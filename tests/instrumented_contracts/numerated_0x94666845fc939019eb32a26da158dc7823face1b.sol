1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 // TELEGRAM: https://t.me/kentoofficial
5 
6 
7 
8 pragma solidity ^0.8.4;
9 
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
158 contract Kento is Context, IERC20, Ownable {
159 
160     using SafeMath for uint256;
161 
162     string private constant _name = "Kento";
163     string private constant _symbol = "KENTO";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 10000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174 
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 0;
177     uint256 private _taxFeeOnBuy = 0;
178 
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 0;
181     uint256 private _taxFeeOnSell = 0;
182 
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186 
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189 
190     mapping(address => bool) public bots;
191     mapping(address => uint256) private cooldown;
192 
193     address payable private _developmentAddress = payable(0xABEaa9954feA6294856a7665351d7eC8267D156B);
194     address payable private _marketingAddress = payable(0xd910e0104dec0836E67E0430A8a54C930F3957F0);
195 
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198 
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202 
203     uint256 public _maxTxAmount = 150000 * 10**9; //
204     uint256 public _maxWalletSize = 300000 * 10**9; //
205     uint256 public _swapTokensAtAmount = 50000 * 10**9; //
206 
207     event MaxTxAmountUpdated(uint256 _maxTxAmount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213 
214     constructor() {
215 
216         _rOwned[_msgSender()] = _rTotal;
217 
218         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
219         uniswapV2Router = _uniswapV2Router;
220         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
221             .createPair(address(this), _uniswapV2Router.WETH());
222 
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[address(this)] = true;
225         _isExcludedFromFee[_developmentAddress] = true;
226         _isExcludedFromFee[_marketingAddress] = true;
227 
228         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
229         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
230         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
231         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
232         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
233         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
234         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
235         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
236         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
237         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
238         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
239 
240         emit Transfer(address(0), _msgSender(), _tTotal);
241     }
242 
243     function name() public pure returns (string memory) {
244         return _name;
245     }
246 
247     function symbol() public pure returns (string memory) {
248         return _symbol;
249     }
250 
251     function decimals() public pure returns (uint8) {
252         return _decimals;
253     }
254 
255     function totalSupply() public pure override returns (uint256) {
256         return _tTotal;
257     }
258 
259     function balanceOf(address account) public view override returns (uint256) {
260         return tokenFromReflection(_rOwned[account]);
261     }
262 
263     function transfer(address recipient, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271 
272     function allowance(address owner, address spender)
273         public
274         view
275         override
276         returns (uint256)
277     {
278         return _allowances[owner][spender];
279     }
280 
281     function approve(address spender, uint256 amount)
282         public
283         override
284         returns (bool)
285     {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) public override returns (bool) {
295         _transfer(sender, recipient, amount);
296         _approve(
297             sender,
298             _msgSender(),
299             _allowances[sender][_msgSender()].sub(
300                 amount,
301                 "ERC20: transfer amount exceeds allowance"
302             )
303         );
304         return true;
305     }
306 
307     function tokenFromReflection(uint256 rAmount)
308         private
309         view
310         returns (uint256)
311     {
312         require(
313             rAmount <= _rTotal,
314             "Amount must be less than total reflections"
315         );
316         uint256 currentRate = _getRate();
317         return rAmount.div(currentRate);
318     }
319 
320     function removeAllFee() private {
321         if (_redisFee == 0 && _taxFee == 0) return;
322 
323         _previousredisFee = _redisFee;
324         _previoustaxFee = _taxFee;
325 
326         _redisFee = 0;
327         _taxFee = 0;
328     }
329 
330     function restoreAllFee() private {
331         _redisFee = _previousredisFee;
332         _taxFee = _previoustaxFee;
333     }
334 
335     function _approve(
336         address owner,
337         address spender,
338         uint256 amount
339     ) private {
340         require(owner != address(0), "ERC20: approve from the zero address");
341         require(spender != address(0), "ERC20: approve to the zero address");
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     function _transfer(
347         address from,
348         address to,
349         uint256 amount
350     ) private {
351         require(from != address(0), "ERC20: transfer from the zero address");
352         require(to != address(0), "ERC20: transfer to the zero address");
353         require(amount > 0, "Transfer amount must be greater than zero");
354 
355         if (from != owner() && to != owner()) {
356 
357             //Trade start check
358             if (!tradingOpen) {
359                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
360             }
361 
362             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
363             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
364 
365             if(to != uniswapV2Pair) {
366                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
367             }
368 
369             uint256 contractTokenBalance = balanceOf(address(this));
370             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
371 
372             if(contractTokenBalance >= _maxTxAmount)
373             {
374                 contractTokenBalance = _maxTxAmount;
375             }
376 
377             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
378                 swapTokensForEth(contractTokenBalance);
379                 uint256 contractETHBalance = address(this).balance;
380                 if (contractETHBalance > 0) {
381                     sendETHToFee(address(this).balance);
382                 }
383             }
384         }
385 
386         bool takeFee = true;
387 
388         //Transfer Tokens
389         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
390             takeFee = false;
391         } else {
392 
393             //Set Fee for Buys
394             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
395                 _redisFee = _redisFeeOnBuy;
396                 _taxFee = _taxFeeOnBuy;
397             }
398 
399             //Set Fee for Sells
400             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnSell;
402                 _taxFee = _taxFeeOnSell;
403             }
404 
405         }
406 
407         _tokenTransfer(from, to, amount, takeFee);
408     }
409 
410     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
411         address[] memory path = new address[](2);
412         path[0] = address(this);
413         path[1] = uniswapV2Router.WETH();
414         _approve(address(this), address(uniswapV2Router), tokenAmount);
415         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
416             tokenAmount,
417             0,
418             path,
419             address(this),
420             block.timestamp
421         );
422     }
423 
424     function sendETHToFee(uint256 amount) private {
425         _developmentAddress.transfer(amount.div(2));
426         _marketingAddress.transfer(amount.div(2));
427     }
428 
429     function setTrading(bool _tradingOpen) public onlyOwner {
430         tradingOpen = _tradingOpen;
431     }
432 
433     function manualswap() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438 
439     function manualsend() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444 
445     function blockBots(address[] memory bots_) public onlyOwner {
446         for (uint256 i = 0; i < bots_.length; i++) {
447             bots[bots_[i]] = true;
448         }
449     }
450 
451     function unblockBot(address notbot) public onlyOwner {
452         bots[notbot] = false;
453     }
454 
455     function _tokenTransfer(
456         address sender,
457         address recipient,
458         uint256 amount,
459         bool takeFee
460     ) private {
461         if (!takeFee) removeAllFee();
462         _transferStandard(sender, recipient, amount);
463         if (!takeFee) restoreAllFee();
464     }
465 
466     function _transferStandard(
467         address sender,
468         address recipient,
469         uint256 tAmount
470     ) private {
471         (
472             uint256 rAmount,
473             uint256 rTransferAmount,
474             uint256 rFee,
475             uint256 tTransferAmount,
476             uint256 tFee,
477             uint256 tTeam
478         ) = _getValues(tAmount);
479         _rOwned[sender] = _rOwned[sender].sub(rAmount);
480         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
481         _takeTeam(tTeam);
482         _reflectFee(rFee, tFee);
483         emit Transfer(sender, recipient, tTransferAmount);
484     }
485 
486     function _takeTeam(uint256 tTeam) private {
487         uint256 currentRate = _getRate();
488         uint256 rTeam = tTeam.mul(currentRate);
489         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
490     }
491 
492     function _reflectFee(uint256 rFee, uint256 tFee) private {
493         _rTotal = _rTotal.sub(rFee);
494         _tFeeTotal = _tFeeTotal.add(tFee);
495     }
496 
497     receive() external payable {}
498 
499     function _getValues(uint256 tAmount)
500         private
501         view
502         returns (
503             uint256,
504             uint256,
505             uint256,
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
512             _getTValues(tAmount, _redisFee, _taxFee);
513         uint256 currentRate = _getRate();
514         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
515             _getRValues(tAmount, tFee, tTeam, currentRate);
516 
517         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getTValues(
521         uint256 tAmount,
522         uint256 redisFee,
523         uint256 taxFee
524     )
525         private
526         pure
527         returns (
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         uint256 tFee = tAmount.mul(redisFee).div(100);
534         uint256 tTeam = tAmount.mul(taxFee).div(100);
535         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
536 
537         return (tTransferAmount, tFee, tTeam);
538     }
539 
540     function _getRValues(
541         uint256 tAmount,
542         uint256 tFee,
543         uint256 tTeam,
544         uint256 currentRate
545     )
546         private
547         pure
548         returns (
549             uint256,
550             uint256,
551             uint256
552         )
553     {
554         uint256 rAmount = tAmount.mul(currentRate);
555         uint256 rFee = tFee.mul(currentRate);
556         uint256 rTeam = tTeam.mul(currentRate);
557         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
558 
559         return (rAmount, rTransferAmount, rFee);
560     }
561 
562     function _getRate() private view returns (uint256) {
563         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
564 
565         return rSupply.div(tSupply);
566     }
567 
568     function _getCurrentSupply() private view returns (uint256, uint256) {
569         uint256 rSupply = _rTotal;
570         uint256 tSupply = _tTotal;
571         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
572 
573         return (rSupply, tSupply);
574     }
575 
576     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
577         _redisFeeOnBuy = redisFeeOnBuy;
578         _redisFeeOnSell = redisFeeOnSell;
579 
580         _taxFeeOnBuy = taxFeeOnBuy;
581         _taxFeeOnSell = taxFeeOnSell;
582     }
583 
584     //Set minimum tokens required to swap.
585     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
586         _swapTokensAtAmount = swapTokensAtAmount;
587     }
588 
589     //Set minimum tokens required to swap.
590     function toggleSwap(bool _swapEnabled) public onlyOwner {
591         swapEnabled = _swapEnabled;
592     }
593 
594     //Set MAx transaction
595     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
596         _maxTxAmount = maxTxAmount;
597     }
598 
599     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
600         _maxWalletSize = maxWalletSize;
601     }
602 
603 }