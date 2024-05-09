1 /*
2 
3 Shiba Don (DON)
4 
5 Website: https://shibadon.io
6 
7 Telegram: t.me/ShibaDonTG
8 
9 Social Media: @shibadontoken
10 
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.13;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28   
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 }
78  
79 library SafeMath {
80  
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84 
85         return c;
86     }
87 
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91 
92     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100    
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118 
119         return c;
120     }
121 
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         return mod(a, b, "SafeMath: modulo by zero");
124     }
125 
126     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b != 0, errorMessage);
128         return a % b;
129     }
130 }
131 
132 library SafeCast {
133     function toUint128(uint256 value) internal pure returns (uint128) {
134         require(value < 2**128, "SafeCast: value doesn't fit in 128 bits");
135         return uint128(value);
136     }
137 
138     function toUint64(uint256 value) internal pure returns (uint64) {
139         require(value < 2**64, "SafeCast: value doesn't fit in 64 bits");
140         return uint64(value);
141     }
142 
143     function toUint32(uint256 value) internal pure returns (uint32) {
144         require(value < 2**32, "SafeCast: value doesn't fit in 32 bits");
145         return uint32(value);
146     }
147 
148     function toUint16(uint256 value) internal pure returns (uint16) {
149         require(value < 2**16, "SafeCast: value doesn't fit in 16 bits");
150         return uint16(value);
151     }
152 
153     function toUint8(uint256 value) internal pure returns (uint8) {
154         require(value < 2**8, "SafeCast: value doesn't fit in 8 bits");
155         return uint8(value);
156     }
157 
158     function toUint256(int256 value) internal pure returns (uint256) {
159         require(value >= 0, "SafeCast: value must be positive");
160         return uint256(value);
161     }
162 
163     function toInt256(uint256 value) internal pure returns (int256) {
164         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
165         return int256(value);
166     }
167 }
168 
169 interface IERC20Metadata is IERC20 {
170 
171     function name() external view returns (string memory);
172 
173     function symbol() external view returns (string memory);
174 
175     function decimals() external view returns (uint8);
176 }
177 
178 interface IUniswapV2Factory {
179     function createPair(address tokenA, address tokenB)
180         external
181         returns (address pair);
182 }
183 
184 interface IUniswapV2Router02 {
185     function swapExactTokensForETHSupportingFeeOnTransferTokens(
186         uint256 amountIn,
187         uint256 amountOutMin,
188         address[] calldata path,
189         address to,
190         uint256 deadline
191     ) external;
192 
193     function factory() external pure returns (address);
194 
195     function WETH() external pure returns (address);
196 
197     function addLiquidityETH(
198         address token,
199         uint256 amountTokenDesired,
200         uint256 amountTokenMin,
201         uint256 amountETHMin,
202         address to,
203         uint256 deadline
204     )
205         external
206         payable
207         returns (
208             uint256 amountToken,
209             uint256 amountETH,
210             uint256 liquidity
211         );
212 }
213  
214 contract ShibaDon is Context, IERC20, Ownable {
215     
216     using SafeMath for uint256;
217     using SafeCast for int256;
218 
219     string private constant _name = "ShibaDon";
220     string private constant _symbol = "DON";
221     uint8 private constant _decimals = 9;
222 
223     mapping(address => uint256) private _rOwned;
224     mapping(address => uint256) private _tOwned;
225     mapping(address => mapping(address => uint256)) private _allowances;
226     mapping(address => bool) private _isExcludedFromFee;
227     uint256 private constant MAX = ~uint256(0);
228     uint256 private constant _tTotal = 69420000000 * 10**9;
229     uint256 private _rTotal = (MAX - (MAX % _tTotal));
230     uint256 private _tFeeTotal;
231     
232     //Buy Fee
233     uint256 private _redisFeeOnBuy = 2;
234     uint256 private _taxFeeOnBuy = 7;
235     
236     //Sell Fee
237     uint256 private _redisFeeOnSell = 2;
238     uint256 private _taxFeeOnSell = 7;
239     
240     //Original Fee
241     uint256 private _redisFee = _redisFeeOnSell;
242     uint256 private _taxFee = _taxFeeOnSell;
243     
244     uint256 private _previousredisFee = _redisFee;
245     uint256 private _previoustaxFee = _taxFee;
246     
247     mapping(address => bool) public bots;
248     mapping (address => bool) public preTrader;
249     mapping(address => uint256) private cooldown;
250     
251     address payable private _marketingAddress = payable(0x2C939b5c9029030FD3fC66C2c67d737CBDE449F2);
252     
253     IUniswapV2Router02 public uniswapV2Router;
254     address public uniswapV2Pair;
255     
256     bool private tradingOpen;
257     bool private inSwap = false;
258     bool private swapEnabled = true;
259     
260     uint256 public _maxTxAmount = 694200000 * 10**9; // 1.00%
261     uint256 public _maxWalletSize = 1388400000 * 10**9; // 2.00%
262     uint256 public _swapTokensAtAmount = 6942000 * 10**9; // 0.01%
263 
264     event MaxTxAmountUpdated(uint256 _maxTxAmount);
265     modifier lockTheSwap {
266         inSwap = true;
267         _;
268         inSwap = false;
269     }
270 
271     constructor() {
272         
273         _rOwned[_msgSender()] = _rTotal;
274         
275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
276         uniswapV2Router = _uniswapV2Router;
277         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
278             .createPair(address(this), _uniswapV2Router.WETH());
279 
280         _isExcludedFromFee[owner()] = true;
281         _isExcludedFromFee[address(this)] = true;
282         _isExcludedFromFee[_marketingAddress] = true;
283         
284         preTrader[owner()] = true;
285 
286         emit Transfer(address(0), _msgSender(), _tTotal);
287     }
288 
289     function name() public pure returns (string memory) {
290         return _name;
291     }
292 
293     function symbol() public pure returns (string memory) {
294         return _symbol;
295     }
296 
297     function decimals() public pure returns (uint8) {
298         return _decimals;
299     }
300 
301     function totalSupply() public pure override returns (uint256) {
302         return _tTotal;
303     }
304 
305     function balanceOf(address account) public view override returns (uint256) {
306         return tokenFromReflection(_rOwned[account]);
307     }
308 
309     function transfer(address recipient, uint256 amount)
310         public
311         override
312         returns (bool)
313     {
314         _transfer(_msgSender(), recipient, amount);
315         return true;
316     }
317 
318     function allowance(address owner, address spender)
319         public
320         view
321         override
322         returns (uint256)
323     {
324         return _allowances[owner][spender];
325     }
326 
327     function approve(address spender, uint256 amount)
328         public
329         override
330         returns (bool)
331     {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336     function transferFrom(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) public override returns (bool) {
341         _transfer(sender, recipient, amount);
342         _approve(
343             sender,
344             _msgSender(),
345             _allowances[sender][_msgSender()].sub(
346                 amount,
347                 "ERC20: transfer amount exceeds allowance"
348             )
349         );
350         return true;
351     }
352 
353     function tokenFromReflection(uint256 rAmount)
354         private
355         view
356         returns (uint256)
357     {
358         require(
359             rAmount <= _rTotal,
360             "Amount must be less than total reflections"
361         );
362         uint256 currentRate = _getRate();
363         return rAmount.div(currentRate);
364     }
365 
366     function removeAllFee() private {
367         if (_redisFee == 0 && _taxFee == 0) return;
368     
369         _previousredisFee = _redisFee;
370         _previoustaxFee = _taxFee;
371         
372         _redisFee = 0;
373         _taxFee = 0;
374     }
375 
376     function restoreAllFee() private {
377         _redisFee = _previousredisFee;
378         _taxFee = _previoustaxFee;
379     }
380 
381     function _approve(
382         address owner,
383         address spender,
384         uint256 amount
385     ) private {
386         require(owner != address(0), "ERC20: approve from the zero address");
387         require(spender != address(0), "ERC20: approve to the zero address");
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391 
392     function _transfer(
393         address from,
394         address to,
395         uint256 amount
396     ) private {
397         require(from != address(0), "ERC20: transfer from the zero address");
398         require(to != address(0), "ERC20: transfer to the zero address");
399         require(amount > 0, "Transfer amount must be greater than zero");
400 
401         if (from != owner() && to != owner()) {
402             
403             //Trade start check
404             if (!tradingOpen) {
405                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
406             }
407               
408             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
409             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
410             
411             if(to != uniswapV2Pair) {
412                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
413             }
414             
415             uint256 contractTokenBalance = balanceOf(address(this));
416             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
417 
418             if(contractTokenBalance >= _maxTxAmount)
419             {
420                 contractTokenBalance = _maxTxAmount;
421             }
422             
423             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
424                 swapTokensForEth(contractTokenBalance);
425                 uint256 contractETHBalance = address(this).balance;
426                 if (contractETHBalance > 0) {
427                     sendETHToFee(address(this).balance);
428                 }
429             }
430         }
431         
432         bool takeFee = true;
433 
434         //Transfer Tokens
435         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
436             
437             takeFee = false;
438         } else {
439             
440             //Set Fee for Buys
441             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
442                 _redisFee = _redisFeeOnBuy;
443                 _taxFee = _taxFeeOnBuy;
444             }
445     
446             //Set Fee for Sells
447             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
448                 _redisFee = _redisFeeOnSell;
449                 _taxFee = _taxFeeOnSell;
450             }
451             
452         }
453 
454         _tokenTransfer(from, to, amount, takeFee);
455     }
456 
457     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
458         address[] memory path = new address[](2);
459         path[0] = address(this);
460         path[1] = uniswapV2Router.WETH();
461         _approve(address(this), address(uniswapV2Router), tokenAmount);
462         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
463             tokenAmount,
464             0,
465             path,
466             address(this),
467             block.timestamp
468         );
469     }
470 
471     function sendETHToFee(uint256 amount) private {
472         _marketingAddress.transfer(amount);
473     }
474 
475     function setTrading(bool _tradingOpen) public onlyOwner {
476         tradingOpen = _tradingOpen;
477     }
478 
479     function manualswap() external {
480         require(_msgSender() == _marketingAddress);
481         uint256 contractBalance = balanceOf(address(this));
482         swapTokensForEth(contractBalance);
483     }
484 
485     function manualsend() external {
486         require(_msgSender() == _marketingAddress);
487         uint256 contractETHBalance = address(this).balance;
488         sendETHToFee(contractETHBalance);
489     }
490 
491     function blockBots(address[] memory bots_) public onlyOwner {
492         for (uint256 i = 0; i < bots_.length; i++) {
493             bots[bots_[i]] = true;
494         }
495     }
496 
497     function unblockBot(address notbot) public onlyOwner {
498         bots[notbot] = false;
499     }
500 
501     function _tokenTransfer(
502         address sender,
503         address recipient,
504         uint256 amount,
505         bool takeFee
506     ) private {
507         if (!takeFee) removeAllFee();
508         _transferStandard(sender, recipient, amount);
509         if (!takeFee) restoreAllFee();
510     }
511 
512     function _transferStandard(
513         address sender,
514         address recipient,
515         uint256 tAmount
516     ) private {
517         (
518             uint256 rAmount,
519             uint256 rTransferAmount,
520             uint256 rFee,
521             uint256 tTransferAmount,
522             uint256 tFee,
523             uint256 tTeam
524         ) = _getValues(tAmount);
525         _rOwned[sender] = _rOwned[sender].sub(rAmount);
526         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
527         _takeTeam(tTeam);
528         _reflectFee(rFee, tFee);
529         emit Transfer(sender, recipient, tTransferAmount);
530     }
531 
532     function _takeTeam(uint256 tTeam) private {
533         uint256 currentRate = _getRate();
534         uint256 rTeam = tTeam.mul(currentRate);
535         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
536     }
537 
538     function _reflectFee(uint256 rFee, uint256 tFee) private {
539         _rTotal = _rTotal.sub(rFee);
540         _tFeeTotal = _tFeeTotal.add(tFee);
541     }
542 
543     receive() external payable {}
544 
545     function _getValues(uint256 tAmount)
546         private
547         view
548         returns (
549             uint256,
550             uint256,
551             uint256,
552             uint256,
553             uint256,
554             uint256
555         )
556     {
557         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
558             _getTValues(tAmount, _redisFee, _taxFee);
559         uint256 currentRate = _getRate();
560         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
561             _getRValues(tAmount, tFee, tTeam, currentRate);
562         
563         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
564     }
565 
566     function _getTValues(
567         uint256 tAmount,
568         uint256 redisFee,
569         uint256 taxFee
570     )
571         private
572         pure
573         returns (
574             uint256,
575             uint256,
576             uint256
577         )
578     {
579         uint256 tFee = tAmount.mul(redisFee).div(100);
580         uint256 tTeam = tAmount.mul(taxFee).div(100);
581         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
582 
583         return (tTransferAmount, tFee, tTeam);
584     }
585 
586     function _getRValues(
587         uint256 tAmount,
588         uint256 tFee,
589         uint256 tTeam,
590         uint256 currentRate
591     )
592         private
593         pure
594         returns (
595             uint256,
596             uint256,
597             uint256
598         )
599     {
600         uint256 rAmount = tAmount.mul(currentRate);
601         uint256 rFee = tFee.mul(currentRate);
602         uint256 rTeam = tTeam.mul(currentRate);
603         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
604 
605         return (rAmount, rTransferAmount, rFee);
606     }
607 
608     function _getRate() private view returns (uint256) {
609         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
610 
611         return rSupply.div(tSupply);
612     }
613 
614     function _getCurrentSupply() private view returns (uint256, uint256) {
615         uint256 rSupply = _rTotal;
616         uint256 tSupply = _tTotal;
617         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
618     
619         return (rSupply, tSupply);
620     }
621     
622     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
623         _redisFeeOnBuy = redisFeeOnBuy;
624         _redisFeeOnSell = redisFeeOnSell;
625         
626         _taxFeeOnBuy = taxFeeOnBuy;
627         _taxFeeOnSell = taxFeeOnSell;
628     }
629 
630     //Set minimum tokens required to swap.
631     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
632         _swapTokensAtAmount = swapTokensAtAmount;
633     }
634     
635     //Set minimum tokens required to swap.
636     function toggleSwap(bool _swapEnabled) public onlyOwner {
637         swapEnabled = _swapEnabled;
638     }
639     
640     //Set Max transaction
641     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
642         _maxTxAmount = maxTxAmount;
643     }
644     
645     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
646         _maxWalletSize = maxWalletSize;
647     }
648  
649     function allowPreTrading(address account, bool allowed) public onlyOwner {
650         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
651         preTrader[account] = allowed;
652     }
653 }