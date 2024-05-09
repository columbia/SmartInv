1 pragma solidity ^0.8.12;
2 // SPDX-License-Identifier: Unlicensed
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(
17         uint256 a,
18         uint256 b,
19         string memory errorMessage
20     ) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(
43         uint256 a,
44         uint256 b,
45         string memory errorMessage
46     ) internal pure returns (uint256) {
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         return c;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55 
56     function decimals() external view returns (uint8);
57 
58     function symbol() external view returns (string memory);
59 
60     function name() external view returns (string memory);
61 
62     function getOwner() external view returns (address);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount)
67         external
68         returns (bool);
69 
70     function allowance(address _owner, address spender)
71         external
72         view
73         returns (uint256);
74 
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 abstract contract Auth {
92     address internal owner;
93     mapping(address => bool) internal authorizations;
94 
95     constructor(address _owner) {
96         owner = _owner;
97         authorizations[_owner] = true;
98     }
99 
100     modifier onlyOwner() {
101         require(isOwner(msg.sender), "!OWNER");
102         _;
103     }
104 
105     modifier authorized() {
106         require(isAuthorized(msg.sender), "!AUTHORIZED");
107         _;
108     }
109 
110     function authorize(address adr) public onlyOwner {
111         authorizations[adr] = true;
112     }
113 
114     function unauthorize(address adr) public onlyOwner {
115         authorizations[adr] = false;
116     }
117 
118     function isOwner(address account) public view returns (bool) {
119         return account == owner;
120     }
121 
122     function isAuthorized(address adr) public view returns (bool) {
123         return authorizations[adr];
124     }
125 
126     function transferOwnership(address payable adr) public onlyOwner {
127         owner = adr;
128         authorizations[adr] = true;
129         emit OwnershipTransferred(adr);
130     }
131 
132     event OwnershipTransferred(address owner);
133 }
134 
135 interface IDEXFactory {
136     function createPair(address tokenA, address tokenB)
137         external
138         returns (address liqPair);
139 }
140 
141 interface IDEXRouter {
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidity(
147         address tokenA,
148         address tokenB,
149         uint256 amountADesired,
150         uint256 amountBDesired,
151         uint256 amountAMin,
152         uint256 amountBMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         returns (
158             uint256 amountA,
159             uint256 amountB,
160             uint256 liquidity
161         );
162 
163     function addLiquidityETH(
164         address token,
165         uint256 amountTokenDesired,
166         uint256 amountTokenMin,
167         uint256 amountETHMin,
168         address to,
169         uint256 deadline
170     )
171         external
172         payable
173         returns (
174             uint256 amountToken,
175             uint256 amountETH,
176             uint256 liquidity
177         );
178 
179     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
180         uint256 amountIn,
181         uint256 amountOutMin,
182         address[] calldata path,
183         address to,
184         uint256 deadline
185     ) external;
186 
187     function swapExactETHForTokensSupportingFeeOnTransferTokens(
188         uint256 amountOutMin,
189         address[] calldata path,
190         address to,
191         uint256 deadline
192     ) external payable;
193 
194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
195         uint256 amountIn,
196         uint256 amountOutMin,
197         address[] calldata path,
198         address to,
199         uint256 deadline
200     ) external;
201 }
202 
203 contract Kitties is IERC20, Auth {
204     using SafeMath for uint256;
205 
206     address public auliquidityRatioReceiver =
207         0x3a7881730A730a87358F1A43a3B67eCcD2E54316;
208     address public marketingFeeReceiver =
209         0x3a7881730A730a87358F1A43a3B67eCcD2E54316;
210 
211     address public devFeeReceiver =
212         0x768Db01886Be76441aE50f41CB0d8c8cfEf5eE11;
213 
214 
215     string constant _name = "Kitties";
216     string constant _symbol = "KTS";
217     uint8 constant _decimals = 18;
218     uint8 constant _zeros = 8;
219 
220     uint8 constant _maxTx = 10;
221     uint8 constant _maxWallet = 10;
222 
223     uint8 constant _threshpct = 5;
224     uint256 _totalSupply = 1 * 10**_zeros * 10**_decimals;
225 
226     uint256 public _maxTxAmount = _totalSupply.mul(_maxTx).div(1000);
227     uint256 public _maxWalletToken = _totalSupply.mul(_maxWallet).div(1000);
228     uint256 public swapThreshold = _totalSupply.mul(_threshpct).div(1000);
229 
230     mapping(address => uint256) _balances;
231     mapping(address => mapping(address => uint256)) _allowances;
232 
233     mapping(address => bool) isFeeExempt;
234     mapping(address => bool) isTxLimitExempt;
235     mapping(address => bool) isWalletLimitExempt;
236     mapping(address => bool) public _isBlacklisted;
237 
238     //FEE % TO TAKE FOR BUY OR SELL
239     uint256 public sellFee = 40;
240     uint256 public buyFee = 40;
241 
242     //HOW FEE IS DIVIDED WHILE SWAPPING THE TOKENS
243     // 1/1 = 50% liquidity 50% Marketing
244     // 1/4 = 25% liquidity 75% Marketing
245     // etc
246     uint256 public liquidityRatio = 0;
247     uint256 public marketingRatio = 5;
248     uint256 public feeRatio = marketingRatio + liquidityRatio;
249     uint256 public feeDenominator = 100;
250 
251     uint256 public marketingTakePerc = 70;
252     uint256 public devTakePerc = 30;
253 
254 
255     IDEXRouter public Irouter02;
256     address public liqPair;
257 
258     bool public tradingLive = false;
259     uint256 private launchedAt;
260     uint256 private deadBlocks;
261 
262     bool public limitsEnabled = true;
263     bool public maxTxOnBuys = true;
264     bool public maxTxOnSells = true;
265     bool public swapEnabled = true;
266 
267     bool inSwap;
268 
269     modifier swapping() {
270         inSwap = true;
271         _;
272         inSwap = false;
273     }
274 
275     constructor() Auth(msg.sender) {
276         Irouter02 = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
277         liqPair = IDEXFactory(Irouter02.factory()).createPair(
278             Irouter02.WETH(),
279             address(this)
280         );
281 
282         _allowances[address(this)][address(Irouter02)] = type(uint256).max;
283         isFeeExempt[msg.sender] = true;
284         isFeeExempt[address(this)] = true;
285 
286         isTxLimitExempt[msg.sender] = true;
287         isTxLimitExempt[address(this)] = true;
288 
289         isWalletLimitExempt[msg.sender] = true;
290         isWalletLimitExempt[address(this)] = true;
291         isWalletLimitExempt[liqPair] = true;
292 
293         _approve(owner, address(Irouter02), type(uint256).max);
294         _approve(address(this), address(Irouter02), type(uint256).max);
295 
296         
297 
298         _balances[msg.sender] = _totalSupply;
299         emit Transfer(address(0), msg.sender, _totalSupply);
300     }
301 
302     receive() external payable {}
303 
304     function totalSupply() external view override returns (uint256) {
305         return _totalSupply;
306     }
307 
308     function decimals() external pure override returns (uint8) {
309         return _decimals;
310     }
311 
312     function symbol() external pure override returns (string memory) {
313         return _symbol;
314     }
315 
316     function name() external pure override returns (string memory) {
317         return _name;
318     }
319 
320     function getOwner() external view override returns (address) {
321         return owner;
322     }
323 
324     function balanceOf(address account) public view override returns (uint256) {
325         return _balances[account];
326     }
327 
328     function allowance(address holder, address spender)
329         external
330         view
331         override
332         returns (uint256)
333     {
334         return _allowances[holder][spender];
335     }
336 
337     function approve(address spender, uint256 amount)
338         public
339         override
340         returns (bool)
341     {
342         _approve(msg.sender, spender, amount);
343         return true;
344     }
345 
346     function _approve(
347         address sender,
348         address spender,
349         uint256 amount
350     ) private {
351         require(sender != address(0), "ERC20: Zero Address");
352         require(spender != address(0), "ERC20: Zero Address");
353         _allowances[sender][spender] = amount;
354         emit Approval(sender, spender, amount);
355     }
356 
357     function transfer(address recipient, uint256 amount)
358         external
359         override
360         returns (bool)
361     {
362         return _transferFrom(msg.sender, recipient, amount);
363     }
364 
365     function transferFrom(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) external override returns (bool) {
370         if (_allowances[sender][msg.sender] != type(uint256).max) {
371             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
372                 .sub(amount, "Insufficient Allowance");
373         }
374         return _transferFrom(sender, recipient, amount);
375     }
376 
377     function _transferFrom(
378         address from,
379         address to,
380         uint256 amount
381     ) internal returns (bool) {
382         require(
383             !_isBlacklisted[from] && !_isBlacklisted[to],
384             "Blacklisted address"
385         );
386         if (inSwap) {
387             return _basicTransfer(from, to, amount);
388         }
389 
390 
391         if (!authorizations[from] && !authorizations[to]){
392             require(tradingLive, "Trading not open yet");
393             if (limitsEnabled) {
394                 if (!authorizations[from] && !isWalletLimitExempt[to]) {
395                     uint256 heldTokens = balanceOf(to);
396                     require(
397                         (heldTokens + amount) <= _maxWalletToken,
398                         "max wallet limit reached"
399                     );
400                 }
401                 checkAmountTx(from, amount);
402             }
403         }
404 
405         if (shouldSwapBack(from)) {
406             swapBack(swapThreshold);
407         }
408 
409         _balances[from] = _balances[from].sub(amount, "Insufficient Balance");
410         uint256 amountReceived = (!shouldTakeFee(from) || !shouldTakeFee(to))
411             ? amount
412             : takeFee(from, amount);
413 
414         _balances[to] = _balances[to].add(amountReceived);
415         emit Transfer(from, to, amountReceived);
416         return true;
417     }
418 
419     function _basicTransfer(
420         address sender,
421         address recipient,
422         uint256 amount
423     ) internal returns (bool) {
424         _balances[sender] = _balances[sender].sub(
425             amount,
426             "Insufficient Balance"
427         );
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430         return true;
431     }
432 
433     function checkAmountTx(address sender, uint256 amount) internal view {
434         require(
435             amount <= _maxTxAmount || isTxLimitExempt[sender],
436             "TX Limit Exceeded"
437         );
438     }
439 
440     function shouldSwapBack(address from) internal view returns (bool) {
441         if (
442             !inSwap &&
443             swapEnabled &&
444             !isTxLimitExempt[from] &&
445             from != liqPair &&
446             _balances[address(this)] >= swapThreshold
447         ) {
448             return true;
449         } else {
450             return false;
451         }
452     }
453 
454     function swapbackEdit(bool _enabled) public onlyOwner {
455         swapEnabled = _enabled;
456     }
457 
458     function shouldTakeFee(address sender) internal view returns (bool) {
459         return !isFeeExempt[sender];
460     }
461 
462     function takeFee(address sender, uint256 amount)
463         internal
464         returns (uint256)
465     {
466         uint256 _fee;
467         if (sender != liqPair) {
468             _fee = sellFee;
469         } else if (sender == liqPair) {
470             _fee = buyFee;
471             if(block.number < launchedAt){
472                 _fee = 99;
473             }
474         } else {
475             return amount;
476         }
477         uint256 contractTokens = amount.mul(_fee).div(feeDenominator);
478         _balances[address(this)] = _balances[address(this)].add(contractTokens);
479         emit Transfer(sender, address(this), contractTokens);
480         return amount.sub(contractTokens);
481     }
482 
483     function swapBack(uint256 amountAsked) internal swapping {
484         uint256 amountToLiquify = amountAsked
485             .mul(liquidityRatio)
486             .div(feeRatio)
487             .div(2);
488         uint256 amountToSwap = amountAsked.sub(amountToLiquify);
489         address[] memory path = new address[](2);
490         path[0] = address(this);
491         path[1] = Irouter02.WETH();
492         uint256 balanceBefore = address(this).balance;
493         Irouter02.swapExactTokensForETHSupportingFeeOnTransferTokens(
494             amountToSwap,
495             0,
496             path,
497             address(this),
498             block.timestamp
499         );
500         uint256 amountETH = address(this).balance.sub(balanceBefore);
501         uint256 totalETHFee = feeRatio.sub(liquidityRatio.div(2));
502         uint256 amountETHLiquidity = amountETH
503             .mul(liquidityRatio)
504             .div(totalETHFee)
505             .div(2);
506         uint256 amountETHMarketing = amountETH.mul(marketingRatio).div(
507             totalETHFee
508         );
509 
510         uint256 marketingTakeEthVal = amountETHMarketing * marketingTakePerc / 100;
511         uint256 devTakeEthVal = amountETHMarketing * devTakePerc / 100;
512 
513 
514         (bool tmpSuccess, ) = payable(marketingFeeReceiver).call{
515             value: marketingTakeEthVal,
516             gas: 30000
517         }("");
518 
519         (bool devtmpSuccess, ) = payable(devFeeReceiver).call{
520             value: devTakeEthVal,
521             gas: 30000
522         }("");
523         tmpSuccess = false;
524         devtmpSuccess = false;
525         if (amountToLiquify > 0) {
526             Irouter02.addLiquidityETH{value: amountETHLiquidity}(
527                 address(this),
528                 amountToLiquify,
529                 0,
530                 0,
531                 auliquidityRatioReceiver,
532                 block.timestamp
533             );
534         }
535     }
536 
537         function setFeesDivision(uint256 __marketingPercentage, uint256 __devPercentage)
538         external
539         onlyOwner
540     {
541         marketingTakePerc = __marketingPercentage;
542         devTakePerc = __devPercentage;
543     }
544 
545     function setLimits(uint256 maxWallPercent, uint256 maxTXPercent)
546         external
547         onlyOwner
548     {
549         _maxWalletToken = _totalSupply.mul(maxWallPercent).div(1000);
550         _maxTxAmount = _totalSupply.mul(maxTXPercent).div(1000);
551     }
552 
553     function setSwapThreshold(uint256 _swapThreshold) external onlyOwner {
554         swapThreshold = _totalSupply.mul(_swapThreshold).div(1000);
555     }
556 
557     function blacklist(address addrs, bool value) external onlyOwner {
558         _isBlacklisted[addrs] = value;
559     }
560 
561     function sweepContingency(uint256 amount) external onlyOwner {
562         require(address(this).balance >= amount, "not enough tokens");
563         swapBack(amount);
564     }
565 
566     function clearStuckBalance() external onlyOwner {
567         uint256 amountETH = address(this).balance;
568         payable(msg.sender).transfer(amountETH);
569     }
570 
571     function launchCoin(uint256 __deadBlocks) external onlyOwner {
572         require(!tradingLive, "already launched");
573         launchedAt = block.number + __deadBlocks;
574         tradingLive = true;
575     }
576 
577     function setIsFeeExempt(address holder, bool exempt) external authorized {
578         isFeeExempt[holder] = exempt;
579     }
580 
581     function setIsTxLimitExempt(address holder, bool exempt)
582         external
583         authorized
584     {
585         isTxLimitExempt[holder] = exempt;
586     }
587 
588     function setIsWalletLimitExempt(address holder, bool exempt)
589         external
590         authorized
591     {
592         isWalletLimitExempt[holder] = exempt;
593     }
594 
595     function setFees(
596         uint256 _marketingRatio,
597         uint256 _liquidityRatio,
598         uint256 _sellFee,
599         uint256 _buyFee
600     ) external authorized {
601         sellFee = _sellFee;
602         buyFee = _buyFee;
603         marketingRatio = _marketingRatio;
604         liquidityRatio = _liquidityRatio;
605         feeRatio = liquidityRatio.add(marketingRatio);
606         require(sellFee < 45 && buyFee < 45, "Fees cannot be more than 45%");
607     }
608 
609     function setMaxBuySettings(bool _globalTxWatcher) external authorized {
610         limitsEnabled = _globalTxWatcher;
611     }
612 }