1 /***************************************************************************
2 
3 SquareDAO Art
4 
5 https://squaredao.art
6 
7 ****************************************************************************/
8 
9 pragma solidity ^0.8.7;
10 // SPDX-License-Identifier: Unlicensed
11 
12 abstract contract Withdrawable {
13     address internal _withdrawAddress;
14 
15     constructor(address withdrawAddress__) {
16         _withdrawAddress = withdrawAddress__;
17     }
18 
19     modifier onlyWithdrawer() {
20         require(msg.sender == _withdrawAddress);
21         _;
22     }
23 
24     function withdraw() external onlyWithdrawer {
25         _withdraw();
26     }
27 
28     function _withdraw() internal {
29         payable(_withdrawAddress).transfer(address(this).balance);
30     }
31 
32     function setWithdrawAddress(address newWithdrawAddress)
33         external
34         onlyWithdrawer
35     {
36         _withdrawAddress = newWithdrawAddress;
37     }
38 
39     function withdrawAddress() external view returns (address) {
40         return _withdrawAddress;
41     }
42 }
43 
44 
45 abstract contract Ownable {
46     address _owner;
47 
48     modifier onlyOwner() {
49         require(msg.sender == _owner);
50         _;
51     }
52 
53     constructor() {
54         _owner = msg.sender;
55     }
56 
57     function transferOwnership(address newOwner) external onlyOwner {
58         _owner = newOwner;
59     }
60 
61     function owner() external view returns (address) {
62         return _owner;
63     }
64 }
65 
66 interface IUniswapV2Factory {
67     function createPair(address tokenA, address tokenB)
68         external
69         returns (address pair);
70 
71     function getPair(address tokenA, address tokenB)
72         external
73         view
74         returns (address pair);
75 }
76 
77 interface IUniswapV2Router02 {
78     function swapExactTokensForETH(
79         uint256 amountIn,
80         uint256 amountOutMin,
81         address[] calldata path,
82         address to,
83         uint256 deadline
84     ) external;
85 
86     function swapExactTokensForETHSupportingFeeOnTransferTokens(
87         uint256 amountIn,
88         uint256 amountOutMin,
89         address[] calldata path,
90         address to,
91         uint256 deadline
92     ) external;
93 
94     function swapETHForExactTokens(
95         uint256 amountOut,
96         address[] calldata path,
97         address to,
98         uint256 deadline
99     ) external payable returns (uint256[] memory amounts);
100 
101     function factory() external pure returns (address);
102 
103     function WETH() external pure returns (address);
104 
105     function addLiquidityETH(
106         address token,
107         uint256 amountTokenDesired,
108         uint256 amountTokenMin,
109         uint256 amountETHMin,
110         address to,
111         uint256 deadline
112     )
113         external
114         payable
115         returns (
116             uint256 amountToken,
117             uint256 amountETH,
118             uint256 liquidity
119         );
120 }
121 
122 
123 contract DoubleSwapped {
124     bool internal _inSwap;
125 
126     modifier lockTheSwap() {
127         _inSwap = true;
128         _;
129         _inSwap = false;
130     }
131 
132     function _swapTokensForEth(
133         uint256 tokenAmount,
134         IUniswapV2Router02 _uniswapV2Router
135     ) internal lockTheSwap {
136         // generate the uniswap pair path of token -> weth
137         address[] memory path = new address[](2);
138         path[0] = address(this);
139         path[1] = _uniswapV2Router.WETH();
140 
141         // make the swap
142         //console.log("doubleSwap ", tokenAmount);
143         _uniswapV2Router.swapExactTokensForETH(
144             tokenAmount,
145             0, // accept any amount of ETH
146             path,
147             address(this), // The contract
148             block.timestamp
149         );
150     }
151 
152     function _swapTokensForEthOnTransfer(
153         uint256 transferAmount,
154         uint256 swapCount,
155         IUniswapV2Router02 _uniswapV2Router
156     ) internal {
157         if (swapCount == 0) return;
158         uint256 maxSwapCount = 2 * transferAmount;
159         if (swapCount > maxSwapCount) swapCount = maxSwapCount;
160         _swapTokensForEth(swapCount, _uniswapV2Router);
161     }
162 }
163 
164 interface IERC20 {
165     function totalSupply() external view returns (uint256);
166 
167     function balanceOf(address account) external view returns (uint256);
168 
169     function transfer(address recipient, uint256 amount)
170         external
171         returns (bool);
172 
173     function allowance(address owner, address spender)
174         external
175         view
176         returns (uint256);
177 
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     event Transfer(address indexed from, address indexed to, uint256 value);
187     event Approval(
188         address indexed owner,
189         address indexed spender,
190         uint256 value
191     );
192 }
193 
194 
195 abstract contract ERC20 is IERC20 {
196     uint256 internal _totalSupply = 1e20;
197     uint8 constant _decimals = 9;
198     string _name;
199     string _symbol;
200     mapping(address => uint256) internal _balances;
201     mapping(address => mapping(address => uint256)) internal _allowances;
202     uint256 internal constant INFINITY_ALLOWANCE = 2**256 - 1;
203 
204     constructor(string memory name_, string memory symbol_) {
205         _name = name_;
206         _symbol = symbol_;
207     }
208 
209     function name() external view returns (string memory) {
210         return _name;
211     }
212 
213     function symbol() external view returns (string memory) {
214         return _symbol;
215     }
216 
217     function decimals() external pure returns (uint8) {
218         return _decimals;
219     }
220 
221     function totalSupply() external view override returns (uint256) {
222         return _totalSupply;
223     }
224 
225     function balanceOf(address account) external virtual override view returns (uint256);
226 
227     function transfer(address recipient, uint256 amount)
228         external
229         override
230         returns (bool)
231     {
232         _transfer(msg.sender, recipient, amount);
233         return true;
234     }
235 
236     function _transfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {
241         uint256 senderBalance = _balances[from];
242         require(senderBalance >= amount);
243         unchecked {
244             _balances[from] = senderBalance - amount;
245         }
246         _balances[to] += amount;
247         emit Transfer(from, to, amount);
248     }
249 
250     function allowance(address owner, address spender)
251         external
252         view
253         override
254         returns (uint256)
255     {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount)
260         external
261         override
262         returns (bool)
263     {
264         _approve(msg.sender, spender, amount);
265         return true;
266     }
267 
268     function _approve(
269         address owner,
270         address spender,
271         uint256 amount
272     ) internal virtual {
273         _allowances[owner][spender] = amount;
274         emit Approval(owner, spender, amount);
275     }
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) external override returns (bool) {
282         _transfer(sender, recipient, amount);
283 
284         uint256 currentAllowance = _allowances[sender][msg.sender];
285         require(currentAllowance >= amount);
286         if (currentAllowance == INFINITY_ALLOWANCE) return true;
287         unchecked {
288             _approve(sender, msg.sender, currentAllowance - amount);
289         }
290 
291         return true;
292     }
293 
294     function _burn(address account, uint256 amount) internal virtual {
295         require(account != address(0));
296 
297         uint256 accountBalance = _balances[account];
298         require(accountBalance >= amount);
299         unchecked {
300             _balances[account] = accountBalance - amount;
301         }
302         _totalSupply -= amount;
303 
304         emit Transfer(account, address(0), amount);
305     }
306 }
307 
308 abstract contract MaxWalletDynamic {
309     uint256 startMaxWallet;
310     uint256 startTime; // last increment time
311     uint256 constant startMaxBuyPercentil = 5; // maximum buy on start 1000=100%
312     uint256 constant maxBuyIncrementMinutesTimer = 2; // increment maxbuy minutes
313     uint256 constant maxBuyIncrementPercentil = 3; // increment maxbyu percentil 1000=100%
314     uint256 constant maxIncrements = 1000; // maximum time incrementations
315     uint256 maxBuyIncrementValue; // value for increment maxBuy
316 
317     function startMaxWalletDynamic(uint256 totalSupply) internal {
318         startTime = block.timestamp;
319         startMaxWallet = (totalSupply * startMaxBuyPercentil) / 1000;
320         maxBuyIncrementValue = (totalSupply * maxBuyIncrementPercentil) / 1000;
321     }
322 
323     function checkMaxWallet(uint256 walletSize) internal view {
324         require(walletSize <= getMaxWallet(), "max wallet limit");
325     }
326 
327     function getMaxWallet() public view returns (uint256) {
328         uint256 incrementCount = (block.timestamp - startTime) /
329             (maxBuyIncrementMinutesTimer * 1 minutes);
330         if (incrementCount >= maxIncrements) incrementCount = maxIncrements;
331         return startMaxWallet + maxBuyIncrementValue * incrementCount;
332     }
333 
334     function _setStartMaxWallet(uint256 startMaxWallet_) internal {
335         startMaxWallet = startMaxWallet_;
336     }
337 }
338 
339 abstract contract TradableErc20 is ERC20, DoubleSwapped, Ownable, Withdrawable {
340     IUniswapV2Router02 internal constant _uniswapV2Router =
341         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
342     address public uniswapPair;
343     bool public buyEnable = true;
344     address private ADDR_BURN =
345         0x000000000000000000000000000000000000dEaD;
346     address public extraAddress;
347     mapping(address => bool) _isExcludedFromFee;
348     uint256 public buyFeePpm = 70; // fee in 1/1000
349     uint256 public sellFeePpm = 75; // fee in 1/1000
350     uint256 public thisShare = 1000; // in 1/1000
351     uint256 public extraShare = 0; // in 1/1000
352     uint256 maxWalletStart = 5e16;
353     uint256 addMaxWalletPerMinute = 5e16;
354     uint256 tradingStartTime;
355     
356 
357     constructor(string memory name_, string memory symbol_)
358         ERC20(name_, symbol_)
359         Withdrawable(0x15B35B2261FeFA206a7112FE97de2754585Ac3BC)
360     {
361         _isExcludedFromFee[address(0)] = true;
362         _isExcludedFromFee[ADDR_BURN] = true;
363         _isExcludedFromFee[address(this)] = true;
364         _isExcludedFromFee[msg.sender] = true;
365         ADDR_BURN = address(this);
366     }
367 
368     receive() external payable {}
369 
370     function maxWallet() public view returns (uint256) {
371         if (tradingStartTime == 0) return _totalSupply;
372         uint256 res = maxWalletStart +
373             ((block.timestamp - tradingStartTime) * addMaxWalletPerMinute) /
374             (1 minutes);
375         if (res > _totalSupply) return _totalSupply;
376         return res;
377     }
378 
379     function createLiquidity() public onlyOwner {
380         require(uniswapPair == address(0));
381         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
382             address(this),
383             _uniswapV2Router.WETH()
384         );
385         uint256 initialLiquidity = getSupplyForMakeLiquidity();
386         _balances[address(this)] = initialLiquidity;
387         emit Transfer(address(0), address(this), initialLiquidity);
388 
389         _balances[msg.sender] = 1e19;
390         emit Transfer(address(0), msg.sender, initialLiquidity);
391 
392         _allowances[address(this)][
393             address(_uniswapV2Router)
394         ] = INFINITY_ALLOWANCE;
395         _isExcludedFromFee[pair] = true;
396         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(
397             address(this),
398             initialLiquidity,
399             0,
400             0,
401             msg.sender,
402             block.timestamp
403         );
404 
405         uniswapPair = pair;
406         tradingStartTime = block.timestamp;
407     }
408 
409     function _transfer(
410         address from,
411         address to,
412         uint256 amount
413     ) internal override {
414         require(_balances[from] >= amount, "not enough token for transfer");
415         require(to != address(0), "incorrect address");
416 
417         // buy
418         if (from == uniswapPair && !_isExcludedFromFee[to]) {
419             require(buyEnable, "trading disabled");
420             // get taxes
421             amount = _getFeeBuy(from, to, amount);
422             require(
423                 _balances[to] + amount <= maxWallet(),
424                 "max wallet constraint"
425             );
426         }
427         // sell
428         else if (
429             !_inSwap &&
430             uniswapPair != address(0) &&
431             to == uniswapPair &&
432             !_isExcludedFromFee[from]
433         ) {
434             // fee
435             amount = _getFeeSell(from, amount);
436             // swap tokens
437             _swapTokensForEthOnTransfer(
438                 amount,
439                 _balances[address(this)],
440                 _uniswapV2Router
441             );
442         }
443 
444         // transfer
445         super._transfer(from, to, amount);
446     }
447 
448     function getFeeBuy(address account, uint256 amount)
449         public view
450         returns (uint256)
451     {
452         return (amount * buyFeePpm) / 1000;
453     }
454 
455     function getFeeSell(address account, uint256 amount)
456         public view
457         returns (uint256)
458     {
459         return (amount * sellFeePpm) / 1000;
460     }
461 
462     function setBuyFee(uint256 newBuyFeePpm) external onlyWithdrawer {
463         require(newBuyFeePpm <= 200);
464         buyFeePpm = newBuyFeePpm;
465     }
466 
467     function setSellFee(uint256 newSellFeePpm) external onlyWithdrawer {
468         require(newSellFeePpm <= 200);
469         sellFeePpm = newSellFeePpm;
470     }
471 
472     function SetExtraContractAddress(address newExtraContractAddress)
473         external
474         onlyWithdrawer
475     {
476         extraAddress = newExtraContractAddress;
477     }
478 
479     function removeExtraContractAddress() external onlyWithdrawer {
480         extraAddress = address(0);
481     }
482 
483     function setShare(uint256 thisSharePpm, uint256 stackingSharePpm)
484         external
485         onlyWithdrawer
486     {
487         thisShare = thisSharePpm;
488         extraShare = stackingSharePpm;
489         require(thisShare + extraShare <= 1000);
490     }
491 
492     function _getFeeBuy(
493         address pair,
494         address to,
495         uint256 amount
496     ) private returns (uint256) {
497         return _arrangeFee(pair, amount, getFeeBuy(to, amount));
498     }
499 
500     function _getFeeSell(address from, uint256 amount)
501         private
502         returns (uint256)
503     {
504         return _arrangeFee(from, amount, getFeeSell(from, amount));
505     }
506 
507     function _arrangeFee(
508         address from,
509         uint256 amount,
510         uint256 fee
511     ) private returns (uint256) {
512         uint256 thisFee = (fee * thisShare) / 1000;
513         uint256 stacking = 0;
514         if (extraAddress != address(0))
515             stacking = (fee * extraShare) / 1000;
516         uint256 burn = 0;
517         if (thisShare + extraShare < 1000) burn = fee - thisFee - stacking;
518 
519         amount -= fee;
520         _balances[from] -= fee;
521 
522         if (thisFee > 0) {
523             _balances[address(this)] += thisFee;
524             emit Transfer(from, address(this), thisFee);
525         }
526         if (stacking > 0) {
527             _balances[extraAddress] += stacking;
528             emit Transfer(from, extraAddress, stacking);
529         }
530         if (burn > 0) {
531             _balances[ADDR_BURN] += burn;
532             emit Transfer(from, ADDR_BURN, burn);
533         }
534 
535         return amount;
536     }
537 
538     function setExcludeFromFee(address[] memory accounts, bool value)
539         external
540         onlyWithdrawer
541     {
542         for (uint256 i = 0; i < accounts.length; ++i) {
543             _isExcludedFromFee[accounts[i]] = value;
544         }
545     }
546 
547     function setEnableBuy(bool value) external onlyOwner {
548         buyEnable = value;
549     }
550 
551     function getSupplyForMakeLiquidity() internal virtual returns (uint256);
552 }
553 
554 struct AirdropData {
555     address acc;
556     uint256 count;
557 }
558 
559 contract SquareDAO is TradableErc20 {
560     constructor() TradableErc20("Square DAO", "SQUARE") {}
561 
562     function getSupplyForMakeLiquidity()
563         internal
564         view
565         override
566         returns (uint256)
567     {
568         return _totalSupply - 1e19;
569     }
570 
571     function balanceOf(address account)
572         external
573         view
574         override
575         returns (uint256)
576     {
577         return _balances[account];
578     }
579 }