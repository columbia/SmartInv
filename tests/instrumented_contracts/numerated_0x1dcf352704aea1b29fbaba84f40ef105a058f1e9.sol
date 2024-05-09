1 // SPDX-License-Identifier: UNLICENSED
2 // Telegram: https://t.me/pawdexshibarium
3 // Website:  https://pawdexshibarium.com/
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 contract Ownable is Context {
38     address private _owner;
39     address private _previousOwner;
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 }
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132 
133     function factory() external pure returns (address);
134 
135     function WETH() external pure returns (address);
136 
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153 
154 contract PawDEX is Context, IERC20, Ownable {
155 
156     using SafeMath for uint256;
157 
158     string private constant _name = "Pawdex Shibarium";
159     string private constant _symbol = "PAWDEX";
160     uint8 private constant _decimals = 9;
161 
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 10000000 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170 
171     //Buy Fee
172     uint256 private _redisFeeOnBuy = 0;
173     uint256 private _taxFeeOnBuy = 5;
174 
175     //Sell Fee
176     uint256 private _redisFeeOnSell = 0;
177     uint256 private _taxFeeOnSell = 5;
178 
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182 
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185 
186     mapping(address => bool) public bots;
187     mapping(address => uint256) private cooldown;
188 
189     address payable private _developmentAddress = payable(0x64D7D5F9D7768503d8Be7F81586765A69bd7c4A3);
190     address payable private _marketingAddress = payable(0xddb57Bc2aF0Efa7387f2eBEcd34Bd0c3fd00A454);
191 
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194 
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198 
199     uint256 public _maxTxAmount = 100000 * 10**9; //
200     uint256 public _maxWalletSize = 300000 * 10**9; //
201     uint256 public _swapTokensAtAmount = 50000 * 10**9; //
202 
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209 
210     constructor() {
211 
212         _rOwned[_msgSender()] = _rTotal;
213 
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218 
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223 
224         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
225         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
226         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
227         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
228         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
229         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
230         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
231         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
232         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
233         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
234         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
235 
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238 
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242 
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246 
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250 
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254 
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258 
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267 
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276 
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302 
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315 
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318 
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321 
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325 
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330 
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350 
351         if (from != owner() && to != owner()) {
352 
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357 
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
360 
361             if(to != uniswapV2Pair) {
362                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
363             }
364 
365             uint256 contractTokenBalance = balanceOf(address(this));
366             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
367 
368             if(contractTokenBalance >= _maxTxAmount)
369             {
370                 contractTokenBalance = _maxTxAmount;
371             }
372 
373             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
374                 swapTokensForEth(contractTokenBalance);
375                 uint256 contractETHBalance = address(this).balance;
376                 if (contractETHBalance > 0) {
377                     sendETHToFee(address(this).balance);
378                 }
379             }
380         }
381 
382         bool takeFee = true;
383 
384         //Transfer Tokens
385         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
386             takeFee = false;
387         } else {
388 
389             //Set Fee for Buys
390             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnBuy;
392                 _taxFee = _taxFeeOnBuy;
393             }
394 
395             //Set Fee for Sells
396             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnSell;
398                 _taxFee = _taxFeeOnSell;
399             }
400 
401         }
402 
403         _tokenTransfer(from, to, amount, takeFee);
404     }
405 
406     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
407         address[] memory path = new address[](2);
408         path[0] = address(this);
409         path[1] = uniswapV2Router.WETH();
410         _approve(address(this), address(uniswapV2Router), tokenAmount);
411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
412             tokenAmount,
413             0,
414             path,
415             address(this),
416             block.timestamp
417         );
418     }
419 
420     function sendETHToFee(uint256 amount) private {
421         _developmentAddress.transfer(amount.div(2));
422         _marketingAddress.transfer(amount.div(2));
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
512 
513         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
514     }
515 
516     function _getTValues(
517         uint256 tAmount,
518         uint256 redisFee,
519         uint256 taxFee
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 tFee = tAmount.mul(redisFee).div(100);
530         uint256 tTeam = tAmount.mul(taxFee).div(100);
531         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
532 
533         return (tTransferAmount, tFee, tTeam);
534     }
535 
536     function _getRValues(
537         uint256 tAmount,
538         uint256 tFee,
539         uint256 tTeam,
540         uint256 currentRate
541     )
542         private
543         pure
544         returns (
545             uint256,
546             uint256,
547             uint256
548         )
549     {
550         uint256 rAmount = tAmount.mul(currentRate);
551         uint256 rFee = tFee.mul(currentRate);
552         uint256 rTeam = tTeam.mul(currentRate);
553         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
554 
555         return (rAmount, rTransferAmount, rFee);
556     }
557 
558     function _getRate() private view returns (uint256) {
559         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
560 
561         return rSupply.div(tSupply);
562     }
563 
564     function _getCurrentSupply() private view returns (uint256, uint256) {
565         uint256 rSupply = _rTotal;
566         uint256 tSupply = _tTotal;
567         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
568 
569         return (rSupply, tSupply);
570     }
571 
572     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
573         _redisFeeOnBuy = redisFeeOnBuy;
574         _redisFeeOnSell = redisFeeOnSell;
575 
576         _taxFeeOnBuy = taxFeeOnBuy;
577         _taxFeeOnSell = taxFeeOnSell;
578     }
579 
580     //Set minimum tokens required to swap.
581     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
582         _swapTokensAtAmount = swapTokensAtAmount;
583     }
584 
585     //Set minimum tokens required to swap.
586     function toggleSwap(bool _swapEnabled) public onlyOwner {
587         swapEnabled = _swapEnabled;
588     }
589 
590     //Set MAx transaction
591     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
592         _maxTxAmount = maxTxAmount;
593     }
594 
595     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
596         _maxWalletSize = maxWalletSize;
597     }
598 
599 }