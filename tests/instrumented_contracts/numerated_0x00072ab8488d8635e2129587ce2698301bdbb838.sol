1 /**
2 *
3 
4 为了文化.
5 
6 */
7 
8 pragma solidity ^0.8.14;
9 // SPDX-License-Identifier: Unlicensed
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157 
158 contract Quantum2 is Context, IERC20, Ownable {
159 
160     using SafeMath for uint256;
161 
162     string private constant _name = "Quantum 2.0";
163     string private constant _symbol = "QNTM 2.0";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 4000000000000 * 10**_decimals;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 4;
176     uint256 private _redisFeeOnSell = 0;
177     uint256 private _taxFeeOnSell = 4;
178 
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182 
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185 
186     mapping(address => bool) public bots; 
187     mapping (address => uint256) public _buyMap;
188     mapping (address => bool) public preTrader;
189     address private developmentAddress;
190     address private marketingAddress;
191     address private devFeeAddress1;
192     address private devFeeAddress2;
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 40000000000 * 10**_decimals;
202     uint256 public _maxWalletSize = 40000000000 * 10**_decimals;
203     uint256 public _swapTokensAtAmount = 100000000 * 10**_decimals;
204 
205     struct Distribution {
206         uint256 development;
207         uint256 marketing;
208         uint256 devFee;
209     }
210 
211     Distribution public distribution;
212 
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219 
220     constructor(address developmentAddr, address marketingAddr, address devFeeAddr1, address devFeeAddr2) {
221         developmentAddress = developmentAddr;
222         marketingAddress = marketingAddr;
223         devFeeAddress1 = devFeeAddr1;
224         devFeeAddress2 = devFeeAddr2;
225         _rOwned[_msgSender()] = _rTotal;
226 
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231 
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[devFeeAddress1] = true;
235         _isExcludedFromFee[devFeeAddress2] = true;
236         _isExcludedFromFee[marketingAddress] = true;
237         _isExcludedFromFee[developmentAddress] = true;
238 
239         distribution = Distribution(37, 38, 25);
240 
241         emit Transfer(address(0), _msgSender(), _tTotal);
242     }
243 
244     function name() public pure returns (string memory) {
245         return _name;
246     }
247 
248     function symbol() public pure returns (string memory) {
249         return _symbol;
250     }
251 
252     function decimals() public pure returns (uint8) {
253         return _decimals;
254     }
255 
256     function totalSupply() public pure override returns (uint256) {
257         return _tTotal;
258     }
259 
260     function balanceOf(address account) public view override returns (uint256) {
261         return tokenFromReflection(_rOwned[account]);
262     }
263 
264     function transfer(address recipient, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     function allowance(address owner, address spender)
274         public
275         view
276         override
277         returns (uint256)
278     {
279         return _allowances[owner][spender];
280     }
281 
282     function approve(address spender, uint256 amount)
283         public
284         override
285         returns (bool)
286     {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290 
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(
298             sender,
299             _msgSender(),
300             _allowances[sender][_msgSender()].sub(
301                 amount,
302                 "ERC20: transfer amount exceeds allowance"
303             )
304         );
305         return true;
306     }
307 
308     function tokenFromReflection(uint256 rAmount)
309         private
310         view
311         returns (uint256)
312     {
313         require(
314             rAmount <= _rTotal,
315             "Amount must be less than total reflections"
316         );
317         uint256 currentRate = _getRate();
318         return rAmount.div(currentRate);
319     }
320 
321     function removeAllFee() private {
322         if (_redisFee == 0 && _taxFee == 0) return;
323 
324         _previousredisFee = _redisFee;
325         _previoustaxFee = _taxFee;
326 
327         _redisFee = 0;
328         _taxFee = 0;
329     }
330 
331     function restoreAllFee() private {
332         _redisFee = _previousredisFee;
333         _taxFee = _previoustaxFee;
334     }
335 
336     function _approve(
337         address owner,
338         address spender,
339         uint256 amount
340     ) private {
341         require(owner != address(0), "ERC20: approve from the zero address");
342         require(spender != address(0), "ERC20: approve to the zero address");
343         _allowances[owner][spender] = amount;
344         emit Approval(owner, spender, amount);
345     }
346 
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) private {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354         require(amount > 0, "Transfer amount must be greater than zero");
355 
356         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
357 
358             //Trade start check
359             if (!tradingOpen) {
360                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
361             }
362 
363             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
364             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
365 
366             if(to != uniswapV2Pair) {
367                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
368             }
369 
370             uint256 contractTokenBalance = balanceOf(address(this));
371             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
372 
373             if(contractTokenBalance >= _maxTxAmount)
374             {
375                 contractTokenBalance = _maxTxAmount;
376             }
377 
378             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
379                 swapTokensForEth(contractTokenBalance);
380                 uint256 contractETHBalance = address(this).balance;
381                 if (contractETHBalance > 0) {
382                     sendETHToFee(address(this).balance);
383                 }
384             }
385         }
386 
387         bool takeFee = true;
388 
389         //Transfer Tokens
390         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
391             takeFee = false;
392         } else {
393 
394             //Set Fee for Buys
395             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnBuy;
397                 _taxFee = _taxFeeOnBuy;
398             }
399 
400             //Set Fee for Sells
401             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
402                 _redisFee = _redisFeeOnSell;
403                 _taxFee = _taxFeeOnSell;
404             }
405 
406         }
407 
408         _tokenTransfer(from, to, amount, takeFee);
409     }
410 
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424 
425     function sendETHToFee(uint256 amount) private lockTheSwap {
426         uint256 distributionEth = amount;
427         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
428         uint256 devFeeShare = distributionEth.mul(distribution.devFee).div(100).div(2);
429         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
430         payable(marketingAddress).transfer(marketingShare);
431         payable(devFeeAddress1).transfer(devFeeShare);
432         payable(devFeeAddress2).transfer(devFeeShare);
433         payable(developmentAddress).transfer(developmentShare);
434     }
435 
436     function setTrading(bool _tradingOpen) public onlyOwner {
437         tradingOpen = _tradingOpen;
438     }
439 
440     function manualswap() external {
441         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress || _msgSender() == devFeeAddress1 || _msgSender() == devFeeAddress2);
442         uint256 contractBalance = balanceOf(address(this));
443         swapTokensForEth(contractBalance);
444     }
445 
446     function manualsend() external {
447         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress || _msgSender() == devFeeAddress1 || _msgSender() == devFeeAddress2);
448         uint256 contractETHBalance = address(this).balance;
449         sendETHToFee(contractETHBalance);
450     }
451 
452     function blockBots(address[] memory bots_) public onlyOwner {
453         for (uint256 i = 0; i < bots_.length; i++) {
454             bots[bots_[i]] = true;
455         }
456     }
457 
458     function unblockBot(address notbot) public onlyOwner {
459         bots[notbot] = false;
460     }
461 
462     function _tokenTransfer(
463         address sender,
464         address recipient,
465         uint256 amount,
466         bool takeFee
467     ) private {
468         if (!takeFee) removeAllFee();
469         _transferStandard(sender, recipient, amount);
470         if (!takeFee) restoreAllFee();
471     }
472 
473     function _transferStandard(
474         address sender,
475         address recipient,
476         uint256 tAmount
477     ) private {
478         (
479             uint256 rAmount,
480             uint256 rTransferAmount,
481             uint256 rFee,
482             uint256 tTransferAmount,
483             uint256 tFee,
484             uint256 tTeam
485         ) = _getValues(tAmount);
486         _rOwned[sender] = _rOwned[sender].sub(rAmount);
487         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
488         _takeTeam(tTeam);
489         _reflectFee(rFee, tFee);
490         emit Transfer(sender, recipient, tTransferAmount);
491     }
492 
493     function setDistribution(uint256 development, uint256 marketing, uint256 devFee) external onlyOwner {        
494         distribution.development = development;
495         distribution.marketing = marketing;
496         distribution.devFee = devFee;
497     }
498 
499     function _takeTeam(uint256 tTeam) private {
500         uint256 currentRate = _getRate();
501         uint256 rTeam = tTeam.mul(currentRate);
502         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
503     }
504 
505     function _reflectFee(uint256 rFee, uint256 tFee) private {
506         _rTotal = _rTotal.sub(rFee);
507         _tFeeTotal = _tFeeTotal.add(tFee);
508     }
509 
510     receive() external payable {
511     }
512 
513     function _getValues(uint256 tAmount)
514         private
515         view
516         returns (
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
526             _getTValues(tAmount, _redisFee, _taxFee);
527         uint256 currentRate = _getRate();
528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
529             _getRValues(tAmount, tFee, tTeam, currentRate);
530         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
531     }
532 
533     function _getTValues(
534         uint256 tAmount,
535         uint256 redisFee,
536         uint256 taxFee
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 tFee = tAmount.mul(redisFee).div(100);
547         uint256 tTeam = tAmount.mul(taxFee).div(100);
548         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
549         return (tTransferAmount, tFee, tTeam);
550     }
551 
552     function _getRValues(
553         uint256 tAmount,
554         uint256 tFee,
555         uint256 tTeam,
556         uint256 currentRate
557     )
558         private
559         pure
560         returns (
561             uint256,
562             uint256,
563             uint256
564         )
565     {
566         uint256 rAmount = tAmount.mul(currentRate);
567         uint256 rFee = tFee.mul(currentRate);
568         uint256 rTeam = tTeam.mul(currentRate);
569         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
570         return (rAmount, rTransferAmount, rFee);
571     }
572 
573     function _getRate() private view returns (uint256) {
574         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
575         return rSupply.div(tSupply);
576     }
577 
578     function _getCurrentSupply() private view returns (uint256, uint256) {
579         uint256 rSupply = _rTotal;
580         uint256 tSupply = _tTotal;
581         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
582         return (rSupply, tSupply);
583     }
584 
585     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
586         _redisFeeOnBuy = redisFeeOnBuy;
587         _redisFeeOnSell = redisFeeOnSell;
588         _taxFeeOnBuy = taxFeeOnBuy;
589         _taxFeeOnSell = taxFeeOnSell;
590     }
591 
592     //Set minimum tokens required to swap.
593     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
594         _swapTokensAtAmount = swapTokensAtAmount;
595     }
596 
597     //Set minimum tokens required to swap.
598     function toggleSwap(bool _swapEnabled) public onlyOwner {
599         swapEnabled = _swapEnabled;
600     }
601 
602     //Set maximum transaction
603     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
604         _maxTxAmount = maxTxAmount;
605     }
606 
607     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
608         _maxWalletSize = maxWalletSize;
609     }
610 
611     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
612         for(uint256 i = 0; i < accounts.length; i++) {
613             _isExcludedFromFee[accounts[i]] = excluded;
614         }
615     }
616 
617     function allowPreTrading(address[] calldata accounts) public onlyOwner {
618         for(uint256 i = 0; i < accounts.length; i++) {
619                  preTrader[accounts[i]] = true;
620         }
621     }
622 
623     function removePreTrading(address[] calldata accounts) public onlyOwner {
624         for(uint256 i = 0; i < accounts.length; i++) {
625                  delete preTrader[accounts[i]];
626         }
627     }
628 }