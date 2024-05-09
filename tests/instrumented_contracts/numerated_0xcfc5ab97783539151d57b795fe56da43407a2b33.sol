1 // SPDX-License-Identifier: UNLICENSED
2 
3 // TELEGRAM: https://t.me/elmoerc
4 
5 pragma solidity ^0.8.4;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 contract Ownable is Context {
39     address private _owner;
40     address private _previousOwner;
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45 
46     constructor() {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 
72 }
73 
74 library SafeMath {
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78         return c;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     function sub(
86         uint256 a,
87         uint256 b,
88         string memory errorMessage
89     ) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92         return c;
93     }
94 
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         if (a == 0) {
97             return 0;
98         }
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
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
115         return c;
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     function createPair(address tokenA, address tokenB)
121         external
122         returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint256 amountIn,
128         uint256 amountOutMin,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external;
133 
134     function factory() external pure returns (address);
135 
136     function WETH() external pure returns (address);
137 
138     function addLiquidityETH(
139         address token,
140         uint256 amountTokenDesired,
141         uint256 amountTokenMin,
142         uint256 amountETHMin,
143         address to,
144         uint256 deadline
145     )
146         external
147         payable
148         returns (
149             uint256 amountToken,
150             uint256 amountETH,
151             uint256 liquidity
152         );
153 }
154 
155 contract Elmo is Context, IERC20, Ownable {
156 
157     using SafeMath for uint256;
158 
159     string private constant _name = "Elmo";
160     string private constant _symbol = "ELMO";
161     uint8 private constant _decimals = 9;
162 
163     mapping(address => uint256) private _rOwned;
164     mapping(address => uint256) private _tOwned;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     mapping(address => bool) private _isExcludedFromFee;
167     uint256 private constant MAX = ~uint256(0);
168     uint256 private constant _tTotal = 100000000 * 10**9;
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171 
172     //Buy Fee
173     uint256 private _redisFeeOnBuy = 0;
174     uint256 private _taxFeeOnBuy = 2;
175 
176     //Sell Fee
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 2;
179 
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     mapping(address => bool) public bots;
188     mapping(address => uint256) private cooldown;
189 
190     address payable private _developmentAddress = payable(0xABEaa9954feA6294856a7665351d7eC8267D156B);
191     address payable private _marketingAddress = payable(0xd910e0104dec0836E67E0430A8a54C930F3957F0);
192 
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195 
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199 
200     uint256 public _maxTxAmount = 2000000 * 10**9; //
201     uint256 public _maxWalletSize = 3000000 * 10**9; //
202     uint256 public _swapTokensAtAmount = 500000 * 10**9; //
203 
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210 
211     constructor() {
212 
213         _rOwned[_msgSender()] = _rTotal;
214 
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219 
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_developmentAddress] = true;
223         _isExcludedFromFee[_marketingAddress] = true;
224 
225         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
226         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
227         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
228         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
229         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
230         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
231         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
232         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
233         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
234         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
235         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
236 
237         emit Transfer(address(0), _msgSender(), _tTotal);
238     }
239 
240     function name() public pure returns (string memory) {
241         return _name;
242     }
243 
244     function symbol() public pure returns (string memory) {
245         return _symbol;
246     }
247 
248     function decimals() public pure returns (uint8) {
249         return _decimals;
250     }
251 
252     function totalSupply() public pure override returns (uint256) {
253         return _tTotal;
254     }
255 
256     function balanceOf(address account) public view override returns (uint256) {
257         return tokenFromReflection(_rOwned[account]);
258     }
259 
260     function transfer(address recipient, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     function allowance(address owner, address spender)
270         public
271         view
272         override
273         returns (uint256)
274     {
275         return _allowances[owner][spender];
276     }
277 
278     function approve(address spender, uint256 amount)
279         public
280         override
281         returns (bool)
282     {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public override returns (bool) {
292         _transfer(sender, recipient, amount);
293         _approve(
294             sender,
295             _msgSender(),
296             _allowances[sender][_msgSender()].sub(
297                 amount,
298                 "ERC20: transfer amount exceeds allowance"
299             )
300         );
301         return true;
302     }
303 
304     function tokenFromReflection(uint256 rAmount)
305         private
306         view
307         returns (uint256)
308     {
309         require(
310             rAmount <= _rTotal,
311             "Amount must be less than total reflections"
312         );
313         uint256 currentRate = _getRate();
314         return rAmount.div(currentRate);
315     }
316 
317     function removeAllFee() private {
318         if (_redisFee == 0 && _taxFee == 0) return;
319 
320         _previousredisFee = _redisFee;
321         _previoustaxFee = _taxFee;
322 
323         _redisFee = 0;
324         _taxFee = 0;
325     }
326 
327     function restoreAllFee() private {
328         _redisFee = _previousredisFee;
329         _taxFee = _previoustaxFee;
330     }
331 
332     function _approve(
333         address owner,
334         address spender,
335         uint256 amount
336     ) private {
337         require(owner != address(0), "ERC20: approve from the zero address");
338         require(spender != address(0), "ERC20: approve to the zero address");
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) private {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "Transfer amount must be greater than zero");
351 
352         if (from != owner() && to != owner()) {
353 
354             //Trade start check
355             if (!tradingOpen) {
356                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
357             }
358 
359             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
360             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
361 
362             if(to != uniswapV2Pair) {
363                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
364             }
365 
366             uint256 contractTokenBalance = balanceOf(address(this));
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368 
369             if(contractTokenBalance >= _maxTxAmount)
370             {
371                 contractTokenBalance = _maxTxAmount;
372             }
373 
374             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
375                 swapTokensForEth(contractTokenBalance);
376                 uint256 contractETHBalance = address(this).balance;
377                 if (contractETHBalance > 0) {
378                     sendETHToFee(address(this).balance);
379                 }
380             }
381         }
382 
383         bool takeFee = true;
384 
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389 
390             //Set Fee for Buys
391             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnBuy;
393                 _taxFee = _taxFeeOnBuy;
394             }
395 
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _redisFee = _redisFeeOnSell;
399                 _taxFee = _taxFeeOnSell;
400             }
401 
402         }
403 
404         _tokenTransfer(from, to, amount, takeFee);
405     }
406 
407     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = uniswapV2Router.WETH();
411         _approve(address(this), address(uniswapV2Router), tokenAmount);
412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             tokenAmount,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419     }
420 
421     function sendETHToFee(uint256 amount) private {
422         _developmentAddress.transfer(amount.div(2));
423         _marketingAddress.transfer(amount.div(2));
424     }
425 
426     function setTrading(bool _tradingOpen) public onlyOwner {
427         tradingOpen = _tradingOpen;
428     }
429 
430     function manualswap() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435 
436     function manualsend() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractETHBalance = address(this).balance;
439         sendETHToFee(contractETHBalance);
440     }
441 
442     function blockBots(address[] memory bots_) public onlyOwner {
443         for (uint256 i = 0; i < bots_.length; i++) {
444             bots[bots_[i]] = true;
445         }
446     }
447 
448     function unblockBot(address notbot) public onlyOwner {
449         bots[notbot] = false;
450     }
451 
452     function _tokenTransfer(
453         address sender,
454         address recipient,
455         uint256 amount,
456         bool takeFee
457     ) private {
458         if (!takeFee) removeAllFee();
459         _transferStandard(sender, recipient, amount);
460         if (!takeFee) restoreAllFee();
461     }
462 
463     function _transferStandard(
464         address sender,
465         address recipient,
466         uint256 tAmount
467     ) private {
468         (
469             uint256 rAmount,
470             uint256 rTransferAmount,
471             uint256 rFee,
472             uint256 tTransferAmount,
473             uint256 tFee,
474             uint256 tTeam
475         ) = _getValues(tAmount);
476         _rOwned[sender] = _rOwned[sender].sub(rAmount);
477         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
478         _takeTeam(tTeam);
479         _reflectFee(rFee, tFee);
480         emit Transfer(sender, recipient, tTransferAmount);
481     }
482 
483     function _takeTeam(uint256 tTeam) private {
484         uint256 currentRate = _getRate();
485         uint256 rTeam = tTeam.mul(currentRate);
486         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
487     }
488 
489     function _reflectFee(uint256 rFee, uint256 tFee) private {
490         _rTotal = _rTotal.sub(rFee);
491         _tFeeTotal = _tFeeTotal.add(tFee);
492     }
493 
494     receive() external payable {}
495 
496     function _getValues(uint256 tAmount)
497         private
498         view
499         returns (
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
509             _getTValues(tAmount, _redisFee, _taxFee);
510         uint256 currentRate = _getRate();
511         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
512             _getRValues(tAmount, tFee, tTeam, currentRate);
513 
514         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
515     }
516 
517     function _getTValues(
518         uint256 tAmount,
519         uint256 redisFee,
520         uint256 taxFee
521     )
522         private
523         pure
524         returns (
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         uint256 tFee = tAmount.mul(redisFee).div(100);
531         uint256 tTeam = tAmount.mul(taxFee).div(100);
532         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
533 
534         return (tTransferAmount, tFee, tTeam);
535     }
536 
537     function _getRValues(
538         uint256 tAmount,
539         uint256 tFee,
540         uint256 tTeam,
541         uint256 currentRate
542     )
543         private
544         pure
545         returns (
546             uint256,
547             uint256,
548             uint256
549         )
550     {
551         uint256 rAmount = tAmount.mul(currentRate);
552         uint256 rFee = tFee.mul(currentRate);
553         uint256 rTeam = tTeam.mul(currentRate);
554         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
555 
556         return (rAmount, rTransferAmount, rFee);
557     }
558 
559     function _getRate() private view returns (uint256) {
560         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
561 
562         return rSupply.div(tSupply);
563     }
564 
565     function _getCurrentSupply() private view returns (uint256, uint256) {
566         uint256 rSupply = _rTotal;
567         uint256 tSupply = _tTotal;
568         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
569 
570         return (rSupply, tSupply);
571     }
572 
573     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
574         _redisFeeOnBuy = redisFeeOnBuy;
575         _redisFeeOnSell = redisFeeOnSell;
576 
577         _taxFeeOnBuy = taxFeeOnBuy;
578         _taxFeeOnSell = taxFeeOnSell;
579     }
580 
581     //Set minimum tokens required to swap.
582     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
583         _swapTokensAtAmount = swapTokensAtAmount;
584     }
585 
586     //Set minimum tokens required to swap.
587     function toggleSwap(bool _swapEnabled) public onlyOwner {
588         swapEnabled = _swapEnabled;
589     }
590 
591     //Set MAx transaction
592     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
593         _maxTxAmount = maxTxAmount;
594     }
595 
596     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
597         _maxWalletSize = maxWalletSize;
598     }
599 
600 }