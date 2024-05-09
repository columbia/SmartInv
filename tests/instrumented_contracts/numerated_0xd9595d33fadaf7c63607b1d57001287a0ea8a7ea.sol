1 /**
2  *
3 */
4 
5 /**
6 
7         https://dogea.org/
8         0/0 - Renounced
9 
10 
11 
12 */
13 
14 //SPDX-License-Identifier: UNLICENSED
15 pragma solidity ^0.8.4;
16  
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22  
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25  
26     function balanceOf(address account) external view returns (uint256);
27  
28     function transfer(address recipient, uint256 amount) external returns (bool);
29  
30     function allowance(address owner, address spender) external view returns (uint256);
31  
32     function approve(address spender, uint256 amount) external returns (bool);
33  
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39  
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47  
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55  
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61  
62     function owner() public view returns (address) {
63         return _owner;
64     }
65  
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70  
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75  
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81  
82 }
83  
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90  
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94  
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104  
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113  
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117  
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128  
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134  
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143  
144     function factory() external pure returns (address);
145  
146     function WETH() external pure returns (address);
147  
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164  
165 contract DOGEA is Context, IERC20, Ownable {
166  
167     using SafeMath for uint256;
168  
169     string private constant _name = "DOGEA";
170     string private constant _symbol = "DOGEA";
171     uint8 private constant _decimals = 9;
172  
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 1000000000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181     uint256 public launchBlock;
182  
183     //Buy Fee
184     uint256 private _redisFeeOnBuy = 0;
185     uint256 private _taxFeeOnBuy = 20;
186  
187     //Sell Fee
188     uint256 private _redisFeeOnSell = 0;
189     uint256 private _taxFeeOnSell = 40;
190  
191     //Original Fee
192     uint256 private _redisFee = _redisFeeOnSell;
193     uint256 private _taxFee = _taxFeeOnSell;
194  
195     uint256 private _previousredisFee = _redisFee;
196     uint256 private _previoustaxFee = _taxFee;
197  
198     mapping(address => bool) public bots;
199     mapping(address => uint256) private cooldown;
200  
201     address payable private _developmentAddress = payable(0x94a272D4e357fd3B7d516411cB0D8aA13294b254);
202     address payable private _marketingAddress = payable(0x94a272D4e357fd3B7d516411cB0D8aA13294b254);
203  
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206  
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210  
211     uint256 public _maxTxAmount = 20000000000 * 10**9; 
212     uint256 public _maxWalletSize = 20000000000 * 10**9; 
213     uint256 public _swapTokensAtAmount = 10000000 * 10**9; 
214  
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221  
222     constructor() {
223  
224         _rOwned[_msgSender()] = _rTotal;
225  
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
352  
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357  
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
360  
361             if(to != uniswapV2Pair) {
362                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
363             }
364  
365             uint256 contractTokenBalance = balanceOf(address(this));
366             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
367  
368             if(contractTokenBalance >= _maxTxAmount)
369             {
370                 contractTokenBalance = _maxTxAmount;
371             }
372  
373             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
374                 swapTokensForEth(contractTokenBalance);
375                 uint256 contractETHBalance = address(this).balance;
376                 if (contractETHBalance > 0) {
377                     sendETHToFee(address(this).balance);
378                 }
379             }
380         }
381  
382         bool takeFee = true;
383  
384         //Transfer Tokens
385         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
386             takeFee = false;
387         } else {
388  
389             //Set Fee for Buys
390             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnBuy;
392                 _taxFee = _taxFeeOnBuy;
393             }
394  
395             //Set Fee for Sells
396             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnSell;
398                 _taxFee = _taxFeeOnSell;
399             }
400  
401         }
402  
403         _tokenTransfer(from, to, amount, takeFee);
404     }
405  
406     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
407         address[] memory path = new address[](2);
408         path[0] = address(this);
409         path[1] = uniswapV2Router.WETH();
410         _approve(address(this), address(uniswapV2Router), tokenAmount);
411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
412             tokenAmount,
413             0,
414             path,
415             address(this),
416             block.timestamp
417         );
418     }
419  
420     function sendETHToFee(uint256 amount) private {
421         _developmentAddress.transfer(amount.mul(50).div(100));
422         _marketingAddress.transfer(amount.mul(50).div(100));
423     }
424  
425     function setTrading(bool _tradingOpen) public onlyOwner {
426         tradingOpen = _tradingOpen;
427     }
428  
429     function manualswap() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractBalance = balanceOf(address(this));
432         swapTokensForEth(contractBalance);
433     }
434  
435     function manualsend() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractETHBalance = address(this).balance;
438         sendETHToFee(contractETHBalance);
439     }
440  
441     function blockBots(address[] memory bots_) public onlyOwner {
442         for (uint256 i = 0; i < bots_.length; i++) {
443             bots[bots_[i]] = true;
444         }
445     }
446  
447     function unblockBot(address notbot) public onlyOwner {
448         bots[notbot] = false;
449     }
450  
451     function _tokenTransfer(
452         address sender,
453         address recipient,
454         uint256 amount,
455         bool takeFee
456     ) private {
457         if (!takeFee) removeAllFee();
458         _transferStandard(sender, recipient, amount);
459         if (!takeFee) restoreAllFee();
460     }
461  
462     function _transferStandard(
463         address sender,
464         address recipient,
465         uint256 tAmount
466     ) private {
467         (
468             uint256 rAmount,
469             uint256 rTransferAmount,
470             uint256 rFee,
471             uint256 tTransferAmount,
472             uint256 tFee,
473             uint256 tTeam
474         ) = _getValues(tAmount);
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
477         _takeTeam(tTeam);
478         _reflectFee(rFee, tFee);
479         emit Transfer(sender, recipient, tTransferAmount);
480     }
481  
482     function _takeTeam(uint256 tTeam) private {
483         uint256 currentRate = _getRate();
484         uint256 rTeam = tTeam.mul(currentRate);
485         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
486     }
487  
488     function _reflectFee(uint256 rFee, uint256 tFee) private {
489         _rTotal = _rTotal.sub(rFee);
490         _tFeeTotal = _tFeeTotal.add(tFee);
491     }
492  
493     receive() external payable {}
494  
495     function _getValues(uint256 tAmount)
496         private
497         view
498         returns (
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
508             _getTValues(tAmount, _redisFee, _taxFee);
509         uint256 currentRate = _getRate();
510         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
511             _getRValues(tAmount, tFee, tTeam, currentRate);
512  
513         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
514     }
515  
516     function _getTValues(
517         uint256 tAmount,
518         uint256 redisFee,
519         uint256 taxFee
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 tFee = tAmount.mul(redisFee).div(100);
530         uint256 tTeam = tAmount.mul(taxFee).div(100);
531         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
532  
533         return (tTransferAmount, tFee, tTeam);
534     }
535  
536     function _getRValues(
537         uint256 tAmount,
538         uint256 tFee,
539         uint256 tTeam,
540         uint256 currentRate
541     )
542         private
543         pure
544         returns (
545             uint256,
546             uint256,
547             uint256
548         )
549     {
550         uint256 rAmount = tAmount.mul(currentRate);
551         uint256 rFee = tFee.mul(currentRate);
552         uint256 rTeam = tTeam.mul(currentRate);
553         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
554  
555         return (rAmount, rTransferAmount, rFee);
556     }
557  
558     function _getRate() private view returns (uint256) {
559         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
560  
561         return rSupply.div(tSupply);
562     }
563  
564     function _getCurrentSupply() private view returns (uint256, uint256) {
565         uint256 rSupply = _rTotal;
566         uint256 tSupply = _tTotal;
567         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
568  
569         return (rSupply, tSupply);
570     }
571  
572     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
573         _redisFeeOnBuy = redisFeeOnBuy;
574         _redisFeeOnSell = redisFeeOnSell;
575  
576         _taxFeeOnBuy = taxFeeOnBuy;
577         _taxFeeOnSell = taxFeeOnSell;
578     }
579  
580     //Set minimum tokens required to swap.
581     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
582         _swapTokensAtAmount = swapTokensAtAmount;
583     }
584  
585     //Set minimum tokens required to swap.
586     function toggleSwap(bool _swapEnabled) public onlyOwner {
587         swapEnabled = _swapEnabled;
588     }
589  
590  
591     //Set maximum transaction
592     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
593         _maxTxAmount = maxTxAmount;
594     }
595  
596     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
597         _maxWalletSize = maxWalletSize;
598     }
599  
600     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
601         for(uint256 i = 0; i < accounts.length; i++) {
602             _isExcludedFromFee[accounts[i]] = excluded;
603         }
604     }
605 }