1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49 
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 }
64 
65 library SafeMath {
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB)
112         external
113         returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint256 amountIn,
119         uint256 amountOutMin,
120         address[] calldata path,
121         address to,
122         uint256 deadline
123     ) external;
124 
125     function factory() external pure returns (address);
126 
127     function WETH() external pure returns (address);
128 
129     function addLiquidityETH(
130         address token,
131         uint256 amountTokenDesired,
132         uint256 amountTokenMin,
133         uint256 amountETHMin,
134         address to,
135         uint256 deadline
136     )
137         external
138         payable
139         returns (
140             uint256 amountToken,
141             uint256 amountETH,
142             uint256 liquidity
143         );
144 }
145 
146 contract SatoruInu is Context, IERC20, Ownable {
147     
148     using SafeMath for uint256;
149 
150     string private constant _name = "Satoru Inu";
151     string private constant _symbol = "SATO";
152     uint8 private constant _decimals = 9;
153 
154     mapping(address => uint256) private _rOwned;
155     mapping(address => uint256) private _tOwned;
156     mapping(address => mapping(address => uint256)) private _allowances;
157     mapping(address => bool) private _isExcludedFromFee;
158     uint256 private constant MAX = ~uint256(0);
159     uint256 private constant _tTotal = 100000000000000 * 10**9;
160     uint256 private _rTotal = (MAX - (MAX % _tTotal));
161     uint256 private _tFeeTotal;
162     
163     //Buy Fee
164     uint256 private _redisFeeOnBuy = 2;
165     uint256 private _taxFeeOnBuy = 8;
166     
167     //Sell Fee
168     uint256 private _redisFeeOnSell = 2;
169     uint256 private _taxFeeOnSell = 8;
170     
171     //Original Fee
172     uint256 private _redisFee = _redisFeeOnSell;
173     uint256 private _taxFee = _taxFeeOnSell;
174     
175     uint256 private _previousredisFee = _redisFee;
176     uint256 private _previoustaxFee = _taxFee;
177     
178     mapping(address => bool) public bots;
179     mapping (address => bool) public preTrader;
180     mapping(address => uint256) private cooldown;
181     
182     address payable private _developmentAddress = payable(0x19fa7E3c7d3ECa554bB4d209B918D2359270b361);
183     address payable private _marketingAddress = payable(0x19fa7E3c7d3ECa554bB4d209B918D2359270b361);
184     
185     IUniswapV2Router02 public uniswapV2Router;
186     address public uniswapV2Pair;
187     
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191     
192     uint256 public _maxTxAmount = 500000000000 * 10**9; //0.5
193     uint256 public _maxWalletSize = 2000000000000 * 10**9; //2
194     uint256 public _swapTokensAtAmount = 10000000000 * 10**9; //0.1
195 
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor() {
204         
205         _rOwned[_msgSender()] = _rTotal;
206         
207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
208         uniswapV2Router = _uniswapV2Router;
209         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
210             .createPair(address(this), _uniswapV2Router.WETH());
211 
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[_developmentAddress] = true;
215         _isExcludedFromFee[_marketingAddress] = true;
216         
217         preTrader[owner()] = true;
218         
219         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
220         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
221         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
222         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
223         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
224         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
225         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
226         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
227         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
228         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
229         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
230         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
231         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
232         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
233         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
234         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
235         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
236         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
237         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
238         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
239         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
240         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
241         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
242         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
243         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
244         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
245         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
246         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
247         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
248         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
249         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
250         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
251         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
252         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
253 
254         emit Transfer(address(0), _msgSender(), _tTotal);
255     }
256 
257     function name() public pure returns (string memory) {
258         return _name;
259     }
260 
261     function symbol() public pure returns (string memory) {
262         return _symbol;
263     }
264 
265     function decimals() public pure returns (uint8) {
266         return _decimals;
267     }
268 
269     function totalSupply() public pure override returns (uint256) {
270         return _tTotal;
271     }
272 
273     function balanceOf(address account) public view override returns (uint256) {
274         return tokenFromReflection(_rOwned[account]);
275     }
276 
277     function transfer(address recipient, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _transfer(_msgSender(), recipient, amount);
283         return true;
284     }
285 
286     function allowance(address owner, address spender)
287         public
288         view
289         override
290         returns (uint256)
291     {
292         return _allowances[owner][spender];
293     }
294 
295     function approve(address spender, uint256 amount)
296         public
297         override
298         returns (bool)
299     {
300         _approve(_msgSender(), spender, amount);
301         return true;
302     }
303 
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(
311             sender,
312             _msgSender(),
313             _allowances[sender][_msgSender()].sub(
314                 amount,
315                 "ERC20: transfer amount exceeds allowance"
316             )
317         );
318         return true;
319     }
320 
321     function tokenFromReflection(uint256 rAmount)
322         private
323         view
324         returns (uint256)
325     {
326         require(
327             rAmount <= _rTotal,
328             "Amount must be less than total reflections"
329         );
330         uint256 currentRate = _getRate();
331         return rAmount.div(currentRate);
332     }
333 
334     function removeAllFee() private {
335         if (_redisFee == 0 && _taxFee == 0) return;
336     
337         _previousredisFee = _redisFee;
338         _previoustaxFee = _taxFee;
339         
340         _redisFee = 0;
341         _taxFee = 0;
342     }
343 
344     function restoreAllFee() private {
345         _redisFee = _previousredisFee;
346         _taxFee = _previoustaxFee;
347     }
348 
349     function _approve(
350         address owner,
351         address spender,
352         uint256 amount
353     ) private {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360     function _transfer(
361         address from,
362         address to,
363         uint256 amount
364     ) private {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367         require(amount > 0, "Transfer amount must be greater than zero");
368 
369         if (from != owner() && to != owner()) {
370             
371             //Trade start check
372             if (!tradingOpen) {
373                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
374             }
375               
376             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
377             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
378             
379             if(to != uniswapV2Pair) {
380                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
381             }
382             
383             uint256 contractTokenBalance = balanceOf(address(this));
384             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
385 
386             if(contractTokenBalance >= _maxTxAmount)
387             {
388                 contractTokenBalance = _maxTxAmount;
389             }
390             
391             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
392                 swapTokensForEth(contractTokenBalance);
393                 uint256 contractETHBalance = address(this).balance;
394                 if (contractETHBalance > 0) {
395                     sendETHToFee(address(this).balance);
396                 }
397             }
398         }
399         
400         bool takeFee = true;
401 
402         //Transfer Tokens
403         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
404             takeFee = false;
405         } else {
406             
407             //Set Fee for Buys
408             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
409                 _redisFee = _redisFeeOnBuy;
410                 _taxFee = _taxFeeOnBuy;
411             }
412     
413             //Set Fee for Sells
414             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
415                 _redisFee = _redisFeeOnSell;
416                 _taxFee = _taxFeeOnSell;
417             }
418             
419         }
420 
421         _tokenTransfer(from, to, amount, takeFee);
422     }
423 
424     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
425         address[] memory path = new address[](2);
426         path[0] = address(this);
427         path[1] = uniswapV2Router.WETH();
428         _approve(address(this), address(uniswapV2Router), tokenAmount);
429         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
430             tokenAmount,
431             0,
432             path,
433             address(this),
434             block.timestamp
435         );
436     }
437 
438     function sendETHToFee(uint256 amount) private {
439         _developmentAddress.transfer(amount.div(2));
440         _marketingAddress.transfer(amount.div(2));
441     }
442 
443     function setTrading(bool _tradingOpen) public onlyOwner {
444         tradingOpen = _tradingOpen;
445     }
446 
447     function manualswap() external {
448         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
449         uint256 contractBalance = balanceOf(address(this));
450         swapTokensForEth(contractBalance);
451     }
452 
453     function manualsend() external {
454         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
455         uint256 contractETHBalance = address(this).balance;
456         sendETHToFee(contractETHBalance);
457     }
458 
459     function blockBots(address[] memory bots_) public onlyOwner {
460         for (uint256 i = 0; i < bots_.length; i++) {
461             bots[bots_[i]] = true;
462         }
463     }
464 
465     function unblockBot(address notbot) public onlyOwner {
466         bots[notbot] = false;
467     }
468 
469     function _tokenTransfer(
470         address sender,
471         address recipient,
472         uint256 amount,
473         bool takeFee
474     ) private {
475         if (!takeFee) removeAllFee();
476         _transferStandard(sender, recipient, amount);
477         if (!takeFee) restoreAllFee();
478     }
479 
480     function _transferStandard(
481         address sender,
482         address recipient,
483         uint256 tAmount
484     ) private {
485         (
486             uint256 rAmount,
487             uint256 rTransferAmount,
488             uint256 rFee,
489             uint256 tTransferAmount,
490             uint256 tFee,
491             uint256 tTeam
492         ) = _getValues(tAmount);
493         _rOwned[sender] = _rOwned[sender].sub(rAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
495         _takeTeam(tTeam);
496         _reflectFee(rFee, tFee);
497         emit Transfer(sender, recipient, tTransferAmount);
498     }
499 
500     function _takeTeam(uint256 tTeam) private {
501         uint256 currentRate = _getRate();
502         uint256 rTeam = tTeam.mul(currentRate);
503         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
504     }
505 
506     function _reflectFee(uint256 rFee, uint256 tFee) private {
507         _rTotal = _rTotal.sub(rFee);
508         _tFeeTotal = _tFeeTotal.add(tFee);
509     }
510 
511     receive() external payable {}
512 
513     function _getValues(uint256 tAmount)
514         private
515         view
516         returns (
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
526             _getTValues(tAmount, _redisFee, _taxFee);
527         uint256 currentRate = _getRate();
528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
529             _getRValues(tAmount, tFee, tTeam, currentRate);
530         
531         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
532     }
533 
534     function _getTValues(
535         uint256 tAmount,
536         uint256 redisFee,
537         uint256 taxFee
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 tFee = tAmount.mul(redisFee).div(100);
548         uint256 tTeam = tAmount.mul(taxFee).div(100);
549         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
550 
551         return (tTransferAmount, tFee, tTeam);
552     }
553 
554     function _getRValues(
555         uint256 tAmount,
556         uint256 tFee,
557         uint256 tTeam,
558         uint256 currentRate
559     )
560         private
561         pure
562         returns (
563             uint256,
564             uint256,
565             uint256
566         )
567     {
568         uint256 rAmount = tAmount.mul(currentRate);
569         uint256 rFee = tFee.mul(currentRate);
570         uint256 rTeam = tTeam.mul(currentRate);
571         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
572 
573         return (rAmount, rTransferAmount, rFee);
574     }
575 
576     function _getRate() private view returns (uint256) {
577         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
578 
579         return rSupply.div(tSupply);
580     }
581 
582     function _getCurrentSupply() private view returns (uint256, uint256) {
583         uint256 rSupply = _rTotal;
584         uint256 tSupply = _tTotal;
585         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
586     
587         return (rSupply, tSupply);
588     }
589     
590     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
591         _redisFeeOnBuy = redisFeeOnBuy;
592         _redisFeeOnSell = redisFeeOnSell;
593         
594         _taxFeeOnBuy = taxFeeOnBuy;
595         _taxFeeOnSell = taxFeeOnSell;
596     }
597 
598     //Set minimum tokens required to swap.
599     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
600         _swapTokensAtAmount = swapTokensAtAmount;
601     }
602     
603     //Set minimum tokens required to swap.
604     function toggleSwap(bool _swapEnabled) public onlyOwner {
605         swapEnabled = _swapEnabled;
606     }
607     
608     //Set MAx transaction
609     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
610         _maxTxAmount = maxTxAmount;
611     }
612     
613     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
614         _maxWalletSize = maxWalletSize;
615     }
616  
617     function allowPreTrading(address account, bool allowed) public onlyOwner {
618         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
619         preTrader[account] = allowed;
620     }
621 }