1 /**
2 
3 */
4 
5 /*
6 
7 Razzlekhan Inu (RAZZLE) 
8 
9 Telegram :
10 https://t.me/Razzlekhan
11 
12 Twitter : 
13 https://twitter.com/razzlekhaninu
14 
15 Website: 
16 Www.Razzlekhaninu.com
17 
18 */
19 
20 // SPDX-License-Identifier: MIT
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 contract Ownable is Context {
55     address private _owner;
56     address private _previousOwner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 library SafeMath {
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     }
109 
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         return c;
131     }
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169 
170 contract Razzlekhan is Context, IERC20, Ownable {
171     
172     using SafeMath for uint256;
173 
174     string private constant _name = "Razzlekhan Inu";
175     string private constant _symbol = "RAZZLE";
176     uint8 private constant _decimals = 9;
177 
178     mapping(address => uint256) private _rOwned;
179     mapping(address => mapping(address => uint256)) private _allowances;
180     mapping(address => bool) private _isExcludedFromFee;
181     uint256 private constant MAX = ~uint256(0);
182     uint256 private constant _tTotal = 4600000000 * 10**9;
183     uint256 private _rTotal = (MAX - (MAX % _tTotal));
184     uint256 private _tFeeTotal;
185     
186     //Buy Fee
187     uint256 private _redisFeeOnBuy = 0;
188     uint256 private _marketingFeeOnBuy = 400; //100 = 1%
189     uint256 private _liquidityFeeOnBuy = 100; //100 = 1%
190     
191     //Sell Fee
192     uint256 private _redisFeeOnSell = 0;
193     uint256 private _marketingFeeOnSell = 400; //100 = 1%
194     uint256 private _liquidityFeeOnSell = 100; //100 = 1%
195     
196     //Original Fee
197     uint256 private _redisFee = _redisFeeOnSell;
198     uint256 private _taxFee = _marketingFeeOnSell.add(_liquidityFeeOnSell).div(100);
199     
200     uint256 private _previousredisFee = _redisFee;
201     uint256 private _previoustaxFee = _taxFee;
202     
203     mapping(address => bool) public bots;
204     mapping (address => bool) public preTrader;
205     
206     address payable private _taxWallet1 = payable(0x5341e2194DD52850f9c9eA6628C93161BD0Dbe9c);
207     address payable private _taxWallet2 = payable(0xdf3Caf0036FF9c190F5dACF1D4803C74a02d38a0);
208     
209     IUniswapV2Router02 public uniswapV2Router;
210     address public uniswapV2Pair;
211     
212     bool private tradingOpen;
213     bool private inSwap = false;
214     bool private swapEnabled = true;
215     
216     uint256 public _maxTxAmount = _tTotal.mul(30).div(10000); //0.30%
217     uint256 public _maxWalletSize = _tTotal.mul(50).div(10000); //0.50%
218     uint256 public _swapTokensAtAmount = _tTotal.mul(10).div(10000); //0.1%
219 
220     event MaxTxAmountUpdated(uint256 _maxTxAmount);
221     modifier lockTheSwap {
222         inSwap = true;
223         _;
224         inSwap = false;
225     }
226 
227     constructor() {
228         
229         _rOwned[_msgSender()] = _rTotal;
230         
231         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
232         uniswapV2Router = _uniswapV2Router;
233         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
234             .createPair(address(this), _uniswapV2Router.WETH());
235 
236         _isExcludedFromFee[owner()] = true;
237         _isExcludedFromFee[address(this)] = true;
238         _isExcludedFromFee[_taxWallet1] = true;
239         _isExcludedFromFee[_taxWallet2] = true;
240         
241         preTrader[owner()] = true;
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260 
261     function balanceOf(address account) public view override returns (uint256) {
262         return tokenFromReflection(_rOwned[account]);
263     }
264 
265     function transfer(address recipient, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273 
274     function allowance(address owner, address spender)
275         public
276         view
277         override
278         returns (uint256)
279     {
280         return _allowances[owner][spender];
281     }
282 
283     function approve(address spender, uint256 amount)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308 
309     function tokenFromReflection(uint256 rAmount)
310         private
311         view
312         returns (uint256)
313     {
314         require(
315             rAmount <= _rTotal,
316             "Amount must be less than total reflections"
317         );
318         uint256 currentRate = _getRate();
319         return rAmount.div(currentRate);
320     }
321 
322     function removeAllFee() private {
323         if (_redisFee == 0 && _taxFee == 0) return;
324     
325         _previousredisFee = _redisFee;
326         _previoustaxFee = _taxFee;
327         
328         _redisFee = 0;
329         _taxFee = 0;
330     }
331 
332     function restoreAllFee() private {
333         _redisFee = _previousredisFee;
334         _taxFee = _previoustaxFee;
335     }
336 
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347 
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) private {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356 
357         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
358             
359             //Trade start check
360             if (!tradingOpen) {
361                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
362             }
363               
364             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
365             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
366             
367             if(to != uniswapV2Pair) {
368                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
369             }
370             
371             uint256 contractTokenBalance = balanceOf(address(this));
372             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
373 
374             if(contractTokenBalance >= _maxTxAmount) {
375                 contractTokenBalance = _maxTxAmount;
376             }
377             
378             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
379                 swapDistributeAndLiquify(contractTokenBalance);
380             }
381         }
382         
383         bool takeFee = true;
384 
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389             
390             //Set Fee for Buys
391             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnBuy;
393                 _taxFee = _marketingFeeOnBuy.add(_liquidityFeeOnBuy).div(100);
394             }
395     
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _redisFee = _redisFeeOnSell;
399                 _taxFee = _marketingFeeOnSell.add(_liquidityFeeOnSell).div(100);
400             }
401             
402         }
403 
404         _tokenTransfer(from, to, amount, takeFee);
405     }
406 
407     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = uniswapV2Router.WETH();
411         _approve(address(this), address(uniswapV2Router), tokenAmount);
412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             tokenAmount,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419     }
420     
421     function swapDistributeAndLiquify(uint256 tokens) private {
422 
423         uint256 totalTokensFee = _marketingFeeOnSell.add(_liquidityFeeOnSell);
424         uint256 halfLPFee = _liquidityFeeOnSell.div(2);
425 
426         uint256 tokensToSwapToETH = tokens.mul(_marketingFeeOnSell.add(halfLPFee)).div(totalTokensFee);
427 
428         uint256 liquidityTokens = tokens.mul(halfLPFee).div(totalTokensFee);
429 
430         uint256 initialETHBalance = address(this).balance;
431         swapTokensForEth(tokensToSwapToETH);
432         uint256 newETHBalance = address(this).balance.sub(initialETHBalance);
433 
434         uint256 ethMarketingShare = newETHBalance.mul(_marketingFeeOnSell).div(totalTokensFee.sub(halfLPFee));
435         uint256 ethLPShare = newETHBalance.sub(ethMarketingShare);
436         
437         sendETHToFee(ethMarketingShare);
438         addLiquidity(liquidityTokens, ethLPShare);
439     }
440     
441     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
442 
443         // approve token transfer to cover all possible scenarios
444         _approve(address(this), address(uniswapV2Router), tokenAmount);
445 
446         // add the liquidity
447         uniswapV2Router.addLiquidityETH{value: ethAmount}(
448             address(this),
449             tokenAmount,
450             0, // slippage is unavoidable
451             0, // slippage is unavoidable
452             address(0),
453             block.timestamp
454         );
455     }
456 
457     function sendETHToFee(uint256 amount) private {
458         _taxWallet1.transfer(amount.div(2));
459         _taxWallet2.transfer(amount.div(2));
460     }
461 
462     function setTrading(bool _tradingOpen) public onlyOwner {
463         tradingOpen = _tradingOpen;
464     }
465 
466     function manualswap() external {
467         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
468         uint256 contractBalance = balanceOf(address(this));
469         swapTokensForEth(contractBalance);
470     }
471 
472     function manualsend() external {
473         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
474         uint256 contractETHBalance = address(this).balance;
475         sendETHToFee(contractETHBalance);
476     }
477 
478     function blockBots(address[] memory bots_) public onlyOwner {
479         for (uint256 i = 0; i < bots_.length; i++) {
480             bots[bots_[i]] = true;
481         }
482     }
483 
484     function unblockBot(address notbot) public onlyOwner {
485         bots[notbot] = false;
486     }
487 
488     function _tokenTransfer(
489         address sender,
490         address recipient,
491         uint256 amount,
492         bool takeFee
493     ) private {
494         if (!takeFee) removeAllFee();
495         _transferStandard(sender, recipient, amount);
496         if (!takeFee) restoreAllFee();
497     }
498 
499     function _transferStandard(
500         address sender,
501         address recipient,
502         uint256 tAmount
503     ) private {
504         (
505             uint256 rAmount,
506             uint256 rTransferAmount,
507             uint256 rFee,
508             uint256 tTransferAmount,
509             uint256 tFee,
510             uint256 tTeam
511         ) = _getValues(tAmount);
512         _rOwned[sender] = _rOwned[sender].sub(rAmount);
513         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
514         _takeTeam(tTeam);
515         _reflectFee(rFee, tFee);
516         emit Transfer(sender, recipient, tTransferAmount);
517     }
518 
519     function _takeTeam(uint256 tTeam) private {
520         uint256 currentRate = _getRate();
521         uint256 rTeam = tTeam.mul(currentRate);
522         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
523     }
524 
525     function _reflectFee(uint256 rFee, uint256 tFee) private {
526         _rTotal = _rTotal.sub(rFee);
527         _tFeeTotal = _tFeeTotal.add(tFee);
528     }
529 
530     receive() external payable {}
531 
532     function _getValues(uint256 tAmount)
533         private
534         view
535         returns (
536             uint256,
537             uint256,
538             uint256,
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
545             _getTValues(tAmount, _redisFee, _taxFee);
546         uint256 currentRate = _getRate();
547         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
548             _getRValues(tAmount, tFee, tTeam, currentRate);
549         
550         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
551     }
552 
553     function _getTValues(
554         uint256 tAmount,
555         uint256 redisFee,
556         uint256 taxFee
557     )
558         private
559         pure
560         returns (
561             uint256,
562             uint256,
563             uint256
564         )
565     {
566         uint256 tFee = tAmount.mul(redisFee).div(100);
567         uint256 tTeam = tAmount.mul(taxFee).div(100);
568         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
569 
570         return (tTransferAmount, tFee, tTeam);
571     }
572 
573     function _getRValues(
574         uint256 tAmount,
575         uint256 tFee,
576         uint256 tTeam,
577         uint256 currentRate
578     )
579         private
580         pure
581         returns (
582             uint256,
583             uint256,
584             uint256
585         )
586     {
587         uint256 rAmount = tAmount.mul(currentRate);
588         uint256 rFee = tFee.mul(currentRate);
589         uint256 rTeam = tTeam.mul(currentRate);
590         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
591 
592         return (rAmount, rTransferAmount, rFee);
593     }
594 
595     function _getRate() private view returns (uint256) {
596         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
597 
598         return rSupply.div(tSupply);
599     }
600 
601     function _getCurrentSupply() private view returns (uint256, uint256) {
602         uint256 rSupply = _rTotal;
603         uint256 tSupply = _tTotal;
604         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
605     
606         return (rSupply, tSupply);
607     }
608     
609     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 marketingFeeOnBuy, uint256 marketingFeeOnSell, uint256 liquidityFeeOnBuy, uint256 liquidityFeeOnSell) public onlyOwner {
610         _redisFeeOnBuy = redisFeeOnBuy;
611         _redisFeeOnSell = redisFeeOnSell;
612         
613         _marketingFeeOnBuy = marketingFeeOnBuy;
614         _marketingFeeOnSell = marketingFeeOnSell;
615         
616         _liquidityFeeOnBuy = liquidityFeeOnBuy;
617         _liquidityFeeOnSell = liquidityFeeOnSell;
618     
619     }
620     
621     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
622         for(uint256 i = 0; i < accounts.length; i++) {
623             _isExcludedFromFee[accounts[i]] = excluded;
624         }
625     }
626 
627     //Set minimum tokens required to swap.
628     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
629         _swapTokensAtAmount = swapTokensAtAmount;
630     }
631 
632     //Set marketing tax wallet
633     function setTaxWallet(address payable taxWallet1, address payable taxWallet2) public onlyOwner {
634         _taxWallet1 = taxWallet1;
635         _taxWallet2 = taxWallet2;
636     }
637     
638     //Set minimum tokens required to swap.
639     function toggleSwap(bool _swapEnabled) public onlyOwner {
640         swapEnabled = _swapEnabled;
641     }
642     
643     //Set MAx transaction
644     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
645         _maxTxAmount = maxTxAmount;
646     }
647     
648     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
649         _maxWalletSize = maxWalletSize;
650     }
651  
652     function allowPreTrading(address account, bool allowed) public onlyOwner {
653         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
654         preTrader[account] = allowed;
655     }
656 }