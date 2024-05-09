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
152 contract RAREPEPE is Context, IERC20, Ownable {
153 
154     using SafeMath for uint256;
155 
156     string private constant _name = "RARE PEPE";
157     string private constant _symbol = "RAPE";
158     uint8 private constant _decimals = 9;
159 
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 69000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _redisFeeOnBuy = 0;
169     uint256 private _taxFeeOnBuy = 0;
170     uint256 private _redisFeeOnSell = 0;
171     uint256 private _taxFeeOnSell = 0;
172 
173     //Original Fee
174     uint256 private _redisFee = _redisFeeOnSell;
175     uint256 private _taxFee = _taxFeeOnSell;
176 
177     uint256 private _previousredisFee = _redisFee;
178     uint256 private _previoustaxFee = _taxFee;
179 
180     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
181     address payable private _developmentAddress = payable(0x8f07A02C4a7c1D34495501025A01D055C3237e37);
182     address payable private _marketingAddress = payable(0x8f07A02C4a7c1D34495501025A01D055C3237e37);
183 
184     IUniswapV2Router02 public uniswapV2Router;
185     address public uniswapV2Pair;
186 
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = true;
190 
191     uint256 public _maxTxAmount = 690000 * 10**9;
192     uint256 public _maxWalletSize = 690000 * 10**9;
193     uint256 public _swapTokensAtAmount = 100000 * 10**9;
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
216         
217 
218         emit Transfer(address(0), _msgSender(), _tTotal);
219     }
220 
221     function name() public pure returns (string memory) {
222         return _name;
223     }
224 
225     function symbol() public pure returns (string memory) {
226         return _symbol;
227     }
228 
229     function decimals() public pure returns (uint8) {
230         return _decimals;
231     }
232 
233     function totalSupply() public pure override returns (uint256) {
234         return _tTotal;
235     }
236 
237     function balanceOf(address account) public view override returns (uint256) {
238         return tokenFromReflection(_rOwned[account]);
239     }
240 
241     function transfer(address recipient, uint256 amount)
242         public
243         override
244         returns (bool)
245     {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     function allowance(address owner, address spender)
251         public
252         view
253         override
254         returns (uint256)
255     {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(
275             sender,
276             _msgSender(),
277             _allowances[sender][_msgSender()].sub(
278                 amount,
279                 "ERC20: transfer amount exceeds allowance"
280             )
281         );
282         return true;
283     }
284 
285     function tokenFromReflection(uint256 rAmount)
286         private
287         view
288         returns (uint256)
289     {
290         require(
291             rAmount <= _rTotal,
292             "Amount must be less than total reflections"
293         );
294         uint256 currentRate = _getRate();
295         return rAmount.div(currentRate);
296     }
297 
298     function removeAllFee() private {
299         if (_redisFee == 0 && _taxFee == 0) return;
300 
301         _previousredisFee = _redisFee;
302         _previoustaxFee = _taxFee;
303 
304         _redisFee = 0;
305         _taxFee = 0;
306     }
307 
308     function restoreAllFee() private {
309         _redisFee = _previousredisFee;
310         _taxFee = _previoustaxFee;
311     }
312 
313     function _approve(
314         address owner,
315         address spender,
316         uint256 amount
317     ) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324     function _transfer(
325         address from,
326         address to,
327         uint256 amount
328     ) private {
329         require(from != address(0), "ERC20: transfer from the zero address");
330         require(to != address(0), "ERC20: transfer to the zero address");
331         require(amount > 0, "Transfer amount must be greater than zero");
332 
333         if (from != owner() && to != owner()) {
334 
335             //Trade start check
336             if (!tradingOpen) {
337                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
338             }
339 
340             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
341             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
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
403         _marketingAddress.transfer(amount);
404     }
405 
406     function setTrading(bool _tradingOpen) public onlyOwner {
407         tradingOpen = _tradingOpen;
408     }
409 
410     function manualswap() external {
411         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
412         uint256 contractBalance = balanceOf(address(this));
413         swapTokensForEth(contractBalance);
414     }
415 
416     function manualsend() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractETHBalance = address(this).balance;
419         sendETHToFee(contractETHBalance);
420     }
421 
422     function blockBots(address[] memory bots_) public onlyOwner {
423         for (uint256 i = 0; i < bots_.length; i++) {
424             bots[bots_[i]] = true;
425         }
426     }
427 
428     function unblockBot(address notbot) public onlyOwner {
429         bots[notbot] = false;
430     }
431 
432     function _tokenTransfer(
433         address sender,
434         address recipient,
435         uint256 amount,
436         bool takeFee
437     ) private {
438         if (!takeFee) removeAllFee();
439         _transferStandard(sender, recipient, amount);
440         if (!takeFee) restoreAllFee();
441     }
442 
443     function _transferStandard(
444         address sender,
445         address recipient,
446         uint256 tAmount
447     ) private {
448         (
449             uint256 rAmount,
450             uint256 rTransferAmount,
451             uint256 rFee,
452             uint256 tTransferAmount,
453             uint256 tFee,
454             uint256 tTeam
455         ) = _getValues(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
458         _takeTeam(tTeam);
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462 
463     function _takeTeam(uint256 tTeam) private {
464         uint256 currentRate = _getRate();
465         uint256 rTeam = tTeam.mul(currentRate);
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468 
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473 
474     receive() external payable {}
475 
476     function _getValues(uint256 tAmount)
477         private
478         view
479         returns (
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
489             _getTValues(tAmount, _redisFee, _taxFee);
490         uint256 currentRate = _getRate();
491         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
492             _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495 
496     function _getTValues(
497         uint256 tAmount,
498         uint256 redisFee,
499         uint256 taxFee
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 tFee = tAmount.mul(redisFee).div(100);
510         uint256 tTeam = tAmount.mul(taxFee).div(100);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
533         return (rAmount, rTransferAmount, rFee);
534     }
535 
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538         return rSupply.div(tSupply);
539     }
540 
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547 
548     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
549         _redisFeeOnBuy = redisFeeOnBuy;
550         _redisFeeOnSell = redisFeeOnSell;
551         _taxFeeOnBuy = taxFeeOnBuy;
552         _taxFeeOnSell = taxFeeOnSell;
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
565     //Set maximum transaction
566     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
567         _maxTxAmount = maxTxAmount;
568     }
569 
570     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
571         _maxWalletSize = maxWalletSize;
572     }
573 
574     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
575         for(uint256 i = 0; i < accounts.length; i++) {
576             _isExcludedFromFee[accounts[i]] = excluded;
577         }
578     }
579 
580 }