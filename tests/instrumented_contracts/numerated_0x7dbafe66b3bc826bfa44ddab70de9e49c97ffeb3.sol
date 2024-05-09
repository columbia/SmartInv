1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.4;
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
152 contract SecretERC is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "Secret";
157     string private constant _symbol = "$SECRET";
158     uint8 private constant _decimals = 9;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 1000000000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 public launchBlock;
169  
170     //Buy Fee
171     uint256 private _redisFeeOnBuy = 0;
172     uint256 private _taxFeeOnBuy = 4;
173  
174     //Sell Fee
175     uint256 private _redisFeeOnSell = 0;
176     uint256 private _taxFeeOnSell = 90;
177  
178     //Original Fee
179     uint256 private _redisFee = _redisFeeOnSell;
180     uint256 private _taxFee = _taxFeeOnSell;
181  
182     uint256 private _previousredisFee = _redisFee;
183     uint256 private _previoustaxFee = _taxFee;
184  
185     mapping(address => bool) public bots;
186     mapping(address => uint256) private cooldown;
187  
188     address payable private _developmentAddress = payable(0xdE3d7C809eBBa88744Fd2282AED97d3331933Ba6);
189     address payable private _marketingAddress = payable(0xdE3d7C809eBBa88744Fd2282AED97d3331933Ba6);
190  
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193  
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197  
198     uint256 public _maxTxAmount = 20000000000 * 10**9; 
199     uint256 public _maxWalletSize = 20000000000 * 10**9; 
200     uint256 public _swapTokensAtAmount = 10000000 * 10**9; 
201  
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208  
209     constructor() {
210  
211         _rOwned[_msgSender()] = _rTotal;
212  
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217  
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222 
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225  
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229  
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233  
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237  
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241  
242     function balanceOf(address account) public view override returns (uint256) {
243         return tokenFromReflection(_rOwned[account]);
244     }
245  
246     function transfer(address recipient, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254  
255     function allowance(address owner, address spender)
256         public
257         view
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263  
264     function approve(address spender, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272  
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) public override returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(
280             sender,
281             _msgSender(),
282             _allowances[sender][_msgSender()].sub(
283                 amount,
284                 "ERC20: transfer amount exceeds allowance"
285             )
286         );
287         return true;
288     }
289  
290     function tokenFromReflection(uint256 rAmount)
291         private
292         view
293         returns (uint256)
294     {
295         require(
296             rAmount <= _rTotal,
297             "Amount must be less than total reflections"
298         );
299         uint256 currentRate = _getRate();
300         return rAmount.div(currentRate);
301     }
302  
303     function removeAllFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305  
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308  
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312  
313     function restoreAllFee() private {
314         _redisFee = _previousredisFee;
315         _taxFee = _previoustaxFee;
316     }
317  
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328  
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337  
338         if (from != owner() && to != owner()) {
339  
340             //Trade start check
341             if (!tradingOpen) {
342                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344  
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
347  
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351  
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354  
355             if(contractTokenBalance >= _maxTxAmount)
356             {
357                 contractTokenBalance = _maxTxAmount;
358             }
359  
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 0) {
364                     sendETHToFee(address(this).balance);
365                 }
366             }
367         }
368  
369         bool takeFee = true;
370  
371         //Transfer Tokens
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375  
376             //Set Fee for Buys
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381  
382             //Set Fee for Sells
383             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnSell;
385                 _taxFee = _taxFeeOnSell;
386             }
387  
388         }
389  
390         _tokenTransfer(from, to, amount, takeFee);
391     }
392  
393     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = uniswapV2Router.WETH();
397         _approve(address(this), address(uniswapV2Router), tokenAmount);
398         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
399             tokenAmount,
400             0,
401             path,
402             address(this),
403             block.timestamp
404         );
405     }
406  
407     function sendETHToFee(uint256 amount) private {
408         _developmentAddress.transfer(amount.mul(50).div(100));
409         _marketingAddress.transfer(amount.mul(50).div(100));
410     }
411  
412     function setTrading(bool _tradingOpen) public onlyOwner {
413         tradingOpen = _tradingOpen;
414     }
415  
416     function manualswap() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractBalance = balanceOf(address(this));
419         swapTokensForEth(contractBalance);
420     }
421  
422     function manualsend() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractETHBalance = address(this).balance;
425         sendETHToFee(contractETHBalance);
426     }
427  
428     function blockBots(address[] memory bots_) public onlyOwner {
429         for (uint256 i = 0; i < bots_.length; i++) {
430             bots[bots_[i]] = true;
431         }
432     }
433  
434     function unblockBot(address notbot) public onlyOwner {
435         bots[notbot] = false;
436     }
437  
438     function _tokenTransfer(
439         address sender,
440         address recipient,
441         uint256 amount,
442         bool takeFee
443     ) private {
444         if (!takeFee) removeAllFee();
445         _transferStandard(sender, recipient, amount);
446         if (!takeFee) restoreAllFee();
447     }
448  
449     function _transferStandard(
450         address sender,
451         address recipient,
452         uint256 tAmount
453     ) private {
454         (
455             uint256 rAmount,
456             uint256 rTransferAmount,
457             uint256 rFee,
458             uint256 tTransferAmount,
459             uint256 tFee,
460             uint256 tTeam
461         ) = _getValues(tAmount);
462         _rOwned[sender] = _rOwned[sender].sub(rAmount);
463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
464         _takeTeam(tTeam);
465         _reflectFee(rFee, tFee);
466         emit Transfer(sender, recipient, tTransferAmount);
467     }
468  
469     function _takeTeam(uint256 tTeam) private {
470         uint256 currentRate = _getRate();
471         uint256 rTeam = tTeam.mul(currentRate);
472         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
473     }
474  
475     function _reflectFee(uint256 rFee, uint256 tFee) private {
476         _rTotal = _rTotal.sub(rFee);
477         _tFeeTotal = _tFeeTotal.add(tFee);
478     }
479  
480     receive() external payable {}
481  
482     function _getValues(uint256 tAmount)
483         private
484         view
485         returns (
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
495             _getTValues(tAmount, _redisFee, _taxFee);
496         uint256 currentRate = _getRate();
497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
498             _getRValues(tAmount, tFee, tTeam, currentRate);
499  
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502  
503     function _getTValues(
504         uint256 tAmount,
505         uint256 redisFee,
506         uint256 taxFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(redisFee).div(100);
517         uint256 tTeam = tAmount.mul(taxFee).div(100);
518         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
519  
520         return (tTransferAmount, tFee, tTeam);
521     }
522  
523     function _getRValues(
524         uint256 tAmount,
525         uint256 tFee,
526         uint256 tTeam,
527         uint256 currentRate
528     )
529         private
530         pure
531         returns (
532             uint256,
533             uint256,
534             uint256
535         )
536     {
537         uint256 rAmount = tAmount.mul(currentRate);
538         uint256 rFee = tFee.mul(currentRate);
539         uint256 rTeam = tTeam.mul(currentRate);
540         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
541  
542         return (rAmount, rTransferAmount, rFee);
543     }
544  
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547  
548         return rSupply.div(tSupply);
549     }
550  
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555  
556         return (rSupply, tSupply);
557     }
558  
559     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
560         _redisFeeOnBuy = redisFeeOnBuy;
561         _redisFeeOnSell = redisFeeOnSell;
562  
563         _taxFeeOnBuy = taxFeeOnBuy;
564         _taxFeeOnSell = taxFeeOnSell;
565     }
566  
567     //Set minimum tokens required to swap.
568     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
569         _swapTokensAtAmount = swapTokensAtAmount;
570     }
571  
572     //Set minimum tokens required to swap.
573     function toggleSwap(bool _swapEnabled) public onlyOwner {
574         swapEnabled = _swapEnabled;
575     }
576  
577  
578     //Set maximum transaction
579     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
580         _maxTxAmount = maxTxAmount;
581     }
582  
583     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
584         _maxWalletSize = maxWalletSize;
585     }
586  
587     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
588         for(uint256 i = 0; i < accounts.length; i++) {
589             _isExcludedFromFee[accounts[i]] = excluded;
590         }
591     }
592 }