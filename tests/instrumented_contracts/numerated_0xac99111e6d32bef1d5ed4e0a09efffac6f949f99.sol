1 // SPDX-License-Identifier: MIT
2 /*
3   
4     _Waiter!! hey...
5 | Sorry, but the chef's
6 | shiba dog has stolen my steak!!
7 |_____________________|   /)     ____
8         \                //_    /    \%
9          \               \ /   / e  %%% ____
10              .\\///,     //   /_    ,)%    _\_______________
11             .\' _ _\    //      \_o_ /    |                 |
12             \| , (,(   //           \\_   |_Ohhhh, yes Sir, he
13              |   _\|  //           /><(\    REALLY loves it...
14               \_s__|_//            |H  \\
15             ___||_,::/             |H  |\\
16             |:/""\::/            __>---._\\
17             |/,  \\/            / ,|   |--'
18             |>  \ \|            \(-|___|<
19        _____(/____(|_____      /\/ \\  | )
20       /     ;..--..:     \     \/: :|  |()  * hha hha *
21      / _/_/((______))\_   \     \\_//  | )  ________         ____
22     / (/(_) '------' \\\   \     `-'|__|   u     ,  \       /__  \
23    /________________________\        |||   //>-.. /  )         \  ) )
24    '------------------------'        |||  (( )   \\_/__________/ /  _/
25       ||||   ||   ||   ||||          |||   ))\    \             <   _,'
26 ___||||___||___||___||||_ ____ _ _|||_ ((_/ ___| _  \__,-/   /__
27       ||||   >|   |<   ||||          >||          | /\  )( (   <
28       ||   ,' |   | `.   ||     __,-'/_(          |( | /  `.`-. \
29       ||  /__,'   `.__\  ||    /___,'  (         _|/_//  __//_//
30                                    |__,'        '-'--'  '--'--'
31 
32                                                                                                                        
33 
34 // +─────────+──────────────────────────────────────────────────────────+
35 // | NAME    | SHIBASTEAK                                               |
36 // +─────────+──────────────────────────────────────────────────────────+
37 // | TOKEN   | STEAK                                                    |
38 // +─────────+──────────────────────────────────────────────────────────+
39 // | WEBSITE | https://www.shibasteak.io/                               |
40 // +─────────+──────────────────────────────────────────────────────────+
41 // | TELEGRAM| https://t.me/ShibaSteakPortal                            |
42 // +─────────+──────────────────────────────────────────────────────────+
43 // | TOKEN   | TOTAL SUPPLY | 100,000,000                               |
44 // |         | LAUNCH       | STEALTH                                   |
45 // |         | MAX WALLET   | 2%                                        |
46 // |         | TAX          | 5/5                                       |
47 // +─────────+──────────────────────────────────────────────────────────+
48 
49  */
50 pragma solidity ^0.8.14;
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 }
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(
76         address indexed owner,
77         address indexed spender,
78         uint256 value
79     );
80 }
81 
82 contract Ownable is Context {
83     address private _owner;
84     address private _previousOwner;
85     event OwnershipTransferred(
86         address indexed previousOwner,
87         address indexed newOwner
88     );
89 
90     constructor() {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 
116 }
117 
118 library SafeMath {
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122         return c;
123     }
124 
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     function sub(
130         uint256 a,
131         uint256 b,
132         string memory errorMessage
133     ) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136         return c;
137     }
138 
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         if (a == 0) {
141             return 0;
142         }
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145         return c;
146     }
147 
148     function div(uint256 a, uint256 b) internal pure returns (uint256) {
149         return div(a, b, "SafeMath: division by zero");
150     }
151 
152     function div(
153         uint256 a,
154         uint256 b,
155         string memory errorMessage
156     ) internal pure returns (uint256) {
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         return c;
160     }
161 }
162 
163 interface IUniswapV2Factory {
164     function createPair(address tokenA, address tokenB)
165         external
166         returns (address pair);
167 }
168 
169 interface IUniswapV2Router02 {
170     function swapExactTokensForETHSupportingFeeOnTransferTokens(
171         uint256 amountIn,
172         uint256 amountOutMin,
173         address[] calldata path,
174         address to,
175         uint256 deadline
176     ) external;
177 
178     function factory() external pure returns (address);
179 
180     function WETH() external pure returns (address);
181 
182     function addLiquidityETH(
183         address token,
184         uint256 amountTokenDesired,
185         uint256 amountTokenMin,
186         uint256 amountETHMin,
187         address to,
188         uint256 deadline
189     )
190         external
191         payable
192         returns (
193             uint256 amountToken,
194             uint256 amountETH,
195             uint256 liquidity
196         );
197 }
198 
199 contract ShibaSteak is Context, IERC20, Ownable {
200 
201     using SafeMath for uint256;
202 
203     string private constant _name = "Steak";
204     string private constant _symbol = "STEAK";
205     uint8 private constant _decimals = 9;
206 
207     mapping(address => uint256) private _rOwned;
208     mapping(address => uint256) private _tOwned;
209     mapping(address => mapping(address => uint256)) private _allowances;
210     mapping(address => bool) private _isExcludedFromFee;
211     uint256 private constant MAX = ~uint256(0);
212     uint256 private constant _tTotal = 100000000 * 10**9;
213     uint256 private _rTotal = (MAX - (MAX % _tTotal));
214     uint256 private _tFeeTotal;
215     uint256 private _redisFeeOnBuy = 0;
216     uint256 private _taxFeeOnBuy = 10;
217     uint256 private _redisFeeOnSell = 0;
218     uint256 private _taxFeeOnSell = 20;
219 
220     //Original Fee
221     uint256 private _redisFee = _redisFeeOnSell;
222     uint256 private _taxFee = _taxFeeOnSell;
223 
224     uint256 private _previousredisFee = _redisFee;
225     uint256 private _previoustaxFee = _taxFee;
226 
227     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
228     mapping (address => bool) public preTrader;
229     address payable private _developmentAddress = payable(0x2a4286e90B010B96d74dBeaB4a9dde99aE4Eac97);
230     address payable private _treasuryAddress = payable(0xc8Bcc333F925E2C37aCD9B93c2b591763457eAc3);
231 
232     IUniswapV2Router02 public uniswapV2Router;
233     address public uniswapV2Pair;
234 
235     bool private tradingOpen;
236     bool private inSwap = false;
237     bool private swapEnabled = true;
238 
239     uint256 public _maxTxAmount = 1000001 * 10**9;
240     uint256 public _maxWalletSize = 2000001 * 10**9;
241     uint256 public _swapTokensAtAmount = 50000 * 10**9;
242 
243     event MaxTxAmountUpdated(uint256 _maxTxAmount);
244     modifier lockTheSwap {
245         inSwap = true;
246         _;
247         inSwap = false;
248     }
249 
250     constructor() {
251 
252         _rOwned[_msgSender()] = _rTotal;
253 
254         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
255         uniswapV2Router = _uniswapV2Router;
256         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
257             .createPair(address(this), _uniswapV2Router.WETH());
258 
259         _isExcludedFromFee[owner()] = true;
260         _isExcludedFromFee[address(this)] = true;
261         _isExcludedFromFee[_developmentAddress] = true;
262         _isExcludedFromFee[_treasuryAddress] = true;
263 
264         emit Transfer(address(0), _msgSender(), _tTotal);
265     }
266 
267     function name() public pure returns (string memory) {
268         return _name;
269     }
270 
271     function symbol() public pure returns (string memory) {
272         return _symbol;
273     }
274 
275     function decimals() public pure returns (uint8) {
276         return _decimals;
277     }
278 
279     function totalSupply() public pure override returns (uint256) {
280         return _tTotal;
281     }
282 
283     function balanceOf(address account) public view override returns (uint256) {
284         return tokenFromReflection(_rOwned[account]);
285     }
286 
287     function transfer(address recipient, uint256 amount)
288         public
289         override
290         returns (bool)
291     {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     function allowance(address owner, address spender)
297         public
298         view
299         override
300         returns (uint256)
301     {
302         return _allowances[owner][spender];
303     }
304 
305     function approve(address spender, uint256 amount)
306         public
307         override
308         returns (bool)
309     {
310         _approve(_msgSender(), spender, amount);
311         return true;
312     }
313 
314     function transferFrom(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) public override returns (bool) {
319         _transfer(sender, recipient, amount);
320         _approve(
321             sender,
322             _msgSender(),
323             _allowances[sender][_msgSender()].sub(
324                 amount,
325                 "ERC20: transfer amount exceeds allowance"
326             )
327         );
328         return true;
329     }
330 
331     function tokenFromReflection(uint256 rAmount)
332         private
333         view
334         returns (uint256)
335     {
336         require(
337             rAmount <= _rTotal,
338             "Amount must be less than total reflections"
339         );
340         uint256 currentRate = _getRate();
341         return rAmount.div(currentRate);
342     }
343 
344     function removeAllFee() private {
345         if (_redisFee == 0 && _taxFee == 0) return;
346 
347         _previousredisFee = _redisFee;
348         _previoustaxFee = _taxFee;
349 
350         _redisFee = 0;
351         _taxFee = 0;
352     }
353 
354     function restoreAllFee() private {
355         _redisFee = _previousredisFee;
356         _taxFee = _previoustaxFee;
357     }
358 
359     function _approve(
360         address owner,
361         address spender,
362         uint256 amount
363     ) private {
364         require(owner != address(0), "ERC20: approve from the zero address");
365         require(spender != address(0), "ERC20: approve to the zero address");
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) private {
375         require(from != address(0), "ERC20: transfer from the zero address");
376         require(to != address(0), "ERC20: transfer to the zero address");
377         require(amount > 0, "Transfer amount must be greater than zero");
378 
379         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
380 
381             //Trade start check
382             if (!tradingOpen) {
383                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
384             }
385 
386             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
387             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
388 
389             if(to != uniswapV2Pair) {
390                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
391             }
392 
393             uint256 contractTokenBalance = balanceOf(address(this));
394             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
395 
396             if(contractTokenBalance >= _maxTxAmount)
397             {
398                 contractTokenBalance = _maxTxAmount;
399             }
400 
401             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
402                 swapTokensForEth(contractTokenBalance);
403                 uint256 contractETHBalance = address(this).balance;
404                 if (contractETHBalance > 0) {
405                     sendETHToFee(address(this).balance);
406                 }
407             }
408         }
409 
410         bool takeFee = true;
411 
412         //Transfer Tokens
413         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
414             takeFee = false;
415         } else {
416 
417             //Set Fee for Buys
418             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
419                 _redisFee = _redisFeeOnBuy;
420                 _taxFee = _taxFeeOnBuy;
421             }
422 
423             //Set Fee for Sells
424             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
425                 _redisFee = _redisFeeOnSell;
426                 _taxFee = _taxFeeOnSell;
427             }
428 
429         }
430 
431         _tokenTransfer(from, to, amount, takeFee);
432     }
433 
434     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
435         address[] memory path = new address[](2);
436         path[0] = address(this);
437         path[1] = uniswapV2Router.WETH();
438         _approve(address(this), address(uniswapV2Router), tokenAmount);
439         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
440             tokenAmount,
441             0,
442             path,
443             address(this),
444             block.timestamp
445         );
446     }
447 
448     function sendETHToFee(uint256 amount) private {
449         _treasuryAddress.transfer(amount);
450     }
451 
452     function setTrading(bool _tradingOpen) public onlyOwner {
453         tradingOpen = _tradingOpen;
454     }
455 
456     function manualswap() external {
457         require(_msgSender() == _developmentAddress || _msgSender() == _treasuryAddress);
458         uint256 contractBalance = balanceOf(address(this));
459         swapTokensForEth(contractBalance);
460     }
461 
462     function manualsend() external {
463         require(_msgSender() == _developmentAddress || _msgSender() == _treasuryAddress);
464         uint256 contractETHBalance = address(this).balance;
465         sendETHToFee(contractETHBalance);
466     }
467 
468     function blockBots(address[] memory bots_) public onlyOwner {
469         for (uint256 i = 0; i < bots_.length; i++) {
470             bots[bots_[i]] = true;
471         }
472     }
473 
474     function unblockBot(address notbot) public onlyOwner {
475         bots[notbot] = false;
476     }
477 
478     function _tokenTransfer(
479         address sender,
480         address recipient,
481         uint256 amount,
482         bool takeFee
483     ) private {
484         if (!takeFee) removeAllFee();
485         _transferStandard(sender, recipient, amount);
486         if (!takeFee) restoreAllFee();
487     }
488 
489     function _transferStandard(
490         address sender,
491         address recipient,
492         uint256 tAmount
493     ) private {
494         (
495             uint256 rAmount,
496             uint256 rTransferAmount,
497             uint256 rFee,
498             uint256 tTransferAmount,
499             uint256 tFee,
500             uint256 tTeam
501         ) = _getValues(tAmount);
502         _rOwned[sender] = _rOwned[sender].sub(rAmount);
503         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
504         _takeTeam(tTeam);
505         _reflectFee(rFee, tFee);
506         emit Transfer(sender, recipient, tTransferAmount);
507     }
508 
509     function _takeTeam(uint256 tTeam) private {
510         uint256 currentRate = _getRate();
511         uint256 rTeam = tTeam.mul(currentRate);
512         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
513     }
514 
515     function _reflectFee(uint256 rFee, uint256 tFee) private {
516         _rTotal = _rTotal.sub(rFee);
517         _tFeeTotal = _tFeeTotal.add(tFee);
518     }
519 
520     receive() external payable {}
521 
522     function _getValues(uint256 tAmount)
523         private
524         view
525         returns (
526             uint256,
527             uint256,
528             uint256,
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
535             _getTValues(tAmount, _redisFee, _taxFee);
536         uint256 currentRate = _getRate();
537         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
538             _getRValues(tAmount, tFee, tTeam, currentRate);
539         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
540     }
541 
542     function _getTValues(
543         uint256 tAmount,
544         uint256 redisFee,
545         uint256 taxFee
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 tFee = tAmount.mul(redisFee).div(100);
556         uint256 tTeam = tAmount.mul(taxFee).div(100);
557         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
558         return (tTransferAmount, tFee, tTeam);
559     }
560 
561     function _getRValues(
562         uint256 tAmount,
563         uint256 tFee,
564         uint256 tTeam,
565         uint256 currentRate
566     )
567         private
568         pure
569         returns (
570             uint256,
571             uint256,
572             uint256
573         )
574     {
575         uint256 rAmount = tAmount.mul(currentRate);
576         uint256 rFee = tFee.mul(currentRate);
577         uint256 rTeam = tTeam.mul(currentRate);
578         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
579         return (rAmount, rTransferAmount, rFee);
580     }
581 
582     function _getRate() private view returns (uint256) {
583         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
584         return rSupply.div(tSupply);
585     }
586 
587     function _getCurrentSupply() private view returns (uint256, uint256) {
588         uint256 rSupply = _rTotal;
589         uint256 tSupply = _tTotal;
590         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
591         return (rSupply, tSupply);
592     }
593 
594     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
595         _redisFeeOnBuy = redisFeeOnBuy;
596         _redisFeeOnSell = redisFeeOnSell;
597         _taxFeeOnBuy = taxFeeOnBuy;
598         _taxFeeOnSell = taxFeeOnSell;
599     }
600 
601     //Set minimum tokens required to swap.
602     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
603         _swapTokensAtAmount = swapTokensAtAmount;
604     }
605 
606     //Set minimum tokens required to swap.
607     function toggleSwap(bool _swapEnabled) public onlyOwner {
608         swapEnabled = _swapEnabled;
609     }
610 
611     //Set maximum transaction
612     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
613         _maxTxAmount = maxTxAmount;
614     }
615 
616     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
617         _maxWalletSize = maxWalletSize;
618     }
619 
620     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
621         for(uint256 i = 0; i < accounts.length; i++) {
622             _isExcludedFromFee[accounts[i]] = excluded;
623         }
624     }
625 
626     function allowPreTrading(address[] calldata accounts) public onlyOwner {
627         for(uint256 i = 0; i < accounts.length; i++) {
628                  preTrader[accounts[i]] = true;
629         }
630     }
631 
632     function removePreTrading(address[] calldata accounts) public onlyOwner {
633         for(uint256 i = 0; i < accounts.length; i++) {
634                  delete preTrader[accounts[i]];
635         }
636     }
637 }