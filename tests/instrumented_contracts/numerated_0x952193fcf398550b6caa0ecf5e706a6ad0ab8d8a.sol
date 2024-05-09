1 /*
2 
3 Sekiro - A New Beginning
4 
5 www.sekiroeth.com
6 t.me/sekiroportal
7 twitter.com/sekiroeth
8 sekiro.gitbook.io/sekiro-whitepaper-v1.0-1/introduction/a-new-beginning
9 
10 */
11 
12 // SPDX-License-Identifier: UNLICENSED
13 pragma solidity ^0.8.4;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 
80 }
81 
82 library SafeMath {
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     function div(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         return c;
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB)
129         external
130         returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint256 amountIn,
136         uint256 amountOutMin,
137         address[] calldata path,
138         address to,
139         uint256 deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 }
162 
163 contract SEKIRO is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
164 
165     using SafeMath for uint256;
166 
167     string private constant _name = "Sekiro";//////////////////////////
168     string private constant _symbol = "SEKIRO";//////////////////////////////////////////////////////////////////////////
169     uint8 private constant _decimals = 9;
170 
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 10000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179 
180     //Buy Fee
181     uint256 private _redisFeeOnBuy = 1;////////////////////////////////////////////////////////////////////
182     uint256 private _taxFeeOnBuy = 0;//////////////////////////////////////////////////////////////////////
183 
184     //Sell Fee
185     uint256 private _redisFeeOnSell = 1;/////////////////////////////////////////////////////////////////////
186     uint256 private _taxFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
187 
188     //Original Fee
189     uint256 private _redisFee = _redisFeeOnSell;
190     uint256 private _taxFee = _taxFeeOnSell;
191 
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194 
195     mapping(address => bool) public bots;
196     mapping(address => uint256) private cooldown;
197 
198     address payable private _developmentAddress = payable(0xfA72A5AF5E847eF53C0f2BD6e5CaD4ce5ef26E8c);/////////////////////////////////////////////////
199     address payable private _marketingAddress = payable(0x0Fa6570CCf0401e74A3012012f3CF2F39F0b0f90);///////////////////////////////////////////////////
200 
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203 
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207 
208     uint256 public _maxTxAmount = 200000 * 10**9; //2%
209     uint256 public _maxWalletSize = 200000 * 10**9; //2%
210     uint256 public _swapTokensAtAmount = 40000 * 10**9; //.4%
211 
212     event MaxTxAmountUpdated(uint256 _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218 
219     constructor() {
220 
221         _rOwned[_msgSender()] = _rTotal;
222 
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227 
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_developmentAddress] = true;
231         _isExcludedFromFee[_marketingAddress] = true;
232 
233 
234 
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
590 
591     //Set MAx transaction
592     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
593         _maxTxAmount = maxTxAmount;
594     }
595 
596     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
597         _maxWalletSize = maxWalletSize;
598     }
599 
600     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
601         for(uint256 i = 0; i < accounts.length; i++) {
602             _isExcludedFromFee[accounts[i]] = excluded;
603         }
604     }
605 }