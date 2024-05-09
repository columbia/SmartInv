1 // https://medium.com/@yohentenmokuerc20/yohen-tenmoku-4a36d6aa3c55
2 
3 // SPDX-License-Identifier: unlicense
4 
5 pragma solidity ^0.8.15;
6  
7 abstract contract Context 
8 {
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
156 contract Yohentenmoku is Context, IERC20, Ownable {
157  
158     using SafeMath for uint256;
159  
160     string private constant _name = "Yohentenmoku";
161     string private constant _symbol = "YOMOKU";
162     uint8 private constant _decimals = 9;
163  
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 1000000000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 public launchBlock;
173  
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 20;
176  
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 20;
179  
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182  
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185  
186     mapping(address => bool) public bots;
187     mapping(address => uint256) private cooldown;
188  
189     address payable private _developmentAddress = payable(0xA9EfD86d3B0CCb94A69cd269CC782B03866EDF02);
190     address payable private _marketingAddress = payable(0xA9EfD86d3B0CCb94A69cd269CC782B03866EDF02);
191  
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194  
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198  
199     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
200     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000); 
201     uint256 public _swapTokensAtAmount = _tTotal.mul(5).div(1000); 
202  
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209  
210     constructor() {
211  
212         _rOwned[_msgSender()] = _rTotal;
213  
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218  
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223   
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226  
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230  
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234  
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238  
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242  
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246  
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255  
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264  
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273  
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290  
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303  
304     function removeAllFee() private {
305         if (_redisFee == 0 && _taxFee == 0) return;
306  
307         _previousredisFee = _redisFee;
308         _previoustaxFee = _taxFee;
309  
310         _redisFee = 0;
311         _taxFee = 0;
312     }
313  
314     function restoreAllFee() private {
315         _redisFee = _previousredisFee;
316         _taxFee = _previoustaxFee;
317     }
318  
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329  
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338  
339         if (from != owner() && to != owner()) {
340  
341             if (!tradingOpen) {
342                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344  
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
347  
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351  
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354  
355             if(contractTokenBalance >= _maxTxAmount)
356             {
357                 contractTokenBalance = _maxTxAmount;
358             }
359  
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 0) {
364                     sendETHToFee(address(this).balance);
365                 }
366             }
367         }
368  
369         bool takeFee = true;
370  
371         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
372             takeFee = false;
373         } else {
374  
375             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
376                 _redisFee = _redisFeeOnBuy;
377                 _taxFee = _taxFeeOnBuy;
378             }
379  
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
405         _developmentAddress.transfer(amount.div(2));
406         _marketingAddress.transfer(amount.div(2));
407     }
408  
409     function setTrading(bool _tradingOpen) public onlyOwner {
410         tradingOpen = _tradingOpen;
411         launchBlock = block.number;
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
497  
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500  
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517  
518         return (tTransferAmount, tFee, tTeam);
519     }
520  
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539  
540         return (rAmount, rTransferAmount, rFee);
541     }
542  
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545  
546         return rSupply.div(tSupply);
547     }
548  
549     function _getCurrentSupply() private view returns (uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
553  
554         return (rSupply, tSupply);
555     }
556  
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         _redisFeeOnBuy = redisFeeOnBuy;
559         _redisFeeOnSell = redisFeeOnSell;
560  
561         _taxFeeOnBuy = taxFeeOnBuy;
562         _taxFeeOnSell = taxFeeOnSell;
563     }
564  
565     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
566         _swapTokensAtAmount = swapTokensAtAmount;
567     }
568  
569     function toggleSwap(bool _swapEnabled) public onlyOwner {
570         swapEnabled = _swapEnabled;
571     }
572 
573     function removeLimit () external onlyOwner{
574         _maxTxAmount = _tTotal;
575         _maxWalletSize = _tTotal;
576     }
577  
578     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
579         _maxTxAmount = maxTxAmount;
580     }
581  
582     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
583         _maxWalletSize = maxWalletSize;
584     }
585  
586     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
587         for(uint256 i = 0; i < accounts.length; i++) {
588             _isExcludedFromFee[accounts[i]] = excluded;
589         }
590     }
591 }