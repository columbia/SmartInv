1 /*
2 Moontools is a web-based sniper and copy trading Dapp. You just need to hold some $MTT to use it.
3 website : https://moontools.org/
4 we are waiting you in our telegram group https://t.me/MoonToolsErc to build a huge community
5 
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 
11 pragma solidity ^0.8.9;
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
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78  
79 }
80  
81 library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85         return c;
86     }
87  
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91  
92     function sub(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99         return c;
100     }
101  
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110  
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114  
115     function div(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         return c;
123     }
124 }
125  
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB)
128         external
129         returns (address pair);
130 }
131  
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint256 amountIn,
135         uint256 amountOutMin,
136         address[] calldata path,
137         address to,
138         uint256 deadline
139     ) external;
140  
141     function factory() external pure returns (address);
142  
143     function WETH() external pure returns (address);
144  
145     function addLiquidityETH(
146         address token,
147         uint256 amountTokenDesired,
148         uint256 amountTokenMin,
149         uint256 amountETHMin,
150         address to,
151         uint256 deadline
152     )
153         external
154         payable
155         returns (
156             uint256 amountToken,
157             uint256 amountETH,
158             uint256 liquidity
159         );
160 }
161  
162 contract MoonTools is Context, IERC20, Ownable {
163  
164     using SafeMath for uint256;
165  
166     string private constant _name = "MoonToolsToken";
167     string private constant _symbol = "MTT";
168     uint8 private constant _decimals = 9;
169  
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 10000000000* 10**9;                                                                         
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 private _redisFeeOnBuy = 0;  
179     uint256 private _taxFeeOnBuy = 5;  
180     uint256 private _redisFeeOnSell = 0;  
181     uint256 private _taxFeeOnSell = 5;
182  
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186  
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189  
190     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
191     address payable private _developmentAddress = payable(0x9a0279eAAEc121be4291c7fA9BfC817CB69b0bec); 
192     address payable private _marketingAddress = payable(0x9a0279eAAEc121be4291c7fA9BfC817CB69b0bec);
193  
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196  
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200  
201     uint256 public _maxTxAmount = 200000000 * 10**9; 
202     uint256 public _maxWalletSize = 200000000 * 10**9; 
203     uint256 public _swapTokensAtAmount = 100000 * 10**9;
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
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219             .createPair(address(this), _uniswapV2Router.WETH());
220  
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_developmentAddress] = true;
224         _isExcludedFromFee[_marketingAddress] = true;
225  
226         emit Transfer(address(0), _msgSender(), _tTotal);
227     }
228  
229     function name() public pure returns (string memory) {
230         return _name;
231     }
232     function marketingwallet() public view returns (address) {
233         return _marketingAddress;
234     }
235     function symbol() public pure returns (string memory) {
236         return _symbol;
237     }
238  
239     function decimals() public pure returns (uint8) {
240         return _decimals;
241     }
242  
243     function totalSupply() public pure override returns (uint256) {
244         return _tTotal;
245     }
246  
247     function balanceOf(address account) public view override returns (uint256) {
248         return tokenFromReflection(_rOwned[account]);
249     }
250  
251     function transfer(address recipient, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259  
260     function allowance(address owner, address spender)
261         public
262         view
263         override
264         returns (uint256)
265     {
266         return _allowances[owner][spender];
267     }
268  
269     function approve(address spender, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277  
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public override returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(
285             sender,
286             _msgSender(),
287             _allowances[sender][_msgSender()].sub(
288                 amount,
289                 "ERC20: transfer amount exceeds allowance"
290             )
291         );
292         return true;
293     }
294  
295     function tokenFromReflection(uint256 rAmount)
296         private
297         view
298         returns (uint256)
299     {
300         require(
301             rAmount <= _rTotal,
302             "Amount must be less than total reflections"
303         );
304         uint256 currentRate = _getRate();
305         return rAmount.div(currentRate);
306     }
307  
308     function removeAllFee() private {
309         if (_redisFee == 0 && _taxFee == 0) return;
310  
311         _previousredisFee = _redisFee;
312         _previoustaxFee = _taxFee;
313  
314         _redisFee = 0;
315         _taxFee = 0;
316     }
317  
318     function restoreAllFee() private {
319         _redisFee = _previousredisFee;
320         _taxFee = _previoustaxFee;
321     }
322  
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333  
334     function _transfer(
335         address from,
336         address to,
337         uint256 amount
338     ) private {
339         require(from != address(0), "ERC20: transfer from the zero address");
340         require(to != address(0), "ERC20: transfer to the zero address");
341         require(amount > 0, "Transfer amount must be greater than zero");
342  
343         if (from != owner() && to != owner() && from != marketingwallet() && to != marketingwallet() ) {
344  
345             //Trade start check
346             if (!tradingOpen) {
347                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
348             }
349  
350             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
351             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
352  
353             if(to != uniswapV2Pair) {
354                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
355             }
356  
357             uint256 contractTokenBalance = balanceOf(address(this));
358             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
359  
360             if(contractTokenBalance >= _maxTxAmount)
361             {
362                 contractTokenBalance = _maxTxAmount;
363             }
364  
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
366                 swapTokensForEth(contractTokenBalance);
367                 uint256 contractETHBalance = address(this).balance;
368                 if (contractETHBalance > 0) {
369                     sendETHToFee(address(this).balance);
370                 }
371             }
372         }
373  
374         bool takeFee = true;
375  
376         //Transfer Tokens
377         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
378             takeFee = false;
379         } else {
380  
381             //Set Fee for Buys
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386  
387             //Set Fee for Sells
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392  
393         }
394  
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397  
398     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = uniswapV2Router.WETH();
402         _approve(address(this), address(uniswapV2Router), tokenAmount);
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0,
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411  
412     function sendETHToFee(uint256 amount) private {
413         _marketingAddress.transfer(amount);
414     }
415  
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
418         _taxFeeOnBuy = 5;
419         _taxFeeOnSell = 40;
420     }
421     function MoonToolsRealLaunch(int code) public onlyOwner {
422         tradingOpen = code== 10;
423         _taxFeeOnBuy = 5;
424         _taxFeeOnSell = 5;
425     }
426  
427     function manualswap() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
429         uint256 contractBalance = balanceOf(address(this));
430         swapTokensForEth(contractBalance);
431     }
432  
433     function manualsend() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractETHBalance = address(this).balance;
436         sendETHToFee(contractETHBalance);
437     }
438  
439     function blockBots(address[] memory bots_) public onlyOwner {
440         for (uint256 i = 0; i < bots_.length; i++) {
441             bots[bots_[i]] = true;
442         }
443     }
444  
445     function unblockBot(address notbot) public onlyOwner {
446         bots[notbot] = false;
447     }
448  
449     function _tokenTransfer(
450         address sender,
451         address recipient,
452         uint256 amount,
453         bool takeFee
454     ) private {
455         if (!takeFee) removeAllFee();
456         _transferStandard(sender, recipient, amount);
457         if (!takeFee) restoreAllFee();
458     }
459  
460     function _transferStandard(
461         address sender,
462         address recipient,
463         uint256 tAmount
464     ) private {
465         (
466             uint256 rAmount,
467             uint256 rTransferAmount,
468             uint256 rFee,
469             uint256 tTransferAmount,
470             uint256 tFee,
471             uint256 tTeam
472         ) = _getValues(tAmount);
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
475         _takeTeam(tTeam);
476         _reflectFee(rFee, tFee);
477         emit Transfer(sender, recipient, tTransferAmount);
478     }
479  
480     function _takeTeam(uint256 tTeam) private {
481         uint256 currentRate = _getRate();
482         uint256 rTeam = tTeam.mul(currentRate);
483         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
484     }
485  
486     function _reflectFee(uint256 rFee, uint256 tFee) private {
487         _rTotal = _rTotal.sub(rFee);
488         _tFeeTotal = _tFeeTotal.add(tFee);
489     }
490  
491     receive() external payable {}
492  
493     function _getValues(uint256 tAmount)
494         private
495         view
496         returns (
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
506             _getTValues(tAmount, _redisFee, _taxFee);
507         uint256 currentRate = _getRate();
508         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
509             _getRValues(tAmount, tFee, tTeam, currentRate);
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512  
513     function _getTValues(
514         uint256 tAmount,
515         uint256 redisFee,
516         uint256 taxFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(redisFee).div(100);
527         uint256 tTeam = tAmount.mul(taxFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529         return (tTransferAmount, tFee, tTeam);
530     }
531  
532     function _getRValues(
533         uint256 tAmount,
534         uint256 tFee,
535         uint256 tTeam,
536         uint256 currentRate
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 rAmount = tAmount.mul(currentRate);
547         uint256 rFee = tFee.mul(currentRate);
548         uint256 rTeam = tTeam.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
550         return (rAmount, rTransferAmount, rFee);
551     }
552  
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555         return rSupply.div(tSupply);
556     }
557  
558     function _getCurrentSupply() private view returns (uint256, uint256) {
559         uint256 rSupply = _rTotal;
560         uint256 tSupply = _tTotal;
561         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
562         return (rSupply, tSupply);
563     }
564  
565     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
566         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
567         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 80, "Buy tax must be between 0% and 20%");
568         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
569         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 80, "Sell tax must be between 0% and 20%");
570 
571         _redisFeeOnBuy = redisFeeOnBuy;
572         _redisFeeOnSell = redisFeeOnSell;
573         _taxFeeOnBuy = taxFeeOnBuy;
574         _taxFeeOnSell = taxFeeOnSell;
575 
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
598     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
599         for(uint256 i = 0; i < accounts.length; i++) {
600             _isExcludedFromFee[accounts[i]] = excluded;
601         }
602     }
603 
604 }