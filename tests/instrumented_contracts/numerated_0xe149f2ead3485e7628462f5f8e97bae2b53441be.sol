1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-23
3 */
4 
5 /**
6 
7 Tweet about this token:
8 https://twitter.com/elonmusk/status/1586918804780630016
9 
10 */
11 
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.8.9;
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
165 contract Vine is Context, IERC20, Ownable {
166 
167     using SafeMath for uint256;
168 
169     string private constant _name = unicode"Vine";
170     string private constant _symbol = unicode"Vine";
171     uint8 private constant _decimals = 9;
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
182     uint256 private _taxFeeOnBuy = 4;
183     uint256 private _redisFeeOnSell = 0;
184     uint256 private _taxFeeOnSell = 4;
185 
186     //Original Fee
187     uint256 private _redisFee = _redisFeeOnSell;
188     uint256 private _taxFee = _taxFeeOnSell;
189 
190     uint256 private _previousredisFee = _redisFee;
191     uint256 private _previoustaxFee = _taxFee;
192 
193     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
194     address payable private _developmentAddress = payable(0x357f1e397eC84413bb9d1Bb7a992287512EF3Ae4);
195     address payable private _marketingAddress = payable(0x357f1e397eC84413bb9d1Bb7a992287512EF3Ae4);
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203 
204     uint256 public _maxTxAmount = 20000000 * 10**9;
205     uint256 public _maxWalletSize = 20000000 * 10**9;
206     uint256 public _swapTokensAtAmount = 10000 * 10**9;
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
308 
309     function removeAllFee() private {
310         if (_redisFee == 0 && _taxFee == 0) return;
311 
312         _previousredisFee = _redisFee;
313         _previoustaxFee = _taxFee;
314 
315         _redisFee = 0;
316         _taxFee = 0;
317     }
318 
319     function restoreAllFee() private {
320         _redisFee = _previousredisFee;
321         _taxFee = _previoustaxFee;
322     }
323 
324     function _approve(
325         address owner,
326         address spender,
327         uint256 amount
328     ) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) private {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343 
344         if (from != owner() && to != owner()) {
345 
346             //Trade start check
347             if (!tradingOpen) {
348                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
349             }
350 
351             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
352             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
353 
354             if(to != uniswapV2Pair) {
355                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
356             }
357 
358             uint256 contractTokenBalance = balanceOf(address(this));
359             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
360 
361             if(contractTokenBalance >= _maxTxAmount)
362             {
363                 contractTokenBalance = _maxTxAmount;
364             }
365 
366             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         }
374 
375         bool takeFee = true;
376 
377         //Transfer Tokens
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381 
382             //Set Fee for Buys
383             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             //Set Fee for Sells
389             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnSell;
391                 _taxFee = _taxFeeOnSell;
392             }
393 
394         }
395 
396         _tokenTransfer(from, to, amount, takeFee);
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
400         address[] memory path = new address[](2);
401         path[0] = address(this);
402         path[1] = uniswapV2Router.WETH();
403         _approve(address(this), address(uniswapV2Router), tokenAmount);
404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
405             tokenAmount,
406             0,
407             path,
408             address(this),
409             block.timestamp
410         );
411     }
412 
413     function sendETHToFee(uint256 amount) private {
414         _marketingAddress.transfer(amount);
415     }
416 
417     function setTrading(bool _tradingOpen) public onlyOwner {
418         tradingOpen = _tradingOpen;
419     }
420 
421     function manualswap() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractBalance = balanceOf(address(this));
424         swapTokensForEth(contractBalance);
425     }
426 
427     function manualsend() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
429         uint256 contractETHBalance = address(this).balance;
430         sendETHToFee(contractETHBalance);
431     }
432 
433     function blockBots(address[] memory bots_) public onlyOwner {
434         for (uint256 i = 0; i < bots_.length; i++) {
435             bots[bots_[i]] = true;
436         }
437     }
438 
439     function unblockBot(address notbot) public onlyOwner {
440         bots[notbot] = false;
441     }
442 
443     function _tokenTransfer(
444         address sender,
445         address recipient,
446         uint256 amount,
447         bool takeFee
448     ) private {
449         if (!takeFee) removeAllFee();
450         _transferStandard(sender, recipient, amount);
451         if (!takeFee) restoreAllFee();
452     }
453 
454     function _transferStandard(
455         address sender,
456         address recipient,
457         uint256 tAmount
458     ) private {
459         (
460             uint256 rAmount,
461             uint256 rTransferAmount,
462             uint256 rFee,
463             uint256 tTransferAmount,
464             uint256 tFee,
465             uint256 tTeam
466         ) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
469         _takeTeam(tTeam);
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473 
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate = _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478     }
479 
480     function _reflectFee(uint256 rFee, uint256 tFee) private {
481         _rTotal = _rTotal.sub(rFee);
482         _tFeeTotal = _tFeeTotal.add(tFee);
483     }
484 
485     receive() external payable {}
486 
487     function _getValues(uint256 tAmount)
488         private
489         view
490         returns (
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
500             _getTValues(tAmount, _redisFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(
508         uint256 tAmount,
509         uint256 redisFee,
510         uint256 taxFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(redisFee).div(100);
521         uint256 tTeam = tAmount.mul(taxFee).div(100);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
523         return (tTransferAmount, tFee, tTeam);
524     }
525 
526     function _getRValues(
527         uint256 tAmount,
528         uint256 tFee,
529         uint256 tTeam,
530         uint256 currentRate
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 rAmount = tAmount.mul(currentRate);
541         uint256 rFee = tFee.mul(currentRate);
542         uint256 rTeam = tTeam.mul(currentRate);
543         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
544         return (rAmount, rTransferAmount, rFee);
545     }
546 
547     function _getRate() private view returns (uint256) {
548         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
549         return rSupply.div(tSupply);
550     }
551 
552     function _getCurrentSupply() private view returns (uint256, uint256) {
553         uint256 rSupply = _rTotal;
554         uint256 tSupply = _tTotal;
555         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
556         return (rSupply, tSupply);
557     }
558 
559     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
560         _redisFeeOnBuy = redisFeeOnBuy;
561         _redisFeeOnSell = redisFeeOnSell;
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564     }
565 
566     //Set minimum tokens required to swap.
567     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
568         _swapTokensAtAmount = swapTokensAtAmount;
569     }
570 
571     //Set minimum tokens required to swap.
572     function toggleSwap(bool _swapEnabled) public onlyOwner {
573         swapEnabled = _swapEnabled;
574     }
575 
576     //Set maximum transaction
577     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
578         _maxTxAmount = maxTxAmount;
579     }
580 
581     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
582         _maxWalletSize = maxWalletSize;
583     }
584 
585     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
586         for(uint256 i = 0; i < accounts.length; i++) {
587             _isExcludedFromFee[accounts[i]] = excluded;
588         }
589     }
590 
591 }