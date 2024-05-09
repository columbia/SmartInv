1 /**
2 
3     Total supply : 1 000 000 000 000
4 
5 Max wallet: 2%. 
6 
7 Tax : 7 in and out .
8 
9 1.5% send  to TSUKA deployer .
10 
11 1.5%. Send to DARUMA deployer .
12 
13 4% :  Liquidity ,marketing and development.
14   
15 /**
16 
17  Telegram: https://t.me/tsukaruma_portal
18 
19 Twitter: https://twitter.com/TSUKARUMA
20 */
21 
22 // SPDX-License-Identifier: Unlicensed
23 pragma solidity ^0.8.9;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 }
55 
56 contract Ownable is Context {
57     address private _owner;
58     address private _previousOwner;
59     event OwnershipTransferred(
60         address indexed previousOwner,
61         address indexed newOwner
62     );
63 
64     constructor() {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 
90 }
91 
92 library SafeMath {
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96         return c;
97     }
98 
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         return sub(a, b, "SafeMath: subtraction overflow");
101     }
102 
103     function sub(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110         return c;
111     }
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         return c;
134     }
135 }
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB)
139         external
140         returns (address pair);
141 }
142 
143 interface IUniswapV2Router02 {
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint256 amountIn,
146         uint256 amountOutMin,
147         address[] calldata path,
148         address to,
149         uint256 deadline
150     ) external;
151 
152     function factory() external pure returns (address);
153 
154     function WETH() external pure returns (address);
155 
156     function addLiquidityETH(
157         address token,
158         uint256 amountTokenDesired,
159         uint256 amountTokenMin,
160         uint256 amountETHMin,
161         address to,
162         uint256 deadline
163     )
164         external
165         payable
166         returns (
167             uint256 amountToken,
168             uint256 amountETH,
169             uint256 liquidity
170         );
171 }
172 
173 contract TSUKARUMA is Context, IERC20, Ownable {
174 
175     using SafeMath for uint256;
176 
177     string private constant _name = "TSUKARUMA";
178     string private constant _symbol = "TSUKARUMA";
179     uint8 private constant _decimals = 9;
180 
181     mapping(address => uint256) private _rOwned;
182     mapping(address => uint256) private _tOwned;
183     mapping(address => mapping(address => uint256)) private _allowances;
184     mapping(address => bool) private _isExcludedFromFee;
185     uint256 private constant MAX = ~uint256(0);
186     uint256 private constant _tTotal = 1000000000000 * 10**9; // total tokens  1 000 000 000 000   
187     uint256 private _rTotal = (MAX - (MAX % _tTotal));                     
188     uint256 private _tFeeTotal;
189     uint256 private _redisFeeOnBuy = 0;
190     uint256 private _taxFeeOnBuy = 7;
191     uint256 private _redisFeeOnSell = 0;
192     uint256 private _taxFeeOnSell = 7;
193 
194     //Original Fee
195     uint256 private _redisFee = _redisFeeOnSell;
196     uint256 private _taxFee = _taxFeeOnSell;
197 
198     uint256 private _previousredisFee = _redisFee;
199     uint256 private _previoustaxFee = _taxFee;
200 
201     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
202     address payable private _developmentAddress = payable(0xA9B749a42F454907D81f86b7266ED179a399F03B);
203     address payable private _marketingAddress = payable(0xA9B749a42F454907D81f86b7266ED179a399F03B);
204 
205     IUniswapV2Router02 public uniswapV2Router;
206     address public uniswapV2Pair;
207 
208     bool private tradingOpen = true;
209     bool private inSwap = false;
210     bool private swapEnabled = true;
211                                                      
212     uint256 public _maxTxAmount = 20000000000 * 20**9;  
213     uint256 public _maxWalletSize = 20000000000 * 20**9;
214     uint256 public _swapTokensAtAmount = 20000000 * 20**9;
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
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
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
422         _marketingAddress.transfer(amount);
423     }
424 
425     function setTrading(bool _tradingOpen) public onlyOwner {
426         tradingOpen = _tradingOpen;
427     }
428 
429     function manualswap() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractBalance = balanceOf(address(this));
432         swapTokensForEth(contractBalance);
433     }
434 
435     function manualsend() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractETHBalance = address(this).balance;
438         sendETHToFee(contractETHBalance);
439     }
440 
441     function blockBots(address[] memory bots_) public onlyOwner {
442         for (uint256 i = 0; i < bots_.length; i++) {
443             bots[bots_[i]] = true;
444         }
445     }
446 
447     function unblockBot(address notbot) public onlyOwner {
448         bots[notbot] = false;
449     }
450 
451     function _tokenTransfer(
452         address sender,
453         address recipient,
454         uint256 amount,
455         bool takeFee
456     ) private {
457         if (!takeFee) removeAllFee();
458         _transferStandard(sender, recipient, amount);
459         if (!takeFee) restoreAllFee();
460     }
461 
462     function _transferStandard(
463         address sender,
464         address recipient,
465         uint256 tAmount
466     ) private {
467         (
468             uint256 rAmount,
469             uint256 rTransferAmount,
470             uint256 rFee,
471             uint256 tTransferAmount,
472             uint256 tFee,
473             uint256 tTeam
474         ) = _getValues(tAmount);
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
477         _takeTeam(tTeam);
478         _reflectFee(rFee, tFee);
479         emit Transfer(sender, recipient, tTransferAmount);
480     }
481 
482     function _takeTeam(uint256 tTeam) private {
483         uint256 currentRate = _getRate();
484         uint256 rTeam = tTeam.mul(currentRate);
485         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
486     }
487 
488     function _reflectFee(uint256 rFee, uint256 tFee) private {
489         _rTotal = _rTotal.sub(rFee);
490         _tFeeTotal = _tFeeTotal.add(tFee);
491     }
492 
493     receive() external payable {}
494 
495     function _getValues(uint256 tAmount)
496         private
497         view
498         returns (
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
508             _getTValues(tAmount, _redisFee, _taxFee);
509         uint256 currentRate = _getRate();
510         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
511             _getRValues(tAmount, tFee, tTeam, currentRate);
512         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getTValues(
516         uint256 tAmount,
517         uint256 redisFee,
518         uint256 taxFee
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 tFee = tAmount.mul(redisFee).div(100);
529         uint256 tTeam = tAmount.mul(taxFee).div(100);
530         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
531         return (tTransferAmount, tFee, tTeam);
532     }
533 
534     function _getRValues(
535         uint256 tAmount,
536         uint256 tFee,
537         uint256 tTeam,
538         uint256 currentRate
539     )
540         private
541         pure
542         returns (
543             uint256,
544             uint256,
545             uint256
546         )
547     {
548         uint256 rAmount = tAmount.mul(currentRate);
549         uint256 rFee = tFee.mul(currentRate);
550         uint256 rTeam = tTeam.mul(currentRate);
551         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
552         return (rAmount, rTransferAmount, rFee);
553     }
554 
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557         return rSupply.div(tSupply);
558     }
559 
560     function _getCurrentSupply() private view returns (uint256, uint256) {
561         uint256 rSupply = _rTotal;
562         uint256 tSupply = _tTotal;
563         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
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
574     //Set minimum tokens required to swap.
575     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
576         _swapTokensAtAmount = swapTokensAtAmount;
577     }
578 
579     //Set minimum tokens required to swap.
580     function toggleSwap(bool _swapEnabled) public onlyOwner {
581         swapEnabled = _swapEnabled;
582     }
583 
584     //Set maximum transaction
585     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
586         _maxTxAmount = maxTxAmount;
587     }
588 
589     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
590         _maxWalletSize = maxWalletSize;
591     }
592 
593     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
594         for(uint256 i = 0; i < accounts.length; i++) {
595             _isExcludedFromFee[accounts[i]] = excluded;
596         }
597     }
598 
599 }