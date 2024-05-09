1 /**
2 
3 We've all been there, and it's no fun. 
4 Being someone's exit liquidity right after you aped in. 
5 
6 It sucks. 
7 
8 We're here to make tax work for you, not against you. 
9 We've got your back!
10 
11 Telegram: https://t.me/ExitLPerc
12 Twitter: https://twitter.com/exitlperc/
13 Website: https://exitliquidityerc.com
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.9;
19 
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
168 contract ExitLiquidity is Context, IERC20, Ownable {
169 
170     using SafeMath for uint256;
171 
172     string private constant _name = "Exit Liquidity";
173     string private constant _symbol = "EXITLP";
174     uint8 private constant _decimals = 9;
175 
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181     uint256 private constant _tTotal = 100_000_000 * 10**9;
182     uint256 private _rTotal = (MAX - (MAX % _tTotal));
183     uint256 private _tFeeTotal;
184     uint256 private _redisFeeOnBuy = 0;
185     uint256 private _taxFeeOnBuy = 25;
186     uint256 private _redisFeeOnSell = 1;
187     uint256 private _taxFeeOnSell = 34;
188 
189     //Original Fee
190     uint256 private _redisFee = _redisFeeOnSell;
191     uint256 private _taxFee = _taxFeeOnSell;
192 
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195 
196     address payable private _developmentAddress = payable(0x8affB90436c799C1fa19A13d16cd55fF95f4dF38);
197     address payable private _marketingAddress = payable(0x33bb53A7e25A72B9F967Aaf323e2B8Ea90B51aAa);
198 
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201 
202     bool private tradingOpen = false;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205 
206     uint256 public _maxTxAmount = 2_000_000 * 10**9;
207     uint256 public _maxWalletSize = 2_000_000 * 10**9;
208     uint256 public _swapTokensAtAmount = 30_000 * 10**9;
209 
210     event MaxTxAmountUpdated(uint256 _maxTxAmount);
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216 
217     constructor() {
218         _rOwned[_msgSender()] = _rTotal;
219 
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224 
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_developmentAddress] = true;
228         _isExcludedFromFee[_marketingAddress] = true;
229 
230         emit Transfer(address(0), _msgSender(), _tTotal);
231     }
232 
233     function name() public pure returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public pure returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public pure returns (uint8) {
242         return _decimals;
243     }
244 
245     function totalSupply() public pure override returns (uint256) {
246         return _tTotal;
247     }
248 
249     function balanceOf(address account) public view override returns (uint256) {
250         return tokenFromReflection(_rOwned[account]);
251     }
252 
253     function transfer(address recipient, uint256 amount)
254         public
255         override
256         returns (bool)
257     {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261 
262     function allowance(address owner, address spender)
263         public
264         view
265         override
266         returns (uint256)
267     {
268         return _allowances[owner][spender];
269     }
270 
271     function approve(address spender, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public override returns (bool) {
285         _transfer(sender, recipient, amount);
286         _approve(
287             sender,
288             _msgSender(),
289             _allowances[sender][_msgSender()].sub(
290                 amount,
291                 "ERC20: transfer amount exceeds allowance"
292             )
293         );
294         return true;
295     }
296 
297     function tokenFromReflection(uint256 rAmount)
298         private
299         view
300         returns (uint256)
301     {
302         require(
303             rAmount <= _rTotal,
304             "Amount must be less than total reflections"
305         );
306         uint256 currentRate = _getRate();
307         return rAmount.div(currentRate);
308     }
309 
310     function removeAllFee() private {
311         if (_redisFee == 0 && _taxFee == 0) return;
312 
313         _previousredisFee = _redisFee;
314         _previoustaxFee = _taxFee;
315 
316         _redisFee = 0;
317         _taxFee = 0;
318     }
319 
320     function restoreAllFee() private {
321         _redisFee = _previousredisFee;
322         _taxFee = _previoustaxFee;
323     }
324 
325     function _approve(
326         address owner,
327         address spender,
328         uint256 amount
329     ) private {
330         require(owner != address(0), "ERC20: approve from the zero address");
331         require(spender != address(0), "ERC20: approve to the zero address");
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336     function _transfer(
337         address from,
338         address to,
339         uint256 amount
340     ) private {
341         require(from != address(0), "ERC20: transfer from the zero address");
342         require(to != address(0), "ERC20: transfer to the zero address");
343         require(amount > 0, "Transfer amount must be greater than zero");
344 
345         if (from != owner() && to != owner() && from != _developmentAddress && to != _developmentAddress && from != _marketingAddress && to != _marketingAddress) {
346 
347             //Trade start check
348             if (!tradingOpen) {
349                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
350             }
351 
352             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
353 
354             if(to != uniswapV2Pair) {
355                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
356             }
357 
358             uint256 contractTokenBalance = balanceOf(address(this));
359             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
360 
361             if (contractTokenBalance >= _swapTokensAtAmount * 20)
362             {
363                 contractTokenBalance = _swapTokensAtAmount * 20;
364             }
365 
366             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         }
374 
375         bool takeFee = true;
376 
377         //Transfer Tokens
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381             
382             //Set Fee for Buys
383             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             //Set Fee for Sells
389             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnSell;
391                 _taxFee = _taxFeeOnSell;
392             }
393         }
394 
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397 
398     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = uniswapV2Router.WETH();
402         _approve(address(this), address(uniswapV2Router), tokenAmount);
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0,
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411 
412     function sendETHToFee(uint256 amount) private {
413         _marketingAddress.transfer(amount);
414     }
415 
416     function enableTrading() public onlyOwner {
417         tradingOpen = true;
418     }
419 
420     function manualswap() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractBalance = balanceOf(address(this));
423         swapTokensForEth(contractBalance);
424     }
425 
426     function manualsend() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractETHBalance = address(this).balance;
429         sendETHToFee(contractETHBalance);
430     }
431 
432     function _tokenTransfer(
433         address sender,
434         address recipient,
435         uint256 amount,
436         bool takeFee
437     ) private {
438         if (!takeFee) removeAllFee();
439         _transferStandard(sender, recipient, amount);
440         if (!takeFee) restoreAllFee();
441     }
442 
443     function _transferStandard(
444         address sender,
445         address recipient,
446         uint256 tAmount
447     ) private {
448         (
449             uint256 rAmount,
450             uint256 rTransferAmount,
451             uint256 rFee,
452             uint256 tTransferAmount,
453             uint256 tFee,
454             uint256 tTeam
455         ) = _getValues(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
458         _takeTeam(tTeam);
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462 
463     function _takeTeam(uint256 tTeam) private {
464         uint256 currentRate = _getRate();
465         uint256 rTeam = tTeam.mul(currentRate);
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468 
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473 
474     receive() external payable {}
475 
476     function _getValues(uint256 tAmount)
477         private
478         view
479         returns (
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
489             _getTValues(tAmount, _redisFee, _taxFee);
490         uint256 currentRate = _getRate();
491         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
492             _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495 
496     function _getTValues(
497         uint256 tAmount,
498         uint256 redisFee,
499         uint256 taxFee
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 tFee = tAmount.mul(redisFee).div(100);
510         uint256 tTeam = tAmount.mul(taxFee).div(100);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
512         return (tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533         return (rAmount, rTransferAmount, rFee);
534     }
535 
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538         return rSupply.div(tSupply);
539     }
540 
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547 
548     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
549         _redisFeeOnBuy = redisFeeOnBuy;
550         _redisFeeOnSell = redisFeeOnSell;
551         _taxFeeOnBuy = taxFeeOnBuy;
552         _taxFeeOnSell = taxFeeOnSell;
553         require(_redisFeeOnBuy + _taxFeeOnBuy <= 15, "TOKEN: buy fees should be lower than 15%.");
554         require(_redisFeeOnSell + _taxFeeOnSell <= 20, "TOKEN: sell fees should be lower than 20%.");
555     }
556 
557     //Set minimum tokens required to swap.
558     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
559         _swapTokensAtAmount = swapTokensAtAmount;
560     }
561 
562     function toggleSwap(bool _swapEnabled) public onlyOwner {
563         swapEnabled = _swapEnabled;
564     }
565 
566     //Set maximum transaction
567     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
568         require(maxTxAmount >= (_tTotal / 1000), "Cannot set maxTransactionAmount lower than 0.1%");
569         _maxTxAmount = maxTxAmount;
570     }
571 
572     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
573         require(maxWalletSize >= (_tTotal * 5 / 1000), "Cannot set maxWallet lower than 0.5%");
574         _maxWalletSize = maxWalletSize;
575     }
576 
577     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
578         for(uint256 i = 0; i < accounts.length; i++) {
579             _isExcludedFromFee[accounts[i]] = excluded;
580         }
581     }
582 
583 }