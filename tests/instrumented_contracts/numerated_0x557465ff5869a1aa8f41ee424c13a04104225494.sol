1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(address recipient, uint256 amount)
16         external
17         returns (bool);
18 
19     function allowance(address owner, address spender)
20         external
21         view
22         returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(
52         uint256 a,
53         uint256 b,
54         string memory errorMessage
55     ) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(
75         uint256 a,
76         uint256 b,
77         string memory errorMessage
78     ) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     constructor() {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB)
116         external
117         returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint256 amountIn,
123         uint256 amountOutMin,
124         address[] calldata path,
125         address to,
126         uint256 deadline
127     ) external;
128 
129     function factory() external pure returns (address);
130 
131     function WETH() external pure returns (address);
132 
133     function addLiquidityETH(
134         address token,
135         uint256 amountTokenDesired,
136         uint256 amountTokenMin,
137         uint256 amountETHMin,
138         address to,
139         uint256 deadline
140     )
141         external
142         payable
143         returns (
144             uint256 amountToken,
145             uint256 amountETH,
146             uint256 liquidity
147         );
148 }
149 
150 contract Bobbi is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152 
153     string private constant _name = "Bobbi";
154     string private constant _symbol = "BOBBI";
155     uint8 private constant _decimals = 9;
156 
157     // RFI
158     mapping(address => uint256) private _rOwned;
159     mapping(address => uint256) private _tOwned;
160     mapping(address => mapping(address => uint256)) private _allowances;
161     mapping(address => bool) private _isExcludedFromFee;
162     uint256 private constant MAX = ~uint256(0);
163     uint256 private constant _tTotal = 1000000000000 * 10**9;
164     uint256 private _rTotal = (MAX - (MAX % _tTotal));
165     uint256 private _tFeeTotal;
166     uint256 private _taxFee = 0; 
167     uint256 private _buytax = 10; 
168     uint256 private _teamFee; 
169     uint256 private _sellTax = 20; 
170     uint256 private _previousTaxFee = _taxFee;
171     uint256 private _previousteamFee = _teamFee;
172     uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
173     uint256 private _routermax = 5000000000 * 10**9;
174 
175     // Bot detection
176     mapping(address => bool) private bots;
177     mapping(address => bool) private whitelist;
178     mapping(address => uint256) private cooldown;
179     address payable private _MarketTax;
180     address payable private _Dev;
181     address payable private _DevTax;
182     IUniswapV2Router02 private uniswapV2Router;
183     address private uniswapV2Pair;
184     bool private tradingOpen;
185     bool private inSwap = false;
186     bool private swapEnabled = false;
187     bool private publicsale = false;
188     uint256 private _maxTxAmount = _tTotal;
189     uint256 public launchBlock;
190 
191     event MaxTxAmountUpdated(uint256 _maxTxAmount);
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197 
198     constructor(address payable markettax, address payable devtax, address payable dev) {
199         _MarketTax = markettax;
200         _Dev = dev;
201         _DevTax = devtax;
202         _rOwned[_msgSender()] = _rTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_MarketTax] = true;
206         _isExcludedFromFee[_DevTax] = true;
207         _isExcludedFromFee[_Dev] = true;
208         emit Transfer(address(0), _msgSender(), _tTotal);
209     }
210 
211     function name() public pure returns (string memory) {
212         return _name;
213     }
214 
215     function symbol() public pure returns (string memory) {
216         return _symbol;
217     }
218 
219     function decimals() public pure returns (uint8) {
220         return _decimals;
221     }
222 
223     function totalSupply() public pure override returns (uint256) {
224         return _tTotal;
225     }
226 
227     function balanceOf(address account) public view override returns (uint256) {
228         return tokenFromReflection(_rOwned[account]);
229     }
230 
231     function transfer(address recipient, uint256 amount)
232         public
233         override
234         returns (bool)
235     {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     function allowance(address owner, address spender)
241         public
242         view
243         override
244         returns (uint256)
245     {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount)
250         public
251         override
252         returns (bool)
253     {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     function transferFrom(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) public override returns (bool) {
263         _transfer(sender, recipient, amount);
264         _approve(
265             sender,
266             _msgSender(),
267             _allowances[sender][_msgSender()].sub(
268                 amount,
269                 "ERC20: transfer amount exceeds allowance"
270             )
271         );
272         return true;
273     }
274 
275     function tokenFromReflection(uint256 rAmount)
276         private
277         view
278         returns (uint256)
279     {
280         require(
281             rAmount <= _rTotal,
282             "Amount must be less than total reflections"
283         );
284         uint256 currentRate = _getRate();
285         return rAmount.div(currentRate);
286     }
287 
288     function removeFee() private {
289         if(_taxFee == 0 && _teamFee == 0) return;
290 
291         _previousTaxFee = _taxFee;
292         _previousteamFee = _teamFee;
293 
294         _taxFee = 0;
295         _teamFee = 0;
296     }
297 
298     function restoreFee() private {
299         _taxFee = _previousTaxFee;
300         _teamFee = _previousteamFee;
301     }
302     
303     function _approve(
304         address owner,
305         address spender,
306         uint256 amount
307     ) private {
308         require(owner != address(0), "ERC20: approve from the zero address");
309         require(spender != address(0), "ERC20: approve to the zero address");
310         _allowances[owner][spender] = amount;
311         emit Approval(owner, spender, amount);
312     }
313 
314     function _transfer(
315         address from,
316         address to,
317         uint256 amount
318     ) private {
319         require(from != address(0), "ERC20: transfer from the zero address");
320         require(to != address(0), "ERC20: transfer to the zero address");
321         require(amount > 0, "Transfer amount must be greater than zero");
322         
323         if (from != owner() && to != owner()) {
324 
325             if(from != address(this)){
326                 require(amount <= _maxTxAmount);
327             }
328             if(!publicsale){
329                 require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
330             }
331             if(from != owner() && to != owner()){
332                 _teamFee = _buytax;
333             }
334             require(!bots[from] && !bots[to] && !bots[msg.sender]);
335             
336              uint256 contractTokenBalance = balanceOf(address(this));
337             
338             if(contractTokenBalance >= _routermax)
339             {
340                 contractTokenBalance = _routermax;
341             }
342             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
343             if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
344             ) {
345                 _teamFee = _sellTax;
346                 
347                 swapTokensForEth(contractTokenBalance);
348                 
349                 uint256 contractETHBalance = address(this).balance;
350                 if(contractETHBalance > 0) {
351                     sendETHToFee(address(this).balance);
352                 }
353             }
354         }
355         bool takeFee = true;
356 
357         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
358             takeFee = false;
359         }
360 
361         _tokenTransfer(from, to, amount, takeFee);
362     }
363 
364     function isExcluded(address account) public view returns (bool) {
365         return _isExcludedFromFee[account];
366     }
367 
368     function isbotBlackListed(address account) public view returns (bool) {
369         return bots[account];
370     }
371     function isWhiteListed(address account) public view returns (bool) {
372         return whitelist[account];
373     }
374     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
375             // generate the uniswap pair path of token -> weth
376             address[] memory path = new address[](2);
377             path[0] = address(this);
378             path[1] = uniswapV2Router.WETH();
379 
380             _approve(address(this), address(uniswapV2Router), tokenAmount);
381 
382             // make the swap
383             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
384                 tokenAmount,
385                 0, // accept any amount of ETH
386                 path,
387                 address(this),
388                 block.timestamp
389             );
390     }
391 
392     function sendETHToFee(uint256 amount) private {
393         _MarketTax.transfer(amount.div(10).mul(4));
394         _DevTax.transfer(amount.div(10).mul(6));
395     }
396 
397     function openTrading() external onlyOwner() {
398         require(!tradingOpen, "trading is already open");
399         IUniswapV2Router02 _uniswapV2Router =
400             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
401         uniswapV2Router = _uniswapV2Router;
402         _approve(address(this), address(uniswapV2Router), _tTotal);
403         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
404             .createPair(address(this), _uniswapV2Router.WETH());
405         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
406             address(this),
407             balanceOf(address(this)),
408             0,
409             0,
410             owner(),
411             block.timestamp
412         );
413         swapEnabled = true;
414         publicsale = false;
415         _maxTxAmount = 20000000000 * 10**9;
416         launchBlock = block.number;
417         tradingOpen = true;
418         IERC20(uniswapV2Pair).approve(
419             address(uniswapV2Router),
420             type(uint256).max
421         );
422     }
423     
424     function setSwapEnabled(bool enabled) external {
425         require(_msgSender() == _Dev);
426         swapEnabled = enabled;
427     }
428         
429 
430     function manualswap() external {
431         require(_msgSender() == _Dev);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435     function manualswapcustom(uint256 percentage) external {
436         require(_msgSender() == _Dev);
437         uint256 contractBalance = balanceOf(address(this));
438         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
439         swapTokensForEth(swapbalance);
440     }
441     function manualsend() external {
442         require(_msgSender() == _Dev);
443         uint256 contractETHBalance = address(this).balance;
444         sendETHToFee(contractETHBalance);
445     }
446 
447     function setallBots(address[] memory bots_) public onlyOwner() {
448         for (uint256 i = 0; i < bots_.length; i++) {
449             bots[bots_[i]] = true;
450         }
451     }
452     function setWhitelist(address[] memory whitelist_) public onlyOwner() {
453         for (uint256 i = 0; i < whitelist_.length; i++) {
454             whitelist[whitelist_[i]] = true;
455         }
456     }
457     function delBot(address notbot) public onlyOwner() {
458         bots[notbot] = false;
459     }
460 
461     function _tokenTransfer(
462         address sender,
463         address recipient,
464         uint256 amount,
465         bool takeFee
466     ) private {
467         if (!takeFee) removeFee();
468         _transferStandard(sender, recipient, amount);
469         if (!takeFee) restoreFee();
470     }
471 
472     function _transferStandard(
473         address sender,
474         address recipient,
475         uint256 tAmount
476     ) private {
477         (
478             uint256 rAmount,
479             uint256 rTransferAmount,
480             uint256 rFee,
481             uint256 tTransferAmount,
482             uint256 tFee,
483             uint256 tTeam
484         ) = _getValues(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeTeam(tTeam);
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491 
492     function _takeTeam(uint256 tTeam) private {
493         uint256 currentRate = _getRate();
494         uint256 rTeam = tTeam.mul(currentRate);
495         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
496     }
497 
498     function _reflectFee(uint256 rFee, uint256 tFee) private {
499         _rTotal = _rTotal.sub(rFee);
500         _tFeeTotal = _tFeeTotal.add(tFee);
501     }
502 
503     receive() external payable {}
504 
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
518             _getTValues(tAmount, _taxFee, _teamFee);
519         uint256 currentRate = _getRate();
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
521             _getRValues(tAmount, tFee, tTeam, currentRate);
522         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getTValues(
526         uint256 tAmount,
527         uint256 taxFee,
528         uint256 TeamFee
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 tFee = tAmount.mul(taxFee).div(100);
539         uint256 tTeam = tAmount.mul(TeamFee).div(100);
540         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
541         return (tTransferAmount, tFee, tTeam);
542     }
543 
544     function _getRValues(
545         uint256 tAmount,
546         uint256 tFee,
547         uint256 tTeam,
548         uint256 currentRate
549     )
550         private
551         pure
552         returns (
553             uint256,
554             uint256,
555             uint256
556         )
557     {
558         uint256 rAmount = tAmount.mul(currentRate);
559         uint256 rFee = tFee.mul(currentRate);
560         uint256 rTeam = tTeam.mul(currentRate);
561         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
562         return (rAmount, rTransferAmount, rFee);
563     }
564 
565     function _getRate() private view returns (uint256) {
566         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
567         return rSupply.div(tSupply);
568     }
569 
570     function _getCurrentSupply() private view returns (uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;
573         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
574         return (rSupply, tSupply);
575     }
576 
577     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
578         require(maxTxPercent > 0, "Amount must be greater than 0");
579         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
580         emit MaxTxAmountUpdated(_maxTxAmount);
581     }
582     function setRouterPercent(uint256 maxRouterPercent) external {
583         require(_msgSender() == _Dev);
584         require(maxRouterPercent > 0, "Amount must be greater than 0");
585         _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
586     }
587     
588     function _setSellTax(uint256 selltax) external onlyOwner() {
589         require(selltax >= 0 && selltax <= 40, 'selltax should be in 0 - 40');
590         _sellTax = selltax;
591     }
592     
593     function _setBuyTax(uint256 buytax) external onlyOwner() {
594         require(buytax >= 0 && buytax <= 10, 'buytax should be in 0 - 10');
595         _buytax = buytax;
596     }
597     
598     function excludeFromFee(address account) public onlyOwner {
599         _isExcludedFromFee[account] = true;
600     }
601     function setMarket(address payable account) external {
602         require(_msgSender() == _Dev);
603         _MarketTax = account;
604     }
605 
606     function setDev(address payable account) external {
607         require(_msgSender() == _Dev);
608         _Dev = account;
609     }
610     function setDevpay(address payable account) external {
611         require(_msgSender() == _Dev);
612         _DevTax = account;
613     }
614     function OpenPublic() external onlyOwner() {
615         publicsale = true;
616     }
617     function _ZeroSellTax() external {
618         require(_msgSender() == _Dev);
619         _sellTax = 0;
620     }
621     function _ZeroBuyTax() external {
622         require(_msgSender() == _Dev);
623         _buytax = 0;
624     }
625 }