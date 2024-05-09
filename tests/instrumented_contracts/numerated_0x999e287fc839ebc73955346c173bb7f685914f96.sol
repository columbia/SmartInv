1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-09
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-04-07
7 */
8 
9 /*
10 
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15    pragma solidity ^0.8.15;
16  
17    abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22  
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25  
26     function balanceOf(address account) external view returns (uint256);
27  
28     function transfer(address recipient, uint256 amount) external returns (bool);
29  
30     function allowance(address owner, address spender) external view returns (uint256);
31  
32     function approve(address spender, uint256 amount) external returns (bool);
33  
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39  
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47  
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55  
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61  
62     function owner() public view returns (address) {
63         return _owner;
64     }
65  
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70  
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75  
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81  
82 }
83  
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90  
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94  
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104  
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113  
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117  
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128  
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134  
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143  
144     function factory() external pure returns (address);
145  
146     function WETH() external pure returns (address);
147  
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164  
165 contract Titter is Context, IERC20, Ownable {
166  
167     using SafeMath for uint256;
168  
169     string private constant _name = "Titter"; 
170     string private constant _symbol = "Titter"; 
171     uint8 private constant _decimals = 9;
172  
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178 
179     uint256 private constant _tTotal = 100000000 * 10**9; 
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182  
183     //Buy Fee
184     uint256 private _feeOnBuy = 0;  
185     uint256 private _taxOnBuy = 20;  
186  
187     //Sell Fee
188     uint256 private _feeOnSell = 0; 
189     uint256 private _taxOnSell = 60;  
190 
191     uint256 public totalFees;
192  
193     //Original Fee
194     uint256 private _redisFee = _feeOnSell;
195     uint256 private _taxFee = _taxOnSell;
196  
197     uint256 private _previousredisFee = _redisFee;
198     uint256 private _previoustaxFee = _taxFee;
199  
200     mapping(address => uint256) private cooldown;
201  
202     address payable private _developmentWalletAddress = payable(0x2ebB2ed012f0a2c4A2d6e23187822Ab0bfa8C7cc);
203     address payable private _marketingWalletAddress = payable(0x2ebB2ed012f0a2c4A2d6e23187822Ab0bfa8C7cc);
204  
205     IUniswapV2Router02 public uniswapV2Router;
206     address public uniswapV2Pair;
207  
208     bool private tradingOpen = false;
209     bool private inSwap = false;
210     bool private swapEnabled = true;
211  
212     uint256 public _maxTxAmount = 2000000 * 10**9;
213     uint256 public _maxWalletSize = 3000000 * 10**9;
214     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
215  
216     event MaxTxAmountUpdated(uint256 _maxTxAmount);
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222  
223     constructor() {
224  
225         _rOwned[_msgSender()] = _rTotal;
226  
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231  
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[_developmentWalletAddress] = true;
235         _isExcludedFromFee[_marketingWalletAddress] = true;
236  
237  
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240  
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244  
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248  
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252  
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256  
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260  
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269  
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278  
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287  
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304  
305     function tokenFromReflection(uint256 rAmount)
306         private
307         view
308         returns (uint256)
309     {
310         require(
311             rAmount <= _rTotal,
312             "Amount must be less than total reflections"
313         );
314         uint256 currentRate = _getRate();
315         return rAmount.div(currentRate);
316     }
317  
318     function removeAllFee() private {
319         if (_redisFee == 0 && _taxFee == 0) return;
320  
321         _previousredisFee = _redisFee;
322         _previoustaxFee = _taxFee;
323  
324         _redisFee = 0;
325         _taxFee = 0;
326     }
327  
328     function restoreAllFee() private {
329         _redisFee = _previousredisFee;
330         _taxFee = _previoustaxFee;
331     }
332  
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343  
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) private {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351         require(amount > 0, "Transfer amount must be greater than zero");
352  
353         if (from != owner() && to != owner()) {
354  
355             //Trade start check
356             if (!tradingOpen) {
357                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
358             }
359  
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361  
362             if(to != uniswapV2Pair) {
363                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
364             }
365  
366             uint256 contractTokenBalance = balanceOf(address(this));
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368  
369             if(contractTokenBalance >= _maxTxAmount)
370             {
371                 contractTokenBalance = _maxTxAmount;
372             }
373  
374             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
375                 swapTokensForEth(contractTokenBalance);
376                 uint256 contractETHBalance = address(this).balance;
377                 if (contractETHBalance > 0) {
378                     sendETHToFee(address(this).balance);
379                 }
380             }
381         }
382  
383         bool takeFee = true;
384  
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389  
390             //Set Fee for Buys
391             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _redisFee = _feeOnBuy;
393                 _taxFee = _taxOnBuy;
394             }
395  
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _redisFee = _feeOnSell;
399                 _taxFee = _taxOnSell;
400             }
401  
402         }
403  
404         _tokenTransfer(from, to, amount, takeFee);
405     }
406  
407     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = uniswapV2Router.WETH();
411         _approve(address(this), address(uniswapV2Router), tokenAmount);
412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             tokenAmount,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419     }
420  
421     function sendETHToFee(uint256 amount) private {
422         _marketingWalletAddress.transfer(amount);
423     }
424  
425     function setTrading(bool _tradingOpen) public onlyOwner {
426         tradingOpen = _tradingOpen;
427     }
428  
429     function _tokenTransfer(
430         address sender,
431         address recipient,
432         uint256 amount,
433         bool takeFee
434     ) private {
435         if (!takeFee) removeAllFee();
436         _transferStandard(sender, recipient, amount);
437         if (!takeFee) restoreAllFee();
438     }
439  
440     function _transferStandard(
441         address sender,
442         address recipient,
443         uint256 tAmount
444     ) private {
445         (
446             uint256 rAmount,
447             uint256 rTransferAmount,
448             uint256 rFee,
449             uint256 tTransferAmount,
450             uint256 tFee,
451             uint256 tTeam
452         ) = _getValues(tAmount);
453         _rOwned[sender] = _rOwned[sender].sub(rAmount);
454         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
455         _takeTeam(tTeam);
456         _reflectFee(rFee, tFee);
457         emit Transfer(sender, recipient, tTransferAmount);
458     }
459  
460     function _takeTeam(uint256 tTeam) private {
461         uint256 currentRate = _getRate();
462         uint256 rTeam = tTeam.mul(currentRate);
463         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
464     }
465  
466     function _reflectFee(uint256 rFee, uint256 tFee) private {
467         _rTotal = _rTotal.sub(rFee);
468         _tFeeTotal = _tFeeTotal.add(tFee);
469     }
470  
471     receive() external payable {}
472  
473     function _getValues(uint256 tAmount)
474         private
475         view
476         returns (
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256
483         )
484     {
485         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
486             _getTValues(tAmount, _redisFee, _taxFee);
487         uint256 currentRate = _getRate();
488         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
489             _getRValues(tAmount, tFee, tTeam, currentRate);
490  
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
510  
511         return (tTransferAmount, tFee, tTeam);
512     }
513  
514     function _getRValues(
515         uint256 tAmount,
516         uint256 tFee,
517         uint256 tTeam,
518         uint256 currentRate
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 rAmount = tAmount.mul(currentRate);
529         uint256 rFee = tFee.mul(currentRate);
530         uint256 rTeam = tTeam.mul(currentRate);
531         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
532  
533         return (rAmount, rTransferAmount, rFee);
534     }
535  
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538  
539         return rSupply.div(tSupply);
540     }
541  
542     function _getCurrentSupply() private view returns (uint256, uint256) {
543         uint256 rSupply = _rTotal;
544         uint256 tSupply = _tTotal;
545         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
546  
547         return (rSupply, tSupply);
548     }
549  
550     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
551         _feeOnBuy = redisFeeOnBuy;
552         _feeOnSell = redisFeeOnSell;
553         _taxOnBuy = taxFeeOnBuy;
554         _taxOnSell = taxFeeOnSell;
555         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
556         require(totalFees <= 100, "");
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
569     function noLimit() external onlyOwner{
570         _maxTxAmount = _tTotal;
571         _maxWalletSize = _tTotal;
572     }
573  
574     //Set max buy amount 
575     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
576         _maxTxAmount = maxTxAmount;
577     }
578 
579     //Set max wallet amount 
580     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
581         _maxWalletSize = maxWalletSize;
582     }
583 
584 }