1 /*
2 
3 Gogeta Inu (GOGETA)
4 
5 Official Links:
6 
7 Telegram:
8 http://t.me/GogetaInu
9 
10 Website: 
11 https://gogetainu.io/
12 
13 Twitter:
14 https://twitter.com/GogetaInu
15 
16 Reddit:
17 https://www.reddit.com/user/GogetaInuETH/
18 
19 */
20 
21 // SPDX-License-Identifier: Unlicensed
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 }
55 
56 contract Ownable is Context {
57     address private _owner;
58     address private _previousOwner;
59     event OwnershipTransferred(
60         address indexed previousOwner,
61         address indexed newOwner
62     );
63 
64     constructor() {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 contract GogetaInu is Context, IERC20, Ownable {
167     
168     using SafeMath for uint256;
169 
170     string private constant _name = "Gogeta Inu";
171     string private constant _symbol = "GOGETA";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 100000000000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     
183     //Buy Fee
184     uint256 private _redisFeeOnBuy = 2;
185     uint256 private _taxFeeOnBuy = 6;
186     
187     //Sell Fee
188     uint256 private _redisFeeOnSell = 2;
189     uint256 private _taxFeeOnSell = 6;
190     
191     //Original Fee
192     uint256 private _redisFee = _redisFeeOnSell;
193     uint256 private _taxFee = _taxFeeOnSell;
194     
195     uint256 private _previousredisFee = _redisFee;
196     uint256 private _previoustaxFee = _taxFee;
197     
198     mapping(address => bool) public bots;
199     mapping (address => bool) public preTrader;
200     mapping(address => uint256) private cooldown;
201     
202     address payable private _developmentAddress = payable(0xC5945d3C1639d3Eab6184646c524598598A8b8ff);
203     address payable private _marketingAddress = payable(0x4B65D413E373F878F07Aff462416BE6b7d7886Ea);
204     
205     IUniswapV2Router02 public uniswapV2Router;
206     address public uniswapV2Pair;
207     
208     bool private tradingOpen;
209     bool private inSwap = false;
210     bool private swapEnabled = true;
211     
212     uint256 public _maxTxAmount = 750000000000 * 10**9; //0.75
213     uint256 public _maxWalletSize = 1000000000000 * 10**9; //1
214     uint256 public _swapTokensAtAmount = 10000000000 * 10**9; //0.1
215 
216     event MaxTxAmountUpdated(uint256 _maxTxAmount);
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222 
223     constructor() {
224         
225         _rOwned[_msgSender()] = _rTotal;
226         
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231 
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[_developmentAddress] = true;
235         _isExcludedFromFee[_marketingAddress] = true;
236         
237         preTrader[owner()] = true;
238         
239         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
240         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
241         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
242         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
243         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
244         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
245         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
246         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
247         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
248         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
249         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
250         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
251         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
252         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
253         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
254         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
255         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
256         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
257         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
258         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
259         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
260         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
261         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
262         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
263         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
264         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
265         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
266         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
267         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
268         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
269         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
270         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
271         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
272         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
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
424             takeFee = false;
425         } else {
426             
427             //Set Fee for Buys
428             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
429                 _redisFee = _redisFeeOnBuy;
430                 _taxFee = _taxFeeOnBuy;
431             }
432     
433             //Set Fee for Sells
434             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
435                 _redisFee = _redisFeeOnSell;
436                 _taxFee = _taxFeeOnSell;
437             }
438             
439         }
440 
441         _tokenTransfer(from, to, amount, takeFee);
442     }
443 
444     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
445         address[] memory path = new address[](2);
446         path[0] = address(this);
447         path[1] = uniswapV2Router.WETH();
448         _approve(address(this), address(uniswapV2Router), tokenAmount);
449         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
450             tokenAmount,
451             0,
452             path,
453             address(this),
454             block.timestamp
455         );
456     }
457 
458     function sendETHToFee(uint256 amount) private {
459         _developmentAddress.transfer(amount.div(2));
460         _marketingAddress.transfer(amount.div(2));
461     }
462 
463     function setTrading(bool _tradingOpen) public onlyOwner {
464         tradingOpen = _tradingOpen;
465     }
466 
467     function manualswap() external {
468         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
469         uint256 contractBalance = balanceOf(address(this));
470         swapTokensForEth(contractBalance);
471     }
472 
473     function manualsend() external {
474         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
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
628     //Set MAx transaction
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