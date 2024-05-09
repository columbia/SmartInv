1 // SPDX-License-Identifier: Unlicensed
2 // Website - https://2chantoken.com
3 // Telegram - https://t.me/futabachanneltoken
4 // Twitter - https://twitter.com/2Chan_Token
5 
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
40     address internal _owner;
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
156 contract FutabaChannel is Context, IERC20, Ownable {
157  
158     using SafeMath for uint256;
159  
160     string private constant _name = "2CHAN";
161     string private constant _symbol = "2CHAN";
162     uint8 private constant _decimals = 9;
163  
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000000000000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _redisFeeOnBuy = 0;  
173     uint256 private _taxFeeOnBuy = 0;  
174     uint256 private _redisFeeOnSell = 0;  
175     uint256 private _taxFeeOnSell = 99;
176  
177     uint256 private _redisFee = _redisFeeOnSell;
178     uint256 private _taxFee = _taxFeeOnSell;
179  
180     uint256 private _previousredisFee = _redisFee;
181     uint256 private _previoustaxFee = _taxFee;
182  
183     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
184     address payable private _developmentAddress = payable(0xdBeBe8B615A6923484B8aEDf22178FE6aBA05CEa); 
185     address payable private _marketingAddress = payable(0xdBeBe8B615A6923484B8aEDf22178FE6aBA05CEa);
186  
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189  
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193  
194     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
195     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
196     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
197  
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204  
205     constructor() {
206  
207         _rOwned[_msgSender()] = _rTotal;
208  
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
210         uniswapV2Router = _uniswapV2Router;
211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
212             .createPair(address(this), _uniswapV2Router.WETH());
213  
214         _isExcludedFromFee[owner()] = true;
215         _isExcludedFromFee[address(this)] = true;
216         _isExcludedFromFee[_developmentAddress] = true;
217         _isExcludedFromFee[_marketingAddress] = true;
218  
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221  
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225  
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229  
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233  
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237  
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241  
242     function transfer(address recipient, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250  
251     function allowance(address owner, address spender)
252         public
253         view
254         override
255         returns (uint256)
256     {
257         return _allowances[owner][spender];
258     }
259  
260     function approve(address spender, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268  
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(
276             sender,
277             _msgSender(),
278             _allowances[sender][_msgSender()].sub(
279                 amount,
280                 "ERC20: transfer amount exceeds allowance"
281             )
282         );
283         return true;
284     }
285  
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298  
299     function removeAllFee() private {
300         if (_redisFee == 0 && _taxFee == 0) return;
301  
302         _previousredisFee = _redisFee;
303         _previoustaxFee = _taxFee;
304  
305         _redisFee = 0;
306         _taxFee = 0;
307     }
308  
309     function restoreAllFee() private {
310         _redisFee = _previousredisFee;
311         _taxFee = _previoustaxFee;
312     }
313  
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324  
325     function _transfer(
326         address from,
327         address to,
328         uint256 amount
329     ) private {
330         require(from != address(0), "ERC20: transfer from the zero address");
331         require(to != address(0), "ERC20: transfer to the zero address");
332         require(amount > 0, "Transfer amount must be greater than zero");
333  
334         if (from != owner() && to != owner()) {
335  
336             //Trade start check
337             if (!tradingOpen) {
338                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
339             }
340  
341             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
342             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
343  
344             if(to != uniswapV2Pair) {
345                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
346             }
347  
348             uint256 contractTokenBalance = balanceOf(address(this));
349             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
350  
351             if(contractTokenBalance >= _maxTxAmount)
352             {
353                 contractTokenBalance = _maxTxAmount;
354             }
355  
356             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
357                 swapTokensForEth(contractTokenBalance);
358                 uint256 contractETHBalance = address(this).balance;
359                 if (contractETHBalance > 0) {
360                     sendETHToFee(address(this).balance);
361                 }
362             }
363         }
364  
365         bool takeFee = true;
366  
367         //Transfer Tokens
368         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
369             takeFee = false;
370         } else {
371  
372             //Set Fee for Buys
373             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
374                 _redisFee = _redisFeeOnBuy;
375                 _taxFee = _taxFeeOnBuy;
376             }
377  
378             //Set Fee for Sells
379             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnSell;
381                 _taxFee = _taxFeeOnSell;
382             }
383  
384         }
385  
386         _tokenTransfer(from, to, amount, takeFee);
387     }
388  
389     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = uniswapV2Router.WETH();
393         _approve(address(this), address(uniswapV2Router), tokenAmount);
394         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
395             tokenAmount,
396             0,
397             path,
398             address(this),
399             block.timestamp
400         );
401     }
402  
403     function sendETHToFee(uint256 amount) private {
404         _marketingAddress.transfer(amount.mul(3).div(5));
405         _developmentAddress.transfer(amount.mul(2).div(5));
406     }
407  
408     function setTrading(bool _tradingOpen) public onlyOwner {
409         tradingOpen = _tradingOpen;
410     }
411  
412     function manualswap() external {
413         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
414         uint256 contractBalance = balanceOf(address(this));
415         swapTokensForEth(contractBalance);
416     }
417  
418     function manualsend() external {
419         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
420         uint256 contractETHBalance = address(this).balance;
421         sendETHToFee(contractETHBalance);
422     }
423  
424     function blockBots(address[] memory bots_) public onlyOwner {
425         for (uint256 i = 0; i < bots_.length; i++) {
426             bots[bots_[i]] = true;
427         }
428     }
429  
430     function unblockBot(address notbot) public onlyOwner {
431         bots[notbot] = false;
432     }
433  
434     function _tokenTransfer(
435         address sender,
436         address recipient,
437         uint256 amount,
438         bool takeFee
439     ) private {
440         if (!takeFee) removeAllFee();
441         _transferStandard(sender, recipient, amount);
442         if (!takeFee) restoreAllFee();
443     }
444  
445     function _transferStandard(
446         address sender,
447         address recipient,
448         uint256 tAmount
449     ) private {
450         (
451             uint256 rAmount,
452             uint256 rTransferAmount,
453             uint256 rFee,
454             uint256 tTransferAmount,
455             uint256 tFee,
456             uint256 tTeam
457         ) = _getValues(tAmount);
458         _rOwned[sender] = _rOwned[sender].sub(rAmount);
459         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
460         _takeTeam(tTeam);
461         _reflectFee(rFee, tFee);
462         emit Transfer(sender, recipient, tTransferAmount);
463     }
464  
465     function _takeTeam(uint256 tTeam) private {
466         uint256 currentRate = _getRate();
467         uint256 rTeam = tTeam.mul(currentRate);
468         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
469     }
470  
471     function _reflectFee(uint256 rFee, uint256 tFee) private {
472         _rTotal = _rTotal.sub(rFee);
473         _tFeeTotal = _tFeeTotal.add(tFee);
474     }
475  
476     receive() external payable {}
477  
478     function _getValues(uint256 tAmount)
479         private
480         view
481         returns (
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256,
487             uint256
488         )
489     {
490         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
491             _getTValues(tAmount, _redisFee, _taxFee);
492         uint256 currentRate = _getRate();
493         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
494             _getRValues(tAmount, tFee, tTeam, currentRate);
495         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
496     }
497  
498     function _getTValues(
499         uint256 tAmount,
500         uint256 redisFee,
501         uint256 taxFee
502     )
503         private
504         pure
505         returns (
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         uint256 tFee = tAmount.mul(redisFee).div(100);
512         uint256 tTeam = tAmount.mul(taxFee).div(100);
513         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
514         return (tTransferAmount, tFee, tTeam);
515     }
516  
517     function _getRValues(
518         uint256 tAmount,
519         uint256 tFee,
520         uint256 tTeam,
521         uint256 currentRate
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 rAmount = tAmount.mul(currentRate);
532         uint256 rFee = tFee.mul(currentRate);
533         uint256 rTeam = tTeam.mul(currentRate);
534         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
535         return (rAmount, rTransferAmount, rFee);
536     }
537  
538     function _getRate() private view returns (uint256) {
539         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
540         return rSupply.div(tSupply);
541     }
542  
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547         return (rSupply, tSupply);
548     }
549  
550     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
551         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
552         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
553         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
554         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
555 
556         _redisFeeOnBuy = redisFeeOnBuy;
557         _redisFeeOnSell = redisFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560 
561     }
562  
563     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
564         _swapTokensAtAmount = swapTokensAtAmount;
565     }
566  
567     function toggleSwap(bool _swapEnabled) public onlyOwner {
568         swapEnabled = _swapEnabled;
569     }
570  
571     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
572         require(amountPercent>0);
573         _maxTxAmount = (_tTotal * amountPercent ) / 100;
574     }
575 
576     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
577         require(amountPercent>0);
578         _maxWalletSize = (_tTotal * amountPercent ) / 100;
579     }
580 
581     function removeLimits() external onlyOwner{
582         _maxTxAmount = _tTotal;
583         _maxWalletSize = _tTotal;
584     }
585  
586     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
587         for(uint256 i = 0; i < accounts.length; i++) {
588             _isExcludedFromFee[accounts[i]] = excluded;
589         }
590     }
591 
592 }