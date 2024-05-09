1 /**
2 
3 上野 英三郎の所有者ハチ公
4 
5 https://t.me/UenoCommunity
6 
7 https://twitter.com/official_UENO
8 
9 https://www.hidesaburo-ueno.com/
10 
11 */
12 
13 pragma solidity ^0.8.15;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 
80 }
81 
82 library SafeMath {
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     function div(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         return c;
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB)
129         external
130         returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint256 amountIn,
136         uint256 amountOutMin,
137         address[] calldata path,
138         address to,
139         uint256 deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 }
162 
163 contract UENO is Context, IERC20, Ownable {
164 
165     using SafeMath for uint256;
166 
167     string private constant _name = "Hidesaburo Ueno";
168     string private constant _symbol = "UENO";
169     uint8 private constant _decimals = 9;
170 
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 100000000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 private _redisFeeOnBuy = 0;
180     uint256 private _taxFeeOnBuy = 30;
181     uint256 private _redisFeeOnSell = 0;
182     uint256 private _taxFeeOnSell = 70;
183 
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190 
191     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
192     address payable private _developmentAddress = payable(msg.sender);
193     address payable private _marketingAddress = payable(msg.sender);
194 
195     IUniswapV2Router02 public uniswapV2Router;
196     address public uniswapV2Pair;
197  
198     bool private tradingOpen = true;
199     bool private inSwap = false;
200     bool private swapEnabled = true;
201 
202     uint256 public _maxTxAmount = 2000000000  * 10**9;
203     uint256 public _maxWalletSize = 3000000000 * 10**9;
204     uint256 public _swapTokensAtAmount = 100000000 * 10**9;
205  
206     event MaxTxAmountUpdated(uint256 _maxTxAmount);
207     modifier lockTheSwap {
208         inSwap = true;
209         _;
210         inSwap = false;
211     }
212 
213     constructor() {
214 
215         _rOwned[_msgSender()] = _rTotal;
216 
217         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //
218         uniswapV2Router = _uniswapV2Router;
219         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
220             .createPair(address(this), _uniswapV2Router.WETH());
221 
222         _isExcludedFromFee[owner()] = true;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[_developmentAddress] = true;
225         _isExcludedFromFee[_marketingAddress] = true;
226 
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229 
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237 
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241 
242     function totalSupply() public pure override returns (uint256) {
243         return _tTotal;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         return tokenFromReflection(_rOwned[account]);
248     }
249 
250     function transfer(address recipient, uint256 amount)
251         public
252         override
253         returns (bool)
254     {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     function allowance(address owner, address spender)
260         public
261         view
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267 
268     function approve(address spender, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) public override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(
284             sender,
285             _msgSender(),
286             _allowances[sender][_msgSender()].sub(
287                 amount,
288                 "ERC20: transfer amount exceeds allowance"
289             )
290         );
291         return true;
292     }
293 
294     function tokenFromReflection(uint256 rAmount)
295         private
296         view
297         returns (uint256)
298     {
299         require(
300             rAmount <= _rTotal,
301             "Amount must be less than total reflections"
302         );
303         uint256 currentRate = _getRate();
304         return rAmount.div(currentRate);
305     }
306 
307     function removeAllFee() private {
308         if (_redisFee == 0 && _taxFee == 0) return;
309 
310         _previousredisFee = _redisFee;
311         _previoustaxFee = _taxFee;
312 
313         _redisFee = 0;
314         _taxFee = 0;
315     }
316 
317     function restoreAllFee() private {
318         _redisFee = _previousredisFee;
319         _taxFee = _previoustaxFee;
320     }
321 
322     function _approve(
323         address owner,
324         address spender,
325         uint256 amount
326     ) private {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332 
333     function _transfer(
334         address from,
335         address to,
336         uint256 amount
337     ) private {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         require(amount > 0, "Transfer amount must be greater than zero");
341 
342         if (from != owner() && to != owner()) {
343 
344             //Trade start check
345             if (!tradingOpen) {
346                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
347             }
348 
349             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
350             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
351 
352             if(to != uniswapV2Pair) {
353                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
354             }
355 
356             uint256 contractTokenBalance = balanceOf(address(this));
357             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
358 
359             if(contractTokenBalance >= _maxTxAmount)
360             {
361                 contractTokenBalance = _maxTxAmount;
362             }
363 
364             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
365                 swapTokensForEth(contractTokenBalance);
366                 uint256 contractETHBalance = address(this).balance;
367                 if (contractETHBalance > 0) {
368                     sendETHToFee(address(this).balance);
369                 }
370             }
371         }
372 
373         bool takeFee = true;
374 
375         //Transfer Tokens
376         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
377             takeFee = false;
378         } else {
379 
380             //Set Fee for Buys
381             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
382                 _redisFee = _redisFeeOnBuy;
383                 _taxFee = _taxFeeOnBuy;
384             }
385 
386             //Set Fee for Sells
387             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
388                 _redisFee = _redisFeeOnSell;
389                 _taxFee = _taxFeeOnSell;
390             }
391 
392         }
393 
394         _tokenTransfer(from, to, amount, takeFee);
395     }
396 
397     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
398         address[] memory path = new address[](2);
399         path[0] = address(this);
400         path[1] = uniswapV2Router.WETH();
401         _approve(address(this), address(uniswapV2Router), tokenAmount);
402         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
403             tokenAmount,
404             0,
405             path,
406             address(this),
407             block.timestamp
408         );
409     }
410 
411     function sendETHToFee(uint256 amount) private {
412         _marketingAddress.transfer(amount);
413     }
414 
415     function setTrading(bool _tradingOpen) public onlyOwner {
416         tradingOpen = _tradingOpen;
417     }
418 
419     function manualswap() external {
420         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
421         uint256 contractBalance = balanceOf(address(this));
422         swapTokensForEth(contractBalance);
423     }
424 
425     function manualsend() external {
426         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
427         uint256 contractETHBalance = address(this).balance;
428         sendETHToFee(contractETHBalance);
429     }
430 
431     function blackbots(address[] memory bots_) public onlyOwner {
432         for (uint256 i = 0; i < bots_.length; i++) {
433             bots[bots_[i]] = true;
434         }
435     }
436 
437     function unblockbots(address notbot) public onlyOwner {
438         bots[notbot] = false;
439     }
440 
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (!takeFee) removeAllFee();
448         _transferStandard(sender, recipient, amount);
449         if (!takeFee) restoreAllFee();
450     }
451 
452     function _transferStandard(
453         address sender,
454         address recipient,
455         uint256 tAmount
456     ) private {
457         (
458             uint256 rAmount,
459             uint256 rTransferAmount,
460             uint256 rFee,
461             uint256 tTransferAmount,
462             uint256 tFee,
463             uint256 tTeam
464         ) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471 
472     function _takeTeam(uint256 tTeam) private {
473         uint256 currentRate = _getRate();
474         uint256 rTeam = tTeam.mul(currentRate);
475         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
476     }
477 
478     function _reflectFee(uint256 rFee, uint256 tFee) private {
479         _rTotal = _rTotal.sub(rFee);
480         _tFeeTotal = _tFeeTotal.add(tFee);
481     }
482 
483     receive() external payable {}
484 
485     function _getValues(uint256 tAmount)
486         private
487         view
488         returns (
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256
495         )
496     {
497         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
498             _getTValues(tAmount, _redisFee, _taxFee);
499         uint256 currentRate = _getRate();
500         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
501             _getRValues(tAmount, tFee, tTeam, currentRate);
502         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
503     }
504 
505     function _getTValues(
506         uint256 tAmount,
507         uint256 redisFee,
508         uint256 taxFee
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 tFee = tAmount.mul(redisFee).div(100);
519         uint256 tTeam = tAmount.mul(taxFee).div(100);
520         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
521         return (tTransferAmount, tFee, tTeam);
522     }
523 
524     function _getRValues(
525         uint256 tAmount,
526         uint256 tFee,
527         uint256 tTeam,
528         uint256 currentRate
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 rAmount = tAmount.mul(currentRate);
539         uint256 rFee = tFee.mul(currentRate);
540         uint256 rTeam = tTeam.mul(currentRate);
541         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
542         return (rAmount, rTransferAmount, rFee);
543     }
544 
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547         return rSupply.div(tSupply);
548     }
549 
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554         return (rSupply, tSupply);
555     }
556 
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         _redisFeeOnBuy = redisFeeOnBuy;
559         _redisFeeOnSell = redisFeeOnSell;
560         _taxFeeOnBuy = taxFeeOnBuy;
561         _taxFeeOnSell = taxFeeOnSell;
562     }
563 
564     //set minimum tokens required to swap.
565     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
566         _swapTokensAtAmount = swapTokensAtAmount;
567     }
568 
569     //set minimum tokens required to swap.
570     function toggleSwap(bool _swapEnabled) public onlyOwner {
571         swapEnabled = _swapEnabled;
572     }
573 
574     //set maximum transaction
575     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
576         _maxTxAmount = maxTxAmount;
577     }
578 
579     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
580         _maxWalletSize = maxWalletSize;
581     }
582 
583     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
584         for(uint256 i = 0; i < accounts.length; i++) {
585             _isExcludedFromFee[accounts[i]] = excluded;
586         }
587     }
588 
589 }