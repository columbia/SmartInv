1 /**
2         Memekong.io
3 */
4 
5 
6 
7 //SPDX-License-Identifier: UNLICENSED
8 pragma solidity ^0.8.4;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15  
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18  
19     function balanceOf(address account) external view returns (uint256);
20  
21     function transfer(address recipient, uint256 amount) external returns (bool);
22  
23     function allowance(address owner, address spender) external view returns (uint256);
24  
25     function approve(address spender, uint256 amount) external returns (bool);
26  
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32  
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40  
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48  
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54  
55     function owner() public view returns (address) {
56         return _owner;
57     }
58  
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63  
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68  
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74  
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
158 contract MEMEKONG is Context, IERC20, Ownable {
159  
160     using SafeMath for uint256;
161  
162     string private constant _name = "MEME KONG";//
163     string private constant _symbol = "MKONG";//
164     uint8 private constant _decimals = 9;
165  
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 200000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 public launchBlock;
175  
176     //Buy Fee
177     uint256 private _redisFeeOnBuy = 0;//
178     uint256 private _taxFeeOnBuy = 9;//
179  
180     //Sell Fee
181     uint256 private _redisFeeOnSell = 0;//
182     uint256 private _taxFeeOnSell = 99;//
183  
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187  
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190  
191     mapping(address => bool) public bots;
192     mapping(address => uint256) private cooldown;
193  
194     address payable private _developmentAddress = payable(0x56B60b78899d36d5Ad14e4fc2c842C76E51b9782);//
195     address payable private _marketingAddress = payable(0xb118f3dfF544Caa46CB3965280ad710DB7b52B09);//
196  
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199  
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203  
204     uint256 public _maxTxAmount = 250000 * 10**9; //
205     uint256 public _maxWalletSize = 750000 * 10**9; //
206     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
207  
208     event MaxTxAmountUpdated(uint256 _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214  
215     constructor() {
216  
217         _rOwned[_msgSender()] = _rTotal;
218  
219         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
220         uniswapV2Router = _uniswapV2Router;
221         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
222             .createPair(address(this), _uniswapV2Router.WETH());
223  
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
226         _isExcludedFromFee[_developmentAddress] = true;
227         _isExcludedFromFee[_marketingAddress] = true;
228  
229         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
230         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
231         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
232         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
233         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
234         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
235         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
236         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
237         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
238         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
239         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
240  
241  
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244  
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248  
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252  
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256  
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260  
261     function balanceOf(address account) public view override returns (uint256) {
262         return tokenFromReflection(_rOwned[account]);
263     }
264  
265     function transfer(address recipient, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273  
274     function allowance(address owner, address spender)
275         public
276         view
277         override
278         returns (uint256)
279     {
280         return _allowances[owner][spender];
281     }
282  
283     function approve(address spender, uint256 amount)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291  
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308  
309     function tokenFromReflection(uint256 rAmount)
310         private
311         view
312         returns (uint256)
313     {
314         require(
315             rAmount <= _rTotal,
316             "Amount must be less than total reflections"
317         );
318         uint256 currentRate = _getRate();
319         return rAmount.div(currentRate);
320     }
321  
322     function removeAllFee() private {
323         if (_redisFee == 0 && _taxFee == 0) return;
324  
325         _previousredisFee = _redisFee;
326         _previoustaxFee = _taxFee;
327  
328         _redisFee = 0;
329         _taxFee = 0;
330     }
331  
332     function restoreAllFee() private {
333         _redisFee = _previousredisFee;
334         _taxFee = _previoustaxFee;
335     }
336  
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347  
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) private {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356  
357         if (from != owner() && to != owner()) {
358  
359             //Trade start check
360             if (!tradingOpen) {
361                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
362             }
363  
364             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
365             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
366  
367             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
368                 bots[to] = true;
369             } 
370  
371             if(to != uniswapV2Pair) {
372                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
373             }
374  
375             uint256 contractTokenBalance = balanceOf(address(this));
376             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
377  
378             if(contractTokenBalance >= _maxTxAmount)
379             {
380                 contractTokenBalance = _maxTxAmount;
381             }
382  
383             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
384                 swapTokensForEth(contractTokenBalance);
385                 uint256 contractETHBalance = address(this).balance;
386                 if (contractETHBalance > 0) {
387                     sendETHToFee(address(this).balance);
388                 }
389             }
390         }
391  
392         bool takeFee = true;
393  
394         //Transfer Tokens
395         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
396             takeFee = false;
397         } else {
398  
399             //Set Fee for Buys
400             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnBuy;
402                 _taxFee = _taxFeeOnBuy;
403             }
404  
405             //Set Fee for Sells
406             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnSell;
408                 _taxFee = _taxFeeOnSell;
409             }
410  
411         }
412  
413         _tokenTransfer(from, to, amount, takeFee);
414     }
415  
416     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
417         address[] memory path = new address[](2);
418         path[0] = address(this);
419         path[1] = uniswapV2Router.WETH();
420         _approve(address(this), address(uniswapV2Router), tokenAmount);
421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
422             tokenAmount,
423             0,
424             path,
425             address(this),
426             block.timestamp
427         );
428     }
429  
430     function sendETHToFee(uint256 amount) private {
431         _developmentAddress.transfer(amount.div(2));
432         _marketingAddress.transfer(amount.div(2));
433     }
434  
435     function setTrading(bool _tradingOpen) public onlyOwner {
436         tradingOpen = _tradingOpen;
437         launchBlock = block.number;
438     }
439  
440     function manualswap() external {
441         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
442         uint256 contractBalance = balanceOf(address(this));
443         swapTokensForEth(contractBalance);
444     }
445  
446     function manualsend() external {
447         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
448         uint256 contractETHBalance = address(this).balance;
449         sendETHToFee(contractETHBalance);
450     }
451  
452     function blockBots(address[] memory bots_) public onlyOwner {
453         for (uint256 i = 0; i < bots_.length; i++) {
454             bots[bots_[i]] = true;
455         }
456     }
457  
458     function unblockBot(address notbot) public onlyOwner {
459         bots[notbot] = false;
460     }
461  
462     function _tokenTransfer(
463         address sender,
464         address recipient,
465         uint256 amount,
466         bool takeFee
467     ) private {
468         if (!takeFee) removeAllFee();
469         _transferStandard(sender, recipient, amount);
470         if (!takeFee) restoreAllFee();
471     }
472  
473     function _transferStandard(
474         address sender,
475         address recipient,
476         uint256 tAmount
477     ) private {
478         (
479             uint256 rAmount,
480             uint256 rTransferAmount,
481             uint256 rFee,
482             uint256 tTransferAmount,
483             uint256 tFee,
484             uint256 tTeam
485         ) = _getValues(tAmount);
486         _rOwned[sender] = _rOwned[sender].sub(rAmount);
487         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
488         _takeTeam(tTeam);
489         _reflectFee(rFee, tFee);
490         emit Transfer(sender, recipient, tTransferAmount);
491     }
492  
493     function _takeTeam(uint256 tTeam) private {
494         uint256 currentRate = _getRate();
495         uint256 rTeam = tTeam.mul(currentRate);
496         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
497     }
498  
499     function _reflectFee(uint256 rFee, uint256 tFee) private {
500         _rTotal = _rTotal.sub(rFee);
501         _tFeeTotal = _tFeeTotal.add(tFee);
502     }
503  
504     receive() external payable {}
505  
506     function _getValues(uint256 tAmount)
507         private
508         view
509         returns (
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
519             _getTValues(tAmount, _redisFee, _taxFee);
520         uint256 currentRate = _getRate();
521         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
522             _getRValues(tAmount, tFee, tTeam, currentRate);
523  
524         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
525     }
526  
527     function _getTValues(
528         uint256 tAmount,
529         uint256 redisFee,
530         uint256 taxFee
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 tFee = tAmount.mul(redisFee).div(100);
541         uint256 tTeam = tAmount.mul(taxFee).div(100);
542         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
543  
544         return (tTransferAmount, tFee, tTeam);
545     }
546  
547     function _getRValues(
548         uint256 tAmount,
549         uint256 tFee,
550         uint256 tTeam,
551         uint256 currentRate
552     )
553         private
554         pure
555         returns (
556             uint256,
557             uint256,
558             uint256
559         )
560     {
561         uint256 rAmount = tAmount.mul(currentRate);
562         uint256 rFee = tFee.mul(currentRate);
563         uint256 rTeam = tTeam.mul(currentRate);
564         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
565  
566         return (rAmount, rTransferAmount, rFee);
567     }
568  
569     function _getRate() private view returns (uint256) {
570         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
571  
572         return rSupply.div(tSupply);
573     }
574  
575     function _getCurrentSupply() private view returns (uint256, uint256) {
576         uint256 rSupply = _rTotal;
577         uint256 tSupply = _tTotal;
578         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
579  
580         return (rSupply, tSupply);
581     }
582  
583     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
584         _redisFeeOnBuy = redisFeeOnBuy;
585         _redisFeeOnSell = redisFeeOnSell;
586  
587         _taxFeeOnBuy = taxFeeOnBuy;
588         _taxFeeOnSell = taxFeeOnSell;
589     }
590  
591     //Set minimum tokens required to swap.
592     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
593         _swapTokensAtAmount = swapTokensAtAmount;
594     }
595  
596     //Set minimum tokens required to swap.
597     function toggleSwap(bool _swapEnabled) public onlyOwner {
598         swapEnabled = _swapEnabled;
599     }
600  
601  
602     //Set maximum transaction
603     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
604         _maxTxAmount = maxTxAmount;
605     }
606  
607     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
608         _maxWalletSize = maxWalletSize;
609     }
610  
611     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
612         for(uint256 i = 0; i < accounts.length; i++) {
613             _isExcludedFromFee[accounts[i]] = excluded;
614         }
615     }
616 }