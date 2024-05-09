1 /**
2 
3 TG - https://t.me/forkliftcertifiedportal
4 Twitter - https://twitter.com/Forkliftcoin
5 Website - https://www.liftingeth.com
6 
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.14;
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 
76 }
77 
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88 
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98 
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107 
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122 
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158 
159 contract LIFT is Context, IERC20, Ownable {
160 
161     using SafeMath for uint256;
162 
163     string private constant _name = "ForkLift Certified";
164     string private constant _symbol = "LIFT";
165     uint8 private constant _decimals = 9;
166 
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 1000000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 private _redisFeeOnBuy = 0;
176     uint256 private _taxFeeOnBuy = 2;
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 2;
179 
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
188     mapping (address => bool) public preTrader;
189     address payable private _developmentAddress = payable(0x0806C060A6B7c07b4966ac9a0175A7802075D581);
190     address payable private _marketingAddress = payable(0x0806C060A6B7c07b4966ac9a0175A7802075D581);
191 
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194 
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198 
199     uint256 public _maxTxAmount = 20000000 * 10**9;
200     uint256 public _maxWalletSize = 20000000 * 10**9;
201     uint256 public _swapTokensAtAmount = 500000 * 10**9;
202 
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209 
210     constructor() {
211 
212         _rOwned[_msgSender()] = _rTotal;
213 
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218 
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223 
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246 
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264 
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290 
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303 
304     function removeAllFee() private {
305         if (_redisFee == 0 && _taxFee == 0) return;
306 
307         _previousredisFee = _redisFee;
308         _previoustaxFee = _taxFee;
309 
310         _redisFee = 0;
311         _taxFee = 0;
312     }
313 
314     function restoreAllFee() private {
315         _redisFee = _previousredisFee;
316         _taxFee = _previoustaxFee;
317     }
318 
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338 
339         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
340 
341             //Trade start check
342             if (!tradingOpen) {
343                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
344             }
345 
346             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
348 
349             if(to != uniswapV2Pair) {
350                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
351             }
352 
353             uint256 contractTokenBalance = balanceOf(address(this));
354             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
355 
356             if(contractTokenBalance >= _maxTxAmount)
357             {
358                 contractTokenBalance = _maxTxAmount;
359             }
360 
361             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
362                 swapTokensForEth(contractTokenBalance);
363                 uint256 contractETHBalance = address(this).balance;
364                 if (contractETHBalance > 0) {
365                     sendETHToFee(address(this).balance);
366                 }
367             }
368         }
369 
370         bool takeFee = true;
371 
372         //Transfer Tokens
373         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
374             takeFee = false;
375         } else {
376 
377             //Set Fee for Buys
378             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
379                 _redisFee = _redisFeeOnBuy;
380                 _taxFee = _taxFeeOnBuy;
381             }
382 
383             //Set Fee for Sells
384             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnSell;
386                 _taxFee = _taxFeeOnSell;
387             }
388 
389         }
390 
391         _tokenTransfer(from, to, amount, takeFee);
392     }
393 
394     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = uniswapV2Router.WETH();
398         _approve(address(this), address(uniswapV2Router), tokenAmount);
399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0,
402             path,
403             address(this),
404             block.timestamp
405         );
406     }
407 
408     function sendETHToFee(uint256 amount) private {
409         _marketingAddress.transfer(amount);
410     }
411 
412     function setTrading(bool _tradingOpen) public onlyOwner {
413         tradingOpen = _tradingOpen;
414     }
415 
416     function manualswap() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractBalance = balanceOf(address(this));
419         swapTokensForEth(contractBalance);
420     }
421 
422     function manualsend() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractETHBalance = address(this).balance;
425         sendETHToFee(contractETHBalance);
426     }
427 
428     function blockBots(address[] memory bots_) public onlyOwner {
429         for (uint256 i = 0; i < bots_.length; i++) {
430             bots[bots_[i]] = true;
431         }
432     }
433 
434     function unblockBot(address notbot) public onlyOwner {
435         bots[notbot] = false;
436     }
437 
438     function _tokenTransfer(
439         address sender,
440         address recipient,
441         uint256 amount,
442         bool takeFee
443     ) private {
444         if (!takeFee) removeAllFee();
445         _transferStandard(sender, recipient, amount);
446         if (!takeFee) restoreAllFee();
447     }
448 
449     function _transferStandard(
450         address sender,
451         address recipient,
452         uint256 tAmount
453     ) private {
454         (
455             uint256 rAmount,
456             uint256 rTransferAmount,
457             uint256 rFee,
458             uint256 tTransferAmount,
459             uint256 tFee,
460             uint256 tTeam
461         ) = _getValues(tAmount);
462         _rOwned[sender] = _rOwned[sender].sub(rAmount);
463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
464         _takeTeam(tTeam);
465         _reflectFee(rFee, tFee);
466         emit Transfer(sender, recipient, tTransferAmount);
467     }
468 
469     function _takeTeam(uint256 tTeam) private {
470         uint256 currentRate = _getRate();
471         uint256 rTeam = tTeam.mul(currentRate);
472         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
473     }
474 
475     function _reflectFee(uint256 rFee, uint256 tFee) private {
476         _rTotal = _rTotal.sub(rFee);
477         _tFeeTotal = _tFeeTotal.add(tFee);
478     }
479 
480     receive() external payable {}
481 
482     function _getValues(uint256 tAmount)
483         private
484         view
485         returns (
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
495             _getTValues(tAmount, _redisFee, _taxFee);
496         uint256 currentRate = _getRate();
497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
498             _getRValues(tAmount, tFee, tTeam, currentRate);
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getTValues(
503         uint256 tAmount,
504         uint256 redisFee,
505         uint256 taxFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(redisFee).div(100);
516         uint256 tTeam = tAmount.mul(taxFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
518         return (tTransferAmount, tFee, tTeam);
519     }
520 
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539         return (rAmount, rTransferAmount, rFee);
540     }
541 
542     function _getRate() private view returns (uint256) {
543         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
544         return rSupply.div(tSupply);
545     }
546 
547     function _getCurrentSupply() private view returns (uint256, uint256) {
548         uint256 rSupply = _rTotal;
549         uint256 tSupply = _tTotal;
550         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
551         return (rSupply, tSupply);
552     }
553 
554     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
555         _redisFeeOnBuy = redisFeeOnBuy;
556         _redisFeeOnSell = redisFeeOnSell;
557         _taxFeeOnBuy = taxFeeOnBuy;
558         _taxFeeOnSell = taxFeeOnSell;
559     }
560 
561     //Set minimum tokens required to swap.
562     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
563         _swapTokensAtAmount = swapTokensAtAmount;
564     }
565 
566     //Set minimum tokens required to swap.
567     function toggleSwap(bool _swapEnabled) public onlyOwner {
568         swapEnabled = _swapEnabled;
569     }
570 
571     //Set maximum transaction
572     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
573         _maxTxAmount = maxTxAmount;
574     }
575 
576     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
577         _maxWalletSize = maxWalletSize;
578     }
579 
580     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
581         for(uint256 i = 0; i < accounts.length; i++) {
582             _isExcludedFromFee[accounts[i]] = excluded;
583         }
584     }
585 
586     function allowPreTrading(address[] calldata accounts) public onlyOwner {
587         for(uint256 i = 0; i < accounts.length; i++) {
588                  preTrader[accounts[i]] = true;
589         }
590     }
591 
592     function removePreTrading(address[] calldata accounts) public onlyOwner {
593         for(uint256 i = 0; i < accounts.length; i++) {
594                  delete preTrader[accounts[i]];
595         }
596     }
597 }