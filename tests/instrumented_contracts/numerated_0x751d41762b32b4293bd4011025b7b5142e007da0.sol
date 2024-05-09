1 //Noodles Inu ($NoodlesInu)
2 
3 // Limit Buy
4 // Cooldown
5 
6 //TG: https://t.me/noodlesinu
7 //Twitter: https://twitter.com/criptopaulinu
8 //Website: https://noodlesinu.com/
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity ^0.8.4;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
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
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(
62         uint256 a,
63         uint256 b,
64         string memory errorMessage
65     ) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         return c;
92     }
93 }
94 
95 contract Ownable is Context {
96     address private _owner;
97     address private _previousOwner;
98     event OwnershipTransferred(
99         address indexed previousOwner,
100         address indexed newOwner
101     );
102 
103     constructor() {
104         address msgSender = _msgSender();
105         _owner = msgSender;
106         emit OwnershipTransferred(address(0), msgSender);
107     }
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
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
160 contract NoodlesInu is Context, IERC20, Ownable {
161     using SafeMath for uint256;
162 
163     string private constant _name = "Noodles Inu";
164     string private constant _symbol = "NoodlesInu";
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
298         _teamFee = 12;
299         _taxFee = 5;
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
346                 cooldown[to] = block.timestamp + (2 minutes);
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
385     function openTrading() external onlyOwner() {
386         require(!tradingOpen, "trading is already open");
387         IUniswapV2Router02 _uniswapV2Router =
388             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
389         uniswapV2Router = _uniswapV2Router;
390         _approve(address(this), address(uniswapV2Router), _tTotal);
391         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
392             .createPair(address(this), _uniswapV2Router.WETH());
393         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
394             address(this),
395             balanceOf(address(this)),
396             0,
397             0,
398             owner(),
399             block.timestamp
400         );
401         swapEnabled = true;
402         cooldownEnabled = true;
403         _maxTxAmount = 5000000000 * 10**9;
404         tradingOpen = true;
405         IERC20(uniswapV2Pair).approve(
406             address(uniswapV2Router),
407             type(uint256).max
408         );
409     }
410 
411     function manualswap() external {
412         require(_msgSender() == _teamAddress);
413         uint256 contractBalance = balanceOf(address(this));
414         swapTokensForEth(contractBalance);
415     }
416 
417     function manualsend() external {
418         require(_msgSender() == _teamAddress);
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422 
423     function setBots(address[] memory bots_) public onlyOwner {
424         for (uint256 i = 0; i < bots_.length; i++) {
425             bots[bots_[i]] = true;
426         }
427     }
428 
429     function delBot(address notbot) public onlyOwner {
430         bots[notbot] = false;
431     }
432 
433     function _tokenTransfer(
434         address sender,
435         address recipient,
436         uint256 amount,
437         bool takeFee
438     ) private {
439         if (!takeFee) removeAllFee();
440         _transferStandard(sender, recipient, amount);
441         if (!takeFee) restoreAllFee();
442     }
443 
444     function _transferStandard(
445         address sender,
446         address recipient,
447         uint256 tAmount
448     ) private {
449         (
450             uint256 rAmount,
451             uint256 rTransferAmount,
452             uint256 rFee,
453             uint256 tTransferAmount,
454             uint256 tFee,
455             uint256 tTeam
456         ) = _getValues(tAmount);
457         _rOwned[sender] = _rOwned[sender].sub(rAmount);
458         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
459         _takeTeam(tTeam);
460         _reflectFee(rFee, tFee);
461         emit Transfer(sender, recipient, tTransferAmount);
462     }
463 
464     function _takeTeam(uint256 tTeam) private {
465         uint256 currentRate = _getRate();
466         uint256 rTeam = tTeam.mul(currentRate);
467         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
468     }
469 
470     function _reflectFee(uint256 rFee, uint256 tFee) private {
471         _rTotal = _rTotal.sub(rFee);
472         _tFeeTotal = _tFeeTotal.add(tFee);
473     }
474 
475     receive() external payable {}
476 
477     function _getValues(uint256 tAmount)
478         private
479         view
480         returns (
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256
487         )
488     {
489         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
490             _getTValues(tAmount, _taxFee, _teamFee);
491         uint256 currentRate = _getRate();
492         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
493             _getRValues(tAmount, tFee, tTeam, currentRate);
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
513         return (tTransferAmount, tFee, tTeam);
514     }
515 
516     function _getRValues(
517         uint256 tAmount,
518         uint256 tFee,
519         uint256 tTeam,
520         uint256 currentRate
521     )
522         private
523         pure
524         returns (
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         uint256 rAmount = tAmount.mul(currentRate);
531         uint256 rFee = tFee.mul(currentRate);
532         uint256 rTeam = tTeam.mul(currentRate);
533         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
534         return (rAmount, rTransferAmount, rFee);
535     }
536 
537     function _getRate() private view returns (uint256) {
538         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
539         return rSupply.div(tSupply);
540     }
541 
542     function _getCurrentSupply() private view returns (uint256, uint256) {
543         uint256 rSupply = _rTotal;
544         uint256 tSupply = _tTotal;
545         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
546         return (rSupply, tSupply);
547     }
548 
549     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
550         require(maxTxPercent > 0, "Amount must be greater than 0");
551         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
552         emit MaxTxAmountUpdated(_maxTxAmount);
553     }
554 }