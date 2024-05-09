1 /**
2 
3 */
4 
5 // TELEGRAM:https://t.me/theamericanvitalik
6 
7 
8 /**
9 
10 */
11 
12 /**
13 
14 
15 
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 pragma solidity ^0.8.9;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address account) external view returns (uint256);
31 
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54     address private _previousOwner;
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 
86 }
87 
88 library SafeMath {
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106         return c;
107     }
108 
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         return c;
130     }
131 }
132 
133 interface IUniswapV2Factory {
134     function createPair(address tokenA, address tokenB)
135         external
136         returns (address pair);
137 }
138 
139 interface IUniswapV2Router02 {
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint256 amountIn,
142         uint256 amountOutMin,
143         address[] calldata path,
144         address to,
145         uint256 deadline
146     ) external;
147 
148     function factory() external pure returns (address);
149 
150     function WETH() external pure returns (address);
151 
152     function addLiquidityETH(
153         address token,
154         uint256 amountTokenDesired,
155         uint256 amountTokenMin,
156         uint256 amountETHMin,
157         address to,
158         uint256 deadline
159     )
160         external
161         payable
162         returns (
163             uint256 amountToken,
164             uint256 amountETH,
165             uint256 liquidity
166         );
167 }
168 
169 contract THEAmericanVitalik is Context, IERC20, Ownable {
170 
171     using SafeMath for uint256;
172 
173     string private constant _name = unicode"THE AMERICAN VITALIK";
174     string private constant _symbol = unicode"THEV";
175     uint8 private constant _decimals = 9;
176 
177     mapping(address => uint256) private _rOwned;
178     mapping(address => uint256) private _tOwned;
179     mapping(address => mapping(address => uint256)) private _allowances;
180     mapping(address => bool) private _isExcludedFromFee;
181     uint256 private constant MAX = ~uint256(0);
182     uint256 private constant _tTotal = 1000000000 * 10**9;
183     uint256 private _rTotal = (MAX - (MAX % _tTotal));
184     uint256 private _tFeeTotal;
185     uint256 private _redisFeeOnBuy = 0;
186     uint256 private _taxFeeOnBuy = 3;
187     uint256 private _redisFeeOnSell = 0;
188     uint256 private _taxFeeOnSell = 3;
189 
190     //Original Fee
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193 
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196 
197     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
198     address payable private _developmentAddress = payable(0xC6c2aac7996d6670C25Ea821816D67AaDB6e89e3);
199     address payable private _marketingAddress = payable(0xC6c2aac7996d6670C25Ea821816D67AaDB6e89e3);
200 
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203 
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207 
208     uint256 public _maxTxAmount = 20000000 * 10**9;
209     uint256 public _maxWalletSize = 20000000 * 10**9;
210     uint256 public _swapTokensAtAmount = 10000 * 10**9;
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
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227 
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_developmentAddress] = true;
231         _isExcludedFromFee[_marketingAddress] = true;
232 
233         emit Transfer(address(0), _msgSender(), _tTotal);
234     }
235 
236     function name() public pure returns (string memory) {
237         return _name;
238     }
239 
240     function symbol() public pure returns (string memory) {
241         return _symbol;
242     }
243 
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247 
248     function totalSupply() public pure override returns (uint256) {
249         return _tTotal;
250     }
251 
252     function balanceOf(address account) public view override returns (uint256) {
253         return tokenFromReflection(_rOwned[account]);
254     }
255 
256     function transfer(address recipient, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     function allowance(address owner, address spender)
266         public
267         view
268         override
269         returns (uint256)
270     {
271         return _allowances[owner][spender];
272     }
273 
274     function approve(address spender, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public override returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(
290             sender,
291             _msgSender(),
292             _allowances[sender][_msgSender()].sub(
293                 amount,
294                 "ERC20: transfer amount exceeds allowance"
295             )
296         );
297         return true;
298     }
299 
300     function tokenFromReflection(uint256 rAmount)
301         private
302         view
303         returns (uint256)
304     {
305         require(
306             rAmount <= _rTotal,
307             "Amount must be less than total reflections"
308         );
309         uint256 currentRate = _getRate();
310         return rAmount.div(currentRate);
311     }
312 
313     function removeAllFee() private {
314         if (_redisFee == 0 && _taxFee == 0) return;
315 
316         _previousredisFee = _redisFee;
317         _previoustaxFee = _taxFee;
318 
319         _redisFee = 0;
320         _taxFee = 0;
321     }
322 
323     function restoreAllFee() private {
324         _redisFee = _previousredisFee;
325         _taxFee = _previoustaxFee;
326     }
327 
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338 
339     function _transfer(
340         address from,
341         address to,
342         uint256 amount
343     ) private {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346         require(amount > 0, "Transfer amount must be greater than zero");
347 
348         if (from != owner() && to != owner()) {
349 
350             //Trade start check
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
381         //Transfer Tokens
382         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
383             takeFee = false;
384         } else {
385 
386             //Set Fee for Buys
387             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
388                 _redisFee = _redisFeeOnBuy;
389                 _taxFee = _taxFeeOnBuy;
390             }
391 
392             //Set Fee for Sells
393             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
394                 _redisFee = _redisFeeOnSell;
395                 _taxFee = _taxFeeOnSell;
396             }
397 
398         }
399 
400         _tokenTransfer(from, to, amount, takeFee);
401     }
402 
403     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
404         address[] memory path = new address[](2);
405         path[0] = address(this);
406         path[1] = uniswapV2Router.WETH();
407         _approve(address(this), address(uniswapV2Router), tokenAmount);
408         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
409             tokenAmount,
410             0,
411             path,
412             address(this),
413             block.timestamp
414         );
415     }
416 
417     function sendETHToFee(uint256 amount) private {
418         _marketingAddress.transfer(amount);
419     }
420 
421     function setTrading(bool _tradingOpen) public onlyOwner {
422         tradingOpen = _tradingOpen;
423     }
424 
425     function manualswap() external {
426         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
427         uint256 contractBalance = balanceOf(address(this));
428         swapTokensForEth(contractBalance);
429     }
430 
431     function manualsend() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractETHBalance = address(this).balance;
434         sendETHToFee(contractETHBalance);
435     }
436 
437     function blockBots(address[] memory bots_) public onlyOwner {
438         for (uint256 i = 0; i < bots_.length; i++) {
439             bots[bots_[i]] = true;
440         }
441     }
442 
443     function unblockBot(address notbot) public onlyOwner {
444         bots[notbot] = false;
445     }
446 
447     function _tokenTransfer(
448         address sender,
449         address recipient,
450         uint256 amount,
451         bool takeFee
452     ) private {
453         if (!takeFee) removeAllFee();
454         _transferStandard(sender, recipient, amount);
455         if (!takeFee) restoreAllFee();
456     }
457 
458     function _transferStandard(
459         address sender,
460         address recipient,
461         uint256 tAmount
462     ) private {
463         (
464             uint256 rAmount,
465             uint256 rTransferAmount,
466             uint256 rFee,
467             uint256 tTransferAmount,
468             uint256 tFee,
469             uint256 tTeam
470         ) = _getValues(tAmount);
471         _rOwned[sender] = _rOwned[sender].sub(rAmount);
472         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
473         _takeTeam(tTeam);
474         _reflectFee(rFee, tFee);
475         emit Transfer(sender, recipient, tTransferAmount);
476     }
477 
478     function _takeTeam(uint256 tTeam) private {
479         uint256 currentRate = _getRate();
480         uint256 rTeam = tTeam.mul(currentRate);
481         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
482     }
483 
484     function _reflectFee(uint256 rFee, uint256 tFee) private {
485         _rTotal = _rTotal.sub(rFee);
486         _tFeeTotal = _tFeeTotal.add(tFee);
487     }
488 
489     receive() external payable {}
490 
491     function _getValues(uint256 tAmount)
492         private
493         view
494         returns (
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
504             _getTValues(tAmount, _redisFee, _taxFee);
505         uint256 currentRate = _getRate();
506         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
507             _getRValues(tAmount, tFee, tTeam, currentRate);
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
527         return (tTransferAmount, tFee, tTeam);
528     }
529 
530     function _getRValues(
531         uint256 tAmount,
532         uint256 tFee,
533         uint256 tTeam,
534         uint256 currentRate
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 rAmount = tAmount.mul(currentRate);
545         uint256 rFee = tFee.mul(currentRate);
546         uint256 rTeam = tTeam.mul(currentRate);
547         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
548         return (rAmount, rTransferAmount, rFee);
549     }
550 
551     function _getRate() private view returns (uint256) {
552         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
553         return rSupply.div(tSupply);
554     }
555 
556     function _getCurrentSupply() private view returns (uint256, uint256) {
557         uint256 rSupply = _rTotal;
558         uint256 tSupply = _tTotal;
559         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
560         return (rSupply, tSupply);
561     }
562 
563     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
564         _redisFeeOnBuy = redisFeeOnBuy;
565         _redisFeeOnSell = redisFeeOnSell;
566         _taxFeeOnBuy = taxFeeOnBuy;
567         _taxFeeOnSell = taxFeeOnSell;
568     }
569 
570     //Set minimum tokens required to swap.
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574 
575     //Set minimum tokens required to swap.
576     function toggleSwap(bool _swapEnabled) public onlyOwner {
577         swapEnabled = _swapEnabled;
578     }
579 
580     //Set maximum transaction
581     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
582         _maxTxAmount = maxTxAmount;
583     }
584 
585     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
586         _maxWalletSize = maxWalletSize;
587     }
588 
589     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
590         for(uint256 i = 0; i < accounts.length; i++) {
591             _isExcludedFromFee[accounts[i]] = excluded;
592         }
593     }
594 
595 }