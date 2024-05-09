1 // SPDX-License-Identifier: Unlicensed
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
150 contract EverGive is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152 
153     string private constant _name = "EverGive";
154     string private constant _symbol = "EGIVE";
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
166     uint256 private _taxFee = 5;
167     uint256 private _teamFee = 20;
168 
169     // Bot detection
170     mapping(address => bool) private bots;
171     mapping(address => uint256) private cooldown;
172     address payable private _teamAddress;
173     address payable private _marketingFunds;
174     IUniswapV2Router02 private uniswapV2Router;
175     address private uniswapV2Pair;
176     bool private tradingOpen;
177     bool private inSwap = false;
178     bool private swapEnabled = false;
179     bool private cooldownEnabled = false;
180     uint256 private _maxTxAmount = _tTotal;
181 
182     event MaxTxAmountUpdated(uint256 _maxTxAmount);
183     modifier lockTheSwap {
184         inSwap = true;
185         _;
186         inSwap = false;
187     }
188 
189     constructor(address payable addr1, address payable addr2) {
190         _teamAddress = addr1;
191         _marketingFunds = addr2;
192         _rOwned[_msgSender()] = _rTotal;
193         _isExcludedFromFee[owner()] = true;
194         _isExcludedFromFee[address(this)] = true;
195         _isExcludedFromFee[_teamAddress] = true;
196         _isExcludedFromFee[_marketingFunds] = true;
197         emit Transfer(address(0), _msgSender(), _tTotal);
198     }
199 
200     function name() public pure returns (string memory) {
201         return _name;
202     }
203 
204     function symbol() public pure returns (string memory) {
205         return _symbol;
206     }
207 
208     function decimals() public pure returns (uint8) {
209         return _decimals;
210     }
211 
212     function totalSupply() public pure override returns (uint256) {
213         return _tTotal;
214     }
215 
216     function balanceOf(address account) public view override returns (uint256) {
217         return tokenFromReflection(_rOwned[account]);
218     }
219 
220     function transfer(address recipient, uint256 amount)
221         public
222         override
223         returns (bool)
224     {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(address owner, address spender)
230         public
231         view
232         override
233         returns (uint256)
234     {
235         return _allowances[owner][spender];
236     }
237 
238     function approve(address spender, uint256 amount)
239         public
240         override
241         returns (bool)
242     {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(
254             sender,
255             _msgSender(),
256             _allowances[sender][_msgSender()].sub(
257                 amount,
258                 "ERC20: transfer amount exceeds allowance"
259             )
260         );
261         return true;
262     }
263 
264     function setCooldownEnabled(bool onoff) external onlyOwner() {
265         cooldownEnabled = onoff;
266     }
267 
268     function tokenFromReflection(uint256 rAmount)
269         private
270         view
271         returns (uint256)
272     {
273         require(
274             rAmount <= _rTotal,
275             "Amount must be less than total reflections"
276         );
277         uint256 currentRate = _getRate();
278         return rAmount.div(currentRate);
279     }
280 
281     function removeAllFee() private {
282         if (_taxFee == 0 && _teamFee == 0) return;
283         _taxFee = 0;
284         _teamFee = 0;
285     }
286 
287     function restoreAllFee() private {
288         _taxFee = 5;
289         _teamFee = 20;
290     }
291 
292     function _approve(
293         address owner,
294         address spender,
295         uint256 amount
296     ) private {
297         require(owner != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299         _allowances[owner][spender] = amount;
300         emit Approval(owner, spender, amount);
301     }
302 
303     function _transfer(
304         address from,
305         address to,
306         uint256 amount
307     ) private {
308         require(from != address(0), "ERC20: transfer from the zero address");
309         require(to != address(0), "ERC20: transfer to the zero address");
310         require(amount > 0, "Transfer amount must be greater than zero");
311 
312         if (from != owner() && to != owner()) {
313             if (cooldownEnabled) {
314                 if (
315                     from != address(this) &&
316                     to != address(this) &&
317                     from != address(uniswapV2Router) &&
318                     to != address(uniswapV2Router)
319                 ) {
320                     require(
321                         _msgSender() == address(uniswapV2Router) ||
322                             _msgSender() == uniswapV2Pair,
323                         "ERR: Uniswap only"
324                     );
325                 }
326             }
327             require(amount <= _maxTxAmount);
328             require(!bots[from] && !bots[to]);
329             if (
330                 from == uniswapV2Pair &&
331                 to != address(uniswapV2Router) &&
332                 !_isExcludedFromFee[to] &&
333                 cooldownEnabled
334             ) {
335                 require(cooldown[to] < block.timestamp);
336                 cooldown[to] = block.timestamp + (60 seconds);
337             }
338             uint256 contractTokenBalance = balanceOf(address(this));
339             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
340                 swapTokensForEth(contractTokenBalance);
341                 uint256 contractETHBalance = address(this).balance;
342                 if (contractETHBalance > 0) {
343                     sendETHToFee(address(this).balance);
344                 }
345             }
346         }
347         bool takeFee = true;
348 
349         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
350             takeFee = false;
351         }
352 
353         _tokenTransfer(from, to, amount, takeFee);
354     }
355 
356     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
357         address[] memory path = new address[](2);
358         path[0] = address(this);
359         path[1] = uniswapV2Router.WETH();
360         _approve(address(this), address(uniswapV2Router), tokenAmount);
361         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
362             tokenAmount,
363             0,
364             path,
365             address(this),
366             block.timestamp
367         );
368     }
369 
370     function sendETHToFee(uint256 amount) private {
371         _teamAddress.transfer(amount.div(2));
372         _marketingFunds.transfer(amount.div(2));
373     }
374 
375     function openTrading() external onlyOwner() {
376         require(!tradingOpen, "trading is already open");
377         IUniswapV2Router02 _uniswapV2Router =
378             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
379         uniswapV2Router = _uniswapV2Router;
380         _approve(address(this), address(uniswapV2Router), _tTotal);
381         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
382             .createPair(address(this), _uniswapV2Router.WETH());
383         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
384             address(this),
385             balanceOf(address(this)),
386             0,
387             0,
388             owner(),
389             block.timestamp
390         );
391         swapEnabled = true;
392         cooldownEnabled = true;
393         _maxTxAmount = 2500000000 * 10**9;
394         tradingOpen = true;
395         IERC20(uniswapV2Pair).approve(
396             address(uniswapV2Router),
397             type(uint256).max
398         );
399     }
400 
401     function manualswap() external {
402         require(_msgSender() == _teamAddress);
403         uint256 contractBalance = balanceOf(address(this));
404         swapTokensForEth(contractBalance);
405     }
406 
407     function manualsend() external {
408         require(_msgSender() == _teamAddress);
409         uint256 contractETHBalance = address(this).balance;
410         sendETHToFee(contractETHBalance);
411     }
412 
413     function setBots(address[] memory bots_) public onlyOwner {
414         for (uint256 i = 0; i < bots_.length; i++) {
415             bots[bots_[i]] = true;
416         }
417     }
418 
419     function delBot(address notbot) public onlyOwner {
420         bots[notbot] = false;
421     }
422 
423     function _tokenTransfer(
424         address sender,
425         address recipient,
426         uint256 amount,
427         bool takeFee
428     ) private {
429         if (!takeFee) removeAllFee();
430         _transferStandard(sender, recipient, amount);
431         if (!takeFee) restoreAllFee();
432     }
433 
434     function _transferStandard(
435         address sender,
436         address recipient,
437         uint256 tAmount
438     ) private {
439         (
440             uint256 rAmount,
441             uint256 rTransferAmount,
442             uint256 rFee,
443             uint256 tTransferAmount,
444             uint256 tFee,
445             uint256 tTeam
446         ) = _getValues(tAmount);
447         _rOwned[sender] = _rOwned[sender].sub(rAmount);
448         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
449         _takeTeam(tTeam);
450         _reflectFee(rFee, tFee);
451         emit Transfer(sender, recipient, tTransferAmount);
452     }
453 
454     function _takeTeam(uint256 tTeam) private {
455         uint256 currentRate = _getRate();
456         uint256 rTeam = tTeam.mul(currentRate);
457         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
458     }
459 
460     function _reflectFee(uint256 rFee, uint256 tFee) private {
461         _rTotal = _rTotal.sub(rFee);
462         _tFeeTotal = _tFeeTotal.add(tFee);
463     }
464 
465     receive() external payable {}
466 
467     function _getValues(uint256 tAmount)
468         private
469         view
470         returns (
471             uint256,
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256
477         )
478     {
479         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
480             _getTValues(tAmount, _taxFee, _teamFee);
481         uint256 currentRate = _getRate();
482         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
483             _getRValues(tAmount, tFee, tTeam, currentRate);
484         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
485     }
486 
487     function _getTValues(
488         uint256 tAmount,
489         uint256 taxFee,
490         uint256 TeamFee
491     )
492         private
493         pure
494         returns (
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         uint256 tFee = tAmount.mul(taxFee).div(100);
501         uint256 tTeam = tAmount.mul(TeamFee).div(100);
502         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
503         return (tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getRValues(
507         uint256 tAmount,
508         uint256 tFee,
509         uint256 tTeam,
510         uint256 currentRate
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 rAmount = tAmount.mul(currentRate);
521         uint256 rFee = tFee.mul(currentRate);
522         uint256 rTeam = tTeam.mul(currentRate);
523         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
524         return (rAmount, rTransferAmount, rFee);
525     }
526 
527     function _getRate() private view returns (uint256) {
528         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
529         return rSupply.div(tSupply);
530     }
531 
532     function _getCurrentSupply() private view returns (uint256, uint256) {
533         uint256 rSupply = _rTotal;
534         uint256 tSupply = _tTotal;
535         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
536         return (rSupply, tSupply);
537     }
538 
539     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
540         require(maxTxPercent > 0, "Amount must be greater than 0");
541         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
542         emit MaxTxAmountUpdated(_maxTxAmount);
543     }
544 }