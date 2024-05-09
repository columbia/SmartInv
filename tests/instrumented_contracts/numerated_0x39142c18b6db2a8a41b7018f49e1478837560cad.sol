1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
3  
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9  
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12  
13     function balanceOf(address account) external view returns (uint256);
14  
15     function transfer(address recipient, uint256 amount) external returns (bool);
16  
17     function allowance(address owner, address spender) external view returns (uint256);
18  
19     function approve(address spender, uint256 amount) external returns (bool);
20  
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26  
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34  
35 contract Ownable is Context {
36     address private _owner;
37     address private _previousOwner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42  
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48  
49     function owner() public view returns (address) {
50         return _owner;
51     }
52  
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57  
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62  
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68  
69 }
70  
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77  
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81  
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91  
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100  
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104  
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115  
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121  
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130  
131     function factory() external pure returns (address);
132  
133     function WETH() external pure returns (address);
134  
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151  
152 contract Stats is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "Stats";
157     string private constant _symbol = "STATS";
158     uint8 private constant _decimals = 9;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 10000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _redisFeeOnBuy = 0;  
169     uint256 private _taxFeeOnBuy = 5;  
170     uint256 private _redisFeeOnSell = 0;  
171     uint256 private _taxFeeOnSell = 5;
172  
173     //Original Fee
174     uint256 private _redisFee = _redisFeeOnSell;
175     uint256 private _taxFee = _taxFeeOnSell;
176  
177     uint256 private _previousredisFee = _redisFee;
178     uint256 private _previoustaxFee = _taxFee;
179  
180     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
181     address payable private _developmentAddress = payable(0xe17F2970c096450e7C88995bc5B220dB8cBa1F4A); 
182     address payable private _marketingAddress = payable(0xe17F2970c096450e7C88995bc5B220dB8cBa1F4A);
183  
184     IUniswapV2Router02 public uniswapV2Router;
185     address public uniswapV2Pair;
186  
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = true;
190  
191     uint256 public _maxTxAmount = 10000000 * 10**9; 
192     uint256 public _maxWalletSize = 10000000 * 10**9; 
193     uint256 public _swapTokensAtAmount = 100 * 10**9;
194  
195     event MaxTxAmountUpdated(uint256 _maxTxAmount);
196     modifier lockTheSwap {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201  
202     constructor() {
203  
204         _rOwned[_msgSender()] = _rTotal;
205  
206         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
207         uniswapV2Router = _uniswapV2Router;
208         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
209             .createPair(address(this), _uniswapV2Router.WETH());
210  
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[address(this)] = true;
213         _isExcludedFromFee[_developmentAddress] = true;
214         _isExcludedFromFee[_marketingAddress] = true;
215  
216         emit Transfer(address(0), _msgSender(), _tTotal);
217     }
218  
219     function name() public pure returns (string memory) {
220         return _name;
221     }
222  
223     function symbol() public pure returns (string memory) {
224         return _symbol;
225     }
226  
227     function decimals() public pure returns (uint8) {
228         return _decimals;
229     }
230  
231     function totalSupply() public pure override returns (uint256) {
232         return _tTotal;
233     }
234  
235     function balanceOf(address account) public view override returns (uint256) {
236         return tokenFromReflection(_rOwned[account]);
237     }
238  
239     function transfer(address recipient, uint256 amount)
240         public
241         override
242         returns (bool)
243     {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247  
248     function allowance(address owner, address spender)
249         public
250         view
251         override
252         returns (uint256)
253     {
254         return _allowances[owner][spender];
255     }
256  
257     function approve(address spender, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265  
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) public override returns (bool) {
271         _transfer(sender, recipient, amount);
272         _approve(
273             sender,
274             _msgSender(),
275             _allowances[sender][_msgSender()].sub(
276                 amount,
277                 "ERC20: transfer amount exceeds allowance"
278             )
279         );
280         return true;
281     }
282  
283     function tokenFromReflection(uint256 rAmount)
284         private
285         view
286         returns (uint256)
287     {
288         require(
289             rAmount <= _rTotal,
290             "Amount must be less than total reflections"
291         );
292         uint256 currentRate = _getRate();
293         return rAmount.div(currentRate);
294     }
295  
296     function removeAllFee() private {
297         if (_redisFee == 0 && _taxFee == 0) return;
298  
299         _previousredisFee = _redisFee;
300         _previoustaxFee = _taxFee;
301  
302         _redisFee = 0;
303         _taxFee = 0;
304     }
305  
306     function restoreAllFee() private {
307         _redisFee = _previousredisFee;
308         _taxFee = _previoustaxFee;
309     }
310  
311     function _approve(
312         address owner,
313         address spender,
314         uint256 amount
315     ) private {
316         require(owner != address(0), "ERC20: approve from the zero address");
317         require(spender != address(0), "ERC20: approve to the zero address");
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321  
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) private {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329         require(amount > 0, "Transfer amount must be greater than zero");
330  
331         if (from != owner() && to != owner()) {
332  
333             //Trade start check
334             if (!tradingOpen) {
335                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
336             }
337  
338             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
339             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
340  
341             if(to != uniswapV2Pair) {
342                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
343             }
344  
345             uint256 contractTokenBalance = balanceOf(address(this));
346             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
347  
348             if(contractTokenBalance >= _maxTxAmount)
349             {
350                 contractTokenBalance = _maxTxAmount;
351             }
352  
353             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
354                 swapTokensForEth(contractTokenBalance);
355                 uint256 contractETHBalance = address(this).balance;
356                 if (contractETHBalance > 0) {
357                     sendETHToFee(address(this).balance);
358                 }
359             }
360         }
361  
362         bool takeFee = true;
363  
364         //Transfer Tokens
365         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
366             takeFee = false;
367         } else {
368  
369             //Set Fee for Buys
370             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
371                 _redisFee = _redisFeeOnBuy;
372                 _taxFee = _taxFeeOnBuy;
373             }
374  
375             //Set Fee for Sells
376             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnSell;
378                 _taxFee = _taxFeeOnSell;
379             }
380  
381         }
382  
383         _tokenTransfer(from, to, amount, takeFee);
384     }
385  
386     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
387         address[] memory path = new address[](2);
388         path[0] = address(this);
389         path[1] = uniswapV2Router.WETH();
390         _approve(address(this), address(uniswapV2Router), tokenAmount);
391         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             tokenAmount,
393             0,
394             path,
395             address(this),
396             block.timestamp
397         );
398     }
399  
400     function sendETHToFee(uint256 amount) private {
401         _marketingAddress.transfer(amount);
402     }
403  
404     function setTrading(bool _tradingOpen) public onlyOwner {
405         tradingOpen = _tradingOpen;
406     }
407  
408     function manualswap() external {
409         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
410         uint256 contractBalance = balanceOf(address(this));
411         swapTokensForEth(contractBalance);
412     }
413  
414     function manualsend() external {
415         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
416         uint256 contractETHBalance = address(this).balance;
417         sendETHToFee(contractETHBalance);
418     }
419  
420     function blockBots(address[] memory bots_) public onlyOwner {
421         for (uint256 i = 0; i < bots_.length; i++) {
422             bots[bots_[i]] = true;
423         }
424     }
425  
426     function unblockBot(address notbot) public onlyOwner {
427         bots[notbot] = false;
428     }
429  
430     function _tokenTransfer(
431         address sender,
432         address recipient,
433         uint256 amount,
434         bool takeFee
435     ) private {
436         if (!takeFee) removeAllFee();
437         _transferStandard(sender, recipient, amount);
438         if (!takeFee) restoreAllFee();
439     }
440  
441     function _transferStandard(
442         address sender,
443         address recipient,
444         uint256 tAmount
445     ) private {
446         (
447             uint256 rAmount,
448             uint256 rTransferAmount,
449             uint256 rFee,
450             uint256 tTransferAmount,
451             uint256 tFee,
452             uint256 tTeam
453         ) = _getValues(tAmount);
454         _rOwned[sender] = _rOwned[sender].sub(rAmount);
455         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
456         _takeTeam(tTeam);
457         _reflectFee(rFee, tFee);
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460  
461     function _takeTeam(uint256 tTeam) private {
462         uint256 currentRate = _getRate();
463         uint256 rTeam = tTeam.mul(currentRate);
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466  
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471  
472     receive() external payable {}
473  
474     function _getValues(uint256 tAmount)
475         private
476         view
477         returns (
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256
484         )
485     {
486         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
487             _getTValues(tAmount, _redisFee, _taxFee);
488         uint256 currentRate = _getRate();
489         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
490             _getRValues(tAmount, tFee, tTeam, currentRate);
491         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
492     }
493  
494     function _getTValues(
495         uint256 tAmount,
496         uint256 redisFee,
497         uint256 taxFee
498     )
499         private
500         pure
501         returns (
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         uint256 tFee = tAmount.mul(redisFee).div(100);
508         uint256 tTeam = tAmount.mul(taxFee).div(100);
509         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
510         return (tTransferAmount, tFee, tTeam);
511     }
512  
513     function _getRValues(
514         uint256 tAmount,
515         uint256 tFee,
516         uint256 tTeam,
517         uint256 currentRate
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 rAmount = tAmount.mul(currentRate);
528         uint256 rFee = tFee.mul(currentRate);
529         uint256 rTeam = tTeam.mul(currentRate);
530         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
531         return (rAmount, rTransferAmount, rFee);
532     }
533  
534     function _getRate() private view returns (uint256) {
535         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
536         return rSupply.div(tSupply);
537     }
538  
539     function _getCurrentSupply() private view returns (uint256, uint256) {
540         uint256 rSupply = _rTotal;
541         uint256 tSupply = _tTotal;
542         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
543         return (rSupply, tSupply);
544     }
545  
546     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
547         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
548         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
549         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
550         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
551 
552         _redisFeeOnBuy = redisFeeOnBuy;
553         _redisFeeOnSell = redisFeeOnSell;
554         _taxFeeOnBuy = taxFeeOnBuy;
555         _taxFeeOnSell = taxFeeOnSell;
556 
557     }
558  
559     //Set minimum tokens required to swap.
560     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
561         _swapTokensAtAmount = swapTokensAtAmount;
562     }
563  
564     //Set minimum tokens required to swap.
565     function toggleSwap(bool _swapEnabled) public onlyOwner {
566         swapEnabled = _swapEnabled;
567     }
568  
569     //Set maximum transaction
570     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
571            _maxTxAmount = maxTxAmount;
572         
573     }
574  
575     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
576         _maxWalletSize = maxWalletSize;
577     }
578  
579     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
580         for(uint256 i = 0; i < accounts.length; i++) {
581             _isExcludedFromFee[accounts[i]] = excluded;
582         }
583     }
584 
585 }