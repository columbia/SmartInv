1 /**
2 SOCIAL INU ($TRUTH)
3 
4 Born from Elon's tweet, Social Inu is the most sociable and strongest doge token out there. The chads of $TRUTH will socialize their way to Valhalla.
5 
6 Tokenomics
7 
8 1,000,000,000 Supply
9 10,000,000 Max Wallet (1%)
10 
11 6% Buy/Sell Tax
12 
13 Liquidity Locked for 30 days
14 Ownership Renounced
15 
16 Website: Coming soon
17 Twitter : Https://twitter.com/socialInu
18 Telegram: https://t.me/SocialInu
19 */
20 
21 
22 
23 // SPDX-License-Identifier: Unlicensed
24 pragma solidity ^0.8.9;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function approve(address spender, uint256 amount) external returns (bool);
42 
43     function transferFrom(
44         address sender,
45         address recipient,
46         uint256 amount
47     ) external returns (bool);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(
51         address indexed owner,
52         address indexed spender,
53         uint256 value
54     );
55 }
56 
57 contract Ownable is Context {
58     address private _owner;
59     address private _previousOwner;
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     constructor() {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 
91 }
92 
93 library SafeMath {
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     function sub(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) {
116             return 0;
117         }
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     function div(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         return c;
135     }
136 }
137 
138 interface IUniswapV2Factory {
139     function createPair(address tokenA, address tokenB)
140         external
141         returns (address pair);
142 }
143 
144 interface IUniswapV2Router02 {
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint256 amountIn,
147         uint256 amountOutMin,
148         address[] calldata path,
149         address to,
150         uint256 deadline
151     ) external;
152 
153     function factory() external pure returns (address);
154 
155     function WETH() external pure returns (address);
156 
157     function addLiquidityETH(
158         address token,
159         uint256 amountTokenDesired,
160         uint256 amountTokenMin,
161         uint256 amountETHMin,
162         address to,
163         uint256 deadline
164     )
165         external
166         payable
167         returns (
168             uint256 amountToken,
169             uint256 amountETH,
170             uint256 liquidity
171         );
172 }
173 
174 contract SocialInu is Context, IERC20, Ownable {
175 
176     using SafeMath for uint256;
177 
178     string private constant _name = "Social Inu";
179     string private constant _symbol = "SINU";
180     uint8 private constant _decimals = 9;
181 
182     mapping(address => uint256) private _rOwned;
183     mapping(address => uint256) private _tOwned;
184     mapping(address => mapping(address => uint256)) private _allowances;
185     mapping(address => bool) private _isExcludedFromFee;
186     uint256 private constant MAX = ~uint256(0);
187     uint256 private constant _tTotal = 1000000000 * 10**9;
188     uint256 private _rTotal = (MAX - (MAX % _tTotal));
189     uint256 private _tFeeTotal;
190     uint256 private _redisFeeOnBuy = 0;
191     uint256 private _taxFeeOnBuy = 3;
192     uint256 private _redisFeeOnSell = 0;
193     uint256 private _taxFeeOnSell = 3;
194 
195     //Original Fee
196     uint256 private _redisFee = _redisFeeOnSell;
197     uint256 private _taxFee = _taxFeeOnSell;
198 
199     uint256 private _previousredisFee = _redisFee;
200     uint256 private _previoustaxFee = _taxFee;
201 
202     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
203     address payable private _developmentAddress = payable(0x2132E2D46901e56eb89D8442aEe3C2ad91379512);
204     address payable private _marketingAddress = payable(0x2132E2D46901e56eb89D8442aEe3C2ad91379512);
205 
206     IUniswapV2Router02 public uniswapV2Router;
207     address public uniswapV2Pair;
208 
209     bool private tradingOpen;
210     bool private inSwap = false;
211     bool private swapEnabled = true;
212 
213     uint256 public _maxTxAmount = 1000000000 * 10**9;
214     uint256 public _maxWalletSize = 10000000 * 10**9;
215     uint256 public _swapTokensAtAmount = 10000000 * 10**9;
216 
217     event MaxTxAmountUpdated(uint256 _maxTxAmount);
218     modifier lockTheSwap {
219         inSwap = true;
220         _;
221         inSwap = false;
222     }
223 
224     constructor() {
225 
226         _rOwned[_msgSender()] = _rTotal;
227 
228         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
229         uniswapV2Router = _uniswapV2Router;
230         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
231             .createPair(address(this), _uniswapV2Router.WETH());
232 
233         _isExcludedFromFee[owner()] = true;
234         _isExcludedFromFee[address(this)] = true;
235         _isExcludedFromFee[_developmentAddress] = true;
236         _isExcludedFromFee[_marketingAddress] = true;
237 
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240 
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244 
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248 
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252 
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256 
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260 
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278 
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304 
305     function tokenFromReflection(uint256 rAmount)
306         private
307         view
308         returns (uint256)
309     {
310         require(
311             rAmount <= _rTotal,
312             "Amount must be less than total reflections"
313         );
314         uint256 currentRate = _getRate();
315         return rAmount.div(currentRate);
316     }
317 
318     function removeAllFee() private {
319         if (_redisFee == 0 && _taxFee == 0) return;
320 
321         _previousredisFee = _redisFee;
322         _previoustaxFee = _taxFee;
323 
324         _redisFee = 0;
325         _taxFee = 0;
326     }
327 
328     function restoreAllFee() private {
329         _redisFee = _previousredisFee;
330         _taxFee = _previoustaxFee;
331     }
332 
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343 
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) private {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351         require(amount > 0, "Transfer amount must be greater than zero");
352 
353         if (from != owner() && to != owner()) {
354 
355             //Trade start check
356             if (!tradingOpen) {
357                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
358             }
359 
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
362 
363             if(to != uniswapV2Pair) {
364                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
365             }
366 
367             uint256 contractTokenBalance = balanceOf(address(this));
368             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
369 
370             if(contractTokenBalance >= _maxTxAmount)
371             {
372                 contractTokenBalance = _maxTxAmount;
373             }
374 
375             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
376                 swapTokensForEth(contractTokenBalance);
377                 uint256 contractETHBalance = address(this).balance;
378                 if (contractETHBalance > 0) {
379                     sendETHToFee(address(this).balance);
380                 }
381             }
382         }
383 
384         bool takeFee = true;
385 
386         //Transfer Tokens
387         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
388             takeFee = false;
389         } else {
390 
391             //Set Fee for Buys
392             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnBuy;
394                 _taxFee = _taxFeeOnBuy;
395             }
396 
397             //Set Fee for Sells
398             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
399                 _redisFee = _redisFeeOnSell;
400                 _taxFee = _taxFeeOnSell;
401             }
402 
403         }
404 
405         _tokenTransfer(from, to, amount, takeFee);
406     }
407 
408     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
409         address[] memory path = new address[](2);
410         path[0] = address(this);
411         path[1] = uniswapV2Router.WETH();
412         _approve(address(this), address(uniswapV2Router), tokenAmount);
413         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
414             tokenAmount,
415             0,
416             path,
417             address(this),
418             block.timestamp
419         );
420     }
421 
422     function sendETHToFee(uint256 amount) private {
423         _marketingAddress.transfer(amount);
424     }
425 
426     function setTrading(bool _tradingOpen) public onlyOwner {
427         tradingOpen = _tradingOpen;
428     }
429 
430     function manualswap() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435 
436     function manualsend() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractETHBalance = address(this).balance;
439         sendETHToFee(contractETHBalance);
440     }
441 
442     function blockBots(address[] memory bots_) public onlyOwner {
443         for (uint256 i = 0; i < bots_.length; i++) {
444             bots[bots_[i]] = true;
445         }
446     }
447 
448     function unblockBot(address notbot) public onlyOwner {
449         bots[notbot] = false;
450     }
451 
452     function _tokenTransfer(
453         address sender,
454         address recipient,
455         uint256 amount,
456         bool takeFee
457     ) private {
458         if (!takeFee) removeAllFee();
459         _transferStandard(sender, recipient, amount);
460         if (!takeFee) restoreAllFee();
461     }
462 
463     function _transferStandard(
464         address sender,
465         address recipient,
466         uint256 tAmount
467     ) private {
468         (
469             uint256 rAmount,
470             uint256 rTransferAmount,
471             uint256 rFee,
472             uint256 tTransferAmount,
473             uint256 tFee,
474             uint256 tTeam
475         ) = _getValues(tAmount);
476         _rOwned[sender] = _rOwned[sender].sub(rAmount);
477         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
478         _takeTeam(tTeam);
479         _reflectFee(rFee, tFee);
480         emit Transfer(sender, recipient, tTransferAmount);
481     }
482 
483     function _takeTeam(uint256 tTeam) private {
484         uint256 currentRate = _getRate();
485         uint256 rTeam = tTeam.mul(currentRate);
486         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
487     }
488 
489     function _reflectFee(uint256 rFee, uint256 tFee) private {
490         _rTotal = _rTotal.sub(rFee);
491         _tFeeTotal = _tFeeTotal.add(tFee);
492     }
493 
494     receive() external payable {}
495 
496     function _getValues(uint256 tAmount)
497         private
498         view
499         returns (
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
509             _getTValues(tAmount, _redisFee, _taxFee);
510         uint256 currentRate = _getRate();
511         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
512             _getRValues(tAmount, tFee, tTeam, currentRate);
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
532         return (tTransferAmount, tFee, tTeam);
533     }
534 
535     function _getRValues(
536         uint256 tAmount,
537         uint256 tFee,
538         uint256 tTeam,
539         uint256 currentRate
540     )
541         private
542         pure
543         returns (
544             uint256,
545             uint256,
546             uint256
547         )
548     {
549         uint256 rAmount = tAmount.mul(currentRate);
550         uint256 rFee = tFee.mul(currentRate);
551         uint256 rTeam = tTeam.mul(currentRate);
552         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
553         return (rAmount, rTransferAmount, rFee);
554     }
555 
556     function _getRate() private view returns (uint256) {
557         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
558         return rSupply.div(tSupply);
559     }
560 
561     function _getCurrentSupply() private view returns (uint256, uint256) {
562         uint256 rSupply = _rTotal;
563         uint256 tSupply = _tTotal;
564         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
565         return (rSupply, tSupply);
566     }
567 
568     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
569         _redisFeeOnBuy = redisFeeOnBuy;
570         _redisFeeOnSell = redisFeeOnSell;
571         _taxFeeOnBuy = taxFeeOnBuy;
572         _taxFeeOnSell = taxFeeOnSell;
573     }
574 
575     //Set minimum tokens required to swap.
576     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
577         _swapTokensAtAmount = swapTokensAtAmount;
578     }
579 
580     //Set minimum tokens required to swap.
581     function toggleSwap(bool _swapEnabled) public onlyOwner {
582         swapEnabled = _swapEnabled;
583     }
584 
585     //Set maximum transaction
586     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
587         _maxTxAmount = maxTxAmount;
588     }
589 
590     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
591         _maxWalletSize = maxWalletSize;
592     }
593 
594     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
595         for(uint256 i = 0; i < accounts.length; i++) {
596             _isExcludedFromFee[accounts[i]] = excluded;
597         }
598     }
599 
600 }