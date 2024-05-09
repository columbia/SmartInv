1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.9;
4 
5  
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11  
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14  
15     function balanceOf(address account) external view returns (uint256);
16  
17     function transfer(address recipient, uint256 amount) external returns (bool);
18  
19     function allowance(address owner, address spender) external view returns (uint256);
20  
21     function approve(address spender, uint256 amount) external returns (bool);
22  
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28  
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36  
37 contract Ownable is Context {
38     address internal _owner;
39     address private _previousOwner;
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44  
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50  
51     function owner() public view returns (address) {
52         return _owner;
53     }
54  
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59  
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64  
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70  
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79  
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83  
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93  
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102  
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106  
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 }
117  
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123  
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132  
133     function factory() external pure returns (address);
134  
135     function WETH() external pure returns (address);
136  
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153  
154 contract MickeyMouse  is Context, IERC20, Ownable {
155  
156     using SafeMath for uint256;
157  
158     string private constant _name = "Mickey Mouse";
159     string private constant _symbol = "MICKEY";
160     uint8 private constant _decimals = 9;
161  
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 100000000 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170     uint256 private _redisFeeOnBuy = 0;  
171     uint256 private _taxFeeOnBuy = 10;  
172     uint256 private _redisFeeOnSell = 0;  
173     uint256 private _taxFeeOnSell = 15;
174  
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177  
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180  
181     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
182     address payable private _developmentAddress = payable(0xfBe28AD606F72BC83EbA51934f1137B1F1de8A83); 
183     address payable private _marketingAddress = payable(0xfBe28AD606F72BC83EbA51934f1137B1F1de8A83);
184  
185     IUniswapV2Router02 public uniswapV2Router;
186     address public uniswapV2Pair;
187  
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191  
192     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
193     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
194     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
195  
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202  
203     constructor() {
204  
205         _rOwned[_msgSender()] = _rTotal;
206  
207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
208         uniswapV2Router = _uniswapV2Router;
209         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
210             .createPair(address(this), _uniswapV2Router.WETH());
211  
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[_developmentAddress] = true;
215         _isExcludedFromFee[_marketingAddress] = true;
216  
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219  
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223  
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227  
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231  
232     function totalSupply() public pure override returns (uint256) {
233         return _tTotal;
234     }
235  
236     function balanceOf(address account) public view override returns (uint256) {
237         return tokenFromReflection(_rOwned[account]);
238     }
239  
240     function transfer(address recipient, uint256 amount)
241         public
242         override
243         returns (bool)
244     {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248  
249     function allowance(address owner, address spender)
250         public
251         view
252         override
253         returns (uint256)
254     {
255         return _allowances[owner][spender];
256     }
257  
258     function approve(address spender, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266  
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public override returns (bool) {
272         _transfer(sender, recipient, amount);
273         _approve(
274             sender,
275             _msgSender(),
276             _allowances[sender][_msgSender()].sub(
277                 amount,
278                 "ERC20: transfer amount exceeds allowance"
279             )
280         );
281         return true;
282     }
283  
284     function tokenFromReflection(uint256 rAmount)
285         private
286         view
287         returns (uint256)
288     {
289         require(
290             rAmount <= _rTotal,
291             "Amount must be less than total reflections"
292         );
293         uint256 currentRate = _getRate();
294         return rAmount.div(currentRate);
295     }
296  
297     function removeAllFee() private {
298         if (_redisFee == 0 && _taxFee == 0) return;
299  
300         _previousredisFee = _redisFee;
301         _previoustaxFee = _taxFee;
302  
303         _redisFee = 0;
304         _taxFee = 0;
305     }
306  
307     function restoreAllFee() private {
308         _redisFee = _previousredisFee;
309         _taxFee = _previoustaxFee;
310     }
311  
312     function _approve(
313         address owner,
314         address spender,
315         uint256 amount
316     ) private {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322  
323     function _transfer(
324         address from,
325         address to,
326         uint256 amount
327     ) private {
328         require(from != address(0), "ERC20: transfer from the zero address");
329         require(to != address(0), "ERC20: transfer to the zero address");
330         require(amount > 0, "Transfer amount must be greater than zero");
331  
332         if (from != owner() && to != owner()) {
333  
334             //Trade start check
335             if (!tradingOpen) {
336                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
337             }
338  
339             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
340             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
341  
342             if(to != uniswapV2Pair) {
343                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
344             }
345  
346             uint256 contractTokenBalance = balanceOf(address(this));
347             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
348  
349             if(contractTokenBalance >= _maxTxAmount)
350             {
351                 contractTokenBalance = _maxTxAmount;
352             }
353  
354             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
355                 swapTokensForEth(contractTokenBalance);
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362  
363         bool takeFee = true;
364  
365         //Transfer Tokens
366         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
367             takeFee = false;
368         } else {
369  
370             //Set Fee for Buys
371             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
372                 _redisFee = _redisFeeOnBuy;
373                 _taxFee = _taxFeeOnBuy;
374             }
375  
376             //Set Fee for Sells
377             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnSell;
379                 _taxFee = _taxFeeOnSell;
380             }
381  
382         }
383  
384         _tokenTransfer(from, to, amount, takeFee);
385     }
386  
387     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
388         address[] memory path = new address[](2);
389         path[0] = address(this);
390         path[1] = uniswapV2Router.WETH();
391         _approve(address(this), address(uniswapV2Router), tokenAmount);
392         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
393             tokenAmount,
394             0,
395             path,
396             address(this),
397             block.timestamp
398         );
399     }
400  
401     function sendETHToFee(uint256 amount) private {
402         _marketingAddress.transfer(amount.mul(3).div(5));
403         _developmentAddress.transfer(amount.mul(2).div(5));
404     }
405  
406     function setTrading(bool _tradingOpen) public onlyOwner {
407         tradingOpen = _tradingOpen;
408     }
409  
410     function manualswap() external {
411         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
412         uint256 contractBalance = balanceOf(address(this));
413         swapTokensForEth(contractBalance);
414     }
415  
416     function manualsend() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractETHBalance = address(this).balance;
419         sendETHToFee(contractETHBalance);
420     }
421  
422     function blockBots(address[] memory bots_) public onlyOwner {
423         for (uint256 i = 0; i < bots_.length; i++) {
424             bots[bots_[i]] = true;
425         }
426     }
427  
428     function unblockBot(address notbot) public onlyOwner {
429         bots[notbot] = false;
430     }
431  
432     function _tokenTransfer(
433         address sender,
434         address recipient,
435         uint256 amount,
436         bool takeFee
437     ) private {
438         if (!takeFee) removeAllFee();
439         _transferStandard(sender, recipient, amount);
440         if (!takeFee) restoreAllFee();
441     }
442  
443     function _transferStandard(
444         address sender,
445         address recipient,
446         uint256 tAmount
447     ) private {
448         (
449             uint256 rAmount,
450             uint256 rTransferAmount,
451             uint256 rFee,
452             uint256 tTransferAmount,
453             uint256 tFee,
454             uint256 tTeam
455         ) = _getValues(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
458         _takeTeam(tTeam);
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462  
463     function _takeTeam(uint256 tTeam) private {
464         uint256 currentRate = _getRate();
465         uint256 rTeam = tTeam.mul(currentRate);
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468  
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473  
474     receive() external payable {}
475  
476     function _getValues(uint256 tAmount)
477         private
478         view
479         returns (
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
489             _getTValues(tAmount, _redisFee, _taxFee);
490         uint256 currentRate = _getRate();
491         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
492             _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495  
496     function _getTValues(
497         uint256 tAmount,
498         uint256 redisFee,
499         uint256 taxFee
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 tFee = tAmount.mul(redisFee).div(100);
510         uint256 tTeam = tAmount.mul(taxFee).div(100);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
512         return (tTransferAmount, tFee, tTeam);
513     }
514  
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533         return (rAmount, rTransferAmount, rFee);
534     }
535  
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538         return rSupply.div(tSupply);
539     }
540  
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547  
548     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
549         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
550         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 30, "Buy tax must be between 0% and 30%");
551         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
552         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
553 
554         _redisFeeOnBuy = redisFeeOnBuy;
555         _redisFeeOnSell = redisFeeOnSell;
556         _taxFeeOnBuy = taxFeeOnBuy;
557         _taxFeeOnSell = taxFeeOnSell;
558 
559     }
560  
561     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
562         _swapTokensAtAmount = swapTokensAtAmount;
563     }
564  
565     function toggleSwap(bool _swapEnabled) public onlyOwner {
566         swapEnabled = _swapEnabled;
567     }
568  
569     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
570         require(amountPercent>0);
571         _maxTxAmount = (_tTotal * amountPercent ) / 100;
572     }
573 
574     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
575         require(amountPercent>0);
576         _maxWalletSize = (_tTotal * amountPercent ) / 100;
577     }
578 
579     function removeLimits() external onlyOwner{
580         _maxTxAmount = _tTotal;
581         _maxWalletSize = _tTotal;
582     }
583  
584     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
585         for(uint256 i = 0; i < accounts.length; i++) {
586             _isExcludedFromFee[accounts[i]] = excluded;
587         }
588     }
589 
590 }