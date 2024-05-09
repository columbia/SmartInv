1 //Bubbles Inu ($BUBINU)
2 
3 //2% Deflationary yes
4 //Telegram: https://t.me/bubblesinuofficial
5 
6 //CG, CMC listing: Ongoing
7 //Fair Launch
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27 
28     function allowance(address owner, address spender)
29         external
30         view
31         returns (uint256);
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
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     address private _previousOwner;
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102     constructor() {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 }
122 
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158 
159 contract BubblesInu is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161 
162     string private constant _name = "Bubbles Inu";
163     string private constant _symbol = "BUBINU";
164     uint8 private constant _decimals = 9;
165 
166     // RFI
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 1000000000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 private _taxFee = 2;
176     uint256 private _teamFee = 10;
177 
178     // Bot detection
179     mapping(address => bool) private bots;
180     mapping(address => uint256) private cooldown;
181     address payable private _teamAddress;
182     address payable private _marketingFunds;
183     IUniswapV2Router02 private uniswapV2Router;
184     address private uniswapV2Pair;
185     bool private tradingOpen;
186     bool private inSwap = false;
187     bool private swapEnabled = false;
188     bool private cooldownEnabled = false;
189     uint256 private _maxTxAmount = _tTotal;
190 
191     event MaxTxAmountUpdated(uint256 _maxTxAmount);
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197 
198     constructor(address payable addr1, address payable addr2) {
199         _teamAddress = addr1;
200         _marketingFunds = addr2;
201         _rOwned[_msgSender()] = _rTotal;
202         _isExcludedFromFee[owner()] = true;
203         _isExcludedFromFee[address(this)] = true;
204         _isExcludedFromFee[_teamAddress] = true;
205         _isExcludedFromFee[_marketingFunds] = true;
206         emit Transfer(address(0), _msgSender(), _tTotal);
207     }
208 
209     function name() public pure returns (string memory) {
210         return _name;
211     }
212 
213     function symbol() public pure returns (string memory) {
214         return _symbol;
215     }
216 
217     function decimals() public pure returns (uint8) {
218         return _decimals;
219     }
220 
221     function totalSupply() public pure override returns (uint256) {
222         return _tTotal;
223     }
224 
225     function balanceOf(address account) public view override returns (uint256) {
226         return tokenFromReflection(_rOwned[account]);
227     }
228 
229     function transfer(address recipient, uint256 amount)
230         public
231         override
232         returns (bool)
233     {
234         _transfer(_msgSender(), recipient, amount);
235         return true;
236     }
237 
238     function allowance(address owner, address spender)
239         public
240         view
241         override
242         returns (uint256)
243     {
244         return _allowances[owner][spender];
245     }
246 
247     function approve(address spender, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     function transferFrom(
257         address sender,
258         address recipient,
259         uint256 amount
260     ) public override returns (bool) {
261         _transfer(sender, recipient, amount);
262         _approve(
263             sender,
264             _msgSender(),
265             _allowances[sender][_msgSender()].sub(
266                 amount,
267                 "ERC20: transfer amount exceeds allowance"
268             )
269         );
270         return true;
271     }
272 
273     function setCooldownEnabled(bool onoff) external onlyOwner() {
274         cooldownEnabled = onoff;
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
291         if (_taxFee == 0 && _teamFee == 0) return;
292         _taxFee = 0;
293         _teamFee = 0;
294     }
295 
296     function restoreAllFee() private {
297         _taxFee = 5;
298         _teamFee = 10;
299     }
300 
301     function _approve(
302         address owner,
303         address spender,
304         uint256 amount
305     ) private {
306         require(owner != address(0), "ERC20: approve from the zero address");
307         require(spender != address(0), "ERC20: approve to the zero address");
308         _allowances[owner][spender] = amount;
309         emit Approval(owner, spender, amount);
310     }
311 
312     function _transfer(
313         address from,
314         address to,
315         uint256 amount
316     ) private {
317         require(from != address(0), "ERC20: transfer from the zero address");
318         require(to != address(0), "ERC20: transfer to the zero address");
319         require(amount > 0, "Transfer amount must be greater than zero");
320 
321         if (from != owner() && to != owner()) {
322             if (cooldownEnabled) {
323                 if (
324                     from != address(this) &&
325                     to != address(this) &&
326                     from != address(uniswapV2Router) &&
327                     to != address(uniswapV2Router)
328                 ) {
329                     require(
330                         _msgSender() == address(uniswapV2Router) ||
331                             _msgSender() == uniswapV2Pair,
332                         "ERR: Uniswap only"
333                     );
334                 }
335             }
336             require(amount <= _maxTxAmount);
337             require(!bots[from] && !bots[to]);
338             if (
339                 from == uniswapV2Pair &&
340                 to != address(uniswapV2Router) &&
341                 !_isExcludedFromFee[to] &&
342                 cooldownEnabled
343             ) {
344                 require(cooldown[to] < block.timestamp);
345                 cooldown[to] = block.timestamp + (60 seconds);
346             }
347             uint256 contractTokenBalance = balanceOf(address(this));
348             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
349                 swapTokensForEth(contractTokenBalance);
350                 uint256 contractETHBalance = address(this).balance;
351                 if (contractETHBalance > 0) {
352                     sendETHToFee(address(this).balance);
353                 }
354             }
355         }
356         bool takeFee = true;
357 
358         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
359             takeFee = false;
360         }
361 
362         _tokenTransfer(from, to, amount, takeFee);
363     }
364 
365     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
366         address[] memory path = new address[](2);
367         path[0] = address(this);
368         path[1] = uniswapV2Router.WETH();
369         _approve(address(this), address(uniswapV2Router), tokenAmount);
370         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
371             tokenAmount,
372             0,
373             path,
374             address(this),
375             block.timestamp
376         );
377     }
378 
379     function sendETHToFee(uint256 amount) private {
380         _teamAddress.transfer(amount.div(2));
381         _marketingFunds.transfer(amount.div(2));
382     }
383 
384     function openTrading() external onlyOwner() {
385         require(!tradingOpen, "trading is already open");
386         IUniswapV2Router02 _uniswapV2Router =
387             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
388         uniswapV2Router = _uniswapV2Router;
389         _approve(address(this), address(uniswapV2Router), _tTotal);
390         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
391             .createPair(address(this), _uniswapV2Router.WETH());
392         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
393             address(this),
394             balanceOf(address(this)),
395             0,
396             0,
397             owner(),
398             block.timestamp
399         );
400         swapEnabled = true;
401         cooldownEnabled = true;
402         _maxTxAmount = 2500000000 * 10**9;
403         tradingOpen = true;
404         IERC20(uniswapV2Pair).approve(
405             address(uniswapV2Router),
406             type(uint256).max
407         );
408     }
409 
410     function manualswap() external {
411         require(_msgSender() == _teamAddress);
412         uint256 contractBalance = balanceOf(address(this));
413         swapTokensForEth(contractBalance);
414     }
415 
416     function manualsend() external {
417         require(_msgSender() == _teamAddress);
418         uint256 contractETHBalance = address(this).balance;
419         sendETHToFee(contractETHBalance);
420     }
421 
422     function setBots(address[] memory bots_) public onlyOwner {
423         for (uint256 i = 0; i < bots_.length; i++) {
424             bots[bots_[i]] = true;
425         }
426     }
427 
428     function delBot(address notbot) public onlyOwner {
429         bots[notbot] = false;
430     }
431 
432     function _tokenTransfer(
433         address sender,
434         address recipient,
435         uint256 amount,
436         bool takeFee
437     ) private {
438         if (!takeFee) removeAllFee();
439         _transferStandard(sender, recipient, amount);
440         if (!takeFee) restoreAllFee();
441     }
442 
443     function _transferStandard(
444         address sender,
445         address recipient,
446         uint256 tAmount
447     ) private {
448         (
449             uint256 rAmount,
450             uint256 rTransferAmount,
451             uint256 rFee,
452             uint256 tTransferAmount,
453             uint256 tFee,
454             uint256 tTeam
455         ) = _getValues(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
458         _takeTeam(tTeam);
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462 
463     function _takeTeam(uint256 tTeam) private {
464         uint256 currentRate = _getRate();
465         uint256 rTeam = tTeam.mul(currentRate);
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468 
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473 
474     receive() external payable {}
475 
476     function _getValues(uint256 tAmount)
477         private
478         view
479         returns (
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
489             _getTValues(tAmount, _taxFee, _teamFee);
490         uint256 currentRate = _getRate();
491         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
492             _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495 
496     function _getTValues(
497         uint256 tAmount,
498         uint256 taxFee,
499         uint256 TeamFee
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 tFee = tAmount.mul(taxFee).div(100);
510         uint256 tTeam = tAmount.mul(TeamFee).div(100);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
512         return (tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533         return (rAmount, rTransferAmount, rFee);
534     }
535 
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538         return rSupply.div(tSupply);
539     }
540 
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547 
548     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
549         require(maxTxPercent > 0, "Amount must be greater than 0");
550         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
551         emit MaxTxAmountUpdated(_maxTxAmount);
552     }
553 }