1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(address recipient, uint256 amount)
16         external
17         returns (bool);
18 
19     function allowance(address owner, address spender)
20         external
21         view
22         returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(
52         uint256 a,
53         uint256 b,
54         string memory errorMessage
55     ) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(
75         uint256 a,
76         uint256 b,
77         string memory errorMessage
78     ) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     constructor() {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         _transferOwnership(address(0));
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Can only be called by the current owner.
115      */
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(
118             newOwner != address(0),
119             "Ownable: new owner is the zero address"
120         );
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Internal function without access restriction.
127      */
128     function _transferOwnership(address newOwner) internal virtual {
129         address oldOwner = _owner;
130         _owner = newOwner;
131         emit OwnershipTransferred(oldOwner, newOwner);
132     }
133 }
134 
135 interface IUniswapV2Pair {
136     event Approval(
137         address indexed owner,
138         address indexed spender,
139         uint256 value
140     );
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     function name() external pure returns (string memory);
144 
145     function symbol() external pure returns (string memory);
146 
147     function decimals() external pure returns (uint8);
148 
149     function totalSupply() external view returns (uint256);
150 
151     function balanceOf(address owner) external view returns (uint256);
152 
153     function allowance(address owner, address spender)
154         external
155         view
156         returns (uint256);
157 
158     function approve(address spender, uint256 value) external returns (bool);
159 
160     function transfer(address to, uint256 value) external returns (bool);
161 
162     function transferFrom(
163         address from,
164         address to,
165         uint256 value
166     ) external returns (bool);
167 
168     function DOMAIN_SEPARATOR() external view returns (bytes32);
169 
170     function PERMIT_TYPEHASH() external pure returns (bytes32);
171 
172     function nonces(address owner) external view returns (uint256);
173 
174     function permit(
175         address owner,
176         address spender,
177         uint256 value,
178         uint256 deadline,
179         uint8 v,
180         bytes32 r,
181         bytes32 s
182     ) external;
183 
184     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
185     event Burn(
186         address indexed sender,
187         uint256 amount0,
188         uint256 amount1,
189         address indexed to
190     );
191     event Swap(
192         address indexed sender,
193         uint256 amount0In,
194         uint256 amount1In,
195         uint256 amount0Out,
196         uint256 amount1Out,
197         address indexed to
198     );
199     event Sync(uint112 reserve0, uint112 reserve1);
200 
201     function MINIMUM_LIQUIDITY() external pure returns (uint256);
202 
203     function factory() external view returns (address);
204 
205     function token0() external view returns (address);
206 
207     function token1() external view returns (address);
208 
209     function getReserves()
210         external
211         view
212         returns (
213             uint112 reserve0,
214             uint112 reserve1,
215             uint32 blockTimestampLast
216         );
217 
218     function price0CumulativeLast() external view returns (uint256);
219 
220     function price1CumulativeLast() external view returns (uint256);
221 
222     function kLast() external view returns (uint256);
223 
224     function mint(address to) external returns (uint256 liquidity);
225 
226     function burn(address to)
227         external
228         returns (uint256 amount0, uint256 amount1);
229 
230     function swap(
231         uint256 amount0Out,
232         uint256 amount1Out,
233         address to,
234         bytes calldata data
235     ) external;
236 
237     function skim(address to) external;
238 
239     function sync() external;
240 
241     function initialize(address, address) external;
242 }
243 
244 interface IUniswapV2Factory {
245     function createPair(address tokenA, address tokenB)
246         external
247         returns (address pair);
248 }
249 
250 interface IUniswapV2Router02 {
251     function swapExactTokensForETHSupportingFeeOnTransferTokens(
252         uint256 amountIn,
253         uint256 amountOutMin,
254         address[] calldata path,
255         address to,
256         uint256 deadline
257     ) external;
258 
259     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
260         uint256 amountIn,
261         uint256 amountOutMin,
262         address[] calldata path,
263         address to,
264         uint256 deadline
265     ) external;
266 
267     function factory() external pure returns (address);
268 
269     function WETH() external pure returns (address);
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286 
287     function quote(
288         uint256 amountA,
289         uint256 reserveA,
290         uint256 reserveB
291     ) external pure returns (uint256 amountB);
292 
293     function getAmountOut(
294         uint256 amountIn,
295         uint256 reserveIn,
296         uint256 reserveOut
297     ) external pure returns (uint256 amountOut);
298 
299     function getAmountIn(
300         uint256 amountOut,
301         uint256 reserveIn,
302         uint256 reserveOut
303     ) external pure returns (uint256 amountIn);
304 
305     function getAmountsOut(uint256 amountIn, address[] calldata path)
306         external
307         view
308         returns (uint256[] memory amounts);
309 
310     function getAmountsIn(uint256 amountOut, address[] calldata path)
311         external
312         view
313         returns (uint256[] memory amounts);
314 }
315 
316 abstract contract IERC20Extented is IERC20 {
317     function decimals() external view virtual returns (uint8);
318 
319     function name() external view virtual returns (string memory);
320 
321     function symbol() external view virtual returns (string memory);
322 }
323 
324 contract GIGABRAIN is Context, IERC20, IERC20Extented, Ownable {
325     using SafeMath for uint256;
326 
327     string private constant _name = "GIGABRAIN";
328     string private constant _symbol = "GIGA";
329     uint8 private constant _decimals = 18;
330 
331     mapping(address => uint256) private _rOwned;
332     mapping(address => uint256) private _tOwned;
333 
334     mapping(address => mapping(address => uint256)) private _allowances;
335     mapping(address => bool) private _isExcludedFromFee;
336 
337     mapping(address => bool) private _isExcluded;
338     address[] private _excluded;
339     mapping(address => bool) private _isBlackListedBot;
340     // address[] private _blackListedBots;
341 
342     uint256 private constant MAX = ~uint256(0);
343     uint256 private constant _tTotal = 1 * 10**9 * 10**18; // 1 Billion tokens
344     uint256 private _rTotal = (MAX - (MAX % _tTotal));
345     uint256 private _tFeeTotal;
346 
347     uint256 private _botBlocks;
348     uint256 private _firstBlock;
349 
350     // fees wrt to tax percentage
351     uint256 public _rfiFee = 10; // divided by 100
352     uint256 private _previousRfiFee = _rfiFee;
353     uint256 public _lpFee = 10; // divided by 100
354     uint256 private _previousLpFee = _lpFee;
355 
356     mapping(address => bool) private bots;
357     IUniswapV2Router02 private uniswapV2Router;
358     address public uniswapV2Pair;
359     uint256 private _maxTxAmount;
360     uint256 private _maxWalletLimit;
361 
362     bool private tradingOpen = false;
363 
364     event FeesUpdated(uint256 _rfiFee, uint256 _lpFee);
365 
366 
367     constructor() {
368         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
369             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
370         );
371         uniswapV2Router = _uniswapV2Router;
372         _approve(address(this), address(uniswapV2Router), _tTotal);
373         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
374             .createPair(address(this), _uniswapV2Router.WETH());
375         IERC20(uniswapV2Pair).approve(
376             address(uniswapV2Router),
377             type(uint256).max
378         );
379 
380         _rOwned[_msgSender()] = _rTotal;
381 
382         _maxTxAmount = _tTotal.div(100); // 1% of total supply
383         _maxWalletLimit = _tTotal.div(50); // 2% of total supply
384 
385         _isExcludedFromFee[owner()] = true;
386         _isExcludedFromFee[address(this)] = true;
387         emit Transfer(address(0), _msgSender(), _tTotal);
388     }
389 
390     function name() external pure override returns (string memory) {
391         return _name;
392     }
393 
394     function symbol() external pure override returns (string memory) {
395         return _symbol;
396     }
397 
398     function decimals() external pure override returns (uint8) {
399         return _decimals;
400     }
401 
402     function totalSupply() external pure override returns (uint256) {
403         return _tTotal;
404     }
405 
406     function balanceOf(address account) public view override returns (uint256) {
407         if (_isExcluded[account]) return _tOwned[account];
408         return tokenFromReflection(_rOwned[account]);
409     }
410 
411     function isBot(address account) public view returns (bool) {
412         return bots[account];
413     }
414 
415     function transfer(address recipient, uint256 amount)
416         external
417         override
418         returns (bool)
419     {
420         _transfer(_msgSender(), recipient, amount);
421         return true;
422     }
423 
424     function allowance(address owner, address spender)
425         external
426         view
427         override
428         returns (uint256)
429     {
430         return _allowances[owner][spender];
431     }
432 
433     function approve(address spender, uint256 amount)
434         external
435         override
436         returns (bool)
437     {
438         _approve(_msgSender(), spender, amount);
439         return true;
440     }
441 
442     function transferFrom(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) external override returns (bool) {
447         _transfer(sender, recipient, amount);
448         _approve(
449             sender,
450             _msgSender(),
451             _allowances[sender][_msgSender()].sub(
452                 amount,
453                 "ERC20: transfer amount exceeds allowance"
454             )
455         );
456         return true;
457     }
458 
459     function isExcluded(address account) public view returns (bool) {
460         return _isExcluded[account];
461     }
462 
463     function setExcludeFromFee(address account, bool excluded)
464         external
465         onlyOwner
466     {
467         _isExcludedFromFee[account] = excluded;
468     }
469 
470     function updateMaxTxnAmount(uint256 newMaxTxnAmount) external onlyOwner {
471         require( newMaxTxnAmount > 0, "Cant set to zero");
472         require( newMaxTxnAmount <= 1000 , "Invalid input");
473         _maxTxAmount = _tTotal.mul(newMaxTxnAmount).div(1000);
474     }
475 
476     function updateMaxWalletLimit(uint256 newMaxWalletLimit) external onlyOwner {
477         require( newMaxWalletLimit > 0, "Cant set to zero");
478         require( newMaxWalletLimit <= 1000 , "Invalid input");
479         _maxWalletLimit = _tTotal.mul(newMaxWalletLimit).div(1000);
480     }
481 
482 
483     function totalFees() public view returns (uint256) {
484         return _tFeeTotal;
485     }
486 
487     function deliver(uint256 tAmount) public {
488         address sender = _msgSender();
489         require(
490             !_isExcluded[sender],
491             "Excluded addresses cannot call this function"
492         );
493         (uint256 rAmount, , , , , ) = _getValues(tAmount);
494         _rOwned[sender] = _rOwned[sender].sub(rAmount);
495         _rTotal = _rTotal.sub(rAmount);
496         _tFeeTotal = _tFeeTotal.add(tAmount);
497     }
498 
499     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
500         public
501         view
502         returns (uint256)
503     {
504         require(tAmount <= _tTotal, "Amount must be less than supply");
505         if (!deductTransferFee) {
506             (uint256 rAmount, , , , , ) = _getValues(tAmount);
507             return rAmount;
508         } else {
509             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
510             return rTransferAmount;
511         }
512     }
513 
514     function tokenFromReflection(uint256 rAmount)
515         public
516         view
517         returns (uint256)
518     {
519         require(
520             rAmount <= _rTotal,
521             "Amount must be less than total reflections"
522         );
523         uint256 currentRate = _getRate();
524         return rAmount.div(currentRate);
525     }
526 
527     function excludeAccount(address account) external onlyOwner {
528         require(!_isExcluded[account], "Account is already excluded");
529         if (_rOwned[account] > 0) {
530             _tOwned[account] = tokenFromReflection(_rOwned[account]);
531         }
532         _isExcluded[account] = true;
533         _excluded.push(account);
534     }
535 
536     function includeAccount(address account) external onlyOwner {
537         require(_isExcluded[account], "Account is not excluded");
538         for (uint256 i = 0; i < _excluded.length; i++) {
539             if (_excluded[i] == account) {
540                 _excluded[i] = _excluded[_excluded.length - 1];
541                 _rOwned[account] = _tOwned[account].mul(_getRate());
542                 _tOwned[account] = 0;
543                 _isExcluded[account] = false;
544                 _excluded.pop();
545                 break;
546             }
547         }
548     }
549 
550     function removeAllFee() private {
551     if (_lpFee == 0 &&  _rfiFee == 0) return;
552         _previousLpFee = _lpFee;
553         _previousRfiFee = _rfiFee;
554 
555         _lpFee = 0;
556         _rfiFee = 0;
557     }
558 
559     function setBuyFees() private {
560         _lpFee = 0;
561         _rfiFee = 10;
562     }
563 
564     function setSellFees() private {
565         _lpFee = 10;
566         _rfiFee = 0;
567     }
568 
569 
570     function restoreAllFee() private {
571         _lpFee = _previousLpFee;
572         _rfiFee = _previousRfiFee;
573     }
574 
575     function _approve(
576         address owner,
577         address spender,
578         uint256 amount
579     ) private {
580         require(owner != address(0), "ERC20: approve from the zero address");
581         require(spender != address(0), "ERC20: approve to the zero address");
582         _allowances[owner][spender] = amount;
583         emit Approval(owner, spender, amount);
584     }
585 
586     function _transfer(
587         address from,
588         address to,
589         uint256 amount
590     ) private {
591         require(from != address(0), "ERC20: transfer from the zero address");
592         require(to != address(0), "ERC20: transfer to the zero address");
593         require(amount > 0, "Transfer amount must be greater than zero");
594         require(!bots[from] && !bots[to], "Bots not allowed to transfer");  
595 
596 
597         bool takeFee = true;
598 
599         if (
600             from != owner() &&
601             to != owner()
602         ) {
603             require(tradingOpen, "Trading is not open");
604             require(amount <= _maxTxAmount, "Exceeds max transaction amount");
605             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {//buys
606 
607                 if (block.number <= _firstBlock.add(_botBlocks)) {
608                     bots[to] = true;
609                 }
610                 setBuyFees();
611             }
612 
613             if (from != uniswapV2Pair) { //sells, transfers
614 
615                 if(to != uniswapV2Pair) {
616                     require(balanceOf(to) <= _maxWalletLimit, "Wallet limit exceeds");
617                 }
618                 setSellFees();
619             }
620             
621         }
622 
623         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
624             takeFee = false;
625         } 
626 
627         _tokenTransfer(from, to, amount, takeFee);
628     }
629 
630     function openTrading(uint256 botBlocks) external onlyOwner {
631         _firstBlock = block.number;
632         _botBlocks = botBlocks;
633         tradingOpen = true;
634     }
635 
636 
637     function _tokenTransfer(
638         address sender,
639         address recipient,
640         uint256 amount,
641         bool takeFee
642     ) private {
643         if (!takeFee) {
644             removeAllFee();
645         }
646         if (_isExcluded[sender] && !_isExcluded[recipient]) {
647             _transferFromExcluded(sender, recipient, amount);
648         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
649             _transferToExcluded(sender, recipient, amount);
650         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
651             _transferStandard(sender, recipient, amount);
652         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
653             _transferBothExcluded(sender, recipient, amount);
654         } else {
655             _transferStandard(sender, recipient, amount);
656         }
657         if (!takeFee) {
658             restoreAllFee();
659         }
660     }
661 
662     function _transferStandard(
663         address sender,
664         address recipient,
665         uint256 tAmount
666     ) private {
667         (
668             uint256 rAmount,
669             uint256 rTransferAmount,
670             uint256 rFee,
671             uint256 tTransferAmount,
672             uint256 tFee,
673             uint256 tTax
674         ) = _getValues(tAmount);
675         _rOwned[sender] = _rOwned[sender].sub(rAmount);
676         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
677         _takeLP(tTax);
678         _reflectFee(rFee, tFee);
679         emit Transfer(sender, recipient, tTransferAmount);
680         if(tTax > 0) {
681             emit Transfer(sender,uniswapV2Pair, tTax);
682         }
683     }
684 
685     function _transferToExcluded(
686         address sender,
687         address recipient,
688         uint256 tAmount
689     ) private {
690         (
691             uint256 rAmount,
692             uint256 rTransferAmount,
693             uint256 rFee,
694             uint256 tTransferAmount,
695             uint256 tFee,
696             uint256 tTax
697         ) = _getValues(tAmount);
698         _rOwned[sender] = _rOwned[sender].sub(rAmount);
699         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
700         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
701         _takeLP(tTax);
702         _reflectFee(rFee, tFee);
703         emit Transfer(sender, recipient, tTransferAmount);
704         if(tTax > 0) {
705             emit Transfer(sender,uniswapV2Pair, tTax);
706         }
707     }
708 
709     function _transferFromExcluded(
710         address sender,
711         address recipient,
712         uint256 tAmount
713     ) private {
714         (
715             uint256 rAmount,
716             uint256 rTransferAmount,
717             uint256 rFee,
718             uint256 tTransferAmount,
719             uint256 tFee,
720             uint256 tTax
721         ) = _getValues(tAmount);
722         _tOwned[sender] = _tOwned[sender].sub(tAmount);
723         _rOwned[sender] = _rOwned[sender].sub(rAmount);
724         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
725         _takeLP(tTax);
726         _reflectFee(rFee, tFee);
727         emit Transfer(sender, recipient, tTransferAmount);
728         if(tTax > 0) {
729             emit Transfer(sender,uniswapV2Pair, tTax);
730         }
731     }
732 
733     function _transferBothExcluded(
734         address sender,
735         address recipient,
736         uint256 tAmount
737     ) private {
738         (
739             uint256 rAmount,
740             uint256 rTransferAmount,
741             uint256 rFee,
742             uint256 tTransferAmount,
743             uint256 tFee,
744             uint256 tTax
745         ) = _getValues(tAmount);
746         _tOwned[sender] = _tOwned[sender].sub(tAmount);
747         _rOwned[sender] = _rOwned[sender].sub(rAmount);
748         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
749         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
750         _takeLP(tTax);
751         _reflectFee(rFee, tFee);
752         emit Transfer(sender, recipient, tTransferAmount);
753         if(tTax > 0) {
754             emit Transfer(sender,uniswapV2Pair, tTax);
755         }
756         
757     }
758 
759     // sending tax to liquidity pool incentive for liquidity providers
760     function _takeLP(uint256 tTax) private {
761         if(tTax > 0) {
762             uint256 currentRate = _getRate();
763             uint256 rTax = tTax.mul(currentRate);
764             _rOwned[uniswapV2Pair] = _rOwned[uniswapV2Pair].add(rTax);
765             if (_isExcluded[uniswapV2Pair])
766                 _tOwned[uniswapV2Pair] = _tOwned[uniswapV2Pair].add(tTax);  
767         }
768     }
769 
770     function _reflectFee(uint256 rFee, uint256 tFee) private {
771         _rTotal = _rTotal.sub(rFee);
772         _tFeeTotal = _tFeeTotal.add(tFee);
773     }
774 
775     receive() external payable {}
776 
777     function _getValues(uint256 tAmount)
778         private
779         view
780         returns (
781             uint256,
782             uint256,
783             uint256,
784             uint256,
785             uint256,
786             uint256
787         )
788     {
789         uint256 taxFee = _lpFee;
790         (uint256 tTransferAmount, uint256 tRfi, uint256 tTax) = _getTValues(
791             tAmount,
792             _rfiFee,
793             taxFee
794         );
795         uint256 currentRate = _getRate();
796         (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi) = _getRValues(
797             tAmount,
798             tRfi,
799             tTax,
800             currentRate
801         );
802         return (rAmount, rTransferAmount, rRfi, tTransferAmount, tRfi, tTax);
803     }
804 
805     function _getTValues(
806         uint256 tAmount,
807         uint256 rfiFee,
808         uint256 taxFee
809     )
810         private
811         pure
812         returns (
813             uint256,
814             uint256,
815             uint256
816         )
817     {
818         uint256 tRfi = tAmount.mul(rfiFee).div(100);
819         uint256 tTax = tAmount.mul(taxFee).div(100);
820         uint256 tTransferAmount = tAmount.sub(tRfi).sub(tTax);
821         return (tTransferAmount, tRfi, tTax);
822     }
823 
824     function _getRValues(
825         uint256 tAmount,
826         uint256 tRfi,
827         uint256 tTax,
828         uint256 currentRate
829     )
830         private
831         pure
832         returns (
833             uint256,
834             uint256,
835             uint256
836         )
837     {
838         uint256 rAmount = tAmount.mul(currentRate);
839         uint256 rRfi = tRfi.mul(currentRate);
840         uint256 rTax = tTax.mul(currentRate);
841         uint256 rTransferAmount = rAmount.sub(rRfi).sub(rTax);
842         return (rAmount, rTransferAmount, rRfi);
843     }
844 
845     function _getRate() private view returns (uint256) {
846         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
847         return rSupply.div(tSupply);
848     }
849 
850     function _getCurrentSupply() private view returns (uint256, uint256) {
851         uint256 rSupply = _rTotal;
852         uint256 tSupply = _tTotal;
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (
855                 _rOwned[_excluded[i]] > rSupply ||
856                 _tOwned[_excluded[i]] > tSupply
857             ) return (_rTotal, _tTotal);
858             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
859             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
860         }
861         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
862         return (rSupply, tSupply);
863     }
864 
865     function excludeFromFee(address account) public onlyOwner {
866         _isExcludedFromFee[account] = true;
867     }
868 
869     function includeInFee(address account) external onlyOwner {
870         _isExcludedFromFee[account] = false;
871     }
872 
873     function removeBot(address account) external onlyOwner {
874         bots[account] = false;
875     }
876 
877     function addBot(address account) external onlyOwner {
878         bots[account] = true;
879     }
880 
881     function recoverErc20token(address token, uint256 amount) external onlyOwner {
882         IERC20(token).transfer(owner(),amount);
883     }
884 
885     function recoverETH() external onlyOwner {
886         payable(owner()).transfer(address(this).balance);
887     }
888 }