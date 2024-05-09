1 /**
2                                                                                                 
3     ____  ____  ____  ____  __  ______________   ___    ____
4    / __ \/ __ \/ __ \/ __ \/ / / / ____/_  __/  /   |  /  _/
5   / /_/ / /_/ / / / / /_/ / /_/ / __/   / /    / /| |  / /  
6  / ____/ _, _/ /_/ / ____/ __  / /___  / /    / ___ |_/ /   
7 /_/   /_/ |_|\____/_/   /_/ /_/_____/ /_/    /_/  |_/___/  
8 
9 TG : https://t.me/ProphetAIErc20                                                                                                        
10 */
11 
12 //SPDX-License-Identifier: UNLICENSED
13 pragma solidity ^0.8.12;
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
47     address private _owner;
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
163 contract ProphetAI is Context, IERC20, Ownable {
164  
165     using SafeMath for uint256;
166  
167     string private constant _name = "Prophet AI"; 
168     string private constant _symbol = "PAI"; 
169     uint8 private constant _decimals = 9;
170  
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176 
177     uint256 private constant _tTotal = 1000000000 * 10**9; 
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180  
181     //Buy Fee
182     uint256 private _feeOnBuy = 0;  
183     uint256 private _taxOnBuy = 5;   
184  
185     //Sell Fee
186     uint256 private _feeOnSell = 0; 
187     uint256 private _taxOnSell = 5;  
188 
189     uint256 public totalFees;
190  
191     //Original Fee
192     uint256 private _redisFee = _feeOnSell;
193     uint256 private _taxFee = _taxOnSell;
194  
195     uint256 private _previousredisFee = _redisFee;
196     uint256 private _previoustaxFee = _taxFee;
197  
198     mapping(address => uint256) private cooldown;
199  
200     address payable private _developmentWalletAddress = payable(0x8C059191dE1B9d4717d1deFFde218B3881c5C73a);
201     address payable private _marketingWalletAddress = payable(0x8C059191dE1B9d4717d1deFFde218B3881c5C73a);
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen = true;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209  
210     uint256 public _maxTxAmount = 20000000 * 10**9;
211     uint256 public _maxWalletSize = 20000000 * 10**9;
212     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
213  
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220  
221     constructor() {
222  
223         _rOwned[_msgSender()] = _rTotal;
224  
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229  
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_developmentWalletAddress] = true;
233         _isExcludedFromFee[_marketingWalletAddress] = true;
234  
235  
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238  
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242  
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246  
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250  
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254  
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258  
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276  
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302  
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315  
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318  
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321  
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325  
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330  
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341  
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350  
351         if (from != owner() && to != owner()) {
352  
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357  
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359  
360             if(to != uniswapV2Pair) {
361                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
362             }
363  
364             uint256 contractTokenBalance = balanceOf(address(this));
365             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
366  
367             if(contractTokenBalance >= _maxTxAmount)
368             {
369                 contractTokenBalance = _maxTxAmount;
370             }
371  
372             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
373                 swapTokensForEth(contractTokenBalance);
374                 uint256 contractETHBalance = address(this).balance;
375                 if (contractETHBalance > 0) {
376                     sendETHToFee(address(this).balance);
377                 }
378             }
379         }
380  
381         bool takeFee = true;
382  
383         //Transfer Tokens
384         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
385             takeFee = false;
386         } else {
387  
388             //Set Fee for Buys
389             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
390                 _redisFee = _feeOnBuy;
391                 _taxFee = _taxOnBuy;
392             }
393  
394             //Set Fee for Sells
395             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
396                 _redisFee = _feeOnSell;
397                 _taxFee = _taxOnSell;
398             }
399  
400         }
401  
402         _tokenTransfer(from, to, amount, takeFee);
403     }
404  
405     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = uniswapV2Router.WETH();
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
411             tokenAmount,
412             0,
413             path,
414             address(this),
415             block.timestamp
416         );
417     }
418  
419     function sendETHToFee(uint256 amount) private {
420         _marketingWalletAddress.transfer(amount);
421     }
422  
423     function setTrading(bool _tradingOpen) public onlyOwner {
424         tradingOpen = _tradingOpen;
425     }
426  
427     function _tokenTransfer(
428         address sender,
429         address recipient,
430         uint256 amount,
431         bool takeFee
432     ) private {
433         if (!takeFee) removeAllFee();
434         _transferStandard(sender, recipient, amount);
435         if (!takeFee) restoreAllFee();
436     }
437  
438     function _transferStandard(
439         address sender,
440         address recipient,
441         uint256 tAmount
442     ) private {
443         (
444             uint256 rAmount,
445             uint256 rTransferAmount,
446             uint256 rFee,
447             uint256 tTransferAmount,
448             uint256 tFee,
449             uint256 tTeam
450         ) = _getValues(tAmount);
451         _rOwned[sender] = _rOwned[sender].sub(rAmount);
452         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
453         _takeTeam(tTeam);
454         _reflectFee(rFee, tFee);
455         emit Transfer(sender, recipient, tTransferAmount);
456     }
457  
458     function _takeTeam(uint256 tTeam) private {
459         uint256 currentRate = _getRate();
460         uint256 rTeam = tTeam.mul(currentRate);
461         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
462     }
463  
464     function _reflectFee(uint256 rFee, uint256 tFee) private {
465         _rTotal = _rTotal.sub(rFee);
466         _tFeeTotal = _tFeeTotal.add(tFee);
467     }
468  
469     receive() external payable {}
470  
471     function _getValues(uint256 tAmount)
472         private
473         view
474         returns (
475             uint256,
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256
481         )
482     {
483         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
484             _getTValues(tAmount, _redisFee, _taxFee);
485         uint256 currentRate = _getRate();
486         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
487             _getRValues(tAmount, tFee, tTeam, currentRate);
488  
489         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
490     }
491  
492     function _getTValues(
493         uint256 tAmount,
494         uint256 redisFee,
495         uint256 taxFee
496     )
497         private
498         pure
499         returns (
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         uint256 tFee = tAmount.mul(redisFee).div(100);
506         uint256 tTeam = tAmount.mul(taxFee).div(100);
507         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
508  
509         return (tTransferAmount, tFee, tTeam);
510     }
511  
512     function _getRValues(
513         uint256 tAmount,
514         uint256 tFee,
515         uint256 tTeam,
516         uint256 currentRate
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 rAmount = tAmount.mul(currentRate);
527         uint256 rFee = tFee.mul(currentRate);
528         uint256 rTeam = tTeam.mul(currentRate);
529         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
530  
531         return (rAmount, rTransferAmount, rFee);
532     }
533  
534     function _getRate() private view returns (uint256) {
535         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
536  
537         return rSupply.div(tSupply);
538     }
539  
540     function _getCurrentSupply() private view returns (uint256, uint256) {
541         uint256 rSupply = _rTotal;
542         uint256 tSupply = _tTotal;
543         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
544  
545         return (rSupply, tSupply);
546     }
547  
548     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
549         _feeOnBuy = redisFeeOnBuy;
550         _feeOnSell = redisFeeOnSell;
551         _taxOnBuy = taxFeeOnBuy;
552         _taxOnSell = taxFeeOnSell;
553         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
554         require(totalFees <= 10, "Must keep fees at 10% or less");
555     }
556  
557     //Set minimum tokens required to swap.
558     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
559         _swapTokensAtAmount = swapTokensAtAmount;
560     }
561  
562     //Set minimum tokens required to swap.
563     function toggleSwap(bool _swapEnabled) public onlyOwner {
564         swapEnabled = _swapEnabled;
565     }
566     
567     function noLimit() external onlyOwner{
568         _maxTxAmount = _tTotal;
569         _maxWalletSize = _tTotal;
570     }
571  
572     //Set max buy amount 
573     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
574         _maxTxAmount = maxTxAmount;
575     }
576 
577     //Set max wallet amount 
578     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
579         _maxWalletSize = maxWalletSize;
580     }
581 
582 }