1 // SPDX-License-Identifier: MIT
2 
3 /*
4  https://t.me/raiderc20
5  https://t.me/0xraidBot
6  https://twitter.com/Raiderc20
7  https://medium.com/@raiderc200/introducing-raid-an-erc20-token-designed-specifically-to-reward-an-active-community-through-3f82745306d2
8  https://www.raiderc20.com
9 */
10 
11 pragma solidity ^0.8.17;
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18  
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21  
22     function balanceOf(address account) external view returns (uint256);
23  
24     function transfer(address recipient, uint256 amount) external returns (bool);
25  
26     function allowance(address owner, address spender) external view returns (uint256);
27  
28     function approve(address spender, uint256 amount) external returns (bool);
29  
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43  
44 contract Ownable is Context {
45     address private _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51  
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57  
58     function owner() public view returns (address) {
59         return _owner;
60     }
61  
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66  
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71  
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77  
78 }
79  
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86  
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90  
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100  
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109  
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113  
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124  
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130  
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139  
140     function factory() external pure returns (address);
141  
142     function WETH() external pure returns (address);
143  
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160  
161 contract raid is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "Raid";
166     string private constant _symbol = "Raid";
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 1000000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177 
178     uint256 private _redisFeeOnBuy = 0;  
179     uint256 private _taxFeeOnBuy = 0;  
180     uint256 private _redisFeeOnSell = 0;  
181     uint256 private _taxFeeOnSell = 0;
182  
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186  
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189 
190     //Ratio 
191     uint16 receiver0Ratio = 2;
192     uint16 receiver1Ratio = 1;
193     uint16 receiver2Ratio = 2;
194     uint16 receiverTotalRatio = receiver0Ratio + receiver1Ratio + receiver2Ratio;
195  
196     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
197     address payable public _feeReceiver0 = payable(0xEbD24dea6F55ecB5AbB8392e28D2e1036D31bDd9);
198     address payable private _feeReceiver1 = payable(0x2Faf0961B477f1160cb9a73551A11100Df26D3E5); 
199     address payable private _feeReceiver2 = payable(0x97548B461227089eD975CCBb9fF3CccD0a37D0DE);
200  
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203  
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207  
208     uint256 public _maxTxAmount = 10000000 * 10**9; 
209     uint256 public _maxWalletSize = 10000000 * 10**9; 
210     uint256 public _swapTokensAtAmount = 500000 * 10**9;
211  
212     event MaxTxAmountUpdated(uint256 _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218  
219     constructor() {
220  
221         _rOwned[_msgSender()] = _rTotal;
222  
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227  
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_feeReceiver0] = true;
231         _isExcludedFromFee[_feeReceiver1] = true;
232         _isExcludedFromFee[_feeReceiver2] = true;
233  
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236  
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240  
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244  
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248  
249     function totalSupply() public pure override returns (uint256) {
250         return _tTotal;
251     }
252  
253     function balanceOf(address account) public view override returns (uint256) {
254         return tokenFromReflection(_rOwned[account]);
255     }
256  
257     function transfer(address recipient, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265  
266     function allowance(address owner, address spender)
267         public
268         view
269         override
270         returns (uint256)
271     {
272         return _allowances[owner][spender];
273     }
274  
275     function approve(address spender, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283  
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(
291             sender,
292             _msgSender(),
293             _allowances[sender][_msgSender()].sub(
294                 amount,
295                 "ERC20: transfer amount exceeds allowance"
296             )
297         );
298         return true;
299     }
300  
301     function tokenFromReflection(uint256 rAmount)
302         private
303         view
304         returns (uint256)
305     {
306         require(
307             rAmount <= _rTotal,
308             "Amount must be less than total reflections"
309         );
310         uint256 currentRate = _getRate();
311         return rAmount.div(currentRate);
312     }
313  
314     function removeAllFee() private {
315         if (_redisFee == 0 && _taxFee == 0) return;
316  
317         _previousredisFee = _redisFee;
318         _previoustaxFee = _taxFee;
319  
320         _redisFee = 0;
321         _taxFee = 0;
322     }
323  
324     function restoreAllFee() private {
325         _redisFee = _previousredisFee;
326         _taxFee = _previoustaxFee;
327     }
328  
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339  
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) private {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348  
349         if (from != owner() && to != owner()) {
350  
351             //Trade start check
352             if (!tradingOpen) {
353                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
354             }
355  
356             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
357             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
358  
359             if(to != uniswapV2Pair) {
360                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
361             }
362  
363             uint256 contractTokenBalance = balanceOf(address(this));
364             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
365  
366             if(contractTokenBalance >= _maxTxAmount)
367             {
368                 contractTokenBalance = _maxTxAmount;
369             }
370  
371             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
372                 swapTokensForEth(contractTokenBalance);
373                 uint256 contractETHBalance = address(this).balance;
374                 if (contractETHBalance > 0) {
375                     sendETHToFee(address(this).balance);
376                 }
377             }
378         }
379  
380         bool takeFee = true;
381  
382         //Transfer Tokens
383         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
384             takeFee = false;
385         } else {
386  
387             //Set Fee for Buys
388             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnBuy;
390                 _taxFee = _taxFeeOnBuy;
391             }
392  
393             //Set Fee for Sells
394             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
395                 _redisFee = _redisFeeOnSell;
396                 _taxFee = _taxFeeOnSell;
397             }
398  
399         }
400  
401         _tokenTransfer(from, to, amount, takeFee);
402     }
403  
404     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
405         address[] memory path = new address[](2);
406         path[0] = address(this);
407         path[1] = uniswapV2Router.WETH();
408         _approve(address(this), address(uniswapV2Router), tokenAmount);
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0,
412             path,
413             address(this),
414             block.timestamp
415         );
416     }
417  
418     function sendETHToFee(uint256 amount) private {
419         _feeReceiver0.transfer(amount * receiver0Ratio / receiverTotalRatio);
420         _feeReceiver1.transfer(amount * receiver1Ratio / receiverTotalRatio);
421         _feeReceiver2.transfer(address(this).balance);
422     }
423  
424     function beginTrading() public onlyOwner {
425         tradingOpen = true;
426     }
427  
428     function manualswap() external {
429         require(_msgSender() == _feeReceiver1 || _msgSender() == _feeReceiver2);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433  
434     function manualsend() external {
435         require(_msgSender() == _feeReceiver1 || _msgSender() == _feeReceiver2);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439  
440     function blockBots(address[] memory bots_) public onlyOwner {
441         for (uint256 i = 0; i < bots_.length; i++) {
442             bots[bots_[i]] = true;
443         }
444     }
445  
446     function unblockBot(address notbot) public onlyOwner {
447         bots[notbot] = false;
448     }
449  
450     function _tokenTransfer(
451         address sender,
452         address recipient,
453         uint256 amount,
454         bool takeFee
455     ) private {
456         if (!takeFee) removeAllFee();
457         _transferStandard(sender, recipient, amount);
458         if (!takeFee) restoreAllFee();
459     }
460  
461     function _transferStandard(
462         address sender,
463         address recipient,
464         uint256 tAmount
465     ) private {
466         (
467             uint256 rAmount,
468             uint256 rTransferAmount,
469             uint256 rFee,
470             uint256 tTransferAmount,
471             uint256 tFee,
472             uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480  
481     function _takeTeam(uint256 tTeam) private {
482         uint256 currentRate = _getRate();
483         uint256 rTeam = tTeam.mul(currentRate);
484         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
485     }
486  
487     function _reflectFee(uint256 rFee, uint256 tFee) private {
488         _rTotal = _rTotal.sub(rFee);
489         _tFeeTotal = _tFeeTotal.add(tFee);
490     }
491  
492     receive() external payable {}
493  
494     function _getValues(uint256 tAmount)
495         private
496         view
497         returns (
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
507             _getTValues(tAmount, _redisFee, _taxFee);
508         uint256 currentRate = _getRate();
509         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
510             _getRValues(tAmount, tFee, tTeam, currentRate);
511         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
512     }
513  
514     function _getTValues(
515         uint256 tAmount,
516         uint256 redisFee,
517         uint256 taxFee
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 tFee = tAmount.mul(redisFee).div(100);
528         uint256 tTeam = tAmount.mul(taxFee).div(100);
529         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
530         return (tTransferAmount, tFee, tTeam);
531     }
532  
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551         return (rAmount, rTransferAmount, rFee);
552     }
553  
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556         return rSupply.div(tSupply);
557     }
558  
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563         return (rSupply, tSupply);
564     }
565  
566     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
567         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
568         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
569         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
570         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
571 
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574         _taxFeeOnBuy = taxFeeOnBuy;
575         _taxFeeOnSell = taxFeeOnSell;
576     }
577  
578     //Set minimum tokens required to swap.
579     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
580         _swapTokensAtAmount = swapTokensAtAmount;
581     }
582  
583     //Set minimum tokens required to swap.
584     function toggleSwap(bool _swapEnabled) public onlyOwner {
585         swapEnabled = _swapEnabled;
586     }
587  
588     //Set maximum transaction
589     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
590            _maxTxAmount = maxTxAmount;
591         
592     }
593  
594     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
595         _maxWalletSize = maxWalletSize;
596     }
597 
598     function removeLimits() external onlyOwner {
599         _maxWalletSize = _tTotal;
600         _maxTxAmount = _tTotal;
601     }
602 
603     function adjustRatio(uint16 r0, uint16 r1, uint16 r2) external onlyOwner {
604         receiver0Ratio = r0;
605         receiver1Ratio = r1;
606         receiver2Ratio = r2;
607         receiverTotalRatio = receiver0Ratio + receiver1Ratio + receiver2Ratio;
608     }
609 
610     function adjustReceivers(address r0, address r1, address r2) external onlyOwner {
611         _feeReceiver0 = payable(r0);
612         _feeReceiver1 = payable(r1);
613         _feeReceiver2 = payable(r2);
614     }
615  
616     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
617         for(uint256 i = 0; i < accounts.length; i++) {
618             _isExcludedFromFee[accounts[i]] = excluded;
619         }
620     }
621 
622 }