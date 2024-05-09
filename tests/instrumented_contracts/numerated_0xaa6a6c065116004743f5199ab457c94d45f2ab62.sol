1 // Tsuyu the female girlfriend of Tsuka, offering Artificial Intelligence along with EVM Blockchain Utilities
2 //https://t.me/TsuyuOfficial
3 
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
155 contract TSUYU is Context, IERC20, Ownable {
156 
157     using SafeMath for uint256;
158 
159     string private constant _name = " TSUYU";
160     string private constant _symbol = "TSU";
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
172     uint256 private _taxFeeOnBuy = 40;
173     uint256 private _redisFeeOnSell = 0;
174     uint256 private _taxFeeOnSell = 40;
175 
176     //Original Fee
177     uint256 private _redisFee = _redisFeeOnSell;
178     uint256 private _taxFee = _taxFeeOnSell;
179 
180     uint256 private _previousredisFee = _redisFee;
181     uint256 private _previoustaxFee = _taxFee;
182 
183     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
184     address payable private _developmentAddress = payable(0xcbED34FbC2Ca33777e70b7C4e1396807b586Fa05);
185     address payable private _marketingAddress = payable(0xcbED34FbC2Ca33777e70b7C4e1396807b586Fa05);
186 
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189 
190     bool private tradingOpen = false;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193 
194     uint256 public _maxTxAmount = 10000000 * 10**9;
195     uint256 public _maxWalletSize = 10000000 * 10**9;
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
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237 
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241 
242     function transfer(address recipient, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     function allowance(address owner, address spender)
252         public
253         view
254         override
255         returns (uint256)
256     {
257         return _allowances[owner][spender];
258     }
259 
260     function approve(address spender, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268 
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(
276             sender,
277             _msgSender(),
278             _allowances[sender][_msgSender()].sub(
279                 amount,
280                 "ERC20: transfer amount exceeds allowance"
281             )
282         );
283         return true;
284     }
285 
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298 
299     function removeAllFee() private {
300         if (_redisFee == 0 && _taxFee == 0) return;
301 
302         _previousredisFee = _redisFee;
303         _previoustaxFee = _taxFee;
304 
305         _redisFee = 0;
306         _taxFee = 0;
307     }
308 
309     function restoreAllFee() private {
310         _redisFee = _previousredisFee;
311         _taxFee = _previoustaxFee;
312     }
313 
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324 
325     function _transfer(
326         address from,
327         address to,
328         uint256 amount
329     ) private {
330         require(from != address(0), "ERC20: transfer from the zero address");
331         require(to != address(0), "ERC20: transfer to the zero address");
332         require(amount > 0, "Transfer amount must be greater than zero");
333 
334         if (from != owner() && to != owner()) {
335 
336             //Trade start check
337             if (!tradingOpen) {
338                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
339             }
340 
341             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
342             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
343 
344             if(to != uniswapV2Pair) {
345                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
346             }
347 
348             uint256 contractTokenBalance = balanceOf(address(this));
349             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
350 
351             if(contractTokenBalance >= _maxTxAmount)
352             {
353                 contractTokenBalance = _maxTxAmount;
354             }
355 
356             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
357                 swapTokensForEth(contractTokenBalance);
358                 uint256 contractETHBalance = address(this).balance;
359                 if (contractETHBalance > 0) {
360                     sendETHToFee(address(this).balance);
361                 }
362             }
363         }
364 
365         bool takeFee = true;
366 
367         //Transfer Tokens
368         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
369             takeFee = false;
370         } else {
371 
372             //Set Fee for Buys
373             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
374                 _redisFee = _redisFeeOnBuy;
375                 _taxFee = _taxFeeOnBuy;
376             }
377 
378             //Set Fee for Sells
379             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnSell;
381                 _taxFee = _taxFeeOnSell;
382             }
383 
384         }
385 
386         _tokenTransfer(from, to, amount, takeFee);
387     }
388 
389     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = uniswapV2Router.WETH();
393         _approve(address(this), address(uniswapV2Router), tokenAmount);
394         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
395             tokenAmount,
396             0,
397             path,
398             address(this),
399             block.timestamp
400         );
401     }
402 
403     function sendETHToFee(uint256 amount) private {
404         _marketingAddress.transfer(amount);
405     }
406 
407     function setTrading(bool _tradingOpen) public onlyOwner {
408         tradingOpen = _tradingOpen;
409     }
410 
411     function manualswap() external {
412         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
413         uint256 contractBalance = balanceOf(address(this));
414         swapTokensForEth(contractBalance);
415     }
416 
417     function manualsend() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422 
423     function blockBots(address[] memory bots_) public onlyOwner {
424         for (uint256 i = 0; i < bots_.length; i++) {
425             bots[bots_[i]] = true;
426         }
427     }
428 
429     function unblockBot(address notbot) public onlyOwner {
430         bots[notbot] = false;
431     }
432 
433     function _tokenTransfer(
434         address sender,
435         address recipient,
436         uint256 amount,
437         bool takeFee
438     ) private {
439         if (!takeFee) removeAllFee();
440         _transferStandard(sender, recipient, amount);
441         if (!takeFee) restoreAllFee();
442     }
443 
444     function _transferStandard(
445         address sender,
446         address recipient,
447         uint256 tAmount
448     ) private {
449         (
450             uint256 rAmount,
451             uint256 rTransferAmount,
452             uint256 rFee,
453             uint256 tTransferAmount,
454             uint256 tFee,
455             uint256 tTeam
456         ) = _getValues(tAmount);
457         _rOwned[sender] = _rOwned[sender].sub(rAmount);
458         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
459         _takeTeam(tTeam);
460         _reflectFee(rFee, tFee);
461         emit Transfer(sender, recipient, tTransferAmount);
462     }
463 
464     function _takeTeam(uint256 tTeam) private {
465         uint256 currentRate = _getRate();
466         uint256 rTeam = tTeam.mul(currentRate);
467         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
468     }
469 
470     function _reflectFee(uint256 rFee, uint256 tFee) private {
471         _rTotal = _rTotal.sub(rFee);
472         _tFeeTotal = _tFeeTotal.add(tFee);
473     }
474 
475     receive() external payable {}
476 
477     function _getValues(uint256 tAmount)
478         private
479         view
480         returns (
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256
487         )
488     {
489         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
490             _getTValues(tAmount, _redisFee, _taxFee);
491         uint256 currentRate = _getRate();
492         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
493             _getRValues(tAmount, tFee, tTeam, currentRate);
494         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
495     }
496 
497     function _getTValues(
498         uint256 tAmount,
499         uint256 redisFee,
500         uint256 taxFee
501     )
502         private
503         pure
504         returns (
505             uint256,
506             uint256,
507             uint256
508         )
509     {
510         uint256 tFee = tAmount.mul(redisFee).div(100);
511         uint256 tTeam = tAmount.mul(taxFee).div(100);
512         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
513         return (tTransferAmount, tFee, tTeam);
514     }
515 
516     function _getRValues(
517         uint256 tAmount,
518         uint256 tFee,
519         uint256 tTeam,
520         uint256 currentRate
521     )
522         private
523         pure
524         returns (
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         uint256 rAmount = tAmount.mul(currentRate);
531         uint256 rFee = tFee.mul(currentRate);
532         uint256 rTeam = tTeam.mul(currentRate);
533         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
534         return (rAmount, rTransferAmount, rFee);
535     }
536 
537     function _getRate() private view returns (uint256) {
538         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
539         return rSupply.div(tSupply);
540     }
541 
542     function _getCurrentSupply() private view returns (uint256, uint256) {
543         uint256 rSupply = _rTotal;
544         uint256 tSupply = _tTotal;
545         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
546         return (rSupply, tSupply);
547     }
548 
549     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
550         _redisFeeOnBuy = redisFeeOnBuy;
551         _redisFeeOnSell = redisFeeOnSell;
552         _taxFeeOnBuy = taxFeeOnBuy;
553         _taxFeeOnSell = taxFeeOnSell;
554     }
555 
556     //Set minimum tokens required to swap.
557     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
558         _swapTokensAtAmount = swapTokensAtAmount;
559     }
560 
561     //Set minimum tokens required to swap.
562     function toggleSwap(bool _swapEnabled) public onlyOwner {
563         swapEnabled = _swapEnabled;
564     }
565 
566     //Set maximum transaction
567     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
568         _maxTxAmount = maxTxAmount;
569     }
570 
571     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
572         _maxWalletSize = maxWalletSize;
573     }
574 
575     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
576         for(uint256 i = 0; i < accounts.length; i++) {
577             _isExcludedFromFee[accounts[i]] = excluded;
578         }
579     }
580 
581 }