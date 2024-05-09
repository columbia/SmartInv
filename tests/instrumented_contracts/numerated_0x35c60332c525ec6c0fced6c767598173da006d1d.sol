1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.9; 
4 
5 // $UNIMATE
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract UNIMATE is Context, IERC20, Ownable {
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "Unimate";
161     string private constant _symbol = "MATE";
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _redisFeeOnBuy = 0;
173     uint256 private _taxFeeOnBuy = 10;
174     uint256 private _redisFeeOnSell = 0;
175     uint256 private _taxFeeOnSell = 40;
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
185     address payable private _developmentAddress = payable(0x16f7fde3b3b34A59550e2054FC5df9Da821129b3);
186     address payable private _marketingAddress = payable(0x16f7fde3b3b34A59550e2054FC5df9Da821129b3);
187 
188     IUniswapV2Router02 public uniswapV2Router;
189     address public uniswapV2Pair;
190 
191     bool private tradingOpen = true;
192     bool private inSwap = false;
193     bool private swapEnabled = true;
194 
195     uint256 public _maxTxAmount = 2000000 * 10**9;
196     uint256 public _maxWalletSize = 2000000 * 10**9;
197     uint256 public _swapTokensAtAmount = 289000 * 10**9;
198 bool public initialized;
199     event MaxTxAmountUpdated(uint256 _maxTxAmount);
200     modifier lockTheSwap {
201         inSwap = true;
202         _;
203         inSwap = false;
204     }
205     modifier initializer() {
206         require(!initialized, "uniswapV2Pair is already initialized");
207         _;
208 
209     }
210 
211     constructor() {
212 
213         _rOwned[_msgSender()] = _rTotal;
214 
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
216         uniswapV2Router = _uniswapV2Router;
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
229     function changeUniSwapPairAddress(address newPair) public initializer onlyOwner
230     {
231         uniswapV2Pair = newPair;
232         initialized=true;
233     }
234 
235     function symbol() public pure returns (string memory) {
236         return _symbol;
237     }
238 
239     function decimals() public pure returns (uint8) {
240         return _decimals;
241     }
242 
243     function totalSupply() public pure override returns (uint256) {
244         return _tTotal;
245     }
246 
247     function balanceOf(address account) public view override returns (uint256) {
248         return tokenFromReflection(_rOwned[account]);
249     }
250 
251     function transfer(address recipient, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     function allowance(address owner, address spender)
261         public
262         view
263         override
264         returns (uint256)
265     {
266         return _allowances[owner][spender];
267     }
268 
269     function approve(address spender, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public override returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(
285             sender,
286             _msgSender(),
287             _allowances[sender][_msgSender()].sub(
288                 amount,
289                 "ERC20: transfer amount exceeds allowance"
290             )
291         );
292         return true;
293     }
294 
295     function tokenFromReflection(uint256 rAmount)
296         private
297         view
298         returns (uint256)
299     {
300         require(
301             rAmount <= _rTotal,
302             "Amount must be less than total reflections"
303         );
304         uint256 currentRate = _getRate();
305         return rAmount.div(currentRate);
306     }
307 
308     function removeAllFee() private {
309         if (_redisFee == 0 && _taxFee == 0) return;
310 
311         _previousredisFee = _redisFee;
312         _previoustaxFee = _taxFee;
313 
314         _redisFee = 0;
315         _taxFee = 0;
316     }
317 
318     function restoreAllFee() private {
319         _redisFee = _previousredisFee;
320         _taxFee = _previoustaxFee;
321     }
322 
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333 
334     function _transfer(
335         address from,
336         address to,
337         uint256 amount
338     ) private {
339         require(from != address(0), "ERC20: transfer from the zero address");
340         require(to != address(0), "ERC20: transfer to the zero address");
341         require(amount > 0, "Transfer amount must be greater than zero");
342 
343         if (from != owner() && to != owner()) {
344 
345             //Trade start check
346             if (!tradingOpen) {
347                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
348             }
349 
350             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
351             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
352 
353             if(to != uniswapV2Pair) {
354                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
355             }
356 
357             uint256 contractTokenBalance = balanceOf(address(this));
358             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
359 
360             if(contractTokenBalance >= _maxTxAmount)
361             {
362                 contractTokenBalance = _maxTxAmount;
363             }
364 
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
366                 swapTokensForEth(contractTokenBalance);
367                 uint256 contractETHBalance = address(this).balance;
368                 if (contractETHBalance > 0) {
369                     sendETHToFee(address(this).balance);
370                 }
371             }
372         }
373 
374         bool takeFee = true;
375 
376         //Transfer Tokens
377         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
378             takeFee = false;
379         } else {
380 
381             //Set Fee for Buys
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386 
387             //Set Fee for Sells
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392 
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
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
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
432     function blockBots(address[] memory bots_) public onlyOwner {
433         for (uint256 i = 0; i < bots_.length; i++) {
434             bots[bots_[i]] = true;
435         }
436     }
437 
438     function unblockBot(address notbot) public onlyOwner {
439         bots[notbot] = false;
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