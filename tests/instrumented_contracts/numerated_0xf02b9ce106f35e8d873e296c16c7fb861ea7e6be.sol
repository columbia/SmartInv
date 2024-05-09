1 /**
2  *
3 */
4 
5 /**
6  *
7 */
8 
9 /**
10 
11 For every fallen $SALTY soldier out there. 
12 
13 https://salteth.me/
14 
15 https://twitter.com/SaltyERC
16 
17 https://t.me/SALTYETH
18 
19  */
20 // SPDX-License-Identifier: Unlicensed
21 pragma solidity ^0.8.9;
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
171 contract SALTY is Context, IERC20, Ownable {
172 
173     using SafeMath for uint256;
174 
175     string private constant _name = "SALT";
176     string private constant _symbol = "SALTY";
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
187 
188     // Taxes
189     uint256 private _redisFeeOnBuy = 0;
190     uint256 private _taxFeeOnBuy = 3;
191     uint256 private _redisFeeOnSell = 0;
192     uint256 private _taxFeeOnSell = 3;
193 
194     //Original Fee
195     uint256 private _redisFee = _redisFeeOnSell;
196     uint256 private _taxFee = _taxFeeOnSell;
197 
198     uint256 private _previousredisFee = _redisFee;
199     uint256 private _previoustaxFee = _taxFee;
200 
201     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
202     address payable private _developmentAddress = payable(0x68e41E175d83636598238532C4dc9e5B82C42F89);
203     address payable private _marketingAddress = payable(0x68e41E175d83636598238532C4dc9e5B82C42F89);
204 
205     IUniswapV2Router02 public uniswapV2Router;
206     address public uniswapV2Pair;
207 
208     bool private tradingOpen = true;
209     bool private inSwap = false;
210     bool private swapEnabled = true;
211 
212     uint256 public _maxTxAmount = 20000 * 10**9; // 2%
213     uint256 public _maxWalletSize = 20000 * 10**9; // 2%
214     uint256 public _swapTokensAtAmount = 1500 * 10**9; // .15%
215 
216     event MaxTxAmountUpdated(uint256 _maxTxAmount);
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222 
223     constructor() {
224 
225         _rOwned[_msgSender()] = _rTotal;
226 
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231 
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[_developmentAddress] = true;
235         _isExcludedFromFee[_marketingAddress] = true;
236 
237         emit Transfer(address(0), _msgSender(), _tTotal);
238     }
239 
240     function name() public pure returns (string memory) {
241         return _name;
242     }
243 
244     function symbol() public pure returns (string memory) {
245         return _symbol;
246     }
247 
248     function decimals() public pure returns (uint8) {
249         return _decimals;
250     }
251 
252     function totalSupply() public pure override returns (uint256) {
253         return _tTotal;
254     }
255 
256     function balanceOf(address account) public view override returns (uint256) {
257         return tokenFromReflection(_rOwned[account]);
258     }
259 
260     function transfer(address recipient, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     function allowance(address owner, address spender)
270         public
271         view
272         override
273         returns (uint256)
274     {
275         return _allowances[owner][spender];
276     }
277 
278     function approve(address spender, uint256 amount)
279         public
280         override
281         returns (bool)
282     {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public override returns (bool) {
292         _transfer(sender, recipient, amount);
293         _approve(
294             sender,
295             _msgSender(),
296             _allowances[sender][_msgSender()].sub(
297                 amount,
298                 "ERC20: transfer amount exceeds allowance"
299             )
300         );
301         return true;
302     }
303 
304     function tokenFromReflection(uint256 rAmount)
305         private
306         view
307         returns (uint256)
308     {
309         require(
310             rAmount <= _rTotal,
311             "Amount must be less than total reflections"
312         );
313         uint256 currentRate = _getRate();
314         return rAmount.div(currentRate);
315     }
316 
317     function removeAllFee() private {
318         if (_redisFee == 0 && _taxFee == 0) return;
319 
320         _previousredisFee = _redisFee;
321         _previoustaxFee = _taxFee;
322 
323         _redisFee = 0;
324         _taxFee = 0;
325     }
326 
327     function restoreAllFee() private {
328         _redisFee = _previousredisFee;
329         _taxFee = _previoustaxFee;
330     }
331 
332     function _approve(
333         address owner,
334         address spender,
335         uint256 amount
336     ) private {
337         require(owner != address(0), "ERC20: approve from the zero address");
338         require(spender != address(0), "ERC20: approve to the zero address");
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) private {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "Transfer amount must be greater than zero");
351 
352         if (from != owner() && to != owner()) {
353 
354             //Trade start check
355             if (!tradingOpen) {
356                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
357             }
358 
359             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
360             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
361 
362             if(to != uniswapV2Pair) {
363                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
364             }
365 
366             uint256 contractTokenBalance = balanceOf(address(this));
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368 
369             if(contractTokenBalance >= _maxTxAmount)
370             {
371                 contractTokenBalance = _maxTxAmount;
372             }
373 
374             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
375                 swapTokensForEth(contractTokenBalance);
376                 uint256 contractETHBalance = address(this).balance;
377                 if (contractETHBalance > 0) {
378                     sendETHToFee(address(this).balance);
379                 }
380             }
381         }
382 
383         bool takeFee = true;
384 
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389 
390             //Set Fee for Buys
391             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnBuy;
393                 _taxFee = _taxFeeOnBuy;
394             }
395 
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _redisFee = _redisFeeOnSell;
399                 _taxFee = _taxFeeOnSell;
400             }
401 
402         }
403 
404         _tokenTransfer(from, to, amount, takeFee);
405     }
406 
407     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = uniswapV2Router.WETH();
411         _approve(address(this), address(uniswapV2Router), tokenAmount);
412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             tokenAmount,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419     }
420 
421     function sendETHToFee(uint256 amount) private {
422         _marketingAddress.transfer(amount);
423     }
424 
425     function setTrading(bool _tradingOpen) public onlyOwner {
426         tradingOpen = _tradingOpen;
427     }
428 
429     function manualswap() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractBalance = balanceOf(address(this));
432         swapTokensForEth(contractBalance);
433     }
434 
435     function manualsend() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractETHBalance = address(this).balance;
438         sendETHToFee(contractETHBalance);
439     }
440 
441     function blockBots(address[] memory bots_) public onlyOwner {
442         for (uint256 i = 0; i < bots_.length; i++) {
443             bots[bots_[i]] = true;
444         }
445     }
446 
447     function unblockBot(address notbot) public onlyOwner {
448         bots[notbot] = false;
449     }
450 
451     function _tokenTransfer(
452         address sender,
453         address recipient,
454         uint256 amount,
455         bool takeFee
456     ) private {
457         if (!takeFee) removeAllFee();
458         _transferStandard(sender, recipient, amount);
459         if (!takeFee) restoreAllFee();
460     }
461 
462     function _transferStandard(
463         address sender,
464         address recipient,
465         uint256 tAmount
466     ) private {
467         (
468             uint256 rAmount,
469             uint256 rTransferAmount,
470             uint256 rFee,
471             uint256 tTransferAmount,
472             uint256 tFee,
473             uint256 tTeam
474         ) = _getValues(tAmount);
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
477         _takeTeam(tTeam);
478         _reflectFee(rFee, tFee);
479         emit Transfer(sender, recipient, tTransferAmount);
480     }
481 
482     function _takeTeam(uint256 tTeam) private {
483         uint256 currentRate = _getRate();
484         uint256 rTeam = tTeam.mul(currentRate);
485         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
486     }
487 
488     function _reflectFee(uint256 rFee, uint256 tFee) private {
489         _rTotal = _rTotal.sub(rFee);
490         _tFeeTotal = _tFeeTotal.add(tFee);
491     }
492 
493     receive() external payable {}
494 
495     function _getValues(uint256 tAmount)
496         private
497         view
498         returns (
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
508             _getTValues(tAmount, _redisFee, _taxFee);
509         uint256 currentRate = _getRate();
510         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
511             _getRValues(tAmount, tFee, tTeam, currentRate);
512         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getTValues(
516         uint256 tAmount,
517         uint256 redisFee,
518         uint256 taxFee
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 tFee = tAmount.mul(redisFee).div(100);
529         uint256 tTeam = tAmount.mul(taxFee).div(100);
530         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
531         return (tTransferAmount, tFee, tTeam);
532     }
533 
534     function _getRValues(
535         uint256 tAmount,
536         uint256 tFee,
537         uint256 tTeam,
538         uint256 currentRate
539     )
540         private
541         pure
542         returns (
543             uint256,
544             uint256,
545             uint256
546         )
547     {
548         uint256 rAmount = tAmount.mul(currentRate);
549         uint256 rFee = tFee.mul(currentRate);
550         uint256 rTeam = tTeam.mul(currentRate);
551         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
552         return (rAmount, rTransferAmount, rFee);
553     }
554 
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557         return rSupply.div(tSupply);
558     }
559 
560     function _getCurrentSupply() private view returns (uint256, uint256) {
561         uint256 rSupply = _rTotal;
562         uint256 tSupply = _tTotal;
563         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
564         return (rSupply, tSupply);
565     }
566 
567     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
568         _redisFeeOnBuy = redisFeeOnBuy;
569         _redisFeeOnSell = redisFeeOnSell;
570         _taxFeeOnBuy = taxFeeOnBuy;
571         _taxFeeOnSell = taxFeeOnSell;
572     }
573 
574     //Set minimum tokens required to swap.
575     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
576         _swapTokensAtAmount = swapTokensAtAmount;
577     }
578 
579     //Set minimum tokens required to swap.
580     function toggleSwap(bool _swapEnabled) public onlyOwner {
581         swapEnabled = _swapEnabled;
582     }
583 
584     //Set maximum transaction
585     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
586         _maxTxAmount = maxTxAmount;
587     }
588 
589     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
590         _maxWalletSize = maxWalletSize;
591     }
592 
593     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
594         for(uint256 i = 0; i < accounts.length; i++) {
595             _isExcludedFromFee[accounts[i]] = excluded;
596         }
597     }
598 
599 }