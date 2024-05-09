1 pragma solidity ^0.8.9;
2 // SPDX-License-Identifier: Unlicensed
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 contract Ownable is Context {
35     address private _owner;
36     address private _previousOwner;
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41 
42     constructor() {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 
68 }
69 
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88         return c;
89     }
90 
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         uint256 c = a / b;
111         return c;
112     }
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120 
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129 
130     function factory() external pure returns (address);
131 
132     function WETH() external pure returns (address);
133 
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150 
151 contract TDOTFWToken is Context, IERC20, Ownable {
152 
153     using SafeMath for uint256;
154 
155     string private constant _name = "The Dream of the Fisherman's Wife";
156     string private constant _symbol = "Takoto";
157     uint8 private constant _decimals = 9;
158 
159     mapping(address => uint256) private _rOwned;
160     mapping(address => uint256) private _tOwned;
161     mapping(address => mapping(address => uint256)) private _allowances;
162     mapping(address => bool) private _isExcludedFromFee;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 1000000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167     uint256 private _redisFeeOnBuy = 0;
168     uint256 private _taxFeeOnBuy = 0;
169     uint256 private _redisFeeOnSell = 0;
170     uint256 private _taxFeeOnSell = 6;
171 
172     //Original Fee
173     uint256 private _redisFee = _redisFeeOnSell;
174     uint256 private _taxFee = _taxFeeOnSell;
175 
176     uint256 private _previousredisFee = _redisFee;
177     uint256 private _previoustaxFee = _taxFee;
178 
179     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
180     address payable private _developmentAddress = payable(0x64F5D94447Ad80a4a730F6987C33aeDBc36b780f);
181     address payable private _marketingAddress = payable(0x64F5D94447Ad80a4a730F6987C33aeDBc36b780f);
182 
183     IUniswapV2Router02 public uniswapV2Router;
184     address public uniswapV2Pair;
185 
186     bool private tradingOpen = true;
187     bool private inSwap = false;
188     bool private swapEnabled = true;
189 
190     uint256 public _maxTxAmount = 20000000 * 10**9;
191     uint256 public _maxWalletSize = 20000000 * 10**9;
192     uint256 public _swapTokensAtAmount = 10000 * 10**9;
193 
194     event MaxTxAmountUpdated(uint256 _maxTxAmount);
195     modifier lockTheSwap {
196         inSwap = true;
197         _;
198         inSwap = false;
199     }
200 
201     constructor() {
202 
203         _rOwned[_msgSender()] = _rTotal;
204 
205         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
206         uniswapV2Router = _uniswapV2Router;
207         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
208             .createPair(address(this), _uniswapV2Router.WETH());
209 
210         _isExcludedFromFee[owner()] = true;
211         _isExcludedFromFee[address(this)] = true;
212         _isExcludedFromFee[_developmentAddress] = true;
213         _isExcludedFromFee[_marketingAddress] = true;
214 
215         emit Transfer(address(0), _msgSender(), _tTotal);
216     }
217 
218     function name() public pure returns (string memory) {
219         return _name;
220     }
221 
222     function symbol() public pure returns (string memory) {
223         return _symbol;
224     }
225 
226     function decimals() public pure returns (uint8) {
227         return _decimals;
228     }
229 
230     function totalSupply() public pure override returns (uint256) {
231         return _tTotal;
232     }
233 
234     function balanceOf(address account) public view override returns (uint256) {
235         return tokenFromReflection(_rOwned[account]);
236     }
237 
238     function transfer(address recipient, uint256 amount)
239         public
240         override
241         returns (bool)
242     {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     function allowance(address owner, address spender)
248         public
249         view
250         override
251         returns (uint256)
252     {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public override returns (bool) {
270         _transfer(sender, recipient, amount);
271         _approve(
272             sender,
273             _msgSender(),
274             _allowances[sender][_msgSender()].sub(
275                 amount,
276                 "ERC20: transfer amount exceeds allowance"
277             )
278         );
279         return true;
280     }
281 
282     function tokenFromReflection(uint256 rAmount)
283         private
284         view
285         returns (uint256)
286     {
287         require(
288             rAmount <= _rTotal,
289             "Amount must be less than total reflections"
290         );
291         uint256 currentRate = _getRate();
292         return rAmount.div(currentRate);
293     }
294 
295     function removeAllFee() private {
296         if (_redisFee == 0 && _taxFee == 0) return;
297 
298         _previousredisFee = _redisFee;
299         _previoustaxFee = _taxFee;
300 
301         _redisFee = 0;
302         _taxFee = 0;
303     }
304 
305     function restoreAllFee() private {
306         _redisFee = _previousredisFee;
307         _taxFee = _previoustaxFee;
308     }
309 
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) private {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     function _transfer(
322         address from,
323         address to,
324         uint256 amount
325     ) private {
326         require(from != address(0), "ERC20: transfer from the zero address");
327         require(to != address(0), "ERC20: transfer to the zero address");
328         require(amount > 0, "Transfer amount must be greater than zero");
329 
330         if (from != owner() && to != owner()) {
331 
332             //Trade start check
333             if (!tradingOpen) {
334                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
335             }
336 
337             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
338             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
339 
340             if(to != uniswapV2Pair) {
341                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
342             }
343 
344             uint256 contractTokenBalance = balanceOf(address(this));
345             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
346 
347             if(contractTokenBalance >= _maxTxAmount)
348             {
349                 contractTokenBalance = _maxTxAmount;
350             }
351 
352             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
353                 swapTokensForEth(contractTokenBalance);
354                 uint256 contractETHBalance = address(this).balance;
355                 if (contractETHBalance > 0) {
356                     sendETHToFee(address(this).balance);
357                 }
358             }
359         }
360 
361         bool takeFee = true;
362 
363         //Transfer Tokens
364         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
365             takeFee = false;
366         } else {
367 
368             //Set Fee for Buys
369             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
370                 _redisFee = _redisFeeOnBuy;
371                 _taxFee = _taxFeeOnBuy;
372             }
373 
374             //Set Fee for Sells
375             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
376                 _redisFee = _redisFeeOnSell;
377                 _taxFee = _taxFeeOnSell;
378             }
379 
380         }
381 
382         _tokenTransfer(from, to, amount, takeFee);
383     }
384 
385     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
386         address[] memory path = new address[](2);
387         path[0] = address(this);
388         path[1] = uniswapV2Router.WETH();
389         _approve(address(this), address(uniswapV2Router), tokenAmount);
390         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
391             tokenAmount,
392             0,
393             path,
394             address(this),
395             block.timestamp
396         );
397     }
398 
399     function sendETHToFee(uint256 amount) private {
400         _marketingAddress.transfer(amount);
401     }
402 
403     function setTrading(bool _tradingOpen) public onlyOwner {
404         tradingOpen = _tradingOpen;
405     }
406 
407     function manualswap() external {
408         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
409         uint256 contractBalance = balanceOf(address(this));
410         swapTokensForEth(contractBalance);
411     }
412 
413     function manualsend() external {
414         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
415         uint256 contractETHBalance = address(this).balance;
416         sendETHToFee(contractETHBalance);
417     }
418 
419     function blockBots(address[] memory bots_) public onlyOwner {
420         for (uint256 i = 0; i < bots_.length; i++) {
421             bots[bots_[i]] = true;
422         }
423     }
424 
425     function unblockBot(address notbot) public onlyOwner {
426         bots[notbot] = false;
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