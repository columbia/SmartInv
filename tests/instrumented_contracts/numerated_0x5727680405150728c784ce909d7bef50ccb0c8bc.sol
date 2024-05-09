1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-20
3 */
4 
5 // https://t.me/zBOOMETH
6 
7 
8 /// SPDX-License-Identifier: Unlicensed  
9 pragma solidity ^0.8.9;
10 
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
159 contract BOOM is Context, IERC20, Ownable {
160 
161     using SafeMath for uint256;
162 
163     string private constant _name = "BOOM";
164     string private constant _symbol = "$BOOM";
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
176     uint256 private _taxFeeOnBuy = 15;
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 30;
179 
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
188     address payable private _developmentAddress = payable(0xdd0DD940B520436186a669c4C0fEdF5267547840);
189     address payable private _marketingAddress = payable(0xdd0DD940B520436186a669c4C0fEdF5267547840);
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193 
194     bool private tradingOpen = true;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197 
198     uint256 public _maxTxAmount = 20000000 * 10**9;
199     uint256 public _maxWalletSize = 20000000 * 10**9;
200     uint256 public _swapTokensAtAmount = 10000 * 10**9;
201 
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor() {
210 
211         _rOwned[_msgSender()] = _rTotal;
212 
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217 
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222 
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225 
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229 
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233 
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237 
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241 
242     function balanceOf(address account) public view override returns (uint256) {
243         return tokenFromReflection(_rOwned[account]);
244     }
245 
246     function transfer(address recipient, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(address owner, address spender)
256         public
257         view
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263 
264     function approve(address spender, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) public override returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(
280             sender,
281             _msgSender(),
282             _allowances[sender][_msgSender()].sub(
283                 amount,
284                 "ERC20: transfer amount exceeds allowance"
285             )
286         );
287         return true;
288     }
289 
290     function tokenFromReflection(uint256 rAmount)
291         private
292         view
293         returns (uint256)
294     {
295         require(
296             rAmount <= _rTotal,
297             "Amount must be less than total reflections"
298         );
299         uint256 currentRate = _getRate();
300         return rAmount.div(currentRate);
301     }
302 
303     function removeAllFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305 
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308 
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312 
313     function restoreAllFee() private {
314         _redisFee = _previousredisFee;
315         _taxFee = _previoustaxFee;
316     }
317 
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337 
338         if (from != owner() && to != owner()) {
339 
340             //Trade start check
341             if (!tradingOpen) {
342                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344 
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
347 
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351 
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354 
355             if(contractTokenBalance >= _maxTxAmount)
356             {
357                 contractTokenBalance = _maxTxAmount;
358             }
359 
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 0) {
364                     sendETHToFee(address(this).balance);
365                 }
366             }
367         }
368 
369         bool takeFee = true;
370 
371         //Transfer Tokens
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375 
376             //Set Fee for Buys
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381 
382             //Set Fee for Sells
383             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnSell;
385                 _taxFee = _taxFeeOnSell;
386             }
387 
388         }
389 
390         _tokenTransfer(from, to, amount, takeFee);
391     }
392 
393     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = uniswapV2Router.WETH();
397         _approve(address(this), address(uniswapV2Router), tokenAmount);
398         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
399             tokenAmount,
400             0,
401             path,
402             address(this),
403             block.timestamp
404         );
405     }
406 
407     function sendETHToFee(uint256 amount) private {
408         _marketingAddress.transfer(amount);
409     }
410 
411     function setTrading(bool _tradingOpen) public onlyOwner {
412         tradingOpen = _tradingOpen;
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function blockBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432 
433     function unblockBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436 
437      function removeLimits() external onlyOwner {
438         _maxTxAmount = _tTotal;
439         _maxWalletSize = _tTotal;
440     }
441 
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount,
446         bool takeFee
447     ) private {
448         if (!takeFee) removeAllFee();
449         _transferStandard(sender, recipient, amount);
450         if (!takeFee) restoreAllFee();
451     }
452 
453     function _transferStandard(
454         address sender,
455         address recipient,
456         uint256 tAmount
457     ) private {
458         (
459             uint256 rAmount,
460             uint256 rTransferAmount,
461             uint256 rFee,
462             uint256 tTransferAmount,
463             uint256 tFee,
464             uint256 tTeam
465         ) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
468         _takeTeam(tTeam);
469         _reflectFee(rFee, tFee);
470         emit Transfer(sender, recipient, tTransferAmount);
471     }
472 
473     function _takeTeam(uint256 tTeam) private {
474         uint256 currentRate = _getRate();
475         uint256 rTeam = tTeam.mul(currentRate);
476         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
477     }
478 
479     function _reflectFee(uint256 rFee, uint256 tFee) private {
480         _rTotal = _rTotal.sub(rFee);
481         _tFeeTotal = _tFeeTotal.add(tFee);
482     }
483 
484     receive() external payable {}
485 
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
499             _getTValues(tAmount, _redisFee, _taxFee);
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
502             _getRValues(tAmount, tFee, tTeam, currentRate);
503         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getTValues(
507         uint256 tAmount,
508         uint256 redisFee,
509         uint256 taxFee
510     )
511         private
512         pure
513         returns (
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         uint256 tFee = tAmount.mul(redisFee).div(100);
520         uint256 tTeam = tAmount.mul(taxFee).div(100);
521         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
522         return (tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getRValues(
526         uint256 tAmount,
527         uint256 tFee,
528         uint256 tTeam,
529         uint256 currentRate
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 rAmount = tAmount.mul(currentRate);
540         uint256 rFee = tFee.mul(currentRate);
541         uint256 rTeam = tTeam.mul(currentRate);
542         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
543         return (rAmount, rTransferAmount, rFee);
544     }
545 
546     function _getRate() private view returns (uint256) {
547         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
548         return rSupply.div(tSupply);
549     }
550 
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555         return (rSupply, tSupply);
556     }
557 
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561         _taxFeeOnBuy = taxFeeOnBuy;
562         _taxFeeOnSell = taxFeeOnSell;
563     }
564 
565     //Set minimum tokens required to swap.
566     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
567         _swapTokensAtAmount = swapTokensAtAmount;
568     }
569 
570     //Set minimum tokens required to swap.
571     function toggleSwap(bool _swapEnabled) public onlyOwner {
572         swapEnabled = _swapEnabled;
573     }
574 
575 
576     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
577         for(uint256 i = 0; i < accounts.length; i++) {
578             _isExcludedFromFee[accounts[i]] = excluded;
579         }
580     }
581 
582 }