1 // BEAM - The Happy Pill
2 // Feel the Crypto High!
3 // Treats all forms of Cryptomylitis. Take one tablet by mind once daily, as directed by your development team.
4 // WARNING: The Happy Pill may cause delight in your life. Avoid regular work or anything non-Crypto-related while enjoying The Happy Pill. Contact your development team immediately if you experience any side effects or unusual symptoms. Keep The Happy Pill out of the reach of jeets.
5 
6 // Website: https://cryptomylitis.com
7 // Telegram: https://t.me/The_Happy_Pill
8 // Twitter: https://twitter.com/Cryptomylitis
9 
10 // Cryptomylitis
11 
12 // Woke up this morning
13 // With a jeetery feelin'
14 // And that feelin'
15 // Was a freaky lil feelin'
16 
17 // Inna my bone yeah
18 // It inna my blood
19 // Inna my toes
20 // Coming up to my brain
21 
22 // Went to the developer
23 // To check out what's matter
24 // I Went to the developer
25 // To find out the matter
26 
27 // Developer said son
28 // You have a Cryptomylitis
29 // I said, Fuck
30 // Doctor said son
31 // You have a Cryptomylitis
32 
33 // SPDX-License-Identifier: Unlicensed
34 pragma solidity ^0.8.16;
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43 
44     function balanceOf(address account) external view returns (uint256);
45 
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     function transferFrom(
53         address sender,
54         address recipient,
55         uint256 amount
56     ) external returns (bool);
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(
60         address indexed owner,
61         address indexed spender,
62         uint256 value
63     );
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     address private _previousOwner;
69     event OwnershipTransferred(
70         address indexed previousOwner,
71         address indexed newOwner
72     );
73 
74     constructor() {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 
100 }
101 
102 library SafeMath {
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106         return c;
107     }
108 
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     function sub(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120         return c;
121     }
122 
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         if (a == 0) {
125             return 0;
126         }
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129         return c;
130     }
131 
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     function div(
137         uint256 a,
138         uint256 b,
139         string memory errorMessage
140     ) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         return c;
144     }
145 }
146 
147 interface IUniswapV2Factory {
148     function createPair(address tokenA, address tokenB)
149         external
150         returns (address pair);
151 }
152 
153 interface IUniswapV2Router02 {
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint256 amountIn,
156         uint256 amountOutMin,
157         address[] calldata path,
158         address to,
159         uint256 deadline
160     ) external;
161 
162     function factory() external pure returns (address);
163 
164     function WETH() external pure returns (address);
165 
166     function addLiquidityETH(
167         address token,
168         uint256 amountTokenDesired,
169         uint256 amountTokenMin,
170         uint256 amountETHMin,
171         address to,
172         uint256 deadline
173     )
174         external
175         payable
176         returns (
177             uint256 amountToken,
178             uint256 amountETH,
179             uint256 liquidity
180         );
181 }
182 
183 contract BEAM is Context, IERC20, Ownable {
184 
185     using SafeMath for uint256;
186 
187     string private constant _name = "The Happy Pill";
188     string private constant _symbol = "BEAM";
189     uint8 private constant _decimals = 9;
190 
191     mapping(address => uint256) private _rOwned;
192     mapping(address => uint256) private _tOwned;
193     mapping(address => mapping(address => uint256)) private _allowances;
194     mapping(address => bool) private _isExcludedFromFee;
195     uint256 private constant MAX = ~uint256(0);
196     uint256 private constant _tTotal = 1000000000 * 10**9;
197     uint256 private _rTotal = (MAX - (MAX % _tTotal));
198     uint256 private _tFeeTotal;
199     uint256 private _redisFeeOnBuy = 0;
200     uint256 private _taxFeeOnBuy = 5;
201     uint256 private _redisFeeOnSell = 0;
202     uint256 private _taxFeeOnSell = 5;
203 
204     //Original Fee
205     uint256 private _redisFee = _redisFeeOnSell;
206     uint256 private _taxFee = _taxFeeOnSell;
207 
208     uint256 private _previousredisFee = _redisFee;
209     uint256 private _previoustaxFee = _taxFee;
210 
211     mapping(address => bool) public bots; 
212     mapping (address => uint256) public _buyMap;
213     mapping (address => bool) public preTrader;
214     address private developmentAddress;
215     address private marketingAddress;
216 
217     IUniswapV2Router02 public uniswapV2Router;
218     address public uniswapV2Pair;
219 
220     bool private tradingOpen;
221     bool private inSwap = false;
222     bool private swapEnabled = true;
223 
224     uint256 public _maxTxAmount = 20000000 * 10**9;
225     uint256 public _maxWalletSize = 30000000 * 10**9; 
226     uint256 public _swapTokensAtAmount = 10000 * 10**9;
227 
228     struct Distribution {
229         uint256 development;
230         uint256 marketing;
231     }
232 
233     Distribution public distribution;
234 
235     event MaxTxAmountUpdated(uint256 _maxTxAmount);
236     modifier lockTheSwap {
237         inSwap = true;
238         _;
239         inSwap = false;
240     }
241 
242     constructor(address developmentAddr, address marketingAddr) {
243         developmentAddress = developmentAddr;
244         marketingAddress = marketingAddr;
245         _rOwned[_msgSender()] = _rTotal;
246 
247         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
248         uniswapV2Router = _uniswapV2Router;
249         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
250             .createPair(address(this), _uniswapV2Router.WETH());
251 
252         _isExcludedFromFee[owner()] = true;
253         _isExcludedFromFee[address(this)] = true;
254         _isExcludedFromFee[marketingAddress] = true;
255         _isExcludedFromFee[developmentAddress] = true;
256 
257         distribution = Distribution(37, 38);
258 
259         emit Transfer(address(0), _msgSender(), _tTotal);
260     }
261 
262     function name() public pure returns (string memory) {
263         return _name;
264     }
265 
266     function symbol() public pure returns (string memory) {
267         return _symbol;
268     }
269 
270     function decimals() public pure returns (uint8) {
271         return _decimals;
272     }
273 
274     function totalSupply() public pure override returns (uint256) {
275         return _tTotal;
276     }
277 
278     function balanceOf(address account) public view override returns (uint256) {
279         return tokenFromReflection(_rOwned[account]);
280     }
281 
282     function transfer(address recipient, uint256 amount)
283         public
284         override
285         returns (bool)
286     {
287         _transfer(_msgSender(), recipient, amount);
288         return true;
289     }
290 
291     function allowance(address owner, address spender)
292         public
293         view
294         override
295         returns (uint256)
296     {
297         return _allowances[owner][spender];
298     }
299 
300     function approve(address spender, uint256 amount)
301         public
302         override
303         returns (bool)
304     {
305         _approve(_msgSender(), spender, amount);
306         return true;
307     }
308 
309     function transferFrom(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) public override returns (bool) {
314         _transfer(sender, recipient, amount);
315         _approve(
316             sender,
317             _msgSender(),
318             _allowances[sender][_msgSender()].sub(
319                 amount,
320                 "ERC20: transfer amount exceeds allowance"
321             )
322         );
323         return true;
324     }
325 
326     function tokenFromReflection(uint256 rAmount)
327         private
328         view
329         returns (uint256)
330     {
331         require(
332             rAmount <= _rTotal,
333             "Amount must be less than total reflections"
334         );
335         uint256 currentRate = _getRate();
336         return rAmount.div(currentRate);
337     }
338 
339     function removeAllFee() private {
340         if (_redisFee == 0 && _taxFee == 0) return;
341 
342         _previousredisFee = _redisFee;
343         _previoustaxFee = _taxFee;
344 
345         _redisFee = 0;
346         _taxFee = 0;
347     }
348 
349     function restoreAllFee() private {
350         _redisFee = _previousredisFee;
351         _taxFee = _previoustaxFee;
352     }
353 
354     function _approve(
355         address owner,
356         address spender,
357         uint256 amount
358     ) private {
359         require(owner != address(0), "ERC20: approve from the zero address");
360         require(spender != address(0), "ERC20: approve to the zero address");
361         _allowances[owner][spender] = amount;
362         emit Approval(owner, spender, amount);
363     }
364 
365     function _transfer(
366         address from,
367         address to,
368         uint256 amount
369     ) private {
370         require(from != address(0), "ERC20: transfer from the zero address");
371         require(to != address(0), "ERC20: transfer to the zero address");
372         require(amount > 0, "Transfer amount must be greater than zero");
373 
374         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
375 
376             //Trade start check
377             if (!tradingOpen) {
378                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
379             }
380 
381             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
382             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
383 
384             if(to != uniswapV2Pair) {
385                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
386             }
387 
388             uint256 contractTokenBalance = balanceOf(address(this));
389             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
390 
391             if(contractTokenBalance >= _maxTxAmount)
392             {
393                 contractTokenBalance = _maxTxAmount;
394             }
395 
396             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
397                 swapTokensForEth(contractTokenBalance);
398                 uint256 contractETHBalance = address(this).balance;
399                 if (contractETHBalance > 0) {
400                     sendETHToFee(address(this).balance);
401                 }
402             }
403         }
404 
405         bool takeFee = true;
406 
407         //Transfer Tokens
408         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
409             takeFee = false;
410         } else {
411 
412             //Set Fee for Buys
413             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
414                 _redisFee = _redisFeeOnBuy;
415                 _taxFee = _taxFeeOnBuy;
416             }
417 
418             //Set Fee for Sells
419             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
420                 _redisFee = _redisFeeOnSell;
421                 _taxFee = _taxFeeOnSell;
422             }
423 
424         }
425 
426         _tokenTransfer(from, to, amount, takeFee);
427     }
428 
429     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
430         address[] memory path = new address[](2);
431         path[0] = address(this);
432         path[1] = uniswapV2Router.WETH();
433         _approve(address(this), address(uniswapV2Router), tokenAmount);
434         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
435             tokenAmount,
436             0,
437             path,
438             address(this),
439             block.timestamp
440         );
441     }
442 
443     function sendETHToFee(uint256 amount) private lockTheSwap {
444         uint256 distributionEth = amount;
445         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
446         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
447         payable(marketingAddress).transfer(marketingShare);
448         payable(developmentAddress).transfer(developmentShare);
449     }
450 
451     function setTrading(bool _tradingOpen) public onlyOwner {
452         tradingOpen = _tradingOpen;
453     }
454 
455     function manualswap() external {
456         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
457         uint256 contractBalance = balanceOf(address(this));
458         swapTokensForEth(contractBalance);
459     }
460 
461     function manualsend() external {
462         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
463         uint256 contractETHBalance = address(this).balance;
464         sendETHToFee(contractETHBalance);
465     }
466 
467     function blockBots(address[] memory bots_) public onlyOwner {
468         for (uint256 i = 0; i < bots_.length; i++) {
469             bots[bots_[i]] = true;
470         }
471     }
472 
473     function unblockBot(address notbot) public onlyOwner {
474         bots[notbot] = false;
475     }
476 
477     function _tokenTransfer(
478         address sender,
479         address recipient,
480         uint256 amount,
481         bool takeFee
482     ) private {
483         if (!takeFee) removeAllFee();
484         _transferStandard(sender, recipient, amount);
485         if (!takeFee) restoreAllFee();
486     }
487 
488     function _transferStandard(
489         address sender,
490         address recipient,
491         uint256 tAmount
492     ) private {
493         (
494             uint256 rAmount,
495             uint256 rTransferAmount,
496             uint256 rFee,
497             uint256 tTransferAmount,
498             uint256 tFee,
499             uint256 tTeam
500         ) = _getValues(tAmount);
501         _rOwned[sender] = _rOwned[sender].sub(rAmount);
502         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
503         _takeTeam(tTeam);
504         _reflectFee(rFee, tFee);
505         emit Transfer(sender, recipient, tTransferAmount);
506     }
507 
508     function setDistribution(uint256 development, uint256 marketing) external onlyOwner {        
509         distribution.development = development;
510         distribution.marketing = marketing;
511     }
512 
513     function _takeTeam(uint256 tTeam) private {
514         uint256 currentRate = _getRate();
515         uint256 rTeam = tTeam.mul(currentRate);
516         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
517     }
518 
519     function _reflectFee(uint256 rFee, uint256 tFee) private {
520         _rTotal = _rTotal.sub(rFee);
521         _tFeeTotal = _tFeeTotal.add(tFee);
522     }
523 
524     receive() external payable {
525     }
526 
527     function _getValues(uint256 tAmount)
528         private
529         view
530         returns (
531             uint256,
532             uint256,
533             uint256,
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
540             _getTValues(tAmount, _redisFee, _taxFee);
541         uint256 currentRate = _getRate();
542         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
543             _getRValues(tAmount, tFee, tTeam, currentRate);
544         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
545     }
546 
547     function _getTValues(
548         uint256 tAmount,
549         uint256 redisFee,
550         uint256 taxFee
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 tFee = tAmount.mul(redisFee).div(100);
561         uint256 tTeam = tAmount.mul(taxFee).div(100);
562         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
563         return (tTransferAmount, tFee, tTeam);
564     }
565 
566     function _getRValues(
567         uint256 tAmount,
568         uint256 tFee,
569         uint256 tTeam,
570         uint256 currentRate
571     )
572         private
573         pure
574         returns (
575             uint256,
576             uint256,
577             uint256
578         )
579     {
580         uint256 rAmount = tAmount.mul(currentRate);
581         uint256 rFee = tFee.mul(currentRate);
582         uint256 rTeam = tTeam.mul(currentRate);
583         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
584         return (rAmount, rTransferAmount, rFee);
585     }
586 
587     function _getRate() private view returns (uint256) {
588         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
589         return rSupply.div(tSupply);
590     }
591 
592     function _getCurrentSupply() private view returns (uint256, uint256) {
593         uint256 rSupply = _rTotal;
594         uint256 tSupply = _tTotal;
595         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
596         return (rSupply, tSupply);
597     }
598 
599     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
600         _redisFeeOnBuy = redisFeeOnBuy;
601         _redisFeeOnSell = redisFeeOnSell;
602         _taxFeeOnBuy = taxFeeOnBuy;
603         _taxFeeOnSell = taxFeeOnSell;
604     }
605 
606     //Set minimum tokens required to swap.
607     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
608         _swapTokensAtAmount = swapTokensAtAmount;
609     }
610 
611     //Set minimum tokens required to swap.
612     function toggleSwap(bool _swapEnabled) public onlyOwner {
613         swapEnabled = _swapEnabled;
614     }
615 
616     //Set maximum transaction
617     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
618         _maxTxAmount = maxTxAmount;
619     }
620 
621     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
622         _maxWalletSize = maxWalletSize;
623     }
624 
625     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
626         for(uint256 i = 0; i < accounts.length; i++) {
627             _isExcludedFromFee[accounts[i]] = excluded;
628         }
629     }
630 
631     function allowPreTrading(address[] calldata accounts) public onlyOwner {
632         for(uint256 i = 0; i < accounts.length; i++) {
633                  preTrader[accounts[i]] = true;
634         }
635     }
636 
637     function removePreTrading(address[] calldata accounts) public onlyOwner {
638         for(uint256 i = 0; i < accounts.length; i++) {
639                  delete preTrader[accounts[i]];
640         }
641     }
642 }