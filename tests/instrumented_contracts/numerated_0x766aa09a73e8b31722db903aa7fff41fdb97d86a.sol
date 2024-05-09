1 /*
2 
3 Introducing Microsoft 365 Copilot — your copilot for work. It combines the power of large language models (LLMs) with your data in the Microsoft Graph and the Microsoft 365 apps to turn your words into the most powerful productivity tool on the planet.
4 
5  https://t.me/MicrosoftAIportal
6  https://twitter.com/Microsoft_CP
7 
8 */
9 
10 
11 // SPDX-License-Identifier: UNLICENSE
12 
13 pragma solidity ^0.8.16;
14 
15 abstract contract Context 
16 {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21  
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24  
25     function balanceOf(address account) external view returns (uint256);
26  
27     function transfer(address recipient, uint256 amount) external returns (bool);
28  
29     function allowance(address owner, address spender) external view returns (uint256);
30  
31     function approve(address spender, uint256 amount) external returns (bool);
32  
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38  
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46  
47 contract Ownable is Context {
48     address private _owner;
49     address private _previousOwner;
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54  
55     constructor() {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60  
61     function owner() public view returns (address) {
62         return _owner;
63     }
64  
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69  
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74  
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80  
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
164 contract CoPilot is Context, IERC20, Ownable {
165  
166     using SafeMath for uint256;
167  
168     string private constant _name = "Microsoft AI";
169     string private constant _symbol = "CoPilot";
170     uint8 private constant _decimals = 9;
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 365000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 public launchBlock;
180  
181     uint256 private _redisFeeOnBuy = 0;
182     uint256 private _taxFeeOnBuy = 10;
183  
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 25;
186  
187     uint256 private _redisFee = _redisFeeOnSell;
188     uint256 private _taxFee = _taxFeeOnSell;
189  
190     uint256 private _previousredisFee = _redisFee;
191     uint256 private _previoustaxFee = _taxFee;
192  
193     mapping(address => bool) public bots;
194     mapping(address => uint256) private cooldown;
195  
196     address payable private _developmentAddress = payable(0x81978221E82BDCF60Aa111894f6C916F78f097Eb);
197     address payable private _marketingAddress = payable(0x3FB4375164fE687a55946ADe6115B610dD7Dabb6);
198  
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201  
202     bool private tradingOpen;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205  
206     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
207     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000); 
208     uint256 public _swapTokensAtAmount = _tTotal.mul(10).div(1000);
209  
210     event MaxTxAmountUpdated(uint256 _maxTxAmount);
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216  
217     constructor() {
218  
219         _rOwned[_msgSender()] = _rTotal;
220  
221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
222         uniswapV2Router = _uniswapV2Router;
223         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
224             .createPair(address(this), _uniswapV2Router.WETH());
225  
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_developmentAddress] = true;
229         _isExcludedFromFee[_marketingAddress] = true;
230   
231         emit Transfer(address(0), _msgSender(), _tTotal);
232     }
233  
234     function name() public pure returns (string memory) {
235         return _name;
236     }
237  
238     function symbol() public pure returns (string memory) {
239         return _symbol;
240     }
241  
242     function decimals() public pure returns (uint8) {
243         return _decimals;
244     }
245  
246     function totalSupply() public pure override returns (uint256) {
247         return _tTotal;
248     }
249  
250     function balanceOf(address account) public view override returns (uint256) {
251         return tokenFromReflection(_rOwned[account]);
252     }
253  
254     function transfer(address recipient, uint256 amount)
255         public
256         override
257         returns (bool)
258     {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262  
263     function allowance(address owner, address spender)
264         public
265         view
266         override
267         returns (uint256)
268     {
269         return _allowances[owner][spender];
270     }
271  
272     function approve(address spender, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280  
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) public override returns (bool) {
286         _transfer(sender, recipient, amount);
287         _approve(
288             sender,
289             _msgSender(),
290             _allowances[sender][_msgSender()].sub(
291                 amount,
292                 "ERC20: transfer amount exceeds allowance"
293             )
294         );
295         return true;
296     }
297  
298     function tokenFromReflection(uint256 rAmount)
299         private
300         view
301         returns (uint256)
302     {
303         require(
304             rAmount <= _rTotal,
305             "Amount must be less than total reflections"
306         );
307         uint256 currentRate = _getRate();
308         return rAmount.div(currentRate);
309     }
310  
311     function removeAllFee() private {
312         if (_redisFee == 0 && _taxFee == 0) return;
313  
314         _previousredisFee = _redisFee;
315         _previoustaxFee = _taxFee;
316  
317         _redisFee = 0;
318         _taxFee = 0;
319     }
320  
321     function restoreAllFee() private {
322         _redisFee = _previousredisFee;
323         _taxFee = _previoustaxFee;
324     }
325  
326     function _approve(
327         address owner,
328         address spender,
329         uint256 amount
330     ) private {
331         require(owner != address(0), "ERC20: approve from the zero address");
332         require(spender != address(0), "ERC20: approve to the zero address");
333         _allowances[owner][spender] = amount;
334         emit Approval(owner, spender, amount);
335     }
336  
337     function _transfer(
338         address from,
339         address to,
340         uint256 amount
341     ) private {
342         require(from != address(0), "ERC20: transfer from the zero address");
343         require(to != address(0), "ERC20: transfer to the zero address");
344         require(amount > 0, "Transfer amount must be greater than zero");
345  
346         if (from != owner() && to != owner()) {
347  
348             if (!tradingOpen) {
349                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
350             }
351  
352             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
353             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
354  
355             if(to != uniswapV2Pair) {
356                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
357             }
358  
359             uint256 contractTokenBalance = balanceOf(address(this));
360             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
361  
362             if(contractTokenBalance >= _maxTxAmount)
363             {
364                 contractTokenBalance = _maxTxAmount;
365             }
366  
367             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368                 swapTokensForEth(contractTokenBalance);
369                 uint256 contractETHBalance = address(this).balance;
370                 if (contractETHBalance > 0) {
371                     sendETHToFee(address(this).balance);
372                 }
373             }
374         }
375  
376         bool takeFee = true;
377  
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381  
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386  
387             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
388                 _redisFee = _redisFeeOnSell;
389                 _taxFee = _taxFeeOnSell;
390             }
391  
392         }
393  
394         _tokenTransfer(from, to, amount, takeFee);
395     }
396  
397     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
398         address[] memory path = new address[](2);
399         path[0] = address(this);
400         path[1] = uniswapV2Router.WETH();
401         _approve(address(this), address(uniswapV2Router), tokenAmount);
402         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
403             tokenAmount,
404             0,
405             path,
406             address(this),
407             block.timestamp
408         );
409     }
410  
411     function sendETHToFee(uint256 amount) private {
412         _developmentAddress.transfer(amount.div(2));
413         _marketingAddress.transfer(amount.div(2));
414     }
415  
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
418         launchBlock = block.number;
419     }
420  
421     function manualswap() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractBalance = balanceOf(address(this));
424         swapTokensForEth(contractBalance);
425     }
426  
427     function manualsend() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
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
500             _getTValues(tAmount, _redisFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504  
505         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
506     }
507  
508     function _getTValues(
509         uint256 tAmount,
510         uint256 redisFee,
511         uint256 taxFee
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 tFee = tAmount.mul(redisFee).div(100);
522         uint256 tTeam = tAmount.mul(taxFee).div(100);
523         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
524  
525         return (tTransferAmount, tFee, tTeam);
526     }
527  
528     function _getRValues(
529         uint256 tAmount,
530         uint256 tFee,
531         uint256 tTeam,
532         uint256 currentRate
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rFee = tFee.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
546  
547         return (rAmount, rTransferAmount, rFee);
548     }
549  
550     function _getRate() private view returns (uint256) {
551         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
552  
553         return rSupply.div(tSupply);
554     }
555  
556     function _getCurrentSupply() private view returns (uint256, uint256) {
557         uint256 rSupply = _rTotal;
558         uint256 tSupply = _tTotal;
559         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
560  
561         return (rSupply, tSupply);
562     }
563  
564     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
565         _redisFeeOnBuy = redisFeeOnBuy;
566         _redisFeeOnSell = redisFeeOnSell;
567         _taxFeeOnBuy = taxFeeOnBuy;
568         _taxFeeOnSell = taxFeeOnSell;
569     }
570  
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574  
575     function toggleSwap(bool _swapEnabled) public onlyOwner {
576         swapEnabled = _swapEnabled;
577     }
578 
579     function removeLimit () external onlyOwner{
580         _maxTxAmount = _tTotal;
581         _maxWalletSize = _tTotal;
582     }
583  
584     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
585         _maxTxAmount = maxTxAmount;
586     }
587  
588     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
589         _maxWalletSize = maxWalletSize;
590     }
591  
592     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
593         for(uint256 i = 0; i < accounts.length; i++) {
594             _isExcludedFromFee[accounts[i]] = excluded;
595         }
596     }
597 }