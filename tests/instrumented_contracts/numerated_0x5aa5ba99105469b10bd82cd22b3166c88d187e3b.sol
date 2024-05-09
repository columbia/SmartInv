1 /*
2 
3 Frieza Inu (FRINU)
4 
5 Official Links:
6 
7 Telegram:
8 https://t.me/FriezaInuETH
9 
10 
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
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
158 contract FriezaInu is Context, IERC20, Ownable {
159     
160     using SafeMath for uint256;
161 
162     string private constant _name = "Frieza Inu";
163     string private constant _symbol = "FRINU";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 100000000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 1;
177     uint256 private _taxFeeOnBuy = 8;
178     
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 1;
181     uint256 private _taxFeeOnSell = 8;
182     
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186     
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189     
190     mapping(address => bool) public bots;
191     mapping (address => bool) public preTrader;
192     mapping(address => uint256) private cooldown;
193     
194     address payable private _marketingAddress = payable(0xD293AE87937f46ad60F57E6dEc75Ce41b6b4E0FE);
195     
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198     
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202     
203     uint256 public _maxTxAmount = 750000000000 * 10**9; //0.75
204     uint256 public _maxWalletSize = 1500000000000 * 10**9; //1.5
205     uint256 public _swapTokensAtAmount = 10000000000 * 10**9; //0.1
206 
207     event MaxTxAmountUpdated(uint256 _maxTxAmount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213 
214     constructor() {
215         
216         _rOwned[_msgSender()] = _rTotal;
217         
218         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
219         uniswapV2Router = _uniswapV2Router;
220         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
221             .createPair(address(this), _uniswapV2Router.WETH());
222 
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[address(this)] = true;
225         _isExcludedFromFee[_marketingAddress] = true;
226         
227         preTrader[owner()] = true;
228         
229         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
230         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
231         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
232         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
233         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
234         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
235         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
236         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
237         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
238         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
239         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
240         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
241         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
242         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
243         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
244         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
245         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
246         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
247         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
248         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
249         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
250         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
251         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
252         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
253         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
254         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
255         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
256         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
257         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
258         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
259         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
260         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
261         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
262 
263         emit Transfer(address(0), _msgSender(), _tTotal);
264     }
265 
266     function name() public pure returns (string memory) {
267         return _name;
268     }
269 
270     function symbol() public pure returns (string memory) {
271         return _symbol;
272     }
273 
274     function decimals() public pure returns (uint8) {
275         return _decimals;
276     }
277 
278     function totalSupply() public pure override returns (uint256) {
279         return _tTotal;
280     }
281 
282     function balanceOf(address account) public view override returns (uint256) {
283         return tokenFromReflection(_rOwned[account]);
284     }
285 
286     function transfer(address recipient, uint256 amount)
287         public
288         override
289         returns (bool)
290     {
291         _transfer(_msgSender(), recipient, amount);
292         return true;
293     }
294 
295     function allowance(address owner, address spender)
296         public
297         view
298         override
299         returns (uint256)
300     {
301         return _allowances[owner][spender];
302     }
303 
304     function approve(address spender, uint256 amount)
305         public
306         override
307         returns (bool)
308     {
309         _approve(_msgSender(), spender, amount);
310         return true;
311     }
312 
313     function transferFrom(
314         address sender,
315         address recipient,
316         uint256 amount
317     ) public override returns (bool) {
318         _transfer(sender, recipient, amount);
319         _approve(
320             sender,
321             _msgSender(),
322             _allowances[sender][_msgSender()].sub(
323                 amount,
324                 "ERC20: transfer amount exceeds allowance"
325             )
326         );
327         return true;
328     }
329 
330     function tokenFromReflection(uint256 rAmount)
331         private
332         view
333         returns (uint256)
334     {
335         require(
336             rAmount <= _rTotal,
337             "Amount must be less than total reflections"
338         );
339         uint256 currentRate = _getRate();
340         return rAmount.div(currentRate);
341     }
342 
343     function removeAllFee() private {
344         if (_redisFee == 0 && _taxFee == 0) return;
345     
346         _previousredisFee = _redisFee;
347         _previoustaxFee = _taxFee;
348         
349         _redisFee = 0;
350         _taxFee = 0;
351     }
352 
353     function restoreAllFee() private {
354         _redisFee = _previousredisFee;
355         _taxFee = _previoustaxFee;
356     }
357 
358     function _approve(
359         address owner,
360         address spender,
361         uint256 amount
362     ) private {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365         _allowances[owner][spender] = amount;
366         emit Approval(owner, spender, amount);
367     }
368 
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) private {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376         require(amount > 0, "Transfer amount must be greater than zero");
377 
378         if (from != owner() && to != owner()) {
379             
380             //Trade start check
381             if (!tradingOpen) {
382                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
383             }
384               
385             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
386             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
387             
388             if(to != uniswapV2Pair) {
389                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
390             }
391             
392             uint256 contractTokenBalance = balanceOf(address(this));
393             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
394 
395             if(contractTokenBalance >= _maxTxAmount)
396             {
397                 contractTokenBalance = _maxTxAmount;
398             }
399             
400             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
401                 swapTokensForEth(contractTokenBalance);
402                 uint256 contractETHBalance = address(this).balance;
403                 if (contractETHBalance > 0) {
404                     sendETHToFee(address(this).balance);
405                 }
406             }
407         }
408         
409         bool takeFee = true;
410 
411         //Transfer Tokens
412         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
413             takeFee = false;
414         } else {
415             
416             //Set Fee for Buys
417             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
418                 _redisFee = _redisFeeOnBuy;
419                 _taxFee = _taxFeeOnBuy;
420             }
421     
422             //Set Fee for Sells
423             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
424                 _redisFee = _redisFeeOnSell;
425                 _taxFee = _taxFeeOnSell;
426             }
427             
428         }
429 
430         _tokenTransfer(from, to, amount, takeFee);
431     }
432 
433     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
434         address[] memory path = new address[](2);
435         path[0] = address(this);
436         path[1] = uniswapV2Router.WETH();
437         _approve(address(this), address(uniswapV2Router), tokenAmount);
438         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
439             tokenAmount,
440             0,
441             path,
442             address(this),
443             block.timestamp
444         );
445     }
446 
447     function sendETHToFee(uint256 amount) private {
448         _marketingAddress.transfer(amount);
449     }
450 
451     function setTrading(bool _tradingOpen) public onlyOwner {
452         tradingOpen = _tradingOpen;
453     }
454 
455     function manualswap() external {
456         require(_msgSender() == _marketingAddress);
457         uint256 contractBalance = balanceOf(address(this));
458         swapTokensForEth(contractBalance);
459     }
460 
461     function manualsend() external {
462         require(_msgSender() == _marketingAddress);
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
508     function _takeTeam(uint256 tTeam) private {
509         uint256 currentRate = _getRate();
510         uint256 rTeam = tTeam.mul(currentRate);
511         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
512     }
513 
514     function _reflectFee(uint256 rFee, uint256 tFee) private {
515         _rTotal = _rTotal.sub(rFee);
516         _tFeeTotal = _tFeeTotal.add(tFee);
517     }
518 
519     receive() external payable {}
520 
521     function _getValues(uint256 tAmount)
522         private
523         view
524         returns (
525             uint256,
526             uint256,
527             uint256,
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
534             _getTValues(tAmount, _redisFee, _taxFee);
535         uint256 currentRate = _getRate();
536         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
537             _getRValues(tAmount, tFee, tTeam, currentRate);
538         
539         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
540     }
541 
542     function _getTValues(
543         uint256 tAmount,
544         uint256 redisFee,
545         uint256 taxFee
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 tFee = tAmount.mul(redisFee).div(100);
556         uint256 tTeam = tAmount.mul(taxFee).div(100);
557         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
558 
559         return (tTransferAmount, tFee, tTeam);
560     }
561 
562     function _getRValues(
563         uint256 tAmount,
564         uint256 tFee,
565         uint256 tTeam,
566         uint256 currentRate
567     )
568         private
569         pure
570         returns (
571             uint256,
572             uint256,
573             uint256
574         )
575     {
576         uint256 rAmount = tAmount.mul(currentRate);
577         uint256 rFee = tFee.mul(currentRate);
578         uint256 rTeam = tTeam.mul(currentRate);
579         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
580 
581         return (rAmount, rTransferAmount, rFee);
582     }
583 
584     function _getRate() private view returns (uint256) {
585         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
586 
587         return rSupply.div(tSupply);
588     }
589 
590     function _getCurrentSupply() private view returns (uint256, uint256) {
591         uint256 rSupply = _rTotal;
592         uint256 tSupply = _tTotal;
593         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
594     
595         return (rSupply, tSupply);
596     }
597     
598     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
599         _redisFeeOnBuy = redisFeeOnBuy;
600         _redisFeeOnSell = redisFeeOnSell;
601         
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
616     //Set MAx transaction
617     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
618         _maxTxAmount = maxTxAmount;
619     }
620     
621     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
622         _maxWalletSize = maxWalletSize;
623     }
624  
625     function allowPreTrading(address account, bool allowed) public onlyOwner {
626         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
627         preTrader[account] = allowed;
628     }
629 }