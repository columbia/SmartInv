1 // SPDX-License-Identifier: MIT
2    pragma solidity ^0.8.15;
3  
4    abstract contract Context {
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
152 contract x is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "1000X"; 
157     string private constant _symbol = "1000X"; 
158     uint8 private constant _decimals = 9;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165 
166     uint256 private constant _tTotal = 100000000 * 10**9; 
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169  
170     //Buy Fee
171     uint256 private _feeOnBuy = 0;  
172     uint256 private _taxOnBuy = 12;  
173  
174     //Sell Fee
175     uint256 private _feeOnSell = 0; 
176     uint256 private _taxOnSell = 22;  
177 
178     uint256 public totalFees;
179  
180     //Original Fee
181     uint256 private _redisFee = _feeOnSell;
182     uint256 private _taxFee = _taxOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => uint256) private cooldown;
188  
189     address payable private _developmentWalletAddress = payable(0x704A68571aEDfb64096656c09362c06F60242F41);
190     address payable private _marketingWalletAddress = payable(0x704A68571aEDfb64096656c09362c06F60242F41);
191  
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194  
195     bool private tradingOpen = false;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198  
199     uint256 public _maxTxAmount = 2000000 * 10**9;
200     uint256 public _maxWalletSize = 2000000 * 10**9;
201     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
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
221         _isExcludedFromFee[_developmentWalletAddress] = true;
222         _isExcludedFromFee[_marketingWalletAddress] = true;
223  
224  
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227  
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231  
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235  
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239  
240     function totalSupply() public pure override returns (uint256) {
241         return _tTotal;
242     }
243  
244     function balanceOf(address account) public view override returns (uint256) {
245         return tokenFromReflection(_rOwned[account]);
246     }
247  
248     function transfer(address recipient, uint256 amount)
249         public
250         override
251         returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256  
257     function allowance(address owner, address spender)
258         public
259         view
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265  
266     function approve(address spender, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274  
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) public override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(
282             sender,
283             _msgSender(),
284             _allowances[sender][_msgSender()].sub(
285                 amount,
286                 "ERC20: transfer amount exceeds allowance"
287             )
288         );
289         return true;
290     }
291  
292     function tokenFromReflection(uint256 rAmount)
293         private
294         view
295         returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304  
305     function removeAllFee() private {
306         if (_redisFee == 0 && _taxFee == 0) return;
307  
308         _previousredisFee = _redisFee;
309         _previoustaxFee = _taxFee;
310  
311         _redisFee = 0;
312         _taxFee = 0;
313     }
314  
315     function restoreAllFee() private {
316         _redisFee = _previousredisFee;
317         _taxFee = _previoustaxFee;
318     }
319  
320     function _approve(
321         address owner,
322         address spender,
323         uint256 amount
324     ) private {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330  
331     function _transfer(
332         address from,
333         address to,
334         uint256 amount
335     ) private {
336         require(from != address(0), "ERC20: transfer from the zero address");
337         require(to != address(0), "ERC20: transfer to the zero address");
338         require(amount > 0, "Transfer amount must be greater than zero");
339  
340         if (from != owner() && to != owner()) {
341  
342             //Trade start check
343             if (!tradingOpen) {
344                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
345             }
346  
347             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
348  
349             if(to != uniswapV2Pair) {
350                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
351             }
352  
353             uint256 contractTokenBalance = balanceOf(address(this));
354             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
355  
356             if(contractTokenBalance >= _maxTxAmount)
357             {
358                 contractTokenBalance = _maxTxAmount;
359             }
360  
361             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
362                 swapTokensForEth(contractTokenBalance);
363                 uint256 contractETHBalance = address(this).balance;
364                 if (contractETHBalance > 0) {
365                     sendETHToFee(address(this).balance);
366                 }
367             }
368         }
369  
370         bool takeFee = true;
371  
372         //Transfer Tokens
373         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
374             takeFee = false;
375         } else {
376  
377             //Set Fee for Buys
378             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
379                 _redisFee = _feeOnBuy;
380                 _taxFee = _taxOnBuy;
381             }
382  
383             //Set Fee for Sells
384             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
385                 _redisFee = _feeOnSell;
386                 _taxFee = _taxOnSell;
387             }
388  
389         }
390  
391         _tokenTransfer(from, to, amount, takeFee);
392     }
393  
394     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = uniswapV2Router.WETH();
398         _approve(address(this), address(uniswapV2Router), tokenAmount);
399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0,
402             path,
403             address(this),
404             block.timestamp
405         );
406     }
407  
408     function sendETHToFee(uint256 amount) private {
409         _marketingWalletAddress.transfer(amount);
410     }
411  
412     function setTrading(bool _tradingOpen) public onlyOwner {
413         tradingOpen = _tradingOpen;
414     }
415  
416     function _tokenTransfer(
417         address sender,
418         address recipient,
419         uint256 amount,
420         bool takeFee
421     ) private {
422         if (!takeFee) removeAllFee();
423         _transferStandard(sender, recipient, amount);
424         if (!takeFee) restoreAllFee();
425     }
426  
427     function _transferStandard(
428         address sender,
429         address recipient,
430         uint256 tAmount
431     ) private {
432         (
433             uint256 rAmount,
434             uint256 rTransferAmount,
435             uint256 rFee,
436             uint256 tTransferAmount,
437             uint256 tFee,
438             uint256 tTeam
439         ) = _getValues(tAmount);
440         _rOwned[sender] = _rOwned[sender].sub(rAmount);
441         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
442         _takeTeam(tTeam);
443         _reflectFee(rFee, tFee);
444         emit Transfer(sender, recipient, tTransferAmount);
445     }
446  
447     function _takeTeam(uint256 tTeam) private {
448         uint256 currentRate = _getRate();
449         uint256 rTeam = tTeam.mul(currentRate);
450         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
451     }
452  
453     function _reflectFee(uint256 rFee, uint256 tFee) private {
454         _rTotal = _rTotal.sub(rFee);
455         _tFeeTotal = _tFeeTotal.add(tFee);
456     }
457  
458     receive() external payable {}
459  
460     function _getValues(uint256 tAmount)
461         private
462         view
463         returns (
464             uint256,
465             uint256,
466             uint256,
467             uint256,
468             uint256,
469             uint256
470         )
471     {
472         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
473             _getTValues(tAmount, _redisFee, _taxFee);
474         uint256 currentRate = _getRate();
475         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
476             _getRValues(tAmount, tFee, tTeam, currentRate);
477  
478         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
479     }
480  
481     function _getTValues(
482         uint256 tAmount,
483         uint256 redisFee,
484         uint256 taxFee
485     )
486         private
487         pure
488         returns (
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         uint256 tFee = tAmount.mul(redisFee).div(100);
495         uint256 tTeam = tAmount.mul(taxFee).div(100);
496         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
497  
498         return (tTransferAmount, tFee, tTeam);
499     }
500  
501     function _getRValues(
502         uint256 tAmount,
503         uint256 tFee,
504         uint256 tTeam,
505         uint256 currentRate
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 rAmount = tAmount.mul(currentRate);
516         uint256 rFee = tFee.mul(currentRate);
517         uint256 rTeam = tTeam.mul(currentRate);
518         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
519  
520         return (rAmount, rTransferAmount, rFee);
521     }
522  
523     function _getRate() private view returns (uint256) {
524         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
525  
526         return rSupply.div(tSupply);
527     }
528  
529     function _getCurrentSupply() private view returns (uint256, uint256) {
530         uint256 rSupply = _rTotal;
531         uint256 tSupply = _tTotal;
532         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
533  
534         return (rSupply, tSupply);
535     }
536  
537     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
538         _feeOnBuy = redisFeeOnBuy;
539         _feeOnSell = redisFeeOnSell;
540         _taxOnBuy = taxFeeOnBuy;
541         _taxOnSell = taxFeeOnSell;
542         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
543         require(totalFees <= 100, "");
544     }
545  
546     //Set minimum tokens required to swap.
547     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
548         _swapTokensAtAmount = swapTokensAtAmount;
549     }
550  
551     //Set minimum tokens required to swap.
552     function toggleSwap(bool _swapEnabled) public onlyOwner {
553         swapEnabled = _swapEnabled;
554     }
555     
556     function noLimit() external onlyOwner{
557         _maxTxAmount = _tTotal;
558         _maxWalletSize = _tTotal;
559     }
560  
561     //Set max buy amount 
562     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
563         _maxTxAmount = maxTxAmount;
564     }
565 
566     //Set max wallet amount 
567     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
568         _maxWalletSize = maxWalletSize;
569     }
570 
571 }