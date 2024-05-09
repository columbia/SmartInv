1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10  
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13  
14     function balanceOf(address account) external view returns (uint256);
15  
16     function transfer(address recipient, uint256 amount) external returns (bool);
17  
18     function allowance(address owner, address spender) external view returns (uint256);
19  
20     function approve(address spender, uint256 amount) external returns (bool);
21  
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27  
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35  
36 contract Ownable is Context {
37     address internal _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43  
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49  
50     function owner() public view returns (address) {
51         return _owner;
52     }
53  
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58  
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63  
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69  
70 }
71 
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78  
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82  
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92  
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101  
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105  
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116  
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122  
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131  
132     function factory() external pure returns (address);
133  
134     function WETH() external pure returns (address);
135  
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152  
153 contract Wiggle is Context, IERC20, Ownable {
154  
155     using SafeMath for uint256;
156  
157     string private constant _name = "WIGGLE";
158     string private constant _symbol = "WIGGLE";
159     uint8 private constant _decimals = 9;
160  
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 1000000000 * 10**9;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169     uint256 private _redisFeeOnBuy = 1;  
170     uint256 private _taxFeeOnBuy = 9;  
171     uint256 private _redisFeeOnSell = 1;  
172     uint256 private _taxFeeOnSell = 9;
173  
174     uint256 private _redisFee = _redisFeeOnSell;
175     uint256 private _taxFee = _taxFeeOnSell;
176  
177     uint256 private _previousredisFee = _redisFee;
178     uint256 private _previoustaxFee = _taxFee;
179  
180     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
181     address payable private _developmentAddress = payable(0xD2a5EBAc61a6807354CE9Abc749966e1767659De); 
182     address payable private _marketingAddress = payable(0xB11a931f3873F5188d34d1189eb0c62fC1BBECfD);
183  
184     IUniswapV2Router02 public uniswapV2Router;
185     address public uniswapV2Pair;
186  
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = true;
190  
191     uint256 public _maxTxAmount = _tTotal.mul(1).div(100);
192     uint256 public _maxWalletSize = _tTotal.mul(1).div(100); 
193     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
194  
195     event MaxTxAmountUpdated(uint256 _maxTxAmount);
196     modifier lockTheSwap {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201  
202     constructor() {
203  
204         _rOwned[_msgSender()] = _rTotal;
205  
206         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
207         uniswapV2Router = _uniswapV2Router;
208         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
209             .createPair(address(this), _uniswapV2Router.WETH());
210  
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[address(this)] = true;
213         _isExcludedFromFee[_developmentAddress] = true;
214         _isExcludedFromFee[_marketingAddress] = true;
215  
216         emit Transfer(address(0), _msgSender(), _tTotal);
217     }
218  
219     function name() public pure returns (string memory) {
220         return _name;
221     }
222  
223     function symbol() public pure returns (string memory) {
224         return _symbol;
225     }
226  
227     function decimals() public pure returns (uint8) {
228         return _decimals;
229     }
230  
231     function totalSupply() public pure override returns (uint256) {
232         return _tTotal;
233     }
234  
235     function balanceOf(address account) public view override returns (uint256) {
236         return tokenFromReflection(_rOwned[account]);
237     }
238  
239     function transfer(address recipient, uint256 amount)
240         public
241         override
242         returns (bool)
243     {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247  
248     function allowance(address owner, address spender)
249         public
250         view
251         override
252         returns (uint256)
253     {
254         return _allowances[owner][spender];
255     }
256  
257     function approve(address spender, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265  
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) public override returns (bool) {
271         _transfer(sender, recipient, amount);
272         _approve(
273             sender,
274             _msgSender(),
275             _allowances[sender][_msgSender()].sub(
276                 amount,
277                 "ERC20: transfer amount exceeds allowance"
278             )
279         );
280         return true;
281     }
282  
283     function tokenFromReflection(uint256 rAmount)
284         private
285         view
286         returns (uint256)
287     {
288         require(
289             rAmount <= _rTotal,
290             "Amount must be less than total reflections"
291         );
292         uint256 currentRate = _getRate();
293         return rAmount.div(currentRate);
294     }
295  
296     function removeAllFee() private {
297         if (_redisFee == 0 && _taxFee == 0) return;
298  
299         _previousredisFee = _redisFee;
300         _previoustaxFee = _taxFee;
301  
302         _redisFee = 0;
303         _taxFee = 0;
304     }
305  
306     function restoreAllFee() private {
307         _redisFee = _previousredisFee;
308         _taxFee = _previoustaxFee;
309     }
310  
311     function _approve(
312         address owner,
313         address spender,
314         uint256 amount
315     ) private {
316         require(owner != address(0), "ERC20: approve from the zero address");
317         require(spender != address(0), "ERC20: approve to the zero address");
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321  
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) private {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329         require(amount > 0, "Transfer amount must be greater than zero");
330  
331         if (from != owner() && to != owner()) {
332  
333             //Trade start check
334             if (!tradingOpen) {
335                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
336             }
337  
338             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
339             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
340  
341             if(to != uniswapV2Pair) {
342                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
343             }
344  
345             uint256 contractTokenBalance = balanceOf(address(this));
346             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
347  
348             if(contractTokenBalance >= _maxTxAmount)
349             {
350                 contractTokenBalance = _maxTxAmount;
351             }
352  
353             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
354                 swapTokensForEth(contractTokenBalance);
355                 uint256 contractETHBalance = address(this).balance;
356                 if (contractETHBalance > 0) {
357                     sendETHToFee(address(this).balance);
358                 }
359             }
360         }
361  
362         bool takeFee = true;
363  
364         //Transfer Tokens
365         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
366             takeFee = false;
367         } else {
368  
369             //Set Fee for Buys
370             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
371                 _redisFee = _redisFeeOnBuy;
372                 _taxFee = _taxFeeOnBuy;
373             }
374  
375             //Set Fee for Sells
376             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnSell;
378                 _taxFee = _taxFeeOnSell;
379             }
380  
381         }
382  
383         _tokenTransfer(from, to, amount, takeFee);
384     }
385  
386     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
387         address[] memory path = new address[](2);
388         path[0] = address(this);
389         path[1] = uniswapV2Router.WETH();
390         _approve(address(this), address(uniswapV2Router), tokenAmount);
391         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             tokenAmount,
393             0,
394             path,
395             address(this),
396             block.timestamp
397         );
398     }
399  
400     function sendETHToFee(uint256 amount) private {
401         _marketingAddress.transfer(amount.mul(3).div(5));
402         _developmentAddress.transfer(amount.mul(2).div(5));
403     }
404  
405     function setTrading(bool _tradingOpen) public onlyOwner {
406         tradingOpen = _tradingOpen;
407     }
408  
409     function manualswap() external {
410         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414  
415     function manualsend() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420  
421     function blockBots(address[] memory bots_) public onlyOwner {
422         for (uint256 i = 0; i < bots_.length; i++) {
423             bots[bots_[i]] = true;
424         }
425     }
426  
427     function unblockBot(address notbot) public onlyOwner {
428         bots[notbot] = false;
429     }
430  
431     function _tokenTransfer(
432         address sender,
433         address recipient,
434         uint256 amount,
435         bool takeFee
436     ) private {
437         if (!takeFee) removeAllFee();
438         _transferStandard(sender, recipient, amount);
439         if (!takeFee) restoreAllFee();
440     }
441  
442     function _transferStandard(
443         address sender,
444         address recipient,
445         uint256 tAmount
446     ) private {
447         (
448             uint256 rAmount,
449             uint256 rTransferAmount,
450             uint256 rFee,
451             uint256 tTransferAmount,
452             uint256 tFee,
453             uint256 tTeam
454         ) = _getValues(tAmount);
455         _rOwned[sender] = _rOwned[sender].sub(rAmount);
456         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
457         _takeTeam(tTeam);
458         _reflectFee(rFee, tFee);
459         emit Transfer(sender, recipient, tTransferAmount);
460     }
461  
462     function _takeTeam(uint256 tTeam) private {
463         uint256 currentRate = _getRate();
464         uint256 rTeam = tTeam.mul(currentRate);
465         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
466     }
467  
468     function _reflectFee(uint256 rFee, uint256 tFee) private {
469         _rTotal = _rTotal.sub(rFee);
470         _tFeeTotal = _tFeeTotal.add(tFee);
471     }
472  
473     receive() external payable {}
474  
475     function _getValues(uint256 tAmount)
476         private
477         view
478         returns (
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256
485         )
486     {
487         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
488             _getTValues(tAmount, _redisFee, _taxFee);
489         uint256 currentRate = _getRate();
490         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
491             _getRValues(tAmount, tFee, tTeam, currentRate);
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494  
495     function _getTValues(
496         uint256 tAmount,
497         uint256 redisFee,
498         uint256 taxFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(redisFee).div(100);
509         uint256 tTeam = tAmount.mul(taxFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511         return (tTransferAmount, tFee, tTeam);
512     }
513  
514     function _getRValues(
515         uint256 tAmount,
516         uint256 tFee,
517         uint256 tTeam,
518         uint256 currentRate
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 rAmount = tAmount.mul(currentRate);
529         uint256 rFee = tFee.mul(currentRate);
530         uint256 rTeam = tTeam.mul(currentRate);
531         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
532         return (rAmount, rTransferAmount, rFee);
533     }
534  
535     function _getRate() private view returns (uint256) {
536         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
537         return rSupply.div(tSupply);
538     }
539  
540     function _getCurrentSupply() private view returns (uint256, uint256) {
541         uint256 rSupply = _rTotal;
542         uint256 tSupply = _tTotal;
543         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
544         return (rSupply, tSupply);
545     }
546  
547     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
548         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 5, "Buy rewards must be between 0% and 5%");
549         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 15, "Buy tax must be between 0% and 15%");
550         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 5, "Sell rewards must be between 0% and 5%");
551         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 15, "Sell tax must be between 0% and 15%");
552 
553         _redisFeeOnBuy = redisFeeOnBuy;
554         _redisFeeOnSell = redisFeeOnSell;
555         _taxFeeOnBuy = taxFeeOnBuy;
556         _taxFeeOnSell = taxFeeOnSell;
557 
558     }
559  
560     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
561         _swapTokensAtAmount = swapTokensAtAmount;
562     }
563  
564     function toggleSwap(bool _swapEnabled) public onlyOwner {
565         swapEnabled = _swapEnabled;
566     }
567  
568     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
569         require(amountPercent>0);
570         _maxTxAmount = (_tTotal * amountPercent ) / 100;
571     }
572 
573     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
574         require(amountPercent>0);
575         _maxWalletSize = (_tTotal * amountPercent ) / 100;
576     }
577 
578     function removeLimits() external onlyOwner{
579         _maxTxAmount = _tTotal;
580         _maxWalletSize = _tTotal;
581     }
582  
583     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
584         for(uint256 i = 0; i < accounts.length; i++) {
585             _isExcludedFromFee[accounts[i]] = excluded;
586         }
587     }
588 
589 }