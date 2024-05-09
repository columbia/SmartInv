1 /*
2 
3 www.snowyinueth.com
4 t.me/snowyinueth
5 twitter.com/snowyinueth
6 
7 Snowy Inu - Make Memecoins Great Again!
8 
9 Deceiving LARP tokens have taken the Ethereum mainnet by storm, often at the expense of the regular investors. 
10 
11 Do you miss the old-fashioned Memecoins as much as we do? Are you tired of all the Ryoshi nonsense? 
12 
13 Don't miss out on the newest and biggest Memecoin of 2022! Join our Community and buy Snowy Inu!
14 
15 TOKENOMICS
16 - Contract Renounced
17 - Liquidity Burnt
18 - Unruggable
19 - 5% Buy
20 - 5% Sell
21 - 2% Max Wallet
22 - 2% Max Txn
23 - 100% Community Coin!
24 
25 */
26 
27 // SPDX-License-Identifier: UNLICENSED
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
178 contract SNOWY is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
179 
180     using SafeMath for uint256;
181 
182     string private constant _name = "Snowy Inu";//////////////////////////
183     string private constant _symbol = "SNOWY";//////////////////////////////////////////////////////////////////////////
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
194 
195     //Buy Fee
196     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
197     uint256 private _taxFeeOnBuy = 5;//////////////////////////////////////////////////////////////////////
198 
199     //Sell Fee
200     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
201     uint256 private _taxFeeOnSell = 5;/////////////////////////////////////////////////////////////////////
202 
203     //Original Fee
204     uint256 private _redisFee = _redisFeeOnSell;
205     uint256 private _taxFee = _taxFeeOnSell;
206 
207     uint256 private _previousredisFee = _redisFee;
208     uint256 private _previoustaxFee = _taxFee;
209 
210     mapping(address => bool) public bots;
211     mapping(address => uint256) private cooldown;
212 
213     address payable private _developmentAddress = payable(0x806f44E383a7fe095a8BA19Add4Bd09AcAC8C91e);/////////////////////////////////////////////////
214     address payable private _marketingAddress = payable(0xbe1DBeDF8bD2277EcF609C360eFAd1D4c95F8871);///////////////////////////////////////////////////
215 
216     IUniswapV2Router02 public uniswapV2Router;
217     address public uniswapV2Pair;
218 
219     bool private tradingOpen;
220     bool private inSwap = false;
221     bool private swapEnabled = true;
222 
223     uint256 public _maxTxAmount = 200000 * 10**9; //1%
224     uint256 public _maxWalletSize = 200000 * 10**9; //1%
225     uint256 public _swapTokensAtAmount = 40000 * 10**9; //.4%
226 
227     event MaxTxAmountUpdated(uint256 _maxTxAmount);
228     modifier lockTheSwap {
229         inSwap = true;
230         _;
231         inSwap = false;
232     }
233 
234     constructor() {
235 
236         _rOwned[_msgSender()] = _rTotal;
237 
238         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
239         uniswapV2Router = _uniswapV2Router;
240         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
241             .createPair(address(this), _uniswapV2Router.WETH());
242 
243         _isExcludedFromFee[owner()] = true;
244         _isExcludedFromFee[address(this)] = true;
245         _isExcludedFromFee[_developmentAddress] = true;
246         _isExcludedFromFee[_marketingAddress] = true;
247 
248 
249 
250 
251         emit Transfer(address(0), _msgSender(), _tTotal);
252     }
253 
254     function name() public pure returns (string memory) {
255         return _name;
256     }
257 
258     function symbol() public pure returns (string memory) {
259         return _symbol;
260     }
261 
262     function decimals() public pure returns (uint8) {
263         return _decimals;
264     }
265 
266     function totalSupply() public pure override returns (uint256) {
267         return _tTotal;
268     }
269 
270     function balanceOf(address account) public view override returns (uint256) {
271         return tokenFromReflection(_rOwned[account]);
272     }
273 
274     function transfer(address recipient, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282 
283     function allowance(address owner, address spender)
284         public
285         view
286         override
287         returns (uint256)
288     {
289         return _allowances[owner][spender];
290     }
291 
292     function approve(address spender, uint256 amount)
293         public
294         override
295         returns (bool)
296     {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300 
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(
308             sender,
309             _msgSender(),
310             _allowances[sender][_msgSender()].sub(
311                 amount,
312                 "ERC20: transfer amount exceeds allowance"
313             )
314         );
315         return true;
316     }
317 
318     function tokenFromReflection(uint256 rAmount)
319         private
320         view
321         returns (uint256)
322     {
323         require(
324             rAmount <= _rTotal,
325             "Amount must be less than total reflections"
326         );
327         uint256 currentRate = _getRate();
328         return rAmount.div(currentRate);
329     }
330 
331     function removeAllFee() private {
332         if (_redisFee == 0 && _taxFee == 0) return;
333 
334         _previousredisFee = _redisFee;
335         _previoustaxFee = _taxFee;
336 
337         _redisFee = 0;
338         _taxFee = 0;
339     }
340 
341     function restoreAllFee() private {
342         _redisFee = _previousredisFee;
343         _taxFee = _previoustaxFee;
344     }
345 
346     function _approve(
347         address owner,
348         address spender,
349         uint256 amount
350     ) private {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 
357     function _transfer(
358         address from,
359         address to,
360         uint256 amount
361     ) private {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364         require(amount > 0, "Transfer amount must be greater than zero");
365 
366         if (from != owner() && to != owner()) {
367 
368             //Trade start check
369             if (!tradingOpen) {
370                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
371             }
372 
373             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
374             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
375 
376             if(to != uniswapV2Pair) {
377                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
378             }
379 
380             uint256 contractTokenBalance = balanceOf(address(this));
381             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
382 
383             if(contractTokenBalance >= _maxTxAmount)
384             {
385                 contractTokenBalance = _maxTxAmount;
386             }
387 
388             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
389                 swapTokensForEth(contractTokenBalance);
390                 uint256 contractETHBalance = address(this).balance;
391                 if (contractETHBalance > 0) {
392                     sendETHToFee(address(this).balance);
393                 }
394             }
395         }
396 
397         bool takeFee = true;
398 
399         //Transfer Tokens
400         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
401             takeFee = false;
402         } else {
403 
404             //Set Fee for Buys
405             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
406                 _redisFee = _redisFeeOnBuy;
407                 _taxFee = _taxFeeOnBuy;
408             }
409 
410             //Set Fee for Sells
411             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
412                 _redisFee = _redisFeeOnSell;
413                 _taxFee = _taxFeeOnSell;
414             }
415 
416         }
417 
418         _tokenTransfer(from, to, amount, takeFee);
419     }
420 
421     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
422         address[] memory path = new address[](2);
423         path[0] = address(this);
424         path[1] = uniswapV2Router.WETH();
425         _approve(address(this), address(uniswapV2Router), tokenAmount);
426         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
427             tokenAmount,
428             0,
429             path,
430             address(this),
431             block.timestamp
432         );
433     }
434 
435     function sendETHToFee(uint256 amount) private {
436         _developmentAddress.transfer(amount.div(2));
437         _marketingAddress.transfer(amount.div(2));
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
527 
528         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
529     }
530 
531     function _getTValues(
532         uint256 tAmount,
533         uint256 redisFee,
534         uint256 taxFee
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 tFee = tAmount.mul(redisFee).div(100);
545         uint256 tTeam = tAmount.mul(taxFee).div(100);
546         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
547 
548         return (tTransferAmount, tFee, tTeam);
549     }
550 
551     function _getRValues(
552         uint256 tAmount,
553         uint256 tFee,
554         uint256 tTeam,
555         uint256 currentRate
556     )
557         private
558         pure
559         returns (
560             uint256,
561             uint256,
562             uint256
563         )
564     {
565         uint256 rAmount = tAmount.mul(currentRate);
566         uint256 rFee = tFee.mul(currentRate);
567         uint256 rTeam = tTeam.mul(currentRate);
568         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
569 
570         return (rAmount, rTransferAmount, rFee);
571     }
572 
573     function _getRate() private view returns (uint256) {
574         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
575 
576         return rSupply.div(tSupply);
577     }
578 
579     function _getCurrentSupply() private view returns (uint256, uint256) {
580         uint256 rSupply = _rTotal;
581         uint256 tSupply = _tTotal;
582         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
583 
584         return (rSupply, tSupply);
585     }
586 
587     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
588         _redisFeeOnBuy = redisFeeOnBuy;
589         _redisFeeOnSell = redisFeeOnSell;
590 
591         _taxFeeOnBuy = taxFeeOnBuy;
592         _taxFeeOnSell = taxFeeOnSell;
593     }
594 
595     //Set minimum tokens required to swap.
596     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
597         _swapTokensAtAmount = swapTokensAtAmount;
598     }
599 
600     //Set minimum tokens required to swap.
601     function toggleSwap(bool _swapEnabled) public onlyOwner {
602         swapEnabled = _swapEnabled;
603     }
604 
605 
606     //Set MAx transaction
607     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
608         _maxTxAmount = maxTxAmount;
609     }
610 
611     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
612         _maxWalletSize = maxWalletSize;
613     }
614 
615     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
616         for(uint256 i = 0; i < accounts.length; i++) {
617             _isExcludedFromFee[accounts[i]] = excluded;
618         }
619     }
620 }