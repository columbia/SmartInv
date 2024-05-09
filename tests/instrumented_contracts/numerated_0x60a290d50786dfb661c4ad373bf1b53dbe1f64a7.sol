1 /**
2 https://rsa4096.com/
3 
4 -----BEGIN PGP MESSAGE-----
5 
6 hQIMA9t9bEcM0+6VAQ/9F1MBdDlw3jfenfvx9fyvGWiQVRdaZoF/+cwkaA0U1NVZ
7 LBkK9S4WNoVCJ2F06r84yh5P2hghhJXnbW6VCas+rUoit5X52Uj0EehlA/autYGK
8 vrs3CiZ2I3F/wmYTIU40KEJGxVeP6iyXqmv893RLno420LDQNmNe+A5puHFBI6Cz
9 Obz7wMcp1je7vgKwGYCHks77MPGTSLtkKR38b5J008Z0srg77WkjhEXZ6c6/uvLi
10 s2drBFUth8vdJLN8B19o4ad1NkleQIyRePv7wofNVuidLw6toBRgVbjZL4RLzZUn
11 Yn51zbe06ztVpfo3Xp1nedGUcQvmXTlScT/duyjwe5OYQRrNVIIXO5Esy0Sn30w5
12 KC2HnZ/jZArASoN87RKaVL1NGOxpvWBl+344ooNsODtfvwYz3dkQRvhimzMLmxdd
13 b2ce+PZaEoY5NjuZOkz/R/p7UyYY8KYARzpu2YYKzYFWHud7Ch6A7cf6+u4g87lq
14 G8gUsp02V3NqyIZc6HF1slpEPeTTUbe+JdANgBRRfptS4ZuBPqVMWoDGgkmqAFYw
15 USOiXt5ywg2u5B3+/deSmFAyYUMx5/OX489j2dRkuQ99SQzrogKZJsG01mbeNbHI
16 bS/oOGubKvd6HTeKAUjwLV9fH+hPRG5X6sgCFde+VDtcszkqGImpNbTKLVmhv1vS
17 6QHeBhwXo2mPsT8Q0SNmD3T8y9+YczuxrIP0w/4TpcNySTrv1YUfmlhKo0a2Y9He
18 sDxU/9kaN88NbAFu4UqgdA0PoLmIENZdbg0zRMfO2MdO4nYL4vITHOsyCt7RW26P
19 OLqiScvCPFBYuddoRawQmR/sbXol52ceAK36fU7nXoXWJys2Swz3OGh3YULxIZva
20 Hv9n7Cvy5WJUnxmnoNJxlK5XUhtqvvBPsSgqNJLREALfiVGDDzKyNhASYFt5bYry
21 pEXpq34HLu9Xpj+Rbwy5SglVr03l+0qsknNJQAJXN6NffP1Tn43nca32ejlaEyoc
22 OMJS0xgbKoIlQpSzPT4mr+eJ4Tzwv2QYW1O78DCeISLbltvJ/fqTb1fcfIicZCyy
23 Y5CqbgVzEEX7dtxlrCQ6TZtEkNltcMr1MQGmlwJzPB9Kc8GSUBZ8RG8n5+BQridl
24 ZST5W35RYVepqPVCZBS5mxYUqC73wHB0+1FhGgyjidQPOBqNRJT1b7bzSp4cAnce
25 MdO3nTSb8dChF7h+XNHd73Lmckg0Yc7I15+ezn8KXU9uxH/3eSh5hpnVCStXLMaV
26 0QWgugcfQVOwexzBdT14nlZwCjFgCwDcToSnUj4db15wzTwGbw5TUo8q3xXVWLR+
27 G9wAt/eptuLZZDcBZ/iXRHEJGKNRY3YpCnFaN50IRgYmwCu+nE4cwuiEYnvhsxB7
28 1PchAT3sB1R7hNSPnSyaTnOCblp+LX/3gWsExlDqXyO6L/XLKr87uFPU+z5+1WbD
29 TswfpmyDlpkfvWrumosjWdHQ0vxKBF9GS365ya3/YtXHjcuFJX75Lv7n/2PR99zl
30 WGYqPFWz8wAFWWNVXU10i0C6+cKTwUqLj+vq0VV0/B9DJaVeFYIinn5h2MAUttHT
31 92neJ3YRzKN6hthD3/NoQ8HP6zSptJPt6D3V1MafV1Rax5JiX+fpHX5mPz3AtK8D
32 vDenHHvOzOcJu2dVo7koNEy2WxDCqF/zn1LawO+D
33 =MAO0
34 -----END PGP MESSAGE-----
35 */
36 
37 // SPDX-License-Identifier: Unlicensed
38 
39 pragma solidity ^0.8.9;
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49 
50     function balanceOf(address account) external view returns (uint256);
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(
66         address indexed owner,
67         address indexed spender,
68         uint256 value
69     );
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     address private _previousOwner;
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80     constructor() {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 
106 }
107 
108 library SafeMath {
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112         return c;
113     }
114 
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     function sub(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126         return c;
127     }
128 
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         if (a == 0) {
131             return 0;
132         }
133         uint256 c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135         return c;
136     }
137 
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     function div(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         return c;
150     }
151 }
152 
153 interface IUniswapV2Factory {
154     function createPair(address tokenA, address tokenB)
155         external
156         returns (address pair);
157 }
158 
159 interface IUniswapV2Router02 {
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint256 amountIn,
162         uint256 amountOutMin,
163         address[] calldata path,
164         address to,
165         uint256 deadline
166     ) external;
167 
168     function factory() external pure returns (address);
169 
170     function WETH() external pure returns (address);
171 
172     function addLiquidityETH(
173         address token,
174         uint256 amountTokenDesired,
175         uint256 amountTokenMin,
176         uint256 amountETHMin,
177         address to,
178         uint256 deadline
179     )
180         external
181         payable
182         returns (
183             uint256 amountToken,
184             uint256 amountETH,
185             uint256 liquidity
186         );
187 }
188 
189 contract PGP is Context, IERC20, Ownable { 
190 
191     using SafeMath for uint256;
192 
193     string private constant _name = "Pretty Good Privacy";
194     string private constant _symbol = "PGP";
195     uint8 private constant _decimals = 9;
196 
197     mapping(address => uint256) private _rOwned;
198     mapping(address => uint256) private _tOwned;
199     mapping(address => mapping(address => uint256)) private _allowances;
200     mapping(address => bool) private _isExcludedFromFee;
201     uint256 private constant MAX = ~uint256(0);
202     uint256 private constant _tTotal = 4096 * 10**9;
203     uint256 private _rTotal = (MAX - (MAX % _tTotal));
204     uint256 private _tFeeTotal;
205     uint256 private _redisFeeOnBuy = 0;
206     uint256 private _taxFeeOnBuy = 0;
207     uint256 private _redisFeeOnSell = 0;
208     uint256 private _taxFeeOnSell = 10;
209 
210     //Original Fee
211     uint256 private _redisFee = _redisFeeOnSell;
212     uint256 private _taxFee = _taxFeeOnSell;
213 
214     uint256 private _previousredisFee = _redisFee;
215     uint256 private _previoustaxFee = _taxFee;
216 
217     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
218     address payable private _developmentAddress = payable(0x420421Ee60aae3F93873B0168EC695A365E52b12);
219     address payable private _marketingAddress = payable(0x420421Ee60aae3F93873B0168EC695A365E52b12);
220     IUniswapV2Router02 public uniswapV2Router;
221     address public uniswapV2Pair;
222 
223     bool private tradingOpen;
224     bool private inSwap = false;
225     bool private swapEnabled = true;
226 
227     uint256 public _maxTxAmount = 82 * 10**9; //2%
228     uint256 public _maxWalletSize = 82 * 10**9; //2%
229     uint256 public _swapTokensAtAmount = 4 * 10**9; //.1%
230 
231     event MaxTxAmountUpdated(uint256 _maxTxAmount);
232     modifier lockTheSwap {
233         inSwap = true;
234         _;
235         inSwap = false;
236     }
237 
238     constructor() {
239 
240         _rOwned[_msgSender()] = _rTotal;
241 
242         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
243         uniswapV2Router = _uniswapV2Router;
244         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
245             .createPair(address(this), _uniswapV2Router.WETH());
246 
247         _isExcludedFromFee[owner()] = true;
248         _isExcludedFromFee[address(this)] = true;
249         _isExcludedFromFee[_developmentAddress] = true;
250         _isExcludedFromFee[_marketingAddress] = true;
251 
252         emit Transfer(address(0), _msgSender(), _tTotal);
253     }
254 
255     function name() public pure returns (string memory) {
256         return _name;
257     }
258 
259     function symbol() public pure returns (string memory) {
260         return _symbol;
261     }
262 
263     function decimals() public pure returns (uint8) {
264         return _decimals;
265     }
266 
267     function totalSupply() public pure override returns (uint256) {
268         return _tTotal;
269     }
270 
271     function balanceOf(address account) public view override returns (uint256) {
272         return tokenFromReflection(_rOwned[account]);
273     }
274 
275     function transfer(address recipient, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _transfer(_msgSender(), recipient, amount);
281         return true;
282     }
283 
284     function allowance(address owner, address spender)
285         public
286         view
287         override
288         returns (uint256)
289     {
290         return _allowances[owner][spender];
291     }
292 
293     function approve(address spender, uint256 amount)
294         public
295         override
296         returns (bool)
297     {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(
309             sender,
310             _msgSender(),
311             _allowances[sender][_msgSender()].sub(
312                 amount,
313                 "ERC20: transfer amount exceeds allowance"
314             )
315         );
316         return true;
317     }
318 
319     function tokenFromReflection(uint256 rAmount)
320         private
321         view
322         returns (uint256)
323     {
324         require(
325             rAmount <= _rTotal,
326             "Amount must be less than total reflections"
327         );
328         uint256 currentRate = _getRate();
329         return rAmount.div(currentRate);
330     }
331 
332     function removeAllFee() private {
333         if (_redisFee == 0 && _taxFee == 0) return;
334 
335         _previousredisFee = _redisFee;
336         _previoustaxFee = _taxFee;
337 
338         _redisFee = 0;
339         _taxFee = 0;
340     }
341 
342     function restoreAllFee() private {
343         _redisFee = _previousredisFee;
344         _taxFee = _previoustaxFee;
345     }
346 
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) private {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) private {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365         require(amount > 0, "Transfer amount must be greater than zero");
366 
367         if (from != owner() && to != owner()) {
368 
369             //Trade start check
370             if (!tradingOpen) {
371                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
372             }
373 
374             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
375             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
376 
377             if(to != uniswapV2Pair) {
378                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
379             }
380 
381             uint256 contractTokenBalance = balanceOf(address(this));
382             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
383 
384             if(contractTokenBalance >= _maxTxAmount)
385             {
386                 contractTokenBalance = _maxTxAmount;
387             }
388 
389             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
390                 swapTokensForEth(contractTokenBalance);
391                 uint256 contractETHBalance = address(this).balance;
392                 if (contractETHBalance > 0) {
393                     sendETHToFee(address(this).balance);
394                 }
395             }
396         }
397 
398         bool takeFee = true;
399 
400         //Transfer Tokens
401         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
402             takeFee = false;
403         } else {
404 
405             //Set Fee for Buys
406             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnBuy;
408                 _taxFee = _taxFeeOnBuy;
409             }
410 
411             //Set Fee for Sells
412             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
413                 _redisFee = _redisFeeOnSell;
414                 _taxFee = _taxFeeOnSell;
415             }
416 
417         }
418 
419         _tokenTransfer(from, to, amount, takeFee);
420     }
421 
422     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
423         address[] memory path = new address[](2);
424         path[0] = address(this);
425         path[1] = uniswapV2Router.WETH();
426         _approve(address(this), address(uniswapV2Router), tokenAmount);
427         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
428             tokenAmount,
429             0,
430             path,
431             address(this),
432             block.timestamp
433         );
434     }
435 
436     function sendETHToFee(uint256 amount) private {
437         _marketingAddress.transfer(amount);
438     }
439 
440     function setTrading(bool _tradingOpen) public onlyOwner {
441         tradingOpen = _tradingOpen;
442     }
443 
444     function manualswap() external {
445         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
446         uint256 contractBalance = balanceOf(address(this));
447         swapTokensForEth(contractBalance);
448     }
449 
450     function manualsend() external {
451         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
452         uint256 contractETHBalance = address(this).balance;
453         sendETHToFee(contractETHBalance);
454     }
455 
456     function blockBots(address[] memory bots_) public onlyOwner {
457         for (uint256 i = 0; i < bots_.length; i++) {
458             bots[bots_[i]] = true;
459         }
460     }
461 
462     function unblockBot(address notbot) public onlyOwner {
463         bots[notbot] = false;
464     }
465 
466     function _tokenTransfer(
467         address sender,
468         address recipient,
469         uint256 amount,
470         bool takeFee
471     ) private {
472         if (!takeFee) removeAllFee();
473         _transferStandard(sender, recipient, amount);
474         if (!takeFee) restoreAllFee();
475     }
476 
477     function _transferStandard(
478         address sender,
479         address recipient,
480         uint256 tAmount
481     ) private {
482         (
483             uint256 rAmount,
484             uint256 rTransferAmount,
485             uint256 rFee,
486             uint256 tTransferAmount,
487             uint256 tFee,
488             uint256 tTeam
489         ) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
492         _takeTeam(tTeam);
493         _reflectFee(rFee, tFee);
494         emit Transfer(sender, recipient, tTransferAmount);
495     }
496 
497     function _takeTeam(uint256 tTeam) private {
498         uint256 currentRate = _getRate();
499         uint256 rTeam = tTeam.mul(currentRate);
500         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
501     }
502 
503     function _reflectFee(uint256 rFee, uint256 tFee) private {
504         _rTotal = _rTotal.sub(rFee);
505         _tFeeTotal = _tFeeTotal.add(tFee);
506     }
507 
508     receive() external payable {}
509 
510     function _getValues(uint256 tAmount)
511         private
512         view
513         returns (
514             uint256,
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
523             _getTValues(tAmount, _redisFee, _taxFee);
524         uint256 currentRate = _getRate();
525         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
526             _getRValues(tAmount, tFee, tTeam, currentRate);
527         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
528     }
529 
530     function _getTValues(
531         uint256 tAmount,
532         uint256 redisFee,
533         uint256 taxFee
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 tFee = tAmount.mul(redisFee).div(100);
544         uint256 tTeam = tAmount.mul(taxFee).div(100);
545         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
567         return (rAmount, rTransferAmount, rFee);
568     }
569 
570     function _getRate() private view returns (uint256) {
571         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
572         return rSupply.div(tSupply);
573     }
574 
575     function _getCurrentSupply() private view returns (uint256, uint256) {
576         uint256 rSupply = _rTotal;
577         uint256 tSupply = _tTotal;
578         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
579         return (rSupply, tSupply);
580     }
581 
582     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
583         _redisFeeOnBuy = redisFeeOnBuy;
584         _redisFeeOnSell = redisFeeOnSell;
585         _taxFeeOnBuy = taxFeeOnBuy;
586         _taxFeeOnSell = taxFeeOnSell;
587     }
588 
589     //Set minimum tokens required to swap.
590     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
591         _swapTokensAtAmount = swapTokensAtAmount;
592     }
593 
594     //Set minimum tokens required to swap.
595     function toggleSwap(bool _swapEnabled) public onlyOwner {
596         swapEnabled = _swapEnabled;
597     }
598 
599     //Set maximum transaction
600     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
601         _maxTxAmount = maxTxAmount;
602     }
603 
604     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
605         _maxWalletSize = maxWalletSize;
606     }
607 
608     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
609         for(uint256 i = 0; i < accounts.length; i++) {
610             _isExcludedFromFee[accounts[i]] = excluded;
611         }
612     }
613 
614 }