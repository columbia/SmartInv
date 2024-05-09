1 /**
2 
3 0xWhale 🐋 🤖
4 
5 0xWhale is a TG bot that acts as an automated whale group creation and management system for Ethereum projects. Through blockchain and API tech, holders over a certain % holding can be smart-verified and auto-kicked when they sell their holdings to below the chosen % threshold. Create a whale group for your project today! 
6 
7 Tax: 3%
8 Total Supply: 1M $WHALE 
9 Max Wallet: 30K $WHALE 
10 Initial LP: 1 ETH 
11 
12 Website: https://0xwhale.tech
13 
14 Telegram: https://t.me/ZeroXWhale
15 
16 Bot: https://t.me/ZeroXWhaleBot
17 
18 Twitter: https://twitter.com/ZeroXWhale
19 
20 */
21 
22 // SPDX-License-Identifier: Unlicensed
23 
24 pragma solidity 0.8.19;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function approve(address spender, uint256 amount) external returns (bool);
42 
43     function transferFrom(
44         address sender,
45         address recipient,
46         uint256 amount
47     ) external returns (bool);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(
51         address indexed owner,
52         address indexed spender,
53         uint256 value
54     );
55 }
56 
57 contract Ownable is Context {
58     address private _owner;
59     address private _previousOwner;
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     constructor() {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 
91 }
92 
93 library SafeMath {
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) {
116             return 0;
117         }
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     function div(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         return c;
135     }
136 }
137 
138 interface IUniswapV2Factory {
139     function createPair(address tokenA, address tokenB)
140         external
141         returns (address pair);
142 }
143 
144 interface IUniswapV2Router02 {
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint256 amountIn,
147         uint256 amountOutMin,
148         address[] calldata path,
149         address to,
150         uint256 deadline
151     ) external;
152 
153     function factory() external pure returns (address);
154 
155     function WETH() external pure returns (address);
156 
157     function addLiquidityETH(
158         address token,
159         uint256 amountTokenDesired,
160         uint256 amountTokenMin,
161         uint256 amountETHMin,
162         address to,
163         uint256 deadline
164     )
165         external
166         payable
167         returns (
168             uint256 amountToken,
169             uint256 amountETH,
170             uint256 liquidity
171         );
172 }
173 
174 contract ZeroXWhale is Context, IERC20, Ownable { //69
175 
176     using SafeMath for uint256;
177 
178     string private constant _name = "0xWhale";
179     string private constant _symbol = "WHALE";
180     uint8 private constant _decimals = 9;
181 
182     mapping(address => uint256) private _rOwned;
183     mapping(address => uint256) private _tOwned;
184     mapping(address => mapping(address => uint256)) private _allowances;
185     mapping(address => bool) private _isExcludedFromFee;
186     uint256 private constant MAX = ~uint256(0);
187     uint256 private constant _tTotal = 1000000 * 10**9;
188     uint256 private _rTotal = (MAX - (MAX % _tTotal));
189     uint256 private _tFeeTotal;
190     uint256 private _redisFeeOnBuy = 0;
191     uint256 private _taxFeeOnBuy = 40;
192     uint256 private _redisFeeOnSell = 0;
193     uint256 private _taxFeeOnSell = 80;
194 
195     //Original Fee
196     uint256 private _redisFee = _redisFeeOnSell;
197     uint256 private _taxFee = _taxFeeOnSell;
198 
199     uint256 private _previousredisFee = _redisFee;
200     uint256 private _previoustaxFee = _taxFee;
201 
202     mapping (address => uint256) public _buyMap;
203     address payable private _developmentAddress = payable(0x6e256DA404b7857De8D486a73f78CA628fcc0745);
204     address payable private _marketingAddress = payable(0x6e256DA404b7857De8D486a73f78CA628fcc0745);
205 
206 
207     IUniswapV2Router02 public uniswapV2Router;
208     address public uniswapV2Pair;
209 
210     bool private tradingOpen = true;
211     bool private inSwap = false;
212     bool private swapEnabled = true;
213 
214     uint256 public _maxTxAmount = 30000 * 10**9;
215     uint256 public _maxWalletSize = 30000 * 10**9;
216     uint256 public _swapTokensAtAmount = 10000 * 10**9;
217 
218     event MaxTxAmountUpdated(uint256 _maxTxAmount);
219     modifier lockTheSwap {
220         inSwap = true;
221         _;
222         inSwap = false;
223     }
224 
225     constructor() {
226 
227         _rOwned[_msgSender()] = _rTotal;
228 
229         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // uniswap: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D , pancakeswap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
230         uniswapV2Router = _uniswapV2Router;
231         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
232             .createPair(address(this), _uniswapV2Router.WETH());
233 
234         _isExcludedFromFee[owner()] = true;
235         _isExcludedFromFee[address(this)] = true;
236         _isExcludedFromFee[_developmentAddress] = true;
237         _isExcludedFromFee[_marketingAddress] = true;
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
423         _marketingAddress.transfer(amount);
424     }
425 
426     function setTrading(bool _tradingOpen) public onlyOwner {
427         tradingOpen = _tradingOpen;
428     }
429 
430     function manualswap() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435 
436     function manualsend() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractETHBalance = address(this).balance;
439         sendETHToFee(contractETHBalance);
440     }
441 
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount,
446         bool takeFee
447     ) private {
448         if (!takeFee) removeAllFee();
449         _transferStandard(sender, recipient, amount);
450         if (!takeFee) restoreAllFee();
451     }
452 
453     function _transferStandard(
454         address sender,
455         address recipient,
456         uint256 tAmount
457     ) private {
458         (
459             uint256 rAmount,
460             uint256 rTransferAmount,
461             uint256 rFee,
462             uint256 tTransferAmount,
463             uint256 tFee,
464             uint256 tTeam
465         ) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
468         _takeTeam(tTeam);
469         _reflectFee(rFee, tFee);
470         emit Transfer(sender, recipient, tTransferAmount);
471     }
472 
473     function _takeTeam(uint256 tTeam) private {
474         uint256 currentRate = _getRate();
475         uint256 rTeam = tTeam.mul(currentRate);
476         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
477     }
478 
479     function _reflectFee(uint256 rFee, uint256 tFee) private {
480         _rTotal = _rTotal.sub(rFee);
481         _tFeeTotal = _tFeeTotal.add(tFee);
482     }
483 
484     receive() external payable {}
485 
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
499             _getTValues(tAmount, _redisFee, _taxFee);
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
502             _getRValues(tAmount, tFee, tTeam, currentRate);
503         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getTValues(
507         uint256 tAmount,
508         uint256 redisFee,
509         uint256 taxFee
510     )
511         private
512         pure
513         returns (
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         uint256 tFee = tAmount.mul(redisFee).div(100);
520         uint256 tTeam = tAmount.mul(taxFee).div(100);
521         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
522         return (tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getRValues(
526         uint256 tAmount,
527         uint256 tFee,
528         uint256 tTeam,
529         uint256 currentRate
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 rAmount = tAmount.mul(currentRate);
540         uint256 rFee = tFee.mul(currentRate);
541         uint256 rTeam = tTeam.mul(currentRate);
542         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
543         return (rAmount, rTransferAmount, rFee);
544     }
545 
546     function _getRate() private view returns (uint256) {
547         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
548         return rSupply.div(tSupply);
549     }
550 
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555         return (rSupply, tSupply);
556     }
557 
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561         _taxFeeOnBuy = taxFeeOnBuy;
562         _taxFeeOnSell = taxFeeOnSell;
563     }
564 
565     //Set minimum tokens required to swap.
566     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
567         _swapTokensAtAmount = swapTokensAtAmount;
568     }
569 
570     //Set minimum tokens required to swap.
571     function toggleSwap(bool _swapEnabled) public onlyOwner {
572         swapEnabled = _swapEnabled;
573     }
574 
575     //Set maximum transaction
576     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
577         _maxTxAmount = maxTxAmount;
578     }
579 
580     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
581         _maxWalletSize = maxWalletSize;
582     }
583 
584     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
585         for(uint256 i = 0; i < accounts.length; i++) {
586             _isExcludedFromFee[accounts[i]] = excluded;
587         }
588     }
589 
590 }