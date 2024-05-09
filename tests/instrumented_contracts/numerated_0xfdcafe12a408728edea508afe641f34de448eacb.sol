1 /*
2 
3 Bobs
4 
5 Tg- https://t.me/BobsVerify
6 
7 
8 ───────█────────────────────────███▓
9 ────█──██──────────────────────███▓
10 ─────██████───────────────────███▓
11 ──────███████────────────────███▓
12 ───── █◉██████───────────────██▓
13 ────██████████───────────────██▓
14 ────██████████────────────────██▓
15 ─────█████████──────────█████████
16 ─────────██████─────██████████████
17 ─────────██████████████████████████
18 ─────────██████████████████████████
19 ─────────██████████████████████████
20 ─────────██████████████████████████
21 ──────────████████████▓▓▓▓█████████
22 ──────────███████▓▓▓▓▓────▓████████
23 ─────────█████▓▓▓──────────▓████████
24 ─────────███▓▓██────────────▓▓██████
25 ────────███▓─███─────────────█▓▓▓████
26 ────────███──███─────────────███──███
27 ───────███────██─────────────███───██
28 ───────██─────███────────────██────██
29 ──────███──────██───────────███────██
30 ─────███───────██───────────██─────██
31 ─────██─────────██─────────██──────██
32 ────███─────────██────────███──────██
33 ─彡███────────彡███──────彡███────彡███
34 
35 
36 
37 */
38 
39 
40 
41 // SPDX-License-Identifier: Unlicensed
42 pragma solidity ^0.8.9;
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(
69         address indexed owner,
70         address indexed spender,
71         uint256 value
72     );
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(
79         address indexed previousOwner,
80         address indexed newOwner
81     );
82 
83     constructor() {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 
109 }
110 
111 library SafeMath {
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115         return c;
116     }
117 
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     function sub(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129         return c;
130     }
131 
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         if (a == 0) {
134             return 0;
135         }
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138         return c;
139     }
140 
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return div(a, b, "SafeMath: division by zero");
143     }
144 
145     function div(
146         uint256 a,
147         uint256 b,
148         string memory errorMessage
149     ) internal pure returns (uint256) {
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         return c;
153     }
154 }
155 
156 interface IUniswapV2Factory {
157     function createPair(address tokenA, address tokenB)
158         external
159         returns (address pair);
160 }
161 
162 interface IUniswapV2Router02 {
163     function swapExactTokensForETHSupportingFeeOnTransferTokens(
164         uint256 amountIn,
165         uint256 amountOutMin,
166         address[] calldata path,
167         address to,
168         uint256 deadline
169     ) external;
170 
171     function factory() external pure returns (address);
172 
173     function WETH() external pure returns (address);
174 
175     function addLiquidityETH(
176         address token,
177         uint256 amountTokenDesired,
178         uint256 amountTokenMin,
179         uint256 amountETHMin,
180         address to,
181         uint256 deadline
182     )
183         external
184         payable
185         returns (
186             uint256 amountToken,
187             uint256 amountETH,
188             uint256 liquidity
189         );
190 }
191 
192 contract Bobs is Context, IERC20, Ownable {
193 
194     using SafeMath for uint256;
195 
196     string private constant _name = "Bobs";
197     string private constant _symbol = unicode"BOBS";
198     uint8 private constant _decimals = 9;
199 
200     mapping(address => uint256) private _rOwned;
201     mapping(address => uint256) private _tOwned;
202     mapping(address => mapping(address => uint256)) private _allowances;
203     mapping(address => bool) private _isExcludedFromFee;
204     uint256 private constant MAX = ~uint256(0);
205     uint256 private constant _tTotal = 10000000 * 10**9;
206     uint256 private _rTotal = (MAX - (MAX % _tTotal));
207     uint256 private _tFeeTotal;
208 
209     // Taxes
210     uint256 private _redisFeeOnBuy = 0;
211     uint256 private _taxFeeOnBuy = 0;
212     uint256 private _redisFeeOnSell = 0;
213     uint256 private _taxFeeOnSell = 0;
214 
215     //Original Fee
216     uint256 private _redisFee = _redisFeeOnSell;
217     uint256 private _taxFee = _taxFeeOnSell;
218 
219     uint256 private _previousredisFee = _redisFee;
220     uint256 private _previoustaxFee = _taxFee;
221 
222     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
223     address payable private _developmentAddress = payable(0xf89787d525189E13dbC102b6338fe26c60492330);
224     address payable private _marketingAddress = payable(0xf89787d525189E13dbC102b6338fe26c60492330);
225 
226     IUniswapV2Router02 public uniswapV2Router;
227     address public uniswapV2Pair;
228 
229     bool private tradingOpen = true;
230     bool private inSwap = false;
231     bool private swapEnabled = true;
232 
233     uint256 public _maxTxAmount = 100000 * 10**9; // 1%
234     uint256 public _maxWalletSize = 200000 * 10**9; // 1%
235     uint256 public _swapTokensAtAmount = 15000 * 10**9; // .15%
236 
237     event MaxTxAmountUpdated(uint256 _maxTxAmount);
238     modifier lockTheSwap {
239         inSwap = true;
240         _;
241         inSwap = false;
242     }
243 
244     constructor() {
245 
246         _rOwned[_msgSender()] = _rTotal;
247 
248         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
249         uniswapV2Router = _uniswapV2Router;
250         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
251             .createPair(address(this), _uniswapV2Router.WETH());
252 
253         _isExcludedFromFee[owner()] = true;
254         _isExcludedFromFee[address(this)] = true;
255         _isExcludedFromFee[_developmentAddress] = true;
256         _isExcludedFromFee[_marketingAddress] = true;
257 
258         emit Transfer(address(0), _msgSender(), _tTotal);
259     }
260 
261     function name() public pure returns (string memory) {
262         return _name;
263     }
264 
265     function symbol() public pure returns (string memory) {
266         return _symbol;
267     }
268 
269     function decimals() public pure returns (uint8) {
270         return _decimals;
271     }
272 
273     function totalSupply() public pure override returns (uint256) {
274         return _tTotal;
275     }
276 
277     function balanceOf(address account) public view override returns (uint256) {
278         return tokenFromReflection(_rOwned[account]);
279     }
280 
281     function transfer(address recipient, uint256 amount)
282         public
283         override
284         returns (bool)
285     {
286         _transfer(_msgSender(), recipient, amount);
287         return true;
288     }
289 
290     function allowance(address owner, address spender)
291         public
292         view
293         override
294         returns (uint256)
295     {
296         return _allowances[owner][spender];
297     }
298 
299     function approve(address spender, uint256 amount)
300         public
301         override
302         returns (bool)
303     {
304         _approve(_msgSender(), spender, amount);
305         return true;
306     }
307 
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(
315             sender,
316             _msgSender(),
317             _allowances[sender][_msgSender()].sub(
318                 amount,
319                 "ERC20: transfer amount exceeds allowance"
320             )
321         );
322         return true;
323     }
324 
325     function tokenFromReflection(uint256 rAmount)
326         private
327         view
328         returns (uint256)
329     {
330         require(
331             rAmount <= _rTotal,
332             "Amount must be less than total reflections"
333         );
334         uint256 currentRate = _getRate();
335         return rAmount.div(currentRate);
336     }
337 
338     function removeAllFee() private {
339         if (_redisFee == 0 && _taxFee == 0) return;
340 
341         _previousredisFee = _redisFee;
342         _previoustaxFee = _taxFee;
343 
344         _redisFee = 0;
345         _taxFee = 0;
346     }
347 
348     function restoreAllFee() private {
349         _redisFee = _previousredisFee;
350         _taxFee = _previoustaxFee;
351     }
352 
353     function _approve(
354         address owner,
355         address spender,
356         uint256 amount
357     ) private {
358         require(owner != address(0), "ERC20: approve from the zero address");
359         require(spender != address(0), "ERC20: approve to the zero address");
360         _allowances[owner][spender] = amount;
361         emit Approval(owner, spender, amount);
362     }
363 
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) private {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371         require(amount > 0, "Transfer amount must be greater than zero");
372 
373         if (from != owner() && to != owner()) {
374 
375             //Trade start check
376             if (!tradingOpen) {
377                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
378             }
379 
380             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
381             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
382 
383             if(to != uniswapV2Pair) {
384                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
385             }
386 
387             uint256 contractTokenBalance = balanceOf(address(this));
388             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
389 
390             if(contractTokenBalance >= _maxTxAmount)
391             {
392                 contractTokenBalance = _maxTxAmount;
393             }
394 
395             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
396                 swapTokensForEth(contractTokenBalance);
397                 uint256 contractETHBalance = address(this).balance;
398                 if (contractETHBalance > 0) {
399                     sendETHToFee(address(this).balance);
400                 }
401             }
402         }
403 
404         bool takeFee = true;
405 
406         //Transfer Tokens
407         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
408             takeFee = false;
409         } else {
410 
411             //Set Fee for Buys
412             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
413                 _redisFee = _redisFeeOnBuy;
414                 _taxFee = _taxFeeOnBuy;
415             }
416 
417             //Set Fee for Sells
418             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
419                 _redisFee = _redisFeeOnSell;
420                 _taxFee = _taxFeeOnSell;
421             }
422 
423         }
424 
425         _tokenTransfer(from, to, amount, takeFee);
426     }
427 
428     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = uniswapV2Router.WETH();
432         _approve(address(this), address(uniswapV2Router), tokenAmount);
433         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             tokenAmount,
435             0,
436             path,
437             address(this),
438             block.timestamp
439         );
440     }
441 
442     function sendETHToFee(uint256 amount) private {
443         _marketingAddress.transfer(amount);
444     }
445 
446     function setTrading(bool _tradingOpen) public onlyOwner {
447         tradingOpen = _tradingOpen;
448     }
449 
450     function manualswap() external {
451         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
452         uint256 contractBalance = balanceOf(address(this));
453         swapTokensForEth(contractBalance);
454     }
455 
456     function manualsend() external {
457         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
458         uint256 contractETHBalance = address(this).balance;
459         sendETHToFee(contractETHBalance);
460     }
461 
462     function blockBots(address[] memory bots_) public onlyOwner {
463         for (uint256 i = 0; i < bots_.length; i++) {
464             bots[bots_[i]] = true;
465         }
466     }
467 
468     function unblockBot(address notbot) public onlyOwner {
469         bots[notbot] = false;
470     }
471 
472     function _tokenTransfer(
473         address sender,
474         address recipient,
475         uint256 amount,
476         bool takeFee
477     ) private {
478         if (!takeFee) removeAllFee();
479         _transferStandard(sender, recipient, amount);
480         if (!takeFee) restoreAllFee();
481     }
482 
483     function _transferStandard(
484         address sender,
485         address recipient,
486         uint256 tAmount
487     ) private {
488         (
489             uint256 rAmount,
490             uint256 rTransferAmount,
491             uint256 rFee,
492             uint256 tTransferAmount,
493             uint256 tFee,
494             uint256 tTeam
495         ) = _getValues(tAmount);
496         _rOwned[sender] = _rOwned[sender].sub(rAmount);
497         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
498         _takeTeam(tTeam);
499         _reflectFee(rFee, tFee);
500         emit Transfer(sender, recipient, tTransferAmount);
501     }
502 
503     function _takeTeam(uint256 tTeam) private {
504         uint256 currentRate = _getRate();
505         uint256 rTeam = tTeam.mul(currentRate);
506         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
507     }
508 
509     function _reflectFee(uint256 rFee, uint256 tFee) private {
510         _rTotal = _rTotal.sub(rFee);
511         _tFeeTotal = _tFeeTotal.add(tFee);
512     }
513 
514     receive() external payable {}
515 
516     function _getValues(uint256 tAmount)
517         private
518         view
519         returns (
520             uint256,
521             uint256,
522             uint256,
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
529             _getTValues(tAmount, _redisFee, _taxFee);
530         uint256 currentRate = _getRate();
531         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
532             _getRValues(tAmount, tFee, tTeam, currentRate);
533         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
534     }
535 
536     function _getTValues(
537         uint256 tAmount,
538         uint256 redisFee,
539         uint256 taxFee
540     )
541         private
542         pure
543         returns (
544             uint256,
545             uint256,
546             uint256
547         )
548     {
549         uint256 tFee = tAmount.mul(redisFee).div(100);
550         uint256 tTeam = tAmount.mul(taxFee).div(100);
551         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
552         return (tTransferAmount, tFee, tTeam);
553     }
554 
555     function _getRValues(
556         uint256 tAmount,
557         uint256 tFee,
558         uint256 tTeam,
559         uint256 currentRate
560     )
561         private
562         pure
563         returns (
564             uint256,
565             uint256,
566             uint256
567         )
568     {
569         uint256 rAmount = tAmount.mul(currentRate);
570         uint256 rFee = tFee.mul(currentRate);
571         uint256 rTeam = tTeam.mul(currentRate);
572         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
573         return (rAmount, rTransferAmount, rFee);
574     }
575 
576     function _getRate() private view returns (uint256) {
577         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
578         return rSupply.div(tSupply);
579     }
580 
581     function _getCurrentSupply() private view returns (uint256, uint256) {
582         uint256 rSupply = _rTotal;
583         uint256 tSupply = _tTotal;
584         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
585         return (rSupply, tSupply);
586     }
587 
588     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
589         _redisFeeOnBuy = redisFeeOnBuy;
590         _redisFeeOnSell = redisFeeOnSell;
591         _taxFeeOnBuy = taxFeeOnBuy;
592         _taxFeeOnSell = taxFeeOnSell;
593     }
594 
595     //Set minimum tokens required to swap.
596     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
597         _swapTokensAtAmount = swapTokensAtAmount;
598     }
599 
600     //Set minimum tokens required to swap.
601     function toggleSwap(bool _swapEnabled) public onlyOwner {
602         swapEnabled = _swapEnabled;
603     }
604 
605     //Set maximum transaction
606     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
607         _maxTxAmount = maxTxAmount;
608     }
609 
610     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
611         _maxWalletSize = maxWalletSize;
612     }
613 
614     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
615         for(uint256 i = 0; i < accounts.length; i++) {
616             _isExcludedFromFee[accounts[i]] = excluded;
617         }
618     }
619 
620 }