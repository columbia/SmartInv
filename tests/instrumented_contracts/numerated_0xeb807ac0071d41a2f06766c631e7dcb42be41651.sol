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
152 contract HOKKAIDO is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "Hokkaido Inu"; 
157     string private constant _symbol = "HOKI"; 
158     uint8 private constant _decimals = 9;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165 
166     uint256 private constant _tTotal = 1000000000 * 10**9; 
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169  
170     //Buy Fee
171     uint256 private _redisFeeOnBuy = 0;  
172     uint256 private _taxFeeOnBuy = 6;   
173  
174     //Sell Fee
175     uint256 private _redisFeeOnSell = 0; 
176     uint256 private _taxFeeOnSell = 6;  
177 
178     uint256 public totalFees;
179  
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => uint256) private cooldown;
188  
189     address payable private _developmentAddress = payable(0xDF27dE1221C60cDE6FDaaB0b120d2Be37e604578);
190     address payable private _marketingAddress = payable(0xDF27dE1221C60cDE6FDaaB0b120d2Be37e604578);
191  
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194  
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198  
199     uint256 public _maxTxAmount = 10000000 * 10**9;
200     uint256 public _maxWalletSize = 10000000 * 10**9; 
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
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
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
379                 _redisFee = _redisFeeOnBuy;
380                 _taxFee = _taxFeeOnBuy;
381             }
382  
383             //Set Fee for Sells
384             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnSell;
386                 _taxFee = _taxFeeOnSell;
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
409         _developmentAddress.transfer(amount.div(2));
410         _marketingAddress.transfer(amount.div(2));
411     }
412  
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416  
417     function manualswap() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422  
423     function manualsend() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
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
551         _redisFeeOnBuy = redisFeeOnBuy;
552         _redisFeeOnSell = redisFeeOnSell;
553         _taxFeeOnBuy = taxFeeOnBuy;
554         _taxFeeOnSell = taxFeeOnSell;
555         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
556         require(totalFees <= 15, "Must keep fees at 15% or less");
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
580     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
581         for(uint256 i = 0; i < accounts.length; i++) {
582             _isExcludedFromFee[accounts[i]] = excluded;
583         }
584     }
585 }