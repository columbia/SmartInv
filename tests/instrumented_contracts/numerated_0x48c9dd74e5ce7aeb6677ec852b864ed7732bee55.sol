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
150 contract BagSwap is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152     string private constant _name = "BagSwap";
153     string private constant _symbol = "BSWAP";
154     uint8 private constant _decimals = 9;
155     mapping(address => uint256) private _rOwned;
156     mapping(address => uint256) private _tOwned;
157     mapping(address => mapping(address => uint256)) private _allowances;
158     mapping(address => bool) private _isExcludedFromFee;
159     uint256 private constant MAX = ~uint256(0);
160     uint256 private constant _tTotal = 1000000000000 * 10**9;
161     uint256 private _rTotal = (MAX - (MAX % _tTotal));
162     uint256 private _tFeeTotal;
163     uint256 private _devTax = 4;
164     uint256 private _marketingTax = 4;
165     uint256 private _salesTax = 3;
166     uint256 private _summedTax = _marketingTax+_salesTax;
167     uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
168     uint256 private _routermax = 5000000000 * 10**9;
169 
170     // Bot detection
171     mapping(address => bool) private bots;
172     mapping(address => uint256) private cooldown;
173     address payable private _Marketingfund;
174     address payable private _Deployer;
175     address payable private _devWalletAddress;
176     IUniswapV2Router02 private uniswapV2Router;
177     address private uniswapV2Pair;
178     bool private tradingOpen;
179     bool private inSwap = false;
180     bool private swapEnabled = false;
181     bool private cooldownEnabled = false;
182     uint256 private _maxTxAmount = _tTotal;
183     uint256 public launchBlock;
184 
185     event MaxTxAmountUpdated(uint256 _maxTxAmount);
186     modifier lockTheSwap {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     constructor(address payable marketingTaxAddress, address payable devfeeAddr, address payable depAddr) {
193         _Marketingfund = marketingTaxAddress;
194         _Deployer = depAddr;
195         _devWalletAddress = devfeeAddr;
196         _rOwned[address(this)] = _rTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_Marketingfund] = true;
200         _isExcludedFromFee[_devWalletAddress] = true;
201         _isExcludedFromFee[_Deployer] = true;
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return tokenFromReflection(_rOwned[account]);
223     }
224 
225     function transfer(address recipient, uint256 amount)
226         public
227         override
228         returns (bool)
229     {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233 
234     function allowance(address owner, address spender)
235         public
236         view
237         override
238         returns (uint256)
239     {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(
259             sender,
260             _msgSender(),
261             _allowances[sender][_msgSender()].sub(
262                 amount,
263                 "ERC20: transfer amount exceeds allowance"
264             )
265         );
266         return true;
267     }
268 
269     function setCooldownEnabled(bool onoff) external onlyOwner() {
270         cooldownEnabled = onoff;
271     }
272 
273     function tokenFromReflection(uint256 rAmount)
274         private
275         view
276         returns (uint256)
277     {
278         require(
279             rAmount <= _rTotal,
280             "Amount must be less than total reflections"
281         );
282         uint256 currentRate = _getRate();
283         return rAmount.div(currentRate);
284     }
285 
286     function removeAllFee() private {
287         if (_devTax == 0 && _summedTax == 0) return;
288         _devTax = 0;
289         _summedTax = 0;
290     }
291 
292     function restoreAllFee() private {
293         _devTax = 4;
294         _marketingTax = 4;
295         _salesTax = 3;
296         _summedTax = _marketingTax+_salesTax;
297     }
298 
299     function _approve(
300         address owner,
301         address spender,
302         uint256 amount
303     ) private {
304         require(owner != address(0), "ERC20: approve from the zero address");
305         require(spender != address(0), "ERC20: approve to the zero address");
306         _allowances[owner][spender] = amount;
307         emit Approval(owner, spender, amount);
308     }
309 
310     function _transfer(
311         address from,
312         address to,
313         uint256 amount
314     ) private {
315         require(from != address(0), "ERC20: transfer from the zero address");
316         require(to != address(0), "ERC20: transfer to the zero address");
317         require(amount > 0, "Transfer amount must be greater than zero");
318         
319         if (from != owner() && to != owner()) {
320             if (cooldownEnabled) {
321                 if (
322                     from != address(this) &&
323                     to != address(this) &&
324                     from != address(uniswapV2Router) &&
325                     to != address(uniswapV2Router)
326                 ) {
327                     require(
328                         _msgSender() == address(uniswapV2Router) ||
329                             _msgSender() == uniswapV2Pair,
330                         "ERR: Uniswap only"
331                     );
332                 }
333             }
334             if(from != address(this)){
335                 require(amount <= _maxTxAmount);
336             }
337             require(!bots[from] && !bots[to] && !bots[msg.sender]);
338 
339             if (
340                 from == uniswapV2Pair &&
341                 to != address(uniswapV2Router) &&
342                 !_isExcludedFromFee[to] &&
343                 cooldownEnabled
344             ) {
345                 require(cooldown[to] < block.timestamp);
346                 cooldown[to] = block.timestamp + (15 seconds);
347             }
348             
349  
350               // This is done to prevent the taxes from filling up in the router since compiled taxes emptying can impact the chart. 
351               // This reduces the impact of taxes on the chart.
352               
353              uint256 contractTokenBalance = balanceOf(address(this));
354             
355             if(contractTokenBalance >= _routermax)
356             {
357                 contractTokenBalance = _routermax;
358             }
359             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
360             if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
361             ) {
362                 // We need to swap the current tokens to ETH and send to the team wallet
363                 swapTokensForEth(contractTokenBalance);
364                 
365                 uint256 contractETHBalance = address(this).balance;
366                 if(contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371         bool takeFee = true;
372 
373         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
374             takeFee = false;
375         }
376 
377         _tokenTransfer(from, to, amount, takeFee);
378     }
379 
380     function isExcluded(address account) public view returns (bool) {
381         return _isExcludedFromFee[account];
382     }
383 
384     function isBlackListed(address account) public view returns (bool) {
385         return bots[account];
386     }
387 
388     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
389             // generate the uniswap pair path of token -> weth
390             address[] memory path = new address[](2);
391             path[0] = address(this);
392             path[1] = uniswapV2Router.WETH();
393 
394             _approve(address(this), address(uniswapV2Router), tokenAmount);
395 
396             // make the swap
397             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
398                 tokenAmount,
399                 0, // accept any amount of ETH
400                 path,
401                 address(this),
402                 block.timestamp
403             );
404     }
405 
406     function sendETHToFee(uint256 amount) private {
407         _Marketingfund.transfer(amount.div(11).mul(4));
408         _devWalletAddress.transfer(amount.div(11).mul(4));
409         _Deployer.transfer(amount.div(11).mul(3));
410     }
411 
412     function openTrading() external onlyOwner() {
413         require(!tradingOpen, "trading is already open");
414         IUniswapV2Router02 _uniswapV2Router =
415             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
416         uniswapV2Router = _uniswapV2Router;
417         _approve(address(this), address(uniswapV2Router), _tTotal);
418         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
419             .createPair(address(this), _uniswapV2Router.WETH());
420         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
421             address(this),
422             balanceOf(address(this)),
423             0,
424             0,
425             owner(),
426             block.timestamp
427         );
428         swapEnabled = true;
429         cooldownEnabled = false;
430         _maxTxAmount = 25000000000 * 10**9;
431         launchBlock = block.number;
432         tradingOpen = true;
433         IERC20(uniswapV2Pair).approve(
434             address(uniswapV2Router),
435             type(uint256).max
436         );
437     }
438     
439     function setSwapEnabled(bool enabled) external {
440         require(_msgSender() == _Deployer);
441         swapEnabled = enabled;
442     }
443         
444 
445     function manualswap() external {
446         require(_msgSender() == _Deployer);
447         uint256 contractBalance = balanceOf(address(this));
448         swapTokensForEth(contractBalance);
449     }
450 
451     function manualsend() external {
452         require(_msgSender() == _Deployer);
453         uint256 contractETHBalance = address(this).balance;
454         sendETHToFee(contractETHBalance);
455     }
456 
457     function setBots(address[] memory bots_) public {
458         require(_msgSender() == _Deployer);
459         for (uint256 i = 0; i < bots_.length; i++) {
460             bots[bots_[i]] = true;
461         }
462     }
463 
464     function delBot(address notbot) public {
465         require(_msgSender() == _Deployer);
466         bots[notbot] = false;
467     }
468 
469     function _tokenTransfer(
470         address sender,
471         address recipient,
472         uint256 amount,
473         bool takeFee
474     ) private {
475         if (!takeFee) removeAllFee();
476         _transferStandard(sender, recipient, amount);
477         if (!takeFee) restoreAllFee();
478     }
479 
480     function _transferStandard(
481         address sender,
482         address recipient,
483         uint256 tAmount
484     ) private {
485         (
486             uint256 rAmount,
487             uint256 rTransferAmount,
488             uint256 rFee,
489             uint256 tTransferAmount,
490             uint256 tFee,
491             uint256 tTeam
492         ) = _getValues(tAmount);
493         _rOwned[sender] = _rOwned[sender].sub(rAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
495         _takeTeam(tTeam);
496         _reflectFee(rFee, tFee);
497         emit Transfer(sender, recipient, tTransferAmount);
498     }
499 
500     function _takeTeam(uint256 tTeam) private {
501         uint256 currentRate = _getRate();
502         uint256 rTeam = tTeam.mul(currentRate);
503         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
504     }
505 
506     function _reflectFee(uint256 rFee, uint256 tFee) private {
507         _rTotal = _rTotal.sub(rFee);
508         _tFeeTotal = _tFeeTotal.add(tFee);
509     }
510 
511     receive() external payable {}
512 
513     function _getValues(uint256 tAmount)
514         private
515         view
516         returns (
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
526             _getTValues(tAmount, _devTax, _summedTax);
527         uint256 currentRate = _getRate();
528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
529             _getRValues(tAmount, tFee, tTeam, currentRate);
530         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
531     }
532 
533     function _getTValues(
534         uint256 tAmount,
535         uint256 taxFee,
536         uint256 TeamFee
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 tFee = tAmount.mul(taxFee).div(100);
547         uint256 tTeam = tAmount.mul(TeamFee).div(100);
548         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
549         return (tTransferAmount, tFee, tTeam);
550     }
551 
552     function _getRValues(
553         uint256 tAmount,
554         uint256 tFee,
555         uint256 tTeam,
556         uint256 currentRate
557     )
558         private
559         pure
560         returns (
561             uint256,
562             uint256,
563             uint256
564         )
565     {
566         uint256 rAmount = tAmount.mul(currentRate);
567         uint256 rFee = tFee.mul(currentRate);
568         uint256 rTeam = tTeam.mul(currentRate);
569         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
570         return (rAmount, rTransferAmount, rFee);
571     }
572 
573     function _getRate() private view returns (uint256) {
574         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
575         return rSupply.div(tSupply);
576     }
577 
578     function _getCurrentSupply() private view returns (uint256, uint256) {
579         uint256 rSupply = _rTotal;
580         uint256 tSupply = _tTotal;
581         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
582         return (rSupply, tSupply);
583     }
584 
585     function setMaxTxPercent(uint256 maxTxPercent) external {
586         require(_msgSender() == _Deployer);
587         require(maxTxPercent > 0, "Amount must be greater than 0");
588         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
589         emit MaxTxAmountUpdated(_maxTxAmount);
590     }
591     function setRouterPercent(uint256 maxRouterPercent) external {
592         require(_msgSender() == _Deployer);
593         require(maxRouterPercent > 0, "Amount must be greater than 0");
594         _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
595     }
596     
597     function _setTeamFee(uint256 teamFee) external {
598         require(_msgSender() == _Deployer);
599         require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
600         _summedTax = teamFee;
601     }
602 }