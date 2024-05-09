1 /*
2 
3 Shuchu stands for Focus
4 
5 www.shuchueth.com
6 twitter.com/shuchueth
7 t.me/shuchuportal
8 shuchu.gitbook.io/shuchu-whitepaper-v1.0/introduction/the-vision
9 
10 3% tax for marketing, development, buybacks and LP
11 
12 Read our whitepaper for more information
13 
14 The DeFi space is in trouble. 
15 Hundreds of tokens are launching every day and investors lose thousands of dollars jumping from project to project. 
16 Influencers are promoting a new token every 10 minutes. 
17 If 2022 has taught us anything, it is the fact that we have to come together and focus on one specific project to generate successes in this market. 
18 Shuchu is the Japanese word for focus, and that's what we are all about. 
19 Uniting the DeFi investors and influencers that survived the bear market to create one token that we can all focus on. 
20 Let's forget about the 100 rugs and scams launching every day, focus on Shuchu and make the first blue chip Ethereum project of 2023.
21 Building several utilities along the way.
22 
23 */
24 
25 // SPDX-License-Identifier: UNLICENSED
26 pragma solidity ^0.8.4;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address sender,
47         address recipient,
48         uint256 amount
49     ) external returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(
53         address indexed owner,
54         address indexed spender,
55         uint256 value
56     );
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     constructor() {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 
93 }
94 
95 library SafeMath {
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113         return c;
114     }
115 
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118             return 0;
119         }
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     function div(
130         uint256 a,
131         uint256 b,
132         string memory errorMessage
133     ) internal pure returns (uint256) {
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         return c;
137     }
138 }
139 
140 interface IUniswapV2Factory {
141     function createPair(address tokenA, address tokenB)
142         external
143         returns (address pair);
144 }
145 
146 interface IUniswapV2Router02 {
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint256 amountIn,
149         uint256 amountOutMin,
150         address[] calldata path,
151         address to,
152         uint256 deadline
153     ) external;
154 
155     function factory() external pure returns (address);
156 
157     function WETH() external pure returns (address);
158 
159     function addLiquidityETH(
160         address token,
161         uint256 amountTokenDesired,
162         uint256 amountTokenMin,
163         uint256 amountETHMin,
164         address to,
165         uint256 deadline
166     )
167         external
168         payable
169         returns (
170             uint256 amountToken,
171             uint256 amountETH,
172             uint256 liquidity
173         );
174 }
175 
176 contract SHUCHU is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
177 
178     using SafeMath for uint256;
179 
180     string private constant _name = "Shuchu";//////////////////////////
181     string private constant _symbol = "SHUCHU";//////////////////////////////////////////////////////////////////////////
182     uint8 private constant _decimals = 9;
183 
184     mapping(address => uint256) private _rOwned;
185     mapping(address => uint256) private _tOwned;
186     mapping(address => mapping(address => uint256)) private _allowances;
187     mapping(address => bool) private _isExcludedFromFee;
188     uint256 private constant MAX = ~uint256(0);
189     uint256 private constant _tTotal = 10000000 * 10**9;
190     uint256 private _rTotal = (MAX - (MAX % _tTotal));
191     uint256 private _tFeeTotal;
192 
193     //Buy Fee
194     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
195     uint256 private _taxFeeOnBuy = 3;//////////////////////////////////////////////////////////////////////
196 
197     //Sell Fee
198     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
199     uint256 private _taxFeeOnSell = 3;/////////////////////////////////////////////////////////////////////
200 
201     //Original Fee
202     uint256 private _redisFee = _redisFeeOnSell;
203     uint256 private _taxFee = _taxFeeOnSell;
204 
205     uint256 private _previousredisFee = _redisFee;
206     uint256 private _previoustaxFee = _taxFee;
207 
208     mapping(address => bool) public bots;
209     mapping(address => uint256) private cooldown;
210 
211     address payable private _developmentAddress = payable(0xD30c221A75c3c95503a31932Ed04A3AE79925842);/////////////////////////////////////////////////
212     address payable private _marketingAddress = payable(0x7DB6d337d2183aE52eCe831d098cc20f4736dCB9);///////////////////////////////////////////////////
213 
214     IUniswapV2Router02 public uniswapV2Router;
215     address public uniswapV2Pair;
216 
217     bool private tradingOpen;
218     bool private inSwap = false;
219     bool private swapEnabled = true;
220 
221     uint256 public _maxTxAmount = 200000 * 10**9; //2%
222     uint256 public _maxWalletSize = 200000 * 10**9; //2%
223     uint256 public _swapTokensAtAmount = 40000 * 10**9; //.4%
224 
225     event MaxTxAmountUpdated(uint256 _maxTxAmount);
226     modifier lockTheSwap {
227         inSwap = true;
228         _;
229         inSwap = false;
230     }
231 
232     constructor() {
233 
234         _rOwned[_msgSender()] = _rTotal;
235 
236         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
237         uniswapV2Router = _uniswapV2Router;
238         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
239             .createPair(address(this), _uniswapV2Router.WETH());
240 
241         _isExcludedFromFee[owner()] = true;
242         _isExcludedFromFee[address(this)] = true;
243         _isExcludedFromFee[_developmentAddress] = true;
244         _isExcludedFromFee[_marketingAddress] = true;
245 
246 
247 
248 
249         emit Transfer(address(0), _msgSender(), _tTotal);
250     }
251 
252     function name() public pure returns (string memory) {
253         return _name;
254     }
255 
256     function symbol() public pure returns (string memory) {
257         return _symbol;
258     }
259 
260     function decimals() public pure returns (uint8) {
261         return _decimals;
262     }
263 
264     function totalSupply() public pure override returns (uint256) {
265         return _tTotal;
266     }
267 
268     function balanceOf(address account) public view override returns (uint256) {
269         return tokenFromReflection(_rOwned[account]);
270     }
271 
272     function transfer(address recipient, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280 
281     function allowance(address owner, address spender)
282         public
283         view
284         override
285         returns (uint256)
286     {
287         return _allowances[owner][spender];
288     }
289 
290     function approve(address spender, uint256 amount)
291         public
292         override
293         returns (bool)
294     {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(
306             sender,
307             _msgSender(),
308             _allowances[sender][_msgSender()].sub(
309                 amount,
310                 "ERC20: transfer amount exceeds allowance"
311             )
312         );
313         return true;
314     }
315 
316     function tokenFromReflection(uint256 rAmount)
317         private
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328 
329     function removeAllFee() private {
330         if (_redisFee == 0 && _taxFee == 0) return;
331 
332         _previousredisFee = _redisFee;
333         _previoustaxFee = _taxFee;
334 
335         _redisFee = 0;
336         _taxFee = 0;
337     }
338 
339     function restoreAllFee() private {
340         _redisFee = _previousredisFee;
341         _taxFee = _previoustaxFee;
342     }
343 
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) private {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354 
355     function _transfer(
356         address from,
357         address to,
358         uint256 amount
359     ) private {
360         require(from != address(0), "ERC20: transfer from the zero address");
361         require(to != address(0), "ERC20: transfer to the zero address");
362         require(amount > 0, "Transfer amount must be greater than zero");
363 
364         if (from != owner() && to != owner()) {
365 
366             //Trade start check
367             if (!tradingOpen) {
368                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
369             }
370 
371             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
372             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
373 
374             if(to != uniswapV2Pair) {
375                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
376             }
377 
378             uint256 contractTokenBalance = balanceOf(address(this));
379             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
380 
381             if(contractTokenBalance >= _maxTxAmount)
382             {
383                 contractTokenBalance = _maxTxAmount;
384             }
385 
386             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
387                 swapTokensForEth(contractTokenBalance);
388                 uint256 contractETHBalance = address(this).balance;
389                 if (contractETHBalance > 0) {
390                     sendETHToFee(address(this).balance);
391                 }
392             }
393         }
394 
395         bool takeFee = true;
396 
397         //Transfer Tokens
398         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
399             takeFee = false;
400         } else {
401 
402             //Set Fee for Buys
403             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
404                 _redisFee = _redisFeeOnBuy;
405                 _taxFee = _taxFeeOnBuy;
406             }
407 
408             //Set Fee for Sells
409             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
410                 _redisFee = _redisFeeOnSell;
411                 _taxFee = _taxFeeOnSell;
412             }
413 
414         }
415 
416         _tokenTransfer(from, to, amount, takeFee);
417     }
418 
419     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = uniswapV2Router.WETH();
423         _approve(address(this), address(uniswapV2Router), tokenAmount);
424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
425             tokenAmount,
426             0,
427             path,
428             address(this),
429             block.timestamp
430         );
431     }
432 
433     function sendETHToFee(uint256 amount) private {
434         _developmentAddress.transfer(amount.div(2));
435         _marketingAddress.transfer(amount.div(2));
436     }
437 
438     function setTrading(bool _tradingOpen) public onlyOwner {
439         tradingOpen = _tradingOpen;
440     }
441 
442     function manualswap() external {
443         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
444         uint256 contractBalance = balanceOf(address(this));
445         swapTokensForEth(contractBalance);
446     }
447 
448     function manualsend() external {
449         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
450         uint256 contractETHBalance = address(this).balance;
451         sendETHToFee(contractETHBalance);
452     }
453 
454     function blockBots(address[] memory bots_) public onlyOwner {
455         for (uint256 i = 0; i < bots_.length; i++) {
456             bots[bots_[i]] = true;
457         }
458     }
459 
460     function unblockBot(address notbot) public onlyOwner {
461         bots[notbot] = false;
462     }
463 
464     function _tokenTransfer(
465         address sender,
466         address recipient,
467         uint256 amount,
468         bool takeFee
469     ) private {
470         if (!takeFee) removeAllFee();
471         _transferStandard(sender, recipient, amount);
472         if (!takeFee) restoreAllFee();
473     }
474 
475     function _transferStandard(
476         address sender,
477         address recipient,
478         uint256 tAmount
479     ) private {
480         (
481             uint256 rAmount,
482             uint256 rTransferAmount,
483             uint256 rFee,
484             uint256 tTransferAmount,
485             uint256 tFee,
486             uint256 tTeam
487         ) = _getValues(tAmount);
488         _rOwned[sender] = _rOwned[sender].sub(rAmount);
489         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
490         _takeTeam(tTeam);
491         _reflectFee(rFee, tFee);
492         emit Transfer(sender, recipient, tTransferAmount);
493     }
494 
495     function _takeTeam(uint256 tTeam) private {
496         uint256 currentRate = _getRate();
497         uint256 rTeam = tTeam.mul(currentRate);
498         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
499     }
500 
501     function _reflectFee(uint256 rFee, uint256 tFee) private {
502         _rTotal = _rTotal.sub(rFee);
503         _tFeeTotal = _tFeeTotal.add(tFee);
504     }
505 
506     receive() external payable {}
507 
508     function _getValues(uint256 tAmount)
509         private
510         view
511         returns (
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
521             _getTValues(tAmount, _redisFee, _taxFee);
522         uint256 currentRate = _getRate();
523         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
524             _getRValues(tAmount, tFee, tTeam, currentRate);
525 
526         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
527     }
528 
529     function _getTValues(
530         uint256 tAmount,
531         uint256 redisFee,
532         uint256 taxFee
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 tFee = tAmount.mul(redisFee).div(100);
543         uint256 tTeam = tAmount.mul(taxFee).div(100);
544         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
545 
546         return (tTransferAmount, tFee, tTeam);
547     }
548 
549     function _getRValues(
550         uint256 tAmount,
551         uint256 tFee,
552         uint256 tTeam,
553         uint256 currentRate
554     )
555         private
556         pure
557         returns (
558             uint256,
559             uint256,
560             uint256
561         )
562     {
563         uint256 rAmount = tAmount.mul(currentRate);
564         uint256 rFee = tFee.mul(currentRate);
565         uint256 rTeam = tTeam.mul(currentRate);
566         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
567 
568         return (rAmount, rTransferAmount, rFee);
569     }
570 
571     function _getRate() private view returns (uint256) {
572         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
573 
574         return rSupply.div(tSupply);
575     }
576 
577     function _getCurrentSupply() private view returns (uint256, uint256) {
578         uint256 rSupply = _rTotal;
579         uint256 tSupply = _tTotal;
580         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
581 
582         return (rSupply, tSupply);
583     }
584 
585     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
586         _redisFeeOnBuy = redisFeeOnBuy;
587         _redisFeeOnSell = redisFeeOnSell;
588 
589         _taxFeeOnBuy = taxFeeOnBuy;
590         _taxFeeOnSell = taxFeeOnSell;
591     }
592 
593     //Set minimum tokens required to swap.
594     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
595         _swapTokensAtAmount = swapTokensAtAmount;
596     }
597 
598     //Set minimum tokens required to swap.
599     function toggleSwap(bool _swapEnabled) public onlyOwner {
600         swapEnabled = _swapEnabled;
601     }
602 
603 
604     //Set MAx transaction
605     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
606         _maxTxAmount = maxTxAmount;
607     }
608 
609     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
610         _maxWalletSize = maxWalletSize;
611     }
612 
613     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
614         for(uint256 i = 0; i < accounts.length; i++) {
615             _isExcludedFromFee[accounts[i]] = excluded;
616         }
617     }
618 }