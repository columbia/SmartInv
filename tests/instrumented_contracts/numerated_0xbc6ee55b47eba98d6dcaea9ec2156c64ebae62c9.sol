1 // SPDX-License-Identifier: MIT
2 
3 /*
4  https://t.me/smatyai
5  https://twitter.com/0x0smaty?s=21&t=gK4fBEsk_4IcpSqFeBEEIQ
6 */
7 
8 pragma solidity ^0.8.17;
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
158 contract smaty is Context, IERC20, Ownable {
159  
160     using SafeMath for uint256;
161  
162     string private constant _name = "0x0smaty";
163     string private constant _symbol = "smaty";
164     uint8 private constant _decimals = 9;
165  
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 1000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174 
175     uint256 private _redisFeeOnBuy = 0;  
176     uint256 private _taxFeeOnBuy = 0;  
177     uint256 private _redisFeeOnSell = 0;  
178     uint256 private _taxFeeOnSell = 0;
179  
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     //Ratio 
188     uint16 receiver0Ratio = 1;
189     uint16 receiver1Ratio = 2;
190     uint16 receiver2Ratio = 2;
191     uint16 receiverTotalRatio = receiver0Ratio + receiver1Ratio + receiver2Ratio;
192  
193     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
194     address payable public _feeReceiver0 = payable(0x2b112388622A651E20aF3D1278cc9A4246412403);
195     address payable private _feeReceiver1 = payable(0xa6692840A09C4b924cDAEB0c01a6EF9E2Dc4c124); 
196     address payable private _feeReceiver2 = payable(0xa6692840A09C4b924cDAEB0c01a6EF9E2Dc4c124);
197  
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapV2Pair;
200  
201     bool private tradingOpen;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204  
205     uint256 public _maxTxAmount = 10000000 * 10**9; 
206     uint256 public _maxWalletSize = 10000000 * 10**9; 
207     uint256 public _swapTokensAtAmount = 500000 * 10**9;
208  
209     event MaxTxAmountUpdated(uint256 _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215  
216     constructor() {
217  
218         _rOwned[_msgSender()] = _rTotal;
219  
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224  
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_feeReceiver0] = true;
228         _isExcludedFromFee[_feeReceiver1] = true;
229         _isExcludedFromFee[_feeReceiver2] = true;
230  
231         emit Transfer(address(0), _msgSender(), _tTotal);
232     }
233  
234     function name() public pure returns (string memory) {
235         return _name;
236     }
237  
238     function symbol() public pure returns (string memory) {
239         return _symbol;
240     }
241  
242     function decimals() public pure returns (uint8) {
243         return _decimals;
244     }
245  
246     function totalSupply() public pure override returns (uint256) {
247         return _tTotal;
248     }
249  
250     function balanceOf(address account) public view override returns (uint256) {
251         return tokenFromReflection(_rOwned[account]);
252     }
253  
254     function transfer(address recipient, uint256 amount)
255         public
256         override
257         returns (bool)
258     {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262  
263     function allowance(address owner, address spender)
264         public
265         view
266         override
267         returns (uint256)
268     {
269         return _allowances[owner][spender];
270     }
271  
272     function approve(address spender, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280  
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) public override returns (bool) {
286         _transfer(sender, recipient, amount);
287         _approve(
288             sender,
289             _msgSender(),
290             _allowances[sender][_msgSender()].sub(
291                 amount,
292                 "ERC20: transfer amount exceeds allowance"
293             )
294         );
295         return true;
296     }
297  
298     function tokenFromReflection(uint256 rAmount)
299         private
300         view
301         returns (uint256)
302     {
303         require(
304             rAmount <= _rTotal,
305             "Amount must be less than total reflections"
306         );
307         uint256 currentRate = _getRate();
308         return rAmount.div(currentRate);
309     }
310  
311     function removeAllFee() private {
312         if (_redisFee == 0 && _taxFee == 0) return;
313  
314         _previousredisFee = _redisFee;
315         _previoustaxFee = _taxFee;
316  
317         _redisFee = 0;
318         _taxFee = 0;
319     }
320  
321     function restoreAllFee() private {
322         _redisFee = _previousredisFee;
323         _taxFee = _previoustaxFee;
324     }
325  
326     function _approve(
327         address owner,
328         address spender,
329         uint256 amount
330     ) private {
331         require(owner != address(0), "ERC20: approve from the zero address");
332         require(spender != address(0), "ERC20: approve to the zero address");
333         _allowances[owner][spender] = amount;
334         emit Approval(owner, spender, amount);
335     }
336  
337     function _transfer(
338         address from,
339         address to,
340         uint256 amount
341     ) private {
342         require(from != address(0), "ERC20: transfer from the zero address");
343         require(to != address(0), "ERC20: transfer to the zero address");
344         require(amount > 0, "Transfer amount must be greater than zero");
345  
346         if (from != owner() && to != owner()) {
347  
348             //Trade start check
349             if (!tradingOpen) {
350                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
351             }
352  
353             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
354             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
355  
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359  
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362  
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367  
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376  
377         bool takeFee = true;
378  
379         //Transfer Tokens
380         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383  
384             //Set Fee for Buys
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy;
388             }
389  
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnSell;
393                 _taxFee = _taxFeeOnSell;
394             }
395  
396         }
397  
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400  
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414  
415     function sendETHToFee(uint256 amount) private {
416         _feeReceiver0.transfer(amount * receiver0Ratio / receiverTotalRatio);
417         _feeReceiver1.transfer(amount * receiver1Ratio / receiverTotalRatio);
418         _feeReceiver2.transfer(address(this).balance);
419     }
420  
421     function beginTrading() public onlyOwner {
422         tradingOpen = true;
423     }
424  
425     function manualswap() external {
426         require(_msgSender() == _feeReceiver1 || _msgSender() == _feeReceiver2);
427         uint256 contractBalance = balanceOf(address(this));
428         swapTokensForEth(contractBalance);
429     }
430  
431     function manualsend() external {
432         require(_msgSender() == _feeReceiver1 || _msgSender() == _feeReceiver2);
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
564         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
565         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
566         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
567         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
568 
569         _redisFeeOnBuy = redisFeeOnBuy;
570         _redisFeeOnSell = redisFeeOnSell;
571         _taxFeeOnBuy = taxFeeOnBuy;
572         _taxFeeOnSell = taxFeeOnSell;
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
595     function removeLimits() external onlyOwner {
596         _maxWalletSize = _tTotal;
597         _maxTxAmount = _tTotal;
598     }
599 
600     function adjustRatio(uint16 r0, uint16 r1, uint16 r2) external onlyOwner {
601         receiver0Ratio = r0;
602         receiver1Ratio = r1;
603         receiver2Ratio = r2;
604         receiverTotalRatio = receiver0Ratio + receiver1Ratio + receiver2Ratio;
605     }
606 
607     function adjustReceivers(address r0, address r1, address r2) external onlyOwner {
608         _feeReceiver0 = payable(r0);
609         _feeReceiver1 = payable(r1);
610         _feeReceiver2 = payable(r2);
611     }
612  
613     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
614         for(uint256 i = 0; i < accounts.length; i++) {
615             _isExcludedFromFee[accounts[i]] = excluded;
616         }
617     }
618 
619 }