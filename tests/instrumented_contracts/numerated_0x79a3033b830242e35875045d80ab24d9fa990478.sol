1 /**
2 
3 Telegram Portal: https://t.me/redactedcoin
4 Twitter: https://twitter.com/redactederc
5 Web: https://redactedcoin.com/
6 
7 ▄▄███▄▄·██████╗ ███████╗██████╗  █████╗  ██████╗████████╗
8 ██╔════╝██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
9 ███████╗██████╔╝█████╗  ██║  ██║███████║██║        ██║   
10 ╚════██║██╔══██╗██╔══╝  ██║  ██║██╔══██║██║        ██║   
11 ███████║██║  ██║███████╗██████╔╝██║  ██║╚██████╗   ██║   
12 ╚═▀▀▀══╝╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝   ╚═╝   
13                                                          
14 
15 
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 pragma solidity ^0.8.14;
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28 
29     function balanceOf(address account) external view returns (uint256);
30 
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49 }
50 
51 contract Ownable is Context {
52     address private _owner;
53     address private _previousOwner;
54     event OwnershipTransferred(
55         address indexed previousOwner,
56         address indexed newOwner
57     );
58 
59     constructor() {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 
85 }
86 
87 library SafeMath {
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91         return c;
92     }
93 
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return sub(a, b, "SafeMath: subtraction overflow");
96     }
97 
98     function sub(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b <= a, errorMessage);
104         uint256 c = a - b;
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         if (a == 0) {
110             return 0;
111         }
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114         return c;
115     }
116 
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     function div(
122         uint256 a,
123         uint256 b,
124         string memory errorMessage
125     ) internal pure returns (uint256) {
126         require(b > 0, errorMessage);
127         uint256 c = a / b;
128         return c;
129     }
130 }
131 
132 interface IUniswapV2Factory {
133     function createPair(address tokenA, address tokenB)
134         external
135         returns (address pair);
136 }
137 
138 interface IUniswapV2Router02 {
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint256 amountIn,
141         uint256 amountOutMin,
142         address[] calldata path,
143         address to,
144         uint256 deadline
145     ) external;
146 
147     function factory() external pure returns (address);
148 
149     function WETH() external pure returns (address);
150 
151     function addLiquidityETH(
152         address token,
153         uint256 amountTokenDesired,
154         uint256 amountTokenMin,
155         uint256 amountETHMin,
156         address to,
157         uint256 deadline
158     )
159         external
160         payable
161         returns (
162             uint256 amountToken,
163             uint256 amountETH,
164             uint256 liquidity
165         );
166 }
167 
168 contract redacted is Context, IERC20, Ownable {
169 
170     using SafeMath for uint256;
171 
172     string private constant _name = "REDACTED";
173     string private constant _symbol = "REDACT";
174     uint8 private constant _decimals = 9;
175 
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181     uint256 private constant _tTotal = 1000000000 * 10**9; // - 100%
182     uint256 private _rTotal = (MAX - (MAX % _tTotal));
183     uint256 private _tFeeTotal;
184     uint256 private _redisFeeOnBuy = 0;
185     uint256 private _taxFeeOnBuy = 25;
186     uint256 private _redisFeeOnSell = 0;
187     uint256 private _taxFeeOnSell = 25;
188 
189     //Original Fee
190     uint256 private _redisFee = _redisFeeOnSell;
191     uint256 private _taxFee = _taxFeeOnSell;
192 
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195 
196     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
197     mapping (address => bool) public preTrader;
198     address payable private _developmentAddress = payable(0x1c463503d28747326992880b94B048fef40A336E);
199     address payable private _marketingAddress = payable(0xe67B0b39333D27389D5b082A9916254088148f97);
200 
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203 
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = false;
207 
208     uint256 public _maxTxAmount = 2000000 * 10**9; // - 2%
209     uint256 public _maxWalletSize = 6000000 * 10**9; // - 2%
210     uint256 public _swapTokensAtAmount = 50000 * 10**9;
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
348         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
349 
350             //Trade start check
351             if (!tradingOpen) {
352                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
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
595     function allowPreTrading(address[] calldata accounts) public onlyOwner {
596         for(uint256 i = 0; i < accounts.length; i++) {
597                  preTrader[accounts[i]] = true;
598         }
599     }
600 
601     function removePreTrading(address[] calldata accounts) public onlyOwner {
602         for(uint256 i = 0; i < accounts.length; i++) {
603                  delete preTrader[accounts[i]];
604         }
605     }
606 }