1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 /**
7 
8 
9 
10             BOT -     @BoltERCBot
11             TG -      https://t.me/BoltBotERC
12             Twitter - https://twitter.com/BoltBotERC
13             Website - https://boltbot.net/
14             YouTube - https://www.youtube.com/@BoltBotERC
15 
16 
17 
18 */
19 
20 
21 pragma solidity ^0.8.16;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 contract Ownable is Context {
55     address private _owner;
56     address private _previousOwner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 
88 }
89 
90 library SafeMath {
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath: addition overflow");
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     function sub(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         require(b <= a, errorMessage);
107         uint256 c = a - b;
108         return c;
109     }
110 
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         if (a == 0) {
113             return 0;
114         }
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117         return c;
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     function div(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         return c;
132     }
133 }
134 
135 interface IUniswapV2Factory {
136     function createPair(address tokenA, address tokenB)
137         external
138         returns (address pair);
139 }
140 
141 interface IUniswapV2Router02 {
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint256 amountIn,
144         uint256 amountOutMin,
145         address[] calldata path,
146         address to,
147         uint256 deadline
148     ) external;
149 
150     function factory() external pure returns (address);
151 
152     function WETH() external pure returns (address);
153 
154     function addLiquidityETH(
155         address token,
156         uint256 amountTokenDesired,
157         uint256 amountTokenMin,
158         uint256 amountETHMin,
159         address to,
160         uint256 deadline
161     )
162         external
163         payable
164         returns (
165             uint256 amountToken,
166             uint256 amountETH,
167             uint256 liquidity
168         );
169 }
170 
171 contract BOLTBOT is Context, IERC20, Ownable {
172 
173     using SafeMath for uint256;
174 
175     string private constant _name = "BoltBot";
176     string private constant _symbol = "BOLT";
177     uint8 private constant _decimals = 9;
178 
179     mapping(address => uint256) private _rOwned;
180     mapping(address => uint256) private _tOwned;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping(address => bool) private _isExcludedFromFee;
183     uint256 private constant MAX = ~uint256(0);
184     uint256 private constant _tTotal = 1000000 * 10**9;
185     uint256 private _rTotal = (MAX - (MAX % _tTotal));
186     uint256 private _tFeeTotal;
187     uint256 private _redisFeeOnBuy = 0;
188     uint256 private _taxFeeOnBuy = 25;
189     uint256 private _redisFeeOnSell = 0;
190     uint256 private _taxFeeOnSell = 35;
191 
192     //Original Fee
193     uint256 private _redisFee = _redisFeeOnSell;
194     uint256 private _taxFee = _taxFeeOnSell;
195 
196     uint256 private _previousredisFee = _redisFee;
197     uint256 private _previoustaxFee = _taxFee;
198 
199     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
200     address payable private _developmentAddress = payable(msg.sender);
201     address payable private _marketingAddress = payable(msg.sender);
202 
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen = true;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209 
210     uint256 public _maxTxAmount = 10000 * 10**9;
211     uint256 public _maxWalletSize = 10000 * 10**9;
212     uint256 public _swapTokensAtAmount = 2500 * 10**9;
213 
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220 
221     constructor() {
222 
223         _rOwned[_msgSender()] = _rTotal;
224 
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229 
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_developmentAddress] = true;
233         _isExcludedFromFee[_marketingAddress] = true;
234 
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237 
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241 
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257 
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275 
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301 
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314 
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317 
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320 
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324 
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329 
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340 
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349 
350         if (from != owner() && to != owner()) {
351 
352             //Trade start check
353             if (!tradingOpen) {
354                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
355             }
356 
357             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
358             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
359 
360             if(to != uniswapV2Pair) {
361                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
362             }
363 
364             uint256 contractTokenBalance = balanceOf(address(this));
365             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
366 
367             if(contractTokenBalance >= _maxTxAmount)
368             {
369                 contractTokenBalance = _maxTxAmount;
370             }
371 
372             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
373                 swapTokensForEth(contractTokenBalance);
374                 uint256 contractETHBalance = address(this).balance;
375                 if (contractETHBalance > 0) {
376                     sendETHToFee(address(this).balance);
377                 }
378             }
379         }
380 
381         bool takeFee = true;
382 
383         //Transfer Tokens
384         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
385             takeFee = false;
386         } else {
387 
388             //Set Fee for Buys
389             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnBuy;
391                 _taxFee = _taxFeeOnBuy;
392             }
393 
394             //Set Fee for Sells
395             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnSell;
397                 _taxFee = _taxFeeOnSell;
398             }
399 
400         }
401 
402         _tokenTransfer(from, to, amount, takeFee);
403     }
404 
405     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = uniswapV2Router.WETH();
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
411             tokenAmount,
412             0,
413             path,
414             address(this),
415             block.timestamp
416         );
417     }
418 
419     function sendETHToFee(uint256 amount) private {
420         _marketingAddress.transfer(amount);
421     }
422 
423     function setTrading(bool _tradingOpen) public onlyOwner {
424         tradingOpen = _tradingOpen;
425     }
426 
427     function manualswap() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
429         uint256 contractBalance = balanceOf(address(this));
430         swapTokensForEth(contractBalance);
431     }
432 
433     function manualsend() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractETHBalance = address(this).balance;
436         sendETHToFee(contractETHBalance);
437     }
438 
439     function blockbots(address[] memory bots_) public onlyOwner {
440         for (uint256 i = 0; i < bots_.length; i++) {
441             bots[bots_[i]] = true;
442         }
443     }
444 
445     function unblackaddress(address notbot) public onlyOwner {
446         bots[notbot] = false;
447     }
448 
449     function _tokenTransfer(
450         address sender,
451         address recipient,
452         uint256 amount,
453         bool takeFee
454     ) private {
455         if (!takeFee) removeAllFee();
456         _transferStandard(sender, recipient, amount);
457         if (!takeFee) restoreAllFee();
458     }
459 
460     function _transferStandard(
461         address sender,
462         address recipient,
463         uint256 tAmount
464     ) private {
465         (
466             uint256 rAmount,
467             uint256 rTransferAmount,
468             uint256 rFee,
469             uint256 tTransferAmount,
470             uint256 tFee,
471             uint256 tTeam
472         ) = _getValues(tAmount);
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
475         _takeTeam(tTeam);
476         _reflectFee(rFee, tFee);
477         emit Transfer(sender, recipient, tTransferAmount);
478     }
479 
480     function _takeTeam(uint256 tTeam) private {
481         uint256 currentRate = _getRate();
482         uint256 rTeam = tTeam.mul(currentRate);
483         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
484     }
485 
486     function _reflectFee(uint256 rFee, uint256 tFee) private {
487         _rTotal = _rTotal.sub(rFee);
488         _tFeeTotal = _tFeeTotal.add(tFee);
489     }
490 
491     receive() external payable {}
492 
493     function _getValues(uint256 tAmount)
494         private
495         view
496         returns (
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
506             _getTValues(tAmount, _redisFee, _taxFee);
507         uint256 currentRate = _getRate();
508         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
509             _getRValues(tAmount, tFee, tTeam, currentRate);
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512 
513     function _getTValues(
514         uint256 tAmount,
515         uint256 redisFee,
516         uint256 taxFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(redisFee).div(100);
527         uint256 tTeam = tAmount.mul(taxFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529         return (tTransferAmount, tFee, tTeam);
530     }
531 
532     function _getRValues(
533         uint256 tAmount,
534         uint256 tFee,
535         uint256 tTeam,
536         uint256 currentRate
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 rAmount = tAmount.mul(currentRate);
547         uint256 rFee = tFee.mul(currentRate);
548         uint256 rTeam = tTeam.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
550         return (rAmount, rTransferAmount, rFee);
551     }
552 
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555         return rSupply.div(tSupply);
556     }
557 
558     function _getCurrentSupply() private view returns (uint256, uint256) {
559         uint256 rSupply = _rTotal;
560         uint256 tSupply = _tTotal;
561         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
562         return (rSupply, tSupply);
563     }
564 
565     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
566         _redisFeeOnBuy = redisFeeOnBuy;
567         _redisFeeOnSell = redisFeeOnSell;
568         _taxFeeOnBuy = taxFeeOnBuy;
569         _taxFeeOnSell = taxFeeOnSell;
570     }
571 
572     //Set minimum tokens required to swap.
573     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
574         _swapTokensAtAmount = swapTokensAtAmount;
575     }
576 
577     //Set minimum tokens required to swap.
578     function toggleSwap(bool _swapEnabled) public onlyOwner {
579         swapEnabled = _swapEnabled;
580     }
581 
582     //Set maximum transaction
583     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
584         _maxTxAmount = maxTxAmount;
585     }
586 
587     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
588         _maxWalletSize = maxWalletSize;
589     }
590 
591     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
592         for(uint256 i = 0; i < accounts.length; i++) {
593             _isExcludedFromFee[accounts[i]] = excluded;
594         }
595     }
596 
597 }