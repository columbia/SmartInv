1 /**
2  * Its not art
3  / www.itsnotart.biz
4  / https://t.me/itsnotartportal
5  / Its Not art or it might be who knows
6 */
7 
8 // SPDX-License-Identifier: UNLICENSED
9 pragma solidity ^0.8.4;
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
43     address private _owner;
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
159 contract NotArt is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
160 
161     using SafeMath for uint256;
162 
163     string private constant _name = "Its Not Art";//////////////////////////
164     string private constant _symbol = "NotArt";//////////////////////////////////////////////////////////////////////////
165     uint8 private constant _decimals = 9;
166 
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 10000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175 
176     //Buy Fee
177     uint256 private _redisFeeOnBuy = 1;////////////////////////////////////////////////////////////////////
178     uint256 private _taxFeeOnBuy = 11;//////////////////////////////////////////////////////////////////////
179 
180     //Sell Fee
181     uint256 private _redisFeeOnSell = 1;/////////////////////////////////////////////////////////////////////
182     uint256 private _taxFeeOnSell = 11;/////////////////////////////////////////////////////////////////////
183 
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190 
191     mapping(address => bool) public bots;
192     mapping(address => uint256) private cooldown;
193 
194     address payable private _developmentAddress = payable(0x5Dc03C27c505904397aC3c10fc6559150930B14f);/////////////////////////////////////////////////
195     address payable private _marketingAddress = payable(0x0343C8EB07e9041C5a4dA00098eEBA952432eb48);///////////////////////////////////////////////////
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203 
204     uint256 public _maxTxAmount = 100000 * 10**9; //1%
205     uint256 public _maxWalletSize = 200000 * 10**9; //2%
206     uint256 public _swapTokensAtAmount = 100000 * 10**9; //1%
207 
208     event MaxTxAmountUpdated(uint256 _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214 
215     constructor() {
216 
217         _rOwned[_msgSender()] = _rTotal;
218 
219         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
220         uniswapV2Router = _uniswapV2Router;
221         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
222             .createPair(address(this), _uniswapV2Router.WETH());
223 
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
226         _isExcludedFromFee[_developmentAddress] = true;
227         _isExcludedFromFee[_marketingAddress] = true;
228 
229         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
230         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
231         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
232         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
233         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
234         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
235         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
236         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
237         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
238         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
239         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
240 
241 
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260 
261     function balanceOf(address account) public view override returns (uint256) {
262         return tokenFromReflection(_rOwned[account]);
263     }
264 
265     function transfer(address recipient, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273 
274     function allowance(address owner, address spender)
275         public
276         view
277         override
278         returns (uint256)
279     {
280         return _allowances[owner][spender];
281     }
282 
283     function approve(address spender, uint256 amount)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308 
309     function tokenFromReflection(uint256 rAmount)
310         private
311         view
312         returns (uint256)
313     {
314         require(
315             rAmount <= _rTotal,
316             "Amount must be less than total reflections"
317         );
318         uint256 currentRate = _getRate();
319         return rAmount.div(currentRate);
320     }
321 
322     function removeAllFee() private {
323         if (_redisFee == 0 && _taxFee == 0) return;
324 
325         _previousredisFee = _redisFee;
326         _previoustaxFee = _taxFee;
327 
328         _redisFee = 0;
329         _taxFee = 0;
330     }
331 
332     function restoreAllFee() private {
333         _redisFee = _previousredisFee;
334         _taxFee = _previoustaxFee;
335     }
336 
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347 
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) private {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356 
357         if (from != owner() && to != owner()) {
358 
359             //Trade start check
360             if (!tradingOpen) {
361                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
362             }
363 
364             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
365             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
366 
367             if(to != uniswapV2Pair) {
368                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
369             }
370 
371             uint256 contractTokenBalance = balanceOf(address(this));
372             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
373 
374             if(contractTokenBalance >= _maxTxAmount)
375             {
376                 contractTokenBalance = _maxTxAmount;
377             }
378 
379             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
380                 swapTokensForEth(contractTokenBalance);
381                 uint256 contractETHBalance = address(this).balance;
382                 if (contractETHBalance > 0) {
383                     sendETHToFee(address(this).balance);
384                 }
385             }
386         }
387 
388         bool takeFee = true;
389 
390         //Transfer Tokens
391         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
392             takeFee = false;
393         } else {
394 
395             //Set Fee for Buys
396             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnBuy;
398                 _taxFee = _taxFeeOnBuy;
399             }
400 
401             //Set Fee for Sells
402             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
403                 _redisFee = _redisFeeOnSell;
404                 _taxFee = _taxFeeOnSell;
405             }
406 
407         }
408 
409         _tokenTransfer(from, to, amount, takeFee);
410     }
411 
412     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
413         address[] memory path = new address[](2);
414         path[0] = address(this);
415         path[1] = uniswapV2Router.WETH();
416         _approve(address(this), address(uniswapV2Router), tokenAmount);
417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
418             tokenAmount,
419             0,
420             path,
421             address(this),
422             block.timestamp
423         );
424     }
425 
426     function sendETHToFee(uint256 amount) private {
427         _developmentAddress.transfer(amount.div(2));
428         _marketingAddress.transfer(amount.div(2));
429     }
430 
431     function setTrading(bool _tradingOpen) public onlyOwner {
432         tradingOpen = _tradingOpen;
433     }
434 
435     function manualswap() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractBalance = balanceOf(address(this));
438         swapTokensForEth(contractBalance);
439     }
440 
441     function manualsend() external {
442         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
443         uint256 contractETHBalance = address(this).balance;
444         sendETHToFee(contractETHBalance);
445     }
446 
447     function blockBots(address[] memory bots_) public onlyOwner {
448         for (uint256 i = 0; i < bots_.length; i++) {
449             bots[bots_[i]] = true;
450         }
451     }
452 
453     function unblockBot(address notbot) public onlyOwner {
454         bots[notbot] = false;
455     }
456 
457     function _tokenTransfer(
458         address sender,
459         address recipient,
460         uint256 amount,
461         bool takeFee
462     ) private {
463         if (!takeFee) removeAllFee();
464         _transferStandard(sender, recipient, amount);
465         if (!takeFee) restoreAllFee();
466     }
467 
468     function _transferStandard(
469         address sender,
470         address recipient,
471         uint256 tAmount
472     ) private {
473         (
474             uint256 rAmount,
475             uint256 rTransferAmount,
476             uint256 rFee,
477             uint256 tTransferAmount,
478             uint256 tFee,
479             uint256 tTeam
480         ) = _getValues(tAmount);
481         _rOwned[sender] = _rOwned[sender].sub(rAmount);
482         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
483         _takeTeam(tTeam);
484         _reflectFee(rFee, tFee);
485         emit Transfer(sender, recipient, tTransferAmount);
486     }
487 
488     function _takeTeam(uint256 tTeam) private {
489         uint256 currentRate = _getRate();
490         uint256 rTeam = tTeam.mul(currentRate);
491         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
492     }
493 
494     function _reflectFee(uint256 rFee, uint256 tFee) private {
495         _rTotal = _rTotal.sub(rFee);
496         _tFeeTotal = _tFeeTotal.add(tFee);
497     }
498 
499     receive() external payable {}
500 
501     function _getValues(uint256 tAmount)
502         private
503         view
504         returns (
505             uint256,
506             uint256,
507             uint256,
508             uint256,
509             uint256,
510             uint256
511         )
512     {
513         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
514             _getTValues(tAmount, _redisFee, _taxFee);
515         uint256 currentRate = _getRate();
516         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
517             _getRValues(tAmount, tFee, tTeam, currentRate);
518 
519         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getTValues(
523         uint256 tAmount,
524         uint256 redisFee,
525         uint256 taxFee
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 tFee = tAmount.mul(redisFee).div(100);
536         uint256 tTeam = tAmount.mul(taxFee).div(100);
537         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
538 
539         return (tTransferAmount, tFee, tTeam);
540     }
541 
542     function _getRValues(
543         uint256 tAmount,
544         uint256 tFee,
545         uint256 tTeam,
546         uint256 currentRate
547     )
548         private
549         pure
550         returns (
551             uint256,
552             uint256,
553             uint256
554         )
555     {
556         uint256 rAmount = tAmount.mul(currentRate);
557         uint256 rFee = tFee.mul(currentRate);
558         uint256 rTeam = tTeam.mul(currentRate);
559         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
560 
561         return (rAmount, rTransferAmount, rFee);
562     }
563 
564     function _getRate() private view returns (uint256) {
565         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
566 
567         return rSupply.div(tSupply);
568     }
569 
570     function _getCurrentSupply() private view returns (uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;
573         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
574 
575         return (rSupply, tSupply);
576     }
577 
578     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
579         _redisFeeOnBuy = redisFeeOnBuy;
580         _redisFeeOnSell = redisFeeOnSell;
581 
582         _taxFeeOnBuy = taxFeeOnBuy;
583         _taxFeeOnSell = taxFeeOnSell;
584     }
585 
586     //Set minimum tokens required to swap.
587     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
588         _swapTokensAtAmount = swapTokensAtAmount;
589     }
590 
591     //Set minimum tokens required to swap.
592     function toggleSwap(bool _swapEnabled) public onlyOwner {
593         swapEnabled = _swapEnabled;
594     }
595 
596 
597     //Set MAx transaction
598     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
599         _maxTxAmount = maxTxAmount;
600     }
601 
602     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
603         _maxWalletSize = maxWalletSize;
604     }
605 
606     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
607         for(uint256 i = 0; i < accounts.length; i++) {
608             _isExcludedFromFee[accounts[i]] = excluded;
609         }
610     }
611 }