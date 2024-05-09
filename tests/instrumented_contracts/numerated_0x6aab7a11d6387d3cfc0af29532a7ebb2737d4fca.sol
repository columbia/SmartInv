1 /*
2 
3 Tomoe Gozen - Daughter Of The Blade
4 
5 https://www.samuraigozen.com/
6 https://t.me/Tomoe_Gozen
7 https://twitter.com/TomoeGozenERC
8 
9 Brick by brick, day by day we will build something strong with a real foundation. Something that will last!
10 
11 */
12 
13 
14 // SPDX-License-Identifier: UNLICENSE
15 
16 pragma solidity ^0.8.16;
17 
18 abstract contract Context 
19 {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24  
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27  
28     function balanceOf(address account) external view returns (uint256);
29  
30     function transfer(address recipient, uint256 amount) external returns (bool);
31  
32     function allowance(address owner, address spender) external view returns (uint256);
33  
34     function approve(address spender, uint256 amount) external returns (bool);
35  
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41  
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49  
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57  
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63  
64     function owner() public view returns (address) {
65         return _owner;
66     }
67  
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72  
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77  
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83  
84 }
85  
86 library SafeMath {
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92  
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96  
97     function sub(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104         return c;
105     }
106  
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113         return c;
114     }
115  
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return div(a, b, "SafeMath: division by zero");
118     }
119  
120     function div(
121         uint256 a,
122         uint256 b,
123         string memory errorMessage
124     ) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         return c;
128     }
129 }
130  
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB)
133         external
134         returns (address pair);
135 }
136  
137 interface IUniswapV2Router02 {
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint256 amountIn,
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external;
145  
146     function factory() external pure returns (address);
147  
148     function WETH() external pure returns (address);
149  
150     function addLiquidityETH(
151         address token,
152         uint256 amountTokenDesired,
153         uint256 amountTokenMin,
154         uint256 amountETHMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         payable
160         returns (
161             uint256 amountToken,
162             uint256 amountETH,
163             uint256 liquidity
164         );
165 }
166  
167 contract GOZEN is Context, IERC20, Ownable {
168  
169     using SafeMath for uint256;
170  
171     string private constant _name = "TOMOE GOZEN";
172     string private constant _symbol = "GOZEN";
173     uint8 private constant _decimals = 9;
174  
175     mapping(address => uint256) private _rOwned;
176     mapping(address => uint256) private _tOwned;
177     mapping(address => mapping(address => uint256)) private _allowances;
178     mapping(address => bool) private _isExcludedFromFee;
179     uint256 private constant MAX = ~uint256(0);
180     uint256 private constant _tTotal = 1000000000 * 10**9;
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183     uint256 public launchBlock;
184  
185     uint256 private _redisFeeOnBuy = 0;
186     uint256 private _taxFeeOnBuy = 40;
187  
188     uint256 private _redisFeeOnSell = 0;
189     uint256 private _taxFeeOnSell = 40;
190  
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193  
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196  
197     mapping(address => bool) public bots;
198     mapping(address => uint256) private cooldown;
199  
200     address payable private _developmentAddress = payable(0x7834Cf22293e2Fee1d11713fEBF36Fc7Da09365f);
201     address payable private _marketingAddress = payable(0x7834Cf22293e2Fee1d11713fEBF36Fc7Da09365f);
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209  
210     uint256 public _maxTxAmount = _tTotal.mul(8).div(1000); 
211     uint256 public _maxWalletSize = _tTotal.mul(8).div(1000); 
212     uint256 public _swapTokensAtAmount = _tTotal.mul(8).div(1000);
213  
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220  
221     constructor() {
222  
223         _rOwned[_msgSender()] = _rTotal;
224  
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229  
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_developmentAddress] = true;
233         _isExcludedFromFee[_marketingAddress] = true;
234   
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237  
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241  
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245  
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249  
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253  
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257  
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266  
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275  
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284  
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301  
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314  
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317  
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320  
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324  
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329  
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340  
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349  
350         if (from != owner() && to != owner()) {
351  
352             if (!tradingOpen) {
353                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
354             }
355  
356             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
357             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
358  
359             if(to != uniswapV2Pair) {
360                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
361             }
362  
363             uint256 contractTokenBalance = balanceOf(address(this));
364             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
365  
366             if(contractTokenBalance >= _maxTxAmount)
367             {
368                 contractTokenBalance = _maxTxAmount;
369             }
370  
371             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
372                 swapTokensForEth(contractTokenBalance);
373                 uint256 contractETHBalance = address(this).balance;
374                 if (contractETHBalance > 0) {
375                     sendETHToFee(address(this).balance);
376                 }
377             }
378         }
379  
380         bool takeFee = true;
381  
382         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
383             takeFee = false;
384         } else {
385  
386             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnBuy;
388                 _taxFee = _taxFeeOnBuy;
389             }
390  
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnSell;
393                 _taxFee = _taxFeeOnSell;
394             }
395  
396         }
397  
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400  
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414  
415     function sendETHToFee(uint256 amount) private {
416         _developmentAddress.transfer(amount.div(2));
417         _marketingAddress.transfer(amount.div(2));
418     }
419  
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422         launchBlock = block.number;
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
508  
509         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
510     }
511  
512     function _getTValues(
513         uint256 tAmount,
514         uint256 redisFee,
515         uint256 taxFee
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 tFee = tAmount.mul(redisFee).div(100);
526         uint256 tTeam = tAmount.mul(taxFee).div(100);
527         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
528  
529         return (tTransferAmount, tFee, tTeam);
530     }
531  
532     function _getRValues(
533         uint256 tAmount,
534         uint256 tFee,
535         uint256 tTeam,
536         uint256 currentRate
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 rAmount = tAmount.mul(currentRate);
547         uint256 rFee = tFee.mul(currentRate);
548         uint256 rTeam = tTeam.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
550  
551         return (rAmount, rTransferAmount, rFee);
552     }
553  
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556  
557         return rSupply.div(tSupply);
558     }
559  
560     function _getCurrentSupply() private view returns (uint256, uint256) {
561         uint256 rSupply = _rTotal;
562         uint256 tSupply = _tTotal;
563         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
564  
565         return (rSupply, tSupply);
566     }
567  
568     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
569         _redisFeeOnBuy = redisFeeOnBuy;
570         _redisFeeOnSell = redisFeeOnSell;
571         _taxFeeOnBuy = taxFeeOnBuy;
572         _taxFeeOnSell = taxFeeOnSell;
573     }
574  
575     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
576         _swapTokensAtAmount = swapTokensAtAmount;
577     }
578  
579     function toggleSwap(bool _swapEnabled) public onlyOwner {
580         swapEnabled = _swapEnabled;
581     }
582 
583     function removeLimit () external onlyOwner{
584         _maxTxAmount = _tTotal;
585         _maxWalletSize = _tTotal;
586     }
587  
588     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
589         _maxTxAmount = maxTxAmount;
590     }
591  
592     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
593         _maxWalletSize = maxWalletSize;
594     }
595  
596     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
597         for(uint256 i = 0; i < accounts.length; i++) {
598             _isExcludedFromFee[accounts[i]] = excluded;
599         }
600     }
601 }