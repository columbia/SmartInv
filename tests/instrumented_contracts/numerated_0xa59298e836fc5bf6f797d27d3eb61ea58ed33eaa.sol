1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
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
152 contract Shinzo is Context, IERC20, Ownable {
153 
154     using SafeMath for uint256;
155 
156     string private constant _name = "Shinzo";
157     string private constant _symbol = "SHZO";
158     uint8 private constant _decimals = 9;
159 
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 40000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _redisFeeOnBuy = 0;
169     uint256 private _taxFeeOnBuy = 4;
170     uint256 private _redisFeeOnSell = 0;
171     uint256 private _taxFeeOnSell = 4;
172 
173     //Original Fee
174     uint256 private _redisFee = _redisFeeOnSell;
175     uint256 private _taxFee = _taxFeeOnSell;
176 
177     uint256 private _previousredisFee = _redisFee;
178     uint256 private _previoustaxFee = _taxFee;
179 
180     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
181     address payable private _developmentAddress = payable(0x76b3dBb0E95Ff8c18606453cA7B9f5b6b98FE768);
182     address payable private _marketingAddress = payable(0x76E72829251F4CBFf7E0f2d5f64Cf62ac7d495B0);
183 
184     IUniswapV2Router02 public uniswapV2Router;
185     address public uniswapV2Pair;
186 
187     bool private tradingOpen = false;
188     bool private inSwap = false;
189     bool private swapEnabled = true;
190 
191     uint256 public _maxTxAmount = 800000 * 10**9;
192     uint256 public _maxWalletSize = 800000 * 10**9;
193     uint256 public _swapTokensAtAmount = 400 * 10**9;
194 
195     event MaxTxAmountUpdated(uint256 _maxTxAmount);
196     modifier lockTheSwap {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201 
202     constructor() {
203 
204         _rOwned[_msgSender()] = _rTotal;
205 
206         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
207         uniswapV2Router = _uniswapV2Router;
208         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
209             .createPair(address(this), _uniswapV2Router.WETH());
210 
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[address(this)] = true;
213         _isExcludedFromFee[_developmentAddress] = true;
214         _isExcludedFromFee[_marketingAddress] = true;
215 
216         emit Transfer(address(0), _msgSender(), _tTotal);
217     }
218 
219     function name() public pure returns (string memory) {
220         return _name;
221     }
222 
223     function symbol() public pure returns (string memory) {
224         return _symbol;
225     }
226 
227     function decimals() public pure returns (uint8) {
228         return _decimals;
229     }
230 
231     function totalSupply() public pure override returns (uint256) {
232         return _tTotal;
233     }
234 
235     function balanceOf(address account) public view override returns (uint256) {
236         return tokenFromReflection(_rOwned[account]);
237     }
238 
239     function transfer(address recipient, uint256 amount)
240         public
241         override
242         returns (bool)
243     {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247 
248     function allowance(address owner, address spender)
249         public
250         view
251         override
252         returns (uint256)
253     {
254         return _allowances[owner][spender];
255     }
256 
257     function approve(address spender, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) public override returns (bool) {
271         _transfer(sender, recipient, amount);
272         _approve(
273             sender,
274             _msgSender(),
275             _allowances[sender][_msgSender()].sub(
276                 amount,
277                 "ERC20: transfer amount exceeds allowance"
278             )
279         );
280         return true;
281     }
282 
283     function tokenFromReflection(uint256 rAmount)
284         private
285         view
286         returns (uint256)
287     {
288         require(
289             rAmount <= _rTotal,
290             "Amount must be less than total reflections"
291         );
292         uint256 currentRate = _getRate();
293         return rAmount.div(currentRate);
294     }
295 
296     function removeAllFee() private {
297         if (_redisFee == 0 && _taxFee == 0) return;
298 
299         _previousredisFee = _redisFee;
300         _previoustaxFee = _taxFee;
301 
302         _redisFee = 0;
303         _taxFee = 0;
304     }
305 
306     function restoreAllFee() private {
307         _redisFee = _previousredisFee;
308         _taxFee = _previoustaxFee;
309     }
310 
311     function _approve(
312         address owner,
313         address spender,
314         uint256 amount
315     ) private {
316         require(owner != address(0), "ERC20: approve from the zero address");
317         require(spender != address(0), "ERC20: approve to the zero address");
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321 
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) private {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329         require(amount > 0, "Transfer amount must be greater than zero");
330 
331         if (from != owner() && to != owner()) {
332 
333             //Trade start check
334             if (!tradingOpen) {
335                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
336             }
337 
338             require(amount <= _maxTxAmount || _isExcludedFromFee[to], "TOKEN: Max Transaction Limit");
339             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
340 
341             if(to != uniswapV2Pair && !_isExcludedFromFee[to]) {
342                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
343             }
344 
345             uint256 contractTokenBalance = balanceOf(address(this));
346             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
347 
348             if(contractTokenBalance >= _maxTxAmount)
349             {
350                 contractTokenBalance = _maxTxAmount;
351             }
352 
353             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
354                 swapTokensForEth(contractTokenBalance);
355                 uint256 contractETHBalance = address(this).balance;
356                 if (contractETHBalance > 0) {
357                     sendETHToFee(address(this).balance);
358                 }
359             }
360         }
361 
362         bool takeFee = true;
363 
364         //Transfer Tokens
365         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
366             takeFee = false;
367         } else {
368 
369             //Set Fee for Buys
370             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
371                 _redisFee = _redisFeeOnBuy;
372                 _taxFee = _taxFeeOnBuy;
373             }
374 
375             //Set Fee for Sells
376             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnSell;
378                 _taxFee = _taxFeeOnSell;
379             }
380 
381             if (_taxFee == 0 && _redisFee == 0) {
382                 takeFee = false;
383             }
384 
385         }
386 
387         _tokenTransfer(from, to, amount, takeFee);
388     }
389 
390     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = uniswapV2Router.WETH();
394         _approve(address(this), address(uniswapV2Router), tokenAmount);
395         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
396             tokenAmount,
397             0,
398             path,
399             address(this),
400             block.timestamp
401         );
402     }
403 
404     function sendETHToFee(uint256 amount) private {
405         uint256 half = amount.div(2);
406         _marketingAddress.transfer(half);
407         _developmentAddress.transfer(amount.sub(half));
408     }
409 
410     function setTrading(bool _tradingOpen) public onlyOwner {
411         require(!tradingOpen, "ERC20: Trading can be only opened once");
412         tradingOpen = _tradingOpen;
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function blockBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432 
433     function unblockBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436 
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467 
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473 
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478 
479     receive() external payable {}
480 
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _redisFee, _taxFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500 
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517         return (tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538         return (rAmount, rTransferAmount, rFee);
539     }
540 
541     function _getRate() private view returns (uint256) {
542         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
543         return rSupply.div(tSupply);
544     }
545 
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550         return (rSupply, tSupply);
551     }
552 
553     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
554         require(redisFeeOnBuy + taxFeeOnBuy <= 5, "Tax on buy can't be more than 5");
555         require(redisFeeOnSell + taxFeeOnSell <= 5, "Tax on sell can't be more than 5");
556         _redisFeeOnBuy = redisFeeOnBuy;
557         _redisFeeOnSell = redisFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560     }
561 
562     //Set minimum tokens required to swap.
563     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
564         _swapTokensAtAmount = swapTokensAtAmount;
565     }
566 
567     //Set minimum tokens required to swap.
568     function toggleSwap(bool _swapEnabled) public onlyOwner {
569         swapEnabled = _swapEnabled;
570     }
571 
572     //Set maximum transaction
573     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
574         _maxTxAmount = maxTxAmount;
575     }
576 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = maxWalletSize;
579     }
580 
581     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
582         for(uint256 i = 0; i < accounts.length; i++) {
583             _isExcludedFromFee[accounts[i]] = excluded;
584         }
585     }
586 
587 }