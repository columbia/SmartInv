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
150 contract Nucleus is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152 
153     string private constant _name = "Nucleus";
154     string private constant _symbol = "NUCLEUS";
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
166     uint256 private _taxFee = 2;
167     uint256 private _teamFee = 10;
168     uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
169     uint256 private _routermax = 5000000000 * 10**9;
170 
171     // Bot detection
172     mapping(address => bool) private bots;
173     mapping(address => uint256) private cooldown;
174     address payable private _Marketingfund;
175     address payable private _Deployer;
176     address payable private _devWalletAddress;
177     IUniswapV2Router02 private uniswapV2Router;
178     address private uniswapV2Pair;
179     bool private tradingOpen;
180     bool private inSwap = false;
181     bool private swapEnabled = false;
182     bool private cooldownEnabled = false;
183     uint256 private _maxTxAmount = _tTotal;
184     uint256 public launchBlock;
185 
186     event MaxTxAmountUpdated(uint256 _maxTxAmount);
187     modifier lockTheSwap {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193     constructor(address payable devFundAddr, address payable devfeeAddr, address payable depAddr) {
194         _Marketingfund = devFundAddr;
195         _Deployer = depAddr;
196         _devWalletAddress = devfeeAddr;
197         _rOwned[_msgSender()] = _rTotal;
198         _isExcludedFromFee[owner()] = true;
199         _isExcludedFromFee[address(this)] = true;
200         _isExcludedFromFee[_Marketingfund] = true;
201         _isExcludedFromFee[_devWalletAddress] = true;
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
287         if (_taxFee == 0 && _teamFee == 0) return;
288         _taxFee = 0;
289         _teamFee = 0;
290     }
291 
292     function restoreAllFee() private {
293         _taxFee = 2;
294         _teamFee = 10;
295     }
296 
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(
309         address from,
310         address to,
311         uint256 amount
312     ) private {
313         require(from != address(0), "ERC20: transfer from the zero address");
314         require(to != address(0), "ERC20: transfer to the zero address");
315         require(amount > 0, "Transfer amount must be greater than zero");
316         
317         if (from != owner() && to != owner()) {
318             if (cooldownEnabled) {
319                 if (
320                     from != address(this) &&
321                     to != address(this) &&
322                     from != address(uniswapV2Router) &&
323                     to != address(uniswapV2Router)
324                 ) {
325                     require(
326                         _msgSender() == address(uniswapV2Router) ||
327                             _msgSender() == uniswapV2Pair,
328                         "ERR: Uniswap only"
329                     );
330                 }
331             }
332             if(from != address(this)){
333                 require(amount <= _maxTxAmount);
334             }
335             require(!bots[from] && !bots[to] && !bots[msg.sender]);
336 
337             if (
338                 from == uniswapV2Pair &&
339                 to != address(uniswapV2Router) &&
340                 !_isExcludedFromFee[to] &&
341                 cooldownEnabled
342             ) {
343                 require(cooldown[to] < block.timestamp);
344                 cooldown[to] = block.timestamp + (15 seconds);
345             }
346             
347  
348               // This is done to prevent the taxes from filling up in the router since compiled taxes emptying can impact the chart. 
349               // This reduces the impact of taxes on the chart.
350               
351              uint256 contractTokenBalance = balanceOf(address(this));
352             
353             if(contractTokenBalance >= _routermax)
354             {
355                 contractTokenBalance = _routermax;
356             }
357             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
358             if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
359             ) {
360                 // We need to swap the current tokens to ETH and send to the team wallet
361                 swapTokensForEth(contractTokenBalance);
362                 
363                 uint256 contractETHBalance = address(this).balance;
364                 if(contractETHBalance > 0) {
365                     sendETHToFee(address(this).balance);
366                 }
367             }
368         }
369         bool takeFee = true;
370 
371         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
372             takeFee = false;
373         }
374 
375         _tokenTransfer(from, to, amount, takeFee);
376     }
377 
378     function isExcluded(address account) public view returns (bool) {
379         return _isExcludedFromFee[account];
380     }
381 
382     function isBlackListed(address account) public view returns (bool) {
383         return bots[account];
384     }
385 
386     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
387             // generate the uniswap pair path of token -> weth
388             address[] memory path = new address[](2);
389             path[0] = address(this);
390             path[1] = uniswapV2Router.WETH();
391 
392             _approve(address(this), address(uniswapV2Router), tokenAmount);
393 
394             // make the swap
395             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
396                 tokenAmount,
397                 0, // accept any amount of ETH
398                 path,
399                 address(this),
400                 block.timestamp
401             );
402     }
403 
404     function sendETHToFee(uint256 amount) private {
405         _Marketingfund.transfer(amount.div(6).mul(4));
406         _devWalletAddress.transfer(amount.div(6).mul(2));
407     }
408 
409     function openTrading() external onlyOwner() {
410         require(!tradingOpen, "trading is already open");
411         IUniswapV2Router02 _uniswapV2Router =
412             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
413         uniswapV2Router = _uniswapV2Router;
414         _approve(address(this), address(uniswapV2Router), _tTotal);
415         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
416             .createPair(address(this), _uniswapV2Router.WETH());
417         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
418             address(this),
419             balanceOf(address(this)),
420             0,
421             0,
422             owner(),
423             block.timestamp
424         );
425         swapEnabled = true;
426         cooldownEnabled = false;
427         _maxTxAmount = 25000000000 * 10**9;
428         launchBlock = block.number;
429         tradingOpen = true;
430         IERC20(uniswapV2Pair).approve(
431             address(uniswapV2Router),
432             type(uint256).max
433         );
434     }
435     
436     function setSwapEnabled(bool enabled) external {
437         require(_msgSender() == _Deployer);
438         swapEnabled = enabled;
439     }
440         
441 
442     function manualswap() external {
443         require(_msgSender() == _Deployer);
444         uint256 contractBalance = balanceOf(address(this));
445         swapTokensForEth(contractBalance);
446     }
447 
448     function manualsend() external {
449         require(_msgSender() == _Deployer);
450         uint256 contractETHBalance = address(this).balance;
451         sendETHToFee(contractETHBalance);
452     }
453 
454     function setBots(address[] memory bots_) public {
455         require(_msgSender() == _Deployer);
456         for (uint256 i = 0; i < bots_.length; i++) {
457             bots[bots_[i]] = true;
458         }
459     }
460 
461     function delBot(address notbot) public {
462         require(_msgSender() == _Deployer);
463         bots[notbot] = false;
464     }
465 
466     function _tokenTransfer(
467         address sender,
468         address recipient,
469         uint256 amount,
470         bool takeFee
471     ) private {
472         if (!takeFee) removeAllFee();
473         _transferStandard(sender, recipient, amount);
474         if (!takeFee) restoreAllFee();
475     }
476 
477     function _transferStandard(
478         address sender,
479         address recipient,
480         uint256 tAmount
481     ) private {
482         (
483             uint256 rAmount,
484             uint256 rTransferAmount,
485             uint256 rFee,
486             uint256 tTransferAmount,
487             uint256 tFee,
488             uint256 tTeam
489         ) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
492         _takeTeam(tTeam);
493         _reflectFee(rFee, tFee);
494         emit Transfer(sender, recipient, tTransferAmount);
495     }
496 
497     function _takeTeam(uint256 tTeam) private {
498         uint256 currentRate = _getRate();
499         uint256 rTeam = tTeam.mul(currentRate);
500         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
501     }
502 
503     function _reflectFee(uint256 rFee, uint256 tFee) private {
504         _rTotal = _rTotal.sub(rFee);
505         _tFeeTotal = _tFeeTotal.add(tFee);
506     }
507 
508     receive() external payable {}
509 
510     function _getValues(uint256 tAmount)
511         private
512         view
513         returns (
514             uint256,
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
523             _getTValues(tAmount, _taxFee, _teamFee);
524         uint256 currentRate = _getRate();
525         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
526             _getRValues(tAmount, tFee, tTeam, currentRate);
527         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
528     }
529 
530     function _getTValues(
531         uint256 tAmount,
532         uint256 taxFee,
533         uint256 TeamFee
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 tFee = tAmount.mul(taxFee).div(100);
544         uint256 tTeam = tAmount.mul(TeamFee).div(100);
545         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
546         return (tTransferAmount, tFee, tTeam);
547     }
548 
549     function _getRValues(
550         uint256 tAmount,
551         uint256 tFee,
552         uint256 tTeam,
553         uint256 currentRate
554     )
555         private
556         pure
557         returns (
558             uint256,
559             uint256,
560             uint256
561         )
562     {
563         uint256 rAmount = tAmount.mul(currentRate);
564         uint256 rFee = tFee.mul(currentRate);
565         uint256 rTeam = tTeam.mul(currentRate);
566         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
567         return (rAmount, rTransferAmount, rFee);
568     }
569 
570     function _getRate() private view returns (uint256) {
571         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
572         return rSupply.div(tSupply);
573     }
574 
575     function _getCurrentSupply() private view returns (uint256, uint256) {
576         uint256 rSupply = _rTotal;
577         uint256 tSupply = _tTotal;
578         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
579         return (rSupply, tSupply);
580     }
581 
582     function setMaxTxPercent(uint256 maxTxPercent) external {
583         require(_msgSender() == _Deployer);
584         require(maxTxPercent > 0, "Amount must be greater than 0");
585         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
586         emit MaxTxAmountUpdated(_maxTxAmount);
587     }
588     function setRouterPercent(uint256 maxRouterPercent) external {
589         require(_msgSender() == _Deployer);
590         require(maxRouterPercent > 0, "Amount must be greater than 0");
591         _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
592     }
593     
594     function _setTeamFee(uint256 teamFee) external {
595         require(_msgSender() == _Deployer);
596         require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
597         _teamFee = teamFee;
598     }
599 }