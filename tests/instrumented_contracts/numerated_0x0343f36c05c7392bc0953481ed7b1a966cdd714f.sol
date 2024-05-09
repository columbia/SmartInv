1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 library SafeMath {
5     function tryAdd(
6         uint256 a,
7         uint256 b
8     ) internal pure returns (bool, uint256) {
9         unchecked {
10             uint256 c = a + b;
11             if (c < a) return (false, 0);
12             return (true, c);
13         }
14     }
15 
16     function trySub(
17         uint256 a,
18         uint256 b
19     ) internal pure returns (bool, uint256) {
20         unchecked {
21             if (b > a) return (false, 0);
22             return (true, a - b);
23         }
24     }
25 
26     function tryMul(
27         uint256 a,
28         uint256 b
29     ) internal pure returns (bool, uint256) {
30         unchecked {
31             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32             // benefit is lost if 'b' is also tested.
33             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
34             if (a == 0) return (true, 0);
35             uint256 c = a * b;
36             if (c / a != b) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     function tryDiv(
42         uint256 a,
43         uint256 b
44     ) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b == 0) return (false, 0);
47             return (true, a / b);
48         }
49     }
50 
51     function tryMod(
52         uint256 a,
53         uint256 b
54     ) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b == 0) return (false, 0);
57             return (true, a % b);
58         }
59     }
60 
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a + b;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a - b;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a * b;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a / b;
75     }
76 
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a % b;
79     }
80 
81     function sub(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         unchecked {
87             require(b <= a, errorMessage);
88             return a - b;
89         }
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a / b;
100         }
101     }
102 
103     function mod(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         unchecked {
109             require(b > 0, errorMessage);
110             return a % b;
111         }
112     }
113 }
114 
115 interface IDexFactory {
116     function createPair(
117         address tokenA,
118         address tokenB
119     ) external returns (address pair);
120 }
121 
122 interface IDexRouter {
123     function factory() external pure returns (address);
124 
125     function WETH() external pure returns (address);
126 
127     function addLiquidityETH(
128         address token,
129         uint256 amountTokenDesired,
130         uint256 amountTokenMin,
131         uint256 amountETHMin,
132         address to,
133         uint256 deadline
134     )
135         external
136         payable
137         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
138 
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external payable;
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint256 amountIn,
148         uint256 amountOutMin,
149         address[] calldata path,
150         address to,
151         uint256 deadline
152     ) external;
153 }
154 
155 interface IERC20Extended {
156     function totalSupply() external view returns (uint256);
157 
158     function decimals() external view returns (uint8);
159 
160     function symbol() external view returns (string memory);
161 
162     function name() external view returns (string memory);
163 
164     function balanceOf(address account) external view returns (uint256);
165 
166     function transfer(
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     function allowance(
172         address _owner,
173         address spender
174     ) external view returns (uint256);
175 
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external returns (bool);
183 
184     event Transfer(address indexed from, address indexed to, uint256 value);
185     event Approval(
186         address indexed owner,
187         address indexed spender,
188         uint256 value
189     );
190 }
191 
192 abstract contract Context {
193     function _msgSender() internal view virtual returns (address payable) {
194         return payable(msg.sender);
195     }
196 
197     function _msgData() internal view virtual returns (bytes memory) {
198         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
199         return msg.data;
200     }
201 }
202 
203 contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(
207         address indexed previousOwner,
208         address indexed newOwner
209     );
210 
211     constructor() {
212         _owner = _msgSender();
213         emit OwnershipTransferred(address(0), _owner);
214     }
215 
216     function owner() public view returns (address) {
217         return _owner;
218     }
219 
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     function renounceOwnership() public virtual onlyOwner {
226         emit OwnershipTransferred(_owner, address(0));
227         _owner = payable(address(0));
228     }
229 
230     function transferOwnership(address newOwner) public virtual onlyOwner {
231         require(
232             newOwner != address(0),
233             "Ownable: new owner is the zero address"
234         );
235         emit OwnershipTransferred(_owner, newOwner);
236         _owner = newOwner;
237     }
238 }
239 
240 // main contract
241 contract XWIFE is IERC20Extended, Ownable {
242     using SafeMath for uint256;
243 
244     string private constant _name = "X Wife";
245     string private constant _symbol = "XWIFE";
246     uint8 private constant _decimals = 9;
247     uint256 private constant _totalSupply = 1_000_000_000 * 10 ** _decimals;
248 
249     address private constant DEAD = address(0xdead);
250     address private constant ZERO = address(0);
251     IDexRouter public router;
252     address public pair;
253     address public autoLiquidityReceiver;
254     address private marketingFeeReceiver;
255     address private devFeeReceiver;
256 
257     uint256 liquidityFeePercent = 0;
258     uint256 marketingFeePercent = 70;
259     uint256 devFeePercent = 30;
260 
261     uint256 public totalBuyFee = 30;
262     uint256 public totalSellFee = 60;
263     uint256 public feeDenominator = 100;
264     uint256 public maxWalletAmount = (_totalSupply * 2) / 100;
265 
266     mapping(address => uint256) private _balances;
267     mapping(address => mapping(address => uint256)) private _allowances;
268     mapping(address => bool) public isFeeExempt;
269     mapping(address => bool) public isLimitExmpt;
270     mapping(address => bool) public isBot;
271 
272     bool public trading;
273     bool public swapEnabled;
274     uint256 public swapThreshold = (_totalSupply * 2) / 100;
275     uint256 public snipingTime = 40 seconds;
276     uint256 public launchedAt;
277     bool inSwap;
278     modifier swapping() {
279         inSwap = true;
280         _;
281         inSwap = false;
282     }
283 
284     event AutoLiquify(uint256 amountEth, uint256 amountToken);
285 
286     constructor() {
287         address router_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
288         autoLiquidityReceiver = msg.sender;
289         marketingFeeReceiver = msg.sender;
290         devFeeReceiver = msg.sender;
291 
292         router = IDexRouter(router_);
293         pair = IDexFactory(router.factory()).createPair(
294             address(this),
295             router.WETH()
296         );
297 
298         isFeeExempt[msg.sender] = true;
299         isFeeExempt[autoLiquidityReceiver] = true;
300         isFeeExempt[marketingFeeReceiver] = true;
301         isFeeExempt[devFeeReceiver] = true;
302 
303         isLimitExmpt[msg.sender] = true;
304         isLimitExmpt[address(this)] = true;
305         isLimitExmpt[address(router)] = true;
306         isLimitExmpt[pair] = true;
307         isLimitExmpt[autoLiquidityReceiver] = true;
308         isLimitExmpt[marketingFeeReceiver] = true;
309         isLimitExmpt[devFeeReceiver] = true;
310 
311         _allowances[address(this)][address(router)] = _totalSupply;
312         _balances[msg.sender] = _totalSupply;
313         emit Transfer(address(0), msg.sender, _totalSupply);
314     }
315 
316     receive() external payable {}
317 
318     function totalSupply() external pure override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     function decimals() external pure override returns (uint8) {
323         return _decimals;
324     }
325 
326     function symbol() external pure override returns (string memory) {
327         return _symbol;
328     }
329 
330     function name() external pure override returns (string memory) {
331         return _name;
332     }
333 
334     function balanceOf(address account) public view override returns (uint256) {
335         return _balances[account];
336     }
337 
338     function allowance(
339         address holder,
340         address spender
341     ) external view override returns (uint256) {
342         return _allowances[holder][spender];
343     }
344 
345     function approve(
346         address spender,
347         uint256 amount
348     ) public override returns (bool) {
349         _allowances[msg.sender][spender] = amount;
350         emit Approval(msg.sender, spender, amount);
351         return true;
352     }
353 
354     function approveMax(address spender) external returns (bool) {
355         return approve(spender, _totalSupply);
356     }
357 
358     function transfer(
359         address recipient,
360         uint256 amount
361     ) external override returns (bool) {
362         return _transferFrom(msg.sender, recipient, amount);
363     }
364 
365     function transferFrom(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) external override returns (bool) {
370         if (_allowances[sender][msg.sender] != _totalSupply) {
371             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
372                 .sub(amount, "Insufficient Allowance");
373         }
374 
375         return _transferFrom(sender, recipient, amount);
376     }
377 
378     function _transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) internal returns (bool) {
383         if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {
384             // trading disable till launch
385             if (!trading) {
386                 require(
387                     pair != sender && pair != recipient,
388                     "trading is disable"
389                 );
390             }
391             // antibot
392             if (
393                 block.timestamp < launchedAt + snipingTime &&
394                 sender != address(router)
395             ) {
396                 if (pair == sender) {
397                     isBot[recipient] = true;
398                 } else if (pair == recipient) {
399                     isBot[sender] = true;
400                 }
401             }
402         }
403         if (!isLimitExmpt[recipient]) {
404             require(
405                 balanceOf(recipient).add(amount) <= maxWalletAmount,
406                 "Max wallet limit exceeds"
407             );
408         }
409 
410         if (inSwap) {
411             return _basicTransfer(sender, recipient, amount);
412         }
413 
414         if (shouldSwapBack()) {
415             swapBack();
416         }
417 
418         _balances[sender] = _balances[sender].sub(
419             amount,
420             "Insufficient Balance"
421         );
422 
423         uint256 amountReceived;
424         if (
425             isFeeExempt[sender] ||
426             isFeeExempt[recipient] ||
427             (sender != pair && recipient != pair)
428         ) {
429             amountReceived = amount;
430         } else {
431             uint256 feeAmount;
432             if (sender == pair) {
433                 feeAmount = amount.mul(totalBuyFee).div(feeDenominator);
434                 amountReceived = amount.sub(feeAmount);
435                 takeFee(sender, feeAmount);
436             } else {
437                 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
438                 amountReceived = amount.sub(feeAmount);
439                 takeFee(sender, feeAmount);
440             }
441         }
442 
443         _balances[recipient] = _balances[recipient].add(amountReceived);
444 
445         emit Transfer(sender, recipient, amountReceived);
446         return true;
447     }
448 
449     function _basicTransfer(
450         address sender,
451         address recipient,
452         uint256 amount
453     ) internal returns (bool) {
454         _balances[sender] = _balances[sender].sub(
455             amount,
456             "Insufficient Balance"
457         );
458         _balances[recipient] = _balances[recipient].add(amount);
459         emit Transfer(sender, recipient, amount);
460         return true;
461     }
462 
463     function takeFee(address sender, uint256 feeAmount) internal {
464         _balances[address(this)] = _balances[address(this)].add(feeAmount);
465         emit Transfer(sender, address(this), feeAmount);
466     }
467 
468     function shouldSwapBack() internal view returns (bool) {
469         return
470             msg.sender != pair &&
471             !inSwap &&
472             swapEnabled &&
473             _balances[address(this)] >= swapThreshold;
474     }
475 
476     function swapBack() internal swapping {
477         uint256 amountToLiquify = swapThreshold
478             .mul(liquidityFeePercent)
479             .div(feeDenominator)
480             .div(2);
481 
482         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
483         _allowances[address(this)][address(router)] = _totalSupply;
484         address[] memory path = new address[](2);
485         path[0] = address(this);
486         path[1] = router.WETH();
487         uint256 balanceBefore = address(this).balance;
488 
489         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
490             amountToSwap,
491             0,
492             path,
493             address(this),
494             block.timestamp
495         );
496 
497         uint256 amountEth = address(this).balance.sub(balanceBefore);
498 
499         uint256 totalEthFee = marketingFeePercent.add(devFeePercent).add(
500             liquidityFeePercent.div(2)
501         );
502 
503         uint256 amountEthLiquidity = amountEth
504             .mul(liquidityFeePercent)
505             .div(totalEthFee)
506             .div(2);
507         uint256 amountEthMarketing = amountEth.mul(marketingFeePercent).div(
508             totalEthFee
509         );
510         uint256 amountEthDev = amountEth.mul(devFeePercent).div(totalEthFee);
511 
512         if (amountEthMarketing > 0) {
513             payable(marketingFeeReceiver).transfer(amountEthMarketing);
514         }
515         if (amountEthDev > 0) {
516             payable(devFeeReceiver).transfer(amountEthDev);
517         }
518 
519         if (amountToLiquify > 0) {
520             router.addLiquidityETH{value: amountEthLiquidity}(
521                 address(this),
522                 amountToLiquify,
523                 0,
524                 0,
525                 autoLiquidityReceiver,
526                 block.timestamp
527             );
528             emit AutoLiquify(amountEthLiquidity, amountToLiquify);
529         }
530     }
531 
532     function enableTrading() external onlyOwner {
533         require(!trading, "Already enabled");
534         trading = true;
535         swapEnabled = true;
536         launchedAt = block.timestamp;
537     }
538 
539     function removeStuckTokens(
540         address receiver,
541         address token,
542         uint256 amount
543     ) external onlyOwner {
544         IERC20Extended(token).transfer(receiver, amount);
545     }
546 
547     function removeStuckEth(
548         address receiver,
549         uint256 amount
550     ) external onlyOwner {
551         payable(receiver).transfer(amount);
552     }
553 
554     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
555         isFeeExempt[holder] = exempt;
556     }
557 
558     function setIsLimitExempt(address holder, bool exempt) external onlyOwner {
559         isLimitExmpt[holder] = exempt;
560     }
561 
562     function setMaxWalletlimit(uint256 _maxWalletAmount) external onlyOwner {
563         maxWalletAmount = _maxWalletAmount;
564     }
565 
566     function removeBots(address account)
567         external
568         onlyOwner
569     {
570         isBot[account] = false;
571     }
572 
573     function setFeesPercent(
574         uint256 _liquidityFee,
575         uint256 _marketingFee,
576         uint256 _devFee,
577         uint256 _feeDenominator
578     ) public onlyOwner {
579         liquidityFeePercent = _liquidityFee;
580         marketingFeePercent = _marketingFee;
581         devFeePercent = _devFee;
582         feeDenominator = _feeDenominator;
583         uint256 totalFeePercent = liquidityFeePercent.add(marketingFeePercent).add(devFeePercent);
584         require(
585             totalFeePercent == feeDenominator,
586             "Must be equal"
587         );
588     }
589 
590     function setFees(
591         uint256 _buyFee,
592         uint256 _sellFee
593     ) public onlyOwner {
594         totalBuyFee = _buyFee;
595         totalSellFee = _sellFee;
596         require(
597             totalSellFee <= feeDenominator.mul(80).div(100) &&
598                 totalBuyFee <= feeDenominator.mul(80).div(100),
599             "Can't be greater than 80%"
600         );
601     }
602 
603     function setFeeReceivers(
604         address _autoLiquidityReceiver,
605         address _marketingFeeReceiver,
606         address _devFeeReceiver
607     ) external onlyOwner {
608         autoLiquidityReceiver = _autoLiquidityReceiver;
609         marketingFeeReceiver = _marketingFeeReceiver;
610         devFeeReceiver = _devFeeReceiver;
611     }
612 
613     function setSwapBackSettings(
614         bool _enabled,
615         uint256 _amount
616     ) external onlyOwner {
617         swapEnabled = _enabled;
618         swapThreshold = _amount;
619     }
620 }