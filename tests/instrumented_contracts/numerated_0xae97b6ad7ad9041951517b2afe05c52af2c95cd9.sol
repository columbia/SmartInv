1 //Waifu Inu ($wINU)
2 
3 //Deflationary yes
4 //Telegram: https://t.me/waifuinuofficial
5 
6 //Fair Launch
7 
8 // SPDX-License-Identifier: Unlicensed
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
157 contract WaifuInu is Context, IERC20, Ownable {
158     using SafeMath for uint256;
159 
160     string private constant _name = "Waifu Inu";
161     string private constant _symbol = "wINU";
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
173     uint256 private _taxFee = 1;
174     uint256 private _teamFee = 12;
175 
176     // Bot detection
177     mapping(address => bool) private bots;
178     mapping(address => uint256) private cooldown;
179     address payable private _teamAddress;
180     address payable private _marketingFunds;
181     IUniswapV2Router02 private uniswapV2Router;
182     address private uniswapV2Pair;
183     bool private tradingOpen;
184     bool private inSwap = false;
185     bool private swapEnabled = false;
186     bool private cooldownEnabled = false;
187     uint256 private _maxTxAmount = _tTotal;
188 
189     event MaxTxAmountUpdated(uint256 _maxTxAmount);
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195 
196     constructor(address payable addr1, address payable addr2) {
197         _teamAddress = addr1;
198         _marketingFunds = addr2;
199         _rOwned[_msgSender()] = _rTotal;
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202         _isExcludedFromFee[_teamAddress] = true;
203         _isExcludedFromFee[_marketingFunds] = true;
204         emit Transfer(address(0), _msgSender(), _tTotal);
205     }
206 
207     function name() public pure returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public pure returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public pure returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public pure override returns (uint256) {
220         return _tTotal;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return tokenFromReflection(_rOwned[account]);
225     }
226 
227     function transfer(address recipient, uint256 amount)
228         public
229         override
230         returns (bool)
231     {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     function allowance(address owner, address spender)
237         public
238         view
239         override
240         returns (uint256)
241     {
242         return _allowances[owner][spender];
243     }
244 
245     function approve(address spender, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(
255         address sender,
256         address recipient,
257         uint256 amount
258     ) public override returns (bool) {
259         _transfer(sender, recipient, amount);
260         _approve(
261             sender,
262             _msgSender(),
263             _allowances[sender][_msgSender()].sub(
264                 amount,
265                 "ERC20: transfer amount exceeds allowance"
266             )
267         );
268         return true;
269     }
270 
271     function setCooldownEnabled(bool onoff) external onlyOwner() {
272         cooldownEnabled = onoff;
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
288     function removeAllFee() private {
289         if (_taxFee == 0 && _teamFee == 0) return;
290         _taxFee = 0;
291         _teamFee = 0;
292     }
293 
294     function restoreAllFee() private {
295         _taxFee = 5;
296         _teamFee = 10;
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
334             require(amount <= _maxTxAmount);
335             require(!bots[from] && !bots[to]);
336             if (
337                 from == uniswapV2Pair &&
338                 to != address(uniswapV2Router) &&
339                 !_isExcludedFromFee[to] &&
340                 cooldownEnabled
341             ) {
342                 require(cooldown[to] < block.timestamp);
343                 cooldown[to] = block.timestamp + (30 seconds);
344             }
345             uint256 contractTokenBalance = balanceOf(address(this));
346             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
347                 swapTokensForEth(contractTokenBalance);
348                 uint256 contractETHBalance = address(this).balance;
349                 if (contractETHBalance > 0) {
350                     sendETHToFee(address(this).balance);
351                 }
352             }
353         }
354         bool takeFee = true;
355 
356         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
357             takeFee = false;
358         }
359 
360         _tokenTransfer(from, to, amount, takeFee);
361     }
362 
363     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
364         address[] memory path = new address[](2);
365         path[0] = address(this);
366         path[1] = uniswapV2Router.WETH();
367         _approve(address(this), address(uniswapV2Router), tokenAmount);
368         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
369             tokenAmount,
370             0,
371             path,
372             address(this),
373             block.timestamp
374         );
375     }
376 
377     function sendETHToFee(uint256 amount) private {
378         _teamAddress.transfer(amount.div(2));
379         _marketingFunds.transfer(amount.div(2));
380     }
381 
382     function openTrading() external onlyOwner() {
383         require(!tradingOpen, "trading is already open");
384         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
385             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
386         );
387         uniswapV2Router = _uniswapV2Router;
388         _approve(address(this), address(uniswapV2Router), _tTotal);
389         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
390         .createPair(address(this), _uniswapV2Router.WETH());
391         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
392             address(this),
393             balanceOf(address(this)),
394             0,
395             0,
396             owner(),
397             block.timestamp
398         );
399         swapEnabled = true;
400         cooldownEnabled = true;
401         _maxTxAmount = 3000000000 * 10**9;
402         tradingOpen = true;
403         IERC20(uniswapV2Pair).approve(
404             address(uniswapV2Router),
405             type(uint256).max
406         );
407     }
408 
409     function manualswap() external {
410         require(_msgSender() == _teamAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414 
415     function manualsend() external {
416         require(_msgSender() == _teamAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420 
421     function setBots(address[] memory bots_) public onlyOwner {
422         for (uint256 i = 0; i < bots_.length; i++) {
423             bots[bots_[i]] = true;
424         }
425     }
426 
427     function delBot(address notbot) public onlyOwner {
428         bots[notbot] = false;
429     }
430 
431     function _tokenTransfer(
432         address sender,
433         address recipient,
434         uint256 amount,
435         bool takeFee
436     ) private {
437         if (!takeFee) removeAllFee();
438         _transferStandard(sender, recipient, amount);
439         if (!takeFee) restoreAllFee();
440     }
441 
442     function _transferStandard(
443         address sender,
444         address recipient,
445         uint256 tAmount
446     ) private {
447         (
448             uint256 rAmount,
449             uint256 rTransferAmount,
450             uint256 rFee,
451             uint256 tTransferAmount,
452             uint256 tFee,
453             uint256 tTeam
454         ) = _getValues(tAmount);
455         _rOwned[sender] = _rOwned[sender].sub(rAmount);
456         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
457         _takeTeam(tTeam);
458         _reflectFee(rFee, tFee);
459         emit Transfer(sender, recipient, tTransferAmount);
460     }
461 
462     function _takeTeam(uint256 tTeam) private {
463         uint256 currentRate = _getRate();
464         uint256 rTeam = tTeam.mul(currentRate);
465         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
466     }
467 
468     function _reflectFee(uint256 rFee, uint256 tFee) private {
469         _rTotal = _rTotal.sub(rFee);
470         _tFeeTotal = _tFeeTotal.add(tFee);
471     }
472 
473     receive() external payable {}
474 
475     function _getValues(uint256 tAmount)
476         private
477         view
478         returns (
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256
485         )
486     {
487         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
488             tAmount,
489             _taxFee,
490             _teamFee
491         );
492         uint256 currentRate = _getRate();
493         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
494             tAmount,
495             tFee,
496             tTeam,
497             currentRate
498         );
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getTValues(
503         uint256 tAmount,
504         uint256 taxFee,
505         uint256 TeamFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(taxFee).div(100);
516         uint256 tTeam = tAmount.mul(TeamFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
518         return (tTransferAmount, tFee, tTeam);
519     }
520 
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539         return (rAmount, rTransferAmount, rFee);
540     }
541 
542     function _getRate() private view returns (uint256) {
543         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
544         return rSupply.div(tSupply);
545     }
546 
547     function _getCurrentSupply() private view returns (uint256, uint256) {
548         uint256 rSupply = _rTotal;
549         uint256 tSupply = _tTotal;
550         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
551         return (rSupply, tSupply);
552     }
553 
554     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
555         require(maxTxPercent > 0, "Amount must be greater than 0");
556         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
557         emit MaxTxAmountUpdated(_maxTxAmount);
558     }
559 }