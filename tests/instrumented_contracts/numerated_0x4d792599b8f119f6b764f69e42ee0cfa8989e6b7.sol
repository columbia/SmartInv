1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-09
3 */
4 
5 /**
6 https://twitter.com/WatcherGuru/status/1646207148244844560?cxt=HHwWoIC-nb2rwNgtAAAA
7 */
8 
9 // SPDX-License-Identifier: MIT
10    pragma solidity ^0.8.15;
11  
12    abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17  
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20  
21     function balanceOf(address account) external view returns (uint256);
22  
23     function transfer(address recipient, uint256 amount) external returns (bool);
24  
25     function allowance(address owner, address spender) external view returns (uint256);
26  
27     function approve(address spender, uint256 amount) external returns (bool);
28  
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34  
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42  
43 contract Ownable is Context {
44     address private _owner;
45     address private _previousOwner;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50  
51     constructor() {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56  
57     function owner() public view returns (address) {
58         return _owner;
59     }
60  
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65  
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70  
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76  
77 }
78  
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85  
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89  
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99  
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108  
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112  
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123  
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129  
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138  
139     function factory() external pure returns (address);
140  
141     function WETH() external pure returns (address);
142  
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159  
160 contract FTX is Context, IERC20, Ownable {
161  
162     using SafeMath for uint256;
163  
164     string private constant _name = "FTX 2.0"; 
165     string private constant _symbol = "FTX2.0"; 
166     uint8 private constant _decimals = 9;
167  
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173 
174     uint256 private constant _tTotal = 100000000 * 10**9; 
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177  
178     //Buy Fee
179     uint256 private _feeOnBuy = 0;  
180     uint256 private _taxOnBuy = 20;  
181  
182     //Sell Fee
183     uint256 private _feeOnSell = 20; 
184     uint256 private _taxOnSell = 50;  
185 
186     uint256 public totalFees;
187  
188     //Original Fee
189     uint256 private _redisFee = _feeOnSell;
190     uint256 private _taxFee = _taxOnSell;
191  
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194  
195     mapping(address => uint256) private cooldown;
196  
197     address payable private _developmentWalletAddress = payable(0x2018Ac66555591Cb0C278aE0919215721eB3Bf48);
198     address payable private _marketingWalletAddress = payable(0x2018Ac66555591Cb0C278aE0919215721eB3Bf48);
199  
200     IUniswapV2Router02 public uniswapV2Router;
201     address public uniswapV2Pair;
202  
203     bool private tradingOpen = false;
204     bool private inSwap = false;
205     bool private swapEnabled = true;
206  
207     uint256 public _maxTxAmount = 2000000 * 10**9;
208     uint256 public _maxWalletSize = 3000000 * 10**9;
209     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
210  
211     event MaxTxAmountUpdated(uint256 _maxTxAmount);
212     modifier lockTheSwap {
213         inSwap = true;
214         _;
215         inSwap = false;
216     }
217  
218     constructor() {
219  
220         _rOwned[_msgSender()] = _rTotal;
221  
222         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
223         uniswapV2Router = _uniswapV2Router;
224         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
225             .createPair(address(this), _uniswapV2Router.WETH());
226  
227         _isExcludedFromFee[owner()] = true;
228         _isExcludedFromFee[address(this)] = true;
229         _isExcludedFromFee[_developmentWalletAddress] = true;
230         _isExcludedFromFee[_marketingWalletAddress] = true;
231  
232  
233         emit Transfer(address(0), _msgSender(), _tTotal);
234     }
235  
236     function name() public pure returns (string memory) {
237         return _name;
238     }
239  
240     function symbol() public pure returns (string memory) {
241         return _symbol;
242     }
243  
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247  
248     function totalSupply() public pure override returns (uint256) {
249         return _tTotal;
250     }
251  
252     function balanceOf(address account) public view override returns (uint256) {
253         return tokenFromReflection(_rOwned[account]);
254     }
255  
256     function transfer(address recipient, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264  
265     function allowance(address owner, address spender)
266         public
267         view
268         override
269         returns (uint256)
270     {
271         return _allowances[owner][spender];
272     }
273  
274     function approve(address spender, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282  
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public override returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(
290             sender,
291             _msgSender(),
292             _allowances[sender][_msgSender()].sub(
293                 amount,
294                 "ERC20: transfer amount exceeds allowance"
295             )
296         );
297         return true;
298     }
299  
300     function tokenFromReflection(uint256 rAmount)
301         private
302         view
303         returns (uint256)
304     {
305         require(
306             rAmount <= _rTotal,
307             "Amount must be less than total reflections"
308         );
309         uint256 currentRate = _getRate();
310         return rAmount.div(currentRate);
311     }
312  
313     function removeAllFee() private {
314         if (_redisFee == 0 && _taxFee == 0) return;
315  
316         _previousredisFee = _redisFee;
317         _previoustaxFee = _taxFee;
318  
319         _redisFee = 0;
320         _taxFee = 0;
321     }
322  
323     function restoreAllFee() private {
324         _redisFee = _previousredisFee;
325         _taxFee = _previoustaxFee;
326     }
327  
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338  
339     function _transfer(
340         address from,
341         address to,
342         uint256 amount
343     ) private {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346         require(amount > 0, "Transfer amount must be greater than zero");
347  
348         if (from != owner() && to != owner()) {
349  
350             //Trade start check
351             if (!tradingOpen) {
352                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
353             }
354  
355             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
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
387                 _redisFee = _feeOnBuy;
388                 _taxFee = _taxOnBuy;
389             }
390  
391             //Set Fee for Sells
392             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
393                 _redisFee = _feeOnSell;
394                 _taxFee = _taxOnSell;
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
417         _marketingWalletAddress.transfer(amount);
418     }
419  
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422     }
423  
424     function _tokenTransfer(
425         address sender,
426         address recipient,
427         uint256 amount,
428         bool takeFee
429     ) private {
430         if (!takeFee) removeAllFee();
431         _transferStandard(sender, recipient, amount);
432         if (!takeFee) restoreAllFee();
433     }
434  
435     function _transferStandard(
436         address sender,
437         address recipient,
438         uint256 tAmount
439     ) private {
440         (
441             uint256 rAmount,
442             uint256 rTransferAmount,
443             uint256 rFee,
444             uint256 tTransferAmount,
445             uint256 tFee,
446             uint256 tTeam
447         ) = _getValues(tAmount);
448         _rOwned[sender] = _rOwned[sender].sub(rAmount);
449         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
450         _takeTeam(tTeam);
451         _reflectFee(rFee, tFee);
452         emit Transfer(sender, recipient, tTransferAmount);
453     }
454  
455     function _takeTeam(uint256 tTeam) private {
456         uint256 currentRate = _getRate();
457         uint256 rTeam = tTeam.mul(currentRate);
458         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
459     }
460  
461     function _reflectFee(uint256 rFee, uint256 tFee) private {
462         _rTotal = _rTotal.sub(rFee);
463         _tFeeTotal = _tFeeTotal.add(tFee);
464     }
465  
466     receive() external payable {}
467  
468     function _getValues(uint256 tAmount)
469         private
470         view
471         returns (
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256,
477             uint256
478         )
479     {
480         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
481             _getTValues(tAmount, _redisFee, _taxFee);
482         uint256 currentRate = _getRate();
483         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
484             _getRValues(tAmount, tFee, tTeam, currentRate);
485  
486         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
487     }
488  
489     function _getTValues(
490         uint256 tAmount,
491         uint256 redisFee,
492         uint256 taxFee
493     )
494         private
495         pure
496         returns (
497             uint256,
498             uint256,
499             uint256
500         )
501     {
502         uint256 tFee = tAmount.mul(redisFee).div(100);
503         uint256 tTeam = tAmount.mul(taxFee).div(100);
504         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
505  
506         return (tTransferAmount, tFee, tTeam);
507     }
508  
509     function _getRValues(
510         uint256 tAmount,
511         uint256 tFee,
512         uint256 tTeam,
513         uint256 currentRate
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 rAmount = tAmount.mul(currentRate);
524         uint256 rFee = tFee.mul(currentRate);
525         uint256 rTeam = tTeam.mul(currentRate);
526         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
527  
528         return (rAmount, rTransferAmount, rFee);
529     }
530  
531     function _getRate() private view returns (uint256) {
532         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
533  
534         return rSupply.div(tSupply);
535     }
536  
537     function _getCurrentSupply() private view returns (uint256, uint256) {
538         uint256 rSupply = _rTotal;
539         uint256 tSupply = _tTotal;
540         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
541  
542         return (rSupply, tSupply);
543     }
544  
545     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
546         _feeOnBuy = redisFeeOnBuy;
547         _feeOnSell = redisFeeOnSell;
548         _taxOnBuy = taxFeeOnBuy;
549         _taxOnSell = taxFeeOnSell;
550         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
551         require(totalFees <= 100, "");
552     }
553  
554     //Set minimum tokens required to swap.
555     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
556         _swapTokensAtAmount = swapTokensAtAmount;
557     }
558  
559     //Set minimum tokens required to swap.
560     function toggleSwap(bool _swapEnabled) public onlyOwner {
561         swapEnabled = _swapEnabled;
562     }
563     
564     function noLimit() external onlyOwner{
565         _maxTxAmount = _tTotal;
566         _maxWalletSize = _tTotal;
567     }
568  
569     //Set max buy amount 
570     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
571         _maxTxAmount = maxTxAmount;
572     }
573 
574     //Set max wallet amount 
575     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
576         _maxWalletSize = maxWalletSize;
577     }
578 
579 }