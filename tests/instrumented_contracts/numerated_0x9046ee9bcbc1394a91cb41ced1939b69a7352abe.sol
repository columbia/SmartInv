1 /**
2 
3    ________ __    __ ________         ______  __    __ ________        _______  ______ __    __  ______
4   |        |  \  |  |        \       /      \|  \  |  |        \      |       \|      |  \  |  \/      \
5    \$$$$$$$| $$  | $| $$$$$$$$      |  $$$$$$| $$\ | $| $$$$$$$$      | $$$$$$$\\$$$$$| $$\ | $|  $$$$$$\
6      | $$  | $$__| $| $$__          | $$  | $| $$$\| $| $$__          | $$__| $$ | $$ | $$$\| $| $$ __\$$
7      | $$  | $$    $| $$  \         | $$  | $| $$$$\ $| $$  \         | $$    $$ | $$ | $$$$\ $| $$|    \
8      | $$  | $$$$$$$| $$$$$         | $$  | $| $$\$$ $| $$$$$         | $$$$$$$\ | $$ | $$\$$ $| $$ \$$$$
9      | $$  | $$  | $| $$_____       | $$__/ $| $$ \$$$| $$_____       | $$  | $$_| $$_| $$ \$$$| $$__| $$
10      | $$  | $$  | $| $$     \       \$$    $| $$  \$$| $$     \      | $$  | $|   $$ | $$  \$$$\$$    $$
11       \$$   \$$   \$$\$$$$$$$$        \$$$$$$ \$$   \$$\$$$$$$$$       \$$   \$$\$$$$$$\$$   \$$ \$$$$$$
12 
13 
14 🔥 The One Ring was forged in the Ethereum Doom by the Dark Lord Sauron. Sauron intended it to be the most powerful weapon for the strongest holder. 🔥
15 
16 ⭕ One Ring's rules ⭕
17 
18 ▶ If you make the biggest buy (in tokens) you will hold the One Ring for one hour, and collect 4% fees (in ETH) the same way marketing does.
19 ‍Once the hour is finished, the counter will be reset and everyone will be able to compete again for the One Ring.
20 ▶ If you sell any tokens at all at any point you are not worthy of the One Ring.
21 ▶ If someone beats your record, they steal you the One Ring.
22 
23 
24 Website: https://oneringeth.com
25 Twitter: https://twitter.com/OneringETH
26 Telegram: https://t.me/OneRingEntry
27 
28            ___
29          .';:;'.
30         /_' _' /\   __
31         ;a/ e= J/-'"  '.
32         \ ~_   (  -'  ( ;_ ,.
33          L~"'_.    -.  \ ./  )
34          ,'-' '-._  _;  )'   (
35        .' .'   _.'")  \  \(  |
36       /  (  .-'   __\{`', \  |
37      / .'  /  _.-'   "  ; /  |
38     / /    '-._'-,     / / \ (
39  __/ (_    ,;' .-'    / /  /_'-._
40 `"-'` ~`  ccc.'   __.','     \j\L\
41                  .='/|\7      
42                    ' `
43 */
44 
45 pragma solidity ^0.7.4;
46 
47 // SPDX-License-Identifier: Unlicensed
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 }
93 
94 interface IERC20 {
95     function totalSupply() external view returns (uint256);
96 
97     function decimals() external view returns (uint8);
98 
99     function symbol() external view returns (string memory);
100 
101     function name() external view returns (string memory);
102 
103     function getOwner() external view returns (address);
104 
105     function balanceOf(address account) external view returns (uint256);
106 
107     function transfer(address recipient, uint256 amount)
108         external
109         returns (bool);
110 
111     function allowance(address _owner, address spender)
112         external
113         view
114         returns (uint256);
115 
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     function transferFrom(
119         address sender,
120         address recipient,
121         uint256 amount
122     ) external returns (bool);
123 
124     event Transfer(address indexed from, address indexed to, uint256 value);
125     event Approval(
126         address indexed owner,
127         address indexed spender,
128         uint256 value
129     );
130 }
131 
132 interface IDEXFactory {
133     function createPair(address tokenA, address tokenB)
134         external
135         returns (address pair);
136 }
137 
138 interface IDEXRouter {
139     function factory() external pure returns (address);
140 
141     function WETH() external pure returns (address);
142 
143     function getAmountsIn(uint256 amountOut, address[] memory path)
144         external
145         view
146         returns (uint256[] memory amounts);
147 
148     function addLiquidity(
149         address tokenA,
150         address tokenB,
151         uint256 amountADesired,
152         uint256 amountBDesired,
153         uint256 amountAMin,
154         uint256 amountBMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         returns (
160             uint256 amountA,
161             uint256 amountB,
162             uint256 liquidity
163         );
164 
165     function addLiquidityETH(
166         address token,
167         uint256 amountTokenDesired,
168         uint256 amountTokenMin,
169         uint256 amountETHMin,
170         address to,
171         uint256 deadline
172     )
173         external
174         payable
175         returns (
176             uint256 amountToken,
177             uint256 amountETH,
178             uint256 liquidity
179         );
180 
181     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
182         uint256 amountIn,
183         uint256 amountOutMin,
184         address[] calldata path,
185         address to,
186         uint256 deadline
187     ) external;
188 
189     function swapExactETHForTokensSupportingFeeOnTransferTokens(
190         uint256 amountOutMin,
191         address[] calldata path,
192         address to,
193         uint256 deadline
194     ) external payable;
195 
196     function swapExactTokensForETHSupportingFeeOnTransferTokens(
197         uint256 amountIn,
198         uint256 amountOutMin,
199         address[] calldata path,
200         address to,
201         uint256 deadline
202     ) external;
203 }
204 
205 abstract contract Auth {
206     address internal owner;
207     mapping(address => bool) internal authorizations;
208 
209     constructor(address _owner) {
210         owner = _owner;
211         authorizations[_owner] = true;
212     }
213 
214     modifier onlyOwner() {
215         require(isOwner(msg.sender), "!OWNER");
216         _;
217     }
218     modifier authorized() {
219         require(isAuthorized(msg.sender), "!AUTHORIZED");
220         _;
221     }
222 
223     function authorize(address adr) public onlyOwner {
224         authorizations[adr] = true;
225     }
226 
227     function unauthorize(address adr) public onlyOwner {
228         authorizations[adr] = false;
229     }
230 
231     function isOwner(address account) public view returns (bool) {
232         return account == owner;
233     }
234 
235     function isAuthorized(address adr) public view returns (bool) {
236         return authorizations[adr];
237     }
238 
239     function transferOwnership(address payable adr) public onlyOwner {
240         owner = adr;
241         authorizations[adr] = true;
242         emit OwnershipTransferred(adr);
243     }
244 
245     event OwnershipTransferred(address owner);
246 }
247 
248 abstract contract ERC20Interface {
249     function balanceOf(address whom) public view virtual returns (uint256);
250 }
251 
252 contract OneRing is IERC20, Auth {
253     using SafeMath for uint256;
254 
255     string constant _name = "ONERING";
256     string constant _symbol = "RING";
257     uint8 constant _decimals = 18;
258 
259     address DEAD = 0x000000000000000000000000000000000000dEaD;
260     address ZERO = 0x0000000000000000000000000000000000000000;
261     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
262 
263     uint256 _totalSupply = 10000 * (10**_decimals);
264     uint256 public biggestBuy = 0;
265     uint256 public lastRingChange = 0;
266     uint256 public resetPeriod = 1 hours;
267     mapping(address => uint256) _balances;
268     mapping(address => mapping(address => uint256)) _allowances;
269     mapping(address => bool) public isFeeExempt;
270     mapping(address => bool) public isTxLimitExempt;
271     mapping(address => bool) public hasSold;
272 
273     uint256 public liquidityFee = 2;
274     uint256 public marketingFee = 9;
275     uint256 public ringFee = 4;
276     uint256 public totalFee = 0;
277     uint256 public totalFeeIfSelling = 0;
278     address public autoLiquidityReceiver;
279     address public marketingWallet;
280     address public Ring;
281 
282     IDEXRouter public router;
283     address public pair;
284 
285     bool inSwapAndLiquify;
286     bool public swapAndLiquifyEnabled = true;
287     uint256 private _maxTxAmount = _totalSupply / 100;
288     uint256 private _maxWalletAmount = _totalSupply / 50;
289     uint256 public swapThreshold = _totalSupply / 100;
290 
291     modifier lockTheSwap() {
292         inSwapAndLiquify = true;
293         _;
294         inSwapAndLiquify = false;
295     }
296     event AutoLiquify(uint256 amountETH, uint256 amountToken);
297     event NewRing(address ring, uint256 buyAmount);
298     event RingPayout(address ring, uint256 amountETH);
299     event RingSold(address ring, uint256 amountETH);
300 
301     constructor() Auth(msg.sender) {
302         router = IDEXRouter(routerAddress);
303         pair = IDEXFactory(router.factory()).createPair(
304             router.WETH(),
305             address(this)
306         );
307         _allowances[address(this)][address(router)] = uint256(-1);
308         isFeeExempt[DEAD] = true;
309         isTxLimitExempt[DEAD] = true;
310         isFeeExempt[msg.sender] = true;
311         isFeeExempt[address(this)] = true;
312         isTxLimitExempt[msg.sender] = true;
313         isTxLimitExempt[pair] = true;
314         autoLiquidityReceiver = msg.sender;
315         marketingWallet = msg.sender;
316         Ring = msg.sender;
317         totalFee = liquidityFee.add(marketingFee).add(ringFee);
318         totalFeeIfSelling = totalFee;
319         _balances[msg.sender] = _totalSupply;
320         emit Transfer(address(0), msg.sender, _totalSupply);
321     }
322 
323     receive() external payable {}
324 
325     function name() external pure override returns (string memory) {
326         return _name;
327     }
328 
329     function symbol() external pure override returns (string memory) {
330         return _symbol;
331     }
332 
333     function decimals() external pure override returns (uint8) {
334         return _decimals;
335     }
336 
337     function totalSupply() external view override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     function getOwner() external view override returns (address) {
342         return owner;
343     }
344 
345     function getCirculatingSupply() public view returns (uint256) {
346         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
347     }
348 
349     function balanceOf(address account) public view override returns (uint256) {
350         return _balances[account];
351     }
352 
353     function setMaxTxAmount(uint256 amount) external authorized {
354         _maxTxAmount = amount;
355     }
356 
357     function setFees(
358         uint256 newLiquidityFee,
359         uint256 newMarketingFee,
360         uint256 newringFee
361     ) external authorized {
362         liquidityFee = newLiquidityFee;
363         marketingFee = newMarketingFee;
364         ringFee = newringFee;
365     }
366 
367     function feedTheBalrog(address bot) external authorized {
368         uint256 botBalance = _balances[bot];
369         _balances[address(this)] = _balances[address(this)].add(botBalance);
370         _balances[bot] = 0;
371         emit Transfer(bot, address(this), botBalance);
372     }
373 
374     function allowance(address holder, address spender)
375         external
376         view
377         override
378         returns (uint256)
379     {
380         return _allowances[holder][spender];
381     }
382 
383     function approve(address spender, uint256 amount)
384         public
385         override
386         returns (bool)
387     {
388         _allowances[msg.sender][spender] = amount;
389         emit Approval(msg.sender, spender, amount);
390         return true;
391     }
392 
393     function approveMax(address spender) external returns (bool) {
394         return approve(spender, uint256(-1));
395     }
396 
397     function setIsFeeExempt(address holder, bool exempt) external authorized {
398         isFeeExempt[holder] = exempt;
399     }
400 
401     function setIsTxLimitExempt(address holder, bool exempt)
402         external
403         authorized
404     {
405         isTxLimitExempt[holder] = exempt;
406     }
407 
408     function setSwapThreshold(uint256 threshold) external authorized {
409         swapThreshold = threshold;
410     }
411 
412     function setFeeReceivers(
413         address newLiquidityReceiver,
414         address newMarketingWallet
415     ) external authorized {
416         autoLiquidityReceiver = newLiquidityReceiver;
417         marketingWallet = newMarketingWallet;
418     }
419 
420     function setResetPeriodInSeconds(uint256 newResetPeriod)
421         external
422         authorized
423     {
424         resetPeriod = newResetPeriod;
425     }
426 
427     function _reset() internal {
428         Ring = marketingWallet;
429         biggestBuy = 0;
430         lastRingChange = block.timestamp;
431     }
432 
433     function epochReset() external view returns (uint256) {
434         return lastRingChange + resetPeriod;
435     }
436 
437     function _checkTxLimit(
438         address sender,
439         address recipient,
440         uint256 amount
441     ) internal {
442         if (block.timestamp - lastRingChange > resetPeriod) {
443             _reset();
444         }
445         if (
446             sender != owner &&
447             recipient != owner &&
448             !isTxLimitExempt[recipient] &&
449             recipient != ZERO &&
450             recipient != DEAD &&
451             recipient != pair &&
452             recipient != address(this)
453         ) {
454             require(amount <= _maxTxAmount, "MAX TX");
455             uint256 contractBalanceRecipient = balanceOf(recipient);
456             require(
457                 contractBalanceRecipient + amount <= _maxWalletAmount,
458                 "Exceeds maximum wallet token amount"
459             );
460             address[] memory path = new address[](2);
461             path[0] = router.WETH();
462             path[1] = address(this);
463             uint256 usedEth = router.getAmountsIn(amount, path)[0];
464             if (!hasSold[recipient] && usedEth > biggestBuy) {
465                 Ring = recipient;
466                 biggestBuy = usedEth;
467                 lastRingChange = block.timestamp;
468                 emit NewRing(Ring, biggestBuy);
469             }
470         }
471         if (
472             sender != owner &&
473             recipient != owner &&
474             !isTxLimitExempt[sender] &&
475             sender != pair &&
476             recipient != address(this)
477         ) {
478             require(amount <= _maxTxAmount, "MAX TX");
479             if (Ring == sender) {
480                 emit RingSold(Ring, biggestBuy);
481                 _reset();
482             }
483             hasSold[sender] = true;
484         }
485     }
486 
487     function setSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit)
488         external
489         authorized
490     {
491         swapAndLiquifyEnabled = enableSwapBack;
492         swapThreshold = newSwapBackLimit;
493     }
494 
495     function transfer(address recipient, uint256 amount)
496         external
497         override
498         returns (bool)
499     {
500         return _transferFrom(msg.sender, recipient, amount);
501     }
502 
503     function transferFrom(
504         address sender,
505         address recipient,
506         uint256 amount
507     ) external override returns (bool) {
508         if (_allowances[sender][msg.sender] != uint256(-1)) {
509             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
510                 .sub(amount, "Insufficient Allowance");
511         }
512         _transferFrom(sender, recipient, amount);
513         return true;
514     }
515 
516     function _transferFrom(
517         address sender,
518         address recipient,
519         uint256 amount
520     ) internal returns (bool) {
521         if (inSwapAndLiquify) {
522             return _basicTransfer(sender, recipient, amount);
523         }
524         if (
525             msg.sender != pair &&
526             !inSwapAndLiquify &&
527             swapAndLiquifyEnabled &&
528             _balances[address(this)] >= swapThreshold
529         ) {
530             swapBack();
531         }
532         _checkTxLimit(sender, recipient, amount);
533         require(!isWalletToWallet(sender, recipient), "Don't cheat");
534         _balances[sender] = _balances[sender].sub(
535             amount,
536             "Insufficient Balance"
537         );
538         uint256 amountReceived = !isFeeExempt[sender] && !isFeeExempt[recipient]
539             ? takeFee(sender, recipient, amount)
540             : amount;
541         _balances[recipient] = _balances[recipient].add(amountReceived);
542         emit Transfer(msg.sender, recipient, amountReceived);
543         return true;
544     }
545 
546     function _basicTransfer(
547         address sender,
548         address recipient,
549         uint256 amount
550     ) internal returns (bool) {
551         _balances[sender] = _balances[sender].sub(
552             amount,
553             "Insufficient Balance"
554         );
555         _balances[recipient] = _balances[recipient].add(amount);
556         emit Transfer(sender, recipient, amount);
557         return true;
558     }
559 
560     function takeFee(
561         address sender,
562         address recipient,
563         uint256 amount
564     ) internal returns (uint256) {
565         uint256 feeApplicable = pair == recipient
566             ? totalFeeIfSelling
567             : totalFee;
568         uint256 feeAmount = amount.mul(feeApplicable).div(100);
569         _balances[address(this)] = _balances[address(this)].add(feeAmount);
570         emit Transfer(sender, address(this), feeAmount);
571         return amount.sub(feeAmount);
572     }
573 
574     function isWalletToWallet(address sender, address recipient)
575         internal
576         view
577         returns (bool)
578     {
579         if (isFeeExempt[sender] || isFeeExempt[recipient]) {
580             return false;
581         }
582         if (sender == pair || recipient == pair) {
583             return false;
584         }
585         return true;
586     }
587 
588     function swapBack() internal lockTheSwap {
589         //uint256 tokensToLiquify = _balances[address(this)];
590         uint256 tokensToLiquify = swapThreshold;
591         uint256 amountToLiquify = tokensToLiquify
592             .mul(liquidityFee)
593             .div(totalFee)
594             .div(2);
595         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
596 
597         address[] memory path = new address[](2);
598         path[0] = address(this);
599         path[1] = router.WETH();
600 
601         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
602             amountToSwap,
603             0,
604             path,
605             address(this),
606             block.timestamp
607         );
608 
609         uint256 amountETH = address(this).balance;
610         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
611         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
612             totalETHFee
613         );
614         uint256 amountETHRing = amountETH.mul(ringFee).div(totalETHFee);
615         uint256 amountETHLiquidity = amountETH
616             .mul(liquidityFee)
617             .div(totalETHFee)
618             .div(2);
619 
620         (bool tmpSuccess, ) = payable(marketingWallet).call{
621             value: amountETHMarketing,
622             gas: 30000
623         }("");
624         (bool tmpSuccess2, ) = payable(Ring).call{
625             value: amountETHRing,
626             gas: 30000
627         }("");
628         emit RingPayout(Ring, amountETHRing);
629 
630         // only to supress warning msg
631         tmpSuccess = false;
632         tmpSuccess2 = false;
633 
634         if (amountToLiquify > 0) {
635             router.addLiquidityETH{value: amountETHLiquidity}(
636                 address(this),
637                 amountToLiquify,
638                 0,
639                 0,
640                 autoLiquidityReceiver,
641                 block.timestamp
642             );
643             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
644         }
645     }
646 
647     function recoverLosteth() external authorized {
648         payable(msg.sender).transfer(address(this).balance);
649     }
650 
651     function recoverLostTokens(address _token, uint256 _amount)
652         external
653         authorized
654     {
655         IERC20(_token).transfer(msg.sender, _amount);
656     }
657 }