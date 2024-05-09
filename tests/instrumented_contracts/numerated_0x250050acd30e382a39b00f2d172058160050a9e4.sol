1 /**
2                                                 https://k0de.app/                                                                                            
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract Thek0de is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "The $k0de";//////////////////////////
161     string private constant _symbol = "k0de";//////////////////////////////////////////////////////////////////////////
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 10000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172 
173     //Buy Fee
174     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
175     uint256 private _taxFeeOnBuy = 6;//////////////////////////////////////////////////////////////////////
176 
177     //Sell Fee
178     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
179     uint256 private _taxFeeOnSell = 6;/////////////////////////////////////////////////////////////////////
180 
181     //Original Fee
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184 
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187 
188     mapping(address => bool) public bots;
189     mapping(address => uint256) private cooldown;
190 
191     address payable private _developmentAddress = payable(0x525bFCb552b39DcaaDD3D1CEdC4BD252B5dd9c28);/////////////////////////////////////////////////
192     address payable private _marketingAddress = payable(0x525bFCb552b39DcaaDD3D1CEdC4BD252B5dd9c28);///////////////////////////////////////////////////
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 200000 * 10**9; //1%
202     uint256 public _maxWalletSize = 200000 * 10**9; //2%
203     uint256 public _swapTokensAtAmount = 20000 * 10**9; //.4%
204 
205     event MaxTxAmountUpdated(uint256 _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211 
212     constructor() {
213 
214         _rOwned[_msgSender()] = _rTotal;
215 
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219             .createPair(address(this), _uniswapV2Router.WETH());
220 
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_developmentAddress] = true;
224         _isExcludedFromFee[_marketingAddress] = true;
225 
226 
227 
228 
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251 
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269 
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295 
296     function tokenFromReflection(uint256 rAmount)
297         private
298         view
299         returns (uint256)
300     {
301         require(
302             rAmount <= _rTotal,
303             "Amount must be less than total reflections"
304         );
305         uint256 currentRate = _getRate();
306         return rAmount.div(currentRate);
307     }
308 
309     function removeAllFee() private {
310         if (_redisFee == 0 && _taxFee == 0) return;
311 
312         _previousredisFee = _redisFee;
313         _previoustaxFee = _taxFee;
314 
315         _redisFee = 0;
316         _taxFee = 0;
317     }
318 
319     function restoreAllFee() private {
320         _redisFee = _previousredisFee;
321         _taxFee = _previoustaxFee;
322     }
323 
324     function _approve(
325         address owner,
326         address spender,
327         uint256 amount
328     ) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) private {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343 
344         if (from != owner() && to != owner()) {
345 
346             //Trade start check
347             if (!tradingOpen) {
348                 require(from == owner(), "k0de: This account cannot send tokens until trading is enabled");
349             }
350 
351             require(amount <= _maxTxAmount, "k0de: Max Transaction Limit");
352             require(!bots[from] && !bots[to], "k0de: Your account is blacklisted!");
353 
354             if(to != uniswapV2Pair) {
355                 require(balanceOf(to) + amount < _maxWalletSize, "k0de: Balance exceeds wallet size!");
356             }
357 
358             uint256 contractTokenBalance = balanceOf(address(this));
359             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
360 
361             if(contractTokenBalance >= _maxTxAmount)
362             {
363                 contractTokenBalance = _maxTxAmount;
364             }
365 
366             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         }
374 
375         bool takeFee = true;
376 
377         //Transfer Tokens
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381 
382             //Set Fee for Buys
383             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             //Set Fee for Sells
389             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnSell;
391                 _taxFee = _taxFeeOnSell;
392             }
393 
394         }
395 
396         _tokenTransfer(from, to, amount, takeFee);
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
400         address[] memory path = new address[](2);
401         path[0] = address(this);
402         path[1] = uniswapV2Router.WETH();
403         _approve(address(this), address(uniswapV2Router), tokenAmount);
404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
405             tokenAmount,
406             0,
407             path,
408             address(this),
409             block.timestamp
410         );
411     }
412 
413     function sendETHToFee(uint256 amount) private {
414         _developmentAddress.transfer(amount.div(2));
415         _marketingAddress.transfer(amount.div(2));
416     }
417 
418     function setTrading(bool _tradingOpen) public onlyOwner {
419         tradingOpen = _tradingOpen;
420     }
421 
422     function manualswap() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractBalance = balanceOf(address(this));
425         swapTokensForEth(contractBalance);
426     }
427 
428     function manualsend() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractETHBalance = address(this).balance;
431         sendETHToFee(contractETHBalance);
432     }
433 
434     function blockBots(address[] memory bots_) public onlyOwner {
435         for (uint256 i = 0; i < bots_.length; i++) {
436             bots[bots_[i]] = true;
437         }
438     }
439 
440     function unblockBot(address notbot) public onlyOwner {
441         bots[notbot] = false;
442     }
443 
444     function _tokenTransfer(
445         address sender,
446         address recipient,
447         uint256 amount,
448         bool takeFee
449     ) private {
450         if (!takeFee) removeAllFee();
451         _transferStandard(sender, recipient, amount);
452         if (!takeFee) restoreAllFee();
453     }
454 
455     function _transferStandard(
456         address sender,
457         address recipient,
458         uint256 tAmount
459     ) private {
460         (
461             uint256 rAmount,
462             uint256 rTransferAmount,
463             uint256 rFee,
464             uint256 tTransferAmount,
465             uint256 tFee,
466             uint256 tTeam
467         ) = _getValues(tAmount);
468         _rOwned[sender] = _rOwned[sender].sub(rAmount);
469         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
470         _takeTeam(tTeam);
471         _reflectFee(rFee, tFee);
472         emit Transfer(sender, recipient, tTransferAmount);
473     }
474 
475     function _takeTeam(uint256 tTeam) private {
476         uint256 currentRate = _getRate();
477         uint256 rTeam = tTeam.mul(currentRate);
478         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
479     }
480 
481     function _reflectFee(uint256 rFee, uint256 tFee) private {
482         _rTotal = _rTotal.sub(rFee);
483         _tFeeTotal = _tFeeTotal.add(tFee);
484     }
485 
486     receive() external payable {}
487 
488     function _getValues(uint256 tAmount)
489         private
490         view
491         returns (
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
501             _getTValues(tAmount, _redisFee, _taxFee);
502         uint256 currentRate = _getRate();
503         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
504             _getRValues(tAmount, tFee, tTeam, currentRate);
505 
506         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
507     }
508 
509     function _getTValues(
510         uint256 tAmount,
511         uint256 redisFee,
512         uint256 taxFee
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 tFee = tAmount.mul(redisFee).div(100);
523         uint256 tTeam = tAmount.mul(taxFee).div(100);
524         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
525 
526         return (tTransferAmount, tFee, tTeam);
527     }
528 
529     function _getRValues(
530         uint256 tAmount,
531         uint256 tFee,
532         uint256 tTeam,
533         uint256 currentRate
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rFee = tFee.mul(currentRate);
545         uint256 rTeam = tTeam.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
547 
548         return (rAmount, rTransferAmount, rFee);
549     }
550 
551     function _getRate() private view returns (uint256) {
552         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
553 
554         return rSupply.div(tSupply);
555     }
556 
557     function _getCurrentSupply() private view returns (uint256, uint256) {
558         uint256 rSupply = _rTotal;
559         uint256 tSupply = _tTotal;
560         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
561 
562         return (rSupply, tSupply);
563     }
564 
565     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
566         _redisFeeOnBuy = redisFeeOnBuy;
567         _redisFeeOnSell = redisFeeOnSell;
568 
569         _taxFeeOnBuy = taxFeeOnBuy;
570         _taxFeeOnSell = taxFeeOnSell;
571     }
572 
573     //Set minimum tokens required to swap.
574     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
575         _swapTokensAtAmount = swapTokensAtAmount;
576     }
577 
578     //Set minimum tokens required to swap.
579     function toggleSwap(bool _swapEnabled) public onlyOwner {
580         swapEnabled = _swapEnabled;
581     }
582 
583 
584     //Set MAx transaction
585     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
586         _maxTxAmount = maxTxAmount;
587     }
588 
589     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
590         _maxWalletSize = maxWalletSize;
591     }
592 
593     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
594         for(uint256 i = 0; i < accounts.length; i++) {
595             _isExcludedFromFee[accounts[i]] = excluded;
596         }
597     }
598 }