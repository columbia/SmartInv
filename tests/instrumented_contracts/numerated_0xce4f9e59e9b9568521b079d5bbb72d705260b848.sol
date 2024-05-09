1 pragma solidity ^0.8.4;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 contract Ownable is Context {
35     address private _owner;
36     address private _previousOwner;
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41 
42     constructor() {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 
68 }
69 
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88         return c;
89     }
90 
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         uint256 c = a / b;
111         return c;
112     }
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120 
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129 
130     function factory() external pure returns (address);
131 
132     function WETH() external pure returns (address);
133 
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150 
151 contract Rugtoshi is Context, IERC20, Ownable {
152 
153     using SafeMath for uint256;
154 
155     string private constant _name = unicode"Rugtoshi Kuscama";
156     string private constant _symbol = unicode"RUGTOSHI";
157     uint8 private constant _decimals = 9;
158 
159     mapping(address => uint256) private _rOwned;
160     mapping(address => uint256) private _tOwned;
161     mapping(address => mapping(address => uint256)) private _allowances;
162     mapping(address => bool) private _isExcludedFromFee;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 100000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167 
168     //Buy Fee
169     uint256 private _redisFeeOnBuy = 0;
170     uint256 private _taxFeeOnBuy = 25;
171 
172     //Sell Fee
173     uint256 private _redisFeeOnSell = 0;
174     uint256 private _taxFeeOnSell = 25;
175 
176     //Original Fee
177     uint256 private _redisFee = _redisFeeOnSell;
178     uint256 private _taxFee = _taxFeeOnSell;
179 
180     uint256 private _previousredisFee = _redisFee;
181     uint256 private _previoustaxFee = _taxFee;
182 
183     mapping(address => bool) public bots;
184     mapping(address => uint256) private cooldown;
185 
186     address payable private _developmentAddress = payable(0x17d20F8d752F61A4FfBECEc091B45E131E4ea464);
187     address payable private _marketingAddress = payable(0x17d20F8d752F61A4FfBECEc091B45E131E4ea464);
188 
189     IUniswapV2Router02 public uniswapV2Router;
190     address public uniswapV2Pair;
191 
192     bool private tradingOpen = true;
193     bool private inSwap = false;
194     bool private swapEnabled = true;
195 
196     uint256 public _maxTxAmount = 2000000 * 10**9; //
197     uint256 public _maxWalletSize = 2000000 * 10**9; //
198     uint256 public _swapTokensAtAmount = 500000 * 10**9; //
199 
200     event MaxTxAmountUpdated(uint256 _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor() {
208 
209         _rOwned[_msgSender()] = _rTotal;
210 
211         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
212         uniswapV2Router = _uniswapV2Router;
213         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
214             .createPair(address(this), _uniswapV2Router.WETH());
215 
216         _isExcludedFromFee[owner()] = true;
217         _isExcludedFromFee[address(this)] = true;
218         _isExcludedFromFee[_developmentAddress] = true;
219         _isExcludedFromFee[_marketingAddress] = true;
220 
221         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
222         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
223         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
224         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
225         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
226         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
227         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
228         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
229         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
230         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
231         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
232 
233         emit Transfer(address(0), _msgSender(), _tTotal);
234     }
235 
236     function name() public pure returns (string memory) {
237         return _name;
238     }
239 
240     function symbol() public pure returns (string memory) {
241         return _symbol;
242     }
243 
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247 
248     function totalSupply() public pure override returns (uint256) {
249         return _tTotal;
250     }
251 
252     function balanceOf(address account) public view override returns (uint256) {
253         return tokenFromReflection(_rOwned[account]);
254     }
255 
256     function transfer(address recipient, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     function allowance(address owner, address spender)
266         public
267         view
268         override
269         returns (uint256)
270     {
271         return _allowances[owner][spender];
272     }
273 
274     function approve(address spender, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public override returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(
290             sender,
291             _msgSender(),
292             _allowances[sender][_msgSender()].sub(
293                 amount,
294                 "ERC20: transfer amount exceeds allowance"
295             )
296         );
297         return true;
298     }
299 
300     function tokenFromReflection(uint256 rAmount)
301         private
302         view
303         returns (uint256)
304     {
305         require(
306             rAmount <= _rTotal,
307             "Amount must be less than total reflections"
308         );
309         uint256 currentRate = _getRate();
310         return rAmount.div(currentRate);
311     }
312 
313     function removeAllFee() private {
314         if (_redisFee == 0 && _taxFee == 0) return;
315 
316         _previousredisFee = _redisFee;
317         _previoustaxFee = _taxFee;
318 
319         _redisFee = 0;
320         _taxFee = 0;
321     }
322 
323     function restoreAllFee() private {
324         _redisFee = _previousredisFee;
325         _taxFee = _previoustaxFee;
326     }
327 
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338 
339     function _transfer(
340         address from,
341         address to,
342         uint256 amount
343     ) private {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346         require(amount > 0, "Transfer amount must be greater than zero");
347 
348         if (from != owner() && to != owner()) {
349 
350             //Trade start check
351             if (!tradingOpen) {
352                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
353             }
354 
355             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
356             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
357 
358             if(to != uniswapV2Pair) {
359                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
360             }
361 
362             uint256 contractTokenBalance = balanceOf(address(this));
363             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
364 
365             if(contractTokenBalance >= _maxTxAmount)
366             {
367                 contractTokenBalance = _maxTxAmount;
368             }
369 
370             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
371                 swapTokensForEth(contractTokenBalance);
372                 uint256 contractETHBalance = address(this).balance;
373                 if (contractETHBalance > 0) {
374                     sendETHToFee(address(this).balance);
375                 }
376             }
377         }
378 
379         bool takeFee = true;
380 
381         //Transfer Tokens
382         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
383             takeFee = false;
384         } else {
385 
386             //Set Fee for Buys
387             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
388                 _redisFee = _redisFeeOnBuy;
389                 _taxFee = _taxFeeOnBuy;
390             }
391 
392             //Set Fee for Sells
393             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
394                 _redisFee = _redisFeeOnSell;
395                 _taxFee = _taxFeeOnSell;
396             }
397 
398         }
399 
400         _tokenTransfer(from, to, amount, takeFee);
401     }
402 
403     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
404         address[] memory path = new address[](2);
405         path[0] = address(this);
406         path[1] = uniswapV2Router.WETH();
407         _approve(address(this), address(uniswapV2Router), tokenAmount);
408         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
409             tokenAmount,
410             0,
411             path,
412             address(this),
413             block.timestamp
414         );
415     }
416 
417     function sendETHToFee(uint256 amount) private {
418         _developmentAddress.transfer(amount.div(2));
419         _marketingAddress.transfer(amount.div(2));
420     }
421 
422     function setTrading(bool _tradingOpen) public onlyOwner {
423         tradingOpen = _tradingOpen;
424     }
425 
426     function manualswap() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractBalance = balanceOf(address(this));
429         swapTokensForEth(contractBalance);
430     }
431 
432     function manualsend() external {
433         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
434         uint256 contractETHBalance = address(this).balance;
435         sendETHToFee(contractETHBalance);
436     }
437 
438     function blockBots(address[] memory bots_) public onlyOwner {
439         for (uint256 i = 0; i < bots_.length; i++) {
440             bots[bots_[i]] = true;
441         }
442     }
443 
444     function unblockBot(address notbot) public onlyOwner {
445         bots[notbot] = false;
446     }
447 
448     function _tokenTransfer(
449         address sender,
450         address recipient,
451         uint256 amount,
452         bool takeFee
453     ) private {
454         if (!takeFee) removeAllFee();
455         _transferStandard(sender, recipient, amount);
456         if (!takeFee) restoreAllFee();
457     }
458 
459     function _transferStandard(
460         address sender,
461         address recipient,
462         uint256 tAmount
463     ) private {
464         (
465             uint256 rAmount,
466             uint256 rTransferAmount,
467             uint256 rFee,
468             uint256 tTransferAmount,
469             uint256 tFee,
470             uint256 tTeam
471         ) = _getValues(tAmount);
472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
473         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
474         _takeTeam(tTeam);
475         _reflectFee(rFee, tFee);
476         emit Transfer(sender, recipient, tTransferAmount);
477     }
478 
479     function _takeTeam(uint256 tTeam) private {
480         uint256 currentRate = _getRate();
481         uint256 rTeam = tTeam.mul(currentRate);
482         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
483     }
484 
485     function _reflectFee(uint256 rFee, uint256 tFee) private {
486         _rTotal = _rTotal.sub(rFee);
487         _tFeeTotal = _tFeeTotal.add(tFee);
488     }
489 
490     receive() external payable {}
491 
492     function _getValues(uint256 tAmount)
493         private
494         view
495         returns (
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
505             _getTValues(tAmount, _redisFee, _taxFee);
506         uint256 currentRate = _getRate();
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
508             _getRValues(tAmount, tFee, tTeam, currentRate);
509 
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512 
513     function _getTValues(
514         uint256 tAmount,
515         uint256 redisFee,
516         uint256 taxFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(redisFee).div(100);
527         uint256 tTeam = tAmount.mul(taxFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529 
530         return (tTransferAmount, tFee, tTeam);
531     }
532 
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551 
552         return (rAmount, rTransferAmount, rFee);
553     }
554 
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557 
558         return rSupply.div(tSupply);
559     }
560 
561     function _getCurrentSupply() private view returns (uint256, uint256) {
562         uint256 rSupply = _rTotal;
563         uint256 tSupply = _tTotal;
564         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
565 
566         return (rSupply, tSupply);
567     }
568 
569     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
570         _redisFeeOnBuy = redisFeeOnBuy;
571         _redisFeeOnSell = redisFeeOnSell;
572 
573         _taxFeeOnBuy = taxFeeOnBuy;
574         _taxFeeOnSell = taxFeeOnSell;
575     }
576 
577     //Set minimum tokens required to swap.
578     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
579         _swapTokensAtAmount = swapTokensAtAmount;
580     }
581 
582     //Set minimum tokens required to swap.
583     function toggleSwap(bool _swapEnabled) public onlyOwner {
584         swapEnabled = _swapEnabled;
585     }
586 
587     //Set MAx transaction
588     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
589         _maxTxAmount = maxTxAmount;
590     }
591 
592     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
593         _maxWalletSize = maxWalletSize;
594     }
595 
596 }