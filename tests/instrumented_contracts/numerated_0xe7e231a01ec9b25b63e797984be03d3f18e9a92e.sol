1 /**
2 The Mission X
3 
4 ███╗░░░███╗░██████╗███╗░░██╗██╗░░██╗
5 ████╗░████║██╔════╝████╗░██║╚██╗██╔╝
6 ██╔████╔██║╚█████╗░██╔██╗██║░╚███╔╝░
7 ██║╚██╔╝██║░╚═══██╗██║╚████║░██╔██╗░
8 ██║░╚═╝░██║██████╔╝██║░╚███║██╔╝╚██╗
9 ╚═╝░░░░░╚═╝╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝
10 
11 Shrouded in an enigma, Mission X unfurls as a social paradigm shift, an experiment like no other.
12 
13 In this realm, there are no leaders, no developers. We exist as an unguided constellation of minds, a community united in purpose, a team intertwined by shared aspirations.
14 
15 We, the collective, steer this voyage, deciding the fate of this extraordinary initiative.
16 
17 As the mission advances beyond its inception, the financial burdens will dissipate into the ether. The taxes, stripped to nothingness. The ownership, surrendered to the cosmos.
18 
19 Should unity thrive and collective force surge, the LP Tokens shall meet their fiery demise. Burnt in the crucible of community ambition, an act to test our resolve.
20 
21 In the event of unity persisting and propelling our project forward, tax resources will find their way into a wallet, chosen by the collective will.
22 
23 Rest assured, from the shadows, we shall observe, witnessing the destiny of Mission X unfold.
24 
25 https://t.me/TheMissionX
26 
27 */
28 
29 // SPDX-License-Identifier: Unlicensed
30 pragma solidity ^0.8.14;
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(
49         address sender,
50         address recipient,
51         uint256 amount
52     ) external returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(
56         address indexed owner,
57         address indexed spender,
58         uint256 value
59     );
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     constructor() {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 
96 }
97 
98 library SafeMath {
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102         return c;
103     }
104 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     function sub(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b <= a, errorMessage);
115         uint256 c = a - b;
116         return c;
117     }
118 
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a == 0) {
121             return 0;
122         }
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125         return c;
126     }
127 
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 }
142 
143 interface IUniswapV2Factory {
144     function createPair(address tokenA, address tokenB)
145         external
146         returns (address pair);
147 }
148 
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint256 amountIn,
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external;
157 
158     function factory() external pure returns (address);
159 
160     function WETH() external pure returns (address);
161 
162     function addLiquidityETH(
163         address token,
164         uint256 amountTokenDesired,
165         uint256 amountTokenMin,
166         uint256 amountETHMin,
167         address to,
168         uint256 deadline
169     )
170         external
171         payable
172         returns (
173             uint256 amountToken,
174             uint256 amountETH,
175             uint256 liquidity
176         );
177 }
178 
179 contract TheMissionX is Context, IERC20, Ownable {
180 
181     using SafeMath for uint256;
182 
183     string private constant _name = "The Mission X";
184     string private constant _symbol = "MSNx";
185     uint8 private constant _decimals = 9;
186 
187     mapping(address => uint256) private _rOwned;
188     mapping(address => uint256) private _tOwned;
189     mapping(address => mapping(address => uint256)) private _allowances;
190     mapping(address => bool) private _isExcludedFromFee;
191     uint256 private constant MAX = ~uint256(0);
192     uint256 private constant _tTotal = 100000000 * 10**9;
193     uint256 private _rTotal = (MAX - (MAX % _tTotal));
194     uint256 private _tFeeTotal;
195     uint256 private _redisFeeOnBuy = 0;
196     uint256 private _taxFeeOnBuy = 20;
197     uint256 private _redisFeeOnSell = 0;
198     uint256 private _taxFeeOnSell = 25;
199 
200     //Original Fee
201     uint256 private _redisFee = _redisFeeOnSell;
202     uint256 private _taxFee = _taxFeeOnSell;
203 
204     uint256 private _previousredisFee = _redisFee;
205     uint256 private _previoustaxFee = _taxFee;
206 
207     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
208     mapping (address => bool) public preTrader;
209     address payable private _developmentAddress = payable(0x2875Dc7F26709882df741cf3f49d88bB30de25dA);
210     address payable private _marketingAddress = payable(0x2875Dc7F26709882df741cf3f49d88bB30de25dA);
211 
212     IUniswapV2Router02 public uniswapV2Router;
213     address public uniswapV2Pair;
214 
215     bool private tradingOpen;
216     bool private inSwap = false;
217     bool private swapEnabled = true;
218 
219     uint256 public _maxTxAmount = 2000000 * 10**9;
220     uint256 public _maxWalletSize = 2000000 * 10**9;
221     uint256 public _swapTokensAtAmount = 50000 * 10**9;
222 
223     event MaxTxAmountUpdated(uint256 _maxTxAmount);
224     modifier lockTheSwap {
225         inSwap = true;
226         _;
227         inSwap = false;
228     }
229 
230     constructor() {
231 
232         _rOwned[_msgSender()] = _rTotal;
233 
234         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
235         uniswapV2Router = _uniswapV2Router;
236         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
237             .createPair(address(this), _uniswapV2Router.WETH());
238 
239         _isExcludedFromFee[owner()] = true;
240         _isExcludedFromFee[address(this)] = true;
241         _isExcludedFromFee[_developmentAddress] = true;
242         _isExcludedFromFee[_marketingAddress] = true;
243 
244         emit Transfer(address(0), _msgSender(), _tTotal);
245     }
246 
247     function name() public pure returns (string memory) {
248         return _name;
249     }
250 
251     function symbol() public pure returns (string memory) {
252         return _symbol;
253     }
254 
255     function decimals() public pure returns (uint8) {
256         return _decimals;
257     }
258 
259     function totalSupply() public pure override returns (uint256) {
260         return _tTotal;
261     }
262 
263     function balanceOf(address account) public view override returns (uint256) {
264         return tokenFromReflection(_rOwned[account]);
265     }
266 
267     function transfer(address recipient, uint256 amount)
268         public
269         override
270         returns (bool)
271     {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     function allowance(address owner, address spender)
277         public
278         view
279         override
280         returns (uint256)
281     {
282         return _allowances[owner][spender];
283     }
284 
285     function approve(address spender, uint256 amount)
286         public
287         override
288         returns (bool)
289     {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293 
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) public override returns (bool) {
299         _transfer(sender, recipient, amount);
300         _approve(
301             sender,
302             _msgSender(),
303             _allowances[sender][_msgSender()].sub(
304                 amount,
305                 "ERC20: transfer amount exceeds allowance"
306             )
307         );
308         return true;
309     }
310 
311     function tokenFromReflection(uint256 rAmount)
312         private
313         view
314         returns (uint256)
315     {
316         require(
317             rAmount <= _rTotal,
318             "Amount must be less than total reflections"
319         );
320         uint256 currentRate = _getRate();
321         return rAmount.div(currentRate);
322     }
323 
324     function removeAllFee() private {
325         if (_redisFee == 0 && _taxFee == 0) return;
326 
327         _previousredisFee = _redisFee;
328         _previoustaxFee = _taxFee;
329 
330         _redisFee = 0;
331         _taxFee = 0;
332     }
333 
334     function restoreAllFee() private {
335         _redisFee = _previousredisFee;
336         _taxFee = _previoustaxFee;
337     }
338 
339     function _approve(
340         address owner,
341         address spender,
342         uint256 amount
343     ) private {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346         _allowances[owner][spender] = amount;
347         emit Approval(owner, spender, amount);
348     }
349 
350     function _transfer(
351         address from,
352         address to,
353         uint256 amount
354     ) private {
355         require(from != address(0), "ERC20: transfer from the zero address");
356         require(to != address(0), "ERC20: transfer to the zero address");
357         require(amount > 0, "Transfer amount must be greater than zero");
358 
359         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
360 
361             //Trade start check
362             if (!tradingOpen) {
363                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
364             }
365 
366             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
367             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
368 
369             if(to != uniswapV2Pair) {
370                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
371             }
372 
373             uint256 contractTokenBalance = balanceOf(address(this));
374             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
375 
376             if(contractTokenBalance >= _maxTxAmount)
377             {
378                 contractTokenBalance = _maxTxAmount;
379             }
380 
381             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
382                 swapTokensForEth(contractTokenBalance);
383                 uint256 contractETHBalance = address(this).balance;
384                 if (contractETHBalance > 0) {
385                     sendETHToFee(address(this).balance);
386                 }
387             }
388         }
389 
390         bool takeFee = true;
391 
392         //Transfer Tokens
393         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
394             takeFee = false;
395         } else {
396 
397             //Set Fee for Buys
398             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
399                 _redisFee = _redisFeeOnBuy;
400                 _taxFee = _taxFeeOnBuy;
401             }
402 
403             //Set Fee for Sells
404             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
405                 _redisFee = _redisFeeOnSell;
406                 _taxFee = _taxFeeOnSell;
407             }
408 
409         }
410 
411         _tokenTransfer(from, to, amount, takeFee);
412     }
413 
414     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
415         address[] memory path = new address[](2);
416         path[0] = address(this);
417         path[1] = uniswapV2Router.WETH();
418         _approve(address(this), address(uniswapV2Router), tokenAmount);
419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
420             tokenAmount,
421             0,
422             path,
423             address(this),
424             block.timestamp
425         );
426     }
427 
428     function sendETHToFee(uint256 amount) private {
429         _marketingAddress.transfer(amount);
430     }
431 
432     function setTrading(bool _tradingOpen) public onlyOwner {
433         tradingOpen = _tradingOpen;
434     }
435 
436     function manualswap() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractBalance = balanceOf(address(this));
439         swapTokensForEth(contractBalance);
440     }
441 
442     function manualsend() external {
443         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
444         uint256 contractETHBalance = address(this).balance;
445         sendETHToFee(contractETHBalance);
446     }
447 
448     function blockBots(address[] memory bots_) public onlyOwner {
449         for (uint256 i = 0; i < bots_.length; i++) {
450             bots[bots_[i]] = true;
451         }
452     }
453 
454     function unblockBot(address notbot) public onlyOwner {
455         bots[notbot] = false;
456     }
457 
458     function _tokenTransfer(
459         address sender,
460         address recipient,
461         uint256 amount,
462         bool takeFee
463     ) private {
464         if (!takeFee) removeAllFee();
465         _transferStandard(sender, recipient, amount);
466         if (!takeFee) restoreAllFee();
467     }
468 
469     function _transferStandard(
470         address sender,
471         address recipient,
472         uint256 tAmount
473     ) private {
474         (
475             uint256 rAmount,
476             uint256 rTransferAmount,
477             uint256 rFee,
478             uint256 tTransferAmount,
479             uint256 tFee,
480             uint256 tTeam
481         ) = _getValues(tAmount);
482         _rOwned[sender] = _rOwned[sender].sub(rAmount);
483         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
484         _takeTeam(tTeam);
485         _reflectFee(rFee, tFee);
486         emit Transfer(sender, recipient, tTransferAmount);
487     }
488 
489     function _takeTeam(uint256 tTeam) private {
490         uint256 currentRate = _getRate();
491         uint256 rTeam = tTeam.mul(currentRate);
492         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
493     }
494 
495     function _reflectFee(uint256 rFee, uint256 tFee) private {
496         _rTotal = _rTotal.sub(rFee);
497         _tFeeTotal = _tFeeTotal.add(tFee);
498     }
499 
500     receive() external payable {}
501 
502     function _getValues(uint256 tAmount)
503         private
504         view
505         returns (
506             uint256,
507             uint256,
508             uint256,
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
515             _getTValues(tAmount, _redisFee, _taxFee);
516         uint256 currentRate = _getRate();
517         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
518             _getRValues(tAmount, tFee, tTeam, currentRate);
519         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getTValues(
523         uint256 tAmount,
524         uint256 redisFee,
525         uint256 taxFee
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 tFee = tAmount.mul(redisFee).div(100);
536         uint256 tTeam = tAmount.mul(taxFee).div(100);
537         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
538         return (tTransferAmount, tFee, tTeam);
539     }
540 
541     function _getRValues(
542         uint256 tAmount,
543         uint256 tFee,
544         uint256 tTeam,
545         uint256 currentRate
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 rAmount = tAmount.mul(currentRate);
556         uint256 rFee = tFee.mul(currentRate);
557         uint256 rTeam = tTeam.mul(currentRate);
558         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
559         return (rAmount, rTransferAmount, rFee);
560     }
561 
562     function _getRate() private view returns (uint256) {
563         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
564         return rSupply.div(tSupply);
565     }
566 
567     function _getCurrentSupply() private view returns (uint256, uint256) {
568         uint256 rSupply = _rTotal;
569         uint256 tSupply = _tTotal;
570         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
571         return (rSupply, tSupply);
572     }
573 
574     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
575         _redisFeeOnBuy = redisFeeOnBuy;
576         _redisFeeOnSell = redisFeeOnSell;
577         _taxFeeOnBuy = taxFeeOnBuy;
578         _taxFeeOnSell = taxFeeOnSell;
579     }
580 
581     //Set minimum tokens required to swap.
582     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
583         _swapTokensAtAmount = swapTokensAtAmount;
584     }
585 
586     //Set minimum tokens required to swap.
587     function toggleSwap(bool _swapEnabled) public onlyOwner {
588         swapEnabled = _swapEnabled;
589     }
590 
591     //Set maximum transaction
592     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
593         _maxTxAmount = maxTxAmount;
594     }
595 
596     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
597         _maxWalletSize = maxWalletSize;
598     }
599 
600     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
601         for(uint256 i = 0; i < accounts.length; i++) {
602             _isExcludedFromFee[accounts[i]] = excluded;
603         }
604     }
605 
606     function allowPreTrading(address[] calldata accounts) public onlyOwner {
607         for(uint256 i = 0; i < accounts.length; i++) {
608                  preTrader[accounts[i]] = true;
609         }
610     }
611 
612     function removePreTrading(address[] calldata accounts) public onlyOwner {
613         for(uint256 i = 0; i < accounts.length; i++) {
614                  delete preTrader[accounts[i]];
615         }
616     }
617 }