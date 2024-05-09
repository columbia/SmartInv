1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-23
3 */
4 
5 /**
6 website https://loongdragon.io/enter/
7 telegram https://t.me/LoongDragonPortal
8 
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 pragma solidity ^0.8.14;
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 contract Ownable is Context {
45     address private _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86 
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100 
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124 
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130 
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139 
140     function factory() external pure returns (address);
141 
142     function WETH() external pure returns (address);
143 
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160 
161 contract LOONG is Context, IERC20, Ownable {
162 
163     using SafeMath for uint256;
164 
165     string private constant _name = "Loong Dragon";
166     string private constant _symbol = "Loong";
167     uint8 private constant _decimals = 9;
168 
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 100000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177     uint256 private _redisFeeOnBuy = 0;
178     uint256 private _taxFeeOnBuy = 25;
179     uint256 private _redisFeeOnSell = 0;
180     uint256 private _taxFeeOnSell = 20;
181 
182     //Original Fee
183     uint256 private _redisFee = _redisFeeOnSell;
184     uint256 private _taxFee = _taxFeeOnSell;
185 
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188 
189     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
190     mapping (address => bool) public preTrader;
191     address payable private _developmentAddress = payable(0x8beFf0538cC3b3DB55b0Af5336618d4c1b247A68);
192     address payable private _marketingAddress = payable(0x8beFf0538cC3b3DB55b0Af5336618d4c1b247A68);
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 1000000 * 10**9;
202     uint256 public _maxWalletSize = 1000000 * 10**9;
203     uint256 public _swapTokensAtAmount = 30000 * 10**9;
204 
205     event MaxTxAmountUpdated(uint256 _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211 
212     constructor() {
213 
214         _rOwned[_msgSender()] = _rTotal;
215 
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219             .createPair(address(this), _uniswapV2Router.WETH());
220 
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_developmentAddress] = true;
224         _isExcludedFromFee[_marketingAddress] = true;
225 
226         emit Transfer(address(0), _msgSender(), _tTotal);
227     }
228 
229     function name() public pure returns (string memory) {
230         return _name;
231     }
232 
233     function symbol() public pure returns (string memory) {
234         return _symbol;
235     }
236 
237     function decimals() public pure returns (uint8) {
238         return _decimals;
239     }
240 
241     function totalSupply() public pure override returns (uint256) {
242         return _tTotal;
243     }
244 
245     function balanceOf(address account) public view override returns (uint256) {
246         return tokenFromReflection(_rOwned[account]);
247     }
248 
249     function transfer(address recipient, uint256 amount)
250         public
251         override
252         returns (bool)
253     {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     function allowance(address owner, address spender)
259         public
260         view
261         override
262         returns (uint256)
263     {
264         return _allowances[owner][spender];
265     }
266 
267     function approve(address spender, uint256 amount)
268         public
269         override
270         returns (bool)
271     {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275 
276     function transferFrom(
277         address sender,
278         address recipient,
279         uint256 amount
280     ) public override returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(
283             sender,
284             _msgSender(),
285             _allowances[sender][_msgSender()].sub(
286                 amount,
287                 "ERC20: transfer amount exceeds allowance"
288             )
289         );
290         return true;
291     }
292 
293     function tokenFromReflection(uint256 rAmount)
294         private
295         view
296         returns (uint256)
297     {
298         require(
299             rAmount <= _rTotal,
300             "Amount must be less than total reflections"
301         );
302         uint256 currentRate = _getRate();
303         return rAmount.div(currentRate);
304     }
305 
306     function removeAllFee() private {
307         if (_redisFee == 0 && _taxFee == 0) return;
308 
309         _previousredisFee = _redisFee;
310         _previoustaxFee = _taxFee;
311 
312         _redisFee = 0;
313         _taxFee = 0;
314     }
315 
316     function restoreAllFee() private {
317         _redisFee = _previousredisFee;
318         _taxFee = _previoustaxFee;
319     }
320 
321     function _approve(
322         address owner,
323         address spender,
324         uint256 amount
325     ) private {
326         require(owner != address(0), "ERC20: approve from the zero address");
327         require(spender != address(0), "ERC20: approve to the zero address");
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331 
332     function _transfer(
333         address from,
334         address to,
335         uint256 amount
336     ) private {
337         require(from != address(0), "ERC20: transfer from the zero address");
338         require(to != address(0), "ERC20: transfer to the zero address");
339         require(amount > 0, "Transfer amount must be greater than zero");
340 
341         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
342 
343             //Trade start check
344             if (!tradingOpen) {
345                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
346             }
347 
348             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
349             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
350 
351             if(to != uniswapV2Pair) {
352                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
353             }
354 
355             uint256 contractTokenBalance = balanceOf(address(this));
356             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
357 
358             if(contractTokenBalance >= _maxTxAmount)
359             {
360                 contractTokenBalance = _maxTxAmount;
361             }
362 
363             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
364                 swapTokensForEth(contractTokenBalance);
365                 uint256 contractETHBalance = address(this).balance;
366                 if (contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371 
372         bool takeFee = true;
373 
374         //Transfer Tokens
375         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
376             takeFee = false;
377         } else {
378 
379             //Set Fee for Buys
380             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
381                 _redisFee = _redisFeeOnBuy;
382                 _taxFee = _taxFeeOnBuy;
383             }
384 
385             //Set Fee for Sells
386             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnSell;
388                 _taxFee = _taxFeeOnSell;
389             }
390 
391         }
392 
393         _tokenTransfer(from, to, amount, takeFee);
394     }
395 
396     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
397         address[] memory path = new address[](2);
398         path[0] = address(this);
399         path[1] = uniswapV2Router.WETH();
400         _approve(address(this), address(uniswapV2Router), tokenAmount);
401         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
402             tokenAmount,
403             0,
404             path,
405             address(this),
406             block.timestamp
407         );
408     }
409 
410     function sendETHToFee(uint256 amount) private {
411         _marketingAddress.transfer(amount);
412     }
413 
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416     }
417 
418     function manualswap() external {
419         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
420         uint256 contractBalance = balanceOf(address(this));
421         swapTokensForEth(contractBalance);
422     }
423 
424     function manualsend() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractETHBalance = address(this).balance;
427         sendETHToFee(contractETHBalance);
428     }
429 
430     function blockBots(address[] memory bots_) public onlyOwner {
431         for (uint256 i = 0; i < bots_.length; i++) {
432             bots[bots_[i]] = true;
433         }
434     }
435 
436     function unblockBot(address notbot) public onlyOwner {
437         bots[notbot] = false;
438     }
439 
440     function _tokenTransfer(
441         address sender,
442         address recipient,
443         uint256 amount,
444         bool takeFee
445     ) private {
446         if (!takeFee) removeAllFee();
447         _transferStandard(sender, recipient, amount);
448         if (!takeFee) restoreAllFee();
449     }
450 
451     function _transferStandard(
452         address sender,
453         address recipient,
454         uint256 tAmount
455     ) private {
456         (
457             uint256 rAmount,
458             uint256 rTransferAmount,
459             uint256 rFee,
460             uint256 tTransferAmount,
461             uint256 tFee,
462             uint256 tTeam
463         ) = _getValues(tAmount);
464         _rOwned[sender] = _rOwned[sender].sub(rAmount);
465         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
466         _takeTeam(tTeam);
467         _reflectFee(rFee, tFee);
468         emit Transfer(sender, recipient, tTransferAmount);
469     }
470 
471     function _takeTeam(uint256 tTeam) private {
472         uint256 currentRate = _getRate();
473         uint256 rTeam = tTeam.mul(currentRate);
474         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
475     }
476 
477     function _reflectFee(uint256 rFee, uint256 tFee) private {
478         _rTotal = _rTotal.sub(rFee);
479         _tFeeTotal = _tFeeTotal.add(tFee);
480     }
481 
482     receive() external payable {}
483 
484     function _getValues(uint256 tAmount)
485         private
486         view
487         returns (
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
497             _getTValues(tAmount, _redisFee, _taxFee);
498         uint256 currentRate = _getRate();
499         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
500             _getRValues(tAmount, tFee, tTeam, currentRate);
501         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
502     }
503 
504     function _getTValues(
505         uint256 tAmount,
506         uint256 redisFee,
507         uint256 taxFee
508     )
509         private
510         pure
511         returns (
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         uint256 tFee = tAmount.mul(redisFee).div(100);
518         uint256 tTeam = tAmount.mul(taxFee).div(100);
519         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
520         return (tTransferAmount, tFee, tTeam);
521     }
522 
523     function _getRValues(
524         uint256 tAmount,
525         uint256 tFee,
526         uint256 tTeam,
527         uint256 currentRate
528     )
529         private
530         pure
531         returns (
532             uint256,
533             uint256,
534             uint256
535         )
536     {
537         uint256 rAmount = tAmount.mul(currentRate);
538         uint256 rFee = tFee.mul(currentRate);
539         uint256 rTeam = tTeam.mul(currentRate);
540         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
541         return (rAmount, rTransferAmount, rFee);
542     }
543 
544     function _getRate() private view returns (uint256) {
545         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
546         return rSupply.div(tSupply);
547     }
548 
549     function _getCurrentSupply() private view returns (uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
553         return (rSupply, tSupply);
554     }
555 
556     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
557         _redisFeeOnBuy = redisFeeOnBuy;
558         _redisFeeOnSell = redisFeeOnSell;
559         _taxFeeOnBuy = taxFeeOnBuy;
560         _taxFeeOnSell = taxFeeOnSell;
561     }
562 
563     //Set minimum tokens required to swap.
564     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
565         _swapTokensAtAmount = swapTokensAtAmount;
566     }
567 
568     //Set minimum tokens required to swap.
569     function toggleSwap(bool _swapEnabled) public onlyOwner {
570         swapEnabled = _swapEnabled;
571     }
572 
573     //Set maximum transaction
574     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
575         _maxTxAmount = maxTxAmount;
576     }
577 
578     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
579         _maxWalletSize = maxWalletSize;
580     }
581 
582     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
583         for(uint256 i = 0; i < accounts.length; i++) {
584             _isExcludedFromFee[accounts[i]] = excluded;
585         }
586     }
587 
588     function allowPreTrading(address[] calldata accounts) public onlyOwner {
589         for(uint256 i = 0; i < accounts.length; i++) {
590                  preTrader[accounts[i]] = true;
591         }
592     }
593 
594     function removePreTrading(address[] calldata accounts) public onlyOwner {
595         for(uint256 i = 0; i < accounts.length; i++) {
596                  delete preTrader[accounts[i]];
597         }
598     }
599 }