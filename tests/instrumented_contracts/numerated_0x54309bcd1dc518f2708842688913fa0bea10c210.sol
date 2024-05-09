1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 // TELEGRAM: https://t.me/saitamaerc
5 
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract Saitama is Context, IERC20, Ownable {
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "Saitama";
161     string private constant _symbol = "SAITAMA";
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172 
173     //Buy Fee
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 0;
176 
177     //Sell Fee
178     uint256 private _redisFeeOnSell = 0;
179     uint256 private _taxFeeOnSell = 0;
180 
181     //Original Fee
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184 
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187 
188     mapping(address => bool) public bots;
189     mapping(address => uint256) private cooldown;
190 
191     address payable private _developmentAddress = payable(0xcBdcA5E0bF601751F74f373c90dcA04503C00426);
192     address payable private _marketingAddress = payable(0xaC7d5259b0FeDe3C1fD41644c9e41506d493E8BA);
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 1500000 * 10**9; //
202     uint256 public _maxWalletSize = 3000000 * 10**9; //
203     uint256 public _swapTokensAtAmount = 500000 * 10**9; //
204 
205     event MaxTxAmountUpdated(uint256 _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211 
212     constructor() {
213 
214         _rOwned[_msgSender()] = _rTotal;
215 
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219             .createPair(address(this), _uniswapV2Router.WETH());
220 
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_developmentAddress] = true;
224         _isExcludedFromFee[_marketingAddress] = true;
225 
226         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
227         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
228         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
229         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
230         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
231         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
232         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
233         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
234         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
235         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
236         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
237 
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240 
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244 
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248 
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252 
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256 
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260 
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278 
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304 
305     function tokenFromReflection(uint256 rAmount)
306         private
307         view
308         returns (uint256)
309     {
310         require(
311             rAmount <= _rTotal,
312             "Amount must be less than total reflections"
313         );
314         uint256 currentRate = _getRate();
315         return rAmount.div(currentRate);
316     }
317 
318     function removeAllFee() private {
319         if (_redisFee == 0 && _taxFee == 0) return;
320 
321         _previousredisFee = _redisFee;
322         _previoustaxFee = _taxFee;
323 
324         _redisFee = 0;
325         _taxFee = 0;
326     }
327 
328     function restoreAllFee() private {
329         _redisFee = _previousredisFee;
330         _taxFee = _previoustaxFee;
331     }
332 
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343 
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) private {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351         require(amount > 0, "Transfer amount must be greater than zero");
352 
353         if (from != owner() && to != owner()) {
354 
355             //Trade start check
356             if (!tradingOpen) {
357                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
358             }
359 
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
362 
363             if(to != uniswapV2Pair) {
364                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
365             }
366 
367             uint256 contractTokenBalance = balanceOf(address(this));
368             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
369 
370             if(contractTokenBalance >= _maxTxAmount)
371             {
372                 contractTokenBalance = _maxTxAmount;
373             }
374 
375             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
376                 swapTokensForEth(contractTokenBalance);
377                 uint256 contractETHBalance = address(this).balance;
378                 if (contractETHBalance > 0) {
379                     sendETHToFee(address(this).balance);
380                 }
381             }
382         }
383 
384         bool takeFee = true;
385 
386         //Transfer Tokens
387         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
388             takeFee = false;
389         } else {
390 
391             //Set Fee for Buys
392             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnBuy;
394                 _taxFee = _taxFeeOnBuy;
395             }
396 
397             //Set Fee for Sells
398             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
399                 _redisFee = _redisFeeOnSell;
400                 _taxFee = _taxFeeOnSell;
401             }
402 
403         }
404 
405         _tokenTransfer(from, to, amount, takeFee);
406     }
407 
408     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
409         address[] memory path = new address[](2);
410         path[0] = address(this);
411         path[1] = uniswapV2Router.WETH();
412         _approve(address(this), address(uniswapV2Router), tokenAmount);
413         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
414             tokenAmount,
415             0,
416             path,
417             address(this),
418             block.timestamp
419         );
420     }
421 
422     function sendETHToFee(uint256 amount) private {
423         _developmentAddress.transfer(amount.div(2));
424         _marketingAddress.transfer(amount.div(2));
425     }
426 
427     function setTrading(bool _tradingOpen) public onlyOwner {
428         tradingOpen = _tradingOpen;
429     }
430 
431     function manualswap() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractBalance = balanceOf(address(this));
434         swapTokensForEth(contractBalance);
435     }
436 
437     function manualsend() external {
438         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
439         uint256 contractETHBalance = address(this).balance;
440         sendETHToFee(contractETHBalance);
441     }
442 
443     function blockBots(address[] memory bots_) public onlyOwner {
444         for (uint256 i = 0; i < bots_.length; i++) {
445             bots[bots_[i]] = true;
446         }
447     }
448 
449     function unblockBot(address notbot) public onlyOwner {
450         bots[notbot] = false;
451     }
452 
453     function _tokenTransfer(
454         address sender,
455         address recipient,
456         uint256 amount,
457         bool takeFee
458     ) private {
459         if (!takeFee) removeAllFee();
460         _transferStandard(sender, recipient, amount);
461         if (!takeFee) restoreAllFee();
462     }
463 
464     function _transferStandard(
465         address sender,
466         address recipient,
467         uint256 tAmount
468     ) private {
469         (
470             uint256 rAmount,
471             uint256 rTransferAmount,
472             uint256 rFee,
473             uint256 tTransferAmount,
474             uint256 tFee,
475             uint256 tTeam
476         ) = _getValues(tAmount);
477         _rOwned[sender] = _rOwned[sender].sub(rAmount);
478         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
479         _takeTeam(tTeam);
480         _reflectFee(rFee, tFee);
481         emit Transfer(sender, recipient, tTransferAmount);
482     }
483 
484     function _takeTeam(uint256 tTeam) private {
485         uint256 currentRate = _getRate();
486         uint256 rTeam = tTeam.mul(currentRate);
487         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
488     }
489 
490     function _reflectFee(uint256 rFee, uint256 tFee) private {
491         _rTotal = _rTotal.sub(rFee);
492         _tFeeTotal = _tFeeTotal.add(tFee);
493     }
494 
495     receive() external payable {}
496 
497     function _getValues(uint256 tAmount)
498         private
499         view
500         returns (
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
510             _getTValues(tAmount, _redisFee, _taxFee);
511         uint256 currentRate = _getRate();
512         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
513             _getRValues(tAmount, tFee, tTeam, currentRate);
514 
515         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
516     }
517 
518     function _getTValues(
519         uint256 tAmount,
520         uint256 redisFee,
521         uint256 taxFee
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 tFee = tAmount.mul(redisFee).div(100);
532         uint256 tTeam = tAmount.mul(taxFee).div(100);
533         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
534 
535         return (tTransferAmount, tFee, tTeam);
536     }
537 
538     function _getRValues(
539         uint256 tAmount,
540         uint256 tFee,
541         uint256 tTeam,
542         uint256 currentRate
543     )
544         private
545         pure
546         returns (
547             uint256,
548             uint256,
549             uint256
550         )
551     {
552         uint256 rAmount = tAmount.mul(currentRate);
553         uint256 rFee = tFee.mul(currentRate);
554         uint256 rTeam = tTeam.mul(currentRate);
555         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
556 
557         return (rAmount, rTransferAmount, rFee);
558     }
559 
560     function _getRate() private view returns (uint256) {
561         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
562 
563         return rSupply.div(tSupply);
564     }
565 
566     function _getCurrentSupply() private view returns (uint256, uint256) {
567         uint256 rSupply = _rTotal;
568         uint256 tSupply = _tTotal;
569         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
570 
571         return (rSupply, tSupply);
572     }
573 
574     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
575         _redisFeeOnBuy = redisFeeOnBuy;
576         _redisFeeOnSell = redisFeeOnSell;
577 
578         _taxFeeOnBuy = taxFeeOnBuy;
579         _taxFeeOnSell = taxFeeOnSell;
580     }
581 
582     //Set minimum tokens required to swap.
583     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
584         _swapTokensAtAmount = swapTokensAtAmount;
585     }
586 
587     //Set minimum tokens required to swap.
588     function toggleSwap(bool _swapEnabled) public onlyOwner {
589         swapEnabled = _swapEnabled;
590     }
591 
592     //Set MAx transaction
593     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
594         _maxTxAmount = maxTxAmount;
595     }
596 
597     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
598         _maxWalletSize = maxWalletSize;
599     }
600 
601 }