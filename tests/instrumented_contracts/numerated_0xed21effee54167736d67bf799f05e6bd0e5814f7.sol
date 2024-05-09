1 // DOJIWORLD (DOJI) changes crypto market.
2 //Telegram: https://t.me/dojiworld
3 
4 
5 
6 
7 // SPDX-License-Identifier: Unlicensed
8 
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
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         
101         return c;
102     }
103 
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     function div(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract DOJIWORLD is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158 
159     string private constant _name = "DOJIWORLD";
160     string private constant _symbol = "DOJI \xF0\x9F\x90\xB6";
161     uint8 private constant _decimals = 9;
162 
163     // RFI
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 1000000000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _taxFee = 5;
173     uint256 private _teamFee = 10;
174 
175     // Bot detection
176     mapping(address => bool) private bots;
177     mapping(address => uint256) private cooldown;
178     address payable private _teamAddress;
179     address payable private _marketingFunds;
180     IUniswapV2Router02 private uniswapV2Router;
181     address private uniswapV2Pair;
182     bool private tradingOpen;
183     bool private inSwap = false;
184     bool private swapEnabled = false;
185     bool private cooldownEnabled = false;
186     uint256 private _maxTxAmount = _tTotal;
187 
188     event MaxTxAmountUpdated(uint256 _maxTxAmount);
189     modifier lockTheSwap {
190         inSwap = true;
191         _;
192         inSwap = false;
193     }
194 
195     constructor(address payable addr1, address payable addr2) {
196         _teamAddress = addr1;
197         _marketingFunds = addr2;
198         _rOwned[_msgSender()] = _rTotal;
199         _isExcludedFromFee[owner()] = true;
200         _isExcludedFromFee[address(this)] = true;
201         _isExcludedFromFee[_teamAddress] = true;
202         _isExcludedFromFee[_marketingFunds] = true;
203         emit Transfer(address(0), _msgSender(), _tTotal);
204     }
205 
206     function name() public pure returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public pure returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public pure returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public pure override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return tokenFromReflection(_rOwned[account]);
224     }
225 
226     function transfer(address recipient, uint256 amount)
227         public
228         override
229         returns (bool)
230     {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     function allowance(address owner, address spender)
236         public
237         view
238         override
239         returns (uint256)
240     {
241         return _allowances[owner][spender];
242     }
243 
244     function approve(address spender, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _approve(_msgSender(), spender, amount);
250         return true;
251     }
252 
253     function transferFrom(
254         address sender,
255         address recipient,
256         uint256 amount
257     ) public override returns (bool) {
258         _transfer(sender, recipient, amount);
259         _approve(
260             sender,
261             _msgSender(),
262             _allowances[sender][_msgSender()].sub(
263                 amount,
264                 "ERC20: transfer amount exceeds allowance"
265             )
266         );
267         return true;
268     }
269 
270     function setCooldownEnabled(bool onoff) external onlyOwner() {
271         cooldownEnabled = onoff;
272     }
273 
274     function tokenFromReflection(uint256 rAmount)
275         private
276         view
277         returns (uint256)
278     {
279         require(
280             rAmount <= _rTotal,
281             "Amount must be less than total reflections"
282         );
283         uint256 currentRate = _getRate();
284         return rAmount.div(currentRate);
285     }
286 
287     function removeAllFee() private {
288         if (_taxFee == 0 && _teamFee == 0) return;
289         _taxFee = 0;
290         _teamFee = 0;
291     }
292 
293     function restoreAllFee() private {
294         _taxFee = 5;
295         _teamFee = 10;
296     }
297 
298     function _approve(
299         address owner,
300         address spender,
301         uint256 amount
302     ) private {
303         require(owner != address(0), "ERC20: approve from the zero address");
304         require(spender != address(0), "ERC20: approve to the zero address");
305         _allowances[owner][spender] = amount;
306         emit Approval(owner, spender, amount);
307     }
308 
309     function _transfer(
310         address from,
311         address to,
312         uint256 amount
313     ) private {
314         require(from != address(0), "ERC20: transfer from the zero address");
315         require(to != address(0), "ERC20: transfer to the zero address");
316         require(amount > 0, "Transfer amount must be greater than zero");
317 
318         if (from != owner() && to != owner()) {
319             if (cooldownEnabled) {
320                 if (
321                     from != address(this) &&
322                     to != address(this) &&
323                     from != address(uniswapV2Router) &&
324                     to != address(uniswapV2Router)
325                 ) {
326                     require(
327                         _msgSender() == address(uniswapV2Router) ||
328                             _msgSender() == uniswapV2Pair,
329                         "ERR: Uniswap only"
330                     );
331                 }
332             }
333             require(amount <= _maxTxAmount);
334             require(!bots[from] && !bots[to]);
335             if (
336                 from == uniswapV2Pair &&
337                 to != address(uniswapV2Router) &&
338                 !_isExcludedFromFee[to] &&
339                 cooldownEnabled
340             ) {
341                 require(cooldown[to] < block.timestamp);
342                 cooldown[to] = block.timestamp + (60 seconds);
343             }
344             uint256 contractTokenBalance = balanceOf(address(this));
345             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
346                 swapTokensForEth(contractTokenBalance);
347                 uint256 contractETHBalance = address(this).balance;
348                 if (contractETHBalance > 0) {
349                     sendETHToFee(address(this).balance);
350                 }
351             }
352         }
353         bool takeFee = true;
354 
355         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
356             takeFee = false;
357         }
358 
359         _tokenTransfer(from, to, amount, takeFee);
360     }
361 
362     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
363         address[] memory path = new address[](2);
364         path[0] = address(this);
365         path[1] = uniswapV2Router.WETH();
366         _approve(address(this), address(uniswapV2Router), tokenAmount);
367         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
368             tokenAmount,
369             0,
370             path,
371             address(this),
372             block.timestamp
373         );
374     }
375 
376     function sendETHToFee(uint256 amount) private {
377         _teamAddress.transfer(amount.div(2));
378         _marketingFunds.transfer(amount.div(2));
379     }
380 
381     function startTrading() external onlyOwner() {
382         require(!tradingOpen, "trading is already started");
383         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
384         uniswapV2Router = _uniswapV2Router;
385         _approve(address(this), address(uniswapV2Router), _tTotal);
386         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
387             .createPair(address(this), _uniswapV2Router.WETH());
388         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
389             address(this),
390             balanceOf(address(this)),
391             0,
392             0,
393             owner(),
394             block.timestamp
395         );
396         swapEnabled = true;
397         cooldownEnabled = true;
398         _maxTxAmount = 3000000000 * 10**9;
399         tradingOpen = true;
400         IERC20(uniswapV2Pair).approve(
401             address(uniswapV2Router),
402             type(uint256).max
403         );
404     }
405 
406     function manualswap() external {
407         require(_msgSender() == _teamAddress);
408         uint256 contractBalance = balanceOf(address(this));
409         swapTokensForEth(contractBalance);
410     }
411 
412     function manualsend() external {
413         require(_msgSender() == _teamAddress);
414         uint256 contractETHBalance = address(this).balance;
415         sendETHToFee(contractETHBalance);
416     }
417 
418     function blockBots(address[] memory bots_) public onlyOwner {
419         for (uint256 i = 0; i < bots_.length; i++) {
420             bots[bots_[i]] = true;
421         }
422     }
423 
424     function unblockBot(address notbot) public onlyOwner {
425         bots[notbot] = false;
426     }
427 
428     function _tokenTransfer(
429         address sender,
430         address recipient,
431         uint256 amount,
432         bool takeFee
433     ) private {
434         if (!takeFee) removeAllFee();
435         _transferStandard(sender, recipient, amount);
436         if (!takeFee) restoreAllFee();
437     }
438 
439     function _transferStandard(
440         address sender,
441         address recipient,
442         uint256 tAmount
443     ) private {
444         (
445             uint256 rAmount,
446             uint256 rTransferAmount,
447             uint256 rFee,
448             uint256 tTransferAmount,
449             uint256 tFee,
450             uint256 tTeam
451         ) = _getValues(tAmount);
452         _rOwned[sender] = _rOwned[sender].sub(rAmount);
453         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
454         _takeTeam(tTeam);
455         _reflectFee(rFee, tFee);
456         emit Transfer(sender, recipient, tTransferAmount);
457     }
458 
459     function _takeTeam(uint256 tTeam) private {
460         uint256 currentRate = _getRate();
461         uint256 rTeam = tTeam.mul(currentRate);
462         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
463     }
464 
465     function _reflectFee(uint256 rFee, uint256 tFee) private {
466         _rTotal = _rTotal.sub(rFee);
467         _tFeeTotal = _tFeeTotal.add(tFee);
468     }
469 
470     receive() external payable {}
471 
472     function _getValues(uint256 tAmount)
473         private
474         view
475         returns (
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256
482         )
483     {
484         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
485             _getTValues(tAmount, _taxFee, _teamFee);
486         uint256 currentRate = _getRate();
487         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
488             _getRValues(tAmount, tFee, tTeam, currentRate);
489         
490         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
491     }
492 
493     function _getTValues(
494         uint256 tAmount,
495         uint256 taxFee,
496         uint256 TeamFee
497     )
498         private
499         pure
500         returns (
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         uint256 tFee = tAmount.mul(taxFee).div(100);
507         uint256 tTeam = tAmount.mul(TeamFee).div(100);
508         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
509 
510         return (tTransferAmount, tFee, tTeam);
511     }
512 
513     function _getRValues(
514         uint256 tAmount,
515         uint256 tFee,
516         uint256 tTeam,
517         uint256 currentRate
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 rAmount = tAmount.mul(currentRate);
528         uint256 rFee = tFee.mul(currentRate);
529         uint256 rTeam = tTeam.mul(currentRate);
530         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
531 
532         return (rAmount, rTransferAmount, rFee);
533     }
534 
535     function _getRate() private view returns (uint256) {
536         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
537 
538         return rSupply.div(tSupply);
539     }
540 
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545 
546         return (rSupply, tSupply);
547     }
548 
549     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
550         require(maxTxPercent > 0, "Amount must be greater than 0");
551         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
552         emit MaxTxAmountUpdated(_maxTxAmount);
553     }
554 }