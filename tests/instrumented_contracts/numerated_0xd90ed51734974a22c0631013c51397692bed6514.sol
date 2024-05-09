1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16   
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
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
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
65 }
66  
67 library SafeMath {
68  
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72 
73         return c;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88    
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113 
114     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b != 0, errorMessage);
116         return a % b;
117     }
118 }
119 
120 library SafeCast {
121     function toUint128(uint256 value) internal pure returns (uint128) {
122         require(value < 2**128, "SafeCast: value doesn't fit in 128 bits");
123         return uint128(value);
124     }
125 
126     function toUint64(uint256 value) internal pure returns (uint64) {
127         require(value < 2**64, "SafeCast: value doesn't fit in 64 bits");
128         return uint64(value);
129     }
130 
131     function toUint32(uint256 value) internal pure returns (uint32) {
132         require(value < 2**32, "SafeCast: value doesn't fit in 32 bits");
133         return uint32(value);
134     }
135 
136     function toUint16(uint256 value) internal pure returns (uint16) {
137         require(value < 2**16, "SafeCast: value doesn't fit in 16 bits");
138         return uint16(value);
139     }
140 
141     function toUint8(uint256 value) internal pure returns (uint8) {
142         require(value < 2**8, "SafeCast: value doesn't fit in 8 bits");
143         return uint8(value);
144     }
145 
146     function toUint256(int256 value) internal pure returns (uint256) {
147         require(value >= 0, "SafeCast: value must be positive");
148         return uint256(value);
149     }
150 
151     function toInt256(uint256 value) internal pure returns (int256) {
152         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
153         return int256(value);
154     }
155 }
156 
157 interface IERC20Metadata is IERC20 {
158 
159     function name() external view returns (string memory);
160 
161     function symbol() external view returns (string memory);
162 
163     function decimals() external view returns (uint8);
164 }
165 
166 interface IUniswapV2Factory {
167     function createPair(address tokenA, address tokenB)
168         external
169         returns (address pair);
170 }
171 
172 interface IUniswapV2Router02 {
173     function swapExactTokensForETHSupportingFeeOnTransferTokens(
174         uint256 amountIn,
175         uint256 amountOutMin,
176         address[] calldata path,
177         address to,
178         uint256 deadline
179     ) external;
180 
181     function factory() external pure returns (address);
182 
183     function WETH() external pure returns (address);
184 
185     function addLiquidityETH(
186         address token,
187         uint256 amountTokenDesired,
188         uint256 amountTokenMin,
189         uint256 amountETHMin,
190         address to,
191         uint256 deadline
192     )
193         external
194         payable
195         returns (
196             uint256 amountToken,
197             uint256 amountETH,
198             uint256 liquidity
199         );
200 }
201  
202 contract ShiroiKiri is Context, IERC20, Ownable {
203     
204     using SafeMath for uint256;
205     using SafeCast for int256;
206 
207     string private constant _name = "Shiroi Kiri";
208     string private constant _symbol = "KIRI";
209     uint8 private constant _decimals = 18;
210 
211     mapping(address => uint256) private _rOwned;
212     mapping(address => uint256) private _tOwned;
213     mapping(address => mapping(address => uint256)) private _allowances;
214     mapping(address => bool) private _isExcludedFromFee;
215     uint256 private constant MAX = ~uint256(0);
216     uint256 private constant _tTotal = 1000000 * 10**18;
217     uint256 private _rTotal = (MAX - (MAX % _tTotal));
218     uint256 private _tFeeTotal;
219     
220     //Buy Fee
221     uint256 private _redisFeeOnBuy = 0;
222     uint256 private _taxFeeOnBuy = 3;
223     
224     //Sell Fee
225     uint256 private _redisFeeOnSell = 0;
226     uint256 private _taxFeeOnSell = 3;
227     
228     //Original Fee
229     uint256 private _redisFee = _redisFeeOnSell;
230     uint256 private _taxFee = _taxFeeOnSell;
231     
232     uint256 private _previousredisFee = _redisFee;
233     uint256 private _previoustaxFee = _taxFee;
234     
235     mapping(address => bool) public bots;
236     mapping (address => bool) public preTrader;
237     mapping(address => uint256) private cooldown;
238     
239     address payable private _marketingAddress = payable(0x58578006f346142F25D5c32d6189A48FF81c08F1);
240     
241     IUniswapV2Router02 public uniswapV2Router;
242     address public uniswapV2Pair;
243     
244     bool private tradingOpen;
245     bool private inSwap = false;
246     bool private swapEnabled = true;
247     
248     uint256 public _maxTxAmount = 20000 * 10**18; // 3.00%
249     uint256 public _maxWalletSize = 20000 * 10**18; // 3.00%
250     uint256 public _swapTokensAtAmount = 100 * 10**18; // 0.01%
251 
252     event MaxTxAmountUpdated(uint256 _maxTxAmount);
253     modifier lockTheSwap {
254         inSwap = true;
255         _;
256         inSwap = false;
257     }
258 
259     constructor() {
260         
261         _rOwned[_msgSender()] = _rTotal;
262         
263         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
264         uniswapV2Router = _uniswapV2Router;
265         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
266             .createPair(address(this), _uniswapV2Router.WETH());
267 
268         _isExcludedFromFee[owner()] = true;
269         _isExcludedFromFee[address(this)] = true;
270         _isExcludedFromFee[_marketingAddress] = true;
271         
272         preTrader[owner()] = true;
273 
274         emit Transfer(address(0), _msgSender(), _tTotal);
275     }
276 
277     function name() public pure returns (string memory) {
278         return _name;
279     }
280 
281     function symbol() public pure returns (string memory) {
282         return _symbol;
283     }
284 
285     function decimals() public pure returns (uint8) {
286         return _decimals;
287     }
288 
289     function totalSupply() public pure override returns (uint256) {
290         return _tTotal;
291     }
292 
293     function balanceOf(address account) public view override returns (uint256) {
294         return tokenFromReflection(_rOwned[account]);
295     }
296 
297     function transfer(address recipient, uint256 amount)
298         public
299         override
300         returns (bool)
301     {
302         _transfer(_msgSender(), recipient, amount);
303         return true;
304     }
305 
306     function allowance(address owner, address spender)
307         public
308         view
309         override
310         returns (uint256)
311     {
312         return _allowances[owner][spender];
313     }
314 
315     function approve(address spender, uint256 amount)
316         public
317         override
318         returns (bool)
319     {
320         _approve(_msgSender(), spender, amount);
321         return true;
322     }
323 
324     function transferFrom(
325         address sender,
326         address recipient,
327         uint256 amount
328     ) public override returns (bool) {
329         _transfer(sender, recipient, amount);
330         _approve(
331             sender,
332             _msgSender(),
333             _allowances[sender][_msgSender()].sub(
334                 amount,
335                 "ERC20: transfer amount exceeds allowance"
336             )
337         );
338         return true;
339     }
340 
341     function tokenFromReflection(uint256 rAmount)
342         private
343         view
344         returns (uint256)
345     {
346         require(
347             rAmount <= _rTotal,
348             "Amount must be less than total reflections"
349         );
350         uint256 currentRate = _getRate();
351         return rAmount.div(currentRate);
352     }
353 
354     function removeAllFee() private {
355         if (_redisFee == 0 && _taxFee == 0) return;
356     
357         _previousredisFee = _redisFee;
358         _previoustaxFee = _taxFee;
359         
360         _redisFee = 0;
361         _taxFee = 0;
362     }
363 
364     function restoreAllFee() private {
365         _redisFee = _previousredisFee;
366         _taxFee = _previoustaxFee;
367     }
368 
369     function _approve(
370         address owner,
371         address spender,
372         uint256 amount
373     ) private {
374         require(owner != address(0), "ERC20: approve from the zero address");
375         require(spender != address(0), "ERC20: approve to the zero address");
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380     function _transfer(
381         address from,
382         address to,
383         uint256 amount
384     ) private {
385         require(from != address(0), "ERC20: transfer from the zero address");
386         require(to != address(0), "ERC20: transfer to the zero address");
387         require(amount > 0, "Transfer amount must be greater than zero");
388 
389         if (from != owner() && to != owner()) {
390             
391             //Trade start check
392             if (!tradingOpen) {
393                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
394             }
395               
396             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
397             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
398             
399             if(to != uniswapV2Pair) {
400                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
401             }
402             
403             uint256 contractTokenBalance = balanceOf(address(this));
404             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
405 
406             if(contractTokenBalance >= _maxTxAmount)
407             {
408                 contractTokenBalance = _maxTxAmount;
409             }
410             
411             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
412                 swapTokensForEth(contractTokenBalance);
413                 uint256 contractETHBalance = address(this).balance;
414                 if (contractETHBalance > 0) {
415                     sendETHToFee(address(this).balance);
416                 }
417             }
418         }
419         
420         bool takeFee = true;
421 
422         //Transfer Tokens
423         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
424             
425             takeFee = false;
426         } else {
427             
428             //Set Fee for Buys
429             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
430                 _redisFee = _redisFeeOnBuy;
431                 _taxFee = _taxFeeOnBuy;
432             }
433     
434             //Set Fee for Sells
435             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
436                 _redisFee = _redisFeeOnSell;
437                 _taxFee = _taxFeeOnSell;
438             }
439             
440         }
441 
442         _tokenTransfer(from, to, amount, takeFee);
443     }
444 
445     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
446         address[] memory path = new address[](2);
447         path[0] = address(this);
448         path[1] = uniswapV2Router.WETH();
449         _approve(address(this), address(uniswapV2Router), tokenAmount);
450         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
451             tokenAmount,
452             0,
453             path,
454             address(this),
455             block.timestamp
456         );
457     }
458 
459     function sendETHToFee(uint256 amount) private {
460         _marketingAddress.transfer(amount);
461     }
462 
463     function setTrading(bool _tradingOpen) public onlyOwner {
464         tradingOpen = _tradingOpen;
465     }
466 
467     function manualswap() external {
468         require(_msgSender() == _marketingAddress);
469         uint256 contractBalance = balanceOf(address(this));
470         swapTokensForEth(contractBalance);
471     }
472 
473     function manualsend() external {
474         require(_msgSender() == _marketingAddress);
475         uint256 contractETHBalance = address(this).balance;
476         sendETHToFee(contractETHBalance);
477     }
478 
479     function blockBots(address[] memory bots_) public onlyOwner {
480         for (uint256 i = 0; i < bots_.length; i++) {
481             bots[bots_[i]] = true;
482         }
483     }
484 
485     function unblockBot(address notbot) public onlyOwner {
486         bots[notbot] = false;
487     }
488 
489     function _tokenTransfer(
490         address sender,
491         address recipient,
492         uint256 amount,
493         bool takeFee
494     ) private {
495         if (!takeFee) removeAllFee();
496         _transferStandard(sender, recipient, amount);
497         if (!takeFee) restoreAllFee();
498     }
499 
500     function _transferStandard(
501         address sender,
502         address recipient,
503         uint256 tAmount
504     ) private {
505         (
506             uint256 rAmount,
507             uint256 rTransferAmount,
508             uint256 rFee,
509             uint256 tTransferAmount,
510             uint256 tFee,
511             uint256 tTeam
512         ) = _getValues(tAmount);
513         _rOwned[sender] = _rOwned[sender].sub(rAmount);
514         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
515         _takeTeam(tTeam);
516         _reflectFee(rFee, tFee);
517         emit Transfer(sender, recipient, tTransferAmount);
518     }
519 
520     function _takeTeam(uint256 tTeam) private {
521         uint256 currentRate = _getRate();
522         uint256 rTeam = tTeam.mul(currentRate);
523         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
524     }
525 
526     function _reflectFee(uint256 rFee, uint256 tFee) private {
527         _rTotal = _rTotal.sub(rFee);
528         _tFeeTotal = _tFeeTotal.add(tFee);
529     }
530 
531     receive() external payable {}
532 
533     function _getValues(uint256 tAmount)
534         private
535         view
536         returns (
537             uint256,
538             uint256,
539             uint256,
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
546             _getTValues(tAmount, _redisFee, _taxFee);
547         uint256 currentRate = _getRate();
548         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
549             _getRValues(tAmount, tFee, tTeam, currentRate);
550         
551         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
552     }
553 
554     function _getTValues(
555         uint256 tAmount,
556         uint256 redisFee,
557         uint256 taxFee
558     )
559         private
560         pure
561         returns (
562             uint256,
563             uint256,
564             uint256
565         )
566     {
567         uint256 tFee = tAmount.mul(redisFee).div(100);
568         uint256 tTeam = tAmount.mul(taxFee).div(100);
569         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
570 
571         return (tTransferAmount, tFee, tTeam);
572     }
573 
574     function _getRValues(
575         uint256 tAmount,
576         uint256 tFee,
577         uint256 tTeam,
578         uint256 currentRate
579     )
580         private
581         pure
582         returns (
583             uint256,
584             uint256,
585             uint256
586         )
587     {
588         uint256 rAmount = tAmount.mul(currentRate);
589         uint256 rFee = tFee.mul(currentRate);
590         uint256 rTeam = tTeam.mul(currentRate);
591         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
592 
593         return (rAmount, rTransferAmount, rFee);
594     }
595 
596     function _getRate() private view returns (uint256) {
597         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
598 
599         return rSupply.div(tSupply);
600     }
601 
602     function _getCurrentSupply() private view returns (uint256, uint256) {
603         uint256 rSupply = _rTotal;
604         uint256 tSupply = _tTotal;
605         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
606     
607         return (rSupply, tSupply);
608     }
609     
610     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
611         _redisFeeOnBuy = redisFeeOnBuy;
612         _redisFeeOnSell = redisFeeOnSell;
613         
614         _taxFeeOnBuy = taxFeeOnBuy;
615         _taxFeeOnSell = taxFeeOnSell;
616     }
617 
618     //Set minimum tokens required to swap.
619     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
620         _swapTokensAtAmount = swapTokensAtAmount;
621     }
622     
623     //Set minimum tokens required to swap.
624     function toggleSwap(bool _swapEnabled) public onlyOwner {
625         swapEnabled = _swapEnabled;
626     }
627     
628     //Set Max transaction
629     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
630         _maxTxAmount = maxTxAmount;
631     }
632     
633     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
634         _maxWalletSize = maxWalletSize;
635     }
636  
637     function allowPreTrading(address account, bool allowed) public onlyOwner {
638         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
639         preTrader[account] = allowed;
640     }
641 }