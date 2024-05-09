1 /**
2 */ 
3 
4 //104 116 116 112 115 58 47 47 116 46 109 101 47 69 116 104 101 114 101 117 109 83 116 101 97 108 116 104
5 //ASCII
6 
7 // https://toshi.tools/
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.4;
10 
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
22     function transfer(address recipient, uint256 amount)
23         external
24         returns (bool);
25 
26     function allowance(address owner, address spender)
27         external
28         view
29         returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         return c;
89     }
90 }
91 
92 contract Ownable is Context {
93     address private _owner;
94     address private _previousOwner;
95     event OwnershipTransferred(
96         address indexed previousOwner,
97         address indexed newOwner
98     );
99 
100     constructor() {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135 
136     function factory() external pure returns (address);
137 
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156 
157 contract ToshiTools is Context, IERC20, Ownable {
158     using SafeMath for uint256;
159 
160     string private constant _name = "Toshi Tools";
161     string private constant _symbol = "TOSHI";
162     uint8 private constant _decimals = 9;
163 
164     // RFI
165     mapping(address => uint256) private _rOwned;
166     mapping(address => uint256) private _tOwned;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 1000000000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173     uint256 private _taxFee = 0; 
174     uint256 private _buytax = 10; 
175     uint256 private _teamFee; 
176     uint256 private _sellTax = 20; 
177     uint256 private _previousTaxFee = _taxFee;
178     uint256 private _previousteamFee = _teamFee;
179     uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
180     uint256 private _routermax = 5000000000 * 10**9;
181 
182     // Bot detection
183     mapping(address => bool) private bots;
184     mapping(address => bool) private whitelist;
185     mapping(address => uint256) private cooldown;
186     address payable private _MarketTax;
187     address payable private _Dev;
188     address payable private _DevTax;
189     IUniswapV2Router02 private uniswapV2Router;
190     address private uniswapV2Pair;
191     bool private tradingOpen;
192     bool private inSwap = false;
193     bool private swapEnabled = false;
194     bool private publicsale = false;
195     uint256 private _maxTxAmount = _tTotal;
196     uint256 public launchBlock;
197 
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204 
205     constructor(address payable markettax, address payable devtax, address payable dev) {
206         _MarketTax = markettax;
207         _Dev = dev;
208         _DevTax = devtax;
209         _rOwned[_msgSender()] = _rTotal;
210         _isExcludedFromFee[owner()] = true;
211         _isExcludedFromFee[address(this)] = true;
212         _isExcludedFromFee[_MarketTax] = true;
213         _isExcludedFromFee[_DevTax] = true;
214         _isExcludedFromFee[_Dev] = true;
215         emit Transfer(address(0), _msgSender(), _tTotal);
216     }
217 
218     function name() public pure returns (string memory) {
219         return _name;
220     }
221 
222     function symbol() public pure returns (string memory) {
223         return _symbol;
224     }
225 
226     function decimals() public pure returns (uint8) {
227         return _decimals;
228     }
229 
230     function totalSupply() public pure override returns (uint256) {
231         return _tTotal;
232     }
233 
234     function balanceOf(address account) public view override returns (uint256) {
235         return tokenFromReflection(_rOwned[account]);
236     }
237 
238     function transfer(address recipient, uint256 amount)
239         public
240         override
241         returns (bool)
242     {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     function allowance(address owner, address spender)
248         public
249         view
250         override
251         returns (uint256)
252     {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public override returns (bool) {
270         _transfer(sender, recipient, amount);
271         _approve(
272             sender,
273             _msgSender(),
274             _allowances[sender][_msgSender()].sub(
275                 amount,
276                 "ERC20: transfer amount exceeds allowance"
277             )
278         );
279         return true;
280     }
281 
282     function tokenFromReflection(uint256 rAmount)
283         private
284         view
285         returns (uint256)
286     {
287         require(
288             rAmount <= _rTotal,
289             "Amount must be less than total reflections"
290         );
291         uint256 currentRate = _getRate();
292         return rAmount.div(currentRate);
293     }
294 
295     function removeAllFee() private {
296         if(_taxFee == 0 && _teamFee == 0) return;
297 
298         _previousTaxFee = _taxFee;
299         _previousteamFee = _teamFee;
300 
301         _taxFee = 0;
302         _teamFee = 0;
303     }
304 
305     function restoreAllFee() private {
306         _taxFee = _previousTaxFee;
307         _teamFee = _previousteamFee;
308     }
309     
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) private {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     function _transfer(
322         address from,
323         address to,
324         uint256 amount
325     ) private {
326         require(from != address(0), "ERC20: transfer from the zero address");
327         require(to != address(0), "ERC20: transfer to the zero address");
328         require(amount > 0, "Transfer amount must be greater than zero");
329         
330         if (from != owner() && to != owner()) {
331 
332             if(from != address(this)){
333                 require(amount <= _maxTxAmount);
334             }
335             if(!publicsale){
336                 require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
337             }
338             if(from != owner() && to != owner()){
339                 _teamFee = _buytax;
340             }
341             require(!bots[from] && !bots[to] && !bots[msg.sender]);
342             
343              uint256 contractTokenBalance = balanceOf(address(this));
344             
345             if(contractTokenBalance >= _routermax)
346             {
347                 contractTokenBalance = _routermax;
348             }
349             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
350             if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
351             ) {
352                 _teamFee = _sellTax;
353                 // We need to swap the current tokens to ETH and send to the team wallet
354                 swapTokensForEth(contractTokenBalance);
355                 
356                 uint256 contractETHBalance = address(this).balance;
357                 if(contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362         bool takeFee = true;
363 
364         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
365             takeFee = false;
366         }
367 
368         _tokenTransfer(from, to, amount, takeFee);
369     }
370 
371     function isExcluded(address account) public view returns (bool) {
372         return _isExcludedFromFee[account];
373     }
374 
375     function isBlackListed(address account) public view returns (bool) {
376         return bots[account];
377     }
378     function isWhiteListed(address account) public view returns (bool) {
379         return whitelist[account];
380     }
381     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
382             // generate the uniswap pair path of token -> weth
383             address[] memory path = new address[](2);
384             path[0] = address(this);
385             path[1] = uniswapV2Router.WETH();
386 
387             _approve(address(this), address(uniswapV2Router), tokenAmount);
388 
389             // make the swap
390             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
391                 tokenAmount,
392                 0, // accept any amount of ETH
393                 path,
394                 address(this),
395                 block.timestamp
396             );
397     }
398 
399     function sendETHToFee(uint256 amount) private {
400         _MarketTax.transfer(amount.div(10).mul(4));
401         _DevTax.transfer(amount.div(10).mul(6));
402     }
403 
404     function openTrading() external onlyOwner() {
405         require(!tradingOpen, "trading is already open");
406         IUniswapV2Router02 _uniswapV2Router =
407             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
408         uniswapV2Router = _uniswapV2Router;
409         _approve(address(this), address(uniswapV2Router), _tTotal);
410         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
411             .createPair(address(this), _uniswapV2Router.WETH());
412         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
413             address(this),
414             balanceOf(address(this)),
415             0,
416             0,
417             owner(),
418             block.timestamp
419         );
420         swapEnabled = true;
421         publicsale = false;
422         _maxTxAmount = 5000000000 * 10**9;
423         launchBlock = block.number;
424         tradingOpen = true;
425         IERC20(uniswapV2Pair).approve(
426             address(uniswapV2Router),
427             type(uint256).max
428         );
429     }
430     
431     function setSwapEnabled(bool enabled) external {
432         require(_msgSender() == _Dev);
433         swapEnabled = enabled;
434     }
435         
436 
437     function manualswap() external {
438         require(_msgSender() == _Dev);
439         uint256 contractBalance = balanceOf(address(this));
440         swapTokensForEth(contractBalance);
441     }
442     function manualswapcustom(uint256 percentage) external {
443         require(_msgSender() == _Dev);
444         uint256 contractBalance = balanceOf(address(this));
445         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
446         swapTokensForEth(swapbalance);
447     }
448     function manualsend() external {
449         require(_msgSender() == _Dev);
450         uint256 contractETHBalance = address(this).balance;
451         sendETHToFee(contractETHBalance);
452     }
453 
454     function setBots(address[] memory bots_) public onlyOwner() {
455         for (uint256 i = 0; i < bots_.length; i++) {
456             bots[bots_[i]] = true;
457         }
458     }
459     function setWhitelist(address[] memory whitelist_) public onlyOwner() {
460         for (uint256 i = 0; i < whitelist_.length; i++) {
461             whitelist[whitelist_[i]] = true;
462         }
463     }
464     function delBot(address notbot) public onlyOwner() {
465         bots[notbot] = false;
466     }
467 
468     function _tokenTransfer(
469         address sender,
470         address recipient,
471         uint256 amount,
472         bool takeFee
473     ) private {
474         if (!takeFee) removeAllFee();
475         _transferStandard(sender, recipient, amount);
476         if (!takeFee) restoreAllFee();
477     }
478 
479     function _transferStandard(
480         address sender,
481         address recipient,
482         uint256 tAmount
483     ) private {
484         (
485             uint256 rAmount,
486             uint256 rTransferAmount,
487             uint256 rFee,
488             uint256 tTransferAmount,
489             uint256 tFee,
490             uint256 tTeam
491         ) = _getValues(tAmount);
492         _rOwned[sender] = _rOwned[sender].sub(rAmount);
493         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
494         _takeTeam(tTeam);
495         _reflectFee(rFee, tFee);
496         emit Transfer(sender, recipient, tTransferAmount);
497     }
498 
499     function _takeTeam(uint256 tTeam) private {
500         uint256 currentRate = _getRate();
501         uint256 rTeam = tTeam.mul(currentRate);
502         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
503     }
504 
505     function _reflectFee(uint256 rFee, uint256 tFee) private {
506         _rTotal = _rTotal.sub(rFee);
507         _tFeeTotal = _tFeeTotal.add(tFee);
508     }
509 
510     receive() external payable {}
511 
512     function _getValues(uint256 tAmount)
513         private
514         view
515         returns (
516             uint256,
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
525             _getTValues(tAmount, _taxFee, _teamFee);
526         uint256 currentRate = _getRate();
527         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
528             _getRValues(tAmount, tFee, tTeam, currentRate);
529         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
530     }
531 
532     function _getTValues(
533         uint256 tAmount,
534         uint256 taxFee,
535         uint256 TeamFee
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 tFee = tAmount.mul(taxFee).div(100);
546         uint256 tTeam = tAmount.mul(TeamFee).div(100);
547         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
548         return (tTransferAmount, tFee, tTeam);
549     }
550 
551     function _getRValues(
552         uint256 tAmount,
553         uint256 tFee,
554         uint256 tTeam,
555         uint256 currentRate
556     )
557         private
558         pure
559         returns (
560             uint256,
561             uint256,
562             uint256
563         )
564     {
565         uint256 rAmount = tAmount.mul(currentRate);
566         uint256 rFee = tFee.mul(currentRate);
567         uint256 rTeam = tTeam.mul(currentRate);
568         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
569         return (rAmount, rTransferAmount, rFee);
570     }
571 
572     function _getRate() private view returns (uint256) {
573         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
574         return rSupply.div(tSupply);
575     }
576 
577     function _getCurrentSupply() private view returns (uint256, uint256) {
578         uint256 rSupply = _rTotal;
579         uint256 tSupply = _tTotal;
580         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
581         return (rSupply, tSupply);
582     }
583 
584     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
585         require(maxTxPercent > 0, "Amount must be greater than 0");
586         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
587         emit MaxTxAmountUpdated(_maxTxAmount);
588     }
589     function setRouterPercent(uint256 maxRouterPercent) external {
590         require(_msgSender() == _Dev);
591         require(maxRouterPercent > 0, "Amount must be greater than 0");
592         _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
593     }
594     
595     function _setSellTax(uint256 selltax) external onlyOwner() {
596         require(selltax >= 0 && selltax <= 40, 'selltax should be in 0 - 40');
597         _sellTax = selltax;
598     }
599     
600     function _setBuyTax(uint256 buytax) external onlyOwner() {
601         require(buytax >= 0 && buytax <= 10, 'buytax should be in 0 - 10');
602         _buytax = buytax;
603     }
604     
605     function excludeFromFee(address account) public onlyOwner {
606         _isExcludedFromFee[account] = true;
607     }
608     function setMarket(address payable account) external {
609         require(_msgSender() == _Dev);
610         _MarketTax = account;
611     }
612 
613     function setDev(address payable account) external {
614         require(_msgSender() == _Dev);
615         _Dev = account;
616     }
617     function setDevpay(address payable account) external {
618         require(_msgSender() == _Dev);
619         _DevTax = account;
620     }
621     function OpenPublic() external onlyOwner() {
622         publicsale = true;
623     }
624     function _ZeroSellTax() external {
625         require(_msgSender() == _Dev);
626         _sellTax = 0;
627     }
628     function _ZeroBuyTax() external {
629         require(_msgSender() == _Dev);
630         _buytax = 0;
631     }
632 }