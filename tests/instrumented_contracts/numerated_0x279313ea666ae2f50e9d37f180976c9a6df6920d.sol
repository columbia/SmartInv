1 /*
2 EternalUp
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     function allowance(address owner, address spender)
24         external
25         view
26         returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(
56         uint256 a,
57         uint256 b,
58         string memory errorMessage
59     ) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(
79         uint256 a,
80         uint256 b,
81         string memory errorMessage
82     ) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         return c;
86     }
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     address private _previousOwner;
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     constructor() {
98         address msgSender = _msgSender();
99         _owner = msgSender;
100         emit OwnershipTransferred(address(0), msgSender);
101     }
102 
103     function owner() public view returns (address) {
104         return _owner;
105     }
106 
107     modifier onlyOwner() {
108         require(_owner == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     function renounceOwnership() public virtual onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 }
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132 
133     function factory() external pure returns (address);
134 
135     function WETH() external pure returns (address);
136 
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153 
154 contract EternalUp is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156 
157     string private constant _name = "EternalUp";
158     string private constant _symbol = "EternalUp";
159     uint8 private constant _decimals = 9;
160 
161     // RFI
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 1000000000000 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170     uint256 private _taxFee = 5;
171     uint256 private _teamFee = 30;
172 
173     // Bot detection
174     mapping(address => bool) private bots;
175     mapping(address => uint256) private cooldown;
176     address payable private _teamAddress;
177     address payable private _marketingFunds;
178     IUniswapV2Router02 private uniswapV2Router;
179     address private uniswapV2Pair;
180     bool private tradingOpen;
181     bool private inSwap = false;
182     bool private swapEnabled = false;
183     bool private cooldownEnabled = false;
184     uint256 private _maxTxAmount = _tTotal;
185 
186     event MaxTxAmountUpdated(uint256 _maxTxAmount);
187     modifier lockTheSwap {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193     constructor(address payable addr1, address payable addr2) {
194         _teamAddress = addr1;
195         _marketingFunds = addr2;
196         _rOwned[_msgSender()] = _rTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_teamAddress] = true;
200         _isExcludedFromFee[_marketingFunds] = true;
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return tokenFromReflection(_rOwned[account]);
222     }
223 
224     function transfer(address recipient, uint256 amount)
225         public
226         override
227         returns (bool)
228     {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender)
234         public
235         view
236         override
237         returns (uint256)
238     {
239         return _allowances[owner][spender];
240     }
241 
242     function approve(address spender, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(
252         address sender,
253         address recipient,
254         uint256 amount
255     ) public override returns (bool) {
256         _transfer(sender, recipient, amount);
257         _approve(
258             sender,
259             _msgSender(),
260             _allowances[sender][_msgSender()].sub(
261                 amount,
262                 "ERC20: transfer amount exceeds allowance"
263             )
264         );
265         return true;
266     }
267 
268     function setCooldownEnabled(bool onoff) external onlyOwner() {
269         cooldownEnabled = onoff;
270     }
271 
272     function tokenFromReflection(uint256 rAmount)
273         private
274         view
275         returns (uint256)
276     {
277         require(
278             rAmount <= _rTotal,
279             "Amount must be less than total reflections"
280         );
281         uint256 currentRate = _getRate();
282         return rAmount.div(currentRate);
283     }
284 
285     function removeAllFee() private {
286         if (_taxFee == 0 && _teamFee == 0) return;
287         _taxFee = 0;
288         _teamFee = 0;
289     }
290 
291     function restoreAllFee() private {
292         _taxFee = 5;
293         _teamFee = 30;
294     }
295 
296     function _approve(
297         address owner,
298         address spender,
299         uint256 amount
300     ) private {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303         _allowances[owner][spender] = amount;
304         emit Approval(owner, spender, amount);
305     }
306 
307     function _transfer(
308         address from,
309         address to,
310         uint256 amount
311     ) private {
312         require(from != address(0), "ERC20: transfer from the zero address");
313         require(to != address(0), "ERC20: transfer to the zero address");
314         require(amount > 0, "Transfer amount must be greater than zero");
315 
316         if (from != owner() && to != owner()) {
317             if (cooldownEnabled) {
318                 if (
319                     from != address(this) &&
320                     to != address(this) &&
321                     from != address(uniswapV2Router) &&
322                     to != address(uniswapV2Router)
323                 ) {
324                     require(
325                         _msgSender() == address(uniswapV2Router) ||
326                             _msgSender() == uniswapV2Pair,
327                         "ERR: Uniswap only"
328                     );
329                 }
330             }
331             require(amount <= _maxTxAmount);
332             require(!bots[from] && !bots[to]);
333             if (
334                 from == uniswapV2Pair &&
335                 to != address(uniswapV2Router) &&
336                 !_isExcludedFromFee[to] &&
337                 cooldownEnabled
338             ) {
339                 require(cooldown[to] < block.timestamp);
340                 cooldown[to] = block.timestamp + (60 seconds);
341             }
342             uint256 contractTokenBalance = balanceOf(address(this));
343             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
344                 swapTokensForEth(contractTokenBalance);
345                 uint256 contractETHBalance = address(this).balance;
346                 if (contractETHBalance > 0) {
347                     sendETHToFee(address(this).balance);
348                 }
349             }
350         }
351         bool takeFee = true;
352 
353         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
354             takeFee = false;
355         }
356 
357         _tokenTransfer(from, to, amount, takeFee);
358     }
359 
360     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
361         address[] memory path = new address[](2);
362         path[0] = address(this);
363         path[1] = uniswapV2Router.WETH();
364         _approve(address(this), address(uniswapV2Router), tokenAmount);
365         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
366             tokenAmount,
367             0,
368             path,
369             address(this),
370             block.timestamp
371         );
372     }
373 
374     function sendETHToFee(uint256 amount) private {
375         _teamAddress.transfer(amount.div(2));
376         _marketingFunds.transfer(amount.div(2));
377     }
378 
379     function openTrading() external onlyOwner() {
380         require(!tradingOpen, "trading is already open");
381         IUniswapV2Router02 _uniswapV2Router =
382             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
383         uniswapV2Router = _uniswapV2Router;
384         _approve(address(this), address(uniswapV2Router), _tTotal);
385         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
386             .createPair(address(this), _uniswapV2Router.WETH());
387         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
388             address(this),
389             balanceOf(address(this)),
390             0,
391             0,
392             owner(),
393             block.timestamp
394         );
395         swapEnabled = true;
396         cooldownEnabled = true;
397         _maxTxAmount = 2500000000 * 10**9;
398         tradingOpen = true;
399         IERC20(uniswapV2Pair).approve(
400             address(uniswapV2Router),
401             type(uint256).max
402         );
403     }
404 
405     function manualswap() external {
406         require(_msgSender() == _teamAddress);
407         uint256 contractBalance = balanceOf(address(this));
408         swapTokensForEth(contractBalance);
409     }
410 
411     function manualsend() external {
412         require(_msgSender() == _teamAddress);
413         uint256 contractETHBalance = address(this).balance;
414         sendETHToFee(contractETHBalance);
415     }
416 
417     function setBots(address[] memory bots_) public onlyOwner {
418         for (uint256 i = 0; i < bots_.length; i++) {
419             bots[bots_[i]] = true;
420         }
421     }
422 
423     function delBot(address notbot) public onlyOwner {
424         bots[notbot] = false;
425     }
426 
427     function _tokenTransfer(
428         address sender,
429         address recipient,
430         uint256 amount,
431         bool takeFee
432     ) private {
433         if (!takeFee) removeAllFee();
434         _transferStandard(sender, recipient, amount);
435         if (!takeFee) restoreAllFee();
436     }
437 
438     function _transferStandard(
439         address sender,
440         address recipient,
441         uint256 tAmount
442     ) private {
443         (
444             uint256 rAmount,
445             uint256 rTransferAmount,
446             uint256 rFee,
447             uint256 tTransferAmount,
448             uint256 tFee,
449             uint256 tTeam
450         ) = _getValues(tAmount);
451         _rOwned[sender] = _rOwned[sender].sub(rAmount);
452         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
453         _takeTeam(tTeam);
454         _reflectFee(rFee, tFee);
455         emit Transfer(sender, recipient, tTransferAmount);
456     }
457 
458     function _takeTeam(uint256 tTeam) private {
459         uint256 currentRate = _getRate();
460         uint256 rTeam = tTeam.mul(currentRate);
461         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
462     }
463 
464     function _reflectFee(uint256 rFee, uint256 tFee) private {
465         _rTotal = _rTotal.sub(rFee);
466         _tFeeTotal = _tFeeTotal.add(tFee);
467     }
468 
469     receive() external payable {}
470 
471     function _getValues(uint256 tAmount)
472         private
473         view
474         returns (
475             uint256,
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256
481         )
482     {
483         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
484             _getTValues(tAmount, _taxFee, _teamFee);
485         uint256 currentRate = _getRate();
486         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
487             _getRValues(tAmount, tFee, tTeam, currentRate);
488         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
489     }
490 
491     function _getTValues(
492         uint256 tAmount,
493         uint256 taxFee,
494         uint256 TeamFee
495     )
496         private
497         pure
498         returns (
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         uint256 tFee = tAmount.mul(taxFee).div(100);
505         uint256 tTeam = tAmount.mul(TeamFee).div(100);
506         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
507         return (tTransferAmount, tFee, tTeam);
508     }
509 
510     function _getRValues(
511         uint256 tAmount,
512         uint256 tFee,
513         uint256 tTeam,
514         uint256 currentRate
515     )
516         private
517         pure
518         returns (
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         uint256 rAmount = tAmount.mul(currentRate);
525         uint256 rFee = tFee.mul(currentRate);
526         uint256 rTeam = tTeam.mul(currentRate);
527         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
528         return (rAmount, rTransferAmount, rFee);
529     }
530 
531     function _getRate() private view returns (uint256) {
532         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
533         return rSupply.div(tSupply);
534     }
535 
536     function _getCurrentSupply() private view returns (uint256, uint256) {
537         uint256 rSupply = _rTotal;
538         uint256 tSupply = _tTotal;
539         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
540         return (rSupply, tSupply);
541     }
542 
543     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
544         require(maxTxPercent > 0, "Amount must be greater than 0");
545         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
546         emit MaxTxAmountUpdated(_maxTxAmount);
547     }
548 }