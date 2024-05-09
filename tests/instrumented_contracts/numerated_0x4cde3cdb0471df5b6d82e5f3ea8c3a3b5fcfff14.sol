1 /**
2 
3 ZkXchange // ZkX
4 
5 Truly Anonymous DEX.
6 
7 Website: https://zk-x.io
8 Telegram: https://t.me/zkxchange
9 Twitter: https://twitter.com/zkxchange
10 
11 Whitepaper: https://zk-x.io/whitepaper
12 Email: info@zk-x.io
13 
14 */
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity ^0.8.14;
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
168 contract ZkXchange is Context, IERC20, Ownable {
169  
170     using SafeMath for uint256;
171  
172     string private constant _name = "ZkXchange";
173     string private constant _symbol = "ZkX";
174     uint8 private constant _decimals = 9;
175  
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181     uint256 private constant _tTotal = 5000000 * 10**9;
182     uint256 private _rTotal = (MAX - (MAX % _tTotal));
183     uint256 private _tFeeTotal;
184     uint256 private _redisFeeOnBuy = 0;  
185     uint256 private _taxFeeOnBuy = 10;  
186     uint256 private _redisFeeOnSell = 0;  
187     uint256 private _taxFeeOnSell = 30;
188  
189     //Original Fee
190     uint256 private _redisFee = _redisFeeOnSell;
191     uint256 private _taxFee = _taxFeeOnSell;
192  
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195  
196     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
197     address payable private _developmentAddress = payable(0x111093Ac53D98c9349b5abf7aE46bD978B499DC5); 
198     address payable private _marketingAddress = payable(0x111093Ac53D98c9349b5abf7aE46bD978B499DC5);
199  
200     IUniswapV2Router02 public uniswapV2Router;
201     address public uniswapV2Pair;
202  
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = true;
206  
207     uint256 public _maxTxAmount = 50000 * 10**9; 
208     uint256 public _maxWalletSize = 100000 * 10**9; 
209     uint256 public _swapTokensAtAmount = 50 * 10**9;
210  
211     event MaxTxAmountUpdated(uint256 _maxTxAmount);
212     modifier lockTheSwap {
213         inSwap = true;
214         _;
215         inSwap = false;
216     }
217  
218     constructor() {
219  
220         _rOwned[_msgSender()] = _rTotal;
221  
222         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
223         uniswapV2Router = _uniswapV2Router;
224         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
225             .createPair(address(this), _uniswapV2Router.WETH());
226  
227         _isExcludedFromFee[owner()] = true;
228         _isExcludedFromFee[address(this)] = true;
229         _isExcludedFromFee[_developmentAddress] = true;
230         _isExcludedFromFee[_marketingAddress] = true;
231  
232         emit Transfer(address(0), _msgSender(), _tTotal);
233     }
234  
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238  
239     function symbol() public pure returns (string memory) {
240         return _symbol;
241     }
242  
243     function decimals() public pure returns (uint8) {
244         return _decimals;
245     }
246  
247     function totalSupply() public pure override returns (uint256) {
248         return _tTotal;
249     }
250  
251     function balanceOf(address account) public view override returns (uint256) {
252         return tokenFromReflection(_rOwned[account]);
253     }
254  
255     function transfer(address recipient, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263  
264     function allowance(address owner, address spender)
265         public
266         view
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272  
273     function approve(address spender, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281  
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(
289             sender,
290             _msgSender(),
291             _allowances[sender][_msgSender()].sub(
292                 amount,
293                 "ERC20: transfer amount exceeds allowance"
294             )
295         );
296         return true;
297     }
298  
299     function tokenFromReflection(uint256 rAmount)
300         private
301         view
302         returns (uint256)
303     {
304         require(
305             rAmount <= _rTotal,
306             "Amount must be less than total reflections"
307         );
308         uint256 currentRate = _getRate();
309         return rAmount.div(currentRate);
310     }
311  
312     function removeAllFee() private {
313         if (_redisFee == 0 && _taxFee == 0) return;
314  
315         _previousredisFee = _redisFee;
316         _previoustaxFee = _taxFee;
317  
318         _redisFee = 0;
319         _taxFee = 0;
320     }
321  
322     function restoreAllFee() private {
323         _redisFee = _previousredisFee;
324         _taxFee = _previoustaxFee;
325     }
326  
327     function _approve(
328         address owner,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337  
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) private {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345         require(amount > 0, "Transfer amount must be greater than zero");
346  
347         if (from != owner() && to != owner()) {
348  
349             //Trade start check
350             if (!tradingOpen) {
351                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
352             }
353  
354             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
355             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
356  
357             if(to != uniswapV2Pair) {
358                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
359             }
360  
361             uint256 contractTokenBalance = balanceOf(address(this));
362             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
363  
364             if(contractTokenBalance >= _maxTxAmount)
365             {
366                 contractTokenBalance = _maxTxAmount;
367             }
368  
369             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
370                 swapTokensForEth(contractTokenBalance);
371                 uint256 contractETHBalance = address(this).balance;
372                 if (contractETHBalance > 0) {
373                     sendETHToFee(address(this).balance);
374                 }
375             }
376         }
377  
378         bool takeFee = true;
379  
380         //Transfer Tokens
381         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
382             takeFee = false;
383         } else {
384  
385             //Set Fee for Buys
386             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnBuy;
388                 _taxFee = _taxFeeOnBuy;
389             }
390  
391             //Set Fee for Sells
392             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnSell;
394                 _taxFee = _taxFeeOnSell;
395             }
396  
397         }
398  
399         _tokenTransfer(from, to, amount, takeFee);
400     }
401  
402     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = uniswapV2Router.WETH();
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             tokenAmount,
409             0,
410             path,
411             address(this),
412             block.timestamp
413         );
414     }
415  
416     function sendETHToFee(uint256 amount) private {
417         _marketingAddress.transfer(amount);
418     }
419  
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422     }
423  
424     function manualswap() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429  
430     function manualsend() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435  
436     function blockBots(address[] memory bots_) public onlyOwner {
437         for (uint256 i = 0; i < bots_.length; i++) {
438             bots[bots_[i]] = true;
439         }
440     }
441  
442     function unblockBot(address notbot) public onlyOwner {
443         bots[notbot] = false;
444     }
445  
446     function _tokenTransfer(
447         address sender,
448         address recipient,
449         uint256 amount,
450         bool takeFee
451     ) private {
452         if (!takeFee) removeAllFee();
453         _transferStandard(sender, recipient, amount);
454         if (!takeFee) restoreAllFee();
455     }
456  
457     function _transferStandard(
458         address sender,
459         address recipient,
460         uint256 tAmount
461     ) private {
462         (
463             uint256 rAmount,
464             uint256 rTransferAmount,
465             uint256 rFee,
466             uint256 tTransferAmount,
467             uint256 tFee,
468             uint256 tTeam
469         ) = _getValues(tAmount);
470         _rOwned[sender] = _rOwned[sender].sub(rAmount);
471         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
472         _takeTeam(tTeam);
473         _reflectFee(rFee, tFee);
474         emit Transfer(sender, recipient, tTransferAmount);
475     }
476  
477     function _takeTeam(uint256 tTeam) private {
478         uint256 currentRate = _getRate();
479         uint256 rTeam = tTeam.mul(currentRate);
480         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
481     }
482  
483     function _reflectFee(uint256 rFee, uint256 tFee) private {
484         _rTotal = _rTotal.sub(rFee);
485         _tFeeTotal = _tFeeTotal.add(tFee);
486     }
487  
488     receive() external payable {}
489  
490     function _getValues(uint256 tAmount)
491         private
492         view
493         returns (
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256
500         )
501     {
502         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
503             _getTValues(tAmount, _redisFee, _taxFee);
504         uint256 currentRate = _getRate();
505         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
506             _getRValues(tAmount, tFee, tTeam, currentRate);
507         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
508     }
509  
510     function _getTValues(
511         uint256 tAmount,
512         uint256 redisFee,
513         uint256 taxFee
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 tFee = tAmount.mul(redisFee).div(100);
524         uint256 tTeam = tAmount.mul(taxFee).div(100);
525         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
526         return (tTransferAmount, tFee, tTeam);
527     }
528  
529     function _getRValues(
530         uint256 tAmount,
531         uint256 tFee,
532         uint256 tTeam,
533         uint256 currentRate
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rFee = tFee.mul(currentRate);
545         uint256 rTeam = tTeam.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
547         return (rAmount, rTransferAmount, rFee);
548     }
549  
550     function _getRate() private view returns (uint256) {
551         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
552         return rSupply.div(tSupply);
553     }
554  
555     function _getCurrentSupply() private view returns (uint256, uint256) {
556         uint256 rSupply = _rTotal;
557         uint256 tSupply = _tTotal;
558         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
559         return (rSupply, tSupply);
560     }
561  
562     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
563         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
564         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
565         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
566         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
567 
568         _redisFeeOnBuy = redisFeeOnBuy;
569         _redisFeeOnSell = redisFeeOnSell;
570         _taxFeeOnBuy = taxFeeOnBuy;
571         _taxFeeOnSell = taxFeeOnSell;
572 
573     }
574  
575     //Set minimum tokens required to swap.
576     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
577         _swapTokensAtAmount = swapTokensAtAmount;
578     }
579  
580     //Set minimum tokens required to swap.
581     function toggleSwap(bool _swapEnabled) public onlyOwner {
582         swapEnabled = _swapEnabled;
583     }
584  
585     //Set maximum transaction
586     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
587            _maxTxAmount = maxTxAmount;
588         
589     }
590  
591     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
592         _maxWalletSize = maxWalletSize;
593     }
594  
595     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
596         for(uint256 i = 0; i < accounts.length; i++) {
597             _isExcludedFromFee[accounts[i]] = excluded;
598         }
599     }
600 
601 }