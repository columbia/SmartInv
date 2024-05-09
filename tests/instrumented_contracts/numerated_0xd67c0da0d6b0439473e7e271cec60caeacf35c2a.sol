1 // SPDX-License-Identifier: UNLICENSED
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
152 contract DOBA is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
153 
154     using SafeMath for uint256;
155 
156     string private constant _name = "DOBA";//////////////////////////
157     string private constant _symbol = "DOBA";//////////////////////////////////////////////////////////////////////////
158     uint8 private constant _decimals = 9;
159 
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 10000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168 
169     //Buy Fee
170     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
171     uint256 private _taxFeeOnBuy = 10;//////////////////////////////////////////////////////////////////////
172 
173     //Sell Fee
174     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
175     uint256 private _taxFeeOnSell = 80;/////////////////////////////////////////////////////////////////////
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots;
185     mapping(address => uint256) private cooldown;
186 
187     address payable private _developmentAddress = payable(0x07d60cb306DbdF15Df6eA134D490f029f9f5dA4E);/////////////////////////////////////////////////
188     address payable private _marketingAddress = payable(0xd96608b0B670EFd9433B7683fCBac47A50e7C6fe);///////////////////////////////////////////////////
189 
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192 
193     bool private tradingOpen;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196 
197     uint256 public _maxTxAmount = 200000 * 10**9; //1%
198     uint256 public _maxWalletSize = 200000 * 10**9; //1%
199     uint256 public _swapTokensAtAmount = 20000 * 10**9; //1%
200 
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207 
208     constructor() {
209 
210         _rOwned[_msgSender()] = _rTotal;
211 
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216 
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_developmentAddress] = true;
220         _isExcludedFromFee[_marketingAddress] = true;
221 
222         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
223         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
224         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
225         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
226         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
227         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
228         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
229         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
230         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
231         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
232         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
233 
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236 
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240 
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244 
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248 
249     function totalSupply() public pure override returns (uint256) {
250         return _tTotal;
251     }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         return tokenFromReflection(_rOwned[account]);
255     }
256 
257     function transfer(address recipient, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     function allowance(address owner, address spender)
267         public
268         view
269         override
270         returns (uint256)
271     {
272         return _allowances[owner][spender];
273     }
274 
275     function approve(address spender, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(
291             sender,
292             _msgSender(),
293             _allowances[sender][_msgSender()].sub(
294                 amount,
295                 "ERC20: transfer amount exceeds allowance"
296             )
297         );
298         return true;
299     }
300 
301     function tokenFromReflection(uint256 rAmount)
302         private
303         view
304         returns (uint256)
305     {
306         require(
307             rAmount <= _rTotal,
308             "Amount must be less than total reflections"
309         );
310         uint256 currentRate = _getRate();
311         return rAmount.div(currentRate);
312     }
313 
314     function removeAllFee() private {
315         if (_redisFee == 0 && _taxFee == 0) return;
316 
317         _previousredisFee = _redisFee;
318         _previoustaxFee = _taxFee;
319 
320         _redisFee = 0;
321         _taxFee = 0;
322     }
323 
324     function restoreAllFee() private {
325         _redisFee = _previousredisFee;
326         _taxFee = _previoustaxFee;
327     }
328 
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339 
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) private {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348 
349         if (from != owner() && to != owner()) {
350 
351             //Trade start check
352             if (!tradingOpen) {
353                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
354             }
355 
356             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
357             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
358 
359             if(to != uniswapV2Pair) {
360                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
361             }
362 
363             uint256 contractTokenBalance = balanceOf(address(this));
364             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
365 
366             if(contractTokenBalance >= _maxTxAmount)
367             {
368                 contractTokenBalance = _maxTxAmount;
369             }
370 
371             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
372                 swapTokensForEth(contractTokenBalance);
373                 uint256 contractETHBalance = address(this).balance;
374                 if (contractETHBalance > 0) {
375                     sendETHToFee(address(this).balance);
376                 }
377             }
378         }
379 
380         bool takeFee = true;
381 
382         //Transfer Tokens
383         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
384             takeFee = false;
385         } else {
386 
387             //Set Fee for Buys
388             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnBuy;
390                 _taxFee = _taxFeeOnBuy;
391             }
392 
393             //Set Fee for Sells
394             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
395                 _redisFee = _redisFeeOnSell;
396                 _taxFee = _taxFeeOnSell;
397             }
398 
399         }
400 
401         _tokenTransfer(from, to, amount, takeFee);
402     }
403 
404     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
405         address[] memory path = new address[](2);
406         path[0] = address(this);
407         path[1] = uniswapV2Router.WETH();
408         _approve(address(this), address(uniswapV2Router), tokenAmount);
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0,
412             path,
413             address(this),
414             block.timestamp
415         );
416     }
417 
418     function sendETHToFee(uint256 amount) private {
419         _developmentAddress.transfer(amount.div(2));
420         _marketingAddress.transfer(amount.div(2));
421     }
422 
423     function setTrading(bool _tradingOpen) public onlyOwner {
424         tradingOpen = _tradingOpen;
425     }
426 
427     function manualswap() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
429         uint256 contractBalance = balanceOf(address(this));
430         swapTokensForEth(contractBalance);
431     }
432 
433     function manualsend() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractETHBalance = address(this).balance;
436         sendETHToFee(contractETHBalance);
437     }
438 
439     function blockBots(address[] memory bots_) public onlyOwner {
440         for (uint256 i = 0; i < bots_.length; i++) {
441             bots[bots_[i]] = true;
442         }
443     }
444 
445     function unblockBot(address notbot) public onlyOwner {
446         bots[notbot] = false;
447     }
448 
449     function _tokenTransfer(
450         address sender,
451         address recipient,
452         uint256 amount,
453         bool takeFee
454     ) private {
455         if (!takeFee) removeAllFee();
456         _transferStandard(sender, recipient, amount);
457         if (!takeFee) restoreAllFee();
458     }
459 
460     function _transferStandard(
461         address sender,
462         address recipient,
463         uint256 tAmount
464     ) private {
465         (
466             uint256 rAmount,
467             uint256 rTransferAmount,
468             uint256 rFee,
469             uint256 tTransferAmount,
470             uint256 tFee,
471             uint256 tTeam
472         ) = _getValues(tAmount);
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
475         _takeTeam(tTeam);
476         _reflectFee(rFee, tFee);
477         emit Transfer(sender, recipient, tTransferAmount);
478     }
479 
480     function _takeTeam(uint256 tTeam) private {
481         uint256 currentRate = _getRate();
482         uint256 rTeam = tTeam.mul(currentRate);
483         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
484     }
485 
486     function _reflectFee(uint256 rFee, uint256 tFee) private {
487         _rTotal = _rTotal.sub(rFee);
488         _tFeeTotal = _tFeeTotal.add(tFee);
489     }
490 
491     receive() external payable {}
492 
493     function _getValues(uint256 tAmount)
494         private
495         view
496         returns (
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
506             _getTValues(tAmount, _redisFee, _taxFee);
507         uint256 currentRate = _getRate();
508         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
509             _getRValues(tAmount, tFee, tTeam, currentRate);
510 
511         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
512     }
513 
514     function _getTValues(
515         uint256 tAmount,
516         uint256 redisFee,
517         uint256 taxFee
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 tFee = tAmount.mul(redisFee).div(100);
528         uint256 tTeam = tAmount.mul(taxFee).div(100);
529         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
530 
531         return (tTransferAmount, tFee, tTeam);
532     }
533 
534     function _getRValues(
535         uint256 tAmount,
536         uint256 tFee,
537         uint256 tTeam,
538         uint256 currentRate
539     )
540         private
541         pure
542         returns (
543             uint256,
544             uint256,
545             uint256
546         )
547     {
548         uint256 rAmount = tAmount.mul(currentRate);
549         uint256 rFee = tFee.mul(currentRate);
550         uint256 rTeam = tTeam.mul(currentRate);
551         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
552 
553         return (rAmount, rTransferAmount, rFee);
554     }
555 
556     function _getRate() private view returns (uint256) {
557         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
558 
559         return rSupply.div(tSupply);
560     }
561 
562     function _getCurrentSupply() private view returns (uint256, uint256) {
563         uint256 rSupply = _rTotal;
564         uint256 tSupply = _tTotal;
565         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
566 
567         return (rSupply, tSupply);
568     }
569 
570     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
571         _redisFeeOnBuy = redisFeeOnBuy;
572         _redisFeeOnSell = redisFeeOnSell;
573 
574         _taxFeeOnBuy = taxFeeOnBuy;
575         _taxFeeOnSell = taxFeeOnSell;
576     }
577 
578     //Set minimum tokens required to swap.
579     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
580         _swapTokensAtAmount = swapTokensAtAmount;
581     }
582 
583     //Set minimum tokens required to swap.
584     function toggleSwap(bool _swapEnabled) public onlyOwner {
585         swapEnabled = _swapEnabled;
586     }
587 
588     //Set MAx transaction
589     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
590         _maxTxAmount = maxTxAmount;
591     }
592 
593     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
594         _maxWalletSize = maxWalletSize;
595     }
596 
597     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
598         for(uint256 i = 0; i < accounts.length; i++) {
599             _isExcludedFromFee[accounts[i]] = excluded;
600         }
601     }
602 }