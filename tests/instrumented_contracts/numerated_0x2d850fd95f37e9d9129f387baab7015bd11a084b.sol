1 /**
2 I've been waiting quite long, think the right time is now. The final capitulation event is on the door (Screenshot this) and MOONBOY's role is to give everyone hope. Hope that's missing in everyone 's hearts right now.
3 
4 I'm tired of all these memecoins launching daily (that's what changed everyone's mentality). 
5 
6 The secret is to stick to one meme. 
7 
8 So why not this?
9 
10 Moon. Boy. Moonboy. 
11 
12 We all are. Or better say, we all was. Time to get back to our origins.
13 
14 Initial tax will be 0/90, lowered to 0/0 after 5 minutes. Guess who will ape?
15 
16 Only the actual moonboys. Those who do not mind losing 100 bucks, with the chance of winning 10.000.
17 
18 You degens will be our floor. You, real moonboys, will be the basis we'll moon this from. 
19 
20 I'll remain anon and show myself at the right time.
21 
22 Keep an eye on the blockchain, where it all started.
23 */
24 
25 
26 
27 //SPDX-License-Identifier: UNLICENSED
28 pragma solidity ^0.8.4;
29  
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35  
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38  
39     function balanceOf(address account) external view returns (uint256);
40  
41     function transfer(address recipient, uint256 amount) external returns (bool);
42  
43     function allowance(address owner, address spender) external view returns (uint256);
44  
45     function approve(address spender, uint256 amount) external returns (bool);
46  
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52  
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(
55         address indexed owner,
56         address indexed spender,
57         uint256 value
58     );
59 }
60  
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68  
69     constructor() {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74  
75     function owner() public view returns (address) {
76         return _owner;
77     }
78  
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83  
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88  
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94  
95 }
96  
97 library SafeMath {
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101         return c;
102     }
103  
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107  
108     function sub(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115         return c;
116     }
117  
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) {
120             return 0;
121         }
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126  
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130  
131     function div(
132         uint256 a,
133         uint256 b,
134         string memory errorMessage
135     ) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         return c;
139     }
140 }
141  
142 interface IUniswapV2Factory {
143     function createPair(address tokenA, address tokenB)
144         external
145         returns (address pair);
146 }
147  
148 interface IUniswapV2Router02 {
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint256 amountIn,
151         uint256 amountOutMin,
152         address[] calldata path,
153         address to,
154         uint256 deadline
155     ) external;
156  
157     function factory() external pure returns (address);
158  
159     function WETH() external pure returns (address);
160  
161     function addLiquidityETH(
162         address token,
163         uint256 amountTokenDesired,
164         uint256 amountTokenMin,
165         uint256 amountETHMin,
166         address to,
167         uint256 deadline
168     )
169         external
170         payable
171         returns (
172             uint256 amountToken,
173             uint256 amountETH,
174             uint256 liquidity
175         );
176 }
177  
178 contract MoonBoy is Context, IERC20, Ownable {
179  
180     using SafeMath for uint256;
181  
182     string private constant _name = "MoonBoy";
183     string private constant _symbol = "MOON";
184     uint8 private constant _decimals = 9;
185  
186     mapping(address => uint256) private _rOwned;
187     mapping(address => uint256) private _tOwned;
188     mapping(address => mapping(address => uint256)) private _allowances;
189     mapping(address => bool) private _isExcludedFromFee;
190     uint256 private constant MAX = ~uint256(0);
191     uint256 private constant _tTotal = 10000000 * 10**9;
192     uint256 private _rTotal = (MAX - (MAX % _tTotal));
193     uint256 private _tFeeTotal;
194     uint256 public launchBlock;
195  
196     //Buy Fee
197     uint256 private _redisFeeOnBuy = 0;
198     uint256 private _taxFeeOnBuy = 5;
199  
200     //Sell Fee
201     uint256 private _redisFeeOnSell = 0;
202     uint256 private _taxFeeOnSell = 90;
203  
204     //Original Fee
205     uint256 private _redisFee = _redisFeeOnSell;
206     uint256 private _taxFee = _taxFeeOnSell;
207  
208     uint256 private _previousredisFee = _redisFee;
209     uint256 private _previoustaxFee = _taxFee;
210  
211     mapping(address => bool) public bots;
212     mapping(address => uint256) private cooldown;
213  
214     address payable private _developmentAddress = payable(0x21e67cf904aB593D6Fa94Ec6dF7F928B316fdb01);
215     address payable private _marketingAddress = payable(0x21e67cf904aB593D6Fa94Ec6dF7F928B316fdb01);
216  
217     IUniswapV2Router02 public uniswapV2Router;
218     address public uniswapV2Pair;
219  
220     bool private tradingOpen;
221     bool private inSwap = false;
222     bool private swapEnabled = true;
223  
224     uint256 public _maxTxAmount = 200000 * 10**9; 
225     uint256 public _maxWalletSize = 200000 * 10**9; 
226     uint256 public _swapTokensAtAmount = 30000 * 10**9; 
227  
228     event MaxTxAmountUpdated(uint256 _maxTxAmount);
229     modifier lockTheSwap {
230         inSwap = true;
231         _;
232         inSwap = false;
233     }
234  
235     constructor() {
236  
237         _rOwned[_msgSender()] = _rTotal;
238  
239         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
240         uniswapV2Router = _uniswapV2Router;
241         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
242             .createPair(address(this), _uniswapV2Router.WETH());
243  
244         _isExcludedFromFee[owner()] = true;
245         _isExcludedFromFee[address(this)] = true;
246         _isExcludedFromFee[_developmentAddress] = true;
247         _isExcludedFromFee[_marketingAddress] = true;
248 
249         emit Transfer(address(0), _msgSender(), _tTotal);
250     }
251  
252     function name() public pure returns (string memory) {
253         return _name;
254     }
255  
256     function symbol() public pure returns (string memory) {
257         return _symbol;
258     }
259  
260     function decimals() public pure returns (uint8) {
261         return _decimals;
262     }
263  
264     function totalSupply() public pure override returns (uint256) {
265         return _tTotal;
266     }
267  
268     function balanceOf(address account) public view override returns (uint256) {
269         return tokenFromReflection(_rOwned[account]);
270     }
271  
272     function transfer(address recipient, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280  
281     function allowance(address owner, address spender)
282         public
283         view
284         override
285         returns (uint256)
286     {
287         return _allowances[owner][spender];
288     }
289  
290     function approve(address spender, uint256 amount)
291         public
292         override
293         returns (bool)
294     {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298  
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(
306             sender,
307             _msgSender(),
308             _allowances[sender][_msgSender()].sub(
309                 amount,
310                 "ERC20: transfer amount exceeds allowance"
311             )
312         );
313         return true;
314     }
315  
316     function tokenFromReflection(uint256 rAmount)
317         private
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328  
329     function removeAllFee() private {
330         if (_redisFee == 0 && _taxFee == 0) return;
331  
332         _previousredisFee = _redisFee;
333         _previoustaxFee = _taxFee;
334  
335         _redisFee = 0;
336         _taxFee = 0;
337     }
338  
339     function restoreAllFee() private {
340         _redisFee = _previousredisFee;
341         _taxFee = _previoustaxFee;
342     }
343  
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) private {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354  
355     function _transfer(
356         address from,
357         address to,
358         uint256 amount
359     ) private {
360         require(from != address(0), "ERC20: transfer from the zero address");
361         require(to != address(0), "ERC20: transfer to the zero address");
362         require(amount > 0, "Transfer amount must be greater than zero");
363  
364         if (from != owner() && to != owner()) {
365  
366             //Trade start check
367             if (!tradingOpen) {
368                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
369             }
370  
371             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
372             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
373  
374             if(to != uniswapV2Pair) {
375                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
376             }
377  
378             uint256 contractTokenBalance = balanceOf(address(this));
379             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
380  
381             if(contractTokenBalance >= _maxTxAmount)
382             {
383                 contractTokenBalance = _maxTxAmount;
384             }
385  
386             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
387                 swapTokensForEth(contractTokenBalance);
388                 uint256 contractETHBalance = address(this).balance;
389                 if (contractETHBalance > 0) {
390                     sendETHToFee(address(this).balance);
391                 }
392             }
393         }
394  
395         bool takeFee = true;
396  
397         //Transfer Tokens
398         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
399             takeFee = false;
400         } else {
401  
402             //Set Fee for Buys
403             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
404                 _redisFee = _redisFeeOnBuy;
405                 _taxFee = _taxFeeOnBuy;
406             }
407  
408             //Set Fee for Sells
409             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
410                 _redisFee = _redisFeeOnSell;
411                 _taxFee = _taxFeeOnSell;
412             }
413  
414         }
415  
416         _tokenTransfer(from, to, amount, takeFee);
417     }
418  
419     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = uniswapV2Router.WETH();
423         _approve(address(this), address(uniswapV2Router), tokenAmount);
424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
425             tokenAmount,
426             0,
427             path,
428             address(this),
429             block.timestamp
430         );
431     }
432  
433     function sendETHToFee(uint256 amount) private {
434         _developmentAddress.transfer(amount.mul(50).div(100));
435         _marketingAddress.transfer(amount.mul(50).div(100));
436     }
437  
438     function setTrading(bool _tradingOpen) public onlyOwner {
439         tradingOpen = _tradingOpen;
440     }
441  
442     function manualswap() external {
443         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
444         uint256 contractBalance = balanceOf(address(this));
445         swapTokensForEth(contractBalance);
446     }
447  
448     function manualsend() external {
449         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
450         uint256 contractETHBalance = address(this).balance;
451         sendETHToFee(contractETHBalance);
452     }
453  
454     function blockBots(address[] memory bots_) public onlyOwner {
455         for (uint256 i = 0; i < bots_.length; i++) {
456             bots[bots_[i]] = true;
457         }
458     }
459  
460     function unblockBot(address notbot) public onlyOwner {
461         bots[notbot] = false;
462     }
463  
464     function _tokenTransfer(
465         address sender,
466         address recipient,
467         uint256 amount,
468         bool takeFee
469     ) private {
470         if (!takeFee) removeAllFee();
471         _transferStandard(sender, recipient, amount);
472         if (!takeFee) restoreAllFee();
473     }
474  
475     function _transferStandard(
476         address sender,
477         address recipient,
478         uint256 tAmount
479     ) private {
480         (
481             uint256 rAmount,
482             uint256 rTransferAmount,
483             uint256 rFee,
484             uint256 tTransferAmount,
485             uint256 tFee,
486             uint256 tTeam
487         ) = _getValues(tAmount);
488         _rOwned[sender] = _rOwned[sender].sub(rAmount);
489         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
490         _takeTeam(tTeam);
491         _reflectFee(rFee, tFee);
492         emit Transfer(sender, recipient, tTransferAmount);
493     }
494  
495     function _takeTeam(uint256 tTeam) private {
496         uint256 currentRate = _getRate();
497         uint256 rTeam = tTeam.mul(currentRate);
498         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
499     }
500  
501     function _reflectFee(uint256 rFee, uint256 tFee) private {
502         _rTotal = _rTotal.sub(rFee);
503         _tFeeTotal = _tFeeTotal.add(tFee);
504     }
505  
506     receive() external payable {}
507  
508     function _getValues(uint256 tAmount)
509         private
510         view
511         returns (
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
521             _getTValues(tAmount, _redisFee, _taxFee);
522         uint256 currentRate = _getRate();
523         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
524             _getRValues(tAmount, tFee, tTeam, currentRate);
525  
526         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
527     }
528  
529     function _getTValues(
530         uint256 tAmount,
531         uint256 redisFee,
532         uint256 taxFee
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 tFee = tAmount.mul(redisFee).div(100);
543         uint256 tTeam = tAmount.mul(taxFee).div(100);
544         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
545  
546         return (tTransferAmount, tFee, tTeam);
547     }
548  
549     function _getRValues(
550         uint256 tAmount,
551         uint256 tFee,
552         uint256 tTeam,
553         uint256 currentRate
554     )
555         private
556         pure
557         returns (
558             uint256,
559             uint256,
560             uint256
561         )
562     {
563         uint256 rAmount = tAmount.mul(currentRate);
564         uint256 rFee = tFee.mul(currentRate);
565         uint256 rTeam = tTeam.mul(currentRate);
566         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
567  
568         return (rAmount, rTransferAmount, rFee);
569     }
570  
571     function _getRate() private view returns (uint256) {
572         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
573  
574         return rSupply.div(tSupply);
575     }
576  
577     function _getCurrentSupply() private view returns (uint256, uint256) {
578         uint256 rSupply = _rTotal;
579         uint256 tSupply = _tTotal;
580         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
581  
582         return (rSupply, tSupply);
583     }
584  
585     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
586         _redisFeeOnBuy = redisFeeOnBuy;
587         _redisFeeOnSell = redisFeeOnSell;
588  
589         _taxFeeOnBuy = taxFeeOnBuy;
590         _taxFeeOnSell = taxFeeOnSell;
591     }
592  
593     //Set minimum tokens required to swap.
594     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
595         _swapTokensAtAmount = swapTokensAtAmount;
596     }
597  
598     //Set minimum tokens required to swap.
599     function toggleSwap(bool _swapEnabled) public onlyOwner {
600         swapEnabled = _swapEnabled;
601     }
602  
603  
604     //Set maximum transaction
605     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
606         _maxTxAmount = maxTxAmount;
607     }
608  
609     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
610         _maxWalletSize = maxWalletSize;
611     }
612  
613     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
614         for(uint256 i = 0; i < accounts.length; i++) {
615             _isExcludedFromFee[accounts[i]] = excluded;
616         }
617     }
618 }