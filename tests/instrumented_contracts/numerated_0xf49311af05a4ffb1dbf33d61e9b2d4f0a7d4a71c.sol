1 /* 
2 The Crypto Companion Bot introduces a groundbreaking solution to streamline the crypto journey for project owners,
3 investors, and developers alike. With an emphasis on user-friendly functionalities and multi-language support, 
4 our token aims to create a seamless experience within the Telegram ecosystem.
5 
6 Telegram : https://t.me/CompanionBotERC
7 
8 Medium :  https://medium.com/@companionbot/introduction-to-companion-bot-6e7360155694
9 
10 Twitter : https://twitter.com/CompanionBotETH
11 
12 Website : hhtps://companionbot.live
13 
14 Telegram Bot : t.me/CompanionEthBot
15 
16 
17 **/
18 
19 // SPDX-License-Identifier: Unlicensed
20 pragma solidity ^0.8.9;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52 
53 contract Ownable is Context {
54     address private _owner;
55     address private _previousOwner;
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60 
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87 }
88 
89 library SafeMath {
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     }
109 
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         return c;
131     }
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169 
170 contract CompanionBot is Context, IERC20, Ownable {
171 
172     using SafeMath for uint256;
173 
174     string private constant _name = "CompanionBot";
175     string private constant _symbol = "CBot";
176     uint8 private constant _decimals = 9;
177 
178     mapping(address => uint256) private _rOwned;
179     mapping(address => uint256) private _tOwned;
180     mapping(address => mapping(address => uint256)) private _allowances;
181     mapping(address => bool) private _isExcludedFromFee;
182     uint256 private constant MAX = ~uint256(0);
183     uint256 private constant _tTotal = 10000000 * 10**9;
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186     uint256 private _MFeeOnBuy = 0;
187     uint256 private _taxFeeOnBuy = 20;
188     uint256 private _MFeeOnSell = 0;
189     uint256 private _taxFeeOnSell = 20;
190 
191     //Original Fee
192     uint256 private _MFee = _MFeeOnSell;
193     uint256 private _taxFee = _taxFeeOnSell;
194 
195     uint256 private _previousMFee = _MFee;
196     uint256 private _previoustaxFee = _taxFee;
197 
198     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
199     address payable private _developmentAddress = payable(0x449fA2C717BFdCa9E0becC3bFeDb6260c8c571b8);
200     address payable private _marketingAddress = payable(0x449fA2C717BFdCa9E0becC3bFeDb6260c8c571b8);
201 
202     IUniswapV2Router02 public uniswapV2Router;
203     address public uniswapV2Pair;
204 
205     bool private tradingOpen = true;
206     bool private inSwap = false;
207     bool private swapEnabled = true;
208 
209     uint256 public _maxTxAmount = _tTotal;
210     uint256 public _maxWalletSize = _tTotal * 2 / 100;
211     uint256 public _swapTokensAtAmount = _tTotal / 1000;
212 
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219 
220     constructor() {
221 
222         _rOwned[_msgSender()] = _rTotal;
223 
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
225         uniswapV2Router = _uniswapV2Router;
226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
227             .createPair(address(this), _uniswapV2Router.WETH());
228 
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[_developmentAddress] = true;
232         _isExcludedFromFee[_marketingAddress] = true;
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
315         if (_MFee == 0 && _taxFee == 0) return;
316 
317         _previousMFee = _MFee;
318         _previoustaxFee = _taxFee;
319 
320         _MFee = 0;
321         _taxFee = 0;
322     }
323 
324     function restoreAllFee() private {
325         _MFee = _previousMFee;
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
366             if(contractTokenBalance >= _swapTokensAtAmount*8)
367             {
368                 contractTokenBalance = _swapTokensAtAmount*8;
369             }
370 
371             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
372                 swapTokensForEth(contractTokenBalance);
373                 uint256 contractETHBalance = address(this).balance;
374                 if (contractETHBalance > 80000000000000000) {
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
389                 _MFee = _MFeeOnBuy;
390                 _taxFee = _taxFeeOnBuy;
391             }
392 
393             //Set Fee for Sells
394             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
395                 _MFee = _MFeeOnSell;
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
419         _marketingAddress.transfer(amount);
420     }
421 
422     function manualswap() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractBalance = balanceOf(address(this));
425         swapTokensForEth(contractBalance);
426     }
427 
428     function manualsend() external {
429         uint256 contractETHBalance = address(this).balance;
430         sendETHToFee(contractETHBalance);
431     }
432 
433     function blockBots(address[] memory bots_) public onlyOwner {
434         for (uint256 i = 0; i < bots_.length; i++) {
435             bots[bots_[i]] = true;
436         }
437     }
438 
439     function unblockBot(address notbot) public onlyOwner {
440         bots[notbot] = false;
441     }
442 
443     function _tokenTransfer(
444         address sender,
445         address recipient,
446         uint256 amount,
447         bool takeFee
448     ) private {
449         if (!takeFee) removeAllFee();
450         _transferStandard(sender, recipient, amount);
451         if (!takeFee) restoreAllFee();
452     }
453 
454     function _transferStandard(
455         address sender,
456         address recipient,
457         uint256 tAmount
458     ) private {
459         (
460             uint256 rAmount,
461             uint256 rTransferAmount,
462             uint256 rFee,
463             uint256 tTransferAmount,
464             uint256 tFee,
465             uint256 tTeam
466         ) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
469         _takeTeam(tTeam);
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473 
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate = _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478     }
479 
480     function _reflectFee(uint256 rFee, uint256 tFee) private {
481         _rTotal = _rTotal.sub(rFee);
482         _tFeeTotal = _tFeeTotal.add(tFee);
483     }
484 
485     receive() external payable {}
486 
487     function _getValues(uint256 tAmount)
488         private
489         view
490         returns (
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
500             _getTValues(tAmount, _MFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(
508         uint256 tAmount,
509         uint256 MFee,
510         uint256 taxFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(MFee).div(100);
521         uint256 tTeam = tAmount.mul(taxFee).div(100);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
523         return (tTransferAmount, tFee, tTeam);
524     }
525 
526     function _getRValues(
527         uint256 tAmount,
528         uint256 tFee,
529         uint256 tTeam,
530         uint256 currentRate
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 rAmount = tAmount.mul(currentRate);
541         uint256 rFee = tFee.mul(currentRate);
542         uint256 rTeam = tTeam.mul(currentRate);
543         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
544         return (rAmount, rTransferAmount, rFee);
545     }
546 
547     function _getRate() private view returns (uint256) {
548         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
549         return rSupply.div(tSupply);
550     }
551 
552     function _getCurrentSupply() private view returns (uint256, uint256) {
553         uint256 rSupply = _rTotal;
554         uint256 tSupply = _tTotal;
555         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
556         return (rSupply, tSupply);
557     }
558 
559     function setFee(uint256 MFeeOnBuy, uint256 MFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
560         _MFeeOnBuy = MFeeOnBuy;
561         _MFeeOnSell = MFeeOnSell;
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564         uint256 totalFee = _MFeeOnBuy+_MFeeOnSell+_taxFeeOnBuy+_taxFeeOnSell;
565         require (totalFee <= 25,"Total Fees cannot be more than 25%");
566     }
567 
568     //Set minimum tokens required to swap.
569     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
570         _swapTokensAtAmount = swapTokensAtAmount;
571     }
572 
573     //Set minimum tokens required to swap.
574     function toggleSwap(bool _swapEnabled) public onlyOwner {
575         swapEnabled = _swapEnabled;
576     }
577 
578     //Set maximum transaction
579     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
580         _maxTxAmount = _tTotal*maxTxAmount/100;
581         require (_maxTxAmount>= _tTotal/100);
582     }
583 
584     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
585         _maxWalletSize = _tTotal*maxWalletSize/100;
586         require (_maxWalletSize>= _tTotal/100);
587     }
588 
589     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
590         for(uint256 i = 0; i < accounts.length; i++) {
591             _isExcludedFromFee[accounts[i]] = excluded;
592         }
593     }
594 
595      function updateMarketingAddress(address _newmarketingAddress) public onlyOwner {
596         _marketingAddress = payable(_newmarketingAddress);
597     }
598 
599 
600 }