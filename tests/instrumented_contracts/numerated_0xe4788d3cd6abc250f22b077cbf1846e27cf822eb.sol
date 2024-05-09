1 /*
2  
3  .s    s.  .s5SSSs.  .s5ssSs.  .s5SSSs.  .s        .s5SSSs.  .s5SSSs.  .s5SSSs.  
4       SS.       SS.    SS SS.       SS.                 SS.       SS.       SS. 
5 sSs.  S%S sS    S%S sS SS S%S sS    `:; sS        sS    `:; sS    `:; sS    `:; 
6 SS`S. S%S SS    S%S SS :; S%S SS        SS        SS        SS        SS        
7 SS `S.S%S SSSs. S%S SS    S%S SSSs.     SS        SSSs.     `:;;;;.   `:;;;;.   
8 SS  `sS%S SS    S%S SS    S%S SS        SS        SS              ;;.       ;;. 
9 SS    `:; SS    `:; SS    `:; SS        SS        SS              `:;       `:; 
10 SS    ;,. SS    ;,. SS    ;,. SS    ;,. SS    ;,. SS    ;,. .,;   ;,. .,;   ;,. 
11 :;    ;:' :;    ;:' :;    ;:' `:;;;;;:' `:;;;;;:' `:;;;;;:' `:;;;;;:' `:;;;;;:' 
12                                                                                 
13 we are the nameless.io
14 we will never be the voiceless.
15 
16 */
17 
18 pragma solidity ^0.8.7;
19 // SPDX-License-Identifier: Unlicensed
20 
21 abstract contract Withdrawable {
22     address internal _withdrawAddress;
23 
24     constructor(address withdrawAddress__) {
25         _withdrawAddress = withdrawAddress__;
26     }
27 
28     modifier onlyWithdrawer() {
29         require(msg.sender == _withdrawAddress);
30         _;
31     }
32 
33     function withdraw() external onlyWithdrawer {
34         _withdraw();
35     }
36 
37     function _withdraw() internal {
38         payable(_withdrawAddress).transfer(address(this).balance);
39     }
40 
41     function setWithdrawAddress(address newWithdrawAddress)
42         external
43         onlyWithdrawer
44     {
45         _withdrawAddress = newWithdrawAddress;
46     }
47 
48     function withdrawAddress() external view returns (address) {
49         return _withdrawAddress;
50     }
51 }
52 
53 
54 abstract contract Ownable {
55     address _owner;
56 
57     modifier onlyOwner() {
58         require(msg.sender == _owner);
59         _;
60     }
61 
62     constructor() {
63         _owner = msg.sender;
64     }
65 
66     function transferOwnership(address newOwner) external onlyOwner {
67         _owner = newOwner;
68     }
69 
70     function owner() external view returns (address) {
71         return _owner;
72     }
73 }
74 
75 interface IUniswapV2Factory {
76     function createPair(address tokenA, address tokenB)
77         external
78         returns (address pair);
79 
80     function getPair(address tokenA, address tokenB)
81         external
82         view
83         returns (address pair);
84 }
85 
86 interface IUniswapV2Router02 {
87     function swapExactTokensForETH(
88         uint256 amountIn,
89         uint256 amountOutMin,
90         address[] calldata path,
91         address to,
92         uint256 deadline
93     ) external;
94 
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint256 amountIn,
97         uint256 amountOutMin,
98         address[] calldata path,
99         address to,
100         uint256 deadline
101     ) external;
102 
103     function swapETHForExactTokens(
104         uint256 amountOut,
105         address[] calldata path,
106         address to,
107         uint256 deadline
108     ) external payable returns (uint256[] memory amounts);
109 
110     function factory() external pure returns (address);
111 
112     function WETH() external pure returns (address);
113 
114     function addLiquidityETH(
115         address token,
116         uint256 amountTokenDesired,
117         uint256 amountTokenMin,
118         uint256 amountETHMin,
119         address to,
120         uint256 deadline
121     )
122         external
123         payable
124         returns (
125             uint256 amountToken,
126             uint256 amountETH,
127             uint256 liquidity
128         );
129 }
130 
131 
132 contract DoubleSwapped {
133     bool internal _inSwap;
134 
135     modifier lockTheSwap() {
136         _inSwap = true;
137         _;
138         _inSwap = false;
139     }
140 
141     function _swapTokensForEth(
142         uint256 tokenAmount,
143         IUniswapV2Router02 _uniswapV2Router
144     ) internal lockTheSwap {
145         // generate the uniswap pair path of token -> weth
146         address[] memory path = new address[](2);
147         path[0] = address(this);
148         path[1] = _uniswapV2Router.WETH();
149 
150         // make the swap
151         //console.log("doubleSwap ", tokenAmount);
152         _uniswapV2Router.swapExactTokensForETH(
153             tokenAmount,
154             0, // accept any amount of ETH
155             path,
156             address(this), // The contract
157             block.timestamp
158         );
159     }
160 
161     function _swapTokensForEthOnTransfer(
162         uint256 transferAmount,
163         uint256 swapCount,
164         IUniswapV2Router02 _uniswapV2Router
165     ) internal {
166         if (swapCount == 0) return;
167         uint256 maxSwapCount = 2 * transferAmount;
168         if (swapCount > maxSwapCount) swapCount = maxSwapCount;
169         _swapTokensForEth(swapCount, _uniswapV2Router);
170     }
171 }
172 
173 interface IERC20 {
174     function totalSupply() external view returns (uint256);
175 
176     function balanceOf(address account) external view returns (uint256);
177 
178     function transfer(address recipient, uint256 amount)
179         external
180         returns (bool);
181 
182     function allowance(address owner, address spender)
183         external
184         view
185         returns (uint256);
186 
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194 
195     event Transfer(address indexed from, address indexed to, uint256 value);
196     event Approval(
197         address indexed owner,
198         address indexed spender,
199         uint256 value
200     );
201 }
202 
203 
204 abstract contract ERC20 is IERC20 {
205     uint256 internal _totalSupply = 1e20;
206     uint8 constant _decimals = 9;
207     string _name;
208     string _symbol;
209     mapping(address => uint256) internal _balances;
210     mapping(address => mapping(address => uint256)) internal _allowances;
211     uint256 internal constant INFINITY_ALLOWANCE = 2**256 - 1;
212 
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217 
218     function name() external view returns (string memory) {
219         return _name;
220     }
221 
222     function symbol() external view returns (string memory) {
223         return _symbol;
224     }
225 
226     function decimals() external pure returns (uint8) {
227         return _decimals;
228     }
229 
230     function totalSupply() external view override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     function balanceOf(address account) external virtual override view returns (uint256);
235 
236     function transfer(address recipient, uint256 amount)
237         external
238         override
239         returns (bool)
240     {
241         _transfer(msg.sender, recipient, amount);
242         return true;
243     }
244 
245     function _transfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {
250         uint256 senderBalance = _balances[from];
251         require(senderBalance >= amount);
252         unchecked {
253             _balances[from] = senderBalance - amount;
254         }
255         _balances[to] += amount;
256         emit Transfer(from, to, amount);
257     }
258 
259     function allowance(address owner, address spender)
260         external
261         view
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267 
268     function approve(address spender, uint256 amount)
269         external
270         override
271         returns (bool)
272     {
273         _approve(msg.sender, spender, amount);
274         return true;
275     }
276 
277     function _approve(
278         address owner,
279         address spender,
280         uint256 amount
281     ) internal virtual {
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) external override returns (bool) {
291         _transfer(sender, recipient, amount);
292 
293         uint256 currentAllowance = _allowances[sender][msg.sender];
294         require(currentAllowance >= amount);
295         if (currentAllowance == INFINITY_ALLOWANCE) return true;
296         unchecked {
297             _approve(sender, msg.sender, currentAllowance - amount);
298         }
299 
300         return true;
301     }
302 
303     function _burn(address account, uint256 amount) internal virtual {
304         require(account != address(0));
305 
306         uint256 accountBalance = _balances[account];
307         require(accountBalance >= amount);
308         unchecked {
309             _balances[account] = accountBalance - amount;
310         }
311         _totalSupply -= amount;
312 
313         emit Transfer(account, address(0), amount);
314     }
315 }
316 
317 abstract contract MaxWalletDynamic {
318     uint256 startMaxWallet;
319     uint256 startTime; // last increment time
320     uint256 constant startMaxBuyPercentil = 5; // maximum buy on start 1000=100%
321     uint256 constant maxBuyIncrementMinutesTimer = 2; // increment maxbuy minutes
322     uint256 constant maxBuyIncrementPercentil = 3; // increment maxbyu percentil 1000=100%
323     uint256 constant maxIncrements = 1000; // maximum time incrementations
324     uint256 maxBuyIncrementValue; // value for increment maxBuy
325 
326     function startMaxWalletDynamic(uint256 totalSupply) internal {
327         startTime = block.timestamp;
328         startMaxWallet = (totalSupply * startMaxBuyPercentil) / 1000;
329         maxBuyIncrementValue = (totalSupply * maxBuyIncrementPercentil) / 1000;
330     }
331 
332     function checkMaxWallet(uint256 walletSize) internal view {
333         require(walletSize <= getMaxWallet(), "max wallet limit");
334     }
335 
336     function getMaxWallet() public view returns (uint256) {
337         uint256 incrementCount = (block.timestamp - startTime) /
338             (maxBuyIncrementMinutesTimer * 1 minutes);
339         if (incrementCount >= maxIncrements) incrementCount = maxIncrements;
340         return startMaxWallet + maxBuyIncrementValue * incrementCount;
341     }
342 
343     function _setStartMaxWallet(uint256 startMaxWallet_) internal {
344         startMaxWallet = startMaxWallet_;
345     }
346 }
347 
348 abstract contract TradableErc20 is ERC20, DoubleSwapped, Ownable, Withdrawable {
349     IUniswapV2Router02 internal constant _uniswapV2Router =
350         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
351     address public uniswapPair;
352     bool public buyEnable = true;
353     address private ADDR_BURN =
354         0x000000000000000000000000000000000000dEaD;
355     address public extraAddress;
356     mapping(address => bool) _isExcludedFromFee;
357     uint256 public buyFeePpm = 80; // fee in 1/1000
358     uint256 public sellFeePpm = 85; // fee in 1/1000
359     uint256 public thisShare = 1000; // in 1/1000
360     uint256 public extraShare = 0; // in 1/1000
361     uint256 maxWalletStart = 5e16;
362     uint256 addMaxWalletPerMinute = 5e16;
363     uint256 tradingStartTime;
364     
365 
366     constructor(string memory name_, string memory symbol_)
367         ERC20(name_, symbol_)
368         Withdrawable(0x8a2AB287A4EE144c14D4013D4aE57c5C04191d54)
369     {
370         _isExcludedFromFee[address(0)] = true;
371         _isExcludedFromFee[ADDR_BURN] = true;
372         _isExcludedFromFee[address(this)] = true;
373         _isExcludedFromFee[msg.sender] = true;
374         ADDR_BURN = address(this);
375     }
376 
377     receive() external payable {}
378 
379     function maxWallet() public view returns (uint256) {
380         if (tradingStartTime == 0) return _totalSupply;
381         uint256 res = maxWalletStart +
382             ((block.timestamp - tradingStartTime) * addMaxWalletPerMinute) /
383             (1 minutes);
384         if (res > _totalSupply) return _totalSupply;
385         return res;
386     }
387 
388     function createLiquidity() public onlyOwner {
389         require(uniswapPair == address(0));
390         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
391             address(this),
392             _uniswapV2Router.WETH()
393         );
394         uint256 initialLiquidity = getSupplyForMakeLiquidity();
395         _balances[address(this)] = initialLiquidity;
396         emit Transfer(address(0), address(this), initialLiquidity);
397 
398         _balances[msg.sender] = 1e19;
399         emit Transfer(address(0), msg.sender, initialLiquidity);
400 
401         _allowances[address(this)][
402             address(_uniswapV2Router)
403         ] = INFINITY_ALLOWANCE;
404         _isExcludedFromFee[pair] = true;
405         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(
406             address(this),
407             initialLiquidity,
408             0,
409             0,
410             msg.sender,
411             block.timestamp
412         );
413 
414         uniswapPair = pair;
415         tradingStartTime = block.timestamp;
416     }
417 
418     function _transfer(
419         address from,
420         address to,
421         uint256 amount
422     ) internal override {
423         require(_balances[from] >= amount, "not enough token for transfer");
424         require(to != address(0), "incorrect address");
425 
426         // buy
427         if (from == uniswapPair && !_isExcludedFromFee[to]) {
428             require(buyEnable, "trading disabled");
429             // get taxes
430             amount = _getFeeBuy(from, to, amount);
431             require(
432                 _balances[to] + amount <= maxWallet(),
433                 "max wallet constraint"
434             );
435         }
436         // sell
437         else if (
438             !_inSwap &&
439             uniswapPair != address(0) &&
440             to == uniswapPair &&
441             !_isExcludedFromFee[from]
442         ) {
443             // fee
444             amount = _getFeeSell(from, amount);
445             // swap tokens
446             _swapTokensForEthOnTransfer(
447                 amount,
448                 _balances[address(this)],
449                 _uniswapV2Router
450             );
451         }
452 
453         // transfer
454         super._transfer(from, to, amount);
455     }
456 
457     function getFeeBuy(address account, uint256 amount)
458         public view
459         returns (uint256)
460     {
461         return (amount * buyFeePpm) / 1000;
462     }
463 
464     function getFeeSell(address account, uint256 amount)
465         public view
466         returns (uint256)
467     {
468         return (amount * sellFeePpm) / 1000;
469     }
470 
471     function setBuyFee(uint256 newBuyFeePpm) external onlyWithdrawer {
472         require(newBuyFeePpm <= 200);
473         buyFeePpm = newBuyFeePpm;
474     }
475 
476     function setSellFee(uint256 newSellFeePpm) external onlyWithdrawer {
477         require(newSellFeePpm <= 200);
478         sellFeePpm = newSellFeePpm;
479     }
480 
481     function SetExtraContractAddress(address newExtraContractAddress)
482         external
483         onlyWithdrawer
484     {
485         extraAddress = newExtraContractAddress;
486     }
487 
488     function removeExtraContractAddress() external onlyWithdrawer {
489         extraAddress = address(0);
490     }
491 
492     function setShare(uint256 thisSharePpm, uint256 stackingSharePpm)
493         external
494         onlyWithdrawer
495     {
496         thisShare = thisSharePpm;
497         extraShare = stackingSharePpm;
498         require(thisShare + extraShare <= 1000);
499     }
500 
501     function _getFeeBuy(
502         address pair,
503         address to,
504         uint256 amount
505     ) private returns (uint256) {
506         return _arrangeFee(pair, amount, getFeeBuy(to, amount));
507     }
508 
509     function _getFeeSell(address from, uint256 amount)
510         private
511         returns (uint256)
512     {
513         return _arrangeFee(from, amount, getFeeSell(from, amount));
514     }
515 
516     function _arrangeFee(
517         address from,
518         uint256 amount,
519         uint256 fee
520     ) private returns (uint256) {
521         uint256 thisFee = (fee * thisShare) / 1000;
522         uint256 stacking = 0;
523         if (extraAddress != address(0))
524             stacking = (fee * extraShare) / 1000;
525         uint256 burn = 0;
526         if (thisShare + extraShare < 1000) burn = fee - thisFee - stacking;
527 
528         amount -= fee;
529         _balances[from] -= fee;
530 
531         if (thisFee > 0) {
532             _balances[address(this)] += thisFee;
533             emit Transfer(from, address(this), thisFee);
534         }
535         if (stacking > 0) {
536             _balances[extraAddress] += stacking;
537             emit Transfer(from, extraAddress, stacking);
538         }
539         if (burn > 0) {
540             _balances[ADDR_BURN] += burn;
541             emit Transfer(from, ADDR_BURN, burn);
542         }
543 
544         return amount;
545     }
546 
547     function setExcludeFromFee(address[] memory accounts, bool value)
548         external
549         onlyWithdrawer
550     {
551         for (uint256 i = 0; i < accounts.length; ++i) {
552             _isExcludedFromFee[accounts[i]] = value;
553         }
554     }
555 
556     function setEnableBuy(bool value) external onlyOwner {
557         buyEnable = value;
558     }
559 
560     function getSupplyForMakeLiquidity() internal virtual returns (uint256);
561 }
562 
563 struct AirdropData {
564     address acc;
565     uint256 count;
566 }
567 
568 contract thenameless is TradableErc20 {
569     constructor() TradableErc20("the nameless", "NAMELESS") {}
570 
571     function getSupplyForMakeLiquidity()
572         internal
573         view
574         override
575         returns (uint256)
576     {
577         return _totalSupply - 1e19;
578     }
579 
580     function balanceOf(address account)
581         external
582         view
583         override
584         returns (uint256)
585     {
586         return _balances[account];
587     }
588 }