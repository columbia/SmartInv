1 /*
2 
3 AI Capital. Combining VC and AI.
4 
5 Revitalizing the Venture Capital model and revolutionizing it through a new model of seperate funds with different focuses, we aim to build the biggest and most transparent DeFi fund of 2023. 
6 
7 Our investments are done through the help of AI-powered decisions.
8 
9 Returns of our investments are allocated back to the community through buybacks and reinvestments.
10 
11 10,000,000 Total Supply
12 4% Tax
13 Locked Liquidity
14 Renounced CA
15 
16 t.me/aicapitalportal
17 twitter.com/aicapitaleth
18 www.aicapitaleth.com
19 
20 */
21 
22 // SPDX-License-Identifier: UNLICENSED
23 pragma solidity ^0.8.4;
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
173 contract AICAP is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
174 
175     using SafeMath for uint256;
176 
177     string private constant _name = "AI Capital";//////////////////////////
178     string private constant _symbol = "AICAP";//////////////////////////////////////////////////////////////////////////
179     uint8 private constant _decimals = 9;
180 
181     mapping(address => uint256) private _rOwned;
182     mapping(address => uint256) private _tOwned;
183     mapping(address => mapping(address => uint256)) private _allowances;
184     mapping(address => bool) private _isExcludedFromFee;
185     uint256 private constant MAX = ~uint256(0);
186     uint256 private constant _tTotal = 10000000 * 10**9;
187     uint256 private _rTotal = (MAX - (MAX % _tTotal));
188     uint256 private _tFeeTotal;
189 
190     //Buy Fee
191     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
192     uint256 private _taxFeeOnBuy = 10;//////////////////////////////////////////////////////////////////////
193 
194     //Sell Fee
195     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
196     uint256 private _taxFeeOnSell = 30;/////////////////////////////////////////////////////////////////////
197 
198     //Original Fee
199     uint256 private _redisFee = _redisFeeOnSell;
200     uint256 private _taxFee = _taxFeeOnSell;
201 
202     uint256 private _previousredisFee = _redisFee;
203     uint256 private _previoustaxFee = _taxFee;
204 
205     mapping(address => bool) public bots;
206     mapping(address => uint256) private cooldown;
207 
208     address payable private _developmentAddress = payable(0xCFF3dCD1be45a34A4702f12D39c8B38B8f1F4719);/////////////////////////////////////////////////
209     address payable private _marketingAddress = payable(0xaBd77e70ea4cfF6184468F484e4B69F455E10cea);///////////////////////////////////////////////////
210 
211     IUniswapV2Router02 public uniswapV2Router;
212     address public uniswapV2Pair;
213 
214     bool private tradingOpen;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217 
218     uint256 public _maxTxAmount = 200000 * 10**9; //2%
219     uint256 public _maxWalletSize = 200000 * 10**9; //2%
220     uint256 public _swapTokensAtAmount = 40000 * 10**9; //.4%
221 
222     event MaxTxAmountUpdated(uint256 _maxTxAmount);
223     modifier lockTheSwap {
224         inSwap = true;
225         _;
226         inSwap = false;
227     }
228 
229     constructor() {
230 
231         _rOwned[_msgSender()] = _rTotal;
232 
233         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
234         uniswapV2Router = _uniswapV2Router;
235         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
236             .createPair(address(this), _uniswapV2Router.WETH());
237 
238         _isExcludedFromFee[owner()] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[_developmentAddress] = true;
241         _isExcludedFromFee[_marketingAddress] = true;
242 
243 
244 
245 
246         emit Transfer(address(0), _msgSender(), _tTotal);
247     }
248 
249     function name() public pure returns (string memory) {
250         return _name;
251     }
252 
253     function symbol() public pure returns (string memory) {
254         return _symbol;
255     }
256 
257     function decimals() public pure returns (uint8) {
258         return _decimals;
259     }
260 
261     function totalSupply() public pure override returns (uint256) {
262         return _tTotal;
263     }
264 
265     function balanceOf(address account) public view override returns (uint256) {
266         return tokenFromReflection(_rOwned[account]);
267     }
268 
269     function transfer(address recipient, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _transfer(_msgSender(), recipient, amount);
275         return true;
276     }
277 
278     function allowance(address owner, address spender)
279         public
280         view
281         override
282         returns (uint256)
283     {
284         return _allowances[owner][spender];
285     }
286 
287     function approve(address spender, uint256 amount)
288         public
289         override
290         returns (bool)
291     {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295 
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(
303             sender,
304             _msgSender(),
305             _allowances[sender][_msgSender()].sub(
306                 amount,
307                 "ERC20: transfer amount exceeds allowance"
308             )
309         );
310         return true;
311     }
312 
313     function tokenFromReflection(uint256 rAmount)
314         private
315         view
316         returns (uint256)
317     {
318         require(
319             rAmount <= _rTotal,
320             "Amount must be less than total reflections"
321         );
322         uint256 currentRate = _getRate();
323         return rAmount.div(currentRate);
324     }
325 
326     function removeAllFee() private {
327         if (_redisFee == 0 && _taxFee == 0) return;
328 
329         _previousredisFee = _redisFee;
330         _previoustaxFee = _taxFee;
331 
332         _redisFee = 0;
333         _taxFee = 0;
334     }
335 
336     function restoreAllFee() private {
337         _redisFee = _previousredisFee;
338         _taxFee = _previoustaxFee;
339     }
340 
341     function _approve(
342         address owner,
343         address spender,
344         uint256 amount
345     ) private {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351 
352     function _transfer(
353         address from,
354         address to,
355         uint256 amount
356     ) private {
357         require(from != address(0), "ERC20: transfer from the zero address");
358         require(to != address(0), "ERC20: transfer to the zero address");
359         require(amount > 0, "Transfer amount must be greater than zero");
360 
361         if (from != owner() && to != owner()) {
362 
363             //Trade start check
364             if (!tradingOpen) {
365                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
366             }
367 
368             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
369             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
370 
371             if(to != uniswapV2Pair) {
372                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
373             }
374 
375             uint256 contractTokenBalance = balanceOf(address(this));
376             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
377 
378             if(contractTokenBalance >= _maxTxAmount)
379             {
380                 contractTokenBalance = _maxTxAmount;
381             }
382 
383             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
384                 swapTokensForEth(contractTokenBalance);
385                 uint256 contractETHBalance = address(this).balance;
386                 if (contractETHBalance > 0) {
387                     sendETHToFee(address(this).balance);
388                 }
389             }
390         }
391 
392         bool takeFee = true;
393 
394         //Transfer Tokens
395         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
396             takeFee = false;
397         } else {
398 
399             //Set Fee for Buys
400             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnBuy;
402                 _taxFee = _taxFeeOnBuy;
403             }
404 
405             //Set Fee for Sells
406             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnSell;
408                 _taxFee = _taxFeeOnSell;
409             }
410 
411         }
412 
413         _tokenTransfer(from, to, amount, takeFee);
414     }
415 
416     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
417         address[] memory path = new address[](2);
418         path[0] = address(this);
419         path[1] = uniswapV2Router.WETH();
420         _approve(address(this), address(uniswapV2Router), tokenAmount);
421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
422             tokenAmount,
423             0,
424             path,
425             address(this),
426             block.timestamp
427         );
428     }
429 
430     function sendETHToFee(uint256 amount) private {
431         _developmentAddress.transfer(amount.div(2));
432         _marketingAddress.transfer(amount.div(2));
433     }
434 
435     function setTrading(bool _tradingOpen) public onlyOwner {
436         tradingOpen = _tradingOpen;
437     }
438 
439     function manualswap() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractBalance = balanceOf(address(this));
442         swapTokensForEth(contractBalance);
443     }
444 
445     function manualsend() external {
446         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
447         uint256 contractETHBalance = address(this).balance;
448         sendETHToFee(contractETHBalance);
449     }
450 
451     function blockBots(address[] memory bots_) public onlyOwner {
452         for (uint256 i = 0; i < bots_.length; i++) {
453             bots[bots_[i]] = true;
454         }
455     }
456 
457     function unblockBot(address notbot) public onlyOwner {
458         bots[notbot] = false;
459     }
460 
461     function _tokenTransfer(
462         address sender,
463         address recipient,
464         uint256 amount,
465         bool takeFee
466     ) private {
467         if (!takeFee) removeAllFee();
468         _transferStandard(sender, recipient, amount);
469         if (!takeFee) restoreAllFee();
470     }
471 
472     function _transferStandard(
473         address sender,
474         address recipient,
475         uint256 tAmount
476     ) private {
477         (
478             uint256 rAmount,
479             uint256 rTransferAmount,
480             uint256 rFee,
481             uint256 tTransferAmount,
482             uint256 tFee,
483             uint256 tTeam
484         ) = _getValues(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeTeam(tTeam);
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491 
492     function _takeTeam(uint256 tTeam) private {
493         uint256 currentRate = _getRate();
494         uint256 rTeam = tTeam.mul(currentRate);
495         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
496     }
497 
498     function _reflectFee(uint256 rFee, uint256 tFee) private {
499         _rTotal = _rTotal.sub(rFee);
500         _tFeeTotal = _tFeeTotal.add(tFee);
501     }
502 
503     receive() external payable {}
504 
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
518             _getTValues(tAmount, _redisFee, _taxFee);
519         uint256 currentRate = _getRate();
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
521             _getRValues(tAmount, tFee, tTeam, currentRate);
522 
523         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
524     }
525 
526     function _getTValues(
527         uint256 tAmount,
528         uint256 redisFee,
529         uint256 taxFee
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 tFee = tAmount.mul(redisFee).div(100);
540         uint256 tTeam = tAmount.mul(taxFee).div(100);
541         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
542 
543         return (tTransferAmount, tFee, tTeam);
544     }
545 
546     function _getRValues(
547         uint256 tAmount,
548         uint256 tFee,
549         uint256 tTeam,
550         uint256 currentRate
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTeam = tTeam.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
564 
565         return (rAmount, rTransferAmount, rFee);
566     }
567 
568     function _getRate() private view returns (uint256) {
569         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
570 
571         return rSupply.div(tSupply);
572     }
573 
574     function _getCurrentSupply() private view returns (uint256, uint256) {
575         uint256 rSupply = _rTotal;
576         uint256 tSupply = _tTotal;
577         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
578 
579         return (rSupply, tSupply);
580     }
581 
582     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
583         _redisFeeOnBuy = redisFeeOnBuy;
584         _redisFeeOnSell = redisFeeOnSell;
585 
586         _taxFeeOnBuy = taxFeeOnBuy;
587         _taxFeeOnSell = taxFeeOnSell;
588     }
589 
590     //Set minimum tokens required to swap.
591     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
592         _swapTokensAtAmount = swapTokensAtAmount;
593     }
594 
595     //Set minimum tokens required to swap.
596     function toggleSwap(bool _swapEnabled) public onlyOwner {
597         swapEnabled = _swapEnabled;
598     }
599 
600 
601     //Set MAx transaction
602     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
603         _maxTxAmount = maxTxAmount;
604     }
605 
606     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
607         _maxWalletSize = maxWalletSize;
608     }
609 
610     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
611         for(uint256 i = 0; i < accounts.length; i++) {
612             _isExcludedFromFee[accounts[i]] = excluded;
613         }
614     }
615 }