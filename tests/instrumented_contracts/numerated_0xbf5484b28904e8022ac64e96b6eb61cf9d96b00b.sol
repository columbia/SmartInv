1 /**
2 Yueliang
3 
4 Started by a big group of competent dreamers and storytellers.
5 
6 Yueliang is a common expression of the word "Moon" in Chinese, and is a relatively common female name.
7 If you're seeing this, you're probably early.
8 Welcome.
9 
10 Don't get scammed or join a random tg impersonating us. You'll know us when you see us.
11 
12 There will be no telegram until we reach a certain height, one that might make 掌握 happy.
13 Let's make history... again.
14 
15 $YUE
16 
17 */ 
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.9;
21  
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27  
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30  
31     function balanceOf(address account) external view returns (uint256);
32  
33     function transfer(address recipient, uint256 amount) external returns (bool);
34  
35     function allowance(address owner, address spender) external view returns (uint256);
36  
37     function approve(address spender, uint256 amount) external returns (bool);
38  
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44  
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52  
53 contract Ownable is Context {
54     address internal _owner;
55     address private _previousOwner;
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60  
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66  
67     function owner() public view returns (address) {
68         return _owner;
69     }
70  
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75  
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80  
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86  
87 }
88 
89 library SafeMath {
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93         return c;
94     }
95  
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99  
100     function sub(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     }
109  
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116         return c;
117     }
118  
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122  
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         return c;
131     }
132 }
133  
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139  
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148  
149     function factory() external pure returns (address);
150  
151     function WETH() external pure returns (address);
152  
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169  
170 contract YUELIANG  is Context, IERC20, Ownable {
171  
172     using SafeMath for uint256;
173  
174     string private constant _name = "Yueliang";
175     string private constant _symbol = "YUE";
176     uint8 private constant _decimals = 9;
177  
178     mapping(address => uint256) private _rOwned;
179     mapping(address => uint256) private _tOwned;
180     mapping(address => mapping(address => uint256)) private _allowances;
181     mapping(address => bool) private _isExcludedFromFee;
182     uint256 private constant MAX = ~uint256(0);
183     uint256 private constant _tTotal = 10000000 * 10**9;
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186     uint256 private _redisFeeOnBuy = 0;  
187     uint256 private _taxFeeOnBuy = 4;  
188     uint256 private _redisFeeOnSell = 0;  
189     uint256 private _taxFeeOnSell = 4;
190  
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193  
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196  
197     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
198     address payable private _developmentAddress = payable(0x2697e00A09F8d9a5b04A79A5990B6dEA44F73306); 
199     address payable private _marketingAddress = payable(0x2697e00A09F8d9a5b04A79A5990B6dEA44F73306);
200  
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203  
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207  
208     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
209     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
210     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
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
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
418         _marketingAddress.transfer(amount.mul(2).div(4));
419         _developmentAddress.transfer(amount.mul(2).div(4));
420     }
421  
422     function setTrading(bool _tradingOpen) public onlyOwner {
423         tradingOpen = _tradingOpen;
424     }
425  
426     function manualswap() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractBalance = balanceOf(address(this));
429         swapTokensForEth(contractBalance);
430     }
431  
432     function manualsend() external {
433         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
434         uint256 contractETHBalance = address(this).balance;
435         sendETHToFee(contractETHBalance);
436     }
437  
438     function blockBots(address[] memory bots_) public onlyOwner {
439         for (uint256 i = 0; i < bots_.length; i++) {
440             bots[bots_[i]] = true;
441         }
442     }
443  
444     function unblockBot(address notbot) public onlyOwner {
445         bots[notbot] = false;
446     }
447  
448     function _tokenTransfer(
449         address sender,
450         address recipient,
451         uint256 amount,
452         bool takeFee
453     ) private {
454         if (!takeFee) removeAllFee();
455         _transferStandard(sender, recipient, amount);
456         if (!takeFee) restoreAllFee();
457     }
458  
459     function _transferStandard(
460         address sender,
461         address recipient,
462         uint256 tAmount
463     ) private {
464         (
465             uint256 rAmount,
466             uint256 rTransferAmount,
467             uint256 rFee,
468             uint256 tTransferAmount,
469             uint256 tFee,
470             uint256 tTeam
471         ) = _getValues(tAmount);
472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
473         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
474         _takeTeam(tTeam);
475         _reflectFee(rFee, tFee);
476         emit Transfer(sender, recipient, tTransferAmount);
477     }
478  
479     function _takeTeam(uint256 tTeam) private {
480         uint256 currentRate = _getRate();
481         uint256 rTeam = tTeam.mul(currentRate);
482         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
483     }
484  
485     function _reflectFee(uint256 rFee, uint256 tFee) private {
486         _rTotal = _rTotal.sub(rFee);
487         _tFeeTotal = _tFeeTotal.add(tFee);
488     }
489  
490     receive() external payable {}
491  
492     function _getValues(uint256 tAmount)
493         private
494         view
495         returns (
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
505             _getTValues(tAmount, _redisFee, _taxFee);
506         uint256 currentRate = _getRate();
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
508             _getRValues(tAmount, tFee, tTeam, currentRate);
509         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
510     }
511  
512     function _getTValues(
513         uint256 tAmount,
514         uint256 redisFee,
515         uint256 taxFee
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 tFee = tAmount.mul(redisFee).div(100);
526         uint256 tTeam = tAmount.mul(taxFee).div(100);
527         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
528         return (tTransferAmount, tFee, tTeam);
529     }
530  
531     function _getRValues(
532         uint256 tAmount,
533         uint256 tFee,
534         uint256 tTeam,
535         uint256 currentRate
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 rAmount = tAmount.mul(currentRate);
546         uint256 rFee = tFee.mul(currentRate);
547         uint256 rTeam = tTeam.mul(currentRate);
548         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
549         return (rAmount, rTransferAmount, rFee);
550     }
551  
552     function _getRate() private view returns (uint256) {
553         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
554         return rSupply.div(tSupply);
555     }
556  
557     function _getCurrentSupply() private view returns (uint256, uint256) {
558         uint256 rSupply = _rTotal;
559         uint256 tSupply = _tTotal;
560         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
561         return (rSupply, tSupply);
562     }
563  
564     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
565         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
566         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 5, "Buy tax must be between 0% and 5%");
567         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
568         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 5, "Sell tax must be between 0% and 5%");
569 
570         _redisFeeOnBuy = redisFeeOnBuy;
571         _redisFeeOnSell = redisFeeOnSell;
572         _taxFeeOnBuy = taxFeeOnBuy;
573         _taxFeeOnSell = taxFeeOnSell;
574 
575     }
576  
577     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
578         _swapTokensAtAmount = swapTokensAtAmount;
579     }
580  
581     function toggleSwap(bool _swapEnabled) public onlyOwner {
582         swapEnabled = _swapEnabled;
583     }
584  
585     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
586         require(amountPercent>0);
587         _maxTxAmount = (_tTotal * amountPercent ) / 100;
588     }
589 
590     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
591         require(amountPercent>0);
592         _maxWalletSize = (_tTotal * amountPercent ) / 100;
593     }
594 
595     function removeLimits() external onlyOwner{
596         _maxTxAmount = _tTotal;
597         _maxWalletSize = _tTotal;
598     }
599  
600     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
601         for(uint256 i = 0; i < accounts.length; i++) {
602             _isExcludedFromFee[accounts[i]] = excluded;
603         }
604     }
605 
606 }