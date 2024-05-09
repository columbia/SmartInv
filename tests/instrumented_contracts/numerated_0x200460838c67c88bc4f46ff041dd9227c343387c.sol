1 /*
2      __       __                                          __ 
3     |  \     /  \                                        |  \
4     | $$\   /  $$  ______    ______  __     __   ______  | $$
5     | $$$\ /  $$$ |      \  /      \|  \   /  \ /      \ | $$
6     | $$$$\  $$$$  \$$$$$$\|  $$$$$$\\$$\ /  $$|  $$$$$$\| $$
7     | $$\$$ $$ $$ /      $$| $$   \$$ \$$\  $$ | $$    $$| $$
8     | $$ \$$$| $$|  $$$$$$$| $$        \$$ $$  | $$$$$$$$| $$
9     | $$  \$ | $$ \$$    $$| $$         \$$$    \$$     \| $$
10      \$$      \$$  \$$$$$$$ \$$          \$      \$$$$$$$ \$$
11 */
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     function allowance(address owner, address spender)
33         external
34         view
35         returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(
65         uint256 a,
66         uint256 b,
67         string memory errorMessage
68     ) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b > 0, errorMessage);
93         uint256 c = a / b;
94         return c;
95     }
96 }
97 
98 contract Ownable is Context {
99     address private _owner;
100     address private _previousOwner;
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106     constructor() {
107         address msgSender = _msgSender();
108         _owner = msgSender;
109         emit OwnershipTransferred(address(0), msgSender);
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB)
129         external
130         returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint256 amountIn,
136         uint256 amountOutMin,
137         address[] calldata path,
138         address to,
139         uint256 deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 }
162 
163 contract MarvelInu is Context, IERC20, Ownable {
164     using SafeMath for uint256;
165 
166     string private constant _name = "Marvel Inu";
167     string private constant _symbol = "Marvel";
168     uint8 private constant _decimals = 9;
169 
170     // RFI
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 1000000000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 private _taxFee = 2;
180     uint256 private _teamFee = 10;
181 
182     // Bot detection
183     mapping(address => bool) private bots;
184     mapping(address => uint256) private cooldown;
185     address payable private _devFund;
186     address payable private _marketingFunds;
187     address payable private _buybackWalletAddress;
188     IUniswapV2Router02 private uniswapV2Router;
189     address private uniswapV2Pair;
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = false;
193     bool private cooldownEnabled = false;
194     uint256 private _maxTxAmount = _tTotal;
195     uint256 public launchBlock;
196 
197     event MaxTxAmountUpdated(uint256 _maxTxAmount);
198     modifier lockTheSwap {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203 
204     constructor(address payable devFundAddr, address payable marketingFundAddr, address payable buybackAddr) {
205         _devFund = devFundAddr;
206         _marketingFunds = marketingFundAddr;
207         _buybackWalletAddress = buybackAddr;
208         _rOwned[_msgSender()] = _rTotal;
209         _isExcludedFromFee[owner()] = true;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[_devFund] = true;
212         _isExcludedFromFee[_marketingFunds] = true;
213         _isExcludedFromFee[_buybackWalletAddress] = true;
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public pure returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public pure returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public pure override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return tokenFromReflection(_rOwned[account]);
235     }
236 
237     function transfer(address recipient, uint256 amount)
238         public
239         override
240         returns (bool)
241     {
242         _transfer(_msgSender(), recipient, amount);
243         return true;
244     }
245 
246     function allowance(address owner, address spender)
247         public
248         view
249         override
250         returns (uint256)
251     {
252         return _allowances[owner][spender];
253     }
254 
255     function approve(address spender, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     function transferFrom(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) public override returns (bool) {
269         _transfer(sender, recipient, amount);
270         _approve(
271             sender,
272             _msgSender(),
273             _allowances[sender][_msgSender()].sub(
274                 amount,
275                 "ERC20: transfer amount exceeds allowance"
276             )
277         );
278         return true;
279     }
280 
281     function setCooldownEnabled(bool onoff) external onlyOwner() {
282         cooldownEnabled = onoff;
283     }
284 
285     function tokenFromReflection(uint256 rAmount)
286         private
287         view
288         returns (uint256)
289     {
290         require(
291             rAmount <= _rTotal,
292             "Amount must be less than total reflections"
293         );
294         uint256 currentRate = _getRate();
295         return rAmount.div(currentRate);
296     }
297 
298     function removeAllFee() private {
299         if (_taxFee == 0 && _teamFee == 0) return;
300         _taxFee = 0;
301         _teamFee = 0;
302     }
303 
304     function restoreAllFee() private {
305         _taxFee = 2;
306         _teamFee = 10;
307     }
308 
309     function _approve(
310         address owner,
311         address spender,
312         uint256 amount
313     ) private {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319 
320     function _transfer(
321         address from,
322         address to,
323         uint256 amount
324     ) private {
325         require(from != address(0), "ERC20: transfer from the zero address");
326         require(to != address(0), "ERC20: transfer to the zero address");
327         require(amount > 0, "Transfer amount must be greater than zero");
328 
329         if (from != owner() && to != owner()) {
330             if (cooldownEnabled) {
331                 if (
332                     from != address(this) &&
333                     to != address(this) &&
334                     from != address(uniswapV2Router) &&
335                     to != address(uniswapV2Router)
336                 ) {
337                     require(
338                         _msgSender() == address(uniswapV2Router) ||
339                             _msgSender() == uniswapV2Pair,
340                         "ERR: Uniswap only"
341                     );
342                 }
343             }
344             require(amount <= _maxTxAmount);
345             require(!bots[from] && !bots[to] && !bots[msg.sender]);
346 
347             if (
348                 from == uniswapV2Pair &&
349                 to != address(uniswapV2Router) &&
350                 !_isExcludedFromFee[to] &&
351                 cooldownEnabled
352             ) {
353                 require(cooldown[to] < block.timestamp);
354                 cooldown[to] = block.timestamp + (15 seconds);
355             }
356 
357             if (block.number <= launchBlock + 2 && amount == _maxTxAmount) {
358                 if (from != uniswapV2Pair && from != address(uniswapV2Router)) {
359                     bots[from] = true;
360                 } else if (to != uniswapV2Pair && to != address(uniswapV2Router)) {
361                     bots[to] = true;
362                 }
363             }
364 
365             uint256 contractTokenBalance = balanceOf(address(this));
366             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         }
374         bool takeFee = true;
375 
376         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
377             takeFee = false;
378         }
379 
380         _tokenTransfer(from, to, amount, takeFee);
381     }
382 
383     function isExcluded(address account) public view returns (bool) {
384         return _isExcludedFromFee[account];
385     }
386 
387     function isBlackListed(address account) public view returns (bool) {
388         return bots[account];
389     }
390 
391     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
392         address[] memory path = new address[](2);
393         path[0] = address(this);
394         path[1] = uniswapV2Router.WETH();
395         _approve(address(this), address(uniswapV2Router), tokenAmount);
396         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
397             tokenAmount,
398             0,
399             path,
400             address(this),
401             block.timestamp
402         );
403     }
404 
405     function sendETHToFee(uint256 amount) private {
406         _devFund.transfer(amount.mul(4).div(10));
407         _marketingFunds.transfer(amount.mul(4).div(10));
408         _buybackWalletAddress.transfer(amount.mul(2).div(10));
409     }
410 
411     function openTrading() external onlyOwner() {
412         require(!tradingOpen, "trading is already open");
413         IUniswapV2Router02 _uniswapV2Router =
414             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
415         uniswapV2Router = _uniswapV2Router;
416         _approve(address(this), address(uniswapV2Router), _tTotal);
417         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
418             .createPair(address(this), _uniswapV2Router.WETH());
419         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
420             address(this),
421             balanceOf(address(this)),
422             0,
423             0,
424             owner(),
425             block.timestamp
426         );
427         swapEnabled = true;
428         cooldownEnabled = true;
429         _maxTxAmount = 5000000000 * 10**9;
430         launchBlock = block.number;
431         tradingOpen = true;
432         IERC20(uniswapV2Pair).approve(
433             address(uniswapV2Router),
434             type(uint256).max
435         );
436     }
437 
438     function manualswap() external {
439         require(_msgSender() == _devFund);
440         uint256 contractBalance = balanceOf(address(this));
441         swapTokensForEth(contractBalance);
442     }
443 
444     function manualsend() external {
445         require(_msgSender() == _devFund);
446         uint256 contractETHBalance = address(this).balance;
447         sendETHToFee(contractETHBalance);
448     }
449 
450     function setBots(address[] memory bots_) public onlyOwner {
451         for (uint256 i = 0; i < bots_.length; i++) {
452             bots[bots_[i]] = true;
453         }
454     }
455 
456     function delBot(address notbot) public onlyOwner {
457         bots[notbot] = false;
458     }
459 
460     function _tokenTransfer(
461         address sender,
462         address recipient,
463         uint256 amount,
464         bool takeFee
465     ) private {
466         if (!takeFee) removeAllFee();
467         _transferStandard(sender, recipient, amount);
468         if (!takeFee) restoreAllFee();
469     }
470 
471     function _transferStandard(
472         address sender,
473         address recipient,
474         uint256 tAmount
475     ) private {
476         (
477             uint256 rAmount,
478             uint256 rTransferAmount,
479             uint256 rFee,
480             uint256 tTransferAmount,
481             uint256 tFee,
482             uint256 tTeam
483         ) = _getValues(tAmount);
484         _rOwned[sender] = _rOwned[sender].sub(rAmount);
485         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
486         _takeTeam(tTeam);
487         _reflectFee(rFee, tFee);
488         emit Transfer(sender, recipient, tTransferAmount);
489     }
490 
491     function _takeTeam(uint256 tTeam) private {
492         uint256 currentRate = _getRate();
493         uint256 rTeam = tTeam.mul(currentRate);
494         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
495     }
496 
497     function _reflectFee(uint256 rFee, uint256 tFee) private {
498         _rTotal = _rTotal.sub(rFee);
499         _tFeeTotal = _tFeeTotal.add(tFee);
500     }
501 
502     receive() external payable {}
503 
504     function _getValues(uint256 tAmount)
505         private
506         view
507         returns (
508             uint256,
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
517             _getTValues(tAmount, _taxFee, _teamFee);
518         uint256 currentRate = _getRate();
519         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
520             _getRValues(tAmount, tFee, tTeam, currentRate);
521         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
522     }
523 
524     function _getTValues(
525         uint256 tAmount,
526         uint256 taxFee,
527         uint256 TeamFee
528     )
529         private
530         pure
531         returns (
532             uint256,
533             uint256,
534             uint256
535         )
536     {
537         uint256 tFee = tAmount.mul(taxFee).div(100);
538         uint256 tTeam = tAmount.mul(TeamFee).div(100);
539         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
540         return (tTransferAmount, tFee, tTeam);
541     }
542 
543     function _getRValues(
544         uint256 tAmount,
545         uint256 tFee,
546         uint256 tTeam,
547         uint256 currentRate
548     )
549         private
550         pure
551         returns (
552             uint256,
553             uint256,
554             uint256
555         )
556     {
557         uint256 rAmount = tAmount.mul(currentRate);
558         uint256 rFee = tFee.mul(currentRate);
559         uint256 rTeam = tTeam.mul(currentRate);
560         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
561         return (rAmount, rTransferAmount, rFee);
562     }
563 
564     function _getRate() private view returns (uint256) {
565         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
566         return rSupply.div(tSupply);
567     }
568 
569     function _getCurrentSupply() private view returns (uint256, uint256) {
570         uint256 rSupply = _rTotal;
571         uint256 tSupply = _tTotal;
572         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
573         return (rSupply, tSupply);
574     }
575 
576     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
577         require(maxTxPercent > 0, "Amount must be greater than 0");
578         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
579         emit MaxTxAmountUpdated(_maxTxAmount);
580     }
581 }