1 /*
2 
3 // AIGHT - Everything is Aight
4 // WEBSITE - https://www.aighttoken.com
5 // TWITTER - https://twitter.com/Aight_Token
6 // TELEGRAM - https://t.me/Aight_Token
7 
8 // Don't worry, you AIGHT!
9 
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 pragma solidity ^0.8.16;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 
80 }
81 
82 library SafeMath {
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     function div(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         return c;
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB)
129         external
130         returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint256 amountIn,
136         uint256 amountOutMin,
137         address[] calldata path,
138         address to,
139         uint256 deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 }
162 
163 contract AIGHT is Context, IERC20, Ownable {
164 
165     using SafeMath for uint256;
166 
167     string private constant _name = "Everything is Aight";
168     string private constant _symbol = "AIGHT";
169     uint8 private constant _decimals = 9;
170 
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 1000000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 private _redisFeeOnBuy = 0;
180     uint256 private _taxFeeOnBuy = 18;
181     uint256 private _redisFeeOnSell = 0;
182     uint256 private _taxFeeOnSell = 18;
183 
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190 
191     mapping(address => bool) public bots; 
192     mapping (address => uint256) public _buyMap;
193     mapping (address => bool) public preTrader;
194     address private developmentAddress;
195     address private marketingAddress;
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203 
204     uint256 public _maxTxAmount = 20000000 * 10**9;
205     uint256 public _maxWalletSize = 30000000 * 10**9; 
206     uint256 public _swapTokensAtAmount = 10000 * 10**9;
207 
208     struct Distribution {
209         uint256 development;
210         uint256 marketing;
211     }
212 
213     Distribution public distribution;
214 
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221 
222     constructor(address developmentAddr, address marketingAddr) {
223         developmentAddress = developmentAddr;
224         marketingAddress = marketingAddr;
225         _rOwned[_msgSender()] = _rTotal;
226 
227         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
230             .createPair(address(this), _uniswapV2Router.WETH());
231 
232         _isExcludedFromFee[owner()] = true;
233         _isExcludedFromFee[address(this)] = true;
234         _isExcludedFromFee[marketingAddress] = true;
235         _isExcludedFromFee[developmentAddress] = true;
236 
237         distribution = Distribution(37, 38);
238 
239         emit Transfer(address(0), _msgSender(), _tTotal);
240     }
241 
242     function name() public pure returns (string memory) {
243         return _name;
244     }
245 
246     function symbol() public pure returns (string memory) {
247         return _symbol;
248     }
249 
250     function decimals() public pure returns (uint8) {
251         return _decimals;
252     }
253 
254     function totalSupply() public pure override returns (uint256) {
255         return _tTotal;
256     }
257 
258     function balanceOf(address account) public view override returns (uint256) {
259         return tokenFromReflection(_rOwned[account]);
260     }
261 
262     function transfer(address recipient, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     function allowance(address owner, address spender)
272         public
273         view
274         override
275         returns (uint256)
276     {
277         return _allowances[owner][spender];
278     }
279 
280     function approve(address spender, uint256 amount)
281         public
282         override
283         returns (bool)
284     {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288 
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) public override returns (bool) {
294         _transfer(sender, recipient, amount);
295         _approve(
296             sender,
297             _msgSender(),
298             _allowances[sender][_msgSender()].sub(
299                 amount,
300                 "ERC20: transfer amount exceeds allowance"
301             )
302         );
303         return true;
304     }
305 
306     function tokenFromReflection(uint256 rAmount)
307         private
308         view
309         returns (uint256)
310     {
311         require(
312             rAmount <= _rTotal,
313             "Amount must be less than total reflections"
314         );
315         uint256 currentRate = _getRate();
316         return rAmount.div(currentRate);
317     }
318 
319     function removeAllFee() private {
320         if (_redisFee == 0 && _taxFee == 0) return;
321 
322         _previousredisFee = _redisFee;
323         _previoustaxFee = _taxFee;
324 
325         _redisFee = 0;
326         _taxFee = 0;
327     }
328 
329     function restoreAllFee() private {
330         _redisFee = _previousredisFee;
331         _taxFee = _previoustaxFee;
332     }
333 
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) private {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344 
345     function _transfer(
346         address from,
347         address to,
348         uint256 amount
349     ) private {
350         require(from != address(0), "ERC20: transfer from the zero address");
351         require(to != address(0), "ERC20: transfer to the zero address");
352         require(amount > 0, "Transfer amount must be greater than zero");
353 
354         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
355 
356             //Trade start check
357             if (!tradingOpen) {
358                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
359             }
360 
361             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
362             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
363 
364             if(to != uniswapV2Pair) {
365                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
366             }
367 
368             uint256 contractTokenBalance = balanceOf(address(this));
369             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
370 
371             if(contractTokenBalance >= _maxTxAmount)
372             {
373                 contractTokenBalance = _maxTxAmount;
374             }
375 
376             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
377                 swapTokensForEth(contractTokenBalance);
378                 uint256 contractETHBalance = address(this).balance;
379                 if (contractETHBalance > 0) {
380                     sendETHToFee(address(this).balance);
381                 }
382             }
383         }
384 
385         bool takeFee = true;
386 
387         //Transfer Tokens
388         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
389             takeFee = false;
390         } else {
391 
392             //Set Fee for Buys
393             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
394                 _redisFee = _redisFeeOnBuy;
395                 _taxFee = _taxFeeOnBuy;
396             }
397 
398             //Set Fee for Sells
399             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnSell;
401                 _taxFee = _taxFeeOnSell;
402             }
403 
404         }
405 
406         _tokenTransfer(from, to, amount, takeFee);
407     }
408 
409     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
410         address[] memory path = new address[](2);
411         path[0] = address(this);
412         path[1] = uniswapV2Router.WETH();
413         _approve(address(this), address(uniswapV2Router), tokenAmount);
414         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
415             tokenAmount,
416             0,
417             path,
418             address(this),
419             block.timestamp
420         );
421     }
422 
423     function sendETHToFee(uint256 amount) private lockTheSwap {
424         uint256 distributionEth = amount;
425         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
426         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
427         payable(marketingAddress).transfer(marketingShare);
428         payable(developmentAddress).transfer(developmentShare);
429     }
430 
431     function setTrading(bool _tradingOpen) public onlyOwner {
432         tradingOpen = _tradingOpen;
433     }
434 
435     function manualswap() external {
436         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
437         uint256 contractBalance = balanceOf(address(this));
438         swapTokensForEth(contractBalance);
439     }
440 
441     function manualsend() external {
442         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
443         uint256 contractETHBalance = address(this).balance;
444         sendETHToFee(contractETHBalance);
445     }
446 
447     function blockBots(address[] memory bots_) public onlyOwner {
448         for (uint256 i = 0; i < bots_.length; i++) {
449             bots[bots_[i]] = true;
450         }
451     }
452 
453     function unblockBot(address notbot) public onlyOwner {
454         bots[notbot] = false;
455     }
456 
457     function _tokenTransfer(
458         address sender,
459         address recipient,
460         uint256 amount,
461         bool takeFee
462     ) private {
463         if (!takeFee) removeAllFee();
464         _transferStandard(sender, recipient, amount);
465         if (!takeFee) restoreAllFee();
466     }
467 
468     function _transferStandard(
469         address sender,
470         address recipient,
471         uint256 tAmount
472     ) private {
473         (
474             uint256 rAmount,
475             uint256 rTransferAmount,
476             uint256 rFee,
477             uint256 tTransferAmount,
478             uint256 tFee,
479             uint256 tTeam
480         ) = _getValues(tAmount);
481         _rOwned[sender] = _rOwned[sender].sub(rAmount);
482         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
483         _takeTeam(tTeam);
484         _reflectFee(rFee, tFee);
485         emit Transfer(sender, recipient, tTransferAmount);
486     }
487 
488     function setDistribution(uint256 development, uint256 marketing) external onlyOwner {        
489         distribution.development = development;
490         distribution.marketing = marketing;
491     }
492 
493     function _takeTeam(uint256 tTeam) private {
494         uint256 currentRate = _getRate();
495         uint256 rTeam = tTeam.mul(currentRate);
496         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
497     }
498 
499     function _reflectFee(uint256 rFee, uint256 tFee) private {
500         _rTotal = _rTotal.sub(rFee);
501         _tFeeTotal = _tFeeTotal.add(tFee);
502     }
503 
504     receive() external payable {
505     }
506 
507     function _getValues(uint256 tAmount)
508         private
509         view
510         returns (
511             uint256,
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
520             _getTValues(tAmount, _redisFee, _taxFee);
521         uint256 currentRate = _getRate();
522         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
523             _getRValues(tAmount, tFee, tTeam, currentRate);
524         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
525     }
526 
527     function _getTValues(
528         uint256 tAmount,
529         uint256 redisFee,
530         uint256 taxFee
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 tFee = tAmount.mul(redisFee).div(100);
541         uint256 tTeam = tAmount.mul(taxFee).div(100);
542         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
543         return (tTransferAmount, tFee, tTeam);
544     }
545 
546     function _getRValues(
547         uint256 tAmount,
548         uint256 tFee,
549         uint256 tTeam,
550         uint256 currentRate
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTeam = tTeam.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
564         return (rAmount, rTransferAmount, rFee);
565     }
566 
567     function _getRate() private view returns (uint256) {
568         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
569         return rSupply.div(tSupply);
570     }
571 
572     function _getCurrentSupply() private view returns (uint256, uint256) {
573         uint256 rSupply = _rTotal;
574         uint256 tSupply = _tTotal;
575         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
576         return (rSupply, tSupply);
577     }
578 
579     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
580         _redisFeeOnBuy = redisFeeOnBuy;
581         _redisFeeOnSell = redisFeeOnSell;
582         _taxFeeOnBuy = taxFeeOnBuy;
583         _taxFeeOnSell = taxFeeOnSell;
584     }
585 
586     //Set minimum tokens required to swap.
587     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
588         _swapTokensAtAmount = swapTokensAtAmount;
589     }
590 
591     //Set minimum tokens required to swap.
592     function toggleSwap(bool _swapEnabled) public onlyOwner {
593         swapEnabled = _swapEnabled;
594     }
595 
596     //Set maximum transaction
597     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
598         _maxTxAmount = maxTxAmount;
599     }
600 
601     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
602         _maxWalletSize = maxWalletSize;
603     }
604 
605     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
606         for(uint256 i = 0; i < accounts.length; i++) {
607             _isExcludedFromFee[accounts[i]] = excluded;
608         }
609     }
610 
611     function allowPreTrading(address[] calldata accounts) public onlyOwner {
612         for(uint256 i = 0; i < accounts.length; i++) {
613                  preTrader[accounts[i]] = true;
614         }
615     }
616 
617     function removePreTrading(address[] calldata accounts) public onlyOwner {
618         for(uint256 i = 0; i < accounts.length; i++) {
619                  delete preTrader[accounts[i]];
620         }
621     }
622 }