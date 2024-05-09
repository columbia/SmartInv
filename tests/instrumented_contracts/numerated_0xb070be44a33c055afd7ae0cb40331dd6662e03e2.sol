1 /**
2  *    Pay homage to Pepe
3  *
4  *
5  *⠀⢀⠔⠂⠉⠉⠉⠉⠑⠢⡄⣀⠔⠊⠁⠀⠒⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6  *⡰⠁⠀⠀⠀⠀⢀⣀⣀⣀⠘⡇⠀⠀⠀⠀⠀⠀⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7  *⠁⠀⠀⣠⠔⠉⠁⠀⠀⠀⠉⠉⠲⣤⠖⠒⠒⠒⠲⠬⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
8  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀
9  *⠀⠀⠀⣠⠔⣊⠭⠭⠭⠭⢭⣛⠩⣉⠲⣇⠀⠀⢀⣶⠶⢦⣶⢷⣤⡀⠀⠀⠀⠀
10  *⠀⠀⢸⣵⣉⡤⠤⢤⣤⣤⣤⣬⠵⠮⣶⣌⣇⠐⣫⣶⣭⣭⣍⡑⢼⠁⠀⠀⠀⠀
11  *⠀⠀⠀⠀⠈⣅⠲⣿⣞⣿⣉⣿⠀⠀⠘⡎⣇⡜⣿⣾⣿⣹⡇⠈⣽⠀⠀⠀⠀⠀
12  *⠀⠀⠀⠀⠀⠀⠓⠤⢈⣉⣛⣓⣂⣒⣊⡽⠂⢹⣛⠛⢛⠛⣒⣩⠞⠀⠀⠀⠀⠀
13  *⠀⠠⠤⠂⠀⠀⠀⠀⠀⠀⠀⠀⣀⠼⠁⠀⠀⠀⠈⠫⡁⠐⠛⠁⠱⡀⠀⠀⠀⠀
14  *⢠⢶⠭⠭⣄⣀⠀⠀⠀⠤⠒⠉⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⢰⢻⠄⠀⠀⠀
15  *⠀⠘⢦⣙⠲⠤⣍⡉⠑⠒⠢⠤⠤⠤⣀⣀⣀⣀⣀⣀⣀⣀⣀⠔⣡⠊⠀⠀⠀⠀
16  *⠀⠀⠀⠈⠉⠢⢄⡈⠉⠁⠀⠀⠒⠒⠦⠤⠤⠤⠤⠤⠤⠤⠤⠊⡸⠀⠀⠀⠀⠀
17  *⠀⠀⠀⠀⠀⠀⠀⠈⠙⠒⠂⠤⠤⠤⠤⢄⣀⣀⡤⠤⠤⢤⠤⠚⠅⠀⠀⠀⠀⠀
18  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠒⠓⢤⠞⠀⠀⠀⠀⠀⠀
19  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⢄⡠⢶⡁⠀⣀⣀⡀⢑⠢⣄⠀⠀⠀⠀
20  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠣⢶⠕⢋⢔⡵⠗⠁⠀⠈⠳⡀⠀⠀
21  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠘⣖⡝⠁⠀⢀⠔⠀⠀⠀⠘⣆⠀
22  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⠈⠑⠤⢠⠃⠀⣠⠞⢀⠄⠈⢆
23  *
24  * PEPECOIN
25  *
26  * https://t.me/PEPECOINDODODO
27  *
28 */
29 
30 /// SPDX-License-Identifier: Unlicensed
31 
32 
33 
34 pragma solidity ^0.8.20;
35 
36 
37 
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46 
47     function balanceOf(address account) external view returns (uint256);
48 
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     function transferFrom(
56         address sender,
57         address recipient,
58         uint256 amount
59     ) external returns (bool);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(
63         address indexed owner,
64         address indexed spender,
65         uint256 value
66     );
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     address private _previousOwner;
72     event OwnershipTransferred(
73         address indexed previousOwner,
74         address indexed newOwner
75     );
76 
77     constructor() {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 
103 }
104 
105 library SafeMath {
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109         return c;
110     }
111 
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return sub(a, b, "SafeMath: subtraction overflow");
114     }
115 
116     function sub(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         uint256 c = a - b;
123         return c;
124     }
125 
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         if (a == 0) {
128             return 0;
129         }
130         uint256 c = a * b;
131         require(c / a == b, "SafeMath: multiplication overflow");
132         return c;
133     }
134 
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return div(a, b, "SafeMath: division by zero");
137     }
138 
139     function div(
140         uint256 a,
141         uint256 b,
142         string memory errorMessage
143     ) internal pure returns (uint256) {
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         return c;
147     }
148 }
149 
150 interface IUniswapV2Factory {
151     function createPair(address tokenA, address tokenB)
152         external
153         returns (address pair);
154 }
155 
156 interface IUniswapV2Router02 {
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint256 amountIn,
159         uint256 amountOutMin,
160         address[] calldata path,
161         address to,
162         uint256 deadline
163     ) external;
164 
165     function factory() external pure returns (address);
166 
167     function WETH() external pure returns (address);
168 
169     function addLiquidityETH(
170         address token,
171         uint256 amountTokenDesired,
172         uint256 amountTokenMin,
173         uint256 amountETHMin,
174         address to,
175         uint256 deadline
176     )
177         external
178         payable
179         returns (
180             uint256 amountToken,
181             uint256 amountETH,
182             uint256 liquidity
183         );
184 }
185 
186 contract pepecoin is Context, IERC20, Ownable {
187 
188     using SafeMath for uint256;
189 
190     string private constant _name = unicode"➖➖➖🟩🟩➖🟩🟩\n➖➖🟩🟩🟩🟩🟩🟩🟩\n➖🟩🟩⬜️⬛️⬜️⬜️⬛️🟩\n➖🟩🟩🟩🟩🟩🟩🟩\n🟩🟩🟩🟩🟥🟥🟥🟥\n🟩🟩🟩🟩🟩🟩🟩\n🟦🟦🟦🟦🟦🟦🟦";
191     string private constant _symbol = unicode"PEPECOIN";
192     uint8 private constant _decimals = 9;
193 
194     mapping(address => uint256) private _rOwned;
195     mapping(address => uint256) private _tOwned;
196     mapping(address => mapping(address => uint256)) private _allowances;
197     mapping(address => bool) private _isExcludedFromFee;
198     uint256 private constant MAX = ~uint256(0);
199     uint256 private constant _tTotal = 420690000000000 * 10**9;
200     uint256 private _rTotal = (MAX - (MAX % _tTotal));
201     uint256 private _tFeeTotal;
202     uint256 private _redisFeeOnBuy = 0;
203     uint256 private _taxFeeOnBuy = 25;
204     uint256 private _redisFeeOnSell = 0;
205     uint256 private _taxFeeOnSell = 40;
206 
207     //Original Fee
208     uint256 private _redisFee = _redisFeeOnSell;
209     uint256 private _taxFee = _taxFeeOnSell;
210 
211     uint256 private _previousredisFee = _redisFee;
212     uint256 private _previoustaxFee = _taxFee;
213 
214     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
215     address payable private _developmentAddress = payable(0xf44D9316B84e3E1449ab5E198c8984037DB98454);
216     address payable private _marketingAddress = payable(0xf44D9316B84e3E1449ab5E198c8984037DB98454);
217 
218     IUniswapV2Router02 public uniswapV2Router;
219     address public uniswapV2Pair;
220 
221     bool private tradingOpen = false;
222     bool private inSwap = false;
223     bool private swapEnabled =true;
224 
225     uint256 public _maxTxAmount = 841380000000 * 10**9;
226     uint256 public _maxWalletSize = 841380000000 * 10**9;
227     uint256 public _swapTokensAtAmount = 8413800000000 * 10**9;
228 
229     event MaxTxAmountUpdated(uint256 _maxTxAmount);
230     modifier lockTheSwap {
231         inSwap = true;
232         _;
233         inSwap = false;
234     }
235 
236     constructor() {
237 
238         _rOwned[_msgSender()] = _rTotal;
239 
240         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
241         uniswapV2Router = _uniswapV2Router;
242         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
243             .createPair(address(this), _uniswapV2Router.WETH());
244 
245         _isExcludedFromFee[owner()] = true;
246         _isExcludedFromFee[address(this)] = true;
247         _isExcludedFromFee[_developmentAddress] = true;
248         _isExcludedFromFee[_marketingAddress] = true;
249 
250         emit Transfer(address(0), _msgSender(), _tTotal);
251     }
252 
253     function name() public pure returns (string memory) {
254         return _name;
255     }
256 
257     function symbol() public pure returns (string memory) {
258         return _symbol;
259     }
260 
261     function decimals() public pure returns (uint8) {
262         return _decimals;
263     }
264 
265     function totalSupply() public pure override returns (uint256) {
266         return _tTotal;
267     }
268 
269     function balanceOf(address account) public view override returns (uint256) {
270         return tokenFromReflection(_rOwned[account]);
271     }
272 
273     function transfer(address recipient, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _transfer(_msgSender(), recipient, amount);
279         return true;
280     }
281 
282     function allowance(address owner, address spender)
283         public
284         view
285         override
286         returns (uint256)
287     {
288         return _allowances[owner][spender];
289     }
290 
291     function approve(address spender, uint256 amount)
292         public
293         override
294         returns (bool)
295     {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(
307             sender,
308             _msgSender(),
309             _allowances[sender][_msgSender()].sub(
310                 amount,
311                 "ERC20: transfer amount exceeds allowance"
312             )
313         );
314         return true;
315     }
316 
317     function tokenFromReflection(uint256 rAmount)
318         private
319         view
320         returns (uint256)
321     {
322         require(
323             rAmount <= _rTotal,
324             "Amount must be less than total reflections"
325         );
326         uint256 currentRate = _getRate();
327         return rAmount.div(currentRate);
328     }
329 
330     function removeAllFee() private {
331         if (_redisFee == 0 && _taxFee == 0) return;
332 
333         _previousredisFee = _redisFee;
334         _previoustaxFee = _taxFee;
335 
336         _redisFee = 0;
337         _taxFee = 0;
338     }
339 
340     function restoreAllFee() private {
341         _redisFee = _previousredisFee;
342         _taxFee = _previoustaxFee;
343     }
344 
345     function _approve(
346         address owner,
347         address spender,
348         uint256 amount
349     ) private {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356     function _transfer(
357         address from,
358         address to,
359         uint256 amount
360     ) private {
361         require(from != address(0), "ERC20: transfer from the zero address");
362         require(to != address(0), "ERC20: transfer to the zero address");
363         require(amount > 0, "Transfer amount must be greater than zero");
364 
365         if (from != owner() && to != owner()) {
366 
367             //Trade start check
368             if (!tradingOpen) {
369                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
370             }
371 
372             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
373             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
374 
375             if(to != uniswapV2Pair) {
376                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
377             }
378 
379             uint256 contractTokenBalance = balanceOf(address(this));
380             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
381 
382             if(contractTokenBalance >= _maxTxAmount)
383             {
384                 contractTokenBalance = _maxTxAmount;
385             }
386 
387             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
388                 swapTokensForEth(contractTokenBalance);
389                 uint256 contractETHBalance = address(this).balance;
390                 if (contractETHBalance > 0) {
391                     sendETHToFee(address(this).balance);
392                 }
393             }
394         }
395 
396         bool takeFee = true;
397 
398         //Transfer Tokens
399         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
400             takeFee = false;
401         } else {
402 
403             //Set Fee for Buys
404             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
405                 _redisFee = _redisFeeOnBuy;
406                 _taxFee = _taxFeeOnBuy;
407             }
408 
409             //Set Fee for Sells
410             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
411                 _redisFee = _redisFeeOnSell;
412                 _taxFee = _taxFeeOnSell;
413             }
414 
415         }
416 
417         _tokenTransfer(from, to, amount, takeFee);
418     }
419 
420     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
421         address[] memory path = new address[](2);
422         path[0] = address(this);
423         path[1] = uniswapV2Router.WETH();
424         _approve(address(this), address(uniswapV2Router), tokenAmount);
425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
426             tokenAmount,
427             0,
428             path,
429             address(this),
430             block.timestamp
431         );
432     }
433 
434     function sendETHToFee(uint256 amount) private {
435         _marketingAddress.transfer(amount);
436     }
437 
438     function activateTrading() public onlyOwner {
439         tradingOpen = true;
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
525         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
526     }
527 
528     function _getTValues(
529         uint256 tAmount,
530         uint256 redisFee,
531         uint256 taxFee
532     )
533         private
534         pure
535         returns (
536             uint256,
537             uint256,
538             uint256
539         )
540     {
541         uint256 tFee = tAmount.mul(redisFee).div(100);
542         uint256 tTeam = tAmount.mul(taxFee).div(100);
543         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
565         return (rAmount, rTransferAmount, rFee);
566     }
567 
568     function _getRate() private view returns (uint256) {
569         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
570         return rSupply.div(tSupply);
571     }
572 
573     function _getCurrentSupply() private view returns (uint256, uint256) {
574         uint256 rSupply = _rTotal;
575         uint256 tSupply = _tTotal;
576         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
577         return (rSupply, tSupply);
578     }
579 
580     function updateFees(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
581 
582         require((redisFeeOnBuy + taxFeeOnBuy) <= 25);
583         require((redisFeeOnSell + taxFeeOnSell) <= 40);
584         _redisFeeOnBuy = redisFeeOnBuy;
585         _redisFeeOnSell = redisFeeOnSell;
586         _taxFeeOnBuy = taxFeeOnBuy;
587         _taxFeeOnSell = taxFeeOnSell;
588     }
589 
590     //Set minimum tokens required to swap.
591     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
592         _swapTokensAtAmount = swapTokensAtAmount;
593     }
594 
595     //Set minimum tokens required to swap.
596     function toggleSwap(bool _swapEnabled) public onlyOwner {
597         swapEnabled = _swapEnabled;
598     }
599 
600     //Set maximum transaction
601     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
602         _maxTxAmount = maxTxAmount;
603     }
604 
605     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
606         _maxWalletSize = maxWalletSize;
607     }
608 
609     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
610         for(uint256 i = 0; i < accounts.length; i++) {
611             _isExcludedFromFee[accounts[i]] = excluded;
612         }
613     }
614 
615     function removeLimits() public onlyOwner{
616 
617         _maxTxAmount = _tTotal;
618         _maxWalletSize = _tTotal;
619     } 
620 
621 }