1 /**
2  *
3 */
4 
5 /** https://medium.com/@harmony_/harmony-%E8%AA%BF%E5%92%8C-683bc8f18686
6 
7 
8 */
9 
10 //SPDX-License-Identifier: UNLICENSED
11 pragma solidity ^0.8.4;
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
161 contract Harmony is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "Harmony \u8abf\u548c";
166     string private constant _symbol = unicode"HARM";
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 4200000000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177     uint256 public launchBlock;
178  
179     //Buy Fee
180     uint256 private _redisFeeOnBuy = 0;
181     uint256 private _taxFeeOnBuy = 2;
182  
183     //Sell Fee
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 2;
186  
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190  
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193  
194     mapping(address => bool) public bots;
195     mapping(address => uint256) private cooldown;
196  
197     address payable private _developmentAddress = payable(0x807d4436F22d3AAeF096Be582cDA53fd89D8C518);
198     address payable private _marketingAddress = payable(0x807d4436F22d3AAeF096Be582cDA53fd89D8C518);
199  
200     IUniswapV2Router02 public uniswapV2Router;
201     address public uniswapV2Pair;
202  
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = true;
206  
207     uint256 public _maxTxAmount = 84000000000 * 10**9; 
208     uint256 public _maxWalletSize = 84000000000 * 10**9; 
209     uint256 public _swapTokensAtAmount = 42000000 * 10**9; 
210  
211     event MaxTxAmountUpdated(uint256 _maxTxAmount);
212     modifier lockTheSwap {
213         inSwap = true;
214         _;
215         inSwap = false;
216     }
217  
218     constructor() {
219  
220         _rOwned[_msgSender()] = _rTotal;
221  
222         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
223         uniswapV2Router = _uniswapV2Router;
224         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
225             .createPair(address(this), _uniswapV2Router.WETH());
226  
227         _isExcludedFromFee[owner()] = true;
228         _isExcludedFromFee[address(this)] = true;
229         _isExcludedFromFee[_developmentAddress] = true;
230         _isExcludedFromFee[_marketingAddress] = true;
231 
232         emit Transfer(address(0), _msgSender(), _tTotal);
233     }
234  
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238  
239     function symbol() public pure returns (string memory) {
240         return _symbol;
241     }
242  
243     function decimals() public pure returns (uint8) {
244         return _decimals;
245     }
246  
247     function totalSupply() public pure override returns (uint256) {
248         return _tTotal;
249     }
250  
251     function balanceOf(address account) public view override returns (uint256) {
252         return tokenFromReflection(_rOwned[account]);
253     }
254  
255     function transfer(address recipient, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263  
264     function allowance(address owner, address spender)
265         public
266         view
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272  
273     function approve(address spender, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281  
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(
289             sender,
290             _msgSender(),
291             _allowances[sender][_msgSender()].sub(
292                 amount,
293                 "ERC20: transfer amount exceeds allowance"
294             )
295         );
296         return true;
297     }
298  
299     function tokenFromReflection(uint256 rAmount)
300         private
301         view
302         returns (uint256)
303     {
304         require(
305             rAmount <= _rTotal,
306             "Amount must be less than total reflections"
307         );
308         uint256 currentRate = _getRate();
309         return rAmount.div(currentRate);
310     }
311  
312     function removeAllFee() private {
313         if (_redisFee == 0 && _taxFee == 0) return;
314  
315         _previousredisFee = _redisFee;
316         _previoustaxFee = _taxFee;
317  
318         _redisFee = 0;
319         _taxFee = 0;
320     }
321  
322     function restoreAllFee() private {
323         _redisFee = _previousredisFee;
324         _taxFee = _previoustaxFee;
325     }
326  
327     function _approve(
328         address owner,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337  
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) private {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345         require(amount > 0, "Transfer amount must be greater than zero");
346  
347         if (from != owner() && to != owner()) {
348  
349             //Trade start check
350             if (!tradingOpen) {
351                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
352             }
353  
354             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
355             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
356  
357             if(to != uniswapV2Pair) {
358                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
359             }
360  
361             uint256 contractTokenBalance = balanceOf(address(this));
362             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
363  
364             if(contractTokenBalance >= _maxTxAmount)
365             {
366                 contractTokenBalance = _maxTxAmount;
367             }
368  
369             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
370                 swapTokensForEth(contractTokenBalance);
371                 uint256 contractETHBalance = address(this).balance;
372                 if (contractETHBalance > 0) {
373                     sendETHToFee(address(this).balance);
374                 }
375             }
376         }
377  
378         bool takeFee = true;
379  
380         //Transfer Tokens
381         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
382             takeFee = false;
383         } else {
384  
385             //Set Fee for Buys
386             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnBuy;
388                 _taxFee = _taxFeeOnBuy;
389             }
390  
391             //Set Fee for Sells
392             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnSell;
394                 _taxFee = _taxFeeOnSell;
395             }
396  
397         }
398  
399         _tokenTransfer(from, to, amount, takeFee);
400     }
401  
402     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = uniswapV2Router.WETH();
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             tokenAmount,
409             0,
410             path,
411             address(this),
412             block.timestamp
413         );
414     }
415  
416     function sendETHToFee(uint256 amount) private {
417         _developmentAddress.transfer(amount.mul(50).div(100));
418         _marketingAddress.transfer(amount.mul(50).div(100));
419     }
420  
421     function setTrading(bool _tradingOpen) public onlyOwner {
422         tradingOpen = _tradingOpen;
423     }
424  
425     function manualswap() external {
426         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
427         uint256 contractBalance = balanceOf(address(this));
428         swapTokensForEth(contractBalance);
429     }
430  
431     function manualsend() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractETHBalance = address(this).balance;
434         sendETHToFee(contractETHBalance);
435     }
436  
437     function blockBots(address[] memory bots_) public onlyOwner {
438         for (uint256 i = 0; i < bots_.length; i++) {
439             bots[bots_[i]] = true;
440         }
441     }
442  
443     function unblockBot(address notbot) public onlyOwner {
444         bots[notbot] = false;
445     }
446  
447     function _tokenTransfer(
448         address sender,
449         address recipient,
450         uint256 amount,
451         bool takeFee
452     ) private {
453         if (!takeFee) removeAllFee();
454         _transferStandard(sender, recipient, amount);
455         if (!takeFee) restoreAllFee();
456     }
457  
458     function _transferStandard(
459         address sender,
460         address recipient,
461         uint256 tAmount
462     ) private {
463         (
464             uint256 rAmount,
465             uint256 rTransferAmount,
466             uint256 rFee,
467             uint256 tTransferAmount,
468             uint256 tFee,
469             uint256 tTeam
470         ) = _getValues(tAmount);
471         _rOwned[sender] = _rOwned[sender].sub(rAmount);
472         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
473         _takeTeam(tTeam);
474         _reflectFee(rFee, tFee);
475         emit Transfer(sender, recipient, tTransferAmount);
476     }
477  
478     function _takeTeam(uint256 tTeam) private {
479         uint256 currentRate = _getRate();
480         uint256 rTeam = tTeam.mul(currentRate);
481         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
482     }
483  
484     function _reflectFee(uint256 rFee, uint256 tFee) private {
485         _rTotal = _rTotal.sub(rFee);
486         _tFeeTotal = _tFeeTotal.add(tFee);
487     }
488  
489     receive() external payable {}
490  
491     function _getValues(uint256 tAmount)
492         private
493         view
494         returns (
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
504             _getTValues(tAmount, _redisFee, _taxFee);
505         uint256 currentRate = _getRate();
506         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
507             _getRValues(tAmount, tFee, tTeam, currentRate);
508  
509         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
510     }
511  
512     function _getTValues(
513         uint256 tAmount,
514         uint256 redisFee,
515         uint256 taxFee
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 tFee = tAmount.mul(redisFee).div(100);
526         uint256 tTeam = tAmount.mul(taxFee).div(100);
527         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
528  
529         return (tTransferAmount, tFee, tTeam);
530     }
531  
532     function _getRValues(
533         uint256 tAmount,
534         uint256 tFee,
535         uint256 tTeam,
536         uint256 currentRate
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 rAmount = tAmount.mul(currentRate);
547         uint256 rFee = tFee.mul(currentRate);
548         uint256 rTeam = tTeam.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
550  
551         return (rAmount, rTransferAmount, rFee);
552     }
553  
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556  
557         return rSupply.div(tSupply);
558     }
559  
560     function _getCurrentSupply() private view returns (uint256, uint256) {
561         uint256 rSupply = _rTotal;
562         uint256 tSupply = _tTotal;
563         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
564  
565         return (rSupply, tSupply);
566     }
567  
568     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
569         _redisFeeOnBuy = redisFeeOnBuy;
570         _redisFeeOnSell = redisFeeOnSell;
571  
572         _taxFeeOnBuy = taxFeeOnBuy;
573         _taxFeeOnSell = taxFeeOnSell;
574     }
575  
576     //Set minimum tokens required to swap.
577     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
578         _swapTokensAtAmount = swapTokensAtAmount;
579     }
580  
581     //Set minimum tokens required to swap.
582     function toggleSwap(bool _swapEnabled) public onlyOwner {
583         swapEnabled = _swapEnabled;
584     }
585  
586  
587     //Set maximum transaction
588     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
589         _maxTxAmount = maxTxAmount;
590     }
591  
592     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
593         _maxWalletSize = maxWalletSize;
594     }
595  
596     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
597         for(uint256 i = 0; i < accounts.length; i++) {
598             _isExcludedFromFee[accounts[i]] = excluded;
599         }
600     }
601 }