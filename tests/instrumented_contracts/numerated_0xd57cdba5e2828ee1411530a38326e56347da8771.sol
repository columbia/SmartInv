1 /**
2 Telegram : https://t.me/somethingportal
3 Website : https://somethingcoin.xyz
4 Twitter: https://twitter.com/Something_ERC
5 **/
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.9;
10 
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17  
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20  
21     function balanceOf(address account) external view returns (uint256);
22  
23     function transfer(address recipient, uint256 amount) external returns (bool);
24  
25     function allowance(address owner, address spender) external view returns (uint256);
26  
27     function approve(address spender, uint256 amount) external returns (bool);
28  
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34  
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42  
43 contract Ownable is Context {
44     address internal _owner;
45     address private _previousOwner;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50  
51     constructor() {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56  
57     function owner() public view returns (address) {
58         return _owner;
59     }
60  
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65  
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70  
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76  
77 }
78 
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85  
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89  
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99  
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108  
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112  
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123  
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129  
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138  
139     function factory() external pure returns (address);
140  
141     function WETH() external pure returns (address);
142  
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159  
160 contract Something is Context, IERC20, Ownable {
161  
162     using SafeMath for uint256;
163  
164     string private constant _name = "Something";
165     string private constant _symbol = "SOMETHING";
166     uint8 private constant _decimals = 9;
167  
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 1000000 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _redisFeeOnBuy = 0;  
177     uint256 private _taxFeeOnBuy = 25;  
178     uint256 private _redisFeeOnSell = 0;  
179     uint256 private _taxFeeOnSell = 40;
180  
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
188     address payable private _developmentAddress = payable(0x9ccc53a84fdD5cb8B12B304247487f8c32B0A42E); 
189     address payable private _marketingAddress = payable(0x9ccc53a84fdD5cb8B12B304247487f8c32B0A42E);
190  
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193  
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197  
198     uint256 public _maxTxAmount = _tTotal.mul(1).div(100);
199     uint256 public _maxWalletSize = _tTotal.mul(1).div(100); 
200     uint256 public _swapTokensAtAmount = _tTotal.mul(60).div(1000);
201  
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208  
209     constructor() {
210  
211         _rOwned[_msgSender()] = _rTotal;
212  
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217  
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222  
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225  
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229  
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233  
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237  
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241  
242     function balanceOf(address account) public view override returns (uint256) {
243         return tokenFromReflection(_rOwned[account]);
244     }
245  
246     function transfer(address recipient, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254  
255     function allowance(address owner, address spender)
256         public
257         view
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263  
264     function approve(address spender, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272  
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) public override returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(
280             sender,
281             _msgSender(),
282             _allowances[sender][_msgSender()].sub(
283                 amount,
284                 "ERC20: transfer amount exceeds allowance"
285             )
286         );
287         return true;
288     }
289  
290     function tokenFromReflection(uint256 rAmount)
291         private
292         view
293         returns (uint256)
294     {
295         require(
296             rAmount <= _rTotal,
297             "Amount must be less than total reflections"
298         );
299         uint256 currentRate = _getRate();
300         return rAmount.div(currentRate);
301     }
302  
303     function removeAllFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305  
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308  
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312  
313     function restoreAllFee() private {
314         _redisFee = _previousredisFee;
315         _taxFee = _previoustaxFee;
316     }
317  
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328  
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337  
338         if (from != owner() && to != owner()) {
339  
340             //Trade start check
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
371         //Transfer Tokens
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375  
376             //Set Fee for Buys
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381  
382             //Set Fee for Sells
383             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnSell;
385                 _taxFee = _taxFeeOnSell;
386             }
387  
388         }
389  
390         _tokenTransfer(from, to, amount, takeFee);
391     }
392  
393     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = uniswapV2Router.WETH();
397         _approve(address(this), address(uniswapV2Router), tokenAmount);
398         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
399             tokenAmount,
400             0,
401             path,
402             address(this),
403             block.timestamp
404         );
405     }
406  
407     function sendETHToFee(uint256 amount) private {
408         _marketingAddress.transfer(amount.mul(3).div(5));
409         _developmentAddress.transfer(amount.mul(2).div(5));
410     }
411  
412     function setTrading(bool _tradingOpen) public onlyOwner {
413         tradingOpen = _tradingOpen;
414     }
415  
416     function manualswap() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractBalance = balanceOf(address(this));
419         swapTokensForEth(contractBalance);
420     }
421  
422     function manualsend() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractETHBalance = address(this).balance;
425         sendETHToFee(contractETHBalance);
426     }
427  
428     function blockBots(address[] memory bots_) public onlyOwner {
429         for (uint256 i = 0; i < bots_.length; i++) {
430             bots[bots_[i]] = true;
431         }
432     }
433  
434     function unblockBot(address notbot) public onlyOwner {
435         bots[notbot] = false;
436     }
437  
438     function _tokenTransfer(
439         address sender,
440         address recipient,
441         uint256 amount,
442         bool takeFee
443     ) private {
444         if (!takeFee) removeAllFee();
445         _transferStandard(sender, recipient, amount);
446         if (!takeFee) restoreAllFee();
447     }
448  
449     function _transferStandard(
450         address sender,
451         address recipient,
452         uint256 tAmount
453     ) private {
454         (
455             uint256 rAmount,
456             uint256 rTransferAmount,
457             uint256 rFee,
458             uint256 tTransferAmount,
459             uint256 tFee,
460             uint256 tTeam
461         ) = _getValues(tAmount);
462         _rOwned[sender] = _rOwned[sender].sub(rAmount);
463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
464         _takeTeam(tTeam);
465         _reflectFee(rFee, tFee);
466         emit Transfer(sender, recipient, tTransferAmount);
467     }
468  
469     function _takeTeam(uint256 tTeam) private {
470         uint256 currentRate = _getRate();
471         uint256 rTeam = tTeam.mul(currentRate);
472         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
473     }
474  
475     function _reflectFee(uint256 rFee, uint256 tFee) private {
476         _rTotal = _rTotal.sub(rFee);
477         _tFeeTotal = _tFeeTotal.add(tFee);
478     }
479  
480     receive() external payable {}
481  
482     function _getValues(uint256 tAmount)
483         private
484         view
485         returns (
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
495             _getTValues(tAmount, _redisFee, _taxFee);
496         uint256 currentRate = _getRate();
497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
498             _getRValues(tAmount, tFee, tTeam, currentRate);
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501  
502     function _getTValues(
503         uint256 tAmount,
504         uint256 redisFee,
505         uint256 taxFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(redisFee).div(100);
516         uint256 tTeam = tAmount.mul(taxFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
539         return (rAmount, rTransferAmount, rFee);
540     }
541  
542     function _getRate() private view returns (uint256) {
543         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
544         return rSupply.div(tSupply);
545     }
546  
547     function _getCurrentSupply() private view returns (uint256, uint256) {
548         uint256 rSupply = _rTotal;
549         uint256 tSupply = _tTotal;
550         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
551         return (rSupply, tSupply);
552     }
553  
554     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
555         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 5, "Buy rewards must be between 0% and 5%");
556         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 40, "Buy tax must be between 0% and 40%");
557         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 5, "Sell rewards must be between 0% and 5%");
558         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 40, "Sell tax must be between 0% and 40%");
559 
560         _redisFeeOnBuy = redisFeeOnBuy;
561         _redisFeeOnSell = redisFeeOnSell;
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564 
565     }
566  
567     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
568         _swapTokensAtAmount = swapTokensAtAmount;
569     }
570  
571     function toggleSwap(bool _swapEnabled) public onlyOwner {
572         swapEnabled = _swapEnabled;
573     }
574  
575     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
576         require(amountPercent>0);
577         _maxTxAmount = (_tTotal * amountPercent ) / 100;
578     }
579 
580     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
581         require(amountPercent>0);
582         _maxWalletSize = (_tTotal * amountPercent ) / 100;
583     }
584 
585     function removeLimits() external onlyOwner{
586         _maxTxAmount = _tTotal;
587         _maxWalletSize = _tTotal;
588     }
589  
590     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
591         for(uint256 i = 0; i < accounts.length; i++) {
592             _isExcludedFromFee[accounts[i]] = excluded;
593         }
594     }
595 
596 }