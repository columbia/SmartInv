1 //104 116 116 112 115 58 47 47 116 46 109 101 47 69 116 104 101 114 101 117 109 83 116 101 97 108 116 104
2 //ASCII
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount)
18         external
19         returns (bool);
20 
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(
54         uint256 a,
55         uint256 b,
56         string memory errorMessage
57     ) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89     address private _previousOwner;
90     event OwnershipTransferred(
91         address indexed previousOwner,
92         address indexed newOwner
93     );
94 
95     constructor() {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(_owner == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130 
131     function factory() external pure returns (address);
132 
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151 
152 contract ENGINE is Context, IERC20, Ownable {
153     using SafeMath for uint256;
154 
155     string private constant _name = "Engine";
156     string private constant _symbol = "ENGN";
157     uint8 private constant _decimals = 9;
158 
159     // RFI
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 1000000000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _taxFee = 0; // 0%
169     uint256 private _buytax = 10; // Buy tax 10% 
170     uint256 private _teamFee; 
171     uint256 private _sellTax = 30;  // Launch sell tax 30% for 30mins. Then Sell tax down to 10%.
172     uint256 private _previousTaxFee = _taxFee;
173     uint256 private _previousteamFee = _teamFee;
174     uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
175     uint256 private _routermax = 5000000000 * 10**9;
176 
177     // Bot detection
178     mapping(address => bool) private bots;
179     mapping(address => bool) private whitelist;
180     mapping(address => uint256) private cooldown;
181     address payable private _MarketTax;
182     address payable private _Dev;
183     address payable private _DevTax;
184     IUniswapV2Router02 private uniswapV2Router;
185     address private uniswapV2Pair;
186     bool private tradingOpen;
187     bool private inSwap = false;
188     bool private swapEnabled = false;
189     bool private publicsale = false;
190     uint256 private _maxTxAmount = _tTotal;
191     uint256 public launchBlock;
192 
193     event MaxTxAmountUpdated(uint256 _maxTxAmount);
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200     constructor(address payable markettax, address payable devtax, address payable dev) {
201         _MarketTax = markettax;
202         _Dev = dev;
203         _DevTax = devtax;
204         _rOwned[_msgSender()] = _rTotal;
205         _isExcludedFromFee[owner()] = true;
206         _isExcludedFromFee[address(this)] = true;
207         _isExcludedFromFee[_MarketTax] = true;
208         _isExcludedFromFee[_DevTax] = true;
209         _isExcludedFromFee[_Dev] = true;
210         emit Transfer(address(0), _msgSender(), _tTotal);
211     }
212 
213     function name() public pure returns (string memory) {
214         return _name;
215     }
216 
217     function symbol() public pure returns (string memory) {
218         return _symbol;
219     }
220 
221     function decimals() public pure returns (uint8) {
222         return _decimals;
223     }
224 
225     function totalSupply() public pure override returns (uint256) {
226         return _tTotal;
227     }
228 
229     function balanceOf(address account) public view override returns (uint256) {
230         return tokenFromReflection(_rOwned[account]);
231     }
232 
233     function transfer(address recipient, uint256 amount)
234         public
235         override
236         returns (bool)
237     {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     function allowance(address owner, address spender)
243         public
244         view
245         override
246         returns (uint256)
247     {
248         return _allowances[owner][spender];
249     }
250 
251     function approve(address spender, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) public override returns (bool) {
265         _transfer(sender, recipient, amount);
266         _approve(
267             sender,
268             _msgSender(),
269             _allowances[sender][_msgSender()].sub(
270                 amount,
271                 "ERC20: transfer amount exceeds allowance"
272             )
273         );
274         return true;
275     }
276 
277     function tokenFromReflection(uint256 rAmount)
278         private
279         view
280         returns (uint256)
281     {
282         require(
283             rAmount <= _rTotal,
284             "Amount must be less than total reflections"
285         );
286         uint256 currentRate = _getRate();
287         return rAmount.div(currentRate);
288     }
289 
290     function removeAllFee() private {
291         if(_taxFee == 0 && _teamFee == 0) return;
292 
293         _previousTaxFee = _taxFee;
294         _previousteamFee = _teamFee;
295 
296         _taxFee = 0;
297         _teamFee = 0;
298     }
299 
300     function restoreAllFee() private {
301         _taxFee = _previousTaxFee;
302         _teamFee = _previousteamFee;
303     }
304     
305     function _approve(
306         address owner,
307         address spender,
308         uint256 amount
309     ) private {
310         require(owner != address(0), "ERC20: approve from the zero address");
311         require(spender != address(0), "ERC20: approve to the zero address");
312         _allowances[owner][spender] = amount;
313         emit Approval(owner, spender, amount);
314     }
315 
316     function _transfer(
317         address from,
318         address to,
319         uint256 amount
320     ) private {
321         require(from != address(0), "ERC20: transfer from the zero address");
322         require(to != address(0), "ERC20: transfer to the zero address");
323         require(amount > 0, "Transfer amount must be greater than zero");
324         
325         if (from != owner() && to != owner()) {
326 
327             if(from != address(this)){
328                 require(amount <= _maxTxAmount);
329             }
330             if(!publicsale){
331                 require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
332             }
333             if(from != owner() && to != owner()){
334                 _teamFee = _buytax;
335             }
336             require(!bots[from] && !bots[to] && !bots[msg.sender]);
337             
338              uint256 contractTokenBalance = balanceOf(address(this));
339             
340             if(contractTokenBalance >= _routermax)
341             {
342                 contractTokenBalance = _routermax;
343             }
344             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
345             if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
346             ) {
347                 _teamFee = _sellTax;
348                 // We need to swap the current tokens to ETH and send to the team wallet
349                 swapTokensForEth(contractTokenBalance);
350                 
351                 uint256 contractETHBalance = address(this).balance;
352                 if(contractETHBalance > 0) {
353                     sendETHToFee(address(this).balance);
354                 }
355             }
356         }
357         bool takeFee = true;
358 
359         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
360             takeFee = false;
361         }
362 
363         _tokenTransfer(from, to, amount, takeFee);
364     }
365 
366     function isExcluded(address account) public view returns (bool) {
367         return _isExcludedFromFee[account];
368     }
369 
370     function isBlackListed(address account) public view returns (bool) {
371         return bots[account];
372     }
373     function isWhiteListed(address account) public view returns (bool) {
374         return whitelist[account];
375     }
376     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
377             // generate the uniswap pair path of token -> weth
378             address[] memory path = new address[](2);
379             path[0] = address(this);
380             path[1] = uniswapV2Router.WETH();
381 
382             _approve(address(this), address(uniswapV2Router), tokenAmount);
383 
384             // make the swap
385             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
386                 tokenAmount,
387                 0, // accept any amount of ETH
388                 path,
389                 address(this),
390                 block.timestamp
391             );
392     }
393 
394     function sendETHToFee(uint256 amount) private {
395         _MarketTax.transfer(amount.div(10).mul(4));
396         _DevTax.transfer(amount.div(10).mul(6));
397     }
398 
399     function openTrading() external onlyOwner() {
400         require(!tradingOpen, "trading is already open");
401         IUniswapV2Router02 _uniswapV2Router =
402             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
403         uniswapV2Router = _uniswapV2Router;
404         _approve(address(this), address(uniswapV2Router), _tTotal);
405         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
406             .createPair(address(this), _uniswapV2Router.WETH());
407         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
408             address(this),
409             balanceOf(address(this)),
410             0,
411             0,
412             owner(),
413             block.timestamp
414         );
415         swapEnabled = true;
416         publicsale = false;
417         _maxTxAmount = 20000000000 * 10**9;
418         launchBlock = block.number;
419         tradingOpen = true;
420         IERC20(uniswapV2Pair).approve(
421             address(uniswapV2Router),
422             type(uint256).max
423         );
424     }
425     
426     function setSwapEnabled(bool enabled) external {
427         require(_msgSender() == _Dev);
428         swapEnabled = enabled;
429     }
430         
431 
432     function manualswap() external {
433         require(_msgSender() == _Dev);
434         uint256 contractBalance = balanceOf(address(this));
435         swapTokensForEth(contractBalance);
436     }
437     function manualswapcustom(uint256 percentage) external {
438         require(_msgSender() == _Dev);
439         uint256 contractBalance = balanceOf(address(this));
440         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
441         swapTokensForEth(swapbalance);
442     }
443     function manualsend() external {
444         require(_msgSender() == _Dev);
445         uint256 contractETHBalance = address(this).balance;
446         sendETHToFee(contractETHBalance);
447     }
448 
449     function setBots(address[] memory bots_) public onlyOwner() {
450         for (uint256 i = 0; i < bots_.length; i++) {
451             bots[bots_[i]] = true;
452         }
453     }
454     function setWhitelist(address[] memory whitelist_) public onlyOwner() {
455         for (uint256 i = 0; i < whitelist_.length; i++) {
456             whitelist[whitelist_[i]] = true;
457         }
458     }
459     function delBot(address notbot) public onlyOwner() {
460         bots[notbot] = false;
461     }
462 
463     function _tokenTransfer(
464         address sender,
465         address recipient,
466         uint256 amount,
467         bool takeFee
468     ) private {
469         if (!takeFee) removeAllFee();
470         _transferStandard(sender, recipient, amount);
471         if (!takeFee) restoreAllFee();
472     }
473 
474     function _transferStandard(
475         address sender,
476         address recipient,
477         uint256 tAmount
478     ) private {
479         (
480             uint256 rAmount,
481             uint256 rTransferAmount,
482             uint256 rFee,
483             uint256 tTransferAmount,
484             uint256 tFee,
485             uint256 tTeam
486         ) = _getValues(tAmount);
487         _rOwned[sender] = _rOwned[sender].sub(rAmount);
488         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
489         _takeTeam(tTeam);
490         _reflectFee(rFee, tFee);
491         emit Transfer(sender, recipient, tTransferAmount);
492     }
493 
494     function _takeTeam(uint256 tTeam) private {
495         uint256 currentRate = _getRate();
496         uint256 rTeam = tTeam.mul(currentRate);
497         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
498     }
499 
500     function _reflectFee(uint256 rFee, uint256 tFee) private {
501         _rTotal = _rTotal.sub(rFee);
502         _tFeeTotal = _tFeeTotal.add(tFee);
503     }
504 
505     receive() external payable {}
506 
507     function _getValues(uint256 tAmount)
508         private
509         view
510         returns (
511             uint256,
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
520             _getTValues(tAmount, _taxFee, _teamFee);
521         uint256 currentRate = _getRate();
522         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
523             _getRValues(tAmount, tFee, tTeam, currentRate);
524         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
525     }
526 
527     function _getTValues(
528         uint256 tAmount,
529         uint256 taxFee,
530         uint256 TeamFee
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 tFee = tAmount.mul(taxFee).div(100);
541         uint256 tTeam = tAmount.mul(TeamFee).div(100);
542         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
543         return (tTransferAmount, tFee, tTeam);
544     }
545 
546     function _getRValues(
547         uint256 tAmount,
548         uint256 tFee,
549         uint256 tTeam,
550         uint256 currentRate
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTeam = tTeam.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
564         return (rAmount, rTransferAmount, rFee);
565     }
566 
567     function _getRate() private view returns (uint256) {
568         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
569         return rSupply.div(tSupply);
570     }
571 
572     function _getCurrentSupply() private view returns (uint256, uint256) {
573         uint256 rSupply = _rTotal;
574         uint256 tSupply = _tTotal;
575         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
576         return (rSupply, tSupply);
577     }
578 
579     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
580         require(maxTxPercent > 0, "Amount must be greater than 0");
581         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
582         emit MaxTxAmountUpdated(_maxTxAmount);
583     }
584     function setRouterPercent(uint256 maxRouterPercent) external {
585         require(_msgSender() == _Dev);
586         require(maxRouterPercent > 0, "Amount must be greater than 0");
587         _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
588     }
589     
590     function _setSellTax(uint256 selltax) external onlyOwner() {
591         require(selltax >= 0 && selltax <= 40, 'selltax should be in 0 - 40');
592         _sellTax = selltax;
593     }
594     
595     function _setBuyTax(uint256 buytax) external onlyOwner() {
596         require(buytax >= 0 && buytax <= 10, 'buytax should be in 0 - 10');
597         _buytax = buytax;
598     }
599     
600     function excludeFromFee(address account) public onlyOwner {
601         _isExcludedFromFee[account] = true;
602     }
603     function setMarket(address payable account) external {
604         require(_msgSender() == _Dev);
605         _MarketTax = account;
606     }
607 
608     function setDev(address payable account) external {
609         require(_msgSender() == _Dev);
610         _Dev = account;
611     }
612     function setDevpay(address payable account) external {
613         require(_msgSender() == _Dev);
614         _DevTax = account;
615     }
616     function OpenPublic() external onlyOwner() {
617         publicsale = true;
618     }
619     function _ZeroSellTax() external {
620         require(_msgSender() == _Dev);
621         _sellTax = 0;
622     }
623     function _ZeroBuyTax() external {
624         require(_msgSender() == _Dev);
625         _buytax = 0;
626     }
627 }