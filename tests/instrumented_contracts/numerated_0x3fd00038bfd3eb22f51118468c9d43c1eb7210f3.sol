1 /**
2 
3 
4 */
5 
6 
7 
8 //SPDX-License-Identifier: UNLICENSED
9 pragma solidity ^0.8.4;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16  
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19  
20     function balanceOf(address account) external view returns (uint256);
21  
22     function transfer(address recipient, uint256 amount) external returns (bool);
23  
24     function allowance(address owner, address spender) external view returns (uint256);
25  
26     function approve(address spender, uint256 amount) external returns (bool);
27  
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33  
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41  
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49  
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55  
56     function owner() public view returns (address) {
57         return _owner;
58     }
59  
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64  
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69  
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75  
76 }
77  
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84  
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88  
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98  
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107  
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111  
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122  
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128  
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137  
138     function factory() external pure returns (address);
139  
140     function WETH() external pure returns (address);
141  
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158  
159 contract RinTinTin is Context, IERC20, Ownable {
160  
161     using SafeMath for uint256;
162  
163     string private constant _name = "Rin Tin Tin";
164     string private constant _symbol = "RIN";
165     uint8 private constant _decimals = 9;
166  
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 1000000000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 public launchBlock;
176  
177     //Buy Fee
178     uint256 private _redisFeeOnBuy = 0;
179     uint256 private _taxFeeOnBuy = 10;
180  
181     //Sell Fee
182     uint256 private _redisFeeOnSell = 0;
183     uint256 private _taxFeeOnSell = 20;
184  
185     //Original Fee
186     uint256 private _redisFee = _redisFeeOnSell;
187     uint256 private _taxFee = _taxFeeOnSell;
188  
189     uint256 private _previousredisFee = _redisFee;
190     uint256 private _previoustaxFee = _taxFee;
191  
192     mapping(address => bool) public bots;
193     mapping(address => uint256) private cooldown;
194  
195     address payable private _developmentAddress = payable(0xEB1C56117c527E6EB61F4248b648463e73a1C7a1);
196     address payable private _marketingAddress = payable(0xEB1C56117c527E6EB61F4248b648463e73a1C7a1);
197  
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapV2Pair;
200  
201     bool private tradingOpen;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204  
205     uint256 public _maxTxAmount = 20000000000 * 10**9; 
206     uint256 public _maxWalletSize = 20000000000 * 10**9; 
207     uint256 public _swapTokensAtAmount = 1000000000 * 10**9; 
208  
209     event MaxTxAmountUpdated(uint256 _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215  
216     constructor() {
217  
218         _rOwned[_msgSender()] = _rTotal;
219  
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224  
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_developmentAddress] = true;
228         _isExcludedFromFee[_marketingAddress] = true;
229 
230         emit Transfer(address(0), _msgSender(), _tTotal);
231     }
232  
233     function name() public pure returns (string memory) {
234         return _name;
235     }
236  
237     function symbol() public pure returns (string memory) {
238         return _symbol;
239     }
240  
241     function decimals() public pure returns (uint8) {
242         return _decimals;
243     }
244  
245     function totalSupply() public pure override returns (uint256) {
246         return _tTotal;
247     }
248  
249     function balanceOf(address account) public view override returns (uint256) {
250         return tokenFromReflection(_rOwned[account]);
251     }
252  
253     function transfer(address recipient, uint256 amount)
254         public
255         override
256         returns (bool)
257     {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261  
262     function allowance(address owner, address spender)
263         public
264         view
265         override
266         returns (uint256)
267     {
268         return _allowances[owner][spender];
269     }
270  
271     function approve(address spender, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279  
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public override returns (bool) {
285         _transfer(sender, recipient, amount);
286         _approve(
287             sender,
288             _msgSender(),
289             _allowances[sender][_msgSender()].sub(
290                 amount,
291                 "ERC20: transfer amount exceeds allowance"
292             )
293         );
294         return true;
295     }
296  
297     function tokenFromReflection(uint256 rAmount)
298         private
299         view
300         returns (uint256)
301     {
302         require(
303             rAmount <= _rTotal,
304             "Amount must be less than total reflections"
305         );
306         uint256 currentRate = _getRate();
307         return rAmount.div(currentRate);
308     }
309  
310     function removeAllFee() private {
311         if (_redisFee == 0 && _taxFee == 0) return;
312  
313         _previousredisFee = _redisFee;
314         _previoustaxFee = _taxFee;
315  
316         _redisFee = 0;
317         _taxFee = 0;
318     }
319  
320     function restoreAllFee() private {
321         _redisFee = _previousredisFee;
322         _taxFee = _previoustaxFee;
323     }
324  
325     function _approve(
326         address owner,
327         address spender,
328         uint256 amount
329     ) private {
330         require(owner != address(0), "ERC20: approve from the zero address");
331         require(spender != address(0), "ERC20: approve to the zero address");
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335  
336     function _transfer(
337         address from,
338         address to,
339         uint256 amount
340     ) private {
341         require(from != address(0), "ERC20: transfer from the zero address");
342         require(to != address(0), "ERC20: transfer to the zero address");
343         require(amount > 0, "Transfer amount must be greater than zero");
344  
345         if (from != owner() && to != owner()) {
346  
347             //Trade start check
348             if (!tradingOpen) {
349                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
350             }
351  
352             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
353             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
354  
355             if(to != uniswapV2Pair) {
356                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
357             }
358  
359             uint256 contractTokenBalance = balanceOf(address(this));
360             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
361  
362             if(contractTokenBalance >= _maxTxAmount)
363             {
364                 contractTokenBalance = _maxTxAmount;
365             }
366  
367             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368                 swapTokensForEth(contractTokenBalance);
369                 uint256 contractETHBalance = address(this).balance;
370                 if (contractETHBalance > 0) {
371                     sendETHToFee(address(this).balance);
372                 }
373             }
374         }
375  
376         bool takeFee = true;
377  
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381 
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386 
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
412         _developmentAddress.transfer(amount.mul(50).div(100));
413         _marketingAddress.transfer(amount.mul(50).div(100));
414     }
415  
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
418     }
419  
420     function manualswap() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractBalance = balanceOf(address(this));
423         swapTokensForEth(contractBalance);
424     }
425  
426     function manualsend() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractETHBalance = address(this).balance;
429         sendETHToFee(contractETHBalance);
430     }
431  
432     function blockBots(address[] memory bots_) public onlyOwner {
433         for (uint256 i = 0; i < bots_.length; i++) {
434             bots[bots_[i]] = true;
435         }
436     }
437  
438     function unblockBot(address notbot) public onlyOwner {
439         bots[notbot] = false;
440     }
441  
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount,
446         bool takeFee
447     ) private {
448         if (!takeFee) removeAllFee();
449         _transferStandard(sender, recipient, amount);
450         if (!takeFee) restoreAllFee();
451     }
452  
453     function _transferStandard(
454         address sender,
455         address recipient,
456         uint256 tAmount
457     ) private {
458         (
459             uint256 rAmount,
460             uint256 rTransferAmount,
461             uint256 rFee,
462             uint256 tTransferAmount,
463             uint256 tFee,
464             uint256 tTeam
465         ) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
468         _takeTeam(tTeam);
469         _reflectFee(rFee, tFee);
470         emit Transfer(sender, recipient, tTransferAmount);
471     }
472  
473     function _takeTeam(uint256 tTeam) private {
474         uint256 currentRate = _getRate();
475         uint256 rTeam = tTeam.mul(currentRate);
476         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
477     }
478  
479     function _reflectFee(uint256 rFee, uint256 tFee) private {
480         _rTotal = _rTotal.sub(rFee);
481         _tFeeTotal = _tFeeTotal.add(tFee);
482     }
483  
484     receive() external payable {}
485  
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
499             _getTValues(tAmount, _redisFee, _taxFee);
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
502             _getRValues(tAmount, tFee, tTeam, currentRate);
503  
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506  
507     function _getTValues(
508         uint256 tAmount,
509         uint256 redisFee,
510         uint256 taxFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(redisFee).div(100);
521         uint256 tTeam = tAmount.mul(taxFee).div(100);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
523  
524         return (tTransferAmount, tFee, tTeam);
525     }
526  
527     function _getRValues(
528         uint256 tAmount,
529         uint256 tFee,
530         uint256 tTeam,
531         uint256 currentRate
532     )
533         private
534         pure
535         returns (
536             uint256,
537             uint256,
538             uint256
539         )
540     {
541         uint256 rAmount = tAmount.mul(currentRate);
542         uint256 rFee = tFee.mul(currentRate);
543         uint256 rTeam = tTeam.mul(currentRate);
544         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
545  
546         return (rAmount, rTransferAmount, rFee);
547     }
548  
549     function _getRate() private view returns (uint256) {
550         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
551  
552         return rSupply.div(tSupply);
553     }
554  
555     function _getCurrentSupply() private view returns (uint256, uint256) {
556         uint256 rSupply = _rTotal;
557         uint256 tSupply = _tTotal;
558         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
559  
560         return (rSupply, tSupply);
561     }
562  
563     function setinitiator(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
564         _redisFeeOnBuy = redisFeeOnBuy;
565         _redisFeeOnSell = redisFeeOnSell;
566  
567         _taxFeeOnBuy = taxFeeOnBuy;
568         _taxFeeOnSell = taxFeeOnSell;
569     }
570  
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574  
575     function toggleSwap(bool _swapEnabled) public onlyOwner {
576         swapEnabled = _swapEnabled;
577     }
578  
579  
580     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
581         _maxTxAmount = maxTxAmount;
582     }
583  
584     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
585         _maxWalletSize = maxWalletSize;
586     }
587  
588     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
589         for(uint256 i = 0; i < accounts.length; i++) {
590             _isExcludedFromFee[accounts[i]] = excluded;
591         }
592     }
593 }