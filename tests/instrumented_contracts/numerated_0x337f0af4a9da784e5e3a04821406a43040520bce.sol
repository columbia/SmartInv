1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.12;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10  
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13  
14     function balanceOf(address account) external view returns (uint256);
15  
16     function transfer(address recipient, uint256 amount) external returns (bool);
17  
18     function allowance(address owner, address spender) external view returns (uint256);
19  
20     function approve(address spender, uint256 amount) external returns (bool);
21  
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27  
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35  
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43  
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49  
50     function owner() public view returns (address) {
51         return _owner;
52     }
53  
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58  
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63  
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69  
70 }
71  
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78  
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82  
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92  
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101  
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105  
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116  
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122  
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131  
132     function factory() external pure returns (address);
133  
134     function WETH() external pure returns (address);
135  
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152  
153 contract DejitaruYoroi is Context, IERC20, Ownable {
154  
155     using SafeMath for uint256;
156  
157     string private constant _name = "Dejitaru Yoroi"; 
158     string private constant _symbol = "ARMOUR"; 
159     uint8 private constant _decimals = 9;
160  
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166 
167     uint256 private constant _tTotal = 1000000000 * 10**9; 
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170  
171     //Buy Fee
172     uint256 private _feeOnBuy = 0;  
173     uint256 private _taxOnBuy = 15;   
174  
175     //Sell Fee
176     uint256 private _feeOnSell = 0; 
177     uint256 private _taxOnSell = 20;  
178 
179     uint256 public totalFees;
180  
181     //Original Fee
182     uint256 private _redisFee = _feeOnSell;
183     uint256 private _taxFee = _taxOnSell;
184  
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187  
188     mapping(address => uint256) private cooldown;
189  
190     address payable private _developmentWalletAddress = payable(0xF9d0355Cf8412417e5496B44cEc770EC481D6594);
191     address payable private _marketingWalletAddress = payable(0x5e85AadA586fCAe384e24697c60878792e2748aA);
192  
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195  
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199  
200     uint256 public _maxTxAmount = 20000000 * 10**9;
201     uint256 public _maxWalletSize = 20000000 * 10**9; 
202     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
203  
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210  
211     constructor() {
212  
213         _rOwned[_msgSender()] = _rTotal;
214  
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219  
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_developmentWalletAddress] = true;
223         _isExcludedFromFee[_marketingWalletAddress] = true;
224  
225  
226         emit Transfer(address(0), _msgSender(), _tTotal);
227     }
228  
229     function name() public pure returns (string memory) {
230         return _name;
231     }
232  
233     function symbol() public pure returns (string memory) {
234         return _symbol;
235     }
236  
237     function decimals() public pure returns (uint8) {
238         return _decimals;
239     }
240  
241     function totalSupply() public pure override returns (uint256) {
242         return _tTotal;
243     }
244  
245     function balanceOf(address account) public view override returns (uint256) {
246         return tokenFromReflection(_rOwned[account]);
247     }
248  
249     function transfer(address recipient, uint256 amount)
250         public
251         override
252         returns (bool)
253     {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257  
258     function allowance(address owner, address spender)
259         public
260         view
261         override
262         returns (uint256)
263     {
264         return _allowances[owner][spender];
265     }
266  
267     function approve(address spender, uint256 amount)
268         public
269         override
270         returns (bool)
271     {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275  
276     function transferFrom(
277         address sender,
278         address recipient,
279         uint256 amount
280     ) public override returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(
283             sender,
284             _msgSender(),
285             _allowances[sender][_msgSender()].sub(
286                 amount,
287                 "ERC20: transfer amount exceeds allowance"
288             )
289         );
290         return true;
291     }
292  
293     function tokenFromReflection(uint256 rAmount)
294         private
295         view
296         returns (uint256)
297     {
298         require(
299             rAmount <= _rTotal,
300             "Amount must be less than total reflections"
301         );
302         uint256 currentRate = _getRate();
303         return rAmount.div(currentRate);
304     }
305  
306     function removeAllFee() private {
307         if (_redisFee == 0 && _taxFee == 0) return;
308  
309         _previousredisFee = _redisFee;
310         _previoustaxFee = _taxFee;
311  
312         _redisFee = 0;
313         _taxFee = 0;
314     }
315  
316     function restoreAllFee() private {
317         _redisFee = _previousredisFee;
318         _taxFee = _previoustaxFee;
319     }
320  
321     function _approve(
322         address owner,
323         address spender,
324         uint256 amount
325     ) private {
326         require(owner != address(0), "ERC20: approve from the zero address");
327         require(spender != address(0), "ERC20: approve to the zero address");
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331  
332     function _transfer(
333         address from,
334         address to,
335         uint256 amount
336     ) private {
337         require(from != address(0), "ERC20: transfer from the zero address");
338         require(to != address(0), "ERC20: transfer to the zero address");
339         require(amount > 0, "Transfer amount must be greater than zero");
340  
341         if (from != owner() && to != owner()) {
342  
343             //Trade start check
344             if (!tradingOpen) {
345                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
346             }
347  
348             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
349  
350             if(to != uniswapV2Pair) {
351                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
352             }
353  
354             uint256 contractTokenBalance = balanceOf(address(this));
355             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
356  
357             if(contractTokenBalance >= _maxTxAmount)
358             {
359                 contractTokenBalance = _maxTxAmount;
360             }
361  
362             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
363                 swapTokensForEth(contractTokenBalance);
364                 uint256 contractETHBalance = address(this).balance;
365                 if (contractETHBalance > 0) {
366                     sendETHToFee(address(this).balance);
367                 }
368             }
369         }
370  
371         bool takeFee = true;
372  
373         //Transfer Tokens
374         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
375             takeFee = false;
376         } else {
377  
378             //Set Fee for Buys
379             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
380                 _redisFee = _feeOnBuy;
381                 _taxFee = _taxOnBuy;
382             }
383  
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _redisFee = _feeOnSell;
387                 _taxFee = _taxOnSell;
388             }
389  
390         }
391  
392         _tokenTransfer(from, to, amount, takeFee);
393     }
394  
395     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
396         address[] memory path = new address[](2);
397         path[0] = address(this);
398         path[1] = uniswapV2Router.WETH();
399         _approve(address(this), address(uniswapV2Router), tokenAmount);
400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
401             tokenAmount,
402             0,
403             path,
404             address(this),
405             block.timestamp
406         );
407     }
408  
409     function sendETHToFee(uint256 amount) private {
410         _developmentWalletAddress.transfer(amount.div(2));
411         _marketingWalletAddress.transfer(amount.div(2));
412     }
413  
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416     }
417  
418     function manualswap() external {
419         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
420         uint256 contractBalance = balanceOf(address(this));
421         swapTokensForEth(contractBalance);
422     }
423  
424     function manualsend() external {
425         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
426         uint256 contractETHBalance = address(this).balance;
427         sendETHToFee(contractETHBalance);
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
491  
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494  
495     function _getTValues(
496         uint256 tAmount,
497         uint256 redisFee,
498         uint256 taxFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(redisFee).div(100);
509         uint256 tTeam = tAmount.mul(taxFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511  
512         return (tTransferAmount, tFee, tTeam);
513     }
514  
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533  
534         return (rAmount, rTransferAmount, rFee);
535     }
536  
537     function _getRate() private view returns (uint256) {
538         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
539  
540         return rSupply.div(tSupply);
541     }
542  
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547  
548         return (rSupply, tSupply);
549     }
550  
551     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
552         _feeOnBuy = redisFeeOnBuy;
553         _feeOnSell = redisFeeOnSell;
554         _taxOnBuy = taxFeeOnBuy;
555         _taxOnSell = taxFeeOnSell;
556         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
557         require(totalFees <= 10, "Must keep fees at 10% or less");
558     }
559  
560     //Set minimum tokens required to swap.
561     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
562         _swapTokensAtAmount = swapTokensAtAmount;
563     }
564  
565     //Set minimum tokens required to swap.
566     function toggleSwap(bool _swapEnabled) public onlyOwner {
567         swapEnabled = _swapEnabled;
568     }
569  
570  
571     //Set max buy amount 
572     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
573         _maxTxAmount = maxTxAmount;
574     }
575 
576     //Set max wallet amount 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = maxWalletSize;
579     }
580 
581     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
582         for(uint256 i = 0; i < accounts.length; i++) {
583             _isExcludedFromFee[accounts[i]] = excluded;
584         }
585     }
586 }