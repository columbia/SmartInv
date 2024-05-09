1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5  
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11  
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14  
15     function balanceOf(address account) external view returns (uint256);
16  
17     function transfer(address recipient, uint256 amount) external returns (bool);
18  
19     function allowance(address owner, address spender) external view returns (uint256);
20  
21     function approve(address spender, uint256 amount) external returns (bool);
22  
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28  
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36  
37 contract Ownable is Context {
38     address internal _owner;
39     address private _previousOwner;
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44  
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50  
51     function owner() public view returns (address) {
52         return _owner;
53     }
54  
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59  
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64  
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70  
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79  
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83  
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93  
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102  
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106  
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 }
117  
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123  
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132  
133     function factory() external pure returns (address);
134  
135     function WETH() external pure returns (address);
136  
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153  
154 contract CULTURE  is Context, IERC20, Ownable {
155  
156     using SafeMath for uint256;
157  
158     string private constant _name = "CULTURE";
159     string private constant _symbol = "CULTURE";
160     uint8 private constant _decimals = 9;
161  
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     mapping(address => bool) private _isExcludedFromMax;
167     uint256 private constant MAX = ~uint256(0);
168     uint256 private constant _tTotal = 1000000000 * 10**8;
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171     uint256 private _redisFeeOnBuy = 0;  
172     uint256 private _taxFeeOnBuy = 0;  
173     uint256 private _redisFeeOnSell = 0;  
174     uint256 private _taxFeeOnSell = 0;
175  
176     uint256 private _redisFee = _redisFeeOnSell;
177     uint256 private _taxFee = _taxFeeOnSell;
178  
179     uint256 private _previousredisFee = _redisFee;
180     uint256 private _previoustaxFee = _taxFee;
181  
182     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
183     address payable private _developmentAddress = payable(0xd90AB9405aF1E3697aF94f42421e026c389dB8D9); 
184     address payable private _marketingAddress = payable(0x1213fE2a925E41B7C6Db5a1a9e436e1B7Dc12BcB);
185  
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188  
189     bool private tradingOpen;
190     bool private inSwap = false;
191     bool private swapEnabled = true;
192  
193     uint256 public _maxTxAmount = _tTotal.mul(2).div(100);
194     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
195     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
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
208         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
209         uniswapV2Router = _uniswapV2Router;
210         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
211             .createPair(address(this), _uniswapV2Router.WETH());
212  
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_developmentAddress] = true;
216         _isExcludedFromFee[_marketingAddress] = true;
217         _isExcludedFromMax[owner()] = true;
218         _isExcludedFromMax[address(this)] = true;
219         _isExcludedFromMax[_developmentAddress] = true;
220         _isExcludedFromMax[_marketingAddress] = true;
221  
222         emit Transfer(address(0), _msgSender(), _tTotal);
223     }
224  
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228  
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232  
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236  
237     function totalSupply() public pure override returns (uint256) {
238         return _tTotal;
239     }
240  
241     function balanceOf(address account) public view override returns (uint256) {
242         return tokenFromReflection(_rOwned[account]);
243     }
244  
245     function transfer(address recipient, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253  
254     function allowance(address owner, address spender)
255         public
256         view
257         override
258         returns (uint256)
259     {
260         return _allowances[owner][spender];
261     }
262  
263     function approve(address spender, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271  
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(
279             sender,
280             _msgSender(),
281             _allowances[sender][_msgSender()].sub(
282                 amount,
283                 "ERC20: transfer amount exceeds allowance"
284             )
285         );
286         return true;
287     }
288  
289     function tokenFromReflection(uint256 rAmount)
290         private
291         view
292         returns (uint256)
293     {
294         require(
295             rAmount <= _rTotal,
296             "Amount must be less than total reflections"
297         );
298         uint256 currentRate = _getRate();
299         return rAmount.div(currentRate);
300     }
301  
302     function removeAllFee() private {
303         if (_redisFee == 0 && _taxFee == 0) return;
304  
305         _previousredisFee = _redisFee;
306         _previoustaxFee = _taxFee;
307  
308         _redisFee = 0;
309         _taxFee = 0;
310     }
311  
312     function restoreAllFee() private {
313         _redisFee = _previousredisFee;
314         _taxFee = _previoustaxFee;
315     }
316  
317     function _approve(
318         address owner,
319         address spender,
320         uint256 amount
321     ) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327  
328     function _transfer(
329         address from,
330         address to,
331         uint256 amount
332     ) private {
333         require(from != address(0), "ERC20: transfer from the zero address");
334         require(to != address(0), "ERC20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336  
337         if (from != owner() && to != owner()) {
338  
339             //Trade start check
340             if (!tradingOpen) {
341                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
342             }
343 
344             if (!_isExcludedFromMax[from]){
345                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             }
347             
348             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
349  
350             if(to != uniswapV2Pair && !_isExcludedFromMax[to]) {
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
410         _marketingAddress.transfer(amount.mul(4).div(5));
411         _developmentAddress.transfer(amount.mul(1).div(5));
412     }
413  
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416     }
417  
418     function manualswap() external {
419         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
420         uint256 contractBalance = balanceOf(address(this));
421         swapTokensForEth(contractBalance);
422     }
423  
424     function manualsend() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractETHBalance = address(this).balance;
427         sendETHToFee(contractETHBalance);
428     }
429  
430     function blockBots(address[] memory bots_) public onlyOwner {
431         for (uint256 i = 0; i < bots_.length; i++) {
432             bots[bots_[i]] = true;
433         }
434     }
435  
436     function unblockBot(address notbot) public onlyOwner {
437         bots[notbot] = false;
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
501         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
502     }
503  
504     function _getTValues(
505         uint256 tAmount,
506         uint256 redisFee,
507         uint256 taxFee
508     )
509         private
510         pure
511         returns (
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         uint256 tFee = tAmount.mul(redisFee).div(100);
518         uint256 tTeam = tAmount.mul(taxFee).div(100);
519         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
520         return (tTransferAmount, tFee, tTeam);
521     }
522  
523     function _getRValues(
524         uint256 tAmount,
525         uint256 tFee,
526         uint256 tTeam,
527         uint256 currentRate
528     )
529         private
530         pure
531         returns (
532             uint256,
533             uint256,
534             uint256
535         )
536     {
537         uint256 rAmount = tAmount.mul(currentRate);
538         uint256 rFee = tFee.mul(currentRate);
539         uint256 rTeam = tTeam.mul(currentRate);
540         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
541         return (rAmount, rTransferAmount, rFee);
542     }
543  
544     function _getRate() private view returns (uint256) {
545         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
546         return rSupply.div(tSupply);
547     }
548  
549     function _getCurrentSupply() private view returns (uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
553         return (rSupply, tSupply);
554     }
555  
556     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
557         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
558         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
559         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
560         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 1000, "Sell tax must be between 0% and 1000%");
561 
562         _redisFeeOnBuy = redisFeeOnBuy;
563         _redisFeeOnSell = redisFeeOnSell;
564         _taxFeeOnBuy = taxFeeOnBuy;
565         _taxFeeOnSell = taxFeeOnSell;
566 
567     }
568  
569     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
570         _swapTokensAtAmount = swapTokensAtAmount;
571     }
572 
573     function exemptedFromMax() public onlyOwner {
574 
575     }
576  
577     function toggleSwap(bool _swapEnabled) public onlyOwner {
578         swapEnabled = _swapEnabled;
579     }
580  
581     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
582         require(amountPercent>0);
583         _maxTxAmount = (_tTotal * amountPercent ) / 100;
584     }
585 
586     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
587         require(amountPercent>0);
588         _maxWalletSize = (_tTotal * amountPercent ) / 100;
589     }
590 
591     function removeLimits() external onlyOwner{
592         _maxTxAmount = _tTotal;
593         _maxWalletSize = _tTotal;
594     }
595  
596     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
597         for(uint256 i = 0; i < accounts.length; i++) {
598             _isExcludedFromFee[accounts[i]] = excluded;
599         }
600     }
601 
602     function excludeMultipleAccountsFromMax(address[] calldata accounts, bool excluded) public onlyOwner {
603         for(uint256 i = 0; i < accounts.length; i++) {
604             _isExcludedFromMax[accounts[i]] = excluded;
605         }
606     }
607 
608 }