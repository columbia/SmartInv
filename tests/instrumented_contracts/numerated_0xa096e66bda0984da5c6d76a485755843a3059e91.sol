1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4 
5 // https://onionswap.website/
6 // https://twitter.com/onion_swap
7 // https://t.me/onion_swap
8 
9 */
10 
11 
12 pragma solidity ^0.8.17;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19  
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22  
23     function balanceOf(address account) external view returns (uint256);
24  
25     function transfer(address recipient, uint256 amount) external returns (bool);
26  
27     function allowance(address owner, address spender) external view returns (uint256);
28  
29     function approve(address spender, uint256 amount) external returns (bool);
30  
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36  
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44  
45 contract Ownable is Context {
46     address private _owner;
47     address private _previousOwner;
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52  
53     constructor() {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58  
59     function owner() public view returns (address) {
60         return _owner;
61     }
62  
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67  
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72  
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78  
79 }
80  
81 library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85         return c;
86     }
87  
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91  
92     function sub(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99         return c;
100     }
101  
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110  
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114  
115     function div(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         return c;
123     }
124 }
125  
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB)
128         external
129         returns (address pair);
130 }
131  
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint256 amountIn,
135         uint256 amountOutMin,
136         address[] calldata path,
137         address to,
138         uint256 deadline
139     ) external;
140  
141     function factory() external pure returns (address);
142  
143     function WETH() external pure returns (address);
144  
145     function addLiquidityETH(
146         address token,
147         uint256 amountTokenDesired,
148         uint256 amountTokenMin,
149         uint256 amountETHMin,
150         address to,
151         uint256 deadline
152     )
153         external
154         payable
155         returns (
156             uint256 amountToken,
157             uint256 amountETH,
158             uint256 liquidity
159         );
160 }
161  
162 contract OnionSwap is Context, IERC20, Ownable {
163  
164     using SafeMath for uint256;
165  
166     string private constant _name = "OnionSwap";
167     string private constant _symbol = "ONION";
168     uint8 private constant _decimals = 9;
169  
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 1000000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 private _redisFeeOnBuy = 0;  
179     uint256 private _taxFeeOnBuy = 10;
180     uint256 private _redisFeeOnSell = 0;
181     uint256 private _taxFeeOnSell = 20;
182     
183     uint256 private _redisFee = _redisFeeOnSell;
184     uint256 private _taxFee = _taxFeeOnSell;
185  
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188  
189     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
190     address payable private _developmentAddress = payable(0x0e64d3Ff8967c1C61e824ba6Ecef31685C0EDaF2); 
191     address payable private _marketingAddress = payable(0x0e64d3Ff8967c1C61e824ba6Ecef31685C0EDaF2);
192  
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195  
196     bool private tradingOpen = true;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199  
200     uint256 public _maxTxAmount = 1000000000 * 10**9; 
201     uint256 public _maxWalletSize = 20000000 * 10**9; 
202     uint256 public _swapTokensAtAmount = 500000 * 10**9;
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
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219  
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_developmentAddress] = true;
223         _isExcludedFromFee[_marketingAddress] = true;
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
348             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
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
380                 _redisFee = _redisFeeOnBuy;
381                 _taxFee = _taxFeeOnBuy;
382             }
383  
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnSell;
387                 _taxFee = _taxFeeOnSell;
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
410         _marketingAddress.transfer(amount);
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
490         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
491     }
492  
493     function _getTValues(
494         uint256 tAmount,
495         uint256 redisFee,
496         uint256 taxFee
497     )
498         private
499         pure
500         returns (
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         uint256 tFee = tAmount.mul(redisFee).div(100);
507         uint256 tTeam = tAmount.mul(taxFee).div(100);
508         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
530         return (rAmount, rTransferAmount, rFee);
531     }
532  
533     function _getRate() private view returns (uint256) {
534         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
535         return rSupply.div(tSupply);
536     }
537  
538     function _getCurrentSupply() private view returns (uint256, uint256) {
539         uint256 rSupply = _rTotal;
540         uint256 tSupply = _tTotal;
541         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
542         return (rSupply, tSupply);
543     }
544  
545     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
546 
547         _redisFeeOnBuy = redisFeeOnBuy;
548         _redisFeeOnSell = redisFeeOnSell;
549         _taxFeeOnBuy = taxFeeOnBuy;
550         _taxFeeOnSell = taxFeeOnSell;
551 
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
564     //Set maximum transaction
565     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
566 	require(
567             maxTxAmount >= ((totalSupply() * 1) / 100),
568             "Cannot set maxTransactionAmount lower than 1%"
569         );
570 	_maxTxAmount = maxTxAmount;
571         
572     }
573  
574     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
575 	require(
576             maxWalletSize >= ((totalSupply() * 1) / 100),
577             "Cannot set maxWalletAmount lower than 1%"
578         );
579         _maxWalletSize = maxWalletSize;
580     }
581  
582     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
583         for(uint256 i = 0; i < accounts.length; i++) {
584             _isExcludedFromFee[accounts[i]] = excluded;
585         }
586     }
587 
588 }