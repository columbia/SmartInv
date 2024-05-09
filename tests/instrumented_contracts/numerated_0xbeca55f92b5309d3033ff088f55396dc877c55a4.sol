1 // t.me/sodiumerc
2 // x.com/sodiumerc
3 // https://sodiumerc.com/
4 
5 //SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.12;
8 
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15  
16 
17 contract Ownable is Context {
18     address private _owner;
19     address private _previousOwner;
20     event OwnershipTransferred(
21         address indexed previousOwner,
22         address indexed newOwner
23     );
24  
25     constructor() {
26         address msgSender = _msgSender();
27         _owner = msgSender;
28         emit OwnershipTransferred(address(0), msgSender);
29     }
30  
31     function owner() public view returns (address) {
32         return _owner;
33     }
34  
35     modifier onlyOwner() {
36         require(_owner == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39  
40     function renounceOwnership() public virtual onlyOwner {
41         emit OwnershipTransferred(_owner, address(0));
42         _owner = address(0);
43     }
44  
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         emit OwnershipTransferred(_owner, newOwner);
48         _owner = newOwner;
49     }
50  
51 }
52 
53 
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57  
58     function balanceOf(address account) external view returns (uint256);
59  
60     function transfer(address recipient, uint256 amount) external returns (bool);
61  
62     function allowance(address owner, address spender) external view returns (uint256);
63  
64     function approve(address spender, uint256 amount) external returns (bool);
65  
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71  
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
78 }
79 
80 interface IUniswapV2Factory {
81     function createPair(address tokenA, address tokenB)
82         external
83         returns (address pair);
84 }
85  
86 interface IUniswapV2Router02 {
87     function swapExactTokensForETHSupportingFeeOnTransferTokens(
88         uint256 amountIn,
89         uint256 amountOutMin,
90         address[] calldata path,
91         address to,
92         uint256 deadline
93     ) external;
94  
95     function factory() external pure returns (address);
96  
97     function WETH() external pure returns (address);
98  
99     function addLiquidityETH(
100         address token,
101         uint256 amountTokenDesired,
102         uint256 amountTokenMin,
103         uint256 amountETHMin,
104         address to,
105         uint256 deadline
106     )
107         external
108         payable
109         returns (
110             uint256 amountToken,
111             uint256 amountETH,
112             uint256 liquidity
113         );
114 }
115  
116 library SafeMath {
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120         return c;
121     }
122  
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126  
127     function sub(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134         return c;
135     }
136  
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) {
139             return 0;
140         }
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143         return c;
144     }
145  
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return div(a, b, "SafeMath: division by zero");
148     }
149  
150     function div(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         return c;
158     }
159 }
160  
161 
162  
163 contract Na is Context, IERC20, Ownable {
164  
165     using SafeMath for uint256;
166  
167     string private constant _name = "Sodium";
168     string private constant _symbol = "Na";
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
183     uint256 private _taxOnBuy = 20;   
184  
185     //Sell Fee
186     uint256 private _feeOnSell = 0; 
187     uint256 private _taxOnSell = 40;  
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
200     address payable private _developmentWalletAddress = payable(0xe764CF3603740921abF7BDbcdA71d956c3e924cD);
201     address payable private _marketingWalletAddress = payable(0xe764CF3603740921abF7BDbcdA71d956c3e924cD);
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen;
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
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
420         _developmentWalletAddress.transfer(amount.div(2));
421         _marketingWalletAddress.transfer(amount.div(2));
422     }
423  
424     function setTrading(bool _tradingOpen) public onlyOwner {
425         tradingOpen = _tradingOpen;
426     }
427  
428     function manualswap() external {
429         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433  
434     function manualsend() external {
435         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439  
440     function _tokenTransfer(
441         address sender,
442         address recipient,
443         uint256 amount,
444         bool takeFee
445     ) private {
446         if (!takeFee) removeAllFee();
447         _transferStandard(sender, recipient, amount);
448         if (!takeFee) restoreAllFee();
449     }
450  
451     function _transferStandard(
452         address sender,
453         address recipient,
454         uint256 tAmount
455     ) private {
456         (
457             uint256 rAmount,
458             uint256 rTransferAmount,
459             uint256 rFee,
460             uint256 tTransferAmount,
461             uint256 tFee,
462             uint256 tTeam
463         ) = _getValues(tAmount);
464         _rOwned[sender] = _rOwned[sender].sub(rAmount);
465         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
466         _takeTeam(tTeam);
467         _reflectFee(rFee, tFee);
468         emit Transfer(sender, recipient, tTransferAmount);
469     }
470  
471     function _takeTeam(uint256 tTeam) private {
472         uint256 currentRate = _getRate();
473         uint256 rTeam = tTeam.mul(currentRate);
474         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
475     }
476  
477     function _reflectFee(uint256 rFee, uint256 tFee) private {
478         _rTotal = _rTotal.sub(rFee);
479         _tFeeTotal = _tFeeTotal.add(tFee);
480     }
481  
482     receive() external payable {}
483  
484     function _getValues(uint256 tAmount)
485         private
486         view
487         returns (
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
497             _getTValues(tAmount, _redisFee, _taxFee);
498         uint256 currentRate = _getRate();
499         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
500             _getRValues(tAmount, tFee, tTeam, currentRate);
501  
502         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
503     }
504  
505     function _getTValues(
506         uint256 tAmount,
507         uint256 redisFee,
508         uint256 taxFee
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 tFee = tAmount.mul(redisFee).div(100);
519         uint256 tTeam = tAmount.mul(taxFee).div(100);
520         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
521  
522         return (tTransferAmount, tFee, tTeam);
523     }
524  
525     function _getRValues(
526         uint256 tAmount,
527         uint256 tFee,
528         uint256 tTeam,
529         uint256 currentRate
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 rAmount = tAmount.mul(currentRate);
540         uint256 rFee = tFee.mul(currentRate);
541         uint256 rTeam = tTeam.mul(currentRate);
542         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
543  
544         return (rAmount, rTransferAmount, rFee);
545     }
546  
547     function _getRate() private view returns (uint256) {
548         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
549  
550         return rSupply.div(tSupply);
551     }
552  
553     function _getCurrentSupply() private view returns (uint256, uint256) {
554         uint256 rSupply = _rTotal;
555         uint256 tSupply = _tTotal;
556         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
557  
558         return (rSupply, tSupply);
559     }
560  
561     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
562         _feeOnBuy = redisFeeOnBuy;
563         _feeOnSell = redisFeeOnSell;
564         _taxOnBuy = taxFeeOnBuy;
565         _taxOnSell = taxFeeOnSell;
566         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
567         require(totalFees <= 100, "Must keep fees at 100% or less");
568     }
569  
570     //Set minimum tokens required to swap.
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574  
575     //Set minimum tokens required to swap.
576     function toggleSwap(bool _swapEnabled) public onlyOwner {
577         swapEnabled = _swapEnabled;
578     }
579  
580  
581     //Set max buy amount 
582     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
583         _maxTxAmount = maxTxAmount;
584     }
585 
586     //Set max wallet amount 
587     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
588         _maxWalletSize = maxWalletSize;
589     }
590 
591     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
592         for(uint256 i = 0; i < accounts.length; i++) {
593             _isExcludedFromFee[accounts[i]] = excluded;
594         }
595     }
596 }