1 /**
2 
3 Telegram Portal: https://t.me/XansPortal
4 Twitter: Https://Twitter.com/XansErc
5 Web: https://XannyBars.com
6 
7 
8 ▀▄░▄▀ ─█▀▀█ ░█▄─░█ ░█▀▀▀█ 　 █───█ ─▀─ █── █── 　 █▀▄▀█ █▀▀█ █─█ █▀▀ 　 █──█ █▀▀█ █──█ 　 █▀▀▄ █▀▀█ █▀▀▄ █▀▀▄ █▀▀ 
9 ─░█── ░█▄▄█ ░█░█░█ ─▀▀▀▄▄ 　 █▄█▄█ ▀█▀ █── █── 　 █─▀─█ █▄▄█ █▀▄ █▀▀ 　 █▄▄█ █──█ █──█ 　 █▀▀▄ █▄▄█ █──█ █──█ ▀▀█ 
10 ▄▀░▀▄ ░█─░█ ░█──▀█ ░█▄▄▄█ 　 ─▀─▀─ ▀▀▀ ▀▀▀ ▀▀▀ 　 ▀───▀ ▀──▀ ▀─▀ ▀▀▀ 　 ▄▄▄█ ▀▀▀▀ ─▀▀▀ 　 ▀▀▀─ ▀──▀ ▀──▀ ▀▀▀─ ▀▀▀
11 
12 ──────────────────██████────────────────
13 ─────────────────████████─█─────────────
14 ─────────────██████████████─────────────
15 ─────────────█████████████──────────────
16 ──────────────███████████───────────────
17 ───────────────██████████───────────────
18 ────────────────████████────────────────
19 ────────────────▐██████─────────────────
20 ────────────────▐██████─────────────────
21 ──────────────── ▌─────▌────────────────
22 ────────────────███─█████───────────────
23 ────────────████████████████────────────
24 ──────────████████████████████──────────
25 ────────████████████─────███████────────
26 ──────███████████─────────███████───────
27 ─────████████████───██─███████████──────
28 ────██████████████──────────████████────
29 ───████████████████─────█───█████████───
30 ──█████████████████████─██───█████████──
31 ──█████████████████████──██──██████████─
32 ─███████████████████████─██───██████████
33 ████████████████████████──────██████████
34 ███████████████████──────────███████████
35 ─██████████████████───────██████████████
36 ─███████████████████████──█████████████─
37 ──█████████████████████████████████████─
38 ───██████████████████████████████████───
39 ───────██████████████████████████████───
40 ───────██████████████████████████───────
41 ─────────────███████████████────────────
42 
43 
44 
45 */
46 
47 // SPDX-License-Identifier: Unlicensed
48 pragma solidity ^0.8.14;
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53 }
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address account) external view returns (uint256);
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     address private _previousOwner;
83     event OwnershipTransferred(
84         address indexed previousOwner,
85         address indexed newOwner
86     );
87 
88     constructor() {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 
114 }
115 
116 library SafeMath {
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120         return c;
121     }
122 
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     function sub(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134         return c;
135     }
136 
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) {
139             return 0;
140         }
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143         return c;
144     }
145 
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return div(a, b, "SafeMath: division by zero");
148     }
149 
150     function div(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         return c;
158     }
159 }
160 
161 interface IUniswapV2Factory {
162     function createPair(address tokenA, address tokenB)
163         external
164         returns (address pair);
165 }
166 
167 interface IUniswapV2Router02 {
168     function swapExactTokensForETHSupportingFeeOnTransferTokens(
169         uint256 amountIn,
170         uint256 amountOutMin,
171         address[] calldata path,
172         address to,
173         uint256 deadline
174     ) external;
175 
176     function factory() external pure returns (address);
177 
178     function WETH() external pure returns (address);
179 
180     function addLiquidityETH(
181         address token,
182         uint256 amountTokenDesired,
183         uint256 amountTokenMin,
184         uint256 amountETHMin,
185         address to,
186         uint256 deadline
187     )
188         external
189         payable
190         returns (
191             uint256 amountToken,
192             uint256 amountETH,
193             uint256 liquidity
194         );
195 }
196 
197 contract Xans is Context, IERC20, Ownable {
198 
199     using SafeMath for uint256;
200 
201     string private constant _name = "Xanny Bars";
202     string private constant _symbol = "Xans";
203     uint8 private constant _decimals = 9;
204 
205     mapping(address => uint256) private _rOwned;
206     mapping(address => uint256) private _tOwned;
207     mapping(address => mapping(address => uint256)) private _allowances;
208     mapping(address => bool) private _isExcludedFromFee;
209     uint256 private constant MAX = ~uint256(0);
210     uint256 private constant _tTotal = 1000000000 * 10**9; // - 100%
211     uint256 private _rTotal = (MAX - (MAX % _tTotal));
212     uint256 private _tFeeTotal;
213     uint256 private _redisFeeOnBuy = 0;
214     uint256 private _taxFeeOnBuy = 25;
215     uint256 private _redisFeeOnSell = 0;
216     uint256 private _taxFeeOnSell = 45;
217 
218     //Original Fee
219     uint256 private _redisFee = _redisFeeOnSell;
220     uint256 private _taxFee = _taxFeeOnSell;
221 
222     uint256 private _previousredisFee = _redisFee;
223     uint256 private _previoustaxFee = _taxFee;
224 
225     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
226     mapping (address => bool) public preTrader;
227     address payable private _developmentAddress = payable(0x2A4C69DcbD08a14D2Efa5B114A7cA7f9D3c2efD3);
228     address payable private _marketingAddress = payable(0x2A4C69DcbD08a14D2Efa5B114A7cA7f9D3c2efD3);
229 
230     IUniswapV2Router02 public uniswapV2Router;
231     address public uniswapV2Pair;
232 
233     bool private tradingOpen;
234     bool private inSwap = false;
235     bool private swapEnabled = false;
236 
237     uint256 public _maxTxAmount = 2000000 * 10**9; // - 2%
238     uint256 public _maxWalletSize = 2500000 * 10**9; // - 2%
239     uint256 public _swapTokensAtAmount = 50000 * 10**9;
240 
241     event MaxTxAmountUpdated(uint256 _maxTxAmount);
242     modifier lockTheSwap {
243         inSwap = true;
244         _;
245         inSwap = false;
246     }
247 
248     constructor() {
249 
250         _rOwned[_msgSender()] = _rTotal;
251 
252         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
253         uniswapV2Router = _uniswapV2Router;
254         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
255             .createPair(address(this), _uniswapV2Router.WETH());
256 
257         _isExcludedFromFee[owner()] = true;
258         _isExcludedFromFee[address(this)] = true;
259         _isExcludedFromFee[_developmentAddress] = true;
260         _isExcludedFromFee[_marketingAddress] = true;
261 
262         emit Transfer(address(0), _msgSender(), _tTotal);
263     }
264 
265     function name() public pure returns (string memory) {
266         return _name;
267     }
268 
269     function symbol() public pure returns (string memory) {
270         return _symbol;
271     }
272 
273     function decimals() public pure returns (uint8) {
274         return _decimals;
275     }
276 
277     function totalSupply() public pure override returns (uint256) {
278         return _tTotal;
279     }
280 
281     function balanceOf(address account) public view override returns (uint256) {
282         return tokenFromReflection(_rOwned[account]);
283     }
284 
285     function transfer(address recipient, uint256 amount)
286         public
287         override
288         returns (bool)
289     {
290         _transfer(_msgSender(), recipient, amount);
291         return true;
292     }
293 
294     function allowance(address owner, address spender)
295         public
296         view
297         override
298         returns (uint256)
299     {
300         return _allowances[owner][spender];
301     }
302 
303     function approve(address spender, uint256 amount)
304         public
305         override
306         returns (bool)
307     {
308         _approve(_msgSender(), spender, amount);
309         return true;
310     }
311 
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public override returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(
319             sender,
320             _msgSender(),
321             _allowances[sender][_msgSender()].sub(
322                 amount,
323                 "ERC20: transfer amount exceeds allowance"
324             )
325         );
326         return true;
327     }
328 
329     function tokenFromReflection(uint256 rAmount)
330         private
331         view
332         returns (uint256)
333     {
334         require(
335             rAmount <= _rTotal,
336             "Amount must be less than total reflections"
337         );
338         uint256 currentRate = _getRate();
339         return rAmount.div(currentRate);
340     }
341 
342     function removeAllFee() private {
343         if (_redisFee == 0 && _taxFee == 0) return;
344 
345         _previousredisFee = _redisFee;
346         _previoustaxFee = _taxFee;
347 
348         _redisFee = 0;
349         _taxFee = 0;
350     }
351 
352     function restoreAllFee() private {
353         _redisFee = _previousredisFee;
354         _taxFee = _previoustaxFee;
355     }
356 
357     function _approve(
358         address owner,
359         address spender,
360         uint256 amount
361     ) private {
362         require(owner != address(0), "ERC20: approve from the zero address");
363         require(spender != address(0), "ERC20: approve to the zero address");
364         _allowances[owner][spender] = amount;
365         emit Approval(owner, spender, amount);
366     }
367 
368     function _transfer(
369         address from,
370         address to,
371         uint256 amount
372     ) private {
373         require(from != address(0), "ERC20: transfer from the zero address");
374         require(to != address(0), "ERC20: transfer to the zero address");
375         require(amount > 0, "Transfer amount must be greater than zero");
376 
377         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
378 
379             //Trade start check
380             if (!tradingOpen) {
381                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
382             }
383 
384             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
385             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
386 
387             if(to != uniswapV2Pair) {
388                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
389             }
390 
391             uint256 contractTokenBalance = balanceOf(address(this));
392             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
393 
394             if(contractTokenBalance >= _maxTxAmount)
395             {
396                 contractTokenBalance = _maxTxAmount;
397             }
398 
399             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
400                 swapTokensForEth(contractTokenBalance);
401                 uint256 contractETHBalance = address(this).balance;
402                 if (contractETHBalance > 0) {
403                     sendETHToFee(address(this).balance);
404                 }
405             }
406         }
407 
408         bool takeFee = true;
409 
410         //Transfer Tokens
411         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
412             takeFee = false;
413         } else {
414 
415             //Set Fee for Buys
416             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
417                 _redisFee = _redisFeeOnBuy;
418                 _taxFee = _taxFeeOnBuy;
419             }
420 
421             //Set Fee for Sells
422             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
423                 _redisFee = _redisFeeOnSell;
424                 _taxFee = _taxFeeOnSell;
425             }
426 
427         }
428 
429         _tokenTransfer(from, to, amount, takeFee);
430     }
431 
432     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
433         address[] memory path = new address[](2);
434         path[0] = address(this);
435         path[1] = uniswapV2Router.WETH();
436         _approve(address(this), address(uniswapV2Router), tokenAmount);
437         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             tokenAmount,
439             0,
440             path,
441             address(this),
442             block.timestamp
443         );
444     }
445 
446     function sendETHToFee(uint256 amount) private {
447         _marketingAddress.transfer(amount);
448     }
449 
450     function setTrading(bool _tradingOpen) public onlyOwner {
451         tradingOpen = _tradingOpen;
452     }
453 
454     function manualswap() external {
455         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
456         uint256 contractBalance = balanceOf(address(this));
457         swapTokensForEth(contractBalance);
458     }
459 
460     function manualsend() external {
461         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
462         uint256 contractETHBalance = address(this).balance;
463         sendETHToFee(contractETHBalance);
464     }
465 
466     function blockBots(address[] memory bots_) public onlyOwner {
467         for (uint256 i = 0; i < bots_.length; i++) {
468             bots[bots_[i]] = true;
469         }
470     }
471 
472     function unblockBot(address notbot) public onlyOwner {
473         bots[notbot] = false;
474     }
475 
476     function _tokenTransfer(
477         address sender,
478         address recipient,
479         uint256 amount,
480         bool takeFee
481     ) private {
482         if (!takeFee) removeAllFee();
483         _transferStandard(sender, recipient, amount);
484         if (!takeFee) restoreAllFee();
485     }
486 
487     function _transferStandard(
488         address sender,
489         address recipient,
490         uint256 tAmount
491     ) private {
492         (
493             uint256 rAmount,
494             uint256 rTransferAmount,
495             uint256 rFee,
496             uint256 tTransferAmount,
497             uint256 tFee,
498             uint256 tTeam
499         ) = _getValues(tAmount);
500         _rOwned[sender] = _rOwned[sender].sub(rAmount);
501         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
502         _takeTeam(tTeam);
503         _reflectFee(rFee, tFee);
504         emit Transfer(sender, recipient, tTransferAmount);
505     }
506 
507     function _takeTeam(uint256 tTeam) private {
508         uint256 currentRate = _getRate();
509         uint256 rTeam = tTeam.mul(currentRate);
510         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
511     }
512 
513     function _reflectFee(uint256 rFee, uint256 tFee) private {
514         _rTotal = _rTotal.sub(rFee);
515         _tFeeTotal = _tFeeTotal.add(tFee);
516     }
517 
518     receive() external payable {}
519 
520     function _getValues(uint256 tAmount)
521         private
522         view
523         returns (
524             uint256,
525             uint256,
526             uint256,
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
533             _getTValues(tAmount, _redisFee, _taxFee);
534         uint256 currentRate = _getRate();
535         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
536             _getRValues(tAmount, tFee, tTeam, currentRate);
537         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
538     }
539 
540     function _getTValues(
541         uint256 tAmount,
542         uint256 redisFee,
543         uint256 taxFee
544     )
545         private
546         pure
547         returns (
548             uint256,
549             uint256,
550             uint256
551         )
552     {
553         uint256 tFee = tAmount.mul(redisFee).div(100);
554         uint256 tTeam = tAmount.mul(taxFee).div(100);
555         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
556         return (tTransferAmount, tFee, tTeam);
557     }
558 
559     function _getRValues(
560         uint256 tAmount,
561         uint256 tFee,
562         uint256 tTeam,
563         uint256 currentRate
564     )
565         private
566         pure
567         returns (
568             uint256,
569             uint256,
570             uint256
571         )
572     {
573         uint256 rAmount = tAmount.mul(currentRate);
574         uint256 rFee = tFee.mul(currentRate);
575         uint256 rTeam = tTeam.mul(currentRate);
576         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
577         return (rAmount, rTransferAmount, rFee);
578     }
579 
580     function _getRate() private view returns (uint256) {
581         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
582         return rSupply.div(tSupply);
583     }
584 
585     function _getCurrentSupply() private view returns (uint256, uint256) {
586         uint256 rSupply = _rTotal;
587         uint256 tSupply = _tTotal;
588         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
589         return (rSupply, tSupply);
590     }
591 
592     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
593         _redisFeeOnBuy = redisFeeOnBuy;
594         _redisFeeOnSell = redisFeeOnSell;
595         _taxFeeOnBuy = taxFeeOnBuy;
596         _taxFeeOnSell = taxFeeOnSell;
597     }
598 
599     //Set minimum tokens required to swap.
600     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
601         _swapTokensAtAmount = swapTokensAtAmount;
602     }
603 
604     //Set minimum tokens required to swap.
605     function toggleSwap(bool _swapEnabled) public onlyOwner {
606         swapEnabled = _swapEnabled;
607     }
608 
609     //Set maximum transaction
610     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
611         _maxTxAmount = maxTxAmount;
612     }
613 
614     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
615         _maxWalletSize = maxWalletSize;
616     }
617 
618     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
619         for(uint256 i = 0; i < accounts.length; i++) {
620             _isExcludedFromFee[accounts[i]] = excluded;
621         }
622     }
623 
624     function allowPreTrading(address[] calldata accounts) public onlyOwner {
625         for(uint256 i = 0; i < accounts.length; i++) {
626                  preTrader[accounts[i]] = true;
627         }
628     }
629 
630     function removePreTrading(address[] calldata accounts) public onlyOwner {
631         for(uint256 i = 0; i < accounts.length; i++) {
632                  delete preTrader[accounts[i]];
633         }
634     }
635 }