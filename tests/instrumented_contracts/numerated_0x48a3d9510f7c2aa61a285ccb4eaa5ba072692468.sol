1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-20
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-20
7 */
8 
9 //Football Inu ($fINU)
10 //Powerful Bot Protect yes
11 
12 //2% Deflationary yes
13 //Telegram: https://t.me/footballinuofficial
14 
15 //CG, CMC listing: Ongoing
16 //Fair Launch
17 
18 
19 // SPDX-License-Identifier: Unlicensed
20 pragma solidity ^0.8.4;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76         return c;
77     }
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         return c;
100     }
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     address private _previousOwner;
106     event OwnershipTransferred(
107         address indexed previousOwner,
108         address indexed newOwner
109     );
110 
111     constructor() {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     function owner() public view returns (address) {
118         return _owner;
119     }
120 
121     modifier onlyOwner() {
122         require(_owner == _msgSender(), "Ownable: caller is not the owner");
123         _;
124     }
125 
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130 }
131 
132 interface IUniswapV2Factory {
133     function createPair(address tokenA, address tokenB)
134         external
135         returns (address pair);
136 }
137 
138 interface IUniswapV2Router02 {
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint256 amountIn,
141         uint256 amountOutMin,
142         address[] calldata path,
143         address to,
144         uint256 deadline
145     ) external;
146 
147     function factory() external pure returns (address);
148 
149     function WETH() external pure returns (address);
150 
151     function addLiquidityETH(
152         address token,
153         uint256 amountTokenDesired,
154         uint256 amountTokenMin,
155         uint256 amountETHMin,
156         address to,
157         uint256 deadline
158     )
159         external
160         payable
161         returns (
162             uint256 amountToken,
163             uint256 amountETH,
164             uint256 liquidity
165         );
166 }
167 
168 contract FootballInu is Context, IERC20, Ownable {
169     using SafeMath for uint256;
170 
171     string private constant _name = "Football Inu";
172     string private constant _symbol = "fINU";
173     uint8 private constant _decimals = 9;
174 
175     // RFI
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181     uint256 private constant _tTotal = 1000000000000 * 10**9;
182     uint256 private _rTotal = (MAX - (MAX % _tTotal));
183     uint256 private _tFeeTotal;
184     uint256 private _taxFee = 5;
185     uint256 private _teamFee = 10;
186 
187     // Bot detection
188     mapping(address => bool) private bots;
189     mapping(address => uint256) private cooldown;
190     address payable private _teamAddress;
191     address payable private _marketingFunds;
192     IUniswapV2Router02 private uniswapV2Router;
193     address private uniswapV2Pair;
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = false;
197     bool private cooldownEnabled = false;
198     uint256 private _maxTxAmount = _tTotal;
199 
200     event MaxTxAmountUpdated(uint256 _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor(address payable addr1, address payable addr2) {
208         _teamAddress = addr1;
209         _marketingFunds = addr2;
210         _rOwned[_msgSender()] = _rTotal;
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[address(this)] = true;
213         _isExcludedFromFee[_teamAddress] = true;
214         _isExcludedFromFee[_marketingFunds] = true;
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
282     function setCooldownEnabled(bool onoff) external onlyOwner() {
283         cooldownEnabled = onoff;
284     }
285 
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298 
299     function removeAllFee() private {
300         if (_taxFee == 0 && _teamFee == 0) return;
301         _taxFee = 0;
302         _teamFee = 0;
303     }
304 
305     function restoreAllFee() private {
306         _taxFee = 5;
307         _teamFee = 10;
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
331             if (cooldownEnabled) {
332                 if (
333                     from != address(this) &&
334                     to != address(this) &&
335                     from != address(uniswapV2Router) &&
336                     to != address(uniswapV2Router)
337                 ) {
338                     require(
339                         _msgSender() == address(uniswapV2Router) ||
340                             _msgSender() == uniswapV2Pair,
341                         "ERR: Uniswap only"
342                     );
343                 }
344             }
345             require(amount <= _maxTxAmount);
346             require(!bots[from] && !bots[to]);
347             if (
348                 from == uniswapV2Pair &&
349                 to != address(uniswapV2Router) &&
350                 !_isExcludedFromFee[to] &&
351                 cooldownEnabled
352             ) {
353                 require(cooldown[to] < block.timestamp);
354                 cooldown[to] = block.timestamp + (60 seconds);
355             }
356             uint256 contractTokenBalance = balanceOf(address(this));
357             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
358                 swapTokensForEth(contractTokenBalance);
359                 uint256 contractETHBalance = address(this).balance;
360                 if (contractETHBalance > 0) {
361                     sendETHToFee(address(this).balance);
362                 }
363             }
364         }
365         bool takeFee = true;
366 
367         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
368             takeFee = false;
369         }
370 
371         _tokenTransfer(from, to, amount, takeFee);
372     }
373 
374     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
375         address[] memory path = new address[](2);
376         path[0] = address(this);
377         path[1] = uniswapV2Router.WETH();
378         _approve(address(this), address(uniswapV2Router), tokenAmount);
379         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
380             tokenAmount,
381             0,
382             path,
383             address(this),
384             block.timestamp
385         );
386     }
387 
388     function sendETHToFee(uint256 amount) private {
389         _teamAddress.transfer(amount.mul(4).div(10));
390         _marketingFunds.transfer(amount.mul(6).div(10));
391     }
392 
393     function openTrading() external onlyOwner() {
394         require(!tradingOpen, "trading is already open");
395         IUniswapV2Router02 _uniswapV2Router =
396             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
397         uniswapV2Router = _uniswapV2Router;
398         _approve(address(this), address(uniswapV2Router), _tTotal);
399         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
400             .createPair(address(this), _uniswapV2Router.WETH());
401         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
402             address(this),
403             balanceOf(address(this)),
404             0,
405             0,
406             owner(),
407             block.timestamp
408         );
409         swapEnabled = true;
410         cooldownEnabled = true;
411         _maxTxAmount = 2500000000 * 10**9;
412         tradingOpen = true;
413         IERC20(uniswapV2Pair).approve(
414             address(uniswapV2Router),
415             type(uint256).max
416         );
417     }
418 
419     function manualswap() external {
420         require(_msgSender() == _teamAddress);
421         uint256 contractBalance = balanceOf(address(this));
422         swapTokensForEth(contractBalance);
423     }
424 
425     function manualsend() external {
426         require(_msgSender() == _teamAddress);
427         uint256 contractETHBalance = address(this).balance;
428         sendETHToFee(contractETHBalance);
429     }
430 
431     function setBots(address[] memory bots_) public onlyOwner {
432         for (uint256 i = 0; i < bots_.length; i++) {
433             bots[bots_[i]] = true;
434         }
435     }
436 
437     function delBot(address notbot) public onlyOwner {
438         bots[notbot] = false;
439     }
440 
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (!takeFee) removeAllFee();
448         _transferStandard(sender, recipient, amount);
449         if (!takeFee) restoreAllFee();
450     }
451 
452     function _transferStandard(
453         address sender,
454         address recipient,
455         uint256 tAmount
456     ) private {
457         (
458             uint256 rAmount,
459             uint256 rTransferAmount,
460             uint256 rFee,
461             uint256 tTransferAmount,
462             uint256 tFee,
463             uint256 tTeam
464         ) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471 
472     function _takeTeam(uint256 tTeam) private {
473         uint256 currentRate = _getRate();
474         uint256 rTeam = tTeam.mul(currentRate);
475         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
476     }
477 
478     function _reflectFee(uint256 rFee, uint256 tFee) private {
479         _rTotal = _rTotal.sub(rFee);
480         _tFeeTotal = _tFeeTotal.add(tFee);
481     }
482 
483     receive() external payable {}
484 
485     function _getValues(uint256 tAmount)
486         private
487         view
488         returns (
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256
495         )
496     {
497         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
498             _getTValues(tAmount, _taxFee, _teamFee);
499         uint256 currentRate = _getRate();
500         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
501             _getRValues(tAmount, tFee, tTeam, currentRate);
502         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
503     }
504 
505     function _getTValues(
506         uint256 tAmount,
507         uint256 taxFee,
508         uint256 TeamFee
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 tFee = tAmount.mul(taxFee).div(100);
519         uint256 tTeam = tAmount.mul(TeamFee).div(100);
520         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
521         return (tTransferAmount, tFee, tTeam);
522     }
523 
524     function _getRValues(
525         uint256 tAmount,
526         uint256 tFee,
527         uint256 tTeam,
528         uint256 currentRate
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 rAmount = tAmount.mul(currentRate);
539         uint256 rFee = tFee.mul(currentRate);
540         uint256 rTeam = tTeam.mul(currentRate);
541         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
542         return (rAmount, rTransferAmount, rFee);
543     }
544 
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547         return rSupply.div(tSupply);
548     }
549 
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554         return (rSupply, tSupply);
555     }
556 
557     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
558         require(maxTxPercent > 0, "Amount must be greater than 0");
559         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
560         emit MaxTxAmountUpdated(_maxTxAmount);
561     }
562 }