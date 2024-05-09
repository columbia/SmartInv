1 /**
2 
3 https://www.taxer.one/
4 
5 https://twitter.com/TaxerCoin
6 
7 https://t.me/taxercoin
8 
9 
10 Gamified Tax System
11 
12  ▀█▀ ▄▀█ ▀▄▀ █▀▀ █▀█
13  ░█░ █▀█ █░█ ██▄ █▀▄
14 
15 ▶ Make The Biggest Buy In Tokens And Hold The Taxer Role For 1 Hour,
16  You will Earn 2% in Fees in ETH, Similar To How The Marketing Wallet Does.
17 
18 
19 ▶ If you sell tokens at any point while holding the Taxer Role, Automatically you will stop earning fees.
20  If you sell before and try to buyback you will not be able to earn fees, you may have 0 sells on the wallet which you are Taxer
21 
22 
23 ▶ If you Beat The Record Of The Previous Taxer Role Holder While They Are Holding
24  The Role You Will Be Given The Taxer Role and The Timer Will Reset.
25 
26 
27 
28 */
29 
30 pragma solidity ^0.7.4;
31 
32 // SPDX-License-Identifier: MIT
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(
46         uint256 a,
47         uint256 b,
48         string memory errorMessage
49     ) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(
69         uint256 a,
70         uint256 b,
71         string memory errorMessage
72     ) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 }
78 
79 interface IERC20 {
80     function totalSupply() external view returns (uint256);
81 
82     function decimals() external view returns (uint8);
83 
84     function symbol() external view returns (string memory);
85 
86     function name() external view returns (string memory);
87 
88     function getOwner() external view returns (address);
89 
90     function balanceOf(address account) external view returns (uint256);
91 
92     function transfer(address recipient, uint256 amount)
93         external
94         returns (bool);
95 
96     function allowance(address _owner, address spender)
97         external
98         view
99         returns (uint256);
100 
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 }
116 
117 interface IDEXFactory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122 
123 interface IDEXRouter {
124     function factory() external pure returns (address);
125 
126     function WETH() external pure returns (address);
127 
128     function getAmountsIn(uint256 amountOut, address[] memory path)
129         external
130         view
131         returns (uint256[] memory amounts);
132 
133     function addLiquidity(
134         address tokenA,
135         address tokenB,
136         uint256 amountADesired,
137         uint256 amountBDesired,
138         uint256 amountAMin,
139         uint256 amountBMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         returns (
145             uint256 amountA,
146             uint256 amountB,
147             uint256 liquidity
148         );
149 
150     function addLiquidityETH(
151         address token,
152         uint256 amountTokenDesired,
153         uint256 amountTokenMin,
154         uint256 amountETHMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         payable
160         returns (
161             uint256 amountToken,
162             uint256 amountETH,
163             uint256 liquidity
164         );
165 
166     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
167         uint256 amountIn,
168         uint256 amountOutMin,
169         address[] calldata path,
170         address to,
171         uint256 deadline
172     ) external;
173 
174     function swapExactETHForTokensSupportingFeeOnTransferTokens(
175         uint256 amountOutMin,
176         address[] calldata path,
177         address to,
178         uint256 deadline
179     ) external payable;
180 
181     function swapExactTokensForETHSupportingFeeOnTransferTokens(
182         uint256 amountIn,
183         uint256 amountOutMin,
184         address[] calldata path,
185         address to,
186         uint256 deadline
187     ) external;
188 }
189 
190 abstract contract Auth {
191     address internal owner;
192     mapping(address => bool) internal authorizations;
193 
194     constructor(address _owner) {
195         owner = _owner;
196         authorizations[_owner] = true;
197     }
198 
199     modifier onlyOwner() {
200         require(isOwner(msg.sender), "!OWNER");
201         _;
202     }
203     modifier authorized() {
204         require(isAuthorized(msg.sender), "!AUTHORIZED");
205         _;
206     }
207 
208     function authorize(address adr) public onlyOwner {
209         authorizations[adr] = true;
210     }
211 
212     function unauthorize(address adr) public onlyOwner {
213         authorizations[adr] = false;
214     }
215 
216     function isOwner(address account) public view returns (bool) {
217         return account == owner;
218     }
219 
220     function isAuthorized(address adr) public view returns (bool) {
221         return authorizations[adr];
222     }
223 
224     function transferOwnership(address payable adr) public onlyOwner {
225         owner = adr;
226         authorizations[adr] = true;
227         emit OwnershipTransferred(adr);
228     }
229 
230     event OwnershipTransferred(address owner);
231 }
232 
233 abstract contract ERC20Interface {
234     function balanceOf(address whom) public view virtual returns (uint256);
235 }
236 
237 contract taxercoin is IERC20, Auth {
238     using SafeMath for uint256;
239 
240     string constant _name = "Taxer";
241     string constant _symbol = "TAXER";
242     uint8 constant _decimals = 18;
243 
244     address DEAD = 0x000000000000000000000000000000000000dEaD;
245     address ZERO = 0x0000000000000000000000000000000000000000;
246     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
247 
248     uint256 _totalSupply = 1000000 * (10**_decimals);
249     uint256 public biggestBuy = 0;
250     uint256 public lastTaxerChange = 0;
251     uint256 public resetPeriod = 1 hours;
252     mapping(address => uint256) _balances;
253     mapping(address => mapping(address => uint256)) _allowances;
254     mapping(address => bool) public isFeeExempt;
255     mapping(address => bool) public isTxLimitExempt;
256     mapping(address => bool) public hasSold;
257 
258     uint256 public liquidityFee = 0;
259     uint256 public marketingFee = 20;
260     uint256 public TaxerFee = 0;
261     uint256 public totalFee = 0;
262     uint256 public totalFeeIfSelling = 20;
263     address public autoLiquidityReceiver;
264     address public marketingWallet;
265     address public Taxer;
266 
267     IDEXRouter public router;
268     address public pair;
269 
270     bool inSwapAndLiquify;
271     bool public swapAndLiquifyEnabled = true;
272     uint256 private _maxTxAmount = (_totalSupply * 2) / 100;
273     uint256 private _maxWalletAmount = (_totalSupply * 2) / 100;
274     uint256 public swapThreshold = (_totalSupply * 5) / 1000;
275 
276     // Function to remove the limits on max wallet and max transaction
277     function removeLimits() external onlyOwner {
278         _maxTxAmount = _totalSupply;
279         _maxWalletAmount = _totalSupply;
280     }
281 
282     modifier lockTheSwap() {
283         inSwapAndLiquify = true;
284         _;
285         inSwapAndLiquify = false;
286     }
287     event AutoLiquify(uint256 amountETH, uint256 amountToken);
288     event NewTaxer(address Taxer, uint256 buyAmount);
289     event TaxerPayout(address Taxer, uint256 amountETH);
290     event TaxerSold(address Taxer, uint256 amountETH);
291 
292     constructor() Auth(msg.sender) {
293         router = IDEXRouter(routerAddress);
294         pair = IDEXFactory(router.factory()).createPair(
295             router.WETH(),
296             address(this)
297         );
298         _allowances[address(this)][address(router)] = uint256(-1);
299         isFeeExempt[DEAD] = true;
300         isTxLimitExempt[DEAD] = true;
301         isFeeExempt[msg.sender] = true;
302         isFeeExempt[address(this)] = true;
303         isTxLimitExempt[msg.sender] = true;
304         isTxLimitExempt[pair] = true;
305         autoLiquidityReceiver = msg.sender;
306         marketingWallet = msg.sender;
307         Taxer = msg.sender;
308         totalFee = liquidityFee.add(marketingFee).add(TaxerFee);
309         totalFeeIfSelling = totalFee;
310         _balances[msg.sender] = _totalSupply;
311         emit Transfer(address(0), msg.sender, _totalSupply);
312     }
313 
314     receive() external payable {}
315 
316     function name() external pure override returns (string memory) {
317         return _name;
318     }
319 
320     function symbol() external pure override returns (string memory) {
321         return _symbol;
322     }
323 
324     function decimals() external pure override returns (uint8) {
325         return _decimals;
326     }
327 
328     function totalSupply() external view override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     function getOwner() external view override returns (address) {
333         return owner;
334     }
335 
336     function getCirculatingSupply() public view returns (uint256) {
337         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
338     }
339 
340     function balanceOf(address account) public view override returns (uint256) {
341         return _balances[account];
342     }
343 
344     function setMaxTxAmount(uint256 amount) external authorized {
345         _maxTxAmount = amount;
346     }
347 
348     function setFees(
349         uint256 newLiquidityFee,
350         uint256 newMarketingFee,
351         uint256 newTaxerFee
352     ) external authorized {
353         liquidityFee = newLiquidityFee;
354         marketingFee = newMarketingFee;
355         TaxerFee = newTaxerFee;
356         totalFee = liquidityFee.add(marketingFee).add(TaxerFee);
357         totalFeeIfSelling = totalFee;
358     }
359 
360     function allowance(address holder, address spender)
361         external
362         view
363         override
364         returns (uint256)
365     {
366         return _allowances[holder][spender];
367     }
368 
369     function approve(address spender, uint256 amount)
370         public
371         override
372         returns (bool)
373     {
374         _allowances[msg.sender][spender] = amount;
375         emit Approval(msg.sender, spender, amount);
376         return true;
377     }
378 
379     function approveMax(address spender) external returns (bool) {
380         return approve(spender, uint256(-1));
381     }
382 
383     function setIsFeeExempt(address holder, bool exempt) external authorized {
384         isFeeExempt[holder] = exempt;
385     }
386 
387     function setIsTxLimitExempt(address holder, bool exempt)
388         external
389         authorized
390     {
391         isTxLimitExempt[holder] = exempt;
392     }
393 
394     function setSwapThreshold(uint256 threshold) external authorized {
395         swapThreshold = threshold;
396     }
397 
398     function setFeeReceivers(
399         address newLiquidityReceiver,
400         address newMarketingWallet
401     ) external authorized {
402         autoLiquidityReceiver = newLiquidityReceiver;
403         marketingWallet = newMarketingWallet;
404     }
405 
406     function setResetPeriodInSeconds(uint256 newResetPeriod)
407         external
408         authorized
409     {
410         resetPeriod = newResetPeriod;
411     }
412 
413     function _reset() internal {
414         Taxer = marketingWallet;
415         biggestBuy = 0;
416         lastTaxerChange = block.timestamp;
417     }
418 
419     function epochReset() external view returns (uint256) {
420         return lastTaxerChange + resetPeriod;
421     }
422 
423     function _checkTxLimit(
424         address sender,
425         address recipient,
426         uint256 amount
427     ) internal {
428         if (block.timestamp - lastTaxerChange > resetPeriod) {
429             _reset();
430         }
431         if (
432             sender != owner &&
433             recipient != owner &&
434             !isTxLimitExempt[recipient] &&
435             recipient != ZERO &&
436             recipient != DEAD &&
437             recipient != pair &&
438             recipient != address(this)
439         ) {
440             require(amount <= _maxTxAmount, "MAX TX");
441             uint256 contractBalanceRecipient = balanceOf(recipient);
442             require(
443                 contractBalanceRecipient + amount <= _maxWalletAmount,
444                 "Exceeds maximum wallet token amount"
445             );
446             address[] memory path = new address[](2);
447             path[0] = router.WETH();
448             path[1] = address(this);
449             uint256 usedEth = router.getAmountsIn(amount, path)[0];
450             if (!hasSold[recipient] && usedEth > biggestBuy) {
451                 Taxer = recipient;
452                 biggestBuy = usedEth;
453                 lastTaxerChange = block.timestamp;
454                 emit NewTaxer(Taxer, biggestBuy);
455             }
456         }
457         if (
458             sender != owner &&
459             recipient != owner &&
460             !isTxLimitExempt[sender] &&
461             sender != pair &&
462             recipient != address(this)
463         ) {
464             require(amount <= _maxTxAmount, "MAX TX");
465             if (Taxer == sender) {
466                 emit TaxerSold(Taxer, biggestBuy);
467                 _reset();
468             }
469             hasSold[sender] = true;
470         }
471     }
472 
473     function setSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit)
474         external
475         authorized
476     {
477         swapAndLiquifyEnabled = enableSwapBack;
478         swapThreshold = newSwapBackLimit;
479     }
480 
481     function transfer(address recipient, uint256 amount)
482         external
483         override
484         returns (bool)
485     {
486         return _transferFrom(msg.sender, recipient, amount);
487     }
488 
489     function transferFrom(
490         address sender,
491         address recipient,
492         uint256 amount
493     ) external override returns (bool) {
494         if (_allowances[sender][msg.sender] != uint256(-1)) {
495             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
496                 .sub(amount, "Insufficient Allowance");
497         }
498         _transferFrom(sender, recipient, amount);
499         return true;
500     }
501 
502     function _transferFrom(
503         address sender,
504         address recipient,
505         uint256 amount
506     ) internal returns (bool) {
507         if (inSwapAndLiquify) {
508             return _basicTransfer(sender, recipient, amount);
509         }
510         if (
511             msg.sender != pair &&
512             !inSwapAndLiquify &&
513             swapAndLiquifyEnabled &&
514             _balances[address(this)] >= swapThreshold
515         ) {
516             swapBack();
517         }
518         _checkTxLimit(sender, recipient, amount);
519         require(!isWalletToWallet(sender, recipient), "Don't cheat");
520         _balances[sender] = _balances[sender].sub(
521             amount,
522             "Insufficient Balance"
523         );
524         uint256 amountReceived = !isFeeExempt[sender] && !isFeeExempt[recipient]
525             ? takeFee(sender, recipient, amount)
526             : amount;
527         _balances[recipient] = _balances[recipient].add(amountReceived);
528         emit Transfer(msg.sender, recipient, amountReceived);
529         return true;
530     }
531 
532     function _basicTransfer(
533         address sender,
534         address recipient,
535         uint256 amount
536     ) internal returns (bool) {
537         _balances[sender] = _balances[sender].sub(
538             amount,
539             "Insufficient Balance"
540         );
541         _balances[recipient] = _balances[recipient].add(amount);
542         emit Transfer(sender, recipient, amount);
543         return true;
544     }
545 
546     function takeFee(
547         address sender,
548         address recipient,
549         uint256 amount
550     ) internal returns (uint256) {
551         uint256 feeApplicable = pair == recipient
552             ? totalFeeIfSelling
553             : totalFee;
554         uint256 feeAmount = amount.mul(feeApplicable).div(100);
555         _balances[address(this)] = _balances[address(this)].add(feeAmount);
556         emit Transfer(sender, address(this), feeAmount);
557         return amount.sub(feeAmount);
558     }
559 
560     function isWalletToWallet(address sender, address recipient)
561         internal
562         view
563         returns (bool)
564     {
565         if (isFeeExempt[sender] || isFeeExempt[recipient]) {
566             return false;
567         }
568         if (sender == pair || recipient == pair) {
569             return false;
570         }
571         return true;
572     }
573 
574     function swapBack() internal lockTheSwap {
575         //uint256 tokensToLiquify = _balances[address(this)];
576         uint256 tokensToLiquify = swapThreshold;
577         uint256 amountToLiquify = tokensToLiquify
578             .mul(liquidityFee)
579             .div(totalFee)
580             .div(2);
581         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
582 
583         address[] memory path = new address[](2);
584         path[0] = address(this);
585         path[1] = router.WETH();
586 
587         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
588             amountToSwap,
589             0,
590             path,
591             address(this),
592             block.timestamp
593         );
594 
595         uint256 amountETH = address(this).balance;
596         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
597         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
598             totalETHFee
599         );
600         uint256 amountETHTaxer = amountETH.mul(TaxerFee).div(totalETHFee);
601         uint256 amountETHLiquidity = amountETH
602             .mul(liquidityFee)
603             .div(totalETHFee)
604             .div(2);
605 
606         (bool tmpSuccess, ) = payable(marketingWallet).call{
607             value: amountETHMarketing,
608             gas: 30000
609         }("");
610         (bool tmpSuccess2, ) = payable(Taxer).call{
611             value: amountETHTaxer,
612             gas: 30000
613         }("");
614         emit TaxerPayout(Taxer, amountETHTaxer);
615 
616         // only to supress warning msg
617         tmpSuccess = false;
618         tmpSuccess2 = false;
619 
620         if (amountToLiquify > 0) {
621             router.addLiquidityETH{value: amountETHLiquidity}(
622                 address(this),
623                 amountToLiquify,
624                 0,
625                 0,
626                 autoLiquidityReceiver,
627                 block.timestamp
628             );
629             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
630         }
631     }
632 
633     function recoverLosteth() external authorized {
634         payable(msg.sender).transfer(address(this).balance);
635     }
636 
637     function recoverLostTokens(address _token, uint256 _amount)
638         external
639         authorized
640     {
641         IERC20(_token).transfer(msg.sender, _amount);
642     }
643 }