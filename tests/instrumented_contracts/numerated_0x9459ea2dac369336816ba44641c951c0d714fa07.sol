1 /**
2   pepe69.org
3   t.me/pepe69org
4   twitter.com/pepe69org
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.8.9;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15  
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18  
19     function balanceOf(address account) external view returns (uint256);
20  
21     function transfer(address recipient, uint256 amount) external returns (bool);
22  
23     function allowance(address owner, address spender) external view returns (uint256);
24  
25     function approve(address spender, uint256 amount) external returns (bool);
26  
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32  
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40  
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48  
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54  
55     function owner() public view returns (address) {
56         return _owner;
57     }
58  
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63  
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68  
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74  
75 }
76  
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83  
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87  
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97  
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106  
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110  
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121  
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127  
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136  
137     function factory() external pure returns (address);
138  
139     function WETH() external pure returns (address);
140  
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157  
158 contract pepe69 is Context, IERC20, Ownable {
159  
160     using SafeMath for uint256;
161  
162     string private constant _name = "Pepe 6.9";
163     string private constant _symbol = "PEPE6.9";
164     uint8 private constant _decimals = 9;
165  
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 69000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _redisFeeOnBuy = 0;  
175     uint256 private _taxFeeOnBuy = 10;  
176     uint256 private _redisFeeOnSell = 0;  
177     uint256 private _taxFeeOnSell = 15;
178  
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182  
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185  
186     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
187     address payable private _developmentAddress = payable(0x830f65c3dAadAeCa20400Edb7628ad8f8F933812); 
188     address payable private _marketingAddress = payable(0x830f65c3dAadAeCa20400Edb7628ad8f8F933812);
189  
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192  
193     bool private tradingOpen = true;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196  
197     uint256 public _maxTxAmount = 420 * 10**9; 
198     uint256 public _maxWalletSize = 690 * 10**9; 
199     uint256 public _swapTokensAtAmount = 69 * 10**9;
200  
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207  
208     constructor() {
209  
210         _rOwned[_msgSender()] = _rTotal;
211  
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216  
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_developmentAddress] = true;
220         _isExcludedFromFee[_marketingAddress] = true;
221  
222         emit Transfer(address(0), _msgSender(), _tTotal);
223     }
224  
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228  
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232  
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236  
237     function totalSupply() public pure override returns (uint256) {
238         return _tTotal;
239     }
240  
241     function balanceOf(address account) public view override returns (uint256) {
242         return tokenFromReflection(_rOwned[account]);
243     }
244  
245     function transfer(address recipient, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253  
254     function allowance(address owner, address spender)
255         public
256         view
257         override
258         returns (uint256)
259     {
260         return _allowances[owner][spender];
261     }
262  
263     function approve(address spender, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271  
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(
279             sender,
280             _msgSender(),
281             _allowances[sender][_msgSender()].sub(
282                 amount,
283                 "ERC20: transfer amount exceeds allowance"
284             )
285         );
286         return true;
287     }
288  
289     function tokenFromReflection(uint256 rAmount)
290         private
291         view
292         returns (uint256)
293     {
294         require(
295             rAmount <= _rTotal,
296             "Amount must be less than total reflections"
297         );
298         uint256 currentRate = _getRate();
299         return rAmount.div(currentRate);
300     }
301  
302     function removeAllFee() private {
303         if (_redisFee == 0 && _taxFee == 0) return;
304  
305         _previousredisFee = _redisFee;
306         _previoustaxFee = _taxFee;
307  
308         _redisFee = 0;
309         _taxFee = 0;
310     }
311  
312     function restoreAllFee() private {
313         _redisFee = _previousredisFee;
314         _taxFee = _previoustaxFee;
315     }
316  
317     function _approve(
318         address owner,
319         address spender,
320         uint256 amount
321     ) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327  
328     function _transfer(
329         address from,
330         address to,
331         uint256 amount
332     ) private {
333         require(from != address(0), "ERC20: transfer from the zero address");
334         require(to != address(0), "ERC20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336  
337         if (from != owner() && to != owner()) {
338  
339             //Trade start check
340             if (!tradingOpen) {
341                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
342             }
343  
344             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
345             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
346  
347             if(to != uniswapV2Pair) {
348                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
349             }
350  
351             uint256 contractTokenBalance = balanceOf(address(this));
352             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
353  
354             if(contractTokenBalance >= _maxTxAmount)
355             {
356                 contractTokenBalance = _maxTxAmount;
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
410     function setTrading(bool _tradingOpen) public onlyOwner {
411         tradingOpen = _tradingOpen;
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
543         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be 0%");
544         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 5, "Buy tax must be between 0% and 5%");
545         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be 0%");
546         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 50, "Sell tax must be between 0% and 5%");
547 
548         _redisFeeOnBuy = redisFeeOnBuy;
549         _redisFeeOnSell = redisFeeOnSell;
550         _taxFeeOnBuy = taxFeeOnBuy;
551         _taxFeeOnSell = taxFeeOnSell;
552 
553     }
554  
555     //Set minimum tokens required to swap.
556     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
557         _swapTokensAtAmount = swapTokensAtAmount;
558     }
559  
560     //Set minimum tokens required to swap.
561     function toggleSwap(bool _swapEnabled) public onlyOwner {
562         swapEnabled = _swapEnabled;
563     }
564  
565     //Set maximum transaction
566     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
567 	require(
568             maxTxAmount >= ((totalSupply() * 1) / 100),
569             "Cannot set maxTransactionAmount lower than 1%"
570         );
571 	_maxTxAmount = maxTxAmount;
572         
573     }
574  
575     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
576 	require(
577             maxWalletSize >= ((totalSupply() * 1) / 100),
578             "Cannot set maxWalletAmount lower than 1%"
579         );
580         _maxWalletSize = maxWalletSize;
581     }
582  
583     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
584         for(uint256 i = 0; i < accounts.length; i++) {
585             _isExcludedFromFee[accounts[i]] = excluded;
586         }
587     }
588 
589 }