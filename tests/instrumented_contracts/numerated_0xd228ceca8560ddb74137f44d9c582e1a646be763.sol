1 /**
2 
3 https://t.me/telebridge
4 
5 */ 
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.9;
9 
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16  
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19  
20     function balanceOf(address account) external view returns (uint256);
21  
22     function transfer(address recipient, uint256 amount) external returns (bool);
23  
24     function allowance(address owner, address spender) external view returns (uint256);
25  
26     function approve(address spender, uint256 amount) external returns (bool);
27  
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33  
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41  
42 contract Ownable is Context {
43     address internal _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49  
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55  
56     function owner() public view returns (address) {
57         return _owner;
58     }
59  
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64  
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69  
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75  
76 }
77 
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84  
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88  
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98  
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107  
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111  
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122  
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128  
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137  
138     function factory() external pure returns (address);
139  
140     function WETH() external pure returns (address);
141  
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158  
159 contract TeleBridge  is Context, IERC20, Ownable {
160  
161     using SafeMath for uint256;
162  
163     string private constant _name = "TeleBridge";
164     string private constant _symbol = "TB";
165     uint8 private constant _decimals = 9;
166  
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     mapping(address => bool) private _isExcludedFromMax;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 100000000 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _redisFeeOnBuy = 0;  
177     uint256 private _taxFeeOnBuy = 25;  
178     uint256 private _redisFeeOnSell = 0;  
179     uint256 private _taxFeeOnSell = 50;
180  
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
188     address payable private _developmentAddress = payable(0x243598912f4Fe73B63324909e1B980941836d438); 
189     address payable private _marketingAddress = payable(0x00Ee4E58d32Afb09Ad8882078443ADD4E1D9029F);
190  
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193  
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197  
198     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
199     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
200     uint256 public _swapTokensAtAmount = _tTotal.mul(5).div(1000);
201  
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208  
209     constructor() {
210  
211         _rOwned[_msgSender()] = _rTotal;
212  
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217  
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222         _isExcludedFromMax[owner()] = true;
223         _isExcludedFromMax[address(this)] = true;
224         _isExcludedFromMax[_developmentAddress] = true;
225         _isExcludedFromMax[_marketingAddress] = true;
226  
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229  
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233  
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237  
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241  
242     function totalSupply() public pure override returns (uint256) {
243         return _tTotal;
244     }
245  
246     function balanceOf(address account) public view override returns (uint256) {
247         return tokenFromReflection(_rOwned[account]);
248     }
249  
250     function transfer(address recipient, uint256 amount)
251         public
252         override
253         returns (bool)
254     {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258  
259     function allowance(address owner, address spender)
260         public
261         view
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267  
268     function approve(address spender, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276  
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) public override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(
284             sender,
285             _msgSender(),
286             _allowances[sender][_msgSender()].sub(
287                 amount,
288                 "ERC20: transfer amount exceeds allowance"
289             )
290         );
291         return true;
292     }
293  
294     function tokenFromReflection(uint256 rAmount)
295         private
296         view
297         returns (uint256)
298     {
299         require(
300             rAmount <= _rTotal,
301             "Amount must be less than total reflections"
302         );
303         uint256 currentRate = _getRate();
304         return rAmount.div(currentRate);
305     }
306  
307     function removeAllFee() private {
308         if (_redisFee == 0 && _taxFee == 0) return;
309  
310         _previousredisFee = _redisFee;
311         _previoustaxFee = _taxFee;
312  
313         _redisFee = 0;
314         _taxFee = 0;
315     }
316  
317     function restoreAllFee() private {
318         _redisFee = _previousredisFee;
319         _taxFee = _previoustaxFee;
320     }
321  
322     function _approve(
323         address owner,
324         address spender,
325         uint256 amount
326     ) private {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332  
333     function _transfer(
334         address from,
335         address to,
336         uint256 amount
337     ) private {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         require(amount > 0, "Transfer amount must be greater than zero");
341  
342         if (from != owner() && to != owner()) {
343  
344             //Trade start check
345             if (!tradingOpen) {
346                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
347             }
348 
349             if (!_isExcludedFromMax[from]){
350                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
351             }
352             
353             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
354  
355             if(to != uniswapV2Pair && !_isExcludedFromMax[to]) {
356                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
357             }
358  
359             uint256 contractTokenBalance = balanceOf(address(this));
360             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
361  
362             if(contractTokenBalance >= _maxTxAmount)
363             {
364                 contractTokenBalance = _maxTxAmount;
365             }
366  
367             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368                 swapTokensForEth(contractTokenBalance);
369                 uint256 contractETHBalance = address(this).balance;
370                 if (contractETHBalance > 0) {
371                     sendETHToFee(address(this).balance);
372                 }
373             }
374         } 
375  
376         bool takeFee = true;
377  
378         //Transfer Tokens
379         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
380             takeFee = false;
381         } else {
382  
383             //Set Fee for Buys
384             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnBuy;
386                 _taxFee = _taxFeeOnBuy;
387             }
388  
389             //Set Fee for Sells
390             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnSell;
392                 _taxFee = _taxFeeOnSell;
393             }
394  
395         }
396  
397         _tokenTransfer(from, to, amount, takeFee);
398     }
399  
400     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
401         address[] memory path = new address[](2);
402         path[0] = address(this);
403         path[1] = uniswapV2Router.WETH();
404         _approve(address(this), address(uniswapV2Router), tokenAmount);
405         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             tokenAmount,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412     }
413  
414     function sendETHToFee(uint256 amount) private {
415         _marketingAddress.transfer(amount.mul(2).div(3));
416         _developmentAddress.transfer(amount.mul(1).div(3));
417     }
418  
419     function setTrading(bool _tradingOpen) public onlyOwner {
420         tradingOpen = _tradingOpen;
421     }
422  
423     function manualswap() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractBalance = balanceOf(address(this));
426         swapTokensForEth(contractBalance);
427     }
428  
429     function manualsend() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractETHBalance = address(this).balance;
432         sendETHToFee(contractETHBalance);
433     }
434  
435     function blockBots(address[] memory bots_) public onlyOwner {
436         for (uint256 i = 0; i < bots_.length; i++) {
437             bots[bots_[i]] = true;
438         }
439     }
440  
441     function unblockBot(address notbot) public onlyOwner {
442         bots[notbot] = false;
443     }
444  
445     function _tokenTransfer(
446         address sender,
447         address recipient,
448         uint256 amount,
449         bool takeFee
450     ) private {
451         if (!takeFee) removeAllFee();
452         _transferStandard(sender, recipient, amount);
453         if (!takeFee) restoreAllFee();
454     }
455  
456     function _transferStandard(
457         address sender,
458         address recipient,
459         uint256 tAmount
460     ) private {
461         (
462             uint256 rAmount,
463             uint256 rTransferAmount,
464             uint256 rFee,
465             uint256 tTransferAmount,
466             uint256 tFee,
467             uint256 tTeam
468         ) = _getValues(tAmount);
469         _rOwned[sender] = _rOwned[sender].sub(rAmount);
470         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
471         _takeTeam(tTeam);
472         _reflectFee(rFee, tFee);
473         emit Transfer(sender, recipient, tTransferAmount);
474     }
475  
476     function _takeTeam(uint256 tTeam) private {
477         uint256 currentRate = _getRate();
478         uint256 rTeam = tTeam.mul(currentRate);
479         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
480     }
481  
482     function _reflectFee(uint256 rFee, uint256 tFee) private {
483         _rTotal = _rTotal.sub(rFee);
484         _tFeeTotal = _tFeeTotal.add(tFee);
485     }
486  
487     receive() external payable {}
488  
489     function _getValues(uint256 tAmount)
490         private
491         view
492         returns (
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
502             _getTValues(tAmount, _redisFee, _taxFee);
503         uint256 currentRate = _getRate();
504         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
505             _getRValues(tAmount, tFee, tTeam, currentRate);
506         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
507     }
508  
509     function _getTValues(
510         uint256 tAmount,
511         uint256 redisFee,
512         uint256 taxFee
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 tFee = tAmount.mul(redisFee).div(100);
523         uint256 tTeam = tAmount.mul(taxFee).div(100);
524         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
525         return (tTransferAmount, tFee, tTeam);
526     }
527  
528     function _getRValues(
529         uint256 tAmount,
530         uint256 tFee,
531         uint256 tTeam,
532         uint256 currentRate
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rFee = tFee.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
546         return (rAmount, rTransferAmount, rFee);
547     }
548  
549     function _getRate() private view returns (uint256) {
550         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
551         return rSupply.div(tSupply);
552     }
553  
554     function _getCurrentSupply() private view returns (uint256, uint256) {
555         uint256 rSupply = _rTotal;
556         uint256 tSupply = _tTotal;
557         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
558         return (rSupply, tSupply);
559     }
560  
561     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
562         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
563         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
564         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
565         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
566 
567         _redisFeeOnBuy = redisFeeOnBuy;
568         _redisFeeOnSell = redisFeeOnSell;
569         _taxFeeOnBuy = taxFeeOnBuy;
570         _taxFeeOnSell = taxFeeOnSell;
571 
572     }
573  
574     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
575         _swapTokensAtAmount = swapTokensAtAmount;
576     }
577 
578     function exemptedFromMax() public onlyOwner {
579 
580     }
581  
582     function toggleSwap(bool _swapEnabled) public onlyOwner {
583         swapEnabled = _swapEnabled;
584     }
585  
586     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
587         require(amountPercent>0);
588         _maxTxAmount = (_tTotal * amountPercent ) / 100;
589     }
590 
591     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
592         require(amountPercent>0);
593         _maxWalletSize = (_tTotal * amountPercent ) / 100;
594     }
595 
596     function removeLimits() external onlyOwner{
597         _maxTxAmount = _tTotal;
598         _maxWalletSize = _tTotal;
599     }
600  
601     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
602         for(uint256 i = 0; i < accounts.length; i++) {
603             _isExcludedFromFee[accounts[i]] = excluded;
604         }
605     }
606 
607     function excludeMultipleAccountsFromMax(address[] calldata accounts, bool excluded) public onlyOwner {
608         for(uint256 i = 0; i < accounts.length; i++) {
609             _isExcludedFromMax[accounts[i]] = excluded;
610         }
611     }
612 
613 }