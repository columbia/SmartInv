1 /**
2     MIKASA, the token that will slay titans. https://t.me/MikasainuETH
3 */
4 
5 // SPDX-License-Identifier: unlicense
6 
7 pragma solidity ^0.8.7;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14  
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17  
18     function balanceOf(address account) external view returns (uint256);
19  
20     function transfer(address recipient, uint256 amount) external returns (bool);
21  
22     function allowance(address owner, address spender) external view returns (uint256);
23  
24     function approve(address spender, uint256 amount) external returns (bool);
25  
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31  
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39  
40 contract Ownable is Context {
41     address private _owner;
42     address private _previousOwner;
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47  
48     constructor() {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53  
54     function owner() public view returns (address) {
55         return _owner;
56     }
57  
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62  
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67  
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73  
74 }
75  
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82  
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86  
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96  
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105  
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109  
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120  
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126  
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135  
136     function factory() external pure returns (address);
137  
138     function WETH() external pure returns (address);
139  
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156  
157 contract MikasaToken is Context, IERC20, Ownable {
158  
159     using SafeMath for uint256;
160  
161     string private constant _name = "MIKASA";//
162     string private constant _symbol = "MIKASA";//
163     uint8 private constant _decimals = 9;
164  
165     mapping(address => uint256) private _rOwned;
166     mapping(address => uint256) private _tOwned;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 1000000000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173     uint256 public launchBlock;
174  
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 0;//
177     uint256 private _taxFeeOnBuy = 5;//
178  
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 0;//
181     uint256 private _taxFeeOnSell = 15;//
182  
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186  
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189  
190     mapping(address => bool) public bots;
191     mapping(address => uint256) private cooldown;
192  
193     address payable private _developmentAddress = payable(0xeaC1B803B17eBC713E2e9EF2130DCd723Ab99f1f);//
194     address payable private _marketingAddress = payable(0xb227512Aa5b905D42E025C83f29d9135176fa439);//
195  
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198  
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202  
203     uint256 public _maxTxAmount = 16000000000 * 10**9; //
204     uint256 public _maxWalletSize = 33000000000 * 10**9; //
205     uint256 public _swapTokensAtAmount = 100000000 * 10**9; //
206  
207     event MaxTxAmountUpdated(uint256 _maxTxAmount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213  
214     constructor() {
215  
216         _rOwned[_msgSender()] = _rTotal;
217  
218         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
219         uniswapV2Router = _uniswapV2Router;
220         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
221             .createPair(address(this), _uniswapV2Router.WETH());
222  
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[address(this)] = true;
225         _isExcludedFromFee[_developmentAddress] = true;
226         _isExcludedFromFee[_marketingAddress] = true;
227   
228         emit Transfer(address(0), _msgSender(), _tTotal);
229     }
230  
231     function name() public pure returns (string memory) {
232         return _name;
233     }
234  
235     function symbol() public pure returns (string memory) {
236         return _symbol;
237     }
238  
239     function decimals() public pure returns (uint8) {
240         return _decimals;
241     }
242  
243     function totalSupply() public pure override returns (uint256) {
244         return _tTotal;
245     }
246  
247     function balanceOf(address account) public view override returns (uint256) {
248         return tokenFromReflection(_rOwned[account]);
249     }
250  
251     function transfer(address recipient, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259  
260     function allowance(address owner, address spender)
261         public
262         view
263         override
264         returns (uint256)
265     {
266         return _allowances[owner][spender];
267     }
268  
269     function approve(address spender, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277  
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public override returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(
285             sender,
286             _msgSender(),
287             _allowances[sender][_msgSender()].sub(
288                 amount,
289                 "ERC20: transfer amount exceeds allowance"
290             )
291         );
292         return true;
293     }
294  
295     function tokenFromReflection(uint256 rAmount)
296         private
297         view
298         returns (uint256)
299     {
300         require(
301             rAmount <= _rTotal,
302             "Amount must be less than total reflections"
303         );
304         uint256 currentRate = _getRate();
305         return rAmount.div(currentRate);
306     }
307  
308     function removeAllFee() private {
309         if (_redisFee == 0 && _taxFee == 0) return;
310  
311         _previousredisFee = _redisFee;
312         _previoustaxFee = _taxFee;
313  
314         _redisFee = 0;
315         _taxFee = 0;
316     }
317  
318     function restoreAllFee() private {
319         _redisFee = _previousredisFee;
320         _taxFee = _previoustaxFee;
321     }
322  
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333  
334     function _transfer(
335         address from,
336         address to,
337         uint256 amount
338     ) private {
339         require(from != address(0), "ERC20: transfer from the zero address");
340         require(to != address(0), "ERC20: transfer to the zero address");
341         require(amount > 0, "Transfer amount must be greater than zero");
342  
343         if (from != owner() && to != owner()) {
344  
345             //Trade start check
346             if (!tradingOpen) {
347                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
348             }
349  
350             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
351             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
352  
353             if(block.number <= launchBlock+2 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
354                 bots[to] = true;
355             } 
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
417         _developmentAddress.transfer(amount.div(2));
418         _marketingAddress.transfer(amount.div(2));
419     }
420  
421     function setTrading(bool _tradingOpen) public onlyOwner {
422         tradingOpen = _tradingOpen;
423         launchBlock = block.number;
424     }
425  
426     function manualswap() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractBalance = balanceOf(address(this));
429         swapTokensForEth(contractBalance);
430     }
431  
432     function manualsend() external {
433         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
434         uint256 contractETHBalance = address(this).balance;
435         sendETHToFee(contractETHBalance);
436     }
437  
438     function blockBots(address[] memory bots_) public onlyOwner {
439         for (uint256 i = 0; i < bots_.length; i++) {
440             bots[bots_[i]] = true;
441         }
442     }
443  
444     function unblockBot(address notbot) public onlyOwner {
445         bots[notbot] = false;
446     }
447  
448     function _tokenTransfer(
449         address sender,
450         address recipient,
451         uint256 amount,
452         bool takeFee
453     ) private {
454         if (!takeFee) removeAllFee();
455         _transferStandard(sender, recipient, amount);
456         if (!takeFee) restoreAllFee();
457     }
458  
459     function _transferStandard(
460         address sender,
461         address recipient,
462         uint256 tAmount
463     ) private {
464         (
465             uint256 rAmount,
466             uint256 rTransferAmount,
467             uint256 rFee,
468             uint256 tTransferAmount,
469             uint256 tFee,
470             uint256 tTeam
471         ) = _getValues(tAmount);
472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
473         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
474         _takeTeam(tTeam);
475         _reflectFee(rFee, tFee);
476         emit Transfer(sender, recipient, tTransferAmount);
477     }
478  
479     function _takeTeam(uint256 tTeam) private {
480         uint256 currentRate = _getRate();
481         uint256 rTeam = tTeam.mul(currentRate);
482         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
483     }
484  
485     function _reflectFee(uint256 rFee, uint256 tFee) private {
486         _rTotal = _rTotal.sub(rFee);
487         _tFeeTotal = _tFeeTotal.add(tFee);
488     }
489  
490     receive() external payable {}
491  
492     function _getValues(uint256 tAmount)
493         private
494         view
495         returns (
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
505             _getTValues(tAmount, _redisFee, _taxFee);
506         uint256 currentRate = _getRate();
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
508             _getRValues(tAmount, tFee, tTeam, currentRate);
509  
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512  
513     function _getTValues(
514         uint256 tAmount,
515         uint256 redisFee,
516         uint256 taxFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(redisFee).div(100);
527         uint256 tTeam = tAmount.mul(taxFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529  
530         return (tTransferAmount, tFee, tTeam);
531     }
532  
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551  
552         return (rAmount, rTransferAmount, rFee);
553     }
554  
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557  
558         return rSupply.div(tSupply);
559     }
560  
561     function _getCurrentSupply() private view returns (uint256, uint256) {
562         uint256 rSupply = _rTotal;
563         uint256 tSupply = _tTotal;
564         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
565  
566         return (rSupply, tSupply);
567     }
568  
569     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
570         _redisFeeOnBuy = redisFeeOnBuy;
571         _redisFeeOnSell = redisFeeOnSell;
572  
573         _taxFeeOnBuy = taxFeeOnBuy;
574         _taxFeeOnSell = taxFeeOnSell;
575     }
576  
577     //Set minimum tokens required to swap.
578     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
579         _swapTokensAtAmount = swapTokensAtAmount;
580     }
581  
582     //Set minimum tokens required to swap.
583     function toggleSwap(bool _swapEnabled) public onlyOwner {
584         swapEnabled = _swapEnabled;
585     }
586  
587  
588     //Set maximum transaction
589     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
590         _maxTxAmount = maxTxAmount;
591     }
592  
593     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
594         _maxWalletSize = maxWalletSize;
595     }
596  
597     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
598         for(uint256 i = 0; i < accounts.length; i++) {
599             _isExcludedFromFee[accounts[i]] = excluded;
600         }
601     }
602 }