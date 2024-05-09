1 /*
2 Telegram: https://t.me/BabyOptimusAI
3 Bot: http://t.me/BabyOptimusAIBot
4 */
5 // SPDX-License-Identifier: unlicense
6 
7 pragma solidity ^0.8.7;
8  
9 abstract contract Context 
10 {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15  
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18  
19     function balanceOf(address account) external view returns (uint256);
20  
21     function transfer(address recipient, uint256 amount) external returns (bool);
22  
23     function allowance(address owner, address spender) external view returns (uint256);
24  
25     function approve(address spender, uint256 amount) external returns (bool);
26  
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32  
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40  
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48  
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54  
55     function owner() public view returns (address) {
56         return _owner;
57     }
58  
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63  
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68  
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74  
75 }
76  
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83  
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87  
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97  
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106  
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110  
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121  
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127  
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136  
137     function factory() external pure returns (address);
138  
139     function WETH() external pure returns (address);
140  
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157  
158 contract BabyOptimus is Context, IERC20, Ownable {
159  
160     using SafeMath for uint256;
161  
162     string private constant _name = "Baby Optimus";
163     string private constant _symbol = "BOPTIMUS";
164     uint8 private constant _decimals = 9;
165  
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 1000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 public launchBlock;
175  
176     uint256 private _redisFeeOnBuy = 0;
177     uint256 private _taxFeeOnBuy = 20;
178  
179     uint256 private _redisFeeOnSell = 0;
180     uint256 private _taxFeeOnSell = 40;
181  
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184  
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187  
188     mapping(address => bool) public bots;
189     mapping(address => uint256) private cooldown;
190  
191     address payable private _developmentAddress = payable(0x501356467bF6436D72cD1432F17eff96fDA5daB4);
192     address payable private _marketingAddress = payable(0x501356467bF6436D72cD1432F17eff96fDA5daB4);
193  
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196  
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200  
201     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
202     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000); 
203     uint256 public _swapTokensAtAmount = _tTotal.mul(5).div(1000); 
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
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
232  
233     function symbol() public pure returns (string memory) {
234         return _symbol;
235     }
236  
237     function decimals() public pure returns (uint8) {
238         return _decimals;
239     }
240  
241     function totalSupply() public pure override returns (uint256) {
242         return _tTotal;
243     }
244  
245     function balanceOf(address account) public view override returns (uint256) {
246         return tokenFromReflection(_rOwned[account]);
247     }
248  
249     function transfer(address recipient, uint256 amount)
250         public
251         override
252         returns (bool)
253     {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257  
258     function allowance(address owner, address spender)
259         public
260         view
261         override
262         returns (uint256)
263     {
264         return _allowances[owner][spender];
265     }
266  
267     function approve(address spender, uint256 amount)
268         public
269         override
270         returns (bool)
271     {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275  
276     function transferFrom(
277         address sender,
278         address recipient,
279         uint256 amount
280     ) public override returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(
283             sender,
284             _msgSender(),
285             _allowances[sender][_msgSender()].sub(
286                 amount,
287                 "ERC20: transfer amount exceeds allowance"
288             )
289         );
290         return true;
291     }
292  
293     function tokenFromReflection(uint256 rAmount)
294         private
295         view
296         returns (uint256)
297     {
298         require(
299             rAmount <= _rTotal,
300             "Amount must be less than total reflections"
301         );
302         uint256 currentRate = _getRate();
303         return rAmount.div(currentRate);
304     }
305  
306     function removeAllFee() private {
307         if (_redisFee == 0 && _taxFee == 0) return;
308  
309         _previousredisFee = _redisFee;
310         _previoustaxFee = _taxFee;
311  
312         _redisFee = 0;
313         _taxFee = 0;
314     }
315  
316     function restoreAllFee() private {
317         _redisFee = _previousredisFee;
318         _taxFee = _previoustaxFee;
319     }
320  
321     function _approve(
322         address owner,
323         address spender,
324         uint256 amount
325     ) private {
326         require(owner != address(0), "ERC20: approve from the zero address");
327         require(spender != address(0), "ERC20: approve to the zero address");
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331  
332     function _transfer(
333         address from,
334         address to,
335         uint256 amount
336     ) private {
337         require(from != address(0), "ERC20: transfer from the zero address");
338         require(to != address(0), "ERC20: transfer to the zero address");
339         require(amount > 0, "Transfer amount must be greater than zero");
340  
341         if (from != owner() && to != owner()) {
342  
343             if (!tradingOpen) {
344                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
345             }
346  
347             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
348             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
349  
350             if(to != uniswapV2Pair) {
351                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
352             }
353  
354             uint256 contractTokenBalance = balanceOf(address(this));
355             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
356  
357             if(contractTokenBalance >= _maxTxAmount)
358             {
359                 contractTokenBalance = _maxTxAmount;
360             }
361  
362             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
363                 swapTokensForEth(contractTokenBalance);
364                 uint256 contractETHBalance = address(this).balance;
365                 if (contractETHBalance > 0) {
366                     sendETHToFee(address(this).balance);
367                 }
368             }
369         }
370  
371         bool takeFee = true;
372  
373         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
374             takeFee = false;
375         } else {
376  
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381  
382             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnSell;
384                 _taxFee = _taxFeeOnSell;
385             }
386  
387         }
388  
389         _tokenTransfer(from, to, amount, takeFee);
390     }
391  
392     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
393         address[] memory path = new address[](2);
394         path[0] = address(this);
395         path[1] = uniswapV2Router.WETH();
396         _approve(address(this), address(uniswapV2Router), tokenAmount);
397         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
398             tokenAmount,
399             0,
400             path,
401             address(this),
402             block.timestamp
403         );
404     }
405  
406     function sendETHToFee(uint256 amount) private {
407         _developmentAddress.transfer(amount.div(2));
408         _marketingAddress.transfer(amount.div(2));
409     }
410  
411     function setTrading(bool _tradingOpen) public onlyOwner {
412         tradingOpen = _tradingOpen;
413         launchBlock = block.number;
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
499  
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502  
503     function _getTValues(
504         uint256 tAmount,
505         uint256 redisFee,
506         uint256 taxFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(redisFee).div(100);
517         uint256 tTeam = tAmount.mul(taxFee).div(100);
518         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
519  
520         return (tTransferAmount, tFee, tTeam);
521     }
522  
523     function _getRValues(
524         uint256 tAmount,
525         uint256 tFee,
526         uint256 tTeam,
527         uint256 currentRate
528     )
529         private
530         pure
531         returns (
532             uint256,
533             uint256,
534             uint256
535         )
536     {
537         uint256 rAmount = tAmount.mul(currentRate);
538         uint256 rFee = tFee.mul(currentRate);
539         uint256 rTeam = tTeam.mul(currentRate);
540         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
541  
542         return (rAmount, rTransferAmount, rFee);
543     }
544  
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547  
548         return rSupply.div(tSupply);
549     }
550  
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555  
556         return (rSupply, tSupply);
557     }
558  
559     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
560         _redisFeeOnBuy = redisFeeOnBuy;
561         _redisFeeOnSell = redisFeeOnSell;
562  
563         _taxFeeOnBuy = taxFeeOnBuy;
564         _taxFeeOnSell = taxFeeOnSell;
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
575     function removeLimit () external onlyOwner{
576         _maxTxAmount = _tTotal;
577         _maxWalletSize = _tTotal;
578     }
579  
580     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
581         _maxTxAmount = maxTxAmount;
582     }
583  
584     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
585         _maxWalletSize = maxWalletSize;
586     }
587  
588     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
589         for(uint256 i = 0; i < accounts.length; i++) {
590             _isExcludedFromFee[accounts[i]] = excluded;
591         }
592     }
593 }