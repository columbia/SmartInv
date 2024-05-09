1 // SPDX-License-Identifier: Unlicensed
2 
3 //     Website: https://0xfreelance.io
4 //    Telegram: https://t.me/ZeroXFreelance
5 //     Twitter: https://twitter.com/ZeroXFreelance
6 
7 pragma solidity ^0.8.15;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
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
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93 
94     function sub(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103 
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110         return c;
111     }
112 
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
125     }
126 }
127 
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 }
133 
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint256 amountIn,
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external;
142 
143     function factory() external pure returns (address);
144 
145     function WETH() external pure returns (address);
146 
147     function addLiquidityETH(
148         address token,
149         uint256 amountTokenDesired,
150         uint256 amountTokenMin,
151         uint256 amountETHMin,
152         address to,
153         uint256 deadline
154     )
155         external
156         payable
157         returns (
158             uint256 amountToken,
159             uint256 amountETH,
160             uint256 liquidity
161         );
162 }
163 
164 contract FREELANCE is Context, IERC20, Ownable {
165     using SafeMath for uint256;
166 
167     string private constant _name = "0xFreelance";
168     string private constant _symbol = "0xFree";
169     uint8 private constant _decimals = 9;
170 
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 1000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179 
180     //Buy Fee
181     uint256 private _redisFeeOnBuy = 0;
182     uint256 private _taxFeeOnBuy = 20;
183 
184     //Sell Fee
185     uint256 private _redisFeeOnSell = 0;
186     uint256 private _taxFeeOnSell = 40;
187 
188     //Original Fee
189     uint256 private _redisFee = _redisFeeOnSell;
190     uint256 private _taxFee = _taxFeeOnSell;
191 
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194 
195     mapping(address => bool) public bots;
196     mapping(address => uint256) private cooldown;
197 
198     address payable private _developmentAddress =
199         payable(0x154588ecA8f49591651A8D6666b5003457D0b47a);
200     address payable private _marketingAddress =
201         payable(0x154588ecA8f49591651A8D6666b5003457D0b47a);
202 
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205 
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209 
210     uint256 public _maxTxAmount = 20000 * 10**9; //
211     uint256 public _maxWalletSize = 20000 * 10**9; //
212     uint256 public _swapTokensAtAmount = 5000 * 10**9; //
213 
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap() {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220 
221     constructor() {
222         _rOwned[_msgSender()] = _rTotal;
223 
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
225             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
226         );
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230 
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_developmentAddress] = true;
234         _isExcludedFromFee[_marketingAddress] = true;
235 
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238 
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242 
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246 
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250 
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254 
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258 
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267 
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276 
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302 
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315 
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318 
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321 
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325 
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330 
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350 
351         if (from != owner() && to != owner()) {
352             //Trade start check
353             if (!tradingOpen) {
354                 require(
355                     from == owner(),
356                     "TOKEN: This account cannot send tokens until trading is enabled"
357                 );
358             }
359 
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361             require(
362                 !bots[from] && !bots[to],
363                 "TOKEN: Your account is blacklisted!"
364             );
365 
366             if (to != uniswapV2Pair) {
367                 require(
368                     balanceOf(to) + amount < _maxWalletSize,
369                     "TOKEN: Balance exceeds wallet size!"
370                 );
371             }
372 
373             uint256 contractTokenBalance = balanceOf(address(this));
374             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
375 
376             if (contractTokenBalance >= _maxTxAmount) {
377                 contractTokenBalance = _maxTxAmount;
378             }
379 
380             if (
381                 canSwap &&
382                 !inSwap &&
383                 from != uniswapV2Pair &&
384                 swapEnabled &&
385                 !_isExcludedFromFee[from] &&
386                 !_isExcludedFromFee[to]
387             ) {
388                 swapTokensForEth(contractTokenBalance);
389                 uint256 contractETHBalance = address(this).balance;
390                 if (contractETHBalance > 0) {
391                     sendETHToFee(address(this).balance);
392                 }
393             }
394         }
395 
396         bool takeFee = true;
397 
398         //Transfer Tokens
399         if (
400             (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
401             (from != uniswapV2Pair && to != uniswapV2Pair)
402         ) {
403             takeFee = false;
404         } else {
405             //Set Fee for Buys
406             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnBuy;
408                 _taxFee = _taxFeeOnBuy;
409             }
410 
411             //Set Fee for Sells
412             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
413                 _redisFee = _redisFeeOnSell;
414                 _taxFee = _taxFeeOnSell;
415             }
416         }
417 
418         _tokenTransfer(from, to, amount, takeFee);
419     }
420 
421     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
422         address[] memory path = new address[](2);
423         path[0] = address(this);
424         path[1] = uniswapV2Router.WETH();
425         _approve(address(this), address(uniswapV2Router), tokenAmount);
426         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
427             tokenAmount,
428             0,
429             path,
430             address(this),
431             block.timestamp
432         );
433     }
434 
435     function sendETHToFee(uint256 amount) private {
436         _developmentAddress.transfer(amount.div(2));
437         _marketingAddress.transfer(amount.div(2));
438     }
439 
440     function setTrading(bool _tradingOpen) public onlyOwner {
441         tradingOpen = _tradingOpen;
442     }
443 
444     function manualswap() external {
445         require(
446             _msgSender() == _developmentAddress ||
447                 _msgSender() == _marketingAddress
448         );
449         uint256 contractBalance = balanceOf(address(this));
450         swapTokensForEth(contractBalance);
451     }
452 
453     function manualsend() external {
454         require(
455             _msgSender() == _developmentAddress ||
456                 _msgSender() == _marketingAddress
457         );
458         uint256 contractETHBalance = address(this).balance;
459         sendETHToFee(contractETHBalance);
460     }
461 
462     function blockBots(address[] memory bots_) public onlyOwner {
463         for (uint256 i = 0; i < bots_.length; i++) {
464             bots[bots_[i]] = true;
465         }
466     }
467 
468     function unblockBot(address notbot) public onlyOwner {
469         bots[notbot] = false;
470     }
471 
472     function _tokenTransfer(
473         address sender,
474         address recipient,
475         uint256 amount,
476         bool takeFee
477     ) private {
478         if (!takeFee) removeAllFee();
479         _transferStandard(sender, recipient, amount);
480         if (!takeFee) restoreAllFee();
481     }
482 
483     function _transferStandard(
484         address sender,
485         address recipient,
486         uint256 tAmount
487     ) private {
488         (
489             uint256 rAmount,
490             uint256 rTransferAmount,
491             uint256 rFee,
492             uint256 tTransferAmount,
493             uint256 tFee,
494             uint256 tTeam
495         ) = _getValues(tAmount);
496         _rOwned[sender] = _rOwned[sender].sub(rAmount);
497         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
498         _takeTeam(tTeam);
499         _reflectFee(rFee, tFee);
500         emit Transfer(sender, recipient, tTransferAmount);
501     }
502 
503     function _takeTeam(uint256 tTeam) private {
504         uint256 currentRate = _getRate();
505         uint256 rTeam = tTeam.mul(currentRate);
506         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
507     }
508 
509     function _reflectFee(uint256 rFee, uint256 tFee) private {
510         _rTotal = _rTotal.sub(rFee);
511         _tFeeTotal = _tFeeTotal.add(tFee);
512     }
513 
514     receive() external payable {}
515 
516     function _getValues(uint256 tAmount)
517         private
518         view
519         returns (
520             uint256,
521             uint256,
522             uint256,
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
529             tAmount,
530             _redisFee,
531             _taxFee
532         );
533         uint256 currentRate = _getRate();
534         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
535             tAmount,
536             tFee,
537             tTeam,
538             currentRate
539         );
540 
541         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
542     }
543 
544     function _getTValues(
545         uint256 tAmount,
546         uint256 redisFee,
547         uint256 taxFee
548     )
549         private
550         pure
551         returns (
552             uint256,
553             uint256,
554             uint256
555         )
556     {
557         uint256 tFee = tAmount.mul(redisFee).div(100);
558         uint256 tTeam = tAmount.mul(taxFee).div(100);
559         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
560 
561         return (tTransferAmount, tFee, tTeam);
562     }
563 
564     function _getRValues(
565         uint256 tAmount,
566         uint256 tFee,
567         uint256 tTeam,
568         uint256 currentRate
569     )
570         private
571         pure
572         returns (
573             uint256,
574             uint256,
575             uint256
576         )
577     {
578         uint256 rAmount = tAmount.mul(currentRate);
579         uint256 rFee = tFee.mul(currentRate);
580         uint256 rTeam = tTeam.mul(currentRate);
581         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
582 
583         return (rAmount, rTransferAmount, rFee);
584     }
585 
586     function _getRate() private view returns (uint256) {
587         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
588 
589         return rSupply.div(tSupply);
590     }
591 
592     function _getCurrentSupply() private view returns (uint256, uint256) {
593         uint256 rSupply = _rTotal;
594         uint256 tSupply = _tTotal;
595         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
596 
597         return (rSupply, tSupply);
598     }
599 
600     function setFee(
601         uint256 redisFeeOnBuy,
602         uint256 redisFeeOnSell,
603         uint256 taxFeeOnBuy,
604         uint256 taxFeeOnSell
605     ) public onlyOwner {
606         _redisFeeOnBuy = redisFeeOnBuy;
607         _redisFeeOnSell = redisFeeOnSell;
608 
609         _taxFeeOnBuy = taxFeeOnBuy;
610         _taxFeeOnSell = taxFeeOnSell;
611     }
612 
613     //Set MAx transaction
614     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
615         _maxTxAmount = maxTxAmount;
616     }
617 
618     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
619         _maxWalletSize = maxWalletSize;
620     }
621 }