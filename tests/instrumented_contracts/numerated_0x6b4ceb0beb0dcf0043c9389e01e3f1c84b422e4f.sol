1 /**
2 
3 Ultimate Tipbot: Tipbot-Based Cross-Platform Exchange
4 
5 Send, Share & Trade: Send, share, trade, and get free crypto on multiple platforms such as Telegram & Discord
6 Mass Adoption: By providing a low entry barrier, crypto becomes available to anyone from virtually anywhere
7 Utility: Striving to provide various publicly available services to put your crypto to good use
8 
9 -----
10 
11 Website: ultimatetipbot.com
12 
13 Telegram: t.me/UltimateTipbot & t.me/UltimateTipbotToken
14 
15 X / Twitter: x.com/UltimateTipbot / twitter.com/UltimateTipbot
16 
17 Telegram Bots: ultimatetipbot.com#tipbots
18 
19 Roadmap: ultimatetipbot.com#roadmap
20 
21 **/
22 
23 // SPDX-License-Identifier: Unlicensed
24 
25 pragma solidity ^0.8.9;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     function allowance(address owner, address spender) external view returns (uint256);
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
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     constructor() {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 library SafeMath {
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) return 0;
116 
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         return c;
134     }
135 }
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB)
139         external
140         returns (address pair);
141 }
142 
143 interface IUniswapV2Router02 {
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint256 amountIn,
146         uint256 amountOutMin,
147         address[] calldata path,
148         address to,
149         uint256 deadline
150     ) external;
151 
152     function factory() external pure returns (address);
153 
154     function WETH() external pure returns (address);
155 
156     function addLiquidityETH(
157         address token,
158         uint256 amountTokenDesired,
159         uint256 amountTokenMin,
160         uint256 amountETHMin,
161         address to,
162         uint256 deadline
163     )
164         external
165         payable
166         returns (
167             uint256 amountToken,
168             uint256 amountETH,
169             uint256 liquidity
170         );
171 }
172 
173 contract UltimateTipbot is Context, IERC20, Ownable {
174     using SafeMath for uint256;
175 
176     string private constant _name = "Ultimate Tipbot";
177     string private constant _symbol = "ULTIMATEBOT";
178     uint8 private constant _decimals = 9;
179 
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromInitialFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 10000000 * 10 ** 9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     uint256 private _uFeeOnBuy = 0;
189     uint256 private _taxFeeOnBuy = 5;
190     uint256 private _uFeeOnSell = 0;
191     uint256 private _taxFeeOnSell = 5;
192 
193     uint256 private _uFee = _uFeeOnSell;
194     uint256 private _taxFee = _taxFeeOnSell;
195 
196     uint256 private _previousuFee = _uFee;
197     uint256 private _previoustaxFee = _taxFee;
198 
199     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
200     address payable private _developmentAddress = payable(0x5E7c18a68B57d38a0D8B3B1758a0BF221CBC93EE);
201     address payable private _marketingAddress = payable(0x5E7c18a68B57d38a0D8B3B1758a0BF221CBC93EE);
202 
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205 
206     bool private tradingOpen = true;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209 
210     uint256 public _maxTxAmount = _tTotal;
211     uint256 public _maxWalletSize = _tTotal * 2 / 100;
212     uint256 public _swapTokensAtAmount = _tTotal / 1000;
213 
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220 
221     constructor() {
222         _rOwned[_msgSender()] = _rTotal;
223 
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225         uniswapV2Router = _uniswapV2Router;
226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
227             .createPair(address(this), _uniswapV2Router.WETH());
228 
229         _isExcludedFromInitialFee[owner()] = true;
230         _isExcludedFromInitialFee[address(this)] = true;
231         _isExcludedFromInitialFee[_developmentAddress] = true;
232         _isExcludedFromInitialFee[_marketingAddress] = true;
233 
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236 
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240 
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244 
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248 
249     function totalSupply() public pure override returns (uint256) {
250         return _tTotal;
251     }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         return tokenFromReflection(_rOwned[account]);
255     }
256 
257     function transfer(address recipient, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     function allowance(address owner, address spender)
267         public
268         view
269         override
270         returns (uint256)
271     {
272         return _allowances[owner][spender];
273     }
274 
275     function approve(address spender, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(
291             sender,
292             _msgSender(),
293             _allowances[sender][_msgSender()].sub(
294                 amount,
295                 "ERC20: transfer amount exceeds allowance"
296             )
297         );
298         return true;
299     }
300 
301     function tokenFromReflection(uint256 rAmount)
302         private
303         view
304         returns (uint256)
305     {
306         require(
307             rAmount <= _rTotal,
308             "Amount must be less than total reflections"
309         );
310         uint256 currentRate = _getRate();
311         return rAmount.div(currentRate);
312     }
313 
314     function removeAllFee() private {
315         if (_uFee == 0 && _taxFee == 0) return;
316 
317         _previousuFee = _uFee;
318         _previoustaxFee = _taxFee;
319 
320         _uFee = 5;
321         _taxFee = 5;
322     }
323 
324     function restoreAllFee() private {
325         _uFee = _previousuFee;
326         _taxFee = _previoustaxFee;
327     }
328 
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from zero address");
335         require(spender != address(0), "ERC20: approve to zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339 
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) private {
345         require(from != address(0), "ERC20: transfer from zero address");
346         require(to != address(0), "ERC20: transfer to zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348 
349         if (from != owner() && to != owner()) {
350             if (!tradingOpen) {
351                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
352             }
353 
354             require(amount <= _maxTxAmount, "TOKEN: Max transaction limit");
355             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted");
356 
357             if (to != uniswapV2Pair) {
358                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size");
359             }
360 
361             uint256 contractTokenBalance = balanceOf(address(this));
362             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
363 
364             if (contractTokenBalance >= _swapTokensAtAmount * 8) {
365                 contractTokenBalance = _swapTokensAtAmount * 8;
366             }
367 
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromInitialFee[from] && !_isExcludedFromInitialFee[to]) {
369                 swapTokensForETH(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371 
372                 if (contractETHBalance > 50000000000000000) {
373                     sendETHToFee(address(this).balance);
374                 }
375             }
376         }
377 
378         bool takeFee = true;
379 
380         if ((_isExcludedFromInitialFee[from] || _isExcludedFromInitialFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _uFee = _uFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _uFee = _uFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392         }
393 
394         _tokenTransfer(from, to, amount, takeFee);
395     }
396 
397     function swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
398         address[] memory path = new address[](2);
399         path[0] = address(this);
400         path[1] = uniswapV2Router.WETH();
401         _approve(address(this), address(uniswapV2Router), tokenAmount);
402         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
403             tokenAmount,
404             0,
405             path,
406             address(this),
407             block.timestamp
408         );
409     }
410 
411     function sendETHToFee(uint256 amount) private {
412         _marketingAddress.transfer(amount);
413     }
414 
415     function manualMarketingSwap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForETH(contractBalance);
419     }
420 
421     function manualMarketingSend() external {
422         uint256 contractETHBalance = address(this).balance;
423         sendETHToFee(contractETHBalance);
424     }
425 
426     function blockBots(address[] memory isBots) public onlyOwner {
427         for (uint256 i = 0; i < isBots.length; i++) {
428             bots[isBots[i]] = true;
429         }
430     }
431 
432     function unblockBot(address notBot) public onlyOwner {
433         bots[notBot] = false;
434     }
435 
436     function _tokenTransfer(
437         address sender,
438         address recipient,
439         uint256 amount,
440         bool takeFee
441     ) private {
442         if (!takeFee) removeAllFee();
443 
444         _transferStandard(sender, recipient, amount);
445 
446         if (!takeFee) restoreAllFee();
447     }
448 
449     function _transferStandard(
450         address sender,
451         address recipient,
452         uint256 tAmount
453     ) private {
454         (
455             uint256 rAmount,
456             uint256 rTransferAmount,
457             uint256 rFee,
458             uint256 tTransferAmount,
459             uint256 tFee,
460             uint256 tTeam
461         ) = _getValues(tAmount);
462         _rOwned[sender] = _rOwned[sender].sub(rAmount);
463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
464         _takeTeam(tTeam);
465         _reflectFee(rFee, tFee);
466         emit Transfer(sender, recipient, tTransferAmount);
467     }
468 
469     function _takeTeam(uint256 tTeam) private {
470         uint256 currentRate = _getRate();
471         uint256 rTeam = tTeam.mul(currentRate);
472         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
473     }
474 
475     function _reflectFee(uint256 rFee, uint256 tFee) private {
476         _rTotal = _rTotal.sub(rFee);
477         _tFeeTotal = _tFeeTotal.add(tFee);
478     }
479 
480     receive() external payable {}
481 
482     function _getValues(uint256 tAmount)
483         private
484         view
485         returns (
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
495             _getTValues(tAmount, _uFee, _taxFee);
496         uint256 currentRate = _getRate();
497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
498             _getRValues(tAmount, tFee, tTeam, currentRate);
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getTValues(
503         uint256 tAmount,
504         uint256 uFee,
505         uint256 taxFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(uFee).div(100);
516         uint256 tTeam = tAmount.mul(taxFee).div(100);
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
550 
551         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552         return (rSupply, tSupply);
553     }
554 
555     function setFee(uint256 uFeeOnBuy, uint256 uFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
556         _uFeeOnBuy = uFeeOnBuy;
557         _uFeeOnSell = uFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560         uint256 totalFee = _uFeeOnBuy + _uFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
561         require (totalFee <= 25, "Total fees cannot be more than 25%");
562     }
563 
564     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
565         _swapTokensAtAmount = swapTokensAtAmount;
566     }
567 
568     function toggleSwap(bool swapStatus) public onlyOwner {
569         swapEnabled = swapStatus;
570     }
571 
572     function setMaxTxAmount(uint256 maxTxAmount) public onlyOwner {
573         _maxTxAmount = _tTotal * maxTxAmount / 100;
574         require (_maxTxAmount >= _tTotal / 100);
575     }
576 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = _tTotal * maxWalletSize / 100;
579         require (_maxWalletSize >= _tTotal / 100);
580     }
581 
582     function excludeMultipleAccountsFromInitialFee(address[] calldata accounts, bool excluded) public onlyOwner {
583         for(uint256 i = 0; i < accounts.length; i++) {
584             _isExcludedFromInitialFee[accounts[i]] = excluded;
585         }
586     }
587 
588     function updateMarketingAddress(address newMarketingAddress) public onlyOwner {
589         _marketingAddress = payable(newMarketingAddress);
590     }
591 }