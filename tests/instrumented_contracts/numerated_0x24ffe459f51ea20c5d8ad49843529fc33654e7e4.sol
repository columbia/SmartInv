1 // SPDX-License-Identifier: Unlicensed
2 //https://t.me/proofofmemes
3 // Christmas has come early frens!! Airdrops coming in 1 hour
4 //
5 
6 pragma solidity ^0.8.9;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract Pomeranian is Context, IERC20, Ownable {
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "Pomeranian";
161     string private constant _symbol = "POM";
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _redisFeeOnBuy = 0;
173     uint256 private _taxFeeOnBuy = 6;
174     uint256 private _redisFeeOnSell = 0;
175     uint256 private _taxFeeOnSell = 20;
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
185     address payable private _developmentAddress = payable(0x64D225BBc410C8EC4c74DB6013b0BF5d3e39793D);
186     address payable private _marketingAddress = payable(0x64D225BBc410C8EC4c74DB6013b0BF5d3e39793D);
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189 
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193 
194     uint256 public _maxTxAmount = 2000000 * 10**9;
195     uint256 public _maxWalletSize = 2000000 * 10**9;
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