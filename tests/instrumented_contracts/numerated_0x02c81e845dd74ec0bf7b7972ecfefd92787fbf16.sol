1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-10
3 */
4 
5 /*
6 - Developer provides LP, no presale
7 - No Team Tokens, Locked LP
8 - 100% Fair Launch
9 
10 
11 https://t.me/lokiinuerc20
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 }
78 
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99 
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138 
139     function factory() external pure returns (address);
140 
141     function WETH() external pure returns (address);
142 
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159 
160 contract LokiInu is Context, IERC20, Ownable {
161     using SafeMath for uint256;
162 
163     string private constant _name = "Loki Inu";
164     string private constant _symbol = "LOKI";
165     uint8 private constant _decimals = 9;
166 
167     // RFI
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 1000000000000 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _taxFee = 5;
177     uint256 private _teamFee = 10;
178 
179     // Bot detection
180     mapping(address => bool) private bots;
181     mapping(address => uint256) private cooldown;
182     address payable private _teamAddress;
183     address payable private _marketingFunds;
184     IUniswapV2Router02 private uniswapV2Router;
185     address private uniswapV2Pair;
186     bool private tradingOpen;
187     bool private inSwap = false;
188     bool private swapEnabled = false;
189     bool private cooldownEnabled = false;
190     uint256 private _maxTxAmount = _tTotal;
191 
192     event MaxTxAmountUpdated(uint256 _maxTxAmount);
193     modifier lockTheSwap {
194         inSwap = true;
195         _;
196         inSwap = false;
197     }
198 
199     constructor(address payable addr1, address payable addr2) {
200         _teamAddress = addr1;
201         _marketingFunds = addr2;
202         _rOwned[_msgSender()] = _rTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_teamAddress] = true;
206         _isExcludedFromFee[_marketingFunds] = true;
207         emit Transfer(address(0), _msgSender(), _tTotal);
208     }
209 
210     function name() public pure returns (string memory) {
211         return _name;
212     }
213 
214     function symbol() public pure returns (string memory) {
215         return _symbol;
216     }
217 
218     function decimals() public pure returns (uint8) {
219         return _decimals;
220     }
221 
222     function totalSupply() public pure override returns (uint256) {
223         return _tTotal;
224     }
225 
226     function balanceOf(address account) public view override returns (uint256) {
227         return tokenFromReflection(_rOwned[account]);
228     }
229 
230     function transfer(address recipient, uint256 amount)
231         public
232         override
233         returns (bool)
234     {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     function allowance(address owner, address spender)
240         public
241         view
242         override
243         returns (uint256)
244     {
245         return _allowances[owner][spender];
246     }
247 
248     function approve(address spender, uint256 amount)
249         public
250         override
251         returns (bool)
252     {
253         _approve(_msgSender(), spender, amount);
254         return true;
255     }
256 
257     function transferFrom(
258         address sender,
259         address recipient,
260         uint256 amount
261     ) public override returns (bool) {
262         _transfer(sender, recipient, amount);
263         _approve(
264             sender,
265             _msgSender(),
266             _allowances[sender][_msgSender()].sub(
267                 amount,
268                 "ERC20: transfer amount exceeds allowance"
269             )
270         );
271         return true;
272     }
273 
274     function setCooldownEnabled(bool onoff) external onlyOwner() {
275         cooldownEnabled = onoff;
276     }
277 
278     function tokenFromReflection(uint256 rAmount)
279         private
280         view
281         returns (uint256)
282     {
283         require(
284             rAmount <= _rTotal,
285             "Amount must be less than total reflections"
286         );
287         uint256 currentRate = _getRate();
288         return rAmount.div(currentRate);
289     }
290 
291     function removeAllFee() private {
292         if (_taxFee == 0 && _teamFee == 0) return;
293         _taxFee = 0;
294         _teamFee = 0;
295     }
296 
297     function restoreAllFee() private {
298         _taxFee = 5;
299         _teamFee = 10;
300     }
301 
302     function _approve(
303         address owner,
304         address spender,
305         uint256 amount
306     ) private {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309         _allowances[owner][spender] = amount;
310         emit Approval(owner, spender, amount);
311     }
312 
313     function _transfer(
314         address from,
315         address to,
316         uint256 amount
317     ) private {
318         require(from != address(0), "ERC20: transfer from the zero address");
319         require(to != address(0), "ERC20: transfer to the zero address");
320         require(amount > 0, "Transfer amount must be greater than zero");
321 
322         if (from != owner() && to != owner()) {
323             if (cooldownEnabled) {
324                 if (
325                     from != address(this) &&
326                     to != address(this) &&
327                     from != address(uniswapV2Router) &&
328                     to != address(uniswapV2Router)
329                 ) {
330                     require(
331                         _msgSender() == address(uniswapV2Router) ||
332                             _msgSender() == uniswapV2Pair,
333                         "ERR: Uniswap only"
334                     );
335                 }
336             }
337             require(amount <= _maxTxAmount);
338             require(!bots[from] && !bots[to]);
339             if (
340                 from == uniswapV2Pair &&
341                 to != address(uniswapV2Router) &&
342                 !_isExcludedFromFee[to] &&
343                 cooldownEnabled
344             ) {
345                 require(cooldown[to] < block.timestamp);
346                 cooldown[to] = block.timestamp + (30 seconds);
347             }
348             uint256 contractTokenBalance = balanceOf(address(this));
349             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
350                 swapTokensForEth(contractTokenBalance);
351                 uint256 contractETHBalance = address(this).balance;
352                 if (contractETHBalance > 0) {
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
366     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
367         address[] memory path = new address[](2);
368         path[0] = address(this);
369         path[1] = uniswapV2Router.WETH();
370         _approve(address(this), address(uniswapV2Router), tokenAmount);
371         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
372             tokenAmount,
373             0,
374             path,
375             address(this),
376             block.timestamp
377         );
378     }
379 
380     function sendETHToFee(uint256 amount) private {
381         _teamAddress.transfer(amount.div(2));
382         _marketingFunds.transfer(amount.div(2));
383     }
384 
385     function startTrading() external onlyOwner() {
386         require(!tradingOpen, "trading is already started");
387         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
401         cooldownEnabled = false;
402         _maxTxAmount = 10000000000 * 10**9;
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
422     function blockBots(address[] memory bots_) public onlyOwner {
423         for (uint256 i = 0; i < bots_.length; i++) {
424             bots[bots_[i]] = true;
425         }
426     }
427 
428     function unblockBot(address notbot) public onlyOwner {
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
493         
494         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
495     }
496 
497     function _getTValues(
498         uint256 tAmount,
499         uint256 taxFee,
500         uint256 TeamFee
501     )
502         private
503         pure
504         returns (
505             uint256,
506             uint256,
507             uint256
508         )
509     {
510         uint256 tFee = tAmount.mul(taxFee).div(100);
511         uint256 tTeam = tAmount.mul(TeamFee).div(100);
512         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
513 
514         return (tTransferAmount, tFee, tTeam);
515     }
516 
517     function _getRValues(
518         uint256 tAmount,
519         uint256 tFee,
520         uint256 tTeam,
521         uint256 currentRate
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 rAmount = tAmount.mul(currentRate);
532         uint256 rFee = tFee.mul(currentRate);
533         uint256 rTeam = tTeam.mul(currentRate);
534         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
535 
536         return (rAmount, rTransferAmount, rFee);
537     }
538 
539     function _getRate() private view returns (uint256) {
540         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
541 
542         return rSupply.div(tSupply);
543     }
544 
545     function _getCurrentSupply() private view returns (uint256, uint256) {
546         uint256 rSupply = _rTotal;
547         uint256 tSupply = _tTotal;
548         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
549 
550         return (rSupply, tSupply);
551     }
552 
553     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
554         require(maxTxPercent > 0, "Amount must be greater than 0");
555         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
556         emit MaxTxAmountUpdated(_maxTxAmount);
557     }
558 }