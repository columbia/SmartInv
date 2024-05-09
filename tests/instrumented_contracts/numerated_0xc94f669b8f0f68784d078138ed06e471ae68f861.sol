1 pragma solidity ^0.8.9;
2 
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
151 contract Sheherazade is Context, IERC20, Ownable {
152 
153     using SafeMath for uint256;
154 
155     string private constant _name = "Sheherazade";
156     string private constant _symbol = "1001";
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
168     uint256 private _taxFeeOnBuy = 20;
169     uint256 private _redisFeeOnSell = 0;
170     uint256 private _taxFeeOnSell = 20;
171 
172     uint256 private _redisFee = _redisFeeOnSell;
173     uint256 private _taxFee = _taxFeeOnSell;
174 
175     uint256 private _previousredisFee = _redisFee;
176     uint256 private _previoustaxFee = _taxFee;
177 
178     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
179     address payable private _developmentAddress = payable(0xC4f1622D4B63149e58c1df5F4BC9cda3f301F574);
180     address payable private _marketingAddress = payable(0x98b11f691F5d916859B5985343472A628838A0c5);
181 
182     IUniswapV2Router02 public uniswapV2Router;
183     address public uniswapV2Pair;
184 
185     bool private tradingOpen = false;
186     bool private inSwap = false;
187     bool private swapEnabled = true;
188 
189     uint256 public _maxTxAmount = 20000000 * 10**9;
190     uint256 public _maxWalletSize = 30000000 * 10**9;
191     uint256 public _swapTokensAtAmount = 10000 * 10**9;
192 
193     event MaxTxAmountUpdated(uint256 _maxTxAmount);
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200     constructor() {
201 
202         _rOwned[_msgSender()] = _rTotal;
203 
204         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
205         uniswapV2Router = _uniswapV2Router;
206         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
207             .createPair(address(this), _uniswapV2Router.WETH());
208 
209         _isExcludedFromFee[owner()] = true;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[_developmentAddress] = true;
212         _isExcludedFromFee[_marketingAddress] = true;
213 
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public pure returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public pure returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public pure override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return tokenFromReflection(_rOwned[account]);
235     }
236 
237     function transfer(address recipient, uint256 amount)
238         public
239         override
240         returns (bool)
241     {
242         _transfer(_msgSender(), recipient, amount);
243         return true;
244     }
245 
246     function allowance(address owner, address spender)
247         public
248         view
249         override
250         returns (uint256)
251     {
252         return _allowances[owner][spender];
253     }
254 
255     function approve(address spender, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     function transferFrom(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) public override returns (bool) {
269         _transfer(sender, recipient, amount);
270         _approve(
271             sender,
272             _msgSender(),
273             _allowances[sender][_msgSender()].sub(
274                 amount,
275                 "ERC20: transfer amount exceeds allowance"
276             )
277         );
278         return true;
279     }
280 
281     function tokenFromReflection(uint256 rAmount)
282         private
283         view
284         returns (uint256)
285     {
286         require(
287             rAmount <= _rTotal,
288             "Amount must be less than total reflections"
289         );
290         uint256 currentRate = _getRate();
291         return rAmount.div(currentRate);
292     }
293 
294     function removeAllFee() private {
295         if (_redisFee == 0 && _taxFee == 0) return;
296 
297         _previousredisFee = _redisFee;
298         _previoustaxFee = _taxFee;
299 
300         _redisFee = 0;
301         _taxFee = 0;
302     }
303 
304     function restoreAllFee() private {
305         _redisFee = _previousredisFee;
306         _taxFee = _previoustaxFee;
307     }
308 
309     function _approve(
310         address owner,
311         address spender,
312         uint256 amount
313     ) private {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319 
320     function _transfer(
321         address from,
322         address to,
323         uint256 amount
324     ) private {
325         require(from != address(0), "ERC20: transfer from the zero address");
326         require(to != address(0), "ERC20: transfer to the zero address");
327         require(amount > 0, "Transfer amount must be greater than zero");
328 
329         if (from != owner() && to != owner()) {
330 
331             //Trade start check
332             if (!tradingOpen) {
333                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
334             }
335 
336             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
337             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
338 
339             if(to != uniswapV2Pair) {
340                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
341             }
342 
343             uint256 contractTokenBalance = balanceOf(address(this));
344             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
345 
346             if(contractTokenBalance >= _maxTxAmount)
347             {
348                 contractTokenBalance = _maxTxAmount;
349             }
350 
351             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
352                 swapTokensForEth(contractTokenBalance);
353                 uint256 contractETHBalance = address(this).balance;
354                 if (contractETHBalance > 0) {
355                     sendETHToFee(address(this).balance);
356                 }
357             }
358         }
359 
360         bool takeFee = true;
361 
362         //Transfer Tokens
363         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
364             takeFee = false;
365         } else {
366 
367             //Set Fee for Buys
368             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
369                 _redisFee = _redisFeeOnBuy;
370                 _taxFee = _taxFeeOnBuy;
371             }
372 
373             //Set Fee for Sells
374             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
375                 _redisFee = _redisFeeOnSell;
376                 _taxFee = _taxFeeOnSell;
377             }
378 
379         }
380 
381         _tokenTransfer(from, to, amount, takeFee);
382     }
383 
384     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
385         address[] memory path = new address[](2);
386         path[0] = address(this);
387         path[1] = uniswapV2Router.WETH();
388         _approve(address(this), address(uniswapV2Router), tokenAmount);
389         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
390             tokenAmount,
391             0,
392             path,
393             address(this),
394             block.timestamp
395         );
396     }
397 
398     function sendETHToFee(uint256 amount) private {
399         _marketingAddress.transfer(amount);
400     }
401 
402     function setTrading(bool _tradingOpen) public onlyOwner {
403         tradingOpen = _tradingOpen;
404     }
405 
406     function manualswap() external {
407         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
408         uint256 contractBalance = balanceOf(address(this));
409         swapTokensForEth(contractBalance);
410     }
411 
412     function manualsend() external {
413         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
414         uint256 contractETHBalance = address(this).balance;
415         sendETHToFee(contractETHBalance);
416     }
417 
418     function blockBots(address[] memory bots_) public onlyOwner {
419         for (uint256 i = 0; i < bots_.length; i++) {
420             bots[bots_[i]] = true;
421         }
422     }
423 
424     function unblockBot(address notbot) public onlyOwner {
425         bots[notbot] = false;
426     }
427 
428     function _tokenTransfer(
429         address sender,
430         address recipient,
431         uint256 amount,
432         bool takeFee
433     ) private {
434         if (!takeFee) removeAllFee();
435         _transferStandard(sender, recipient, amount);
436         if (!takeFee) restoreAllFee();
437     }
438 
439     function _transferStandard(
440         address sender,
441         address recipient,
442         uint256 tAmount
443     ) private {
444         (
445             uint256 rAmount,
446             uint256 rTransferAmount,
447             uint256 rFee,
448             uint256 tTransferAmount,
449             uint256 tFee,
450             uint256 tTeam
451         ) = _getValues(tAmount);
452         _rOwned[sender] = _rOwned[sender].sub(rAmount);
453         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
454         _takeTeam(tTeam);
455         _reflectFee(rFee, tFee);
456         emit Transfer(sender, recipient, tTransferAmount);
457     }
458 
459     function _takeTeam(uint256 tTeam) private {
460         uint256 currentRate = _getRate();
461         uint256 rTeam = tTeam.mul(currentRate);
462         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
463     }
464 
465     function _reflectFee(uint256 rFee, uint256 tFee) private {
466         _rTotal = _rTotal.sub(rFee);
467         _tFeeTotal = _tFeeTotal.add(tFee);
468     }
469 
470     receive() external payable {}
471 
472     function _getValues(uint256 tAmount)
473         private
474         view
475         returns (
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256
482         )
483     {
484         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
485             _getTValues(tAmount, _redisFee, _taxFee);
486         uint256 currentRate = _getRate();
487         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
488             _getRValues(tAmount, tFee, tTeam, currentRate);
489         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
490     }
491 
492     function _getTValues(
493         uint256 tAmount,
494         uint256 redisFee,
495         uint256 taxFee
496     )
497         private
498         pure
499         returns (
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         uint256 tFee = tAmount.mul(redisFee).div(100);
506         uint256 tTeam = tAmount.mul(taxFee).div(100);
507         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
508         return (tTransferAmount, tFee, tTeam);
509     }
510 
511     function _getRValues(
512         uint256 tAmount,
513         uint256 tFee,
514         uint256 tTeam,
515         uint256 currentRate
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 rAmount = tAmount.mul(currentRate);
526         uint256 rFee = tFee.mul(currentRate);
527         uint256 rTeam = tTeam.mul(currentRate);
528         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
529         return (rAmount, rTransferAmount, rFee);
530     }
531 
532     function _getRate() private view returns (uint256) {
533         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
534         return rSupply.div(tSupply);
535     }
536 
537     function _getCurrentSupply() private view returns (uint256, uint256) {
538         uint256 rSupply = _rTotal;
539         uint256 tSupply = _tTotal;
540         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
541         return (rSupply, tSupply);
542     }
543 
544     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
545         _redisFeeOnBuy = redisFeeOnBuy;
546         _redisFeeOnSell = redisFeeOnSell;
547         _taxFeeOnBuy = taxFeeOnBuy;
548         _taxFeeOnSell = taxFeeOnSell;
549     }
550 
551     //Set minimum tokens required to swap.
552     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
553         _swapTokensAtAmount = swapTokensAtAmount;
554     }
555 
556     //Set minimum tokens required to swap.
557     function toggleSwap(bool _swapEnabled) public onlyOwner {
558         swapEnabled = _swapEnabled;
559     }
560 
561     //Set maximum transaction
562     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
563         _maxTxAmount = maxTxAmount;
564     }
565 
566     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
567         _maxWalletSize = maxWalletSize;
568     }
569 
570     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
571         for(uint256 i = 0; i < accounts.length; i++) {
572             _isExcludedFromFee[accounts[i]] = excluded;
573         }
574     }
575 
576 }