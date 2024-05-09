1 // File: erc-20.sol
2 
3 /*
4                                                                                                              
5   .g8""8q. `7MMF'      `7MMF'`7MN.   `7MF'`7MMF' `YMM' 
6 .dP'    `YM. MM          MM    MMN.    M    MM   .M'   
7 dM'      `MM MM          MM    M YMb   M    MM .d"     
8 MM        MM MM          MM    M  `MN. M    MMMMM.     
9 MM.      ,MP MM      ,   MM    M   `MM.M    MM  VMA    
10 `Mb.    ,dP' MM     ,M   MM    M     YMM    MM   `MM.  
11   `"bmmd"' .JMMmmmmMMM .JMML..JML.    YM  .JMML.   MMb.
12 
13          -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                                                                                      
14 
15 "Out of clutter, find simplicity, harmony."
16 
17 https://twitter.com/OpaqueSyndicate
18 
19 0/0 ~
20 
21 Opaque Ecosystem tokens utilize the OLH (Opaque Liquidity Hub) Smart Contract offering users seamless,
22 tax free swaps.
23 
24 OLH Considers Hold Time and Profit/Loss when determining the rate in which users can redeem 
25 Opaque Ecosystem Tokens for $OLINK.
26 
27 OpaqueLiquidityHub Contract: 0xaad33d8f837dbb5925cf12c90542aa508d419c0b
28 OPADiscountAuthority Contract: 0xd7fcf249ca52ef523a7b1bf7a0404eff7232ccd1
29 
30 */
31 pragma solidity ^0.8.9;
32  
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38  
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41  
42     function balanceOf(address account) external view returns (uint256);
43  
44     function transfer(address recipient, uint256 amount) external returns (bool);
45  
46     function allowance(address owner, address spender) external view returns (uint256);
47  
48     function approve(address spender, uint256 amount) external returns (bool);
49  
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55  
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(
58         address indexed owner,
59         address indexed spender,
60         uint256 value
61     );
62 }
63  
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71  
72     constructor() {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77  
78     function owner() public view returns (address) {
79         return _owner;
80     }
81  
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86  
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91  
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97  
98 }
99  
100 library SafeMath {
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104         return c;
105     }
106  
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return sub(a, b, "SafeMath: subtraction overflow");
109     }
110  
111     function sub(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118         return c;
119     }
120  
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         if (a == 0) {
123             return 0;
124         }
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127         return c;
128     }
129  
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133  
134     function div(
135         uint256 a,
136         uint256 b,
137         string memory errorMessage
138     ) internal pure returns (uint256) {
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         return c;
142     }
143 }
144  
145 interface IUniswapV2Factory {
146     function createPair(address tokenA, address tokenB)
147         external
148         returns (address pair);
149 }
150  
151 interface IUniswapV2Router02 {
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint256 amountIn,
154         uint256 amountOutMin,
155         address[] calldata path,
156         address to,
157         uint256 deadline
158     ) external;
159  
160     function factory() external pure returns (address);
161  
162     function WETH() external pure returns (address);
163  
164     function addLiquidityETH(
165         address token,
166         uint256 amountTokenDesired,
167         uint256 amountTokenMin,
168         uint256 amountETHMin,
169         address to,
170         uint256 deadline
171     )
172         external
173         payable
174         returns (
175             uint256 amountToken,
176             uint256 amountETH,
177             uint256 liquidity
178         );
179 }
180  
181 contract opaqueLink is Context, IERC20, Ownable {
182  
183     using SafeMath for uint256;
184  
185     string private constant _name = "Opaque Link";
186     string private constant _symbol = "OLINK";
187     uint8 private constant _decimals = 9;
188  
189     mapping(address => uint256) private _rOwned;
190     mapping(address => uint256) private _tOwned;
191     mapping(address => mapping(address => uint256)) private _allowances;
192     mapping(address => bool) private _isExcludedFromFee;
193     uint256 private constant MAX = ~uint256(0);
194     uint256 private constant _tTotal = 1000000000 * 10**9;
195     uint256 private _rTotal = (MAX - (MAX % _tTotal));
196     uint256 private _tFeeTotal;
197     uint256 private _redisFeeOnBuy = 0;  
198     uint256 private _taxFeeOnBuy = 1;  
199     uint256 private _redisFeeOnSell = 0;  
200     uint256 private _taxFeeOnSell = 1;
201  
202     //Original Fee
203     uint256 private _redisFee = _redisFeeOnSell;
204     uint256 private _taxFee = _taxFeeOnSell;
205  
206     uint256 private _previousredisFee = _redisFee;
207     uint256 private _previoustaxFee = _taxFee;
208  
209     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
210     address payable private _developmentAddress = payable(0x0A4f3A75D3C039B79CDCea816e010890D7d68445); 
211     address payable private _marketingAddress = payable(0x0A4f3A75D3C039B79CDCea816e010890D7d68445);
212  
213     IUniswapV2Router02 public uniswapV2Router;
214     address public uniswapV2Pair;
215  
216     bool private tradingOpen;
217     bool private inSwap = false;
218     bool private swapEnabled = true;
219  
220     uint256 public _maxTxAmount = 10000000 * 10**9; 
221     uint256 public _maxWalletSize = 10000000 * 10**9; 
222     uint256 public _swapTokensAtAmount = 10000 * 10**9;
223  
224     event MaxTxAmountUpdated(uint256 _maxTxAmount);
225     modifier lockTheSwap {
226         inSwap = true;
227         _;
228         inSwap = false;
229     }
230  
231     constructor() {
232  
233         _rOwned[_msgSender()] = _rTotal;
234  
235         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
236         uniswapV2Router = _uniswapV2Router;
237         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
238             .createPair(address(this), _uniswapV2Router.WETH());
239  
240         _isExcludedFromFee[owner()] = true;
241         _isExcludedFromFee[address(this)] = true;
242         _isExcludedFromFee[_developmentAddress] = true;
243         _isExcludedFromFee[_marketingAddress] = true;
244  
245         emit Transfer(address(0), _msgSender(), _tTotal);
246     }
247  
248     function name() public pure returns (string memory) {
249         return _name;
250     }
251  
252     function symbol() public pure returns (string memory) {
253         return _symbol;
254     }
255  
256     function decimals() public pure returns (uint8) {
257         return _decimals;
258     }
259  
260     function totalSupply() public pure override returns (uint256) {
261         return _tTotal;
262     }
263  
264     function balanceOf(address account) public view override returns (uint256) {
265         return tokenFromReflection(_rOwned[account]);
266     }
267  
268     function transfer(address recipient, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276  
277     function allowance(address owner, address spender)
278         public
279         view
280         override
281         returns (uint256)
282     {
283         return _allowances[owner][spender];
284     }
285  
286     function approve(address spender, uint256 amount)
287         public
288         override
289         returns (bool)
290     {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294  
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public override returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(
302             sender,
303             _msgSender(),
304             _allowances[sender][_msgSender()].sub(
305                 amount,
306                 "ERC20: transfer amount exceeds allowance"
307             )
308         );
309         return true;
310     }
311  
312     function tokenFromReflection(uint256 rAmount)
313         private
314         view
315         returns (uint256)
316     {
317         require(
318             rAmount <= _rTotal,
319             "Amount must be less than total reflections"
320         );
321         uint256 currentRate = _getRate();
322         return rAmount.div(currentRate);
323     }
324  
325     function removeAllFee() private {
326         if (_redisFee == 0 && _taxFee == 0) return;
327  
328         _previousredisFee = _redisFee;
329         _previoustaxFee = _taxFee;
330  
331         _redisFee = 0;
332         _taxFee = 0;
333     }
334  
335     function restoreAllFee() private {
336         _redisFee = _previousredisFee;
337         _taxFee = _previoustaxFee;
338     }
339  
340     function _approve(
341         address owner,
342         address spender,
343         uint256 amount
344     ) private {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350  
351     function _transfer(
352         address from,
353         address to,
354         uint256 amount
355     ) private {
356         require(from != address(0), "ERC20: transfer from the zero address");
357         require(to != address(0), "ERC20: transfer to the zero address");
358         require(amount > 0, "Transfer amount must be greater than zero");
359  
360         if (from != owner() && to != owner()) {
361  
362             //Trade start check
363             if (!tradingOpen) {
364                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
365             }
366  
367             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
368             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
369  
370             if(to != uniswapV2Pair) {
371                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
372             }
373  
374             uint256 contractTokenBalance = balanceOf(address(this));
375             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
376  
377             if(contractTokenBalance >= _maxTxAmount)
378             {
379                 contractTokenBalance = _maxTxAmount;
380             }
381  
382             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
383                 swapTokensForEth(contractTokenBalance);
384                 uint256 contractETHBalance = address(this).balance;
385                 if (contractETHBalance > 0) {
386                     sendETHToFee(address(this).balance);
387                 }
388             }
389         }
390  
391         bool takeFee = true;
392  
393         //Transfer Tokens
394         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
395             takeFee = false;
396         } else {
397  
398             //Set Fee for Buys
399             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnBuy;
401                 _taxFee = _taxFeeOnBuy;
402             }
403  
404             //Set Fee for Sells
405             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
406                 _redisFee = _redisFeeOnSell;
407                 _taxFee = _taxFeeOnSell;
408             }
409  
410         }
411  
412         _tokenTransfer(from, to, amount, takeFee);
413     }
414  
415     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
416         address[] memory path = new address[](2);
417         path[0] = address(this);
418         path[1] = uniswapV2Router.WETH();
419         _approve(address(this), address(uniswapV2Router), tokenAmount);
420         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
421             tokenAmount,
422             0,
423             path,
424             address(this),
425             block.timestamp
426         );
427     }
428  
429     function sendETHToFee(uint256 amount) private {
430         _marketingAddress.transfer(amount);
431     }
432  
433     function setTrading(bool _tradingOpen) public onlyOwner {
434         tradingOpen = _tradingOpen;
435     }
436  
437     function manualswap() external {
438         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
439         uint256 contractBalance = balanceOf(address(this));
440         swapTokensForEth(contractBalance);
441     }
442  
443     function manualsend() external {
444         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
445         uint256 contractETHBalance = address(this).balance;
446         sendETHToFee(contractETHBalance);
447     }
448  
449     function blockBots(address[] memory bots_) public onlyOwner {
450         for (uint256 i = 0; i < bots_.length; i++) {
451             bots[bots_[i]] = true;
452         }
453     }
454  
455     function unblockBot(address notbot) public onlyOwner {
456         bots[notbot] = false;
457     }
458  
459     function _tokenTransfer(
460         address sender,
461         address recipient,
462         uint256 amount,
463         bool takeFee
464     ) private {
465         if (!takeFee) removeAllFee();
466         _transferStandard(sender, recipient, amount);
467         if (!takeFee) restoreAllFee();
468     }
469  
470     function _transferStandard(
471         address sender,
472         address recipient,
473         uint256 tAmount
474     ) private {
475         (
476             uint256 rAmount,
477             uint256 rTransferAmount,
478             uint256 rFee,
479             uint256 tTransferAmount,
480             uint256 tFee,
481             uint256 tTeam
482         ) = _getValues(tAmount);
483         _rOwned[sender] = _rOwned[sender].sub(rAmount);
484         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
485         _takeTeam(tTeam);
486         _reflectFee(rFee, tFee);
487         emit Transfer(sender, recipient, tTransferAmount);
488     }
489  
490     function _takeTeam(uint256 tTeam) private {
491         uint256 currentRate = _getRate();
492         uint256 rTeam = tTeam.mul(currentRate);
493         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
494     }
495  
496     function _reflectFee(uint256 rFee, uint256 tFee) private {
497         _rTotal = _rTotal.sub(rFee);
498         _tFeeTotal = _tFeeTotal.add(tFee);
499     }
500  
501     receive() external payable {}
502  
503     function _getValues(uint256 tAmount)
504         private
505         view
506         returns (
507             uint256,
508             uint256,
509             uint256,
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
516             _getTValues(tAmount, _redisFee, _taxFee);
517         uint256 currentRate = _getRate();
518         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
519             _getRValues(tAmount, tFee, tTeam, currentRate);
520         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
521     }
522  
523     function _getTValues(
524         uint256 tAmount,
525         uint256 redisFee,
526         uint256 taxFee
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 tFee = tAmount.mul(redisFee).div(100);
537         uint256 tTeam = tAmount.mul(taxFee).div(100);
538         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
539         return (tTransferAmount, tFee, tTeam);
540     }
541  
542     function _getRValues(
543         uint256 tAmount,
544         uint256 tFee,
545         uint256 tTeam,
546         uint256 currentRate
547     )
548         private
549         pure
550         returns (
551             uint256,
552             uint256,
553             uint256
554         )
555     {
556         uint256 rAmount = tAmount.mul(currentRate);
557         uint256 rFee = tFee.mul(currentRate);
558         uint256 rTeam = tTeam.mul(currentRate);
559         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
560         return (rAmount, rTransferAmount, rFee);
561     }
562  
563     function _getRate() private view returns (uint256) {
564         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
565         return rSupply.div(tSupply);
566     }
567  
568     function _getCurrentSupply() private view returns (uint256, uint256) {
569         uint256 rSupply = _rTotal;
570         uint256 tSupply = _tTotal;
571         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
572         return (rSupply, tSupply);
573     }
574  
575     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
576         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
577         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 20, "Buy tax must be between 0% and 20%");
578         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
579         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 20, "Sell tax must be between 0% and 20%");
580 
581         _redisFeeOnBuy = redisFeeOnBuy;
582         _redisFeeOnSell = redisFeeOnSell;
583         _taxFeeOnBuy = taxFeeOnBuy;
584         _taxFeeOnSell = taxFeeOnSell;
585 
586     }
587  
588     //Set minimum tokens required to swap.
589     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
590         _swapTokensAtAmount = swapTokensAtAmount;
591     }
592  
593     //Set minimum tokens required to swap.
594     function toggleSwap(bool _swapEnabled) public onlyOwner {
595         swapEnabled = _swapEnabled;
596     }
597  
598     //Set maximum transaction
599     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
600            _maxTxAmount = maxTxAmount;
601         
602     }
603  
604     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
605         _maxWalletSize = maxWalletSize;
606     }
607  
608     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
609         for(uint256 i = 0; i < accounts.length; i++) {
610             _isExcludedFromFee[accounts[i]] = excluded;
611         }
612     }
613 
614 }