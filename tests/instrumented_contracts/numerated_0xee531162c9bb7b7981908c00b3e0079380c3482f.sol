1 /**
2 
3 Twitter: https://twitter.com/01Bitcoin001
4 
5 Telegram: https://t.me/B01000010010101000100001
6 
7 Website: https://010000100101010001000011.com/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.9;
13 
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
47     address internal _owner;
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
163 contract Bitcoin is Context, IERC20, Ownable {
164  
165     using SafeMath for uint256;
166  
167     string private constant _name = "01000010 01001001 01010100 01000011 01001111 01001001 01001110";
168     string private constant _symbol = "BITCOIN";
169     uint8 private constant _decimals = 9;
170  
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 21000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 private _redisFeeOnBuy = 0;  
180     uint256 private _taxFeeOnBuy = 0;  
181     uint256 private _redisFeeOnSell = 0;  
182     uint256 private _taxFeeOnSell = 0;
183  
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186  
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189  
190     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
191     address payable private _developmentAddress = payable(0x21F47e95945dFC654581e080E548DaAe5dA764C3); 
192     address payable private _marketingAddress = payable(0x21F47e95945dFC654581e080E548DaAe5dA764C3);
193  
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196  
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200  
201     uint256 public _maxTxAmount = _tTotal.mul(2).div(100);
202     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
203     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
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
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
411         _marketingAddress.transfer(amount.mul(3).div(5));
412         _developmentAddress.transfer(amount.mul(2).div(5));
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
431     function blockBots(address[] memory bots_) public onlyOwner {
432         for (uint256 i = 0; i < bots_.length; i++) {
433             bots[bots_[i]] = true;
434         }
435     }
436  
437     function unblockBot(address notbot) public onlyOwner {
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
558         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 5, "Buy rewards must be between 0% and 5%");
559         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 50, "Buy tax must be between 0% and 50%");
560         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 5, "Sell rewards must be between 0% and 5%");
561         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
562 
563         _redisFeeOnBuy = redisFeeOnBuy;
564         _redisFeeOnSell = redisFeeOnSell;
565         _taxFeeOnBuy = taxFeeOnBuy;
566         _taxFeeOnSell = taxFeeOnSell;
567 
568     }
569  
570     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
571         _swapTokensAtAmount = swapTokensAtAmount;
572     }
573  
574     function toggleSwap(bool _swapEnabled) public onlyOwner {
575         swapEnabled = _swapEnabled;
576     }
577  
578     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
579         require(amountPercent>0);
580         _maxTxAmount = (_tTotal * amountPercent ) / 100;
581     }
582 
583     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
584         require(amountPercent>0);
585         _maxWalletSize = (_tTotal * amountPercent ) / 100;
586     }
587 
588     function removeLimits() external onlyOwner{
589         _maxTxAmount = _tTotal;
590         _maxWalletSize = _tTotal;
591     }
592  
593     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
594         for(uint256 i = 0; i < accounts.length; i++) {
595             _isExcludedFromFee[accounts[i]] = excluded;
596         }
597     }
598 
599 }