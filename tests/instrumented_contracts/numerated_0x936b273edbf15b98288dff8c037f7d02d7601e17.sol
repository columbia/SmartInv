1 /**
2 
3 Robert F Kennedy Jr
4 $RFK
5 
6 8 888888888o.   8 8888888888   8 8888     ,88' 
7 8 8888    `88.  8 8888         8 8888    ,88'  
8 8 8888     `88  8 8888         8 8888   ,88'   
9 8 8888     ,88  8 8888         8 8888  ,88'    
10 8 8888.   ,88'  8 888888888888 8 8888 ,88'     
11 8 888888888P'   8 8888         8 8888 88'      
12 8 8888`8b       8 8888         8 888888<       
13 8 8888 `8b.     8 8888         8 8888 `Y8.     
14 8 8888   `8b.   8 8888         8 8888   `Y8.   
15 8 8888     `88. 8 8888         8 8888     `Y8. 
16 
17 Telegram: https://t.me/rfketh
18 Website: https://robertfkennedyjr.vip/
19 Twitter: https://twitter.com/RFKeth
20 Medium: https://medium.com/@RobertFKennedyJrERC
21 
22 */
23 
24 // SPDX-License-Identifier: Unlicensed
25 pragma solidity ^0.8.9;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     constructor() {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 
92 }
93 
94 library SafeMath {
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98         return c;
99     }
100 
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104 
105     function sub(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112         return c;
113     }
114 
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) {
117             return 0;
118         }
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123 
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     function div(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         return c;
136     }
137 }
138 
139 interface IUniswapV2Factory {
140     function createPair(address tokenA, address tokenB)
141         external
142         returns (address pair);
143 }
144 
145 interface IUniswapV2Router02 {
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint256 amountIn,
148         uint256 amountOutMin,
149         address[] calldata path,
150         address to,
151         uint256 deadline
152     ) external;
153 
154     function factory() external pure returns (address);
155 
156     function WETH() external pure returns (address);
157 
158     function addLiquidityETH(
159         address token,
160         uint256 amountTokenDesired,
161         uint256 amountTokenMin,
162         uint256 amountETHMin,
163         address to,
164         uint256 deadline
165     )
166         external
167         payable
168         returns (
169             uint256 amountToken,
170             uint256 amountETH,
171             uint256 liquidity
172         );
173 }
174 
175 contract RFK is Context, IERC20, Ownable {
176 
177     using SafeMath for uint256;
178 
179     string private constant _name = unicode"Robert F Kennedy Jr";
180     string private constant _symbol = unicode"RFK";
181     uint8 private constant _decimals = 9;
182 
183     mapping(address => uint256) private _rOwned;
184     mapping(address => uint256) private _tOwned;
185     mapping(address => mapping(address => uint256)) private _allowances;
186     mapping(address => bool) private _isExcludedFromFee;
187     uint256 private constant MAX = ~uint256(0);
188     uint256 private constant _tTotal = 1000000000 * 10**9;
189     uint256 private _rTotal = (MAX - (MAX % _tTotal));
190     uint256 private _tFeeTotal;
191     uint256 private _redisFeeOnBuy = 0;
192     uint256 private _taxFeeOnBuy = 20;
193     uint256 private _redisFeeOnSell = 0;
194     uint256 private _taxFeeOnSell = 80;
195 
196     //Original Fee
197     uint256 private _redisFee = _redisFeeOnSell;
198     uint256 private _taxFee = _taxFeeOnSell;
199 
200     uint256 private _previousredisFee = _redisFee;
201     uint256 private _previoustaxFee = _taxFee;
202 
203     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
204     address payable private _developmentAddress = payable(0xC4BEC9A06e73fd3e21f23A2d784FD2aeD3818a69);
205     address payable private _marketingAddress = payable(0xC4BEC9A06e73fd3e21f23A2d784FD2aeD3818a69);
206 
207     IUniswapV2Router02 public uniswapV2Router;
208     address public uniswapV2Pair;
209 
210     bool private tradingOpen;
211     bool private inSwap = false;
212     bool private swapEnabled = true;
213 
214     uint256 public _maxTxAmount = 20000000 * 10**9;
215     uint256 public _maxWalletSize = 20000000 * 10**9;
216     uint256 public _swapTokensAtAmount = 10000 * 10**9;
217 
218     event MaxTxAmountUpdated(uint256 _maxTxAmount);
219     modifier lockTheSwap {
220         inSwap = true;
221         _;
222         inSwap = false;
223     }
224 
225     constructor() {
226 
227         _rOwned[_msgSender()] = _rTotal;
228 
229         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
230         uniswapV2Router = _uniswapV2Router;
231         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
232             .createPair(address(this), _uniswapV2Router.WETH());
233 
234         _isExcludedFromFee[owner()] = true;
235         _isExcludedFromFee[address(this)] = true;
236         _isExcludedFromFee[_developmentAddress] = true;
237         _isExcludedFromFee[_marketingAddress] = true;
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
354         if (from != owner() && to != owner()) {
355 
356             //Trade start check
357             if (!tradingOpen) {
358                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
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
423     function sendETHToFee(uint256 amount) private {
424         _marketingAddress.transfer(amount);
425     }
426 
427     function setTrading(bool _tradingOpen) public onlyOwner {
428         tradingOpen = _tradingOpen;
429     }
430 
431     function manualswap() external {
432         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
433         uint256 contractBalance = balanceOf(address(this));
434         swapTokensForEth(contractBalance);
435     }
436 
437     function manualsend() external {
438         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
439         uint256 contractETHBalance = address(this).balance;
440         sendETHToFee(contractETHBalance);
441     }
442 
443     function blockBots(address[] memory bots_) public onlyOwner {
444         for (uint256 i = 0; i < bots_.length; i++) {
445             bots[bots_[i]] = true;
446         }
447     }
448 
449     function unblockBot(address notbot) public onlyOwner {
450         bots[notbot] = false;
451     }
452 
453     function _tokenTransfer(
454         address sender,
455         address recipient,
456         uint256 amount,
457         bool takeFee
458     ) private {
459         if (!takeFee) removeAllFee();
460         _transferStandard(sender, recipient, amount);
461         if (!takeFee) restoreAllFee();
462     }
463 
464     function _transferStandard(
465         address sender,
466         address recipient,
467         uint256 tAmount
468     ) private {
469         (
470             uint256 rAmount,
471             uint256 rTransferAmount,
472             uint256 rFee,
473             uint256 tTransferAmount,
474             uint256 tFee,
475             uint256 tTeam
476         ) = _getValues(tAmount);
477         _rOwned[sender] = _rOwned[sender].sub(rAmount);
478         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
479         _takeTeam(tTeam);
480         _reflectFee(rFee, tFee);
481         emit Transfer(sender, recipient, tTransferAmount);
482     }
483 
484     function _takeTeam(uint256 tTeam) private {
485         uint256 currentRate = _getRate();
486         uint256 rTeam = tTeam.mul(currentRate);
487         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
488     }
489 
490     function _reflectFee(uint256 rFee, uint256 tFee) private {
491         _rTotal = _rTotal.sub(rFee);
492         _tFeeTotal = _tFeeTotal.add(tFee);
493     }
494 
495     receive() external payable {}
496 
497     function _getValues(uint256 tAmount)
498         private
499         view
500         returns (
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
510             _getTValues(tAmount, _redisFee, _taxFee);
511         uint256 currentRate = _getRate();
512         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
513             _getRValues(tAmount, tFee, tTeam, currentRate);
514         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
515     }
516 
517     function _getTValues(
518         uint256 tAmount,
519         uint256 redisFee,
520         uint256 taxFee
521     )
522         private
523         pure
524         returns (
525             uint256,
526             uint256,
527             uint256
528         )
529     {
530         uint256 tFee = tAmount.mul(redisFee).div(100);
531         uint256 tTeam = tAmount.mul(taxFee).div(100);
532         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
533         return (tTransferAmount, tFee, tTeam);
534     }
535 
536     function _getRValues(
537         uint256 tAmount,
538         uint256 tFee,
539         uint256 tTeam,
540         uint256 currentRate
541     )
542         private
543         pure
544         returns (
545             uint256,
546             uint256,
547             uint256
548         )
549     {
550         uint256 rAmount = tAmount.mul(currentRate);
551         uint256 rFee = tFee.mul(currentRate);
552         uint256 rTeam = tTeam.mul(currentRate);
553         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
554         return (rAmount, rTransferAmount, rFee);
555     }
556 
557     function _getRate() private view returns (uint256) {
558         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
559         return rSupply.div(tSupply);
560     }
561 
562     function _getCurrentSupply() private view returns (uint256, uint256) {
563         uint256 rSupply = _rTotal;
564         uint256 tSupply = _tTotal;
565         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
566         return (rSupply, tSupply);
567     }
568 
569     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
570         _redisFeeOnBuy = redisFeeOnBuy;
571         _redisFeeOnSell = redisFeeOnSell;
572         _taxFeeOnBuy = taxFeeOnBuy;
573         _taxFeeOnSell = taxFeeOnSell;
574     }
575 
576     //Set minimum tokens required to swap.
577     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
578         _swapTokensAtAmount = swapTokensAtAmount;
579     }
580 
581     //Set minimum tokens required to swap.
582     function toggleSwap(bool _swapEnabled) public onlyOwner {
583         swapEnabled = _swapEnabled;
584     }
585 
586     //Set maximum transaction
587     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
588         _maxTxAmount = maxTxAmount;
589     }
590 
591     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
592         _maxWalletSize = maxWalletSize;
593     }
594 
595     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
596         for(uint256 i = 0; i < accounts.length; i++) {
597             _isExcludedFromFee[accounts[i]] = excluded;
598         }
599     }
600 
601 }