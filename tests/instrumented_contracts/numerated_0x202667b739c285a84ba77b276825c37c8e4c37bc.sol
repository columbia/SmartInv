1 // SPDX-License-Identifier: Unlicensed
2 
3 // https://t.me/zeroxtools
4 
5 // https://zerox.tools
6 
7 // https://twitter.com/zeroxtools
8 
9 // https://medium.com/@zeroxtools
10 
11 pragma solidity 0.8.19;
12 
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
161 contract zeroxtools is Context, IERC20, Ownable {
162 
163     using SafeMath for uint256;
164 
165     string private constant _name = "0xTools";
166     string private constant _symbol = "0XT";
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
178     uint256 private _taxFeeOnBuy = 15;
179     uint256 private _redisFeeOnSell = 0;
180     uint256 private _taxFeeOnSell = 30;
181 
182     //Original Fee
183     uint256 private _redisFee = _redisFeeOnSell;
184     uint256 private _taxFee = _taxFeeOnSell;
185 
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188 
189     mapping (address => uint256) public _buyMap;
190     address payable private _developmentAddress = payable(0xD948f3e92959112553e3E7DD2c4720C3431f801a);
191     address payable private _marketingAddress = payable(0xD948f3e92959112553e3E7DD2c4720C3431f801a);
192 
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen = true;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 3000000 * 10**9;
202     uint256 public _maxWalletSize = 3000000 * 10**9;
203     uint256 public _swapTokensAtAmount = 1000000 * 10**9;
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
341         if (from != owner() && to != owner()) {
342 
343             //Trade start check
344             if (!tradingOpen) {
345                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
346             }
347 
348             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
349 
350             if(to != uniswapV2Pair) {
351                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
352             }
353 
354             uint256 contractTokenBalance = balanceOf(address(this));
355             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
356 
357             if(contractTokenBalance >= _maxTxAmount)
358             {
359                 contractTokenBalance = _maxTxAmount;
360             }
361 
362             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
363                 swapTokensForEth(contractTokenBalance);
364                 uint256 contractETHBalance = address(this).balance;
365                 if (contractETHBalance > 0) {
366                     sendETHToFee(address(this).balance);
367                 }
368             }
369         }
370 
371         bool takeFee = true;
372 
373         //Transfer Tokens
374         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
375             takeFee = false;
376         } else {
377 
378             //Set Fee for Buys
379             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnBuy;
381                 _taxFee = _taxFeeOnBuy;
382             }
383 
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnSell;
387                 _taxFee = _taxFeeOnSell;
388             }
389 
390         }
391 
392         _tokenTransfer(from, to, amount, takeFee);
393     }
394 
395     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
396         address[] memory path = new address[](2);
397         path[0] = address(this);
398         path[1] = uniswapV2Router.WETH();
399         _approve(address(this), address(uniswapV2Router), tokenAmount);
400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
401             tokenAmount,
402             0,
403             path,
404             address(this),
405             block.timestamp
406         );
407     }
408 
409     function sendETHToFee(uint256 amount) private {
410         _marketingAddress.transfer(amount);
411     }
412 
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416 
417     function manualswap() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422 
423     function manualsend() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428 
429     function _tokenTransfer(
430         address sender,
431         address recipient,
432         uint256 amount,
433         bool takeFee
434     ) private {
435         if (!takeFee) removeAllFee();
436         _transferStandard(sender, recipient, amount);
437         if (!takeFee) restoreAllFee();
438     }
439 
440     function _transferStandard(
441         address sender,
442         address recipient,
443         uint256 tAmount
444     ) private {
445         (
446             uint256 rAmount,
447             uint256 rTransferAmount,
448             uint256 rFee,
449             uint256 tTransferAmount,
450             uint256 tFee,
451             uint256 tTeam
452         ) = _getValues(tAmount);
453         _rOwned[sender] = _rOwned[sender].sub(rAmount);
454         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
455         _takeTeam(tTeam);
456         _reflectFee(rFee, tFee);
457         emit Transfer(sender, recipient, tTransferAmount);
458     }
459 
460     function _takeTeam(uint256 tTeam) private {
461         uint256 currentRate = _getRate();
462         uint256 rTeam = tTeam.mul(currentRate);
463         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
464     }
465 
466     function _reflectFee(uint256 rFee, uint256 tFee) private {
467         _rTotal = _rTotal.sub(rFee);
468         _tFeeTotal = _tFeeTotal.add(tFee);
469     }
470 
471     receive() external payable {}
472 
473     function _getValues(uint256 tAmount)
474         private
475         view
476         returns (
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256
483         )
484     {
485         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
486             _getTValues(tAmount, _redisFee, _taxFee);
487         uint256 currentRate = _getRate();
488         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
489             _getRValues(tAmount, tFee, tTeam, currentRate);
490         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
491     }
492 
493     function _getTValues(
494         uint256 tAmount,
495         uint256 redisFee,
496         uint256 taxFee
497     )
498         private
499         pure
500         returns (
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         uint256 tFee = tAmount.mul(redisFee).div(100);
507         uint256 tTeam = tAmount.mul(taxFee).div(100);
508         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
509         return (tTransferAmount, tFee, tTeam);
510     }
511 
512     function _getRValues(
513         uint256 tAmount,
514         uint256 tFee,
515         uint256 tTeam,
516         uint256 currentRate
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 rAmount = tAmount.mul(currentRate);
527         uint256 rFee = tFee.mul(currentRate);
528         uint256 rTeam = tTeam.mul(currentRate);
529         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
530         return (rAmount, rTransferAmount, rFee);
531     }
532 
533     function _getRate() private view returns (uint256) {
534         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
535         return rSupply.div(tSupply);
536     }
537 
538     function _getCurrentSupply() private view returns (uint256, uint256) {
539         uint256 rSupply = _rTotal;
540         uint256 tSupply = _tTotal;
541         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
542         return (rSupply, tSupply);
543     }
544 
545     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
546         _redisFeeOnBuy = redisFeeOnBuy;
547         _redisFeeOnSell = redisFeeOnSell;
548         _taxFeeOnBuy = taxFeeOnBuy;
549         _taxFeeOnSell = taxFeeOnSell;
550     }
551 
552     //Set minimum tokens required to swap.
553     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
554         _swapTokensAtAmount = swapTokensAtAmount;
555     }
556 
557     //Set minimum tokens required to swap.
558     function toggleSwap(bool _swapEnabled) public onlyOwner {
559         swapEnabled = _swapEnabled;
560     }
561 
562     //Set maximum transaction
563     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
564         _maxTxAmount = maxTxAmount;
565     }
566 
567     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
568         _maxWalletSize = maxWalletSize;
569     }
570 
571     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
572         for(uint256 i = 0; i < accounts.length; i++) {
573             _isExcludedFromFee[accounts[i]] = excluded;
574         }
575     }
576 
577 }