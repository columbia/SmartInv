1 // SPDX-License-Identifier: UNLICENSED
2 
3 //   Telegram:  https://t.me/bitcoin2erc
4 //   Website:   https://Bitcoin2erc.com
5 
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39 
40 contract Ownable is Context {
41     address private _owner;
42     address private _previousOwner;
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47 
48     constructor() {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96 
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105 
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135 
136     function factory() external pure returns (address);
137 
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156 
157     contract BitcoinTwo is Context, IERC20, Ownable {
158 
159     using SafeMath for uint256;
160 
161     string private constant _name = "Bitcoin 2.0";
162     string private constant _symbol = "BITCOIN2.0";
163     uint8 private constant _decimals = 9;
164 
165     mapping(address => uint256) private _rOwned;
166     mapping(address => uint256) private _tOwned;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 21000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173 
174     //Buy Fee
175     uint256 private _redisFeeOnBuy = 0;
176     uint256 private _taxFeeOnBuy = 20;
177 
178     //Sell Fee
179     uint256 private _redisFeeOnSell = 0;
180     uint256 private _taxFeeOnSell = 25;
181 
182     //Original Fee
183     uint256 private _redisFee = _redisFeeOnSell;
184     uint256 private _taxFee = _taxFeeOnSell;
185 
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188 
189     mapping(address => bool) public bots;
190     mapping(address => uint256) private cooldown;
191 
192     address payable private _developmentAddress = payable(0xB121235f2CE6FF8F04D77f03f80A3bbF674192d0);
193     address payable private _marketingAddress = payable(0xB121235f2CE6FF8F04D77f03f80A3bbF674192d0);
194 
195     IUniswapV2Router02 public uniswapV2Router;
196     address public uniswapV2Pair;
197 
198     bool private tradingOpen;
199     bool private inSwap = false;
200     bool private swapEnabled = true;
201 
202     uint256 public _maxTxAmount = 200000 * 10**9; //
203     uint256 public _maxWalletSize = 200000 * 10**9; //
204     uint256 public _swapTokensAtAmount = 50000 * 10**9; //
205 
206     event MaxTxAmountUpdated(uint256 _maxTxAmount);
207     modifier lockTheSwap {
208         inSwap = true;
209         _;
210         inSwap = false;
211     }
212 
213     constructor() {
214 
215         _rOwned[_msgSender()] = _rTotal;
216 
217         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
218         uniswapV2Router = _uniswapV2Router;
219         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
220             .createPair(address(this), _uniswapV2Router.WETH());
221 
222         _isExcludedFromFee[owner()] = true;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[_developmentAddress] = true;
225         _isExcludedFromFee[_marketingAddress] = true;
226 
227         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
228         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
229         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
230         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
231         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
232         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
233         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
234         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
235         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
236         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
237         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
238 
239         emit Transfer(address(0), _msgSender(), _tTotal);
240     }
241 
242     function name() public pure returns (string memory) {
243         return _name;
244     }
245 
246     function symbol() public pure returns (string memory) {
247         return _symbol;
248     }
249 
250     function decimals() public pure returns (uint8) {
251         return _decimals;
252     }
253 
254     function totalSupply() public pure override returns (uint256) {
255         return _tTotal;
256     }
257 
258     function balanceOf(address account) public view override returns (uint256) {
259         return tokenFromReflection(_rOwned[account]);
260     }
261 
262     function transfer(address recipient, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     function allowance(address owner, address spender)
272         public
273         view
274         override
275         returns (uint256)
276     {
277         return _allowances[owner][spender];
278     }
279 
280     function approve(address spender, uint256 amount)
281         public
282         override
283         returns (bool)
284     {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288 
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) public override returns (bool) {
294         _transfer(sender, recipient, amount);
295         _approve(
296             sender,
297             _msgSender(),
298             _allowances[sender][_msgSender()].sub(
299                 amount,
300                 "ERC20: transfer amount exceeds allowance"
301             )
302         );
303         return true;
304     }
305 
306     function tokenFromReflection(uint256 rAmount)
307         private
308         view
309         returns (uint256)
310     {
311         require(
312             rAmount <= _rTotal,
313             "Amount must be less than total reflections"
314         );
315         uint256 currentRate = _getRate();
316         return rAmount.div(currentRate);
317     }
318 
319     function removeAllFee() private {
320         if (_redisFee == 0 && _taxFee == 0) return;
321 
322         _previousredisFee = _redisFee;
323         _previoustaxFee = _taxFee;
324 
325         _redisFee = 0;
326         _taxFee = 0;
327     }
328 
329     function restoreAllFee() private {
330         _redisFee = _previousredisFee;
331         _taxFee = _previoustaxFee;
332     }
333 
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) private {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344 
345     function _transfer(
346         address from,
347         address to,
348         uint256 amount
349     ) private {
350         require(from != address(0), "ERC20: transfer from the zero address");
351         require(to != address(0), "ERC20: transfer to the zero address");
352         require(amount > 0, "Transfer amount must be greater than zero");
353 
354         if (from != owner() && to != owner()) {
355 
356             //Trade start check
357             if (!tradingOpen) {
358                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
359             }
360 
361             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
362             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
363 
364             if(to != uniswapV2Pair) {
365                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
366             }
367 
368             uint256 contractTokenBalance = balanceOf(address(this));
369             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
370 
371             if(contractTokenBalance >= _maxTxAmount)
372             {
373                 contractTokenBalance = _maxTxAmount;
374             }
375 
376             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
377                 swapTokensForEth(contractTokenBalance);
378                 uint256 contractETHBalance = address(this).balance;
379                 if (contractETHBalance > 0) {
380                     sendETHToFee(address(this).balance);
381                 }
382             }
383         }
384 
385         bool takeFee = true;
386 
387         //Transfer Tokens
388         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
389             takeFee = false;
390         } else {
391 
392             //Set Fee for Buys
393             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
394                 _redisFee = _redisFeeOnBuy;
395                 _taxFee = _taxFeeOnBuy;
396             }
397 
398             //Set Fee for Sells
399             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnSell;
401                 _taxFee = _taxFeeOnSell;
402             }
403 
404         }
405 
406         _tokenTransfer(from, to, amount, takeFee);
407     }
408 
409     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
410         address[] memory path = new address[](2);
411         path[0] = address(this);
412         path[1] = uniswapV2Router.WETH();
413         _approve(address(this), address(uniswapV2Router), tokenAmount);
414         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
415             tokenAmount,
416             0,
417             path,
418             address(this),
419             block.timestamp
420         );
421     }
422 
423     function sendETHToFee(uint256 amount) private {
424         _developmentAddress.transfer(amount.div(2));
425         _marketingAddress.transfer(amount.div(2));
426     }
427 
428     function setTrading(bool _tradingOpen) public onlyOwner {
429         tradingOpen = _tradingOpen;
430     }
431 
432     function manualswap() external {
433         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
434         uint256 contractBalance = balanceOf(address(this));
435         swapTokensForEth(contractBalance);
436     }
437 
438     function manualsend() external {
439         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
440         uint256 contractETHBalance = address(this).balance;
441         sendETHToFee(contractETHBalance);
442     }
443 
444     function blockBots(address[] memory bots_) public onlyOwner {
445         for (uint256 i = 0; i < bots_.length; i++) {
446             bots[bots_[i]] = true;
447         }
448     }
449 
450     function unblockBot(address notbot) public onlyOwner {
451         bots[notbot] = false;
452     }
453 
454     function _tokenTransfer(
455         address sender,
456         address recipient,
457         uint256 amount,
458         bool takeFee
459     ) private {
460         if (!takeFee) removeAllFee();
461         _transferStandard(sender, recipient, amount);
462         if (!takeFee) restoreAllFee();
463     }
464 
465     function _transferStandard(
466         address sender,
467         address recipient,
468         uint256 tAmount
469     ) private {
470         (
471             uint256 rAmount,
472             uint256 rTransferAmount,
473             uint256 rFee,
474             uint256 tTransferAmount,
475             uint256 tFee,
476             uint256 tTeam
477         ) = _getValues(tAmount);
478         _rOwned[sender] = _rOwned[sender].sub(rAmount);
479         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
480         _takeTeam(tTeam);
481         _reflectFee(rFee, tFee);
482         emit Transfer(sender, recipient, tTransferAmount);
483     }
484 
485     function _takeTeam(uint256 tTeam) private {
486         uint256 currentRate = _getRate();
487         uint256 rTeam = tTeam.mul(currentRate);
488         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
489     }
490 
491     function _reflectFee(uint256 rFee, uint256 tFee) private {
492         _rTotal = _rTotal.sub(rFee);
493         _tFeeTotal = _tFeeTotal.add(tFee);
494     }
495 
496     receive() external payable {}
497 
498     function _getValues(uint256 tAmount)
499         private
500         view
501         returns (
502             uint256,
503             uint256,
504             uint256,
505             uint256,
506             uint256,
507             uint256
508         )
509     {
510         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
511             _getTValues(tAmount, _redisFee, _taxFee);
512         uint256 currentRate = _getRate();
513         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
514             _getRValues(tAmount, tFee, tTeam, currentRate);
515 
516         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
517     }
518 
519     function _getTValues(
520         uint256 tAmount,
521         uint256 redisFee,
522         uint256 taxFee
523     )
524         private
525         pure
526         returns (
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         uint256 tFee = tAmount.mul(redisFee).div(100);
533         uint256 tTeam = tAmount.mul(taxFee).div(100);
534         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
535 
536         return (tTransferAmount, tFee, tTeam);
537     }
538 
539     function _getRValues(
540         uint256 tAmount,
541         uint256 tFee,
542         uint256 tTeam,
543         uint256 currentRate
544     )
545         private
546         pure
547         returns (
548             uint256,
549             uint256,
550             uint256
551         )
552     {
553         uint256 rAmount = tAmount.mul(currentRate);
554         uint256 rFee = tFee.mul(currentRate);
555         uint256 rTeam = tTeam.mul(currentRate);
556         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
557 
558         return (rAmount, rTransferAmount, rFee);
559     }
560 
561     function _getRate() private view returns (uint256) {
562         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
563 
564         return rSupply.div(tSupply);
565     }
566 
567     function _getCurrentSupply() private view returns (uint256, uint256) {
568         uint256 rSupply = _rTotal;
569         uint256 tSupply = _tTotal;
570         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
571 
572         return (rSupply, tSupply);
573     }
574 
575     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
576         _redisFeeOnBuy = redisFeeOnBuy;
577         _redisFeeOnSell = redisFeeOnSell;
578 
579         _taxFeeOnBuy = taxFeeOnBuy;
580         _taxFeeOnSell = taxFeeOnSell;
581     }
582 
583     //Set minimum tokens required to swap.
584     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
585         _swapTokensAtAmount = swapTokensAtAmount;
586     }
587 
588     //Set minimum tokens required to swap.
589     function toggleSwap(bool _swapEnabled) public onlyOwner {
590         swapEnabled = _swapEnabled;
591     }
592 
593     //Set MAx transaction
594     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
595         _maxTxAmount = maxTxAmount;
596     }
597 
598     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
599         _maxWalletSize = maxWalletSize;
600     }
601 
602 }