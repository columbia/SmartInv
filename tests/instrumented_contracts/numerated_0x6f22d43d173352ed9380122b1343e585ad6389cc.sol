1 pragma solidity ^0.8.4;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8  
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20  
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28  
29 contract Ownable is Context {
30     address private _owner;
31     address private _previousOwner;
32     event OwnershipTransferred(
33         address indexed previousOwner,
34         address indexed newOwner
35     );
36  
37     constructor() {
38         address msgSender = _msgSender();
39         _owner = msgSender;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42 
43     function owner() public view returns (address) {
44         return _owner;
45     }
46  
47     modifier onlyOwner() {
48         require(_owner == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51  
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56  
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62  
63 }
64  
65 library SafeMath {
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69         return c;
70     }
71  
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75  
76     function sub(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83         return c;
84     }
85  
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92         return c;
93     }
94  
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98  
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 }
109  
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB)
112         external
113         returns (address pair);
114 }
115  
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint256 amountIn,
119         uint256 amountOutMin,
120         address[] calldata path,
121         address to,
122         uint256 deadline
123     ) external;
124  
125     function factory() external pure returns (address);
126  
127     function WETH() external pure returns (address);
128  
129     function addLiquidityETH(
130         address token,
131         uint256 amountTokenDesired,
132         uint256 amountTokenMin,
133         uint256 amountETHMin,
134         address to,
135         uint256 deadline
136     )
137         external
138         payable
139         returns (
140             uint256 amountToken,
141             uint256 amountETH,
142             uint256 liquidity
143         );
144 }
145  
146 contract TheWOLFZ is Context, IERC20, Ownable {
147  
148     using SafeMath for uint256;
149  
150     string private constant _name = "TheWOLFZ"; 
151     string private constant _symbol = "WOLFZ"; 
152     uint8 private constant _decimals = 9;
153  
154     mapping(address => uint256) private _rOwned;
155     mapping(address => uint256) private _tOwned;
156     mapping(address => mapping(address => uint256)) private _allowances;
157     mapping(address => bool) private _isExcludedFromFee;
158     uint256 private constant MAX = ~uint256(0);
159 
160     uint256 private constant _tTotal = 1000000000 * 10**9; 
161     uint256 private _rTotal = (MAX - (MAX % _tTotal));
162     uint256 private _tFeeTotal;
163  
164     //Buy Fee
165     uint256 private _redisFeeOnBuy = 0;  
166     uint256 private _taxFeeOnBuy = 5;   
167  
168     //Sell Fee
169     uint256 private _redisFeeOnSell = 0; 
170     uint256 private _taxFeeOnSell = 5;  
171 
172     uint256 public totalFees;
173  
174     //Original Fee
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177  
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180  
181     mapping(address => uint256) private cooldown;
182  
183     address payable private _developmentAddress = payable(0xcB800570223b1549EE4581063D253061665ca584);
184     address payable private _marketingAddress = payable(0xdEd5007f673973fcF5822C5a5f1cEebd5eb4AD11);
185  
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188  
189     bool private tradingOpen;
190     bool private inSwap = false;
191     bool private swapEnabled = true;
192  
193     uint256 public _maxTxAmount = 30000000 * 10**9;
194     uint256 public _maxWalletSize = 30000000 * 10**9; 
195     uint256 public _swapTokensAtAmount = 30000000 * 10**9; 
196  
197     event MaxTxAmountUpdated(uint256 _maxTxAmount);
198     modifier lockTheSwap {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203  
204     constructor() {
205  
206         _rOwned[_msgSender()] = _rTotal;
207  
208         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
209         uniswapV2Router = _uniswapV2Router;
210         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
211             .createPair(address(this), _uniswapV2Router.WETH());
212  
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_developmentAddress] = true;
216         _isExcludedFromFee[_marketingAddress] = true;
217  
218  
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221  
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225  
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229  
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233  
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237  
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241  
242     function transfer(address recipient, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250  
251     function allowance(address owner, address spender)
252         public
253         view
254         override
255         returns (uint256)
256     {
257         return _allowances[owner][spender];
258     }
259  
260     function approve(address spender, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268  
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(
276             sender,
277             _msgSender(),
278             _allowances[sender][_msgSender()].sub(
279                 amount,
280                 "ERC20: transfer amount exceeds allowance"
281             )
282         );
283         return true;
284     }
285  
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298  
299     function removeAllFee() private {
300         if (_redisFee == 0 && _taxFee == 0) return;
301  
302         _previousredisFee = _redisFee;
303         _previoustaxFee = _taxFee;
304  
305         _redisFee = 0;
306         _taxFee = 0;
307     }
308  
309     function restoreAllFee() private {
310         _redisFee = _previousredisFee;
311         _taxFee = _previoustaxFee;
312     }
313  
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324  
325     function _transfer(
326         address from,
327         address to,
328         uint256 amount
329     ) private {
330         require(from != address(0), "ERC20: transfer from the zero address");
331         require(to != address(0), "ERC20: transfer to the zero address");
332         require(amount > 0, "Transfer amount must be greater than zero");
333  
334         if (from != owner() && to != owner()) {
335  
336             //Trade start check
337             if (!tradingOpen) {
338                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
339             }
340  
341             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
342  
343             if(to != uniswapV2Pair) {
344                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
345             }
346  
347             uint256 contractTokenBalance = balanceOf(address(this));
348             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
349  
350             if(contractTokenBalance >= _maxTxAmount)
351             {
352                 contractTokenBalance = _maxTxAmount;
353             }
354  
355             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
356                 swapTokensForEth(contractTokenBalance);
357                 uint256 contractETHBalance = address(this).balance;
358                 if (contractETHBalance > 0) {
359                     sendETHToFee(address(this).balance);
360                 }
361             }
362         }
363  
364         bool takeFee = true;
365  
366         //Transfer Tokens
367         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
368             takeFee = false;
369         } else {
370  
371             //Set Fee for Buys
372             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
373                 _redisFee = _redisFeeOnBuy;
374                 _taxFee = _taxFeeOnBuy;
375             }
376  
377             //Set Fee for Sells
378             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
379                 _redisFee = _redisFeeOnSell;
380                 _taxFee = _taxFeeOnSell;
381             }
382  
383         }
384  
385         _tokenTransfer(from, to, amount, takeFee);
386     }
387  
388     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
389         address[] memory path = new address[](2);
390         path[0] = address(this);
391         path[1] = uniswapV2Router.WETH();
392         _approve(address(this), address(uniswapV2Router), tokenAmount);
393         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
394             tokenAmount,
395             0,
396             path,
397             address(this),
398             block.timestamp
399         );
400     }
401  
402     function sendETHToFee(uint256 amount) private {
403         _developmentAddress.transfer(amount.div(2));
404         _marketingAddress.transfer(amount.div(2));
405     }
406  
407     function setTrading(bool _tradingOpen) public onlyOwner {
408         tradingOpen = _tradingOpen;
409     }
410  
411     function manualswap() external {
412         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
413         uint256 contractBalance = balanceOf(address(this));
414         swapTokensForEth(contractBalance);
415     }
416  
417     function manualsend() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422  
423     function _tokenTransfer(
424         address sender,
425         address recipient,
426         uint256 amount,
427         bool takeFee
428     ) private {
429         if (!takeFee) removeAllFee();
430         _transferStandard(sender, recipient, amount);
431         if (!takeFee) restoreAllFee();
432     }
433  
434     function _transferStandard(
435         address sender,
436         address recipient,
437         uint256 tAmount
438     ) private {
439         (
440             uint256 rAmount,
441             uint256 rTransferAmount,
442             uint256 rFee,
443             uint256 tTransferAmount,
444             uint256 tFee,
445             uint256 tTeam
446         ) = _getValues(tAmount);
447         _rOwned[sender] = _rOwned[sender].sub(rAmount);
448         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
449         _takeTeam(tTeam);
450         _reflectFee(rFee, tFee);
451         emit Transfer(sender, recipient, tTransferAmount);
452     }
453  
454     function _takeTeam(uint256 tTeam) private {
455         uint256 currentRate = _getRate();
456         uint256 rTeam = tTeam.mul(currentRate);
457         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
458     }
459  
460     function _reflectFee(uint256 rFee, uint256 tFee) private {
461         _rTotal = _rTotal.sub(rFee);
462         _tFeeTotal = _tFeeTotal.add(tFee);
463     }
464  
465     receive() external payable {}
466  
467     function _getValues(uint256 tAmount)
468         private
469         view
470         returns (
471             uint256,
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256
477         )
478     {
479         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
480             _getTValues(tAmount, _redisFee, _taxFee);
481         uint256 currentRate = _getRate();
482         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
483             _getRValues(tAmount, tFee, tTeam, currentRate);
484  
485         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
486     }
487  
488     function _getTValues(
489         uint256 tAmount,
490         uint256 redisFee,
491         uint256 taxFee
492     )
493         private
494         pure
495         returns (
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         uint256 tFee = tAmount.mul(redisFee).div(100);
502         uint256 tTeam = tAmount.mul(taxFee).div(100);
503         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
504  
505         return (tTransferAmount, tFee, tTeam);
506     }
507  
508     function _getRValues(
509         uint256 tAmount,
510         uint256 tFee,
511         uint256 tTeam,
512         uint256 currentRate
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 rAmount = tAmount.mul(currentRate);
523         uint256 rFee = tFee.mul(currentRate);
524         uint256 rTeam = tTeam.mul(currentRate);
525         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
526  
527         return (rAmount, rTransferAmount, rFee);
528     }
529  
530     function _getRate() private view returns (uint256) {
531         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
532  
533         return rSupply.div(tSupply);
534     }
535  
536     function _getCurrentSupply() private view returns (uint256, uint256) {
537         uint256 rSupply = _rTotal;
538         uint256 tSupply = _tTotal;
539         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
540  
541         return (rSupply, tSupply);
542     }
543  
544     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
545         _redisFeeOnBuy = redisFeeOnBuy;
546         _redisFeeOnSell = redisFeeOnSell;
547         _taxFeeOnBuy = taxFeeOnBuy;
548         _taxFeeOnSell = taxFeeOnSell;
549         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
550         require(totalFees <= 10, "Must keep fees at 10% or less");
551     }
552  
553     //Set minimum tokens required to swap.
554     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
555         _swapTokensAtAmount = swapTokensAtAmount;
556     }
557  
558     //Set minimum tokens required to swap.
559     function toggleSwap(bool _swapEnabled) public onlyOwner {
560         swapEnabled = _swapEnabled;
561     }
562  
563     //Set max buy amount 
564     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
565         _maxTxAmount = maxTxAmount;
566     }
567 
568     //Set max wallet amount 
569     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
570         _maxWalletSize = maxWalletSize;
571     }
572 
573     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
574         for(uint256 i = 0; i < accounts.length; i++) {
575             _isExcludedFromFee[accounts[i]] = excluded;
576         }
577     }
578 }