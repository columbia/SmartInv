1 //Telegram: https://t.me/OPOEerc20
2 /// SPDX-License-Identifier: Unlicensed
3 
4 
5 
6 pragma solidity ^0.8.20;
7 
8 
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
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
158 contract OnlyPossibleOnEthereum is Context, IERC20, Ownable {
159 
160     using SafeMath for uint256;
161 
162     string private constant _name = unicode"Only Possible On Ethereum ";
163     string private constant _symbol = unicode"OPOE";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 1000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 15;
176     uint256 private _redisFeeOnSell = 0;
177     uint256 private _taxFeeOnSell = 45;
178 
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182 
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185 
186     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
187     address payable private _developmentAddress = payable(0x8184869944FEf54Fb111042931C316E73eD8406c);
188     address payable private _marketingAddress = payable(0x8184869944FEf54Fb111042931C316E73eD8406c);
189 
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192 
193     bool private tradingOpen = false;
194     bool private inSwap = false;
195     bool private swapEnabled =true;
196 
197     uint256 public _maxTxAmount = 20000000 * 10**9;
198     uint256 public _maxWalletSize = 20000000 * 10**9;
199     uint256 public _swapTokensAtAmount = 1000000000 * 10**9;
200 
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207 
208     constructor() {
209 
210         _rOwned[_msgSender()] = _rTotal;
211 
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216 
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_developmentAddress] = true;
220         _isExcludedFromFee[_marketingAddress] = true;
221 
222         emit Transfer(address(0), _msgSender(), _tTotal);
223     }
224 
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228 
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232 
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236 
237     function totalSupply() public pure override returns (uint256) {
238         return _tTotal;
239     }
240 
241     function balanceOf(address account) public view override returns (uint256) {
242         return tokenFromReflection(_rOwned[account]);
243     }
244 
245     function transfer(address recipient, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     function allowance(address owner, address spender)
255         public
256         view
257         override
258         returns (uint256)
259     {
260         return _allowances[owner][spender];
261     }
262 
263     function approve(address spender, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(
279             sender,
280             _msgSender(),
281             _allowances[sender][_msgSender()].sub(
282                 amount,
283                 "ERC20: transfer amount exceeds allowance"
284             )
285         );
286         return true;
287     }
288 
289     function tokenFromReflection(uint256 rAmount)
290         private
291         view
292         returns (uint256)
293     {
294         require(
295             rAmount <= _rTotal,
296             "Amount must be less than total reflections"
297         );
298         uint256 currentRate = _getRate();
299         return rAmount.div(currentRate);
300     }
301 
302     function removeAllFee() private {
303         if (_redisFee == 0 && _taxFee == 0) return;
304 
305         _previousredisFee = _redisFee;
306         _previoustaxFee = _taxFee;
307 
308         _redisFee = 0;
309         _taxFee = 0;
310     }
311 
312     function restoreAllFee() private {
313         _redisFee = _previousredisFee;
314         _taxFee = _previoustaxFee;
315     }
316 
317     function _approve(
318         address owner,
319         address spender,
320         uint256 amount
321     ) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327 
328     function _transfer(
329         address from,
330         address to,
331         uint256 amount
332     ) private {
333         require(from != address(0), "ERC20: transfer from the zero address");
334         require(to != address(0), "ERC20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336 
337         if (from != owner() && to != owner()) {
338 
339             //Trade start check
340             if (!tradingOpen) {
341                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
342             }
343 
344             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
345             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
346 
347             if(to != uniswapV2Pair) {
348                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
349             }
350 
351             uint256 contractTokenBalance = balanceOf(address(this));
352             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
353 
354             if(contractTokenBalance >= _maxTxAmount)
355             {
356                 contractTokenBalance = _maxTxAmount;
357             }
358 
359             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
360                 swapTokensForEth(contractTokenBalance);
361                 uint256 contractETHBalance = address(this).balance;
362                 if (contractETHBalance > 0) {
363                     sendETHToFee(address(this).balance);
364                 }
365             }
366         }
367 
368         bool takeFee = true;
369 
370         //Transfer Tokens
371         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
372             takeFee = false;
373         } else {
374 
375             //Set Fee for Buys
376             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnBuy;
378                 _taxFee = _taxFeeOnBuy;
379             }
380 
381             //Set Fee for Sells
382             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnSell;
384                 _taxFee = _taxFeeOnSell;
385             }
386 
387         }
388 
389         _tokenTransfer(from, to, amount, takeFee);
390     }
391 
392     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
393         address[] memory path = new address[](2);
394         path[0] = address(this);
395         path[1] = uniswapV2Router.WETH();
396         _approve(address(this), address(uniswapV2Router), tokenAmount);
397         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
398             tokenAmount,
399             0,
400             path,
401             address(this),
402             block.timestamp
403         );
404     }
405 
406     function sendETHToFee(uint256 amount) private {
407         _marketingAddress.transfer(amount);
408     }
409 
410     function activateTrading() public onlyOwner {
411         tradingOpen = true;
412     }
413 
414     function manualswap() external {
415         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
416         uint256 contractBalance = balanceOf(address(this));
417         swapTokensForEth(contractBalance);
418     }
419 
420     function manualsend() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractETHBalance = address(this).balance;
423         sendETHToFee(contractETHBalance);
424     }
425 
426     function blockBots(address[] memory bots_) public onlyOwner {
427         for (uint256 i = 0; i < bots_.length; i++) {
428             bots[bots_[i]] = true;
429         }
430     }
431 
432     function unblockBot(address notbot) public onlyOwner {
433         bots[notbot] = false;
434     }
435 
436     function _tokenTransfer(
437         address sender,
438         address recipient,
439         uint256 amount,
440         bool takeFee
441     ) private {
442         if (!takeFee) removeAllFee();
443         _transferStandard(sender, recipient, amount);
444         if (!takeFee) restoreAllFee();
445     }
446 
447     function _transferStandard(
448         address sender,
449         address recipient,
450         uint256 tAmount
451     ) private {
452         (
453             uint256 rAmount,
454             uint256 rTransferAmount,
455             uint256 rFee,
456             uint256 tTransferAmount,
457             uint256 tFee,
458             uint256 tTeam
459         ) = _getValues(tAmount);
460         _rOwned[sender] = _rOwned[sender].sub(rAmount);
461         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
462         _takeTeam(tTeam);
463         _reflectFee(rFee, tFee);
464         emit Transfer(sender, recipient, tTransferAmount);
465     }
466 
467     function _takeTeam(uint256 tTeam) private {
468         uint256 currentRate = _getRate();
469         uint256 rTeam = tTeam.mul(currentRate);
470         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
471     }
472 
473     function _reflectFee(uint256 rFee, uint256 tFee) private {
474         _rTotal = _rTotal.sub(rFee);
475         _tFeeTotal = _tFeeTotal.add(tFee);
476     }
477 
478     receive() external payable {}
479 
480     function _getValues(uint256 tAmount)
481         private
482         view
483         returns (
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256
490         )
491     {
492         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
493             _getTValues(tAmount, _redisFee, _taxFee);
494         uint256 currentRate = _getRate();
495         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
496             _getRValues(tAmount, tFee, tTeam, currentRate);
497         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
498     }
499 
500     function _getTValues(
501         uint256 tAmount,
502         uint256 redisFee,
503         uint256 taxFee
504     )
505         private
506         pure
507         returns (
508             uint256,
509             uint256,
510             uint256
511         )
512     {
513         uint256 tFee = tAmount.mul(redisFee).div(100);
514         uint256 tTeam = tAmount.mul(taxFee).div(100);
515         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
516         return (tTransferAmount, tFee, tTeam);
517     }
518 
519     function _getRValues(
520         uint256 tAmount,
521         uint256 tFee,
522         uint256 tTeam,
523         uint256 currentRate
524     )
525         private
526         pure
527         returns (
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         uint256 rAmount = tAmount.mul(currentRate);
534         uint256 rFee = tFee.mul(currentRate);
535         uint256 rTeam = tTeam.mul(currentRate);
536         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
537         return (rAmount, rTransferAmount, rFee);
538     }
539 
540     function _getRate() private view returns (uint256) {
541         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
542         return rSupply.div(tSupply);
543     }
544 
545     function _getCurrentSupply() private view returns (uint256, uint256) {
546         uint256 rSupply = _rTotal;
547         uint256 tSupply = _tTotal;
548         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
549         return (rSupply, tSupply);
550     }
551 
552     function updateFees(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
553 
554         require((redisFeeOnBuy + taxFeeOnBuy) <= 25);
555         require((redisFeeOnSell + taxFeeOnSell) <= 50);
556         _redisFeeOnBuy = redisFeeOnBuy;
557         _redisFeeOnSell = redisFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560     }
561 
562     //Set minimum tokens required to swap.
563     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
564         _swapTokensAtAmount = swapTokensAtAmount;
565     }
566 
567     //Set minimum tokens required to swap.
568     function toggleSwap(bool _swapEnabled) public onlyOwner {
569         swapEnabled = _swapEnabled;
570     }
571 
572     //Set maximum transaction
573     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
574         _maxTxAmount = maxTxAmount;
575     }
576 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = maxWalletSize;
579     }
580 
581     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
582         for(uint256 i = 0; i < accounts.length; i++) {
583             _isExcludedFromFee[accounts[i]] = excluded;
584         }
585     }
586 
587     function removeLimits() public onlyOwner{
588 
589         _maxTxAmount = _tTotal;
590         _maxWalletSize = _tTotal;
591     } 
592 
593 }