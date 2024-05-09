1 // Hiroko Inu (HOKO)
2 
3 // Name: Hiroko Inu
4 // Symbol: HOKO
5 // Total Supply: 1,000,000,000,000
6 // Decimals: 9
7 
8 // Telegram: https://t.me/hirokoinu
9 
10 
11 
12 
13 // SPDX-License-Identifier: Unlicensed
14 
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
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157 
158 contract HIROKOINU is Context, IERC20, Ownable {
159     using SafeMath for uint256;
160 
161     string private constant _name = "Hiroko Inu";
162     string private constant _symbol = "HOKO";
163     uint8 private constant _decimals = 9;
164 
165     // RFI
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 1000000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _taxFee = 5;
175     uint256 private _teamFee = 10;
176 
177     // Bot detection
178     mapping(address => bool) private bots;
179     mapping(address => uint256) private cooldown;
180     address payable private _teamAddress;
181     address payable private _marketingFunds;
182     IUniswapV2Router02 private uniswapV2Router;
183     address private uniswapV2Pair;
184     bool private tradingOpen;
185     bool private inSwap = false;
186     bool private swapEnabled = false;
187     bool private cooldownEnabled = false;
188     uint256 private _maxTxAmount = _tTotal;
189 
190     event MaxTxAmountUpdated(uint256 _maxTxAmount);
191     modifier lockTheSwap {
192         inSwap = true;
193         _;
194         inSwap = false;
195     }
196 
197     constructor(address payable addr1, address payable addr2) {
198         _teamAddress = addr1;
199         _marketingFunds = addr2;
200         _rOwned[_msgSender()] = _rTotal;
201         _isExcludedFromFee[owner()] = true;
202         _isExcludedFromFee[address(this)] = true;
203         _isExcludedFromFee[_teamAddress] = true;
204         _isExcludedFromFee[_marketingFunds] = true;
205         emit Transfer(address(0), _msgSender(), _tTotal);
206     }
207 
208     function name() public pure returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return tokenFromReflection(_rOwned[account]);
226     }
227 
228     function transfer(address recipient, uint256 amount)
229         public
230         override
231         returns (bool)
232     {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender)
238         public
239         view
240         override
241         returns (uint256)
242     {
243         return _allowances[owner][spender];
244     }
245 
246     function approve(address spender, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _approve(_msgSender(), spender, amount);
252         return true;
253     }
254 
255     function transferFrom(
256         address sender,
257         address recipient,
258         uint256 amount
259     ) public override returns (bool) {
260         _transfer(sender, recipient, amount);
261         _approve(
262             sender,
263             _msgSender(),
264             _allowances[sender][_msgSender()].sub(
265                 amount,
266                 "ERC20: transfer amount exceeds allowance"
267             )
268         );
269         return true;
270     }
271 
272     function setCooldownEnabled(bool onoff) external onlyOwner() {
273         cooldownEnabled = onoff;
274     }
275 
276     function tokenFromReflection(uint256 rAmount)
277         private
278         view
279         returns (uint256)
280     {
281         require(
282             rAmount <= _rTotal,
283             "Amount must be less than total reflections"
284         );
285         uint256 currentRate = _getRate();
286         return rAmount.div(currentRate);
287     }
288 
289     function removeAllFee() private {
290         if (_taxFee == 0 && _teamFee == 0) return;
291         _taxFee = 0;
292         _teamFee = 0;
293     }
294 
295     function restoreAllFee() private {
296         _taxFee = 5;
297         _teamFee = 10;
298     }
299 
300     function _approve(
301         address owner,
302         address spender,
303         uint256 amount
304     ) private {
305         require(owner != address(0), "ERC20: approve from the zero address");
306         require(spender != address(0), "ERC20: approve to the zero address");
307         _allowances[owner][spender] = amount;
308         emit Approval(owner, spender, amount);
309     }
310 
311     function _transfer(
312         address from,
313         address to,
314         uint256 amount
315     ) private {
316         require(from != address(0), "ERC20: transfer from the zero address");
317         require(to != address(0), "ERC20: transfer to the zero address");
318         require(amount > 0, "Transfer amount must be greater than zero");
319 
320         if (from != owner() && to != owner()) {
321             if (cooldownEnabled) {
322                 if (
323                     from != address(this) &&
324                     to != address(this) &&
325                     from != address(uniswapV2Router) &&
326                     to != address(uniswapV2Router)
327                 ) {
328                     require(
329                         _msgSender() == address(uniswapV2Router) ||
330                             _msgSender() == uniswapV2Pair,
331                         "ERR: Uniswap only"
332                     );
333                 }
334             }
335             require(amount <= _maxTxAmount);
336             require(!bots[from] && !bots[to]);
337             if (
338                 from == uniswapV2Pair &&
339                 to != address(uniswapV2Router) &&
340                 !_isExcludedFromFee[to] &&
341                 cooldownEnabled
342             ) {
343                 require(cooldown[to] < block.timestamp);
344                 cooldown[to] = block.timestamp + (45 seconds);
345             }
346             uint256 contractTokenBalance = balanceOf(address(this));
347             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
348                 swapTokensForEth(contractTokenBalance);
349                 uint256 contractETHBalance = address(this).balance;
350                 if (contractETHBalance > 0) {
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
364     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
365         address[] memory path = new address[](2);
366         path[0] = address(this);
367         path[1] = uniswapV2Router.WETH();
368         _approve(address(this), address(uniswapV2Router), tokenAmount);
369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             tokenAmount,
371             0,
372             path,
373             address(this),
374             block.timestamp
375         );
376     }
377 
378     function sendETHToFee(uint256 amount) private {
379         _teamAddress.transfer(amount.div(2));
380         _marketingFunds.transfer(amount.div(2));
381     }
382 
383     function startTrading() external onlyOwner() {
384         require(!tradingOpen, "trading is already started");
385         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
386         uniswapV2Router = _uniswapV2Router;
387         _approve(address(this), address(uniswapV2Router), _tTotal);
388         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
389             .createPair(address(this), _uniswapV2Router.WETH());
390         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
391             address(this),
392             balanceOf(address(this)),
393             0,
394             0,
395             owner(),
396             block.timestamp
397         );
398         swapEnabled = true;
399         cooldownEnabled = true;
400         _maxTxAmount = 1000000000 * 10**9;
401         tradingOpen = true;
402         IERC20(uniswapV2Pair).approve(
403             address(uniswapV2Router),
404             type(uint256).max
405         );
406     }
407 
408     function manualswap() external {
409         require(_msgSender() == _teamAddress);
410         uint256 contractBalance = balanceOf(address(this));
411         swapTokensForEth(contractBalance);
412     }
413 
414     function manualsend() external {
415         require(_msgSender() == _teamAddress);
416         uint256 contractETHBalance = address(this).balance;
417         sendETHToFee(contractETHBalance);
418     }
419 
420     function blockBots(address[] memory bots_) public onlyOwner {
421         for (uint256 i = 0; i < bots_.length; i++) {
422             bots[bots_[i]] = true;
423         }
424     }
425 
426     function unblockBot(address notbot) public onlyOwner {
427         bots[notbot] = false;
428     }
429 
430     function _tokenTransfer(
431         address sender,
432         address recipient,
433         uint256 amount,
434         bool takeFee
435     ) private {
436         if (!takeFee) removeAllFee();
437         _transferStandard(sender, recipient, amount);
438         if (!takeFee) restoreAllFee();
439     }
440 
441     function _transferStandard(
442         address sender,
443         address recipient,
444         uint256 tAmount
445     ) private {
446         (
447             uint256 rAmount,
448             uint256 rTransferAmount,
449             uint256 rFee,
450             uint256 tTransferAmount,
451             uint256 tFee,
452             uint256 tTeam
453         ) = _getValues(tAmount);
454         _rOwned[sender] = _rOwned[sender].sub(rAmount);
455         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
456         _takeTeam(tTeam);
457         _reflectFee(rFee, tFee);
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460 
461     function _takeTeam(uint256 tTeam) private {
462         uint256 currentRate = _getRate();
463         uint256 rTeam = tTeam.mul(currentRate);
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466 
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471 
472     receive() external payable {}
473 
474     function _getValues(uint256 tAmount)
475         private
476         view
477         returns (
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256
484         )
485     {
486         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
487             _getTValues(tAmount, _taxFee, _teamFee);
488         uint256 currentRate = _getRate();
489         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
490             _getRValues(tAmount, tFee, tTeam, currentRate);
491         
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494 
495     function _getTValues(
496         uint256 tAmount,
497         uint256 taxFee,
498         uint256 TeamFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(taxFee).div(100);
509         uint256 tTeam = tAmount.mul(TeamFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511 
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
533 
534         return (rAmount, rTransferAmount, rFee);
535     }
536 
537     function _getRate() private view returns (uint256) {
538         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
539 
540         return rSupply.div(tSupply);
541     }
542 
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547 
548         return (rSupply, tSupply);
549     }
550 
551     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
552         require(maxTxPercent > 0, "Amount must be greater than 0");
553         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
554         emit MaxTxAmountUpdated(_maxTxAmount);
555     }
556 }