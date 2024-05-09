1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.12;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11  
12 
13 contract Ownable is Context {
14     address private _owner;
15     address private _previousOwner;
16     event OwnershipTransferred(
17         address indexed previousOwner,
18         address indexed newOwner
19     );
20  
21     constructor() {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26  
27     function owner() public view returns (address) {
28         return _owner;
29     }
30  
31     modifier onlyOwner() {
32         require(_owner == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35  
36     function renounceOwnership() public virtual onlyOwner {
37         emit OwnershipTransferred(_owner, address(0));
38         _owner = address(0);
39     }
40  
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         emit OwnershipTransferred(_owner, newOwner);
44         _owner = newOwner;
45     }
46  
47 }
48 
49 
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53  
54     function balanceOf(address account) external view returns (uint256);
55  
56     function transfer(address recipient, uint256 amount) external returns (bool);
57  
58     function allowance(address owner, address spender) external view returns (uint256);
59  
60     function approve(address spender, uint256 amount) external returns (bool);
61  
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67  
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(
70         address indexed owner,
71         address indexed spender,
72         uint256 value
73     );
74 }
75 
76 interface IUniswapV2Factory {
77     function createPair(address tokenA, address tokenB)
78         external
79         returns (address pair);
80 }
81  
82 interface IUniswapV2Router02 {
83     function swapExactTokensForETHSupportingFeeOnTransferTokens(
84         uint256 amountIn,
85         uint256 amountOutMin,
86         address[] calldata path,
87         address to,
88         uint256 deadline
89     ) external;
90  
91     function factory() external pure returns (address);
92  
93     function WETH() external pure returns (address);
94  
95     function addLiquidityETH(
96         address token,
97         uint256 amountTokenDesired,
98         uint256 amountTokenMin,
99         uint256 amountETHMin,
100         address to,
101         uint256 deadline
102     )
103         external
104         payable
105         returns (
106             uint256 amountToken,
107             uint256 amountETH,
108             uint256 liquidity
109         );
110 }
111  
112 library SafeMath {
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116         return c;
117     }
118  
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122  
123     function sub(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130         return c;
131     }
132  
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         if (a == 0) {
135             return 0;
136         }
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139         return c;
140     }
141  
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         return div(a, b, "SafeMath: division by zero");
144     }
145  
146     function div(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         return c;
154     }
155 }
156  
157 
158  
159 contract Shitarium is Context, IERC20, Ownable {
160  
161     using SafeMath for uint256;
162  
163     string private constant _name = "Shitarium"; 
164     string private constant _symbol = "Shit"; 
165     uint8 private constant _decimals = 9;
166  
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172 
173     uint256 private constant _tTotal = 1000000000 * 10**9; 
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176  
177     //Buy Fee
178     uint256 private _feeOnBuy = 0;  
179     uint256 private _taxOnBuy = 10;   
180  
181     //Sell Fee
182     uint256 private _feeOnSell = 0; 
183     uint256 private _taxOnSell = 20;  
184 
185     uint256 public totalFees;
186  
187     //Original Fee
188     uint256 private _redisFee = _feeOnSell;
189     uint256 private _taxFee = _taxOnSell;
190  
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193  
194     mapping(address => uint256) private cooldown;
195  
196     address payable private _developmentWalletAddress = payable(0x585A37c3eBa77AA41AF4100479FF58406C7CC774);
197     address payable private _marketingWalletAddress = payable(0x585A37c3eBa77AA41AF4100479FF58406C7CC774);
198  
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201  
202     bool private tradingOpen;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205  
206     uint256 public _maxTxAmount = 20000000 * 10**9;
207     uint256 public _maxWalletSize = 20000000 * 10**9; 
208     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
209  
210     event MaxTxAmountUpdated(uint256 _maxTxAmount);
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216  
217     constructor() {
218  
219         _rOwned[_msgSender()] = _rTotal;
220  
221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
222         uniswapV2Router = _uniswapV2Router;
223         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
224             .createPair(address(this), _uniswapV2Router.WETH());
225  
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_developmentWalletAddress] = true;
229         _isExcludedFromFee[_marketingWalletAddress] = true;
230  
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
355  
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359  
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362  
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367  
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376  
377         bool takeFee = true;
378  
379         //Transfer Tokens
380         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383  
384             //Set Fee for Buys
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _feeOnBuy;
387                 _taxFee = _taxOnBuy;
388             }
389  
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _feeOnSell;
393                 _taxFee = _taxOnSell;
394             }
395  
396         }
397  
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400  
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414  
415     function sendETHToFee(uint256 amount) private {
416         _developmentWalletAddress.transfer(amount.div(2));
417         _marketingWalletAddress.transfer(amount.div(2));
418     }
419  
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422     }
423  
424     function manualswap() external {
425         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429  
430     function manualsend() external {
431         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435  
436     function _tokenTransfer(
437         address sender,
438         address recipient,
439         uint256 amount,
440         bool takeFee
441     ) private {
442         if (!takeFee) removeAllFee();
443         _transferStandard(sender, recipient, amount);
444         if (!takeFee) restoreAllFee();
445     }
446  
447     function _transferStandard(
448         address sender,
449         address recipient,
450         uint256 tAmount
451     ) private {
452         (
453             uint256 rAmount,
454             uint256 rTransferAmount,
455             uint256 rFee,
456             uint256 tTransferAmount,
457             uint256 tFee,
458             uint256 tTeam
459         ) = _getValues(tAmount);
460         _rOwned[sender] = _rOwned[sender].sub(rAmount);
461         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
462         _takeTeam(tTeam);
463         _reflectFee(rFee, tFee);
464         emit Transfer(sender, recipient, tTransferAmount);
465     }
466  
467     function _takeTeam(uint256 tTeam) private {
468         uint256 currentRate = _getRate();
469         uint256 rTeam = tTeam.mul(currentRate);
470         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
471     }
472  
473     function _reflectFee(uint256 rFee, uint256 tFee) private {
474         _rTotal = _rTotal.sub(rFee);
475         _tFeeTotal = _tFeeTotal.add(tFee);
476     }
477  
478     receive() external payable {}
479  
480     function _getValues(uint256 tAmount)
481         private
482         view
483         returns (
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256
490         )
491     {
492         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
493             _getTValues(tAmount, _redisFee, _taxFee);
494         uint256 currentRate = _getRate();
495         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
496             _getRValues(tAmount, tFee, tTeam, currentRate);
497  
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500  
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517  
518         return (tTransferAmount, tFee, tTeam);
519     }
520  
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539  
540         return (rAmount, rTransferAmount, rFee);
541     }
542  
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545  
546         return rSupply.div(tSupply);
547     }
548  
549     function _getCurrentSupply() private view returns (uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
553  
554         return (rSupply, tSupply);
555     }
556  
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         _feeOnBuy = redisFeeOnBuy;
559         _feeOnSell = redisFeeOnSell;
560         _taxOnBuy = taxFeeOnBuy;
561         _taxOnSell = taxFeeOnSell;
562         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
563         require(totalFees <= 100, "Must keep fees at 100% or less");
564     }
565  
566     //Set minimum tokens required to swap.
567     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
568         _swapTokensAtAmount = swapTokensAtAmount;
569     }
570  
571     //Set minimum tokens required to swap.
572     function toggleSwap(bool _swapEnabled) public onlyOwner {
573         swapEnabled = _swapEnabled;
574     }
575  
576  
577     //Set max buy amount 
578     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
579         _maxTxAmount = maxTxAmount;
580     }
581 
582     //Set max wallet amount 
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