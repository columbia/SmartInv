1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-09
3 */
4 
5 /**
6 https://t.me/StonksERC
7 https://twitter.com/StonksERC20
8 */
9 
10 // SPDX-License-Identifier: MIT
11    pragma solidity ^0.8.15;
12  
13    abstract contract Context {
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
161 contract Stonks is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "Stonks"; 
166     string private constant _symbol = "Stonks"; 
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174 
175     uint256 private constant _tTotal = 100000000 * 10**9; 
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178  
179     //Buy Fee
180     uint256 private _feeOnBuy = 0;  
181     uint256 private _taxOnBuy = 20;  
182  
183     //Sell Fee
184     uint256 private _feeOnSell = 0; 
185     uint256 private _taxOnSell = 20;  
186 
187     uint256 public totalFees;
188  
189     //Original Fee
190     uint256 private _redisFee = _feeOnSell;
191     uint256 private _taxFee = _taxOnSell;
192  
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195  
196     mapping(address => uint256) private cooldown;
197  
198     address payable private _developmentWalletAddress = payable(0x2ebB2ed012f0a2c4A2d6e23187822Ab0bfa8C7cc);
199     address payable private _marketingWalletAddress = payable(0x2ebB2ed012f0a2c4A2d6e23187822Ab0bfa8C7cc);
200  
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203  
204     bool private tradingOpen = false;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207  
208     uint256 public _maxTxAmount = 2000000 * 10**9;
209     uint256 public _maxWalletSize = 3000000 * 10**9;
210     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
211  
212     event MaxTxAmountUpdated(uint256 _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218  
219     constructor() {
220  
221         _rOwned[_msgSender()] = _rTotal;
222  
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227  
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_developmentWalletAddress] = true;
231         _isExcludedFromFee[_marketingWalletAddress] = true;
232  
233  
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236  
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240  
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244  
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248  
249     function totalSupply() public pure override returns (uint256) {
250         return _tTotal;
251     }
252  
253     function balanceOf(address account) public view override returns (uint256) {
254         return tokenFromReflection(_rOwned[account]);
255     }
256  
257     function transfer(address recipient, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265  
266     function allowance(address owner, address spender)
267         public
268         view
269         override
270         returns (uint256)
271     {
272         return _allowances[owner][spender];
273     }
274  
275     function approve(address spender, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283  
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(
291             sender,
292             _msgSender(),
293             _allowances[sender][_msgSender()].sub(
294                 amount,
295                 "ERC20: transfer amount exceeds allowance"
296             )
297         );
298         return true;
299     }
300  
301     function tokenFromReflection(uint256 rAmount)
302         private
303         view
304         returns (uint256)
305     {
306         require(
307             rAmount <= _rTotal,
308             "Amount must be less than total reflections"
309         );
310         uint256 currentRate = _getRate();
311         return rAmount.div(currentRate);
312     }
313  
314     function removeAllFee() private {
315         if (_redisFee == 0 && _taxFee == 0) return;
316  
317         _previousredisFee = _redisFee;
318         _previoustaxFee = _taxFee;
319  
320         _redisFee = 0;
321         _taxFee = 0;
322     }
323  
324     function restoreAllFee() private {
325         _redisFee = _previousredisFee;
326         _taxFee = _previoustaxFee;
327     }
328  
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339  
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) private {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348  
349         if (from != owner() && to != owner()) {
350  
351             //Trade start check
352             if (!tradingOpen) {
353                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
354             }
355  
356             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
357  
358             if(to != uniswapV2Pair) {
359                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
360             }
361  
362             uint256 contractTokenBalance = balanceOf(address(this));
363             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
364  
365             if(contractTokenBalance >= _maxTxAmount)
366             {
367                 contractTokenBalance = _maxTxAmount;
368             }
369  
370             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
371                 swapTokensForEth(contractTokenBalance);
372                 uint256 contractETHBalance = address(this).balance;
373                 if (contractETHBalance > 0) {
374                     sendETHToFee(address(this).balance);
375                 }
376             }
377         }
378  
379         bool takeFee = true;
380  
381         //Transfer Tokens
382         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
383             takeFee = false;
384         } else {
385  
386             //Set Fee for Buys
387             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
388                 _redisFee = _feeOnBuy;
389                 _taxFee = _taxOnBuy;
390             }
391  
392             //Set Fee for Sells
393             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
394                 _redisFee = _feeOnSell;
395                 _taxFee = _taxOnSell;
396             }
397  
398         }
399  
400         _tokenTransfer(from, to, amount, takeFee);
401     }
402  
403     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
404         address[] memory path = new address[](2);
405         path[0] = address(this);
406         path[1] = uniswapV2Router.WETH();
407         _approve(address(this), address(uniswapV2Router), tokenAmount);
408         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
409             tokenAmount,
410             0,
411             path,
412             address(this),
413             block.timestamp
414         );
415     }
416  
417     function sendETHToFee(uint256 amount) private {
418         _marketingWalletAddress.transfer(amount);
419     }
420  
421     function setTrading(bool _tradingOpen) public onlyOwner {
422         tradingOpen = _tradingOpen;
423     }
424  
425     function _tokenTransfer(
426         address sender,
427         address recipient,
428         uint256 amount,
429         bool takeFee
430     ) private {
431         if (!takeFee) removeAllFee();
432         _transferStandard(sender, recipient, amount);
433         if (!takeFee) restoreAllFee();
434     }
435  
436     function _transferStandard(
437         address sender,
438         address recipient,
439         uint256 tAmount
440     ) private {
441         (
442             uint256 rAmount,
443             uint256 rTransferAmount,
444             uint256 rFee,
445             uint256 tTransferAmount,
446             uint256 tFee,
447             uint256 tTeam
448         ) = _getValues(tAmount);
449         _rOwned[sender] = _rOwned[sender].sub(rAmount);
450         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
451         _takeTeam(tTeam);
452         _reflectFee(rFee, tFee);
453         emit Transfer(sender, recipient, tTransferAmount);
454     }
455  
456     function _takeTeam(uint256 tTeam) private {
457         uint256 currentRate = _getRate();
458         uint256 rTeam = tTeam.mul(currentRate);
459         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
460     }
461  
462     function _reflectFee(uint256 rFee, uint256 tFee) private {
463         _rTotal = _rTotal.sub(rFee);
464         _tFeeTotal = _tFeeTotal.add(tFee);
465     }
466  
467     receive() external payable {}
468  
469     function _getValues(uint256 tAmount)
470         private
471         view
472         returns (
473             uint256,
474             uint256,
475             uint256,
476             uint256,
477             uint256,
478             uint256
479         )
480     {
481         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
482             _getTValues(tAmount, _redisFee, _taxFee);
483         uint256 currentRate = _getRate();
484         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
485             _getRValues(tAmount, tFee, tTeam, currentRate);
486  
487         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
488     }
489  
490     function _getTValues(
491         uint256 tAmount,
492         uint256 redisFee,
493         uint256 taxFee
494     )
495         private
496         pure
497         returns (
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         uint256 tFee = tAmount.mul(redisFee).div(100);
504         uint256 tTeam = tAmount.mul(taxFee).div(100);
505         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
506  
507         return (tTransferAmount, tFee, tTeam);
508     }
509  
510     function _getRValues(
511         uint256 tAmount,
512         uint256 tFee,
513         uint256 tTeam,
514         uint256 currentRate
515     )
516         private
517         pure
518         returns (
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         uint256 rAmount = tAmount.mul(currentRate);
525         uint256 rFee = tFee.mul(currentRate);
526         uint256 rTeam = tTeam.mul(currentRate);
527         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
528  
529         return (rAmount, rTransferAmount, rFee);
530     }
531  
532     function _getRate() private view returns (uint256) {
533         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
534  
535         return rSupply.div(tSupply);
536     }
537  
538     function _getCurrentSupply() private view returns (uint256, uint256) {
539         uint256 rSupply = _rTotal;
540         uint256 tSupply = _tTotal;
541         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
542  
543         return (rSupply, tSupply);
544     }
545  
546     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
547         _feeOnBuy = redisFeeOnBuy;
548         _feeOnSell = redisFeeOnSell;
549         _taxOnBuy = taxFeeOnBuy;
550         _taxOnSell = taxFeeOnSell;
551         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
552         require(totalFees <= 100, "");
553     }
554  
555     //Set minimum tokens required to swap.
556     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
557         _swapTokensAtAmount = swapTokensAtAmount;
558     }
559  
560     //Set minimum tokens required to swap.
561     function toggleSwap(bool _swapEnabled) public onlyOwner {
562         swapEnabled = _swapEnabled;
563     }
564     
565     function noLimit() external onlyOwner{
566         _maxTxAmount = _tTotal;
567         _maxWalletSize = _tTotal;
568     }
569  
570     //Set max buy amount 
571     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
572         _maxTxAmount = maxTxAmount;
573     }
574 
575     //Set max wallet amount 
576     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
577         _maxWalletSize = maxWalletSize;
578     }
579 
580 }