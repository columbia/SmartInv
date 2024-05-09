1 /*
2 
3 // TOKEN NAME
4 // Half Inch Peter
5 
6 // TOKEN SYMBOL
7 // PETER
8 
9 // WEBSITE
10 // https://half-inch-peter.com
11 
12 // TWITTER
13 // https://twitter.com/Half_Inch_Peter
14 
15 // TELEGRAM
16 // https://t.me/Half_Inch_Peter
17 
18 // THE STORY
19 // Half-Inch Peter focuses on the life of a memeable degenerate crypto trading STUD who is only one half-inch tall.
20 
21 */
22 
23 // SPDX-License-Identifier: Unlicensed
24 pragma solidity ^0.8.16;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function approve(address spender, uint256 amount) external returns (bool);
42 
43     function transferFrom(
44         address sender,
45         address recipient,
46         uint256 amount
47     ) external returns (bool);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(
51         address indexed owner,
52         address indexed spender,
53         uint256 value
54     );
55 }
56 
57 contract Ownable is Context {
58     address private _owner;
59     address private _previousOwner;
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     constructor() {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 
91 }
92 
93 library SafeMath {
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) {
116             return 0;
117         }
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     function div(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         return c;
135     }
136 }
137 
138 interface IUniswapV2Factory {
139     function createPair(address tokenA, address tokenB)
140         external
141         returns (address pair);
142 }
143 
144 interface IUniswapV2Router02 {
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint256 amountIn,
147         uint256 amountOutMin,
148         address[] calldata path,
149         address to,
150         uint256 deadline
151     ) external;
152 
153     function factory() external pure returns (address);
154 
155     function WETH() external pure returns (address);
156 
157     function addLiquidityETH(
158         address token,
159         uint256 amountTokenDesired,
160         uint256 amountTokenMin,
161         uint256 amountETHMin,
162         address to,
163         uint256 deadline
164     )
165         external
166         payable
167         returns (
168             uint256 amountToken,
169             uint256 amountETH,
170             uint256 liquidity
171         );
172 }
173 
174 contract PETER is Context, IERC20, Ownable {
175 
176     using SafeMath for uint256;
177 
178     string private constant _name = "Half Inch Peter";
179     string private constant _symbol = "PETER";
180     uint8 private constant _decimals = 9;
181 
182     mapping(address => uint256) private _rOwned;
183     mapping(address => uint256) private _tOwned;
184     mapping(address => mapping(address => uint256)) private _allowances;
185     mapping(address => bool) private _isExcludedFromFee;
186     uint256 private constant MAX = ~uint256(0);
187     uint256 private constant _tTotal = 1000000000 * 10**9;
188     uint256 private _rTotal = (MAX - (MAX % _tTotal));
189     uint256 private _tFeeTotal;
190     uint256 private _redisFeeOnBuy = 0;
191     uint256 private _taxFeeOnBuy = 18;
192     uint256 private _redisFeeOnSell = 0;
193     uint256 private _taxFeeOnSell = 18;
194 
195     //Original Fee
196     uint256 private _redisFee = _redisFeeOnSell;
197     uint256 private _taxFee = _taxFeeOnSell;
198 
199     uint256 private _previousredisFee = _redisFee;
200     uint256 private _previoustaxFee = _taxFee;
201 
202     mapping(address => bool) public bots; 
203     mapping (address => uint256) public _buyMap;
204     mapping (address => bool) public preTrader;
205     address private developmentAddress;
206     address private marketingAddress;
207 
208     IUniswapV2Router02 public uniswapV2Router;
209     address public uniswapV2Pair;
210 
211     bool private tradingOpen;
212     bool private inSwap = false;
213     bool private swapEnabled = true;
214 
215     uint256 public _maxTxAmount = 20000000 * 10**9;
216     uint256 public _maxWalletSize = 30000000 * 10**9; 
217     uint256 public _swapTokensAtAmount = 10000 * 10**9;
218 
219     struct Distribution {
220         uint256 development;
221         uint256 marketing;
222     }
223 
224     Distribution public distribution;
225 
226     event MaxTxAmountUpdated(uint256 _maxTxAmount);
227     modifier lockTheSwap {
228         inSwap = true;
229         _;
230         inSwap = false;
231     }
232 
233     constructor(address developmentAddr, address marketingAddr) {
234         developmentAddress = developmentAddr;
235         marketingAddress = marketingAddr;
236         _rOwned[_msgSender()] = _rTotal;
237 
238         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
239         uniswapV2Router = _uniswapV2Router;
240         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
241             .createPair(address(this), _uniswapV2Router.WETH());
242 
243         _isExcludedFromFee[owner()] = true;
244         _isExcludedFromFee[address(this)] = true;
245         _isExcludedFromFee[marketingAddress] = true;
246         _isExcludedFromFee[developmentAddress] = true;
247 
248         distribution = Distribution(37, 38);
249 
250         emit Transfer(address(0), _msgSender(), _tTotal);
251     }
252 
253     function name() public pure returns (string memory) {
254         return _name;
255     }
256 
257     function symbol() public pure returns (string memory) {
258         return _symbol;
259     }
260 
261     function decimals() public pure returns (uint8) {
262         return _decimals;
263     }
264 
265     function totalSupply() public pure override returns (uint256) {
266         return _tTotal;
267     }
268 
269     function balanceOf(address account) public view override returns (uint256) {
270         return tokenFromReflection(_rOwned[account]);
271     }
272 
273     function transfer(address recipient, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _transfer(_msgSender(), recipient, amount);
279         return true;
280     }
281 
282     function allowance(address owner, address spender)
283         public
284         view
285         override
286         returns (uint256)
287     {
288         return _allowances[owner][spender];
289     }
290 
291     function approve(address spender, uint256 amount)
292         public
293         override
294         returns (bool)
295     {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(
307             sender,
308             _msgSender(),
309             _allowances[sender][_msgSender()].sub(
310                 amount,
311                 "ERC20: transfer amount exceeds allowance"
312             )
313         );
314         return true;
315     }
316 
317     function tokenFromReflection(uint256 rAmount)
318         private
319         view
320         returns (uint256)
321     {
322         require(
323             rAmount <= _rTotal,
324             "Amount must be less than total reflections"
325         );
326         uint256 currentRate = _getRate();
327         return rAmount.div(currentRate);
328     }
329 
330     function removeAllFee() private {
331         if (_redisFee == 0 && _taxFee == 0) return;
332 
333         _previousredisFee = _redisFee;
334         _previoustaxFee = _taxFee;
335 
336         _redisFee = 0;
337         _taxFee = 0;
338     }
339 
340     function restoreAllFee() private {
341         _redisFee = _previousredisFee;
342         _taxFee = _previoustaxFee;
343     }
344 
345     function _approve(
346         address owner,
347         address spender,
348         uint256 amount
349     ) private {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356     function _transfer(
357         address from,
358         address to,
359         uint256 amount
360     ) private {
361         require(from != address(0), "ERC20: transfer from the zero address");
362         require(to != address(0), "ERC20: transfer to the zero address");
363         require(amount > 0, "Transfer amount must be greater than zero");
364 
365         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
366 
367             //Trade start check
368             if (!tradingOpen) {
369                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
370             }
371 
372             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
373             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
374 
375             if(to != uniswapV2Pair) {
376                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
377             }
378 
379             uint256 contractTokenBalance = balanceOf(address(this));
380             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
381 
382             if(contractTokenBalance >= _maxTxAmount)
383             {
384                 contractTokenBalance = _maxTxAmount;
385             }
386 
387             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
388                 swapTokensForEth(contractTokenBalance);
389                 uint256 contractETHBalance = address(this).balance;
390                 if (contractETHBalance > 0) {
391                     sendETHToFee(address(this).balance);
392                 }
393             }
394         }
395 
396         bool takeFee = true;
397 
398         //Transfer Tokens
399         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
400             takeFee = false;
401         } else {
402 
403             //Set Fee for Buys
404             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
405                 _redisFee = _redisFeeOnBuy;
406                 _taxFee = _taxFeeOnBuy;
407             }
408 
409             //Set Fee for Sells
410             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
411                 _redisFee = _redisFeeOnSell;
412                 _taxFee = _taxFeeOnSell;
413             }
414 
415         }
416 
417         _tokenTransfer(from, to, amount, takeFee);
418     }
419 
420     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
421         address[] memory path = new address[](2);
422         path[0] = address(this);
423         path[1] = uniswapV2Router.WETH();
424         _approve(address(this), address(uniswapV2Router), tokenAmount);
425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
426             tokenAmount,
427             0,
428             path,
429             address(this),
430             block.timestamp
431         );
432     }
433 
434     function sendETHToFee(uint256 amount) private lockTheSwap {
435         uint256 distributionEth = amount;
436         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
437         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
438         payable(marketingAddress).transfer(marketingShare);
439         payable(developmentAddress).transfer(developmentShare);
440     }
441 
442     function setTrading(bool _tradingOpen) public onlyOwner {
443         tradingOpen = _tradingOpen;
444     }
445 
446     function manualswap() external {
447         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
448         uint256 contractBalance = balanceOf(address(this));
449         swapTokensForEth(contractBalance);
450     }
451 
452     function manualsend() external {
453         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
454         uint256 contractETHBalance = address(this).balance;
455         sendETHToFee(contractETHBalance);
456     }
457 
458     function blockBots(address[] memory bots_) public onlyOwner {
459         for (uint256 i = 0; i < bots_.length; i++) {
460             bots[bots_[i]] = true;
461         }
462     }
463 
464     function unblockBot(address notbot) public onlyOwner {
465         bots[notbot] = false;
466     }
467 
468     function _tokenTransfer(
469         address sender,
470         address recipient,
471         uint256 amount,
472         bool takeFee
473     ) private {
474         if (!takeFee) removeAllFee();
475         _transferStandard(sender, recipient, amount);
476         if (!takeFee) restoreAllFee();
477     }
478 
479     function _transferStandard(
480         address sender,
481         address recipient,
482         uint256 tAmount
483     ) private {
484         (
485             uint256 rAmount,
486             uint256 rTransferAmount,
487             uint256 rFee,
488             uint256 tTransferAmount,
489             uint256 tFee,
490             uint256 tTeam
491         ) = _getValues(tAmount);
492         _rOwned[sender] = _rOwned[sender].sub(rAmount);
493         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
494         _takeTeam(tTeam);
495         _reflectFee(rFee, tFee);
496         emit Transfer(sender, recipient, tTransferAmount);
497     }
498 
499     function setDistribution(uint256 development, uint256 marketing) external onlyOwner {        
500         distribution.development = development;
501         distribution.marketing = marketing;
502     }
503 
504     function _takeTeam(uint256 tTeam) private {
505         uint256 currentRate = _getRate();
506         uint256 rTeam = tTeam.mul(currentRate);
507         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
508     }
509 
510     function _reflectFee(uint256 rFee, uint256 tFee) private {
511         _rTotal = _rTotal.sub(rFee);
512         _tFeeTotal = _tFeeTotal.add(tFee);
513     }
514 
515     receive() external payable {
516     }
517 
518     function _getValues(uint256 tAmount)
519         private
520         view
521         returns (
522             uint256,
523             uint256,
524             uint256,
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
531             _getTValues(tAmount, _redisFee, _taxFee);
532         uint256 currentRate = _getRate();
533         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
534             _getRValues(tAmount, tFee, tTeam, currentRate);
535         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
536     }
537 
538     function _getTValues(
539         uint256 tAmount,
540         uint256 redisFee,
541         uint256 taxFee
542     )
543         private
544         pure
545         returns (
546             uint256,
547             uint256,
548             uint256
549         )
550     {
551         uint256 tFee = tAmount.mul(redisFee).div(100);
552         uint256 tTeam = tAmount.mul(taxFee).div(100);
553         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
554         return (tTransferAmount, tFee, tTeam);
555     }
556 
557     function _getRValues(
558         uint256 tAmount,
559         uint256 tFee,
560         uint256 tTeam,
561         uint256 currentRate
562     )
563         private
564         pure
565         returns (
566             uint256,
567             uint256,
568             uint256
569         )
570     {
571         uint256 rAmount = tAmount.mul(currentRate);
572         uint256 rFee = tFee.mul(currentRate);
573         uint256 rTeam = tTeam.mul(currentRate);
574         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
575         return (rAmount, rTransferAmount, rFee);
576     }
577 
578     function _getRate() private view returns (uint256) {
579         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
580         return rSupply.div(tSupply);
581     }
582 
583     function _getCurrentSupply() private view returns (uint256, uint256) {
584         uint256 rSupply = _rTotal;
585         uint256 tSupply = _tTotal;
586         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
587         return (rSupply, tSupply);
588     }
589 
590     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
591         _redisFeeOnBuy = redisFeeOnBuy;
592         _redisFeeOnSell = redisFeeOnSell;
593         _taxFeeOnBuy = taxFeeOnBuy;
594         _taxFeeOnSell = taxFeeOnSell;
595     }
596 
597     //Set minimum tokens required to swap.
598     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
599         _swapTokensAtAmount = swapTokensAtAmount;
600     }
601 
602     //Set minimum tokens required to swap.
603     function toggleSwap(bool _swapEnabled) public onlyOwner {
604         swapEnabled = _swapEnabled;
605     }
606 
607     //Set maximum transaction
608     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
609         _maxTxAmount = maxTxAmount;
610     }
611 
612     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
613         _maxWalletSize = maxWalletSize;
614     }
615 
616     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
617         for(uint256 i = 0; i < accounts.length; i++) {
618             _isExcludedFromFee[accounts[i]] = excluded;
619         }
620     }
621 
622     function allowPreTrading(address[] calldata accounts) public onlyOwner {
623         for(uint256 i = 0; i < accounts.length; i++) {
624                  preTrader[accounts[i]] = true;
625         }
626     }
627 
628     function removePreTrading(address[] calldata accounts) public onlyOwner {
629         for(uint256 i = 0; i < accounts.length; i++) {
630                  delete preTrader[accounts[i]];
631         }
632     }
633 }