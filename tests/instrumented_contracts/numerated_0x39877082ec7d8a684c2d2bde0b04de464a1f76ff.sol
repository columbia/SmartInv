1 /*
2 
3 NVIDIA AI ($NVDA)
4 
5 THE ENERGY SOURCE OF AI
6 
7 For more information, please visit the link below. 
8 
9 t.me/nvidiaerc
10 
11 */
12 
13 
14 // SPDX-License-Identifier: MIT
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
167 contract NVDA is Context, IERC20, Ownable {
168  
169     using SafeMath for uint256;
170  
171     string private constant _name = "NVIDIA AI";
172     string private constant _symbol = "NVDA";
173     uint8 private constant _decimals = 9;
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 10000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 public launchBlock;
183  
184     uint256 private _redisFeeOnBuy = 0;
185     uint256 private _taxFeeOnBuy = 30;
186  
187     uint256 private _redisFeeOnSell = 0;
188     uint256 private _taxFeeOnSell = 65;
189  
190     uint256 private _redisFee = _redisFeeOnSell;
191     uint256 private _taxFee = _taxFeeOnSell;
192  
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195  
196     mapping(address => bool) public bots;
197     mapping(address => uint256) private cooldown;
198  
199     address payable private _developmentAddress = payable(0x514D343c30C4FCc442A60150d33bA8E03d3e8485);
200     address payable private _marketingAddress = payable(0x15Ee78C47a9cFc326827598D68a3A8DC1d0953f3);
201  
202     IUniswapV2Router02 public uniswapV2Router;
203     address public uniswapV2Pair;
204  
205     bool private tradingOpen;
206     bool private inSwap = false;
207     bool private swapEnabled = true;
208  
209     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
210     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000); 
211     uint256 public _swapTokensAtAmount = _tTotal.mul(10).div(1000);
212  
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219  
220     constructor() {
221  
222         _rOwned[_msgSender()] = _rTotal;
223  
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225         uniswapV2Router = _uniswapV2Router;
226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
227             .createPair(address(this), _uniswapV2Router.WETH());
228  
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[_developmentAddress] = true;
232         _isExcludedFromFee[_marketingAddress] = true;
233   
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236  
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240  
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244  
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248  
249     function totalSupply() public pure override returns (uint256) {
250         return _tTotal;
251     }
252  
253     function balanceOf(address account) public view override returns (uint256) {
254         return tokenFromReflection(_rOwned[account]);
255     }
256  
257     function transfer(address recipient, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265  
266     function allowance(address owner, address spender)
267         public
268         view
269         override
270         returns (uint256)
271     {
272         return _allowances[owner][spender];
273     }
274  
275     function approve(address spender, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283  
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(
291             sender,
292             _msgSender(),
293             _allowances[sender][_msgSender()].sub(
294                 amount,
295                 "ERC20: transfer amount exceeds allowance"
296             )
297         );
298         return true;
299     }
300  
301     function tokenFromReflection(uint256 rAmount)
302         private
303         view
304         returns (uint256)
305     {
306         require(
307             rAmount <= _rTotal,
308             "Amount must be less than total reflections"
309         );
310         uint256 currentRate = _getRate();
311         return rAmount.div(currentRate);
312     }
313  
314     function removeAllFee() private {
315         if (_redisFee == 0 && _taxFee == 0) return;
316  
317         _previousredisFee = _redisFee;
318         _previoustaxFee = _taxFee;
319  
320         _redisFee = 0;
321         _taxFee = 0;
322     }
323  
324     function restoreAllFee() private {
325         _redisFee = _previousredisFee;
326         _taxFee = _previoustaxFee;
327     }
328  
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339  
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) private {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348  
349         if (from != owner() && to != owner()) {
350  
351             if (!tradingOpen) {
352                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
353             }
354  
355             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
356             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
357  
358             if(to != uniswapV2Pair) {
359                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
360             }
361  
362             uint256 contractTokenBalance = balanceOf(address(this));
363             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
364  
365             if(contractTokenBalance >= _maxTxAmount)
366             {
367                 contractTokenBalance = _maxTxAmount;
368             }
369  
370             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
371                 swapTokensForEth(contractTokenBalance);
372                 uint256 contractETHBalance = address(this).balance;
373                 if (contractETHBalance > 0) {
374                     sendETHToFee(address(this).balance);
375                 }
376             }
377         }
378  
379         bool takeFee = true;
380  
381         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
382             takeFee = false;
383         } else {
384  
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy;
388             }
389  
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
415         _developmentAddress.transfer(amount.div(2));
416         _marketingAddress.transfer(amount.div(2));
417     }
418  
419     function setTrading(bool _tradingOpen) public onlyOwner {
420         tradingOpen = _tradingOpen;
421         launchBlock = block.number;
422     }
423  
424     function manualswap() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429  
430     function manualsend() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435  
436     function blockBots(address[] memory bots_) public onlyOwner {
437         for (uint256 i = 0; i < bots_.length; i++) {
438             bots[bots_[i]] = true;
439         }
440     }
441  
442     function unblockBot(address notbot) public onlyOwner {
443         bots[notbot] = false;
444     }
445  
446     function _tokenTransfer(
447         address sender,
448         address recipient,
449         uint256 amount,
450         bool takeFee
451     ) private {
452         if (!takeFee) removeAllFee();
453         _transferStandard(sender, recipient, amount);
454         if (!takeFee) restoreAllFee();
455     }
456  
457     function _transferStandard(
458         address sender,
459         address recipient,
460         uint256 tAmount
461     ) private {
462         (
463             uint256 rAmount,
464             uint256 rTransferAmount,
465             uint256 rFee,
466             uint256 tTransferAmount,
467             uint256 tFee,
468             uint256 tTeam
469         ) = _getValues(tAmount);
470         _rOwned[sender] = _rOwned[sender].sub(rAmount);
471         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
472         _takeTeam(tTeam);
473         _reflectFee(rFee, tFee);
474         emit Transfer(sender, recipient, tTransferAmount);
475     }
476  
477     function _takeTeam(uint256 tTeam) private {
478         uint256 currentRate = _getRate();
479         uint256 rTeam = tTeam.mul(currentRate);
480         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
481     }
482  
483     function _reflectFee(uint256 rFee, uint256 tFee) private {
484         _rTotal = _rTotal.sub(rFee);
485         _tFeeTotal = _tFeeTotal.add(tFee);
486     }
487  
488     receive() external payable {}
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
502         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
503             _getTValues(tAmount, _redisFee, _taxFee);
504         uint256 currentRate = _getRate();
505         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
506             _getRValues(tAmount, tFee, tTeam, currentRate);
507  
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
527  
528         return (tTransferAmount, tFee, tTeam);
529     }
530  
531     function _getRValues(
532         uint256 tAmount,
533         uint256 tFee,
534         uint256 tTeam,
535         uint256 currentRate
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 rAmount = tAmount.mul(currentRate);
546         uint256 rFee = tFee.mul(currentRate);
547         uint256 rTeam = tTeam.mul(currentRate);
548         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
549  
550         return (rAmount, rTransferAmount, rFee);
551     }
552  
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555  
556         return rSupply.div(tSupply);
557     }
558  
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563  
564         return (rSupply, tSupply);
565     }
566  
567     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
568         _redisFeeOnBuy = redisFeeOnBuy;
569         _redisFeeOnSell = redisFeeOnSell;
570         _taxFeeOnBuy = taxFeeOnBuy;
571         _taxFeeOnSell = taxFeeOnSell;
572     }
573  
574     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
575         _swapTokensAtAmount = swapTokensAtAmount;
576     }
577  
578     function toggleSwap(bool _swapEnabled) public onlyOwner {
579         swapEnabled = _swapEnabled;
580     }
581 
582     function removeLimit () external onlyOwner{
583         _maxTxAmount = _tTotal;
584         _maxWalletSize = _tTotal;
585     }
586  
587     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
588         _maxTxAmount = maxTxAmount;
589     }
590  
591     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
592         _maxWalletSize = maxWalletSize;
593     }
594  
595     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
596         for(uint256 i = 0; i < accounts.length; i++) {
597             _isExcludedFromFee[accounts[i]] = excluded;
598         }
599     }
600 }