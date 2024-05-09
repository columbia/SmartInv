1 /*  
2  ──────────────────██████────────────────
3 ─────────────────████████─█─────────────
4 ─────────────██████████████─────────────
5 ─────────────█████████████──────────────
6 ──────────────███████████───────────────
7 ───────────────██████████───────────────
8 ────────────────████████────────────────
9 ────────────────▐██████─────────────────
10 ────────────────▐██████─────────────────
11 ──────────────── ▌─────▌────────────────
12 ────────────────███─█████───────────────
13 ────────────████████████████────────────
14 ──────────████████████████████──────────
15 ────────████████████─────███████────────
16 ──────███████████─────────███████───────
17 ─────████████████───██─███████████──────
18 ────██████████████──────────████████────
19 ───████████████████─────█───█████████───
20 ──█████████████████████─██───█████████──
21 ──█████████████████████──██──██████████─
22 ─███████████████████████─██───██████████
23 ████████████████████████──────██████████
24 ███████████████████──────────███████████
25 ─██████████████████───────██████████████
26 ─███████████████████████──█████████████─
27 ──█████████████████████████████████████─
28 ───██████████████████████████████████───
29 ───────██████████████████████████████───
30 ───────██████████████████████████───────
31 ─────────────███████████████────────────
32  */
33             
34 /*     
35 https://twitter.com/MILLIONSERC
36 https://t.me/millionserc      
37 https://millionserc.site      
38 */
39 
40 /**
41 */
42 
43 // SPDX-License-Identifier: Unlicensed
44 pragma solidity ^0.8.17;
45  
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 }
51  
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54  
55     function balanceOf(address account) external view returns (uint256);
56  
57     function transfer(address recipient, uint256 amount) external returns (bool);
58  
59     function allowance(address owner, address spender) external view returns (uint256);
60  
61     function approve(address spender, uint256 amount) external returns (bool);
62  
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68  
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(
71         address indexed owner,
72         address indexed spender,
73         uint256 value
74     );
75 }
76  
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(
81         address indexed previousOwner,
82         address indexed newOwner
83     );
84  
85     constructor() {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90  
91     function owner() public view returns (address) {
92         return _owner;
93     }
94  
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99  
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104  
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110  
111 }
112  
113 library SafeMath {
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117         return c;
118     }
119  
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123  
124     function sub(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131         return c;
132     }
133  
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         if (a == 0) {
136             return 0;
137         }
138         uint256 c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140         return c;
141     }
142  
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146  
147     function div(
148         uint256 a,
149         uint256 b,
150         string memory errorMessage
151     ) internal pure returns (uint256) {
152         require(b > 0, errorMessage);
153         uint256 c = a / b;
154         return c;
155     }
156 }
157  
158 interface IUniswapV2Factory {
159     function createPair(address tokenA, address tokenB)
160         external
161         returns (address pair);
162 }
163  
164 interface IUniswapV2Router02 {
165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
166         uint256 amountIn,
167         uint256 amountOutMin,
168         address[] calldata path,
169         address to,
170         uint256 deadline
171     ) external;
172  
173     function factory() external pure returns (address);
174  
175     function WETH() external pure returns (address);
176  
177     function addLiquidityETH(
178         address token,
179         uint256 amountTokenDesired,
180         uint256 amountTokenMin,
181         uint256 amountETHMin,
182         address to,
183         uint256 deadline
184     )
185         external
186         payable
187         returns (
188             uint256 amountToken,
189             uint256 amountETH,
190             uint256 liquidity
191         );
192 }
193  
194 contract Millions is Context, IERC20, Ownable {
195  
196     using SafeMath for uint256;
197  
198     string private constant _name = "Millions";
199     string private constant _symbol = "MLNS";
200     uint8 private constant _decimals = 9;
201  
202     mapping(address => uint256) private _rOwned;
203     mapping(address => uint256) private _tOwned;
204     mapping(address => mapping(address => uint256)) private _allowances;
205     mapping(address => bool) private _isExcludedFromFee;
206     uint256 private constant MAX = ~uint256(0);
207     uint256 private constant _tTotal = 10000000000000 * 10**9; //Total Supply
208     uint256 private _rTotal = (MAX - (MAX % _tTotal));
209     uint256 private _tFeeTotal;
210     uint256 private _redisFeeOnBuy = 0;  //rewards buyers from other buy tax
211     uint256 private _taxFeeOnBuy = 5;    //Main Buy Tax
212     uint256 private _redisFeeOnSell = 0;  //rewards buyers from other Sell tax
213     uint256 private _taxFeeOnSell = 30;   //Main sell Tax
214  
215     //Original Fee
216     uint256 private _redisFee = _redisFeeOnSell;
217     uint256 private _taxFee = _taxFeeOnSell;
218  
219     uint256 private _previousredisFee = _redisFee;
220     uint256 private _previoustaxFee = _taxFee;
221  
222     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
223     address payable private _developmentAddress = payable(0x1ebDd9C603413337471AA97c19eC8667D3ED16e3); //Dev Address
224     address payable private _marketingAddress = payable(0x80bDC29EebCe968c157328689428b016ca20eA50); // Marketing Address
225  
226     IUniswapV2Router02 public uniswapV2Router;
227     address public uniswapV2Pair;
228  
229     bool private tradingOpen;
230     bool private inSwap = false;
231     bool private swapEnabled = true;
232  
233     uint256 public _maxTxAmount = 50000000000 * 10**9; 
234     uint256 public _maxWalletSize = 3000000000000 * 10**9; 
235     uint256 public _swapTokensAtAmount = 10000 * 10**9;
236  
237     event MaxTxAmountUpdated(uint256 _maxTxAmount);
238     modifier lockTheSwap {
239         inSwap = true;
240         _;
241         inSwap = false;
242     }
243  
244     constructor() {
245  
246         _rOwned[_msgSender()] = _rTotal;
247  
248         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
249         uniswapV2Router = _uniswapV2Router;
250         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
251             .createPair(address(this), _uniswapV2Router.WETH());
252  
253         _isExcludedFromFee[owner()] = true;
254         _isExcludedFromFee[address(this)] = true;
255         _isExcludedFromFee[_developmentAddress] = true;
256         _isExcludedFromFee[_marketingAddress] = true;
257  
258         emit Transfer(address(0), _msgSender(), _tTotal);
259     }
260 
261     function name() public pure returns (string memory) {
262         return _name;
263     }
264  
265     function symbol() public pure returns (string memory) {
266         return _symbol;
267     }
268  
269     function decimals() public pure returns (uint8) {
270         return _decimals;
271     }
272  
273     function totalSupply() public pure override returns (uint256) {
274         return _tTotal;
275     }
276  
277     function balanceOf(address account) public view override returns (uint256) {
278         return tokenFromReflection(_rOwned[account]);
279     }
280  
281     function transfer(address recipient, uint256 amount)
282         public
283         override
284         returns (bool)
285     {
286         _transfer(_msgSender(), recipient, amount);
287         return true;
288     }
289  
290     function allowance(address owner, address spender)
291         public
292         view
293         override
294         returns (uint256)
295     {
296         return _allowances[owner][spender];
297     }
298  
299     function approve(address spender, uint256 amount)
300         public
301         override
302         returns (bool)
303     {
304         _approve(_msgSender(), spender, amount);
305         return true;
306     }
307  
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(
315             sender,
316             _msgSender(),
317             _allowances[sender][_msgSender()].sub(
318                 amount,
319                 "ERC20: transfer amount exceeds allowance"
320             )
321         );
322         return true;
323     }
324  
325     function tokenFromReflection(uint256 rAmount)
326         private
327         view
328         returns (uint256)
329     {
330         require(
331             rAmount <= _rTotal,
332             "Amount must be less than total reflections"
333         );
334         uint256 currentRate = _getRate();
335         return rAmount.div(currentRate);
336     }
337  
338     function removeAllFee() private {
339         if (_redisFee == 0 && _taxFee == 0) return;
340  
341         _previousredisFee = _redisFee;
342         _previoustaxFee = _taxFee;
343  
344         _redisFee = 0;
345         _taxFee = 0;
346     }
347  
348     function restoreAllFee() private {
349         _redisFee = _previousredisFee;
350         _taxFee = _previoustaxFee;
351     }
352  
353     function _approve(
354         address owner,
355         address spender,
356         uint256 amount
357     ) private {
358         require(owner != address(0), "ERC20: approve from the zero address");
359         require(spender != address(0), "ERC20: approve to the zero address");
360         _allowances[owner][spender] = amount;
361         emit Approval(owner, spender, amount);
362     }
363  
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) private {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371         require(amount > 0, "Transfer amount must be greater than zero");
372  
373         if (from != owner() && to != owner()) {
374  
375             //Trade start check
376             if (!tradingOpen) {
377                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
378             }
379  
380             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
381             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
382  
383             if(to != uniswapV2Pair) {
384                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
385             }
386  
387             uint256 contractTokenBalance = balanceOf(address(this));
388             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
389  
390             if(contractTokenBalance >= _maxTxAmount)
391             {
392                 contractTokenBalance = _maxTxAmount;
393             }
394  
395             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
396                 swapTokensForEth(contractTokenBalance);
397                 uint256 contractETHBalance = address(this).balance;
398                 if (contractETHBalance > 0) {
399                     sendETHToFee(address(this).balance);
400                 }
401             }
402         }
403  
404         bool takeFee = true;
405  
406         //Transfer Tokens
407         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
408             takeFee = false;
409         } else {
410  
411             //Set Fee for Buys
412             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
413                 _redisFee = _redisFeeOnBuy;
414                 _taxFee = _taxFeeOnBuy;
415             }
416  
417             //Set Fee for Sells
418             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
419                 _redisFee = _redisFeeOnSell;
420                 _taxFee = _taxFeeOnSell;
421             }
422  
423         }
424  
425         _tokenTransfer(from, to, amount, takeFee);
426     }
427  
428     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = uniswapV2Router.WETH();
432         _approve(address(this), address(uniswapV2Router), tokenAmount);
433         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             tokenAmount,
435             0,
436             path,
437             address(this),
438             block.timestamp
439         );
440     }
441  
442     function sendETHToFee(uint256 amount) private {
443         _marketingAddress.transfer(amount);
444     }
445 
446     ///Enables Trading
447     function setTrading(bool _tradingOpen) public onlyOwner {
448         tradingOpen = _tradingOpen;
449     }
450 
451     ///Withdrawls any eth that's sent to this contract
452     function manualswap() external {
453         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
454         uint256 contractBalance = balanceOf(address(this));
455         swapTokensForEth(contractBalance);
456     }
457 
458     ///Withdrawls any erc20 that's sent to this contract
459     function manualsend() external {
460         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
461         uint256 contractETHBalance = address(this).balance;
462         sendETHToFee(contractETHBalance);
463     }
464 
465     ///Input must be ["address","address"]
466     function blockBots(address[] memory bots_) public onlyOwner {
467         for (uint256 i = 0; i < bots_.length; i++) {
468             bots[bots_[i]] = true;
469         }
470     }
471 
472     ///Removes 1 address as bot
473     function unblockBot(address notbot) public onlyOwner {
474         bots[notbot] = false;
475     }
476  
477     function _tokenTransfer(
478         address sender,
479         address recipient,
480         uint256 amount,
481         bool takeFee
482     ) private {
483         if (!takeFee) removeAllFee();
484         _transferStandard(sender, recipient, amount);
485         if (!takeFee) restoreAllFee();
486     }
487  
488     function _transferStandard(
489         address sender,
490         address recipient,
491         uint256 tAmount
492     ) private {
493         (
494             uint256 rAmount,
495             uint256 rTransferAmount,
496             uint256 rFee,
497             uint256 tTransferAmount,
498             uint256 tFee,
499             uint256 tTeam
500         ) = _getValues(tAmount);
501         _rOwned[sender] = _rOwned[sender].sub(rAmount);
502         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
503         _takeTeam(tTeam);
504         _reflectFee(rFee, tFee);
505         emit Transfer(sender, recipient, tTransferAmount);
506     }
507  
508     function _takeTeam(uint256 tTeam) private {
509         uint256 currentRate = _getRate();
510         uint256 rTeam = tTeam.mul(currentRate);
511         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
512     }
513  
514     function _reflectFee(uint256 rFee, uint256 tFee) private {
515         _rTotal = _rTotal.sub(rFee);
516         _tFeeTotal = _tFeeTotal.add(tFee);
517     }
518  
519     receive() external payable {}
520  
521     function _getValues(uint256 tAmount)
522         private
523         view
524         returns (
525             uint256,
526             uint256,
527             uint256,
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
534             _getTValues(tAmount, _redisFee, _taxFee);
535         uint256 currentRate = _getRate();
536         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
537             _getRValues(tAmount, tFee, tTeam, currentRate);
538         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
539     }
540  
541     function _getTValues(
542         uint256 tAmount,
543         uint256 redisFee,
544         uint256 taxFee
545     )
546         private
547         pure
548         returns (
549             uint256,
550             uint256,
551             uint256
552         )
553     {
554         uint256 tFee = tAmount.mul(redisFee).div(100);
555         uint256 tTeam = tAmount.mul(taxFee).div(100);
556         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
557         return (tTransferAmount, tFee, tTeam);
558     }
559  
560     function _getRValues(
561         uint256 tAmount,
562         uint256 tFee,
563         uint256 tTeam,
564         uint256 currentRate
565     )
566         private
567         pure
568         returns (
569             uint256,
570             uint256,
571             uint256
572         )
573     {
574         uint256 rAmount = tAmount.mul(currentRate);
575         uint256 rFee = tFee.mul(currentRate);
576         uint256 rTeam = tTeam.mul(currentRate);
577         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
578         return (rAmount, rTransferAmount, rFee);
579     }
580  
581     function _getRate() private view returns (uint256) {
582         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
583         return rSupply.div(tSupply);
584     }
585  
586     function _getCurrentSupply() private view returns (uint256, uint256) {
587         uint256 rSupply = _rTotal;
588         uint256 tSupply = _tTotal;
589         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
590         return (rSupply, tSupply);
591     }
592 
593     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
594         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
595         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
596         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
597         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
598 
599         _redisFeeOnBuy = redisFeeOnBuy;
600         _redisFeeOnSell = redisFeeOnSell;
601         _taxFeeOnBuy = taxFeeOnBuy;
602         _taxFeeOnSell = taxFeeOnSell;
603 
604     }
605  
606     ///Set minimum tokens required to swap.
607     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
608         _swapTokensAtAmount = swapTokensAtAmount;
609     }
610  
611     ///Set minimum tokens required to swap.
612     function toggleSwap(bool _swapEnabled) public onlyOwner {
613         swapEnabled = _swapEnabled;
614     }
615  
616     ///Set maximum transaction
617     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
618            _maxTxAmount = maxTxAmount;
619         
620     }
621 
622     ///Set maximum wallet size
623     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
624         _maxWalletSize = maxWalletSize;
625     }
626 
627     ///This allows for other accounts to avoid the tax / walletsize / txn amount
628     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
629         for(uint256 i = 0; i < accounts.length; i++) {
630             _isExcludedFromFee[accounts[i]] = excluded;
631         }
632     }
633 
634 }