1 // _,_
2 //    .--.  .-"     "-.  .--.
3 //   / .. \/  .-. .-.  \/ .. \
4 //  | |  '|  /   Y   \  |'  | |
5 //  | \   \  \ 0 | 0 /  /   / |
6 //   \ '- ,\.-"`` ``"-./, -' /
7 //    `'-' /_   ^ ^   _\ '-'`
8 //        |  \._   _./  |
9 //        \   \ `~` /   /
10 //         '._ '-=-' _.'
11 //             '---'
12 // WEBSITE: safuape.finance
13 // TELEGRAM: https://t.me/SafuApeETH
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity ^0.8.4;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76     
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82     
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 contract SAFUAPE is Context, IERC20, Ownable {
167     
168     using SafeMath for uint256;
169 
170     string private constant _name = "SAFUAPE";
171     string private constant _symbol = "SAPE";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping (address => uint256) private _buyMap;
177     mapping(address => mapping(address => uint256)) private _allowances;
178     mapping(address => bool) private _isExcludedFromFee;
179     uint256 private constant MAX = ~uint256(0);
180     uint256 private constant _tTotal = 1e12 * 10**9;
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183     mapping(address => bool) private _isSniper;
184     uint256 public launchTime;
185 
186     // Jeets out Fee
187     uint256 private _redisFeeJeets = 0;
188     uint256 private _taxFeeJeets = 17;
189 
190     // Buy Fee
191     uint256 private _redisFeeOnBuy = 0;
192     uint256 private _taxFeeOnBuy = 5;
193     
194     // Sell Fee
195     uint256 private _redisFeeOnSell = 0;
196     uint256 private _taxFeeOnSell = 12;
197     
198     // Original Fee
199     uint256 private _redisFee = _redisFeeOnSell;
200     uint256 private _taxFee = _taxFeeOnSell;
201     uint256 private _burnFee = 0;
202     
203     uint256 private _previousredisFee = _redisFee;
204     uint256 private _previoustaxFee = _taxFee;
205     uint256 private _previousburnFee = _burnFee;
206     
207     address payable private _marketingAddress = payable(0xB6cE6712871B8FCcAF2a593C56680866442F29b3);
208     address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;
209 
210     uint256 public timeJeets = 2 hours;
211     IUniswapV2Router02 public uniswapV2Router;
212     address public uniswapV2Pair;
213     
214     bool private tradingOpen;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217     bool private isMaxBuyActivated = true;
218     
219     uint256 public _maxTxAmount = 15e9 * 10**9; //1.5%
220     uint256 public _maxWalletSize = 3e10 * 10**9; //3%
221     uint256 public _swapTokensAtAmount = 1000 * 10**9;
222     uint256 public _minimumBuyAmount = 15e9 * 10**9 ; // 1.5%
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
235         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236         uniswapV2Router = _uniswapV2Router;
237         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
238             .createPair(address(this), _uniswapV2Router.WETH());
239 
240         _isExcludedFromFee[owner()] = true;
241         _isExcludedFromFee[address(this)] = true;
242         _isExcludedFromFee[_marketingAddress] = true;
243         _isExcludedFromFee[deadAddress] = true;
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
326         if (_redisFee == 0 && _taxFee == 0 && _burnFee == 0) return;
327     
328         _previousredisFee = _redisFee;
329         _previoustaxFee = _taxFee;
330         _previousburnFee = _burnFee;
331         
332         _redisFee = 0;
333         _taxFee = 0;
334         _burnFee = 0;
335     }
336 
337     function restoreAllFee() private {
338         _redisFee = _previousredisFee;
339         _taxFee = _previoustaxFee;
340         _burnFee = _previousburnFee;
341     }
342 
343     function _approve(
344         address owner,
345         address spender,
346         uint256 amount
347     ) private {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354     function _transfer(
355         address from,
356         address to,
357         uint256 amount
358     ) private {
359         require(from != address(0), "ERC20: transfer from the zero address");
360         require(to != address(0), "ERC20: transfer to the zero address");
361         require(amount > 0, "Transfer amount must be greater than zero");
362         require(!_isSniper[to], 'Stop sniping!');
363         require(!_isSniper[from], 'Stop sniping!');
364         require(!_isSniper[_msgSender()], 'Stop sniping!');
365 
366         if (from != owner() && to != owner()) {
367             
368             // Trade start check
369             if (!tradingOpen) {
370                 revert("Trading not yet enabled!");
371             }
372             
373             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
374                 if (to != address(this) && from != address(this) && to != _marketingAddress && from != _marketingAddress) {
375                     require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
376                 }
377             }
378 
379             if (to != uniswapV2Pair && to != _marketingAddress && to != address(this) && to != deadAddress) {
380                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
381                 if (isMaxBuyActivated) {
382                     if (block.timestamp <= launchTime + 20 minutes) {
383                         require(amount <= _minimumBuyAmount, "Amount too much");
384                     }
385                 }
386             }
387             
388             uint256 contractTokenBalance = balanceOf(address(this));
389             bool canSwap = contractTokenBalance > _swapTokensAtAmount;
390             
391             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
392                 uint256 burntAmount = 0;
393                 if (_burnFee > 0) {
394                     burntAmount = contractTokenBalance.mul(_burnFee).div(10**2);
395                     burnTokens(burntAmount);
396                 }
397                 swapTokensForEth(contractTokenBalance - burntAmount);
398                 uint256 contractETHBalance = address(this).balance;
399                 if (contractETHBalance > 0) {
400                     sendETHToFee(address(this).balance);
401                 }
402             }
403         }
404         
405         bool takeFee = true;
406 
407         // Transfer Tokens
408         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
409             takeFee = false;
410         } else {
411             // Set Fee for Buys
412             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
413                     _buyMap[to] = block.timestamp;
414                     _redisFee = _redisFeeOnBuy;
415                     _taxFee = _taxFeeOnBuy;
416                     // antibot
417                     if (block.timestamp == launchTime) {
418                         _isSniper[to] = true;
419                     }
420             }
421     
422             // Set Fee for Sells
423             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
424                 if (_buyMap[from] != 0 && (_buyMap[from] + timeJeets >= block.timestamp)) {
425                     _redisFee = _redisFeeJeets;
426                     _taxFee = _taxFeeJeets;
427                 } else {
428                     _redisFee = _redisFeeOnSell;
429                     _taxFee = _taxFeeOnSell;
430                 }
431             }
432         }
433 
434         _tokenTransfer(from, to, amount, takeFee);
435     }
436 
437     function burnTokens(uint256 burntAmount) private {
438         _transfer(address(this), deadAddress, burntAmount);
439     }
440 
441     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
442         address[] memory path = new address[](2);
443         path[0] = address(this);
444         path[1] = uniswapV2Router.WETH();
445         _approve(address(this), address(uniswapV2Router), tokenAmount);
446         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
447             tokenAmount,
448             0,
449             path,
450             address(this),
451             block.timestamp
452         );
453     }
454 
455     function sendETHToFee(uint256 amount) private {
456         _marketingAddress.transfer(amount);
457     }
458 
459     function setTrading(bool _tradingOpen) public onlyOwner {
460         tradingOpen = _tradingOpen;
461         launchTime = block.timestamp;
462     }
463 
464     function setMarketingWallet(address marketingAddress) external {
465         require(_msgSender() == _marketingAddress);
466         _marketingAddress = payable(marketingAddress);
467         _isExcludedFromFee[_marketingAddress] = true;
468     }
469 
470     function setIsMaxBuyActivated(bool _isMaxBuyActivated) public onlyOwner {
471         isMaxBuyActivated = _isMaxBuyActivated;
472     }
473 
474     function manualswap(uint256 amount) external {
475         require(_msgSender() == _marketingAddress);
476         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
477         swapTokensForEth(amount);
478     }
479 
480     function addSniper(address sniper) external onlyOwner {
481         _isSniper[sniper] = true;
482     }
483 
484     function removeSniper(address sniper) external onlyOwner {
485         if (_isSniper[sniper]) {
486             _isSniper[sniper] = false;
487         }
488     }
489 
490     function isSniper(address sniper) external view returns (bool){
491         return _isSniper[sniper];
492     }
493 
494     function manualsend() external {
495         require(_msgSender() == _marketingAddress);
496         uint256 contractETHBalance = address(this).balance;
497         sendETHToFee(contractETHBalance);
498     }
499 
500     function _tokenTransfer(
501         address sender,
502         address recipient,
503         uint256 amount,
504         bool takeFee
505     ) private {
506         if (!takeFee) removeAllFee();
507         _transferStandard(sender, recipient, amount);
508         if (!takeFee) restoreAllFee();
509     }
510 
511     function _transferStandard(
512         address sender,
513         address recipient,
514         uint256 tAmount
515     ) private {
516         (
517             uint256 rAmount,
518             uint256 rTransferAmount,
519             uint256 rFee,
520             uint256 tTransferAmount,
521             uint256 tFee,
522             uint256 tTeam
523         ) = _getValues(tAmount);
524         _rOwned[sender] = _rOwned[sender].sub(rAmount);
525         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
526         _takeTeam(tTeam);
527         _reflectFee(rFee, tFee);
528         emit Transfer(sender, recipient, tTransferAmount);
529     }
530 
531     function _takeTeam(uint256 tTeam) private {
532         uint256 currentRate = _getRate();
533         uint256 rTeam = tTeam.mul(currentRate);
534         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
535     }
536 
537     function _reflectFee(uint256 rFee, uint256 tFee) private {
538         _rTotal = _rTotal.sub(rFee);
539         _tFeeTotal = _tFeeTotal.add(tFee);
540     }
541 
542     receive() external payable {}
543 
544     function _getValues(uint256 tAmount)
545         private
546         view
547         returns (
548             uint256,
549             uint256,
550             uint256,
551             uint256,
552             uint256,
553             uint256
554         )
555     {
556         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
557             _getTValues(tAmount, _redisFee, _taxFee);
558         uint256 currentRate = _getRate();
559         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
560             _getRValues(tAmount, tFee, tTeam, currentRate);
561         
562         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
563     }
564 
565     function _getTValues(
566         uint256 tAmount,
567         uint256 redisFee,
568         uint256 taxFee
569     )
570         private
571         pure
572         returns (
573             uint256,
574             uint256,
575             uint256
576         )
577     {
578         uint256 tFee = tAmount.mul(redisFee).div(100);
579         uint256 tTeam = tAmount.mul(taxFee).div(100);
580         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
581 
582         return (tTransferAmount, tFee, tTeam);
583     }
584 
585     function _getRValues(
586         uint256 tAmount,
587         uint256 tFee,
588         uint256 tTeam,
589         uint256 currentRate
590     )
591         private
592         pure
593         returns (
594             uint256,
595             uint256,
596             uint256
597         )
598     {
599         uint256 rAmount = tAmount.mul(currentRate);
600         uint256 rFee = tFee.mul(currentRate);
601         uint256 rTeam = tTeam.mul(currentRate);
602         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
603 
604         return (rAmount, rTransferAmount, rFee);
605     }
606 
607     function _getRate() private view returns (uint256) {
608         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
609 
610         return rSupply.div(tSupply);
611     }
612 
613     function _getCurrentSupply() private view returns (uint256, uint256) {
614         uint256 rSupply = _rTotal;
615         uint256 tSupply = _tTotal;
616         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
617     
618         return (rSupply, tSupply);
619     }
620 
621     function toggleSwap(bool _swapEnabled) public onlyOwner {
622         swapEnabled = _swapEnabled;
623     }
624     
625     function setMaxTxnAmount(uint256 maxTxAmount) external onlyOwner {
626         require(maxTxAmount >= 5e9 * 10**9, "Maximum transaction amount must be greater than 0.5%");
627         _maxTxAmount = maxTxAmount;
628     }
629     
630     function setMaxWalletSize(uint256 maxWalletSize) external onlyOwner {
631         require(maxWalletSize >= _maxWalletSize);
632         _maxWalletSize = maxWalletSize;
633     }
634 
635     // USUAL TAXES CANNOT BE RAISED MORE THAN 15%
636     function setTaxFee(uint256 amountBuy, uint256 amountSell) external onlyOwner {
637         require(amountBuy >= 0 && amountBuy <= 13);
638         require(amountSell >= 0 && amountSell <= 13);
639         _taxFeeOnBuy = amountBuy;
640         _taxFeeOnSell = amountSell;
641     }
642 
643     function setRefFee(uint256 amountRefBuy, uint256 amountRefSell) external onlyOwner {
644         require(amountRefBuy >= 0 && amountRefBuy <= 1);
645         require(amountRefSell >= 0 && amountRefSell <= 1);
646         _redisFeeOnBuy = amountRefBuy;
647         _redisFeeOnSell = amountRefSell;
648     }
649 
650     function setBurnFee(uint256 amount) external onlyOwner {
651         require(amount >= 0 && amount <= 1);
652         _burnFee = amount;
653     }
654 
655     // FAST SELL TAXES CANNOT BE RAISED MORE THAN 20% and 4 hours
656     function setJeetsFee(uint256 amountRedisJeets, uint256 amountTaxJeets) external onlyOwner {
657         require(amountRedisJeets >= 0 && amountRedisJeets <= 1);
658         require(amountTaxJeets >= 0 && amountTaxJeets <= 19);
659         _redisFeeJeets = amountRedisJeets;
660         _taxFeeJeets = amountTaxJeets;
661     }
662 
663     function setTimeJeets(uint256 hoursTime) external onlyOwner {
664         require(hoursTime >= 0 && hoursTime <= 4);
665         timeJeets = hoursTime * 1 hours;
666     }
667 
668 }