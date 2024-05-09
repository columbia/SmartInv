1 /*
2 
3 https://t.me/bumblecerc
4 
5 https://twitter.com/bumbleceth
6 
7 */ 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.9;
11 
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18  
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21  
22     function balanceOf(address account) external view returns (uint256);
23  
24     function transfer(address recipient, uint256 amount) external returns (bool);
25  
26     function allowance(address owner, address spender) external view returns (uint256);
27  
28     function approve(address spender, uint256 amount) external returns (bool);
29  
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43  
44 contract Ownable is Context {
45     address internal _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51  
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57  
58     function owner() public view returns (address) {
59         return _owner;
60     }
61  
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66  
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71  
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77  
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86  
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90  
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100  
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109  
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113  
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124  
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130  
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139  
140     function factory() external pure returns (address);
141  
142     function WETH() external pure returns (address);
143  
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160  
161 contract BUMBLEC  is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "BUMBLEC";
166     string private constant _symbol = "BUMBLEC";
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     mapping(address => bool) private _isExcludedFromMax;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 100000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 private _redisFeeOnBuy = 0;  
179     uint256 private _taxFeeOnBuy = 10;  
180     uint256 private _redisFeeOnSell = 0;  
181     uint256 private _taxFeeOnSell = 50;
182  
183     uint256 private _redisFee = _redisFeeOnSell;
184     uint256 private _taxFee = _taxFeeOnSell;
185  
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188  
189     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
190     address payable private _developmentAddress = payable(0xb70345BF2bDedD91c9f4e263872Da3Ba9BBdffC1); 
191     address payable private _marketingAddress = payable(0xb70345BF2bDedD91c9f4e263872Da3Ba9BBdffC1);
192  
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195  
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199  
200     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
201     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
202     uint256 public _swapTokensAtAmount = _tTotal.mul(5).div(1000);
203  
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210  
211     constructor() {
212  
213         _rOwned[_msgSender()] = _rTotal;
214  
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219  
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_developmentAddress] = true;
223         _isExcludedFromFee[_marketingAddress] = true;
224         _isExcludedFromMax[owner()] = true;
225         _isExcludedFromMax[address(this)] = true;
226         _isExcludedFromMax[_developmentAddress] = true;
227         _isExcludedFromMax[_marketingAddress] = true;
228  
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231  
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235  
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239  
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243  
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247  
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251  
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260  
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269  
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278  
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295  
296     function tokenFromReflection(uint256 rAmount)
297         private
298         view
299         returns (uint256)
300     {
301         require(
302             rAmount <= _rTotal,
303             "Amount must be less than total reflections"
304         );
305         uint256 currentRate = _getRate();
306         return rAmount.div(currentRate);
307     }
308  
309     function removeAllFee() private {
310         if (_redisFee == 0 && _taxFee == 0) return;
311  
312         _previousredisFee = _redisFee;
313         _previoustaxFee = _taxFee;
314  
315         _redisFee = 0;
316         _taxFee = 0;
317     }
318  
319     function restoreAllFee() private {
320         _redisFee = _previousredisFee;
321         _taxFee = _previoustaxFee;
322     }
323  
324     function _approve(
325         address owner,
326         address spender,
327         uint256 amount
328     ) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334  
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) private {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343  
344         if (from != owner() && to != owner()) {
345  
346             //Trade start check
347             if (!tradingOpen) {
348                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
349             }
350 
351             if (!_isExcludedFromMax[from]){
352                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
353             }
354             
355             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
356  
357             if(to != uniswapV2Pair && !_isExcludedFromMax[to]) {
358                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
359             }
360  
361             uint256 contractTokenBalance = balanceOf(address(this));
362             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
363  
364             if(contractTokenBalance >= _maxTxAmount)
365             {
366                 contractTokenBalance = _maxTxAmount;
367             }
368  
369             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
370                 swapTokensForEth(contractTokenBalance);
371                 uint256 contractETHBalance = address(this).balance;
372                 if (contractETHBalance > 0) {
373                     sendETHToFee(address(this).balance);
374                 }
375             }
376         } 
377  
378         bool takeFee = true;
379  
380         //Transfer Tokens
381         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
382             takeFee = false;
383         } else {
384  
385             //Set Fee for Buys
386             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnBuy;
388                 _taxFee = _taxFeeOnBuy;
389             }
390  
391             //Set Fee for Sells
392             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnSell;
394                 _taxFee = _taxFeeOnSell;
395             }
396  
397         }
398  
399         _tokenTransfer(from, to, amount, takeFee);
400     }
401  
402     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = uniswapV2Router.WETH();
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             tokenAmount,
409             0,
410             path,
411             address(this),
412             block.timestamp
413         );
414     }
415  
416     function sendETHToFee(uint256 amount) private {
417         _marketingAddress.transfer(amount.mul(4).div(5));
418         _developmentAddress.transfer(amount.mul(1).div(5));
419     }
420  
421     function setTrading(bool _tradingOpen) public onlyOwner {
422         tradingOpen = _tradingOpen;
423     }
424  
425     function manualswap() external {
426         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
427         uint256 contractBalance = balanceOf(address(this));
428         swapTokensForEth(contractBalance);
429     }
430  
431     function manualsend() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractETHBalance = address(this).balance;
434         sendETHToFee(contractETHBalance);
435     }
436  
437     function blockBots(address[] memory bots_) public onlyOwner {
438         for (uint256 i = 0; i < bots_.length; i++) {
439             bots[bots_[i]] = true;
440         }
441     }
442  
443     function unblockBot(address notbot) public onlyOwner {
444         bots[notbot] = false;
445     }
446  
447     function _tokenTransfer(
448         address sender,
449         address recipient,
450         uint256 amount,
451         bool takeFee
452     ) private {
453         if (!takeFee) removeAllFee();
454         _transferStandard(sender, recipient, amount);
455         if (!takeFee) restoreAllFee();
456     }
457  
458     function _transferStandard(
459         address sender,
460         address recipient,
461         uint256 tAmount
462     ) private {
463         (
464             uint256 rAmount,
465             uint256 rTransferAmount,
466             uint256 rFee,
467             uint256 tTransferAmount,
468             uint256 tFee,
469             uint256 tTeam
470         ) = _getValues(tAmount);
471         _rOwned[sender] = _rOwned[sender].sub(rAmount);
472         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
473         _takeTeam(tTeam);
474         _reflectFee(rFee, tFee);
475         emit Transfer(sender, recipient, tTransferAmount);
476     }
477  
478     function _takeTeam(uint256 tTeam) private {
479         uint256 currentRate = _getRate();
480         uint256 rTeam = tTeam.mul(currentRate);
481         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
482     }
483  
484     function _reflectFee(uint256 rFee, uint256 tFee) private {
485         _rTotal = _rTotal.sub(rFee);
486         _tFeeTotal = _tFeeTotal.add(tFee);
487     }
488  
489     receive() external payable {}
490  
491     function _getValues(uint256 tAmount)
492         private
493         view
494         returns (
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
504             _getTValues(tAmount, _redisFee, _taxFee);
505         uint256 currentRate = _getRate();
506         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
507             _getRValues(tAmount, tFee, tTeam, currentRate);
508         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
509     }
510  
511     function _getTValues(
512         uint256 tAmount,
513         uint256 redisFee,
514         uint256 taxFee
515     )
516         private
517         pure
518         returns (
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         uint256 tFee = tAmount.mul(redisFee).div(100);
525         uint256 tTeam = tAmount.mul(taxFee).div(100);
526         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
527         return (tTransferAmount, tFee, tTeam);
528     }
529  
530     function _getRValues(
531         uint256 tAmount,
532         uint256 tFee,
533         uint256 tTeam,
534         uint256 currentRate
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 rAmount = tAmount.mul(currentRate);
545         uint256 rFee = tFee.mul(currentRate);
546         uint256 rTeam = tTeam.mul(currentRate);
547         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
548         return (rAmount, rTransferAmount, rFee);
549     }
550  
551     function _getRate() private view returns (uint256) {
552         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
553         return rSupply.div(tSupply);
554     }
555  
556     function _getCurrentSupply() private view returns (uint256, uint256) {
557         uint256 rSupply = _rTotal;
558         uint256 tSupply = _tTotal;
559         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
560         return (rSupply, tSupply);
561     }
562  
563     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
564         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
565         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 21, "Buy tax must be between 0% and 21%");
566         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
567         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 21, "Sell tax must be between 0% and 21%");
568 
569         _redisFeeOnBuy = redisFeeOnBuy;
570         _redisFeeOnSell = redisFeeOnSell;
571         _taxFeeOnBuy = taxFeeOnBuy;
572         _taxFeeOnSell = taxFeeOnSell;
573 
574     }
575  
576     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
577         _swapTokensAtAmount = swapTokensAtAmount;
578     }
579 
580     function exemptedFromMax() public onlyOwner {
581 
582     }
583  
584     function toggleSwap(bool _swapEnabled) public onlyOwner {
585         swapEnabled = _swapEnabled;
586     }
587  
588     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
589         require(amountPercent>0);
590         _maxTxAmount = (_tTotal * amountPercent ) / 100;
591     }
592 
593     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
594         require(amountPercent>0);
595         _maxWalletSize = (_tTotal * amountPercent ) / 100;
596     }
597 
598     function removeLimits() external onlyOwner{
599         _maxTxAmount = _tTotal;
600         _maxWalletSize = _tTotal;
601     }
602  
603     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
604         for(uint256 i = 0; i < accounts.length; i++) {
605             _isExcludedFromFee[accounts[i]] = excluded;
606         }
607     }
608 
609     function excludeMultipleAccountsFromMax(address[] calldata accounts, bool excluded) public onlyOwner {
610         for(uint256 i = 0; i < accounts.length; i++) {
611             _isExcludedFromMax[accounts[i]] = excluded;
612         }
613     }
614 
615 }