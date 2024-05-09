1 /**
2 
3 Twitter: http://www.twitter.com/HPWLHC69I
4 Telegram: https://t.me/HPWLHC69I
5 Website: https://www.hpwlhc69i.com/
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.15;
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
159 contract SAFEMOON is Context, IERC20, Ownable {
160 
161     using SafeMath for uint256;
162 
163     string private constant _name = "HarryPotterWashingtonLizzoHotCheetos69Inu";
164     string private constant _symbol = "SAFEMOON";
165     uint8 private constant _decimals = 9;
166 
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 100_000_000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 private _redisFeeOnBuy = 0;
176     uint256 private _taxFeeOnBuy = 25;
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 45;
179 
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     mapping (address => bool) public preTrader;
188     address payable private _developmentAddress = payable(0x8cDE5254017E6Fe4D359Abe4abcE1091C1E61D39);
189     address payable private _marketingAddress = payable(0xa7eeD91112F4E9057247CC70F1C8389569910c44);
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193 
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197 
198     uint256 public _maxTxAmount = 2_000_000 * 10**9;
199     uint256 public _maxWalletSize = 2_000_000 * 10**9;
200     uint256 public _swapTokensAtAmount = 40_000 * 10**9;
201 
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor() {
210 
211         _rOwned[_msgSender()] = _rTotal;
212 
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217 
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222 
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225 
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229 
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233 
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237 
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241 
242     function balanceOf(address account) public view override returns (uint256) {
243         return tokenFromReflection(_rOwned[account]);
244     }
245 
246     function transfer(address recipient, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(address owner, address spender)
256         public
257         view
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263 
264     function approve(address spender, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) public override returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(
280             sender,
281             _msgSender(),
282             _allowances[sender][_msgSender()].sub(
283                 amount,
284                 "ERC20: transfer amount exceeds allowance"
285             )
286         );
287         return true;
288     }
289 
290     function tokenFromReflection(uint256 rAmount)
291         private
292         view
293         returns (uint256)
294     {
295         require(
296             rAmount <= _rTotal,
297             "Amount must be less than total reflections"
298         );
299         uint256 currentRate = _getRate();
300         return rAmount.div(currentRate);
301     }
302 
303     function removeAllFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305 
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308 
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312 
313     function restoreAllFee() private {
314         _redisFee = _previousredisFee;
315         _taxFee = _previoustaxFee;
316     }
317 
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337 
338         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
339 
340             //Trade start check
341             if (!tradingOpen) {
342                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344 
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346 
347             if(to != uniswapV2Pair) {
348                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
349             }
350 
351             uint256 contractTokenBalance = balanceOf(address(this));
352             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
353 
354             if(contractTokenBalance >= _swapTokensAtAmount * 20)
355             {
356                 contractTokenBalance = _swapTokensAtAmount * 20;
357             }
358 
359             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
360                 swapTokensForEth(contractTokenBalance);
361                 uint256 contractETHBalance = address(this).balance;
362                 if (contractETHBalance > 0) {
363                     sendETHToFee(address(this).balance);
364                 }
365             }
366         }
367 
368         bool takeFee = true;
369 
370         //Transfer Tokens
371         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
372             takeFee = false;
373         } else {
374 
375             //Set Fee for Buys
376             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnBuy;
378                 _taxFee = _taxFeeOnBuy;
379             }
380 
381             //Set Fee for Sells
382             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnSell;
384                 _taxFee = _taxFeeOnSell;
385             }
386 
387         }
388 
389         _tokenTransfer(from, to, amount, takeFee);
390     }
391 
392     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
393         address[] memory path = new address[](2);
394         path[0] = address(this);
395         path[1] = uniswapV2Router.WETH();
396         _approve(address(this), address(uniswapV2Router), tokenAmount);
397         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
398             tokenAmount,
399             0,
400             path,
401             address(this),
402             block.timestamp
403         );
404     }
405 
406     function sendETHToFee(uint256 amount) private {
407         _marketingAddress.transfer(amount);
408     }
409 
410     function setTrading() public onlyOwner {
411         tradingOpen = true;
412     }
413 
414     function manualswap() external {
415         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
416         uint256 contractBalance = balanceOf(address(this));
417         swapTokensForEth(contractBalance);
418     }
419 
420     function manualsend() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractETHBalance = address(this).balance;
423         sendETHToFee(contractETHBalance);
424     }
425 
426     function _tokenTransfer(
427         address sender,
428         address recipient,
429         uint256 amount,
430         bool takeFee
431     ) private {
432         if (!takeFee) removeAllFee();
433         _transferStandard(sender, recipient, amount);
434         if (!takeFee) restoreAllFee();
435     }
436 
437     function _transferStandard(
438         address sender,
439         address recipient,
440         uint256 tAmount
441     ) private {
442         (
443             uint256 rAmount,
444             uint256 rTransferAmount,
445             uint256 rFee,
446             uint256 tTransferAmount,
447             uint256 tFee,
448             uint256 tTeam
449         ) = _getValues(tAmount);
450         _rOwned[sender] = _rOwned[sender].sub(rAmount);
451         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
452         _takeTeam(tTeam);
453         _reflectFee(rFee, tFee);
454         emit Transfer(sender, recipient, tTransferAmount);
455     }
456 
457     function _takeTeam(uint256 tTeam) private {
458         uint256 currentRate = _getRate();
459         uint256 rTeam = tTeam.mul(currentRate);
460         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
461     }
462 
463     function _reflectFee(uint256 rFee, uint256 tFee) private {
464         _rTotal = _rTotal.sub(rFee);
465         _tFeeTotal = _tFeeTotal.add(tFee);
466     }
467 
468     receive() external payable {}
469 
470     function _getValues(uint256 tAmount)
471         private
472         view
473         returns (
474             uint256,
475             uint256,
476             uint256,
477             uint256,
478             uint256,
479             uint256
480         )
481     {
482         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
483             _getTValues(tAmount, _redisFee, _taxFee);
484         uint256 currentRate = _getRate();
485         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
486             _getRValues(tAmount, tFee, tTeam, currentRate);
487         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
488     }
489 
490     function _getTValues(
491         uint256 tAmount,
492         uint256 redisFee,
493         uint256 taxFee
494     )
495         private
496         pure
497         returns (
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         uint256 tFee = tAmount.mul(redisFee).div(100);
504         uint256 tTeam = tAmount.mul(taxFee).div(100);
505         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
506         return (tTransferAmount, tFee, tTeam);
507     }
508 
509     function _getRValues(
510         uint256 tAmount,
511         uint256 tFee,
512         uint256 tTeam,
513         uint256 currentRate
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 rAmount = tAmount.mul(currentRate);
524         uint256 rFee = tFee.mul(currentRate);
525         uint256 rTeam = tTeam.mul(currentRate);
526         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
527         return (rAmount, rTransferAmount, rFee);
528     }
529 
530     function _getRate() private view returns (uint256) {
531         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
532         return rSupply.div(tSupply);
533     }
534 
535     function _getCurrentSupply() private view returns (uint256, uint256) {
536         uint256 rSupply = _rTotal;
537         uint256 tSupply = _tTotal;
538         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
539         return (rSupply, tSupply);
540     }
541 
542     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
543         require(redisFeeOnBuy + taxFeeOnBuy < 20, "TOKEN: Buy tax too high.");
544         require(redisFeeOnSell + taxFeeOnSell < 20, "TOKEN: Sell tax too high.");
545         _redisFeeOnBuy = redisFeeOnBuy;
546         _redisFeeOnSell = redisFeeOnSell;
547         _taxFeeOnBuy = taxFeeOnBuy;
548         _taxFeeOnSell = taxFeeOnSell;
549     }
550 
551     //Set minimum tokens required to swap.
552     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
553         _swapTokensAtAmount = swapTokensAtAmount;
554     }
555 
556     //Set minimum tokens required to swap.
557     function toggleSwap(bool _swapEnabled) public onlyOwner {
558         swapEnabled = _swapEnabled;
559     }
560 
561     //Set maximum transaction
562     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
563         _maxTxAmount = maxTxAmount;
564     }
565 
566     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
567         _maxWalletSize = maxWalletSize;
568     }
569 
570     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
571         for(uint256 i = 0; i < accounts.length; i++) {
572             _isExcludedFromFee[accounts[i]] = excluded;
573         }
574     }
575 
576     function allowPreTrading(address[] calldata accounts) public onlyOwner {
577         for(uint256 i = 0; i < accounts.length; i++) {
578             preTrader[accounts[i]] = true;
579         }
580     }
581 
582     function removePreTrading(address[] calldata accounts) public onlyOwner {
583         for(uint256 i = 0; i < accounts.length; i++) {
584             delete preTrader[accounts[i]];
585         }
586     }
587 }