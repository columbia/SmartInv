1 /**
2 
3 The Japanese $KAIJU is here to smash zeros! 🐲
4 
5 Kaiju is a community driven decentralised investment dao focused on providing support for new and existing ethereum projects. whether they are innovative or simply memecoins, kaiju will akwaken greater opportunities that shall help them reach considerable heights 
6 
7 Telegram: https://t.me/KaijuETH
8 
9 Website: https://www.kaijueth.com/
10 */
11 
12 // SPDX-License-Identifier: unlicense
13 
14 pragma solidity ^0.8.7;
15  
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21  
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24  
25     function balanceOf(address account) external view returns (uint256);
26  
27     function transfer(address recipient, uint256 amount) external returns (bool);
28  
29     function allowance(address owner, address spender) external view returns (uint256);
30  
31     function approve(address spender, uint256 amount) external returns (bool);
32  
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38  
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46  
47 contract Ownable is Context {
48     address private _owner;
49     address private _previousOwner;
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54  
55     constructor() {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60  
61     function owner() public view returns (address) {
62         return _owner;
63     }
64  
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69  
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74  
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80  
81 }
82  
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89  
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93  
94     function sub(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103  
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110         return c;
111     }
112  
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116  
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
125     }
126 }
127  
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 }
133  
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint256 amountIn,
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external;
142  
143     function factory() external pure returns (address);
144  
145     function WETH() external pure returns (address);
146  
147     function addLiquidityETH(
148         address token,
149         uint256 amountTokenDesired,
150         uint256 amountTokenMin,
151         uint256 amountETHMin,
152         address to,
153         uint256 deadline
154     )
155         external
156         payable
157         returns (
158             uint256 amountToken,
159             uint256 amountETH,
160             uint256 liquidity
161         );
162 }
163  
164 contract KAIJU is Context, IERC20, Ownable {
165  
166     using SafeMath for uint256;
167  
168     string private constant _name = "KAIJU";//
169     string private constant _symbol = "KAIJU";//
170     uint8 private constant _decimals = 9;
171  
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 1000000000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180     uint256 public launchBlock;
181  
182     //Buy Fee
183     uint256 private _redisFeeOnBuy = 0;//
184     uint256 private _taxFeeOnBuy = 7;//
185  
186     //Sell Fee
187     uint256 private _redisFeeOnSell = 0;//
188     uint256 private _taxFeeOnSell = 10;//
189  
190     //Original Fee
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193  
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196  
197     mapping(address => bool) public bots;
198     mapping(address => uint256) private cooldown;
199  
200     address payable private _developmentAddress = payable(0x39d247Cb4eB24acd4CF3242a89884Ef5A6D6F1F9);//
201     address payable private _marketingAddress = payable(0x2Cc5AA4EB94beEA35b324a83da1B755e3Daa4975);//
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209  
210     uint256 public _maxTxAmount = 15000000000 * 10**9; //
211     uint256 public _maxWalletSize = 15000000000 * 10**9; //
212     uint256 public _swapTokensAtAmount = 100000000 * 10**9; //
213  
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220  
221     constructor() {
222  
223         _rOwned[_msgSender()] = _rTotal;
224  
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229  
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_developmentAddress] = true;
233         _isExcludedFromFee[_marketingAddress] = true;
234   
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237  
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241  
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245  
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249  
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253  
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257  
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266  
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275  
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284  
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301  
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314  
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317  
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320  
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324  
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329  
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340  
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349  
350         if (from != _developmentAddress && to != _developmentAddress) {
351  
352             //Trade start check
353             require(tradingOpen, "TOKEN: This account cannot send tokens until trading is enabled");
354             
355             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
356             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
357  
358             if(block.number <= launchBlock + 0 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
359                 bots[to] = true;
360             } 
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
428         launchBlock = block.number;
429     }
430  
431     function manualswap() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractBalance = balanceOf(address(this));
434         swapTokensForEth(contractBalance);
435     }
436  
437     function manualsend() external {
438         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
439         uint256 contractETHBalance = address(this).balance;
440         sendETHToFee(contractETHBalance);
441     }
442  
443     function blockBots(address[] memory bots_) public onlyOwner {
444         for (uint256 i = 0; i < bots_.length; i++) {
445             bots[bots_[i]] = true;
446         }
447     }
448  
449     function unblockBot(address notbot) public onlyOwner {
450         bots[notbot] = false;
451     }
452  
453     function _tokenTransfer(
454         address sender,
455         address recipient,
456         uint256 amount,
457         bool takeFee
458     ) private {
459         if (!takeFee) removeAllFee();
460         _transferStandard(sender, recipient, amount);
461         if (!takeFee) restoreAllFee();
462     }
463  
464     function _transferStandard(
465         address sender,
466         address recipient,
467         uint256 tAmount
468     ) private {
469         (
470             uint256 rAmount,
471             uint256 rTransferAmount,
472             uint256 rFee,
473             uint256 tTransferAmount,
474             uint256 tFee,
475             uint256 tTeam
476         ) = _getValues(tAmount);
477         _rOwned[sender] = _rOwned[sender].sub(rAmount);
478         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
479         _takeTeam(tTeam);
480         _reflectFee(rFee, tFee);
481         emit Transfer(sender, recipient, tTransferAmount);
482     }
483  
484     function _takeTeam(uint256 tTeam) private {
485         uint256 currentRate = _getRate();
486         uint256 rTeam = tTeam.mul(currentRate);
487         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
488     }
489  
490     function _reflectFee(uint256 rFee, uint256 tFee) private {
491         _rTotal = _rTotal.sub(rFee);
492         _tFeeTotal = _tFeeTotal.add(tFee);
493     }
494  
495     receive() external payable {}
496  
497     function _getValues(uint256 tAmount)
498         private
499         view
500         returns (
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
510             _getTValues(tAmount, _redisFee, _taxFee);
511         uint256 currentRate = _getRate();
512         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
513             _getRValues(tAmount, tFee, tTeam, currentRate);
514  
515         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
516     }
517  
518     function _getTValues(
519         uint256 tAmount,
520         uint256 redisFee,
521         uint256 taxFee
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 tFee = tAmount.mul(redisFee).div(100);
532         uint256 tTeam = tAmount.mul(taxFee).div(100);
533         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
534  
535         return (tTransferAmount, tFee, tTeam);
536     }
537  
538     function _getRValues(
539         uint256 tAmount,
540         uint256 tFee,
541         uint256 tTeam,
542         uint256 currentRate
543     )
544         private
545         pure
546         returns (
547             uint256,
548             uint256,
549             uint256
550         )
551     {
552         uint256 rAmount = tAmount.mul(currentRate);
553         uint256 rFee = tFee.mul(currentRate);
554         uint256 rTeam = tTeam.mul(currentRate);
555         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
556  
557         return (rAmount, rTransferAmount, rFee);
558     }
559  
560     function _getRate() private view returns (uint256) {
561         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
562  
563         return rSupply.div(tSupply);
564     }
565  
566     function _getCurrentSupply() private view returns (uint256, uint256) {
567         uint256 rSupply = _rTotal;
568         uint256 tSupply = _tTotal;
569         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
570  
571         return (rSupply, tSupply);
572     }
573  
574     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
575         _redisFeeOnBuy = redisFeeOnBuy;
576         _redisFeeOnSell = redisFeeOnSell;
577  
578         _taxFeeOnBuy = taxFeeOnBuy;
579         _taxFeeOnSell = taxFeeOnSell;
580     }
581  
582     //Set minimum tokens required to swap.
583     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
584         _swapTokensAtAmount = swapTokensAtAmount;
585     }
586  
587     //Set minimum tokens required to swap.
588     function toggleSwap(bool _swapEnabled) public onlyOwner {
589         swapEnabled = _swapEnabled;
590     }
591  
592     //Set maximum transaction
593     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
594         _maxTxAmount = maxTxAmount;
595     }
596  
597     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
598         _maxWalletSize = maxWalletSize;
599     }
600  
601     function addBots(address[] calldata accounts, bool value) public onlyOwner {
602         for(uint256 i = 0; i < accounts.length; i++) {
603             _isExcludedFromFee[accounts[i]] = value;
604         }
605     }
606 }