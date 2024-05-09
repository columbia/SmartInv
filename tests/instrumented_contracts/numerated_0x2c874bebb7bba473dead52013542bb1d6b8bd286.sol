1 // SPDX-License-Identifier: unlicense
2 
3 pragma solidity ^0.8.7;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10  
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13  
14     function balanceOf(address account) external view returns (uint256);
15  
16     function transfer(address recipient, uint256 amount) external returns (bool);
17  
18     function allowance(address owner, address spender) external view returns (uint256);
19  
20     function approve(address spender, uint256 amount) external returns (bool);
21  
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27  
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35  
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43  
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49  
50     function owner() public view returns (address) {
51         return _owner;
52     }
53  
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58  
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63  
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69  
70 }
71  
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78  
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82  
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92  
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101  
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105  
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116  
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122  
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131  
132     function factory() external pure returns (address);
133  
134     function WETH() external pure returns (address);
135  
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152  
153 contract ZELDA is Context, IERC20, Ownable {
154  
155     using SafeMath for uint256;
156  
157     string private constant _name = "ZELDA";//
158     string private constant _symbol = "ZELDA";//
159     uint8 private constant _decimals = 9;
160  
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 3000000000 * 10**9;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169     uint256 public launchBlock;
170  
171     //Buy Fee
172     uint256 private _redisFeeOnBuy = 0;//
173     uint256 private _taxFeeOnBuy = 20;//
174  
175     //Sell Fee
176     uint256 private _redisFeeOnSell = 0;//
177     uint256 private _taxFeeOnSell = 25;//
178  
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182  
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185  
186     mapping(address => bool) public bots;
187     mapping(address => uint256) private cooldown;
188  
189     address payable private _developmentAddress = payable(0xEd654be532EB38cEF7A4DA7192ea4FeC5Da7d761);//
190     address payable private _marketingAddress = payable(0xEd654be532EB38cEF7A4DA7192ea4FeC5Da7d761);//
191  
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194  
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198  
199     uint256 public _maxTxAmount = 30000000 * 10**9; //
200     uint256 public _maxWalletSize = 60000000 * 10**9; //
201     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
202  
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209  
210     constructor() {
211  
212         _rOwned[_msgSender()] = _rTotal;
213  
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218  
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223   
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226  
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230  
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234  
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238  
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242  
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246  
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255  
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264  
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273  
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290  
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303  
304     function removeAllFee() private {
305         if (_redisFee == 0 && _taxFee == 0) return;
306  
307         _previousredisFee = _redisFee;
308         _previoustaxFee = _taxFee;
309  
310         _redisFee = 0;
311         _taxFee = 0;
312     }
313  
314     function restoreAllFee() private {
315         _redisFee = _previousredisFee;
316         _taxFee = _previoustaxFee;
317     }
318  
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329  
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338  
339         if (from != owner() && to != owner()) {
340  
341             //Trade start check
342             if (!tradingOpen) {
343                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
344             }
345  
346             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
348  
349             if(block.number <= launchBlock+0 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
350                 bots[to] = true;
351             } 
352  
353             if(to != uniswapV2Pair) {
354                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
355             }
356  
357             uint256 contractTokenBalance = balanceOf(address(this));
358             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
359  
360             if(contractTokenBalance >= _maxTxAmount)
361             {
362                 contractTokenBalance = _maxTxAmount;
363             }
364  
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
366                 swapTokensForEth(contractTokenBalance);
367                 uint256 contractETHBalance = address(this).balance;
368                 if (contractETHBalance > 0) {
369                     sendETHToFee(address(this).balance);
370                 }
371             }
372         }
373  
374         bool takeFee = true;
375  
376         //Transfer Tokens
377         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
378             takeFee = false;
379         } else {
380  
381             //Set Fee for Buys
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386  
387             //Set Fee for Sells
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392  
393         }
394  
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397  
398     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = uniswapV2Router.WETH();
402         _approve(address(this), address(uniswapV2Router), tokenAmount);
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0,
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411  
412     function sendETHToFee(uint256 amount) private {
413         _developmentAddress.transfer(amount.div(2));
414         _marketingAddress.transfer(amount.div(2));
415     }
416  
417     function setTrading(bool _tradingOpen) public onlyOwner {
418         tradingOpen = _tradingOpen;
419         launchBlock = block.number;
420     }
421  
422     function manualswap() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractBalance = balanceOf(address(this));
425         swapTokensForEth(contractBalance);
426     }
427  
428     function manualsend() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractETHBalance = address(this).balance;
431         sendETHToFee(contractETHBalance);
432     }
433  
434     function blockBots(address[] memory bots_) public onlyOwner {
435         for (uint256 i = 0; i < bots_.length; i++) {
436             bots[bots_[i]] = true;
437         }
438     }
439  
440     function unblockBot(address notbot) public onlyOwner {
441         bots[notbot] = false;
442     }
443  
444     function _tokenTransfer(
445         address sender,
446         address recipient,
447         uint256 amount,
448         bool takeFee
449     ) private {
450         if (!takeFee) removeAllFee();
451         _transferStandard(sender, recipient, amount);
452         if (!takeFee) restoreAllFee();
453     }
454  
455     function _transferStandard(
456         address sender,
457         address recipient,
458         uint256 tAmount
459     ) private {
460         (
461             uint256 rAmount,
462             uint256 rTransferAmount,
463             uint256 rFee,
464             uint256 tTransferAmount,
465             uint256 tFee,
466             uint256 tTeam
467         ) = _getValues(tAmount);
468         _rOwned[sender] = _rOwned[sender].sub(rAmount);
469         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
470         _takeTeam(tTeam);
471         _reflectFee(rFee, tFee);
472         emit Transfer(sender, recipient, tTransferAmount);
473     }
474  
475     function _takeTeam(uint256 tTeam) private {
476         uint256 currentRate = _getRate();
477         uint256 rTeam = tTeam.mul(currentRate);
478         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
479     }
480  
481     function _reflectFee(uint256 rFee, uint256 tFee) private {
482         _rTotal = _rTotal.sub(rFee);
483         _tFeeTotal = _tFeeTotal.add(tFee);
484     }
485  
486     receive() external payable {}
487  
488     function _getValues(uint256 tAmount)
489         private
490         view
491         returns (
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
501             _getTValues(tAmount, _redisFee, _taxFee);
502         uint256 currentRate = _getRate();
503         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
504             _getRValues(tAmount, tFee, tTeam, currentRate);
505  
506         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
507     }
508  
509     function _getTValues(
510         uint256 tAmount,
511         uint256 redisFee,
512         uint256 taxFee
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 tFee = tAmount.mul(redisFee).div(100);
523         uint256 tTeam = tAmount.mul(taxFee).div(100);
524         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
525  
526         return (tTransferAmount, tFee, tTeam);
527     }
528  
529     function _getRValues(
530         uint256 tAmount,
531         uint256 tFee,
532         uint256 tTeam,
533         uint256 currentRate
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rFee = tFee.mul(currentRate);
545         uint256 rTeam = tTeam.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
547  
548         return (rAmount, rTransferAmount, rFee);
549     }
550  
551     function _getRate() private view returns (uint256) {
552         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
553  
554         return rSupply.div(tSupply);
555     }
556  
557     function _getCurrentSupply() private view returns (uint256, uint256) {
558         uint256 rSupply = _rTotal;
559         uint256 tSupply = _tTotal;
560         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
561  
562         return (rSupply, tSupply);
563     }
564  
565     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
566         _redisFeeOnBuy = redisFeeOnBuy;
567         _redisFeeOnSell = redisFeeOnSell;
568  
569         _taxFeeOnBuy = taxFeeOnBuy;
570         _taxFeeOnSell = taxFeeOnSell;
571     }
572  
573     //Set minimum tokens required to swap.
574     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
575         _swapTokensAtAmount = swapTokensAtAmount;
576     }
577  
578     //Set minimum tokens required to swap.
579     function toggleSwap(bool _swapEnabled) public onlyOwner {
580         swapEnabled = _swapEnabled;
581     }
582  
583  
584     //Set maximum transaction
585     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
586         _maxTxAmount = maxTxAmount;
587     }
588  
589     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
590         _maxWalletSize = maxWalletSize;
591     }
592  
593     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
594         for(uint256 i = 0; i < accounts.length; i++) {
595             _isExcludedFromFee[accounts[i]] = excluded;
596         }
597     }
598 }