1 /*
2  /$$   /$$               /$$   /$$
3 | $$  | $$              | $$  | $$
4 | $$  | $$ /$$  /$$  /$$| $$  | $$
5 | $$  | $$| $$ | $$ | $$| $$  | $$
6 | $$  | $$| $$ | $$ | $$| $$  | $$
7 | $$  | $$| $$ | $$ | $$| $$  | $$
8 |  $$$$$$/|  $$$$$/$$$$/|  $$$$$$/
9  \______/  \_____/\___/  \______/ 
10 
11 
12 WEBSITE - https://uwueth.lol/
13 TELEGRAM - https://t.me/UwUeth
14 TWITTER - https://twitter.com/uwuERC_20
15 
16 */
17 
18 // SPDX-License-Identifier: UNLICENSED
19 pragma solidity ^0.8.4;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address account) external view returns (uint256);
31 
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54     address private _previousOwner;
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 
86 }
87 
88 library SafeMath {
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106         return c;
107     }
108 
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         return c;
130     }
131 }
132 
133 interface IUniswapV2Factory {
134     function createPair(address tokenA, address tokenB)
135         external
136         returns (address pair);
137 }
138 
139 interface IUniswapV2Router02 {
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint256 amountIn,
142         uint256 amountOutMin,
143         address[] calldata path,
144         address to,
145         uint256 deadline
146     ) external;
147 
148     function factory() external pure returns (address);
149 
150     function WETH() external pure returns (address);
151 
152     function addLiquidityETH(
153         address token,
154         uint256 amountTokenDesired,
155         uint256 amountTokenMin,
156         uint256 amountETHMin,
157         address to,
158         uint256 deadline
159     )
160         external
161         payable
162         returns (
163             uint256 amountToken,
164             uint256 amountETH,
165             uint256 liquidity
166         );
167 }
168 
169 contract uwu is Context, IERC20, Ownable {
170 
171     using SafeMath for uint256;
172     string private constant _name = unicode"UwU Coin";
173     string private constant _symbol = unicode"UwU";
174     uint8 private constant _decimals = 9;
175 
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181     uint256 private constant _tTotal = 69000000 * 10**9;
182     uint256 private _rTotal = (MAX - (MAX % _tTotal));
183     uint256 private _tFeeTotal;
184 
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190 
191     uint256 private _redisFeeOnBuy = 0;
192     uint256 private _taxFeeOnBuy = 19;
193 
194     uint256 private _redisFeeOnSell = 0;
195     uint256 private _taxFeeOnSell = 69;
196 
197     mapping(address => uint256) private cooldown;
198     mapping(address => bool) public bots;
199 
200     address payable private _developmentAddress = payable(0x1E774D0333f2c35FbBA4574e35bC78c8998B6b60);
201 
202     IUniswapV2Router02 public uniswapV2Router;
203     address public uniswapV2Pair;
204     
205     uint256 public _maxTxAmount = 1166100 * 10**9;         //1.69%
206     uint256 public _maxWalletSize = 1166100 * 10**9;       //1.69%
207     uint256 public _swapTokensAtAmount = 2760000 * 10**9;  //4%
208 
209     bool private tradingOpen;
210     bool private inSwap = false;
211     bool private swapEnabled = true;
212 
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219 
220     constructor() {
221         _rOwned[_msgSender()] = _rTotal;
222 
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227 
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_developmentAddress] = true;
231 
232         emit Transfer(address(0), _msgSender(), _tTotal);
233     }
234 
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246 
247     function symbol() public pure returns (string memory) {
248         return _symbol;
249     }
250 
251     function decimals() public pure returns (uint8) {
252         return _decimals;
253     }
254 
255     function transfer(address recipient, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263 
264     function allowance(address owner, address spender)
265         public
266         view
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272 
273     function approve(address spender, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(
289             sender,
290             _msgSender(),
291             _allowances[sender][_msgSender()].sub(
292                 amount,
293                 "ERC20: transfer amount exceeds allowance"
294             )
295         );
296         return true;
297     }
298 
299     function tokenFromReflection(uint256 rAmount)
300         private
301         view
302         returns (uint256)
303     {
304         require(
305             rAmount <= _rTotal,
306             "Amount must be less than total reflections"
307         );
308         uint256 currentRate = _getRate();
309         return rAmount.div(currentRate);
310     }
311 
312     function removeAllFee() private {
313         if (_redisFee == 0 && _taxFee == 0) return;
314 
315         _previousredisFee = _redisFee;
316         _previoustaxFee = _taxFee;
317 
318         _redisFee = 0;
319         _taxFee = 0;
320     }
321 
322     function restoreAllFee() private {
323         _redisFee = _previousredisFee;
324         _taxFee = _previoustaxFee;
325     }
326 
327     function _approve(
328         address owner,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337 
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) private {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345         require(amount > 0, "Transfer amount must be greater than zero");
346 
347         if (from != owner() && to != owner()) {
348 
349             if (!tradingOpen) {
350                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
351             }
352 
353             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
354             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
355 
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359 
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362 
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367 
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376 
377         bool takeFee = true;
378 
379         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
380             takeFee = false;
381         } else {
382 
383             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392         }
393         _tokenTransfer(from, to, amount, takeFee);
394     }
395 
396     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
397         address[] memory path = new address[](2);
398         path[0] = address(this);
399         path[1] = uniswapV2Router.WETH();
400         _approve(address(this), address(uniswapV2Router), tokenAmount);
401         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
402             tokenAmount,
403             0,
404             path,
405             address(this),
406             block.timestamp
407         );
408     }
409 
410     function sendETHToFee(uint256 amount) private {
411         _developmentAddress.transfer(amount);
412     }
413 
414     function openTrade() public onlyOwner {
415         tradingOpen = true;
416     }
417 
418     function manualswap() external {
419         require(_msgSender() == _developmentAddress);
420         uint256 contractBalance = balanceOf(address(this));
421         swapTokensForEth(contractBalance);
422     }
423 
424     function manualsend() external {
425         require(_msgSender() == _developmentAddress);
426         uint256 contractETHBalance = address(this).balance;
427         sendETHToFee(contractETHBalance);
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
487             _getTValues(tAmount, _redisFee, _taxFee);
488         uint256 currentRate = _getRate();
489         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
490             _getRValues(tAmount, tFee, tTeam, currentRate);
491 
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494 
495     function _getTValues(
496         uint256 tAmount,
497         uint256 redisFee,
498         uint256 taxFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(redisFee).div(100);
509         uint256 tTeam = tAmount.mul(taxFee).div(100);
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
551     function reduceFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) external{
552         require(_msgSender()==_developmentAddress);
553         require(taxFeeOnBuy<=_taxFeeOnBuy && taxFeeOnSell<=_taxFeeOnSell);
554         _taxFeeOnBuy=taxFeeOnBuy;
555         _taxFeeOnSell=taxFeeOnSell;
556         //Fees can only be reduced not increased
557     }
558 
559     function removeLimits() public onlyOwner{
560         _maxWalletSize = _tTotal;
561         _maxTxAmount = _tTotal;
562     }
563 
564 }