1 /*
2 https://medium.com/@dejitarukabuto
3 */
4 // SPDX-License-Identifier: Unlicensed
5 pragma solidity ^0.8.9;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 contract Ownable is Context {
39     address private _owner;
40     address private _previousOwner;
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45 
46     constructor() {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 
72 }
73 
74 library SafeMath {
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78         return c;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     function sub(
86         uint256 a,
87         uint256 b,
88         string memory errorMessage
89     ) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92         return c;
93     }
94 
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         if (a == 0) {
97             return 0;
98         }
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101         return c;
102     }
103 
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     function div(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         return c;
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     function createPair(address tokenA, address tokenB)
121         external
122         returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint256 amountIn,
128         uint256 amountOutMin,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external;
133 
134     function factory() external pure returns (address);
135 
136     function WETH() external pure returns (address);
137 
138     function addLiquidityETH(
139         address token,
140         uint256 amountTokenDesired,
141         uint256 amountTokenMin,
142         uint256 amountETHMin,
143         address to,
144         uint256 deadline
145     )
146         external
147         payable
148         returns (
149             uint256 amountToken,
150             uint256 amountETH,
151             uint256 liquidity
152         );
153 }
154 
155 contract KABUTO is Context, IERC20, Ownable {
156 
157     using SafeMath for uint256;
158 
159     string private constant _name = "Dejitaru Kabuto";
160     string private constant _symbol = "KABUTO";
161     uint8 private constant _decimals = 9;
162 
163     mapping(address => uint256) private _rOwned;
164     mapping(address => uint256) private _tOwned;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     mapping(address => bool) private _isExcludedFromFee;
167     uint256 private constant MAX = ~uint256(0);
168     uint256 private constant _tTotal = 1000000000 * 10**9;
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171     uint256 private _redisFeeOnBuy = 0;
172     uint256 private _taxFeeOnBuy = 0;
173     uint256 private _redisFeeOnSell = 0;
174     uint256 private _taxFeeOnSell = 0;
175 
176     //Original Fee
177     uint256 private _redisFee = _redisFeeOnSell;
178     uint256 private _taxFee = _taxFeeOnSell;
179 
180     uint256 private _previousredisFee = _redisFee;
181     uint256 private _previoustaxFee = _taxFee;
182 
183     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
184     address payable private _developmentAddress = payable(0x7EED01fE9c23978002730DE8779d70AA9Da873B5);
185     address payable private _marketingAddress = payable(0x7EED01fE9c23978002730DE8779d70AA9Da873B5);
186 
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189 
190     bool private tradingOpen = true;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193 
194     uint256 public _maxTxAmount = 20000000 * 10**9;
195     uint256 public _maxWalletSize = 20000000 * 10**9;
196     uint256 public _swapTokensAtAmount = 10000 * 10**9;
197 
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204 
205     constructor() {
206 
207         _rOwned[_msgSender()] = _rTotal;
208 
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
210         uniswapV2Router = _uniswapV2Router;
211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
212             .createPair(address(this), _uniswapV2Router.WETH());
213 
214         _isExcludedFromFee[owner()] = true;
215         _isExcludedFromFee[address(this)] = true;
216         _isExcludedFromFee[_developmentAddress] = true;
217         _isExcludedFromFee[_marketingAddress] = true;
218 
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221 
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225 
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229 
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233 
234      function buytax() public view  returns (uint256) {
235         return _taxFeeOnBuy;
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
303     function removeFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305 
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308 
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312 
313     function restoreFee() private {
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
411     function openTrading(bool _tradingOpen) public onlyOwner {
412         tradingOpen = _tradingOpen;
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualclaim() external {
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
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467 
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473 
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478 
479     receive() external payable {}
480 
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _redisFee, _taxFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500 
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517         return (tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538         return (rAmount, rTransferAmount, rFee);
539     }
540 
541     function _getRate() private view returns (uint256) {
542         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
543         return rSupply.div(tSupply);
544     }
545 
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550         return (rSupply, tSupply);
551     }
552 
553     function setFees(uint256 redisTaxBuy, uint256 redisTaxSell, uint256 taxFeeBuy, uint256 taxFeeSell) public onlyOwner {
554         _redisFeeOnBuy = redisTaxBuy;
555         _redisFeeOnSell = redisTaxSell;
556         _taxFeeOnBuy = taxFeeBuy;
557         _taxFeeOnSell = taxFeeSell;
558     }
559 
560     //Set minimum tokens required to swap.
561     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
562         _swapTokensAtAmount = swapTokensAtAmount;
563     }
564 
565     //Set minimum tokens required to swap.
566     function toggleSwap(bool _swapEnabled) public onlyOwner {
567         swapEnabled = _swapEnabled;
568     }
569 
570     //Set maximum transaction
571     
572 
573     function settxamount(uint256 maxtx,uint256 maxwallet) public onlyOwner {
574         _maxTxAmount = maxtx;
575         _maxWalletSize = maxwallet;
576         
577     }
578 
579     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
580         for(uint256 i = 0; i < accounts.length; i++) {
581             _isExcludedFromFee[accounts[i]] = excluded;
582         }
583     }
584 
585 }