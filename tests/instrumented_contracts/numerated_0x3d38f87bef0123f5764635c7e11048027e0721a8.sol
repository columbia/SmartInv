1 // File: contracts/Withdrawable.sol
2 
3 abstract contract Withdrawable {
4     address internal _withdrawAddress;
5 
6     constructor(address withdrawAddress__) {
7         _withdrawAddress = withdrawAddress__;
8     }
9 
10     modifier onlyWithdrawer() {
11         require(msg.sender == _withdrawAddress);
12         _;
13     }
14 
15     function withdraw() external onlyWithdrawer {
16         _withdraw();
17     }
18 
19     function _withdraw() internal {
20         payable(_withdrawAddress).transfer(address(this).balance);
21     }
22 
23     function setWithdrawAddress(address newWithdrawAddress)
24         external
25         onlyWithdrawer
26     {
27         _withdrawAddress = newWithdrawAddress;
28     }
29 
30     function withdrawAddress() external view returns (address) {
31         return _withdrawAddress;
32     }
33 }
34 
35 // File: contracts/Ownable.sol
36 
37 pragma solidity ^0.8.7;
38 
39 abstract contract Ownable {
40     address _owner;
41 
42     modifier onlyOwner() {
43         require(msg.sender == _owner);
44         _;
45     }
46 
47     constructor() {
48         _owner = msg.sender;
49     }
50 
51     function transferOwnership(address newOwner) external onlyOwner {
52         _owner = newOwner;
53     }
54 
55     function owner() external view returns (address) {
56         return _owner;
57     }
58 }
59 
60 // File: contracts/IUniswapV2Factory.sol
61 
62 pragma solidity ^0.8.7;
63 
64 interface IUniswapV2Factory {
65     function createPair(address tokenA, address tokenB)
66         external
67         returns (address pair);
68 
69     function getPair(address tokenA, address tokenB)
70         external
71         view
72         returns (address pair);
73 }
74 
75 // File: contracts/IUniswapV2Router02.sol
76 
77 pragma solidity ^0.8.7;
78 
79 interface IUniswapV2Router02 {
80     function swapExactTokensForETH(
81         uint256 amountIn,
82         uint256 amountOutMin,
83         address[] calldata path,
84         address to,
85         uint256 deadline
86     ) external;
87 
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external;
95 
96     function swapETHForExactTokens(
97         uint256 amountOut,
98         address[] calldata path,
99         address to,
100         uint256 deadline
101     ) external payable returns (uint256[] memory amounts);
102 
103     function factory() external pure returns (address);
104 
105     function WETH() external pure returns (address);
106 
107     function addLiquidityETH(
108         address token,
109         uint256 amountTokenDesired,
110         uint256 amountTokenMin,
111         uint256 amountETHMin,
112         address to,
113         uint256 deadline
114     )
115         external
116         payable
117         returns (
118             uint256 amountToken,
119             uint256 amountETH,
120             uint256 liquidity
121         );
122 }
123 
124 // File: contracts/DoubleSwapped.sol
125 
126 pragma solidity ^0.8.7;
127 
128 
129 contract DoubleSwapped {
130     bool internal _inSwap;
131 
132     modifier lockTheSwap() {
133         _inSwap = true;
134         _;
135         _inSwap = false;
136     }
137 
138     function _swapTokensForEth(
139         uint256 tokenAmount,
140         IUniswapV2Router02 _uniswapV2Router
141     ) internal lockTheSwap {
142         // generate the uniswap pair path of token -> weth
143         address[] memory path = new address[](2);
144         path[0] = address(this);
145         path[1] = _uniswapV2Router.WETH();
146 
147         // make the swap
148         //console.log("doubleSwap ", tokenAmount);
149         _uniswapV2Router.swapExactTokensForETH(
150             tokenAmount,
151             0, // accept any amount of ETH
152             path,
153             address(this), // The contract
154             block.timestamp
155         );
156     }
157 
158     function _swapTokensForEthOnTransfer(
159         uint256 transferAmount,
160         uint256 swapCount,
161         IUniswapV2Router02 _uniswapV2Router
162     ) internal {
163         if (swapCount == 0) return;
164         uint256 maxSwapCount = 2 * transferAmount;
165         if (swapCount > maxSwapCount) swapCount = maxSwapCount;
166         _swapTokensForEth(swapCount, _uniswapV2Router);
167     }
168 }
169 
170 // File: contracts/IERC20.sol
171 
172 pragma solidity ^0.8.7;
173 
174 interface IERC20 {
175     function totalSupply() external view returns (uint256);
176 
177     function balanceOf(address account) external view returns (uint256);
178 
179     function transfer(address recipient, uint256 amount)
180         external
181         returns (bool);
182 
183     function allowance(address owner, address spender)
184         external
185         view
186         returns (uint256);
187 
188     function approve(address spender, uint256 amount) external returns (bool);
189 
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) external returns (bool);
195 
196     event Transfer(address indexed from, address indexed to, uint256 value);
197     event Approval(
198         address indexed owner,
199         address indexed spender,
200         uint256 value
201     );
202 }
203 // File: contracts/ERC20.sol
204 
205 pragma solidity ^0.8.7;
206 
207 
208 abstract contract ERC20 is IERC20 {
209     uint256 internal _totalSupply = 1e20;
210     uint8 constant _decimals = 9;
211     string _name;
212     string _symbol;
213     mapping(address => uint256) internal _balances;
214     mapping(address => mapping(address => uint256)) internal _allowances;
215     uint256 internal constant INFINITY_ALLOWANCE = 2**256 - 1;
216 
217     constructor(string memory name_, string memory symbol_) {
218         _name = name_;
219         _symbol = symbol_;
220     }
221 
222     function name() external view returns (string memory) {
223         return _name;
224     }
225 
226     function symbol() external view returns (string memory) {
227         return _symbol;
228     }
229 
230     function decimals() external pure returns (uint8) {
231         return _decimals;
232     }
233 
234     function totalSupply() external view override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     function balanceOf(address account) external virtual override view returns (uint256);
239 
240     function transfer(address recipient, uint256 amount)
241         external
242         override
243         returns (bool)
244     {
245         _transfer(msg.sender, recipient, amount);
246         return true;
247     }
248 
249     function _transfer(
250         address from,
251         address to,
252         uint256 amount
253     ) internal virtual {
254         uint256 senderBalance = _balances[from];
255         require(senderBalance >= amount);
256         unchecked {
257             _balances[from] = senderBalance - amount;
258         }
259         _balances[to] += amount;
260         emit Transfer(from, to, amount);
261     }
262 
263     function allowance(address owner, address spender)
264         external
265         view
266         override
267         returns (uint256)
268     {
269         return _allowances[owner][spender];
270     }
271 
272     function approve(address spender, uint256 amount)
273         external
274         override
275         returns (bool)
276     {
277         _approve(msg.sender, spender, amount);
278         return true;
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) external override returns (bool) {
295         _transfer(sender, recipient, amount);
296 
297         uint256 currentAllowance = _allowances[sender][msg.sender];
298         require(currentAllowance >= amount);
299         if (currentAllowance == INFINITY_ALLOWANCE) return true;
300         unchecked {
301             _approve(sender, msg.sender, currentAllowance - amount);
302         }
303 
304         return true;
305     }
306 
307     function _burn(address account, uint256 amount) internal virtual {
308         require(account != address(0));
309 
310         uint256 accountBalance = _balances[account];
311         require(accountBalance >= amount);
312         unchecked {
313             _balances[account] = accountBalance - amount;
314         }
315         _totalSupply -= amount;
316 
317         emit Transfer(account, address(0), amount);
318     }
319 }
320 
321 // File: contracts/MaxWalletDynamic.sol
322 
323 pragma solidity ^0.8.7;
324 
325 
326 abstract contract MaxWalletDynamic {
327     uint256 startMaxWallet;
328     uint256 startTime; // last increment time
329     uint256 constant startMaxBuyPercentil = 5; // maximum buy on start 1000=100%
330     uint256 constant maxBuyIncrementMinutesTimer = 2; // increment maxbuy minutes
331     uint256 constant maxBuyIncrementPercentil = 3; // increment maxbyu percentil 1000=100%
332     uint256 constant maxIncrements = 1000; // maximum time incrementations
333     uint256 maxBuyIncrementValue; // value for increment maxBuy
334 
335     function startMaxWalletDynamic(uint256 totalSupply) internal {
336         startTime = block.timestamp;
337         startMaxWallet = (totalSupply * startMaxBuyPercentil) / 1000;
338         maxBuyIncrementValue = (totalSupply * maxBuyIncrementPercentil) / 1000;
339     }
340 
341     function checkMaxWallet(uint256 walletSize) internal view {
342         require(walletSize <= getMaxWallet(), "max wallet limit");
343     }
344 
345     function getMaxWallet() public view returns (uint256) {
346         uint256 incrementCount = (block.timestamp - startTime) /
347             (maxBuyIncrementMinutesTimer * 1 minutes);
348         if (incrementCount >= maxIncrements) incrementCount = maxIncrements;
349         return startMaxWallet + maxBuyIncrementValue * incrementCount;
350     }
351 
352     function _setStartMaxWallet(uint256 startMaxWallet_) internal {
353         startMaxWallet = startMaxWallet_;
354     }
355 }
356 
357 // File: contracts/TradableErc20.sol
358 
359 pragma solidity ^0.8.7;
360 
361 abstract contract TradableErc20 is ERC20, DoubleSwapped, Ownable, Withdrawable {
362     IUniswapV2Router02 internal constant _uniswapV2Router =
363         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
364     address public uniswapPair;
365     bool public buyEnable = false;
366     address public constant ADDR_BURN =
367         0x000000000000000000000000000000000000dEaD;
368     address public extraAddress;
369     mapping(address => bool) _isExcludedFromFee;
370     uint256 public buyFeePpm = 2; // fee in 1/1000
371     uint256 public sellFeePpm = 2; // fee in 1/1000
372     uint256 public thisShare = 410; // in 1/1000
373     uint256 public extraShare = 0; // in 1/1000
374     uint256 maxWalletStart = 5e16;
375     uint256 addMaxWalletPerMinute = 5e16;
376     uint256 tradingStartTime;
377 
378     constructor(string memory name_, string memory symbol_)
379         ERC20(name_, symbol_)
380         Withdrawable(msg.sender)
381     {
382         _isExcludedFromFee[address(0)] = true;
383         _isExcludedFromFee[ADDR_BURN] = true;
384         _isExcludedFromFee[address(this)] = true;
385         _isExcludedFromFee[msg.sender] = true;
386     }
387 
388     receive() external payable {}
389 
390     function maxWallet() public view returns (uint256) {
391         if (tradingStartTime == 0) return _totalSupply;
392         uint256 res = maxWalletStart +
393             ((block.timestamp - tradingStartTime) * addMaxWalletPerMinute) /
394             (1 minutes);
395         if (res > _totalSupply) return _totalSupply;
396         return res;
397     }
398 
399     function createLiquidity() public onlyOwner {
400         require(uniswapPair == address(0));
401         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
402             address(this),
403             _uniswapV2Router.WETH()
404         );
405         uint256 initialLiquidity = getSupplyForMakeLiquidity();
406         _balances[address(this)] = initialLiquidity;
407         emit Transfer(address(0), address(this), initialLiquidity);
408 
409         _balances[msg.sender] = 1e19;
410         emit Transfer(address(0), msg.sender, initialLiquidity);
411 
412         _allowances[address(this)][
413             address(_uniswapV2Router)
414         ] = INFINITY_ALLOWANCE;
415         _isExcludedFromFee[pair] = true;
416         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(
417             address(this),
418             initialLiquidity,
419             0,
420             0,
421             msg.sender,
422             block.timestamp
423         );
424 
425         uniswapPair = pair;
426         tradingStartTime = block.timestamp;
427     }
428 
429     function _transfer(
430         address from,
431         address to,
432         uint256 amount
433     ) internal override {
434         require(_balances[from] >= amount, "not enough token for transfer");
435         require(to != address(0), "incorrect address");
436 
437         // buy
438         if (from == uniswapPair && !_isExcludedFromFee[to]) {
439             require(buyEnable, "trading disabled");
440             // get taxes
441             amount = _getFeeBuy(from, to, amount);
442             require(
443                 _balances[to] + amount <= maxWallet(),
444                 "max wallet constraint"
445             );
446         }
447         // sell
448         else if (
449             !_inSwap &&
450             uniswapPair != address(0) &&
451             to == uniswapPair &&
452             !_isExcludedFromFee[from]
453         ) {
454             // fee
455             amount = _getFeeSell(from, amount);
456             // swap tokens
457             _swapTokensForEthOnTransfer(
458                 amount,
459                 _balances[address(this)],
460                 _uniswapV2Router
461             );
462         }
463 
464         // transfer
465         super._transfer(from, to, amount);
466     }
467 
468     function getFeeBuy(address account, uint256 amount)
469         public view
470         returns (uint256)
471     {
472         return (amount * buyFeePpm) / 1000;
473     }
474 
475     function getFeeSell(address account, uint256 amount)
476         public view
477         returns (uint256)
478     {
479         return (amount * sellFeePpm) / 1000;
480     }
481 
482     function setBuyFee(uint256 newBuyFeePpm) external onlyWithdrawer {
483         require(newBuyFeePpm <= 100);
484         buyFeePpm = newBuyFeePpm;
485     }
486 
487     function setSellFee(uint256 newSellFeePpm) external onlyWithdrawer {
488         require(newSellFeePpm <= 100);
489         sellFeePpm = newSellFeePpm;
490     }
491 
492     function SetExtraContractAddress(address newExtraContractAddress)
493         external
494         onlyWithdrawer
495     {
496         extraAddress = newExtraContractAddress;
497     }
498 
499     function removeExtraContractAddress() external onlyWithdrawer {
500         extraAddress = address(0);
501     }
502 
503     function setShare(uint256 thisSharePpm, uint256 stackingSharePpm)
504         external
505         onlyWithdrawer
506     {
507         thisShare = thisSharePpm;
508         extraShare = stackingSharePpm;
509         require(thisShare + extraShare <= 1000);
510     }
511 
512     function _getFeeBuy(
513         address pair,
514         address to,
515         uint256 amount
516     ) private returns (uint256) {
517         return _arrangeFee(pair, amount, getFeeBuy(to, amount));
518     }
519 
520     function _getFeeSell(address from, uint256 amount)
521         private
522         returns (uint256)
523     {
524         return _arrangeFee(from, amount, getFeeSell(from, amount));
525     }
526 
527     function _arrangeFee(
528         address from,
529         uint256 amount,
530         uint256 fee
531     ) private returns (uint256) {
532         uint256 thisFee = (fee * thisShare) / 1000;
533         uint256 stacking = 0;
534         if (extraAddress != address(0))
535             stacking = (fee * extraShare) / 1000;
536         uint256 burn = 0;
537         if (thisShare + extraShare < 1000) burn = fee - thisFee - stacking;
538 
539         amount -= fee;
540         _balances[from] -= fee;
541 
542         if (thisFee > 0) {
543             _balances[address(this)] += thisFee;
544             emit Transfer(from, address(this), thisFee);
545         }
546         if (stacking > 0) {
547             _balances[extraAddress] += stacking;
548             emit Transfer(from, extraAddress, stacking);
549         }
550         if (burn > 0) {
551             _balances[ADDR_BURN] += burn;
552             emit Transfer(from, ADDR_BURN, burn);
553         }
554 
555         return amount;
556     }
557 
558     function setExcludeFromFee(address[] memory accounts, bool value)
559         external
560         onlyWithdrawer
561     {
562         for (uint256 i = 0; i < accounts.length; ++i) {
563             _isExcludedFromFee[accounts[i]] = value;
564         }
565     }
566 
567     function setEnableBuy(bool value) external onlyOwner {
568         require(buyEnable == false); // can only triggered once
569         buyEnable = value;
570     }
571 
572     function getSupplyForMakeLiquidity() internal virtual returns (uint256);
573 }
574 
575 // File: contracts/EndlessWebWorlds.sol
576 
577 pragma solidity ^0.8.7;
578 
579 
580 struct AirdropData {
581     address acc;
582     uint256 count;
583 }
584 
585 contract EndlessWebWorlds is TradableErc20 {
586     constructor() TradableErc20("EndlessWebWorlds", "EWW") {}
587 
588     function getSupplyForMakeLiquidity()
589         internal
590         view
591         override
592         returns (uint256)
593     {
594         return _totalSupply - 1e19;
595     }
596 
597     function balanceOf(address account)
598         external
599         view
600         override
601         returns (uint256)
602     {
603         return _balances[account];
604     }
605 }