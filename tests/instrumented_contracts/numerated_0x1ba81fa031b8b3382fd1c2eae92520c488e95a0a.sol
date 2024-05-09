1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.4;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39 
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
120     external
121     returns (address pair);
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
145     external
146     payable
147     returns (
148         uint256 amountToken,
149         uint256 amountETH,
150         uint256 liquidity
151     );
152 }
153 
154 contract unitedDegens is Context, IERC20, Ownable {
155 
156     using SafeMath for uint256;
157 
158     string private constant _name = "United Degens";//
159     string private constant _symbol = "UNITED";//
160     uint8 private constant _decimals = 9;
161 
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant _tTotal = 200000000 * 10 ** 9;
166     uint256 public launchBlock;
167 
168 
169     //Liquidity Fee Buy
170     uint256 private _liquidityFeeBuy = 2;
171 
172     //Liquidity Fee Buy
173     uint256 private _devFeeBuy = 1;
174 
175     //Liquidity Fee Marketing
176     uint256 private _marketingFeeBuy = 8;
177 
178     //Liquidity Fee Sell
179     uint256 private _liquidityFeeSell = 5;
180 
181     //Liquidity Fee Buy
182     uint256 private _devFeeSell = 1;
183 
184     //Liquidity Fee Marketing
185     uint256 private _marketingFeeSell = 9;
186 
187 
188     //Buy Fee
189     uint256 private _taxFeeOnBuy = _liquidityFeeBuy + _devFeeBuy + _marketingFeeBuy;//
190 
191     //Sell Fee
192     uint256 private _taxFeeOnSell = 99;//
193 
194     //Original Fee
195     uint256 private _taxFee = _taxFeeOnSell;
196 
197     uint256 private _previoustaxFee = _taxFee;
198 
199     mapping(address => bool) public bots;
200 
201     address payable private _developmentAddress = payable(0xFFE15d77C78FBD20c4571064e161A22c4114aab3);//
202     address payable private _marketingAddress = payable(0x6173868A5e412129F5EC7f6f1116Abf779ABa47f);//
203 
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206 
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private inSend = false;
210     bool private swapEnabled = true;
211 
212     uint256 public _maxTxAmount = 1000000 * 10 ** 9; //
213     uint256 public _maxWalletSize = 2000000 * 10 ** 9; //
214     uint256 public _swapTokensAtAmount = 10000 * 10 ** 9; //
215 
216     event MaxTxAmountUpdated(uint256 _maxTxAmount);
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222 
223     modifier lockTheSend {
224         inSend = true;
225         _;
226         inSend = false;
227     }
228     constructor(address router) {
229 
230         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
231         uniswapV2Router = _uniswapV2Router;
232         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
233         .createPair(address(this), _uniswapV2Router.WETH());
234 
235         _isExcludedFromFee[owner()] = true;
236         _isExcludedFromFee[address(this)] = true;
237         _isExcludedFromFee[_developmentAddress] = true;
238         _isExcludedFromFee[_marketingAddress] = true;
239 
240         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
241         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
242         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
243         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
244         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
245         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
246         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
247         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
248         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
249         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
250         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
251 
252         _tOwned[_msgSender()] = _tTotal;
253         emit Transfer(address(0), _msgSender(), _tTotal);
254     }
255 
256     function name() public pure returns (string memory) {
257         return _name;
258     }
259 
260     function symbol() public pure returns (string memory) {
261         return _symbol;
262     }
263 
264     function decimals() public pure returns (uint8) {
265         return _decimals;
266     }
267 
268     function totalSupply() public pure override returns (uint256) {
269         return _tTotal;
270     }
271 
272     function balanceOf(address account) public view override returns (uint256) {
273         return _tOwned[account];
274     }
275 
276     function transfer(address recipient, uint256 amount)
277     public
278     override
279     returns (bool)
280     {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     function allowance(address owner, address spender)
286     public
287     view
288     override
289     returns (uint256)
290     {
291         return _allowances[owner][spender];
292     }
293 
294     function approve(address spender, uint256 amount)
295     public
296     override
297     returns (bool)
298     {
299         _approve(_msgSender(), spender, amount);
300         return true;
301     }
302 
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(
310             sender,
311             _msgSender(),
312             _allowances[sender][_msgSender()].sub(
313                 amount,
314                 "ERC20: transfer amount exceeds allowance"
315             )
316         );
317         return true;
318     }
319 
320 
321     function removeAllFee() private {
322         if (_taxFee == 0) return;
323 
324         _previoustaxFee = _taxFee;
325         _taxFee = 0;
326     }
327 
328     function restoreAllFee() private {
329         _taxFee = _previoustaxFee;
330     }
331 
332     function _approve(
333         address owner,
334         address spender,
335         uint256 amount
336     ) private {
337         require(owner != address(0), "ERC20: approve from the zero address");
338         require(spender != address(0), "ERC20: approve to the zero address");
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) private {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "Transfer amount must be greater than zero");
351 
352         if (from != owner() && to != owner()) {
353 
354             //Trade start check
355             if (!tradingOpen) {
356                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
357             }
358 
359             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
360             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
361 
362             if (block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)) {
363                 bots[to] = true;
364             }
365 
366             if (to != uniswapV2Pair) {
367                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
368             }
369 
370             uint256 contractTokenBalance = balanceOf(address(this));
371             bool canSwap = contractTokenBalance * 10 ** 9 >= _swapTokensAtAmount;
372 
373             if (contractTokenBalance >= _maxTxAmount)
374             {
375                 contractTokenBalance = _maxTxAmount;
376             }
377 
378             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
379                 swapAndLiquidate(contractTokenBalance);
380             }
381         }
382 
383         bool takeFee = true;
384 
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389 
390             //Set Fee for Buys
391             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _taxFee = _taxFeeOnBuy;
393             }
394 
395             //Set Fee for Sells
396             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
397                 _taxFee = _taxFeeOnSell;
398             }
399         }
400 
401         _tokenTransfer(from, to, amount, takeFee);
402     }
403 
404     function swapAndLiquidate(uint256 contractTokenBalance) private lockTheSwap {
405         uint256 devTokens = contractTokenBalance.mul(_devFeeBuy + _devFeeSell).div(_taxFeeOnBuy + _taxFeeOnSell);
406         uint256 marketingTokens = contractTokenBalance.mul(_marketingFeeBuy + _marketingFeeSell).div(_taxFeeOnBuy + _taxFeeOnSell);
407 
408         uint256 initialBalance = address(this).balance;
409         swapTokensForEth(devTokens + marketingTokens);
410         uint256 diffBalance = address(this).balance.sub(initialBalance);
411         uint256 devShare = diffBalance.mul(_devFeeBuy + _devFeeSell).div(_devFeeBuy + _devFeeSell + _marketingFeeBuy + _marketingFeeSell);
412         uint256 marketingShare = diffBalance.sub(devShare);
413         _developmentAddress.transfer(devShare);
414         _marketingAddress.transfer(marketingShare);
415 
416         uint256 tokensForLiquidity = contractTokenBalance.sub(devTokens).sub(marketingTokens);
417         uint256 half = tokensForLiquidity.div(2);
418         uint256 otherHalf = tokensForLiquidity.sub(half);
419 
420         initialBalance = address(this).balance;
421         swapTokensForEth(half);
422         diffBalance = address(this).balance.sub(initialBalance);
423         addLiquidity(otherHalf, diffBalance);
424     }
425 
426     function swapTokensForEth(uint256 tokenAmount) private {
427         address[] memory path = new address[](2);
428         path[0] = address(this);
429         path[1] = uniswapV2Router.WETH();
430         _approve(address(this), address(uniswapV2Router), tokenAmount);
431         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
432             tokenAmount,
433             0,
434             path,
435             address(this),
436             block.timestamp
437         );
438     }
439 
440     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
441         // approve token transfer to cover all possible scenarios
442         _approve(address(this), address(uniswapV2Router), tokenAmount);
443 
444         // add the liquidity
445         uniswapV2Router.addLiquidityETH{value : ethAmount}(
446             address(this),
447             tokenAmount,
448             0, // slippage is unavoidable
449             0, // slippage is unavoidable
450             owner(),
451             block.timestamp
452         );
453     }
454 
455     function sendETHToFee(uint256 amount) private {
456         _developmentAddress.transfer(amount.div(2));
457         _marketingAddress.transfer(amount.div(2));
458     }
459 
460     function setTrading(bool _tradingOpen) public onlyOwner {
461         tradingOpen = _tradingOpen;
462         launchBlock = block.number;
463     }
464 
465     function manualswap() external {
466         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
467         uint256 contractBalance = balanceOf(address(this));
468         swapAndLiquidate(contractBalance);
469     }
470 
471     function manualsend() external lockTheSend {
472         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
473         uint256 contractETHBalance = address(this).balance;
474 
475         uint256 devShare = contractETHBalance.mul(_devFeeBuy + _devFeeSell).div(_devFeeBuy + _devFeeSell + _marketingFeeBuy + _marketingFeeSell);
476         uint256 marketingShare = contractETHBalance.sub(devShare);
477         _developmentAddress.transfer(devShare);
478         _marketingAddress.transfer(marketingShare);
479     }
480 
481     function blockBots(address[] memory bots_) public onlyOwner {
482         for (uint256 i = 0; i < bots_.length; i++) {
483             bots[bots_[i]] = true;
484         }
485     }
486 
487     function unblockBot(address notbot) public onlyOwner {
488         bots[notbot] = false;
489     }
490 
491     function _tokenTransfer(
492         address sender,
493         address recipient,
494         uint256 amount,
495         bool takeFee
496     ) private {
497         if (!takeFee) removeAllFee();
498         _transferStandard(sender, recipient, amount);
499         if (!takeFee) restoreAllFee();
500     }
501 
502     function _transferStandard(
503         address sender,
504         address recipient,
505         uint256 tAmount
506     ) private {
507         (
508         uint256 tTransferAmount,
509         uint256 tTeam
510         ) = _getValues(tAmount);
511         _tOwned[sender] = _tOwned[sender].sub(tTransferAmount);
512         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
513         _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
514         emit Transfer(sender, recipient, tTransferAmount);
515     }
516 
517 
518     receive() external payable {}
519 
520     function _getValues(uint256 tAmount)
521     private
522     view
523     returns (
524         uint256,
525         uint256
526     )
527     {
528 
529         (uint256 tTransferAmount, uint256 tTeam) =
530         _getTValues(tAmount, _taxFee);
531 
532         return (tTransferAmount, tTeam);
533     }
534 
535     function _getTValues(
536         uint256 tAmount,
537         uint256 taxFee
538     )
539     private
540     pure
541     returns (
542         uint256,
543         uint256
544     )
545     {
546         uint256 tTeam = tAmount.mul(taxFee).div(100);
547         uint256 tTransferAmount = tAmount.sub(tTeam);
548 
549         return (tTransferAmount, tTeam);
550     }
551 
552     function setFee(uint256 liquidityFeeBuy, uint256 marketingFeeBuy, uint256 liquidityFeeSell, uint256 marketingFeeSell) public onlyOwner {
553         _liquidityFeeBuy = liquidityFeeBuy;
554         _marketingFeeBuy = marketingFeeBuy;
555         _liquidityFeeSell = liquidityFeeSell;
556         _marketingFeeSell = marketingFeeSell;
557 
558         _taxFeeOnSell = _liquidityFeeSell + _devFeeSell + _marketingFeeSell;
559     }
560 
561     //Set minimum tokens required to swap.
562     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
563         _swapTokensAtAmount = swapTokensAtAmount;
564     }
565 
566     //Set minimum tokens required to swap.
567     function toggleSwap(bool _swapEnabled) public onlyOwner {
568         swapEnabled = _swapEnabled;
569     }
570 
571 
572     //Set maximum transaction
573     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
574         _maxTxAmount = maxTxAmount;
575     }
576 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = maxWalletSize;
579     }
580 
581     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
582         for (uint256 i = 0; i < accounts.length; i++) {
583             _isExcludedFromFee[accounts[i]] = excluded;
584         }
585     }
586 
587     function isExcludedFromFee(address account) public onlyOwner view returns (bool) {
588         return _isExcludedFromFee[account];
589     }
590 }