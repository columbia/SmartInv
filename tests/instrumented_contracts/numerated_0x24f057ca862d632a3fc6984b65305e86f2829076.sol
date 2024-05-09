1 /**
2  *
3 */
4 
5 /**
6 
7 This is for the halloween culture
8 Initial LP burned
9 0/0
10 trick or treat
11 Make the most of this Gem
12 
13 */
14 
15 //SPDX-License-Identifier: UNLICENSED
16 pragma solidity ^0.8.4;
17  
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23  
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26  
27     function balanceOf(address account) external view returns (uint256);
28  
29     function transfer(address recipient, uint256 amount) external returns (bool);
30  
31     function allowance(address owner, address spender) external view returns (uint256);
32  
33     function approve(address spender, uint256 amount) external returns (bool);
34  
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40  
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48  
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56  
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62  
63     function owner() public view returns (address) {
64         return _owner;
65     }
66  
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71  
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76  
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82  
83 }
84  
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91  
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95  
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105  
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114  
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118  
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129  
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135  
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144  
145     function factory() external pure returns (address);
146  
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
166 contract TOT is Context, IERC20, Ownable {
167  
168     using SafeMath for uint256;
169  
170     string private constant _name = "trick or treat";
171     string private constant _symbol = "TOT";
172     uint8 private constant _decimals = 9;
173  
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 1000000000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 public launchBlock;
183  
184     //Buy Fee
185     uint256 private _redisFeeOnBuy = 0;
186     uint256 private _taxFeeOnBuy = 0;
187  
188     //Sell Fee
189     uint256 private _redisFeeOnSell = 0;
190     uint256 private _taxFeeOnSell = 0;
191  
192     //Original Fee
193     uint256 private _redisFee = _redisFeeOnSell;
194     uint256 private _taxFee = _taxFeeOnSell;
195  
196     uint256 private _previousredisFee = _redisFee;
197     uint256 private _previoustaxFee = _taxFee;
198  
199     mapping(address => bool) public bots;
200     mapping(address => uint256) private cooldown;
201  
202     address payable private _developmentAddress = payable(0xE085EE8e750530C1F3AE22C9D28b89c12d1004ab);
203     address payable private _marketingAddress = payable(0xE085EE8e750530C1F3AE22C9D28b89c12d1004ab);
204  
205     IUniswapV2Router02 public uniswapV2Router;
206     address public uniswapV2Pair;
207  
208     bool private tradingOpen;
209     bool private inSwap = false;
210     bool private swapEnabled = true;
211  
212     uint256 public _maxTxAmount = 20000000000 * 10**9; 
213     uint256 public _maxWalletSize = 20000000000 * 10**9; 
214     uint256 public _swapTokensAtAmount = 10000000 * 10**9; 
215  
216     event MaxTxAmountUpdated(uint256 _maxTxAmount);
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222  
223     constructor() {
224  
225         _rOwned[_msgSender()] = _rTotal;
226  
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231  
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[_developmentAddress] = true;
235         _isExcludedFromFee[_marketingAddress] = true;
236 
237         emit Transfer(address(0), _msgSender(), _tTotal);
238     }
239  
240     function name() public pure returns (string memory) {
241         return _name;
242     }
243  
244     function symbol() public pure returns (string memory) {
245         return _symbol;
246     }
247  
248     function decimals() public pure returns (uint8) {
249         return _decimals;
250     }
251  
252     function totalSupply() public pure override returns (uint256) {
253         return _tTotal;
254     }
255  
256     function balanceOf(address account) public view override returns (uint256) {
257         return tokenFromReflection(_rOwned[account]);
258     }
259  
260     function transfer(address recipient, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268  
269     function allowance(address owner, address spender)
270         public
271         view
272         override
273         returns (uint256)
274     {
275         return _allowances[owner][spender];
276     }
277  
278     function approve(address spender, uint256 amount)
279         public
280         override
281         returns (bool)
282     {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286  
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public override returns (bool) {
292         _transfer(sender, recipient, amount);
293         _approve(
294             sender,
295             _msgSender(),
296             _allowances[sender][_msgSender()].sub(
297                 amount,
298                 "ERC20: transfer amount exceeds allowance"
299             )
300         );
301         return true;
302     }
303  
304     function tokenFromReflection(uint256 rAmount)
305         private
306         view
307         returns (uint256)
308     {
309         require(
310             rAmount <= _rTotal,
311             "Amount must be less than total reflections"
312         );
313         uint256 currentRate = _getRate();
314         return rAmount.div(currentRate);
315     }
316  
317     function removeAllFee() private {
318         if (_redisFee == 0 && _taxFee == 0) return;
319  
320         _previousredisFee = _redisFee;
321         _previoustaxFee = _taxFee;
322  
323         _redisFee = 0;
324         _taxFee = 0;
325     }
326  
327     function restoreAllFee() private {
328         _redisFee = _previousredisFee;
329         _taxFee = _previoustaxFee;
330     }
331  
332     function _approve(
333         address owner,
334         address spender,
335         uint256 amount
336     ) private {
337         require(owner != address(0), "ERC20: approve from the zero address");
338         require(spender != address(0), "ERC20: approve to the zero address");
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342  
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) private {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "Transfer amount must be greater than zero");
351  
352         if (from != owner() && to != owner()) {
353  
354             //Trade start check
355             if (!tradingOpen) {
356                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
357             }
358  
359             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
360             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
361  
362             if(to != uniswapV2Pair) {
363                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
364             }
365  
366             uint256 contractTokenBalance = balanceOf(address(this));
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368  
369             if(contractTokenBalance >= _maxTxAmount)
370             {
371                 contractTokenBalance = _maxTxAmount;
372             }
373  
374             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
375                 swapTokensForEth(contractTokenBalance);
376                 uint256 contractETHBalance = address(this).balance;
377                 if (contractETHBalance > 0) {
378                     sendETHToFee(address(this).balance);
379                 }
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
393                 _taxFee = _taxFeeOnBuy;
394             }
395  
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _redisFee = _redisFeeOnSell;
399                 _taxFee = _taxFeeOnSell;
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
421     function sendETHToFee(uint256 amount) private {
422         _developmentAddress.transfer(amount.mul(50).div(100));
423         _marketingAddress.transfer(amount.mul(50).div(100));
424     }
425  
426     function setTrading(bool _tradingOpen) public onlyOwner {
427         tradingOpen = _tradingOpen;
428     }
429  
430     function manualswap() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435  
436     function manualsend() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractETHBalance = address(this).balance;
439         sendETHToFee(contractETHBalance);
440     }
441  
442     function blockBots(address[] memory bots_) public onlyOwner {
443         for (uint256 i = 0; i < bots_.length; i++) {
444             bots[bots_[i]] = true;
445         }
446     }
447  
448     function unblockBot(address notbot) public onlyOwner {
449         bots[notbot] = false;
450     }
451  
452     function _tokenTransfer(
453         address sender,
454         address recipient,
455         uint256 amount,
456         bool takeFee
457     ) private {
458         if (!takeFee) removeAllFee();
459         _transferStandard(sender, recipient, amount);
460         if (!takeFee) restoreAllFee();
461     }
462  
463     function _transferStandard(
464         address sender,
465         address recipient,
466         uint256 tAmount
467     ) private {
468         (
469             uint256 rAmount,
470             uint256 rTransferAmount,
471             uint256 rFee,
472             uint256 tTransferAmount,
473             uint256 tFee,
474             uint256 tTeam
475         ) = _getValues(tAmount);
476         _rOwned[sender] = _rOwned[sender].sub(rAmount);
477         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
478         _takeTeam(tTeam);
479         _reflectFee(rFee, tFee);
480         emit Transfer(sender, recipient, tTransferAmount);
481     }
482  
483     function _takeTeam(uint256 tTeam) private {
484         uint256 currentRate = _getRate();
485         uint256 rTeam = tTeam.mul(currentRate);
486         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
487     }
488  
489     function _reflectFee(uint256 rFee, uint256 tFee) private {
490         _rTotal = _rTotal.sub(rFee);
491         _tFeeTotal = _tFeeTotal.add(tFee);
492     }
493  
494     receive() external payable {}
495  
496     function _getValues(uint256 tAmount)
497         private
498         view
499         returns (
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
509             _getTValues(tAmount, _redisFee, _taxFee);
510         uint256 currentRate = _getRate();
511         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
512             _getRValues(tAmount, tFee, tTeam, currentRate);
513  
514         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
515     }
516  
517     function _getTValues(
518         uint256 tAmount,
519         uint256 redisFee,
520         uint256 taxFee
521     )
522         private
523         pure
524         returns (
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         uint256 tFee = tAmount.mul(redisFee).div(100);
531         uint256 tTeam = tAmount.mul(taxFee).div(100);
532         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
533  
534         return (tTransferAmount, tFee, tTeam);
535     }
536  
537     function _getRValues(
538         uint256 tAmount,
539         uint256 tFee,
540         uint256 tTeam,
541         uint256 currentRate
542     )
543         private
544         pure
545         returns (
546             uint256,
547             uint256,
548             uint256
549         )
550     {
551         uint256 rAmount = tAmount.mul(currentRate);
552         uint256 rFee = tFee.mul(currentRate);
553         uint256 rTeam = tTeam.mul(currentRate);
554         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
555  
556         return (rAmount, rTransferAmount, rFee);
557     }
558  
559     function _getRate() private view returns (uint256) {
560         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
561  
562         return rSupply.div(tSupply);
563     }
564  
565     function _getCurrentSupply() private view returns (uint256, uint256) {
566         uint256 rSupply = _rTotal;
567         uint256 tSupply = _tTotal;
568         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
569  
570         return (rSupply, tSupply);
571     }
572  
573     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
574         _redisFeeOnBuy = redisFeeOnBuy;
575         _redisFeeOnSell = redisFeeOnSell;
576  
577         _taxFeeOnBuy = taxFeeOnBuy;
578         _taxFeeOnSell = taxFeeOnSell;
579     }
580  
581     //Set minimum tokens required to swap.
582     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
583         _swapTokensAtAmount = swapTokensAtAmount;
584     }
585  
586     //Set minimum tokens required to swap.
587     function toggleSwap(bool _swapEnabled) public onlyOwner {
588         swapEnabled = _swapEnabled;
589     }
590  
591  
592     //Set maximum transaction
593     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
594         _maxTxAmount = maxTxAmount;
595     }
596  
597     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
598         _maxWalletSize = maxWalletSize;
599     }
600  
601     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
602         for(uint256 i = 0; i < accounts.length; i++) {
603             _isExcludedFromFee[accounts[i]] = excluded;
604         }
605     }
606 }