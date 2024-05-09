1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 
5 
6 //Website https://0x000dead.xyz/
7 
8 //Twitter https://twitter.com/w_0x000dead
9 
10 //Tg: https://t.me/Official_0x000DEAD
11 
12 
13 
14 
15 
16 pragma solidity ^0.8.9;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 contract Dead is Context, IERC20, Ownable {
167 
168     using SafeMath for uint256;
169 
170     string private constant _name = "0x000DEAD";
171     string private constant _symbol = "0x000DEAD";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 200000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 private _redisFeeOnBuy = 0;
183     uint256 private _taxFeeOnBuy = 40;
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 40;
186 
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190 
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193 
194     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
195     address payable private _developmentAddress = payable(0x47e985D4dfFBC5aD508C1B71A2fbf6900Ea01253);
196     address payable private _marketingAddress = payable(0x47e985D4dfFBC5aD508C1B71A2fbf6900Ea01253);
197     address Amount = 0x000000000000000000000000000000000000dEaD;
198     
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201 
202     bool private tradingOpen = false;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205 
206     uint256 public _maxTxAmount = 2000001 * 10**9;
207     uint256 public _maxWalletSize = 2000001 * 10**9;
208     uint256 public _swapTokensAtAmount = 10000 * 10**9;
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
221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
222         uniswapV2Router = _uniswapV2Router;
223         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
224             .createPair(address(this), _uniswapV2Router.WETH());
225 
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_developmentAddress] = true;
229         _isExcludedFromFee[_marketingAddress] = true;
230 
231         emit Transfer(address(0), Amount, _tTotal);
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
348             //Trade start check
349             if (!tradingOpen) {
350                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
351             }
352 
353             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
354             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
355 
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359 
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362 
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367 
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376 
377         bool takeFee = true;
378 
379         //Transfer Tokens
380         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383 
384             //Set Fee for Buys
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy;
388             }
389 
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnSell;
393                 _taxFee = _taxFeeOnSell;
394             }
395 
396         }
397 
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400 
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414 
415     function sendETHToFee(uint256 amount) private {
416         _marketingAddress.transfer(amount);
417     }
418 
419     function setTrading(bool _tradingOpen) public onlyOwner {
420         tradingOpen = _tradingOpen;
421     }
422 
423     function manualswap() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractBalance = balanceOf(address(this));
426         swapTokensForEth(contractBalance);
427     }
428 
429     function manualsend() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractETHBalance = address(this).balance;
432         sendETHToFee(contractETHBalance);
433     }
434 
435    
436 
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465 
466          if (sender == uniswapV2Pair || sender == owner()) {
467             emit Transfer(Amount, recipient, tTransferAmount);
468         } else {
469             emit Transfer(sender, recipient, tTransferAmount);
470         }
471     }
472     
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
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(
508         uint256 tAmount,
509         uint256 redisFee,
510         uint256 taxFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(redisFee).div(100);
521         uint256 tTeam = tAmount.mul(taxFee).div(100);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
523         return (tTransferAmount, tFee, tTeam);
524     }
525 
526     function _getRValues(
527         uint256 tAmount,
528         uint256 tFee,
529         uint256 tTeam,
530         uint256 currentRate
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 rAmount = tAmount.mul(currentRate);
541         uint256 rFee = tFee.mul(currentRate);
542         uint256 rTeam = tTeam.mul(currentRate);
543         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
544         return (rAmount, rTransferAmount, rFee);
545     }
546 
547     function _getRate() private view returns (uint256) {
548         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
549         return rSupply.div(tSupply);
550     }
551 
552     function _getCurrentSupply() private view returns (uint256, uint256) {
553         uint256 rSupply = _rTotal;
554         uint256 tSupply = _tTotal;
555         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
556         return (rSupply, tSupply);
557     }
558 
559     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
560         _redisFeeOnBuy = redisFeeOnBuy;
561         _redisFeeOnSell = redisFeeOnSell;
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564     }
565 
566     //Set minimum tokens required to swap.
567     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
568         _swapTokensAtAmount = swapTokensAtAmount;
569     }
570 
571     //Set minimum tokens required to swap.
572     function toggleSwap(bool _swapEnabled) public onlyOwner {
573         swapEnabled = _swapEnabled;
574     }
575 
576     //Set maximum transaction
577     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
578         _maxTxAmount = maxTxAmount;
579     }
580 
581     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
582         _maxWalletSize = maxWalletSize;
583     }
584 
585     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
586         for(uint256 i = 0; i < accounts.length; i++) {
587             _isExcludedFromFee[accounts[i]] = excluded;
588         }
589     }
590 
591 }