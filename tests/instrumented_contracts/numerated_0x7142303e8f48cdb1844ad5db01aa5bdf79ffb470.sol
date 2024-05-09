1 // https://godofmanyfaces.com
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity ^0.8.7;
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
155 contract GMF is Context, IERC20, Ownable {
156 
157     using SafeMath for uint256;
158 
159     string private constant _name = "God of Many Faces";
160     string private constant _symbol = "FACES";
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
172     uint256 private _taxFeeOnBuy = 5;
173     uint256 private _redisFeeOnSell = 0;
174     uint256 private _taxFeeOnSell = 8;
175 
176     //Original Fee
177     uint256 private _redisFee = _redisFeeOnSell;
178     uint256 private _taxFee = _taxFeeOnSell;
179 
180     uint256 private _previousredisFee = _redisFee;
181     uint256 private _previoustaxFee = _taxFee;
182 
183     address payable private _developmentAddress = payable(0xe757A44CF462c5a688dC89Ed4397C2823611a4fF);
184     address payable private _marketingAddress = payable(0xe757A44CF462c5a688dC89Ed4397C2823611a4fF);
185 
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188 
189     bool private tradingOpen = false;
190     bool private inSwap = false;
191     bool private swapEnabled = true;
192 
193     uint256 public _maxTxAmount = 10000000 * 10**9;
194     uint256 public _maxWalletSize = 10000000 * 10**9;
195     uint256 public _swapTokensAtAmount = 10000 * 10**9;
196 
197     event MaxTxAmountUpdated(uint256 _maxTxAmount);
198     modifier lockTheSwap {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203 
204     constructor() {
205 
206         _rOwned[_msgSender()] = _rTotal;
207 
208         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
209         uniswapV2Router = _uniswapV2Router;
210         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
211             .createPair(address(this), _uniswapV2Router.WETH());
212 
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_developmentAddress] = true;
216         _isExcludedFromFee[_marketingAddress] = true;
217 
218         emit Transfer(address(0), _msgSender(), _tTotal);
219     }
220 
221     function name() public pure returns (string memory) {
222         return _name;
223     }
224 
225     function symbol() public pure returns (string memory) {
226         return _symbol;
227     }
228 
229     function decimals() public pure returns (uint8) {
230         return _decimals;
231     }
232 
233     function totalSupply() public pure override returns (uint256) {
234         return _tTotal;
235     }
236 
237     function balanceOf(address account) public view override returns (uint256) {
238         return tokenFromReflection(_rOwned[account]);
239     }
240 
241     function transfer(address recipient, uint256 amount)
242         public
243         override
244         returns (bool)
245     {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     function allowance(address owner, address spender)
251         public
252         view
253         override
254         returns (uint256)
255     {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(
275             sender,
276             _msgSender(),
277             _allowances[sender][_msgSender()].sub(
278                 amount,
279                 "ERC20: transfer amount exceeds allowance"
280             )
281         );
282         return true;
283     }
284 
285     function tokenFromReflection(uint256 rAmount)
286         private
287         view
288         returns (uint256)
289     {
290         require(
291             rAmount <= _rTotal,
292             "Amount must be less than total reflections"
293         );
294         uint256 currentRate = _getRate();
295         return rAmount.div(currentRate);
296     }
297 
298     function removeAllFee() private {
299         if (_redisFee == 0 && _taxFee == 0) return;
300 
301         _previousredisFee = _redisFee;
302         _previoustaxFee = _taxFee;
303 
304         _redisFee = 0;
305         _taxFee = 0;
306     }
307 
308     function restoreAllFee() private {
309         _redisFee = _previousredisFee;
310         _taxFee = _previoustaxFee;
311     }
312 
313     function _approve(
314         address owner,
315         address spender,
316         uint256 amount
317     ) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324     function _transfer(
325         address from,
326         address to,
327         uint256 amount
328     ) private {
329         require(from != address(0), "ERC20: transfer from the zero address");
330         require(to != address(0), "ERC20: transfer to the zero address");
331         require(amount > 0, "Transfer amount must be greater than zero");
332 
333         if (from != owner() && to != owner()) {
334 
335             //Trade start check
336             if (!tradingOpen) {
337                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
338             }
339 
340             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
341 
342             if(to != uniswapV2Pair) {
343                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
344             }
345 
346             uint256 contractTokenBalance = balanceOf(address(this));
347             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
348 
349             if(contractTokenBalance >= _maxTxAmount)
350             {
351                 contractTokenBalance = _maxTxAmount;
352             }
353 
354             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
355                 swapTokensForEth(contractTokenBalance);
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362 
363         bool takeFee = true;
364 
365         //Transfer Tokens
366         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
367             takeFee = false;
368         } else {
369 
370             //Set Fee for Buys
371             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
372                 _redisFee = _redisFeeOnBuy;
373                 _taxFee = _taxFeeOnBuy;
374             }
375 
376             //Set Fee for Sells
377             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnSell;
379                 _taxFee = _taxFeeOnSell;
380             }
381 
382         }
383 
384         _tokenTransfer(from, to, amount, takeFee);
385     }
386 
387     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
388         address[] memory path = new address[](2);
389         path[0] = address(this);
390         path[1] = uniswapV2Router.WETH();
391         _approve(address(this), address(uniswapV2Router), tokenAmount);
392         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
393             tokenAmount,
394             0,
395             path,
396             address(this),
397             block.timestamp
398         );
399     }
400 
401     function sendETHToFee(uint256 amount) private {
402         _marketingAddress.transfer(amount);
403     }
404 
405     function setTrading(bool _tradingOpen) public onlyOwner {
406         tradingOpen = _tradingOpen;
407     }
408 
409     function manualswap() external {
410         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414 
415     function manualsend() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420 
421     function _tokenTransfer(
422         address sender,
423         address recipient,
424         uint256 amount,
425         bool takeFee
426     ) private {
427         if (!takeFee) removeAllFee();
428         _transferStandard(sender, recipient, amount);
429         if (!takeFee) restoreAllFee();
430     }
431 
432     function _transferStandard(
433         address sender,
434         address recipient,
435         uint256 tAmount
436     ) private {
437         (
438             uint256 rAmount,
439             uint256 rTransferAmount,
440             uint256 rFee,
441             uint256 tTransferAmount,
442             uint256 tFee,
443             uint256 tTeam
444         ) = _getValues(tAmount);
445         _rOwned[sender] = _rOwned[sender].sub(rAmount);
446         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
447         _takeTeam(tTeam);
448         _reflectFee(rFee, tFee);
449         emit Transfer(sender, recipient, tTransferAmount);
450     }
451 
452     function _takeTeam(uint256 tTeam) private {
453         uint256 currentRate = _getRate();
454         uint256 rTeam = tTeam.mul(currentRate);
455         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
456     }
457 
458     function _reflectFee(uint256 rFee, uint256 tFee) private {
459         _rTotal = _rTotal.sub(rFee);
460         _tFeeTotal = _tFeeTotal.add(tFee);
461     }
462 
463     receive() external payable {}
464 
465     function _getValues(uint256 tAmount)
466         private
467         view
468         returns (
469             uint256,
470             uint256,
471             uint256,
472             uint256,
473             uint256,
474             uint256
475         )
476     {
477         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
478             _getTValues(tAmount, _redisFee, _taxFee);
479         uint256 currentRate = _getRate();
480         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
481             _getRValues(tAmount, tFee, tTeam, currentRate);
482         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
483     }
484 
485     function _getTValues(
486         uint256 tAmount,
487         uint256 redisFee,
488         uint256 taxFee
489     )
490         private
491         pure
492         returns (
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         uint256 tFee = tAmount.mul(redisFee).div(100);
499         uint256 tTeam = tAmount.mul(taxFee).div(100);
500         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
501         return (tTransferAmount, tFee, tTeam);
502     }
503 
504     function _getRValues(
505         uint256 tAmount,
506         uint256 tFee,
507         uint256 tTeam,
508         uint256 currentRate
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 rAmount = tAmount.mul(currentRate);
519         uint256 rFee = tFee.mul(currentRate);
520         uint256 rTeam = tTeam.mul(currentRate);
521         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
522         return (rAmount, rTransferAmount, rFee);
523     }
524 
525     function _getRate() private view returns (uint256) {
526         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
527         return rSupply.div(tSupply);
528     }
529 
530     function _getCurrentSupply() private view returns (uint256, uint256) {
531         uint256 rSupply = _rTotal;
532         uint256 tSupply = _tTotal;
533         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
534         return (rSupply, tSupply);
535     }
536 
537     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
538         _redisFeeOnBuy = redisFeeOnBuy;
539         _redisFeeOnSell = redisFeeOnSell;
540         _taxFeeOnBuy = taxFeeOnBuy;
541         _taxFeeOnSell = taxFeeOnSell;
542     }
543 
544     //Set minimum tokens required to swap.
545     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
546         _swapTokensAtAmount = swapTokensAtAmount;
547     }
548 
549     //Set minimum tokens required to swap.
550     function toggleSwap(bool _swapEnabled) public onlyOwner {
551         swapEnabled = _swapEnabled;
552     }
553 
554     //Set maximum transaction
555     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
556         _maxTxAmount = maxTxAmount;
557     }
558 
559     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
560         _maxWalletSize = maxWalletSize;
561     }
562 
563     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
564         for(uint256 i = 0; i < accounts.length; i++) {
565             _isExcludedFromFee[accounts[i]] = excluded;
566         }
567     }
568 
569 }