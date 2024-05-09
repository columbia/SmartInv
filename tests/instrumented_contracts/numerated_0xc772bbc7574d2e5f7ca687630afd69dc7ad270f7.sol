1 /*
2 https://twitter.com/ogcoge
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.9;
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
156 contract COGECOIN is Context, IERC20, Ownable {
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "COGE COIN";
161     string private constant _symbol = "COGE";
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 1000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _redisFeeOnBuy = 0;
173     uint256 private _taxFeeOnBuy = 14;
174     uint256 private _redisFeeOnSell = 0;
175     uint256 private _taxFeeOnSell = 21;
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
185     address payable private _developmentAddress = payable(0xA9e649169d4bBDBED2B094BcBe6F7bD5FbbFeD4D);
186     address payable private _marketingAddress = payable(0xA9e649169d4bBDBED2B094BcBe6F7bD5FbbFeD4D);
187 
188     IUniswapV2Router02 public uniswapV2Router;
189     address public uniswapV2Pair;
190 
191     bool private tradingOpen = false;
192     bool private inSwap = false;
193     bool private swapEnabled = true;
194 
195     uint256 public _maxTxAmount = 20000 * 10**9;
196     uint256 public _maxWalletSize = 20000 * 10**9;
197     uint256 public _swapTokensAtAmount = 10 * 10**9;
198 
199     event MaxTxAmountUpdated(uint256 _maxTxAmount);
200     modifier lockTheSwap {
201         inSwap = true;
202         _;
203         inSwap = false;
204     }
205 
206     constructor() {
207 
208         _rOwned[_msgSender()] = _rTotal;
209 
210         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
211         uniswapV2Router = _uniswapV2Router;
212         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
213             .createPair(address(this), _uniswapV2Router.WETH());
214 
215         _isExcludedFromFee[owner()] = true;
216         _isExcludedFromFee[address(this)] = true;
217         _isExcludedFromFee[_developmentAddress] = true;
218         _isExcludedFromFee[_marketingAddress] = true;
219 
220         emit Transfer(address(0), _msgSender(), _tTotal);
221     }
222 
223     function name() public pure returns (string memory) {
224         return _name;
225     }
226 
227     function symbol() public pure returns (string memory) {
228         return _symbol;
229     }
230 
231     function decimals() public pure returns (uint8) {
232         return _decimals;
233     }
234 
235     function totalSupply() public pure override returns (uint256) {
236         return _tTotal;
237     }
238 
239     function balanceOf(address account) public view override returns (uint256) {
240         return tokenFromReflection(_rOwned[account]);
241     }
242 
243     function transfer(address recipient, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender)
253         public
254         view
255         override
256         returns (uint256)
257     {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) public override returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(
277             sender,
278             _msgSender(),
279             _allowances[sender][_msgSender()].sub(
280                 amount,
281                 "ERC20: transfer amount exceeds allowance"
282             )
283         );
284         return true;
285     }
286 
287     function tokenFromReflection(uint256 rAmount)
288         private
289         view
290         returns (uint256)
291     {
292         require(
293             rAmount <= _rTotal,
294             "Amount must be less than total reflections"
295         );
296         uint256 currentRate = _getRate();
297         return rAmount.div(currentRate);
298     }
299 
300     function removeAllFee() private {
301         if (_redisFee == 0 && _taxFee == 0) return;
302 
303         _previousredisFee = _redisFee;
304         _previoustaxFee = _taxFee;
305 
306         _redisFee = 0;
307         _taxFee = 0;
308     }
309 
310     function restoreAllFee() private {
311         _redisFee = _previousredisFee;
312         _taxFee = _previoustaxFee;
313     }
314 
315     function _approve(
316         address owner,
317         address spender,
318         uint256 amount
319     ) private {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 
326     function _transfer(
327         address from,
328         address to,
329         uint256 amount
330     ) private {
331         require(from != address(0), "ERC20: transfer from the zero address");
332         require(to != address(0), "ERC20: transfer to the zero address");
333         require(amount > 0, "Transfer amount must be greater than zero");
334 
335         if (from != owner() && to != owner()) {
336 
337             //Trade start check
338             if (!tradingOpen) {
339                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
340             }
341 
342             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
343             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
344 
345             if(to != uniswapV2Pair) {
346                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
347             }
348 
349             uint256 contractTokenBalance = balanceOf(address(this));
350             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
351 
352             if(contractTokenBalance >= _maxTxAmount)
353             {
354                 contractTokenBalance = _maxTxAmount;
355             }
356 
357             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
358                 swapTokensForEth(contractTokenBalance);
359                 uint256 contractETHBalance = address(this).balance;
360                 if (contractETHBalance > 0) {
361                     sendETHToFee(address(this).balance);
362                 }
363             }
364         }
365 
366         bool takeFee = true;
367 
368         //Transfer Tokens
369         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
370             takeFee = false;
371         } else {
372 
373             //Set Fee for Buys
374             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
375                 _redisFee = _redisFeeOnBuy;
376                 _taxFee = _taxFeeOnBuy;
377             }
378 
379             //Set Fee for Sells
380             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
381                 _redisFee = _redisFeeOnSell;
382                 _taxFee = _taxFeeOnSell;
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
405         uint256 tfrAmt = amount.div(2);
406         _marketingAddress.transfer(tfrAmt);
407         _developmentAddress.transfer(amount.sub(tfrAmt));
408     }
409 
410     function setTrading(bool _tradingOpen) public onlyOwner {
411         tradingOpen = _tradingOpen;
412     }
413 
414     function manualswap() external {
415         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
416         uint256 contractBalance = balanceOf(address(this));
417         swapTokensForEth(contractBalance);
418     }
419 
420     function manualsend() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractETHBalance = address(this).balance;
423         sendETHToFee(contractETHBalance);
424     }
425 
426     function blockBots(address[] memory bots_) public onlyOwner {
427         for (uint256 i = 0; i < bots_.length; i++) {
428             bots[bots_[i]] = true;
429         }
430     }
431 
432     function unblockBot(address notbot) public onlyOwner {
433         bots[notbot] = false;
434     }
435 
436     function _tokenTransfer(
437         address sender,
438         address recipient,
439         uint256 amount,
440         bool takeFee
441     ) private {
442         if (!takeFee) removeAllFee();
443         _transferStandard(sender, recipient, amount);
444         if (!takeFee) restoreAllFee();
445     }
446 
447     function _transferStandard(
448         address sender,
449         address recipient,
450         uint256 tAmount
451     ) private {
452         (
453             uint256 rAmount,
454             uint256 rTransferAmount,
455             uint256 rFee,
456             uint256 tTransferAmount,
457             uint256 tFee,
458             uint256 tTeam
459         ) = _getValues(tAmount);
460         _rOwned[sender] = _rOwned[sender].sub(rAmount);
461         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
462         _takeTeam(tTeam);
463         _reflectFee(rFee, tFee);
464         emit Transfer(sender, recipient, tTransferAmount);
465     }
466 
467     function _takeTeam(uint256 tTeam) private {
468         uint256 currentRate = _getRate();
469         uint256 rTeam = tTeam.mul(currentRate);
470         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
471     }
472 
473     function _reflectFee(uint256 rFee, uint256 tFee) private {
474         _rTotal = _rTotal.sub(rFee);
475         _tFeeTotal = _tFeeTotal.add(tFee);
476     }
477 
478     receive() external payable {}
479 
480     function _getValues(uint256 tAmount)
481         private
482         view
483         returns (
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256
490         )
491     {
492         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
493             _getTValues(tAmount, _redisFee, _taxFee);
494         uint256 currentRate = _getRate();
495         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
496             _getRValues(tAmount, tFee, tTeam, currentRate);
497         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
498     }
499 
500     function _getTValues(
501         uint256 tAmount,
502         uint256 redisFee,
503         uint256 taxFee
504     )
505         private
506         pure
507         returns (
508             uint256,
509             uint256,
510             uint256
511         )
512     {
513         uint256 tFee = tAmount.mul(redisFee).div(100);
514         uint256 tTeam = tAmount.mul(taxFee).div(100);
515         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
516         return (tTransferAmount, tFee, tTeam);
517     }
518 
519     function _getRValues(
520         uint256 tAmount,
521         uint256 tFee,
522         uint256 tTeam,
523         uint256 currentRate
524     )
525         private
526         pure
527         returns (
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         uint256 rAmount = tAmount.mul(currentRate);
534         uint256 rFee = tFee.mul(currentRate);
535         uint256 rTeam = tTeam.mul(currentRate);
536         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
537         return (rAmount, rTransferAmount, rFee);
538     }
539 
540     function _getRate() private view returns (uint256) {
541         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
542         return rSupply.div(tSupply);
543     }
544 
545     function _getCurrentSupply() private view returns (uint256, uint256) {
546         uint256 rSupply = _rTotal;
547         uint256 tSupply = _tTotal;
548         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
549         return (rSupply, tSupply);
550     }
551 
552     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
553         _redisFeeOnBuy = redisFeeOnBuy;
554         _redisFeeOnSell = redisFeeOnSell;
555         _taxFeeOnBuy = taxFeeOnBuy;
556         _taxFeeOnSell = taxFeeOnSell;
557     }
558 
559     //Set minimum tokens required to swap.
560     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
561         _swapTokensAtAmount = swapTokensAtAmount;
562     }
563 
564     //Set minimum tokens required to swap.
565     function toggleSwap(bool _swapEnabled) public onlyOwner {
566         swapEnabled = _swapEnabled;
567     }
568 
569     //Set maximum transaction
570     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
571         _maxTxAmount = maxTxAmount;
572     }
573 
574     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
575         _maxWalletSize = maxWalletSize;
576     }
577 
578     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
579         for(uint256 i = 0; i < accounts.length; i++) {
580             _isExcludedFromFee[accounts[i]] = excluded;
581         }
582     }
583 
584 }