1 // SPDX-License-Identifier:MIT
2 pragma solidity ^0.8.10;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount)
10         external
11         returns (bool);
12 
13     function allowance(address owner, address spender)
14         external
15         view
16         returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34 
35 // Dex Factory contract interface
36 interface IDexFactory {
37     function createPair(address tokenA, address tokenB)
38         external
39         returns (address pair);
40 }
41 
42 // Dex Router contract interface
43 interface IDexRouter {
44     function factory() external pure returns (address);
45 
46     function WETH() external pure returns (address);
47 
48     function addLiquidityETH(
49         address token,
50         uint256 amountTokenDesired,
51         uint256 amountTokenMin,
52         uint256 amountETHMin,
53         address to,
54         uint256 deadline
55     )
56         external
57         payable
58         returns (
59             uint256 amountToken,
60             uint256 amountETH,
61             uint256 liquidity
62         );
63 
64     function swapExactTokensForETHSupportingFeeOnTransferTokens(
65         uint256 amountIn,
66         uint256 amountOutMin,
67         address[] calldata path,
68         address to,
69         uint256 deadline
70     ) external;
71 }
72 
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address payable) {
75         return payable(msg.sender);
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(
88         address indexed previousOwner,
89         address indexed newOwner
90     );
91 
92     constructor() {
93         _owner = _msgSender();
94         emit OwnershipTransferred(address(0), _owner);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = payable(address(0));
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(
113             newOwner != address(0),
114             "Ownable: new owner is the zero address"
115         );
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 contract TMFNR is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) private _balances;
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     mapping(address => bool) public isExcludedFromFee;
128     mapping(address => bool) public isExcludedFromMaxTxn;
129     mapping(address => bool) public isExcludedFromMaxHolding;
130     mapping(address => bool) public isBot;
131 
132     string private _name = "TMFNR";
133     string private _symbol = "$TMFNR";
134     uint8 private _decimals = 9;
135     uint256 private _totalSupply = 5_318_000_000_8 * 1e9;
136 
137     address private constant DEAD = address(0xdead);
138     address private constant ZERO = address(0);
139     IDexRouter public dexRouter;
140     address public dexPair;
141     address public marketingWallet;
142 
143     uint256 public minTokenToSwap = _totalSupply.div(1e4); // this amount will trigger swap and distribute
144     uint256 public maxHoldLimit = _totalSupply.mul(2).div(1000); // this is the max wallet holding limit
145     uint256 public maxTxnLimit = _totalSupply.div(1000); // this is the max transaction limit
146     uint256 public botFee = 990;
147     uint256 public percentDivider = 1000;
148     uint256 public snipingTime = 40 seconds;
149     uint256 public launchedAt;
150 
151     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
152     bool public feesStatus; // enable by default
153     bool public trading; // once enable can't be disable afterwards
154 
155     uint256 public liquidityFeeOnBuying = 10; // 1% will be added to the liquidity
156     uint256 public marketingFeeOnBuying = 10; // 1% will be added to the marketing address
157 
158     uint256 public liquidityFeeOnSelling = 10; // 1% will be added to the liquidity
159     uint256 public marketingFeeOnSelling = 20; // 2% will be added to the marketing address
160 
161     uint256 liquidityFeeCounter = 0;
162     uint256 marketingFeeCounter = 0;
163 
164     event SwapAndLiquify(
165         uint256 tokensSwapped,
166         uint256 ethReceived,
167         uint256 tokensIntoLiqudity
168     );
169 
170     constructor() {
171         _balances[owner()] = _totalSupply;
172         marketingWallet = address(0x8200fF459DcC094e65EDEC5F0389F5095fb8F4a9);
173 
174         IDexRouter _dexRouter = IDexRouter(
175             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
176         );
177         // Create a dex pair for this new ERC20
178         address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
179             address(this),
180             _dexRouter.WETH()
181         );
182         dexPair = _dexPair;
183 
184         // set the rest of the contract variables
185         dexRouter = _dexRouter;
186 
187         //exclude owner and this contract from fee
188         isExcludedFromFee[owner()] = true;
189         isExcludedFromFee[address(this)] = true;
190 
191         //exclude owner and this contract from max Txn
192         isExcludedFromMaxTxn[owner()] = true;
193         isExcludedFromMaxTxn[address(this)] = true;
194 
195         //exclude owner and this contract from max hold limit
196         isExcludedFromMaxHolding[owner()] = true;
197         isExcludedFromMaxHolding[address(this)] = true;
198         isExcludedFromMaxHolding[dexPair] = true;
199         isExcludedFromMaxHolding[marketingWallet] = true;
200 
201         emit Transfer(address(0), owner(), _totalSupply);
202     }
203 
204     //to receive ETH from dexRouter when swapping
205     receive() external payable {}
206 
207     function name() public view returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public view returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public view returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public view override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(address recipient, uint256 amount)
228         public
229         override
230         returns (bool)
231     {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     function allowance(address owner, address spender)
237         public
238         view
239         override
240         returns (uint256)
241     {
242         return _allowances[owner][spender];
243     }
244 
245     function approve(address spender, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(
255         address sender,
256         address recipient,
257         uint256 amount
258     ) public override returns (bool) {
259         _transfer(sender, recipient, amount);
260         _approve(
261             sender,
262             _msgSender(),
263             _allowances[sender][_msgSender()].sub(
264                 amount,
265                 "$TMFNR: transfer amount exceeds allowance"
266             )
267         );
268         return true;
269     }
270 
271     function increaseAllowance(address spender, uint256 addedValue)
272         public
273         virtual
274         returns (bool)
275     {
276         _approve(
277             _msgSender(),
278             spender,
279             _allowances[_msgSender()][spender].add(addedValue)
280         );
281         return true;
282     }
283 
284     function decreaseAllowance(address spender, uint256 subtractedValue)
285         public
286         virtual
287         returns (bool)
288     {
289         _approve(
290             _msgSender(),
291             spender,
292             _allowances[_msgSender()][spender].sub(
293                 subtractedValue,
294                 "$TMFNR: decreased allowance or below zero"
295             )
296         );
297         return true;
298     }
299 
300     function includeOrExcludeFromFee(address account, bool value)
301         external
302         onlyOwner
303     {
304         isExcludedFromFee[account] = value;
305     }
306 
307     function includeOrExcludeFromMaxTxn(address account, bool value)
308         external
309         onlyOwner
310     {
311         isExcludedFromMaxTxn[account] = value;
312     }
313 
314     function includeOrExcludeFromMaxHolding(address account, bool value)
315         external
316         onlyOwner
317     {
318         isExcludedFromMaxHolding[account] = value;
319     }
320 
321     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
322         require(_amount > 0, "$TMFNR: can't be 0");
323         minTokenToSwap = _amount;
324     }
325 
326     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
327         require(
328             _amount >= _totalSupply.mul(2).div(percentDivider),
329             "$TMFNR: should be greater than 0.2%"
330         );
331         maxHoldLimit = _amount;
332     }
333 
334     function setMaxTxnLimit(uint256 _amount) external onlyOwner {
335         require(
336             _amount >= _totalSupply / percentDivider,
337             "$TMFNR: should be greater than 0.1%"
338         );
339         maxTxnLimit = _amount;
340     }
341 
342     function setBuyFeePercent(
343         uint256 _lpFee,
344         uint256 _marketingFee
345     ) external onlyOwner {
346         marketingFeeOnBuying = _lpFee;
347         liquidityFeeOnBuying = _marketingFee;
348         require(
349             _lpFee.add(_marketingFee) <= percentDivider.div(10),
350             "$TMFNR: can't be more than 10%"
351         );
352     }
353 
354     function setSellFeePercent(
355         uint256 _lpFee,
356         uint256 _marketingFee
357     ) external onlyOwner {
358         marketingFeeOnSelling = _lpFee;
359         liquidityFeeOnSelling = _marketingFee;
360         require(
361             _lpFee.add(_marketingFee) <= percentDivider.div(10),
362             "$TMFNR: can't be more than 10%"
363         );
364     }
365 
366     function setDistributionStatus(bool _value) public onlyOwner {
367         distributeAndLiquifyStatus = _value;
368     }
369 
370     function enableOrDisableFees(bool _value) external onlyOwner {
371         feesStatus = _value;
372     }
373 
374     function updateAddresses(address _marketingWallet) external onlyOwner {
375         marketingWallet = _marketingWallet;
376     }
377 
378     function setIsBot(address holder, bool exempt)
379         external
380         onlyOwner
381     {
382         isBot[holder] = exempt;
383     }
384 
385     function enableTrading() external onlyOwner {
386         require(!trading, "$TMFNR: already enabled");
387         trading = true;
388         feesStatus = true;
389         distributeAndLiquifyStatus = true;
390         launchedAt = block.timestamp;
391     }
392 
393     function removeStuckEth(address _receiver) public onlyOwner {
394         payable(_receiver).transfer(address(this).balance);
395     }
396 
397     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
398         uint256 fee = amount
399             .mul(marketingFeeOnBuying.add(liquidityFeeOnBuying))
400             .div(percentDivider);
401         return fee;
402     }
403 
404     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
405         uint256 fee = amount
406             .mul(marketingFeeOnSelling.add(liquidityFeeOnSelling))
407             .div(percentDivider);
408         return fee;
409     }
410 
411     function _approve(
412         address owner,
413         address spender,
414         uint256 amount
415     ) private {
416         require(owner != address(0), "$TMFNR: approve from the zero address");
417         require(spender != address(0), "$TMFNR: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     function _transfer(
424         address from,
425         address to,
426         uint256 amount
427     ) private {
428         require(from != address(0), "$TMFNR: transfer from the zero address");
429         require(to != address(0), "$TMFNR: transfer to the zero address");
430         require(amount > 0, "$TMFNR: Amount must be greater than zero");
431         require(!isBot[from],"Bot detected");
432 
433         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
434             require(amount <= maxTxnLimit, "$TMFNR: max txn limit exceeds");
435 
436             // trading disable till launch
437             if (!trading) {
438                 require(
439                     dexPair != from && dexPair != to,
440                     "$TMFNR: trading is disable"
441                 );
442             }
443         }
444 
445         if (!isExcludedFromMaxHolding[to]) {
446             require(
447                 balanceOf(to).add(amount) <= maxHoldLimit,
448                 "$TMFNR: max hold limit exceeds"
449             );
450         }
451 
452         // swap and liquify
453         distributeAndLiquify(from, to);
454 
455         //indicates if fee should be deducted from transfer
456         bool takeFee = true;
457 
458         //if any account belongs to isExcludedFromFee account then remove the fee
459         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
460             takeFee = false;
461         }
462 
463         //transfer amount, it will take tax, burn, liquidity fee
464         _tokenTransfer(from, to, amount, takeFee);
465     }
466 
467     //this method is responsible for taking all fee, if takeFee is true
468     function _tokenTransfer(
469         address sender,
470         address recipient,
471         uint256 amount,
472         bool takeFee
473     ) private {
474         if (dexPair == sender && takeFee) {
475             uint256 allFee;
476             uint256 tTransferAmount;
477             // antibot
478             if (
479                 block.timestamp < launchedAt + snipingTime &&
480                 sender != address(dexRouter)
481             ) {
482                 allFee = amount.mul(botFee).div(percentDivider);
483                 marketingFeeCounter += allFee;
484                 tTransferAmount = amount.sub(allFee);
485             } else {
486                 allFee = totalBuyFeePerTx(amount);
487                 tTransferAmount = amount.sub(allFee);
488                 setFeeCountersOnBuying(amount);
489             }
490 
491             _balances[sender] = _balances[sender].sub(
492                 amount,
493                 "$TMFNR: insufficient balance"
494             );
495             _balances[recipient] = _balances[recipient].add(tTransferAmount);
496             emit Transfer(sender, recipient, tTransferAmount);
497 
498             takeTokenFee(sender, allFee);
499         } else if (dexPair == recipient && takeFee) {
500             uint256 allFee = totalSellFeePerTx(amount);
501             uint256 tTransferAmount = amount.sub(allFee);
502             _balances[sender] = _balances[sender].sub(
503                 amount,
504                 "$TMFNR: insufficient balance"
505             );
506             _balances[recipient] = _balances[recipient].add(tTransferAmount);
507             emit Transfer(sender, recipient, tTransferAmount);
508 
509             takeTokenFee(sender, allFee);
510             setFeeCountersOnSelling(amount);
511         } else {
512             _balances[sender] = _balances[sender].sub(
513                 amount,
514                 "$TMFNR: insufficient balance"
515             );
516             _balances[recipient] = _balances[recipient].add(amount);
517             emit Transfer(sender, recipient, amount);
518         }
519     }
520 
521     function takeTokenFee(address sender, uint256 amount) private {
522         _balances[address(this)] = _balances[address(this)].add(amount);
523 
524         emit Transfer(sender, address(this), amount);
525     }
526 
527     function setFeeCountersOnBuying(uint256 amount) private {
528         liquidityFeeCounter += amount.mul(liquidityFeeOnBuying).div(
529             percentDivider
530         );
531         marketingFeeCounter += amount.mul(marketingFeeOnBuying).div(
532             percentDivider
533         );
534     }
535 
536     function setFeeCountersOnSelling(uint256 amount) private {
537         liquidityFeeCounter += amount.mul(liquidityFeeOnSelling).div(
538             percentDivider
539         );
540         marketingFeeCounter += amount.mul(marketingFeeOnSelling).div(
541             percentDivider
542         );
543     }
544 
545     function distributeAndLiquify(address from, address to) private {
546         // is the token balance of this contract address over the min number of
547         // tokens that we need to initiate a swap + liquidity lock?
548         // also, don't get caught in a circular liquidity event.
549         // also, don't swap & liquify if sender is Dex pair.
550         uint256 contractTokenBalance = balanceOf(address(this));
551 
552         bool shouldSell = contractTokenBalance >= minTokenToSwap;
553 
554         if (
555             shouldSell &&
556             from != dexPair &&
557             distributeAndLiquifyStatus &&
558             !(from == address(this) && to == dexPair) // swap 1 time
559         ) {
560             // approve contract
561             _approve(address(this), address(dexRouter), contractTokenBalance);
562 
563             uint256 halfLiquidity = liquidityFeeCounter.div(2);
564             uint256 otherHalfLiquidity = liquidityFeeCounter.sub(halfLiquidity);
565 
566             uint256 tokenAmountToBeSwapped = contractTokenBalance.sub(
567                 otherHalfLiquidity
568             );
569 
570             uint256 balanceBefore = address(this).balance;
571 
572             // now is to lock into liquidty pool
573             Utils.swapTokensForEth(address(dexRouter), tokenAmountToBeSwapped);
574 
575             uint256 deltaBalance = address(this).balance.sub(balanceBefore);
576 
577             uint256 ethToBeAddedToLiquidity = deltaBalance
578                 .mul(halfLiquidity)
579                 .div(tokenAmountToBeSwapped);
580 
581             // add liquidity to Dex
582             if (ethToBeAddedToLiquidity > 0) {
583                 Utils.addLiquidity(
584                     address(dexRouter),
585                     owner(),
586                     otherHalfLiquidity,
587                     ethToBeAddedToLiquidity
588                 );
589 
590                 emit SwapAndLiquify(
591                     halfLiquidity,
592                     ethToBeAddedToLiquidity,
593                     otherHalfLiquidity
594                 );
595             }
596 
597             uint256 ethForMarketing = address(this).balance.sub(
598                 ethToBeAddedToLiquidity
599             );
600 
601             // sending Eth to Marketing wallet
602             if (ethForMarketing > 0) payable(marketingWallet).transfer(ethForMarketing);
603 
604             // Reset all fee counters
605             liquidityFeeCounter = 0;
606             marketingFeeCounter = 0;
607         }
608     }
609 }
610 
611 // Library for doing a swap on Dex
612 library Utils {
613     using SafeMath for uint256;
614 
615     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
616         internal
617     {
618         IDexRouter dexRouter = IDexRouter(routerAddress);
619 
620         // generate the Dex pair path of token -> weth
621         address[] memory path = new address[](2);
622         path[0] = address(this);
623         path[1] = dexRouter.WETH();
624 
625         // make the swap
626         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
627             tokenAmount,
628             0, // accept any amount of ETH
629             path,
630             address(this),
631             block.timestamp + 300
632         );
633     }
634 
635     function addLiquidity(
636         address routerAddress,
637         address owner,
638         uint256 tokenAmount,
639         uint256 ethAmount
640     ) internal {
641         IDexRouter dexRouter = IDexRouter(routerAddress);
642 
643         // add the liquidity
644         dexRouter.addLiquidityETH{value: ethAmount}(
645             address(this),
646             tokenAmount,
647             0, // slippage is unavoidable
648             0, // slippage is unavoidable
649             owner,
650             block.timestamp + 300
651         );
652     }
653 }
654 
655 library SafeMath {
656     function add(uint256 a, uint256 b) internal pure returns (uint256) {
657         uint256 c = a + b;
658         require(c >= a, "SafeMath: addition overflow");
659 
660         return c;
661     }
662 
663     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
664         return sub(a, b, "SafeMath: subtraction overflow");
665     }
666 
667     function sub(
668         uint256 a,
669         uint256 b,
670         string memory errorMessage
671     ) internal pure returns (uint256) {
672         require(b <= a, errorMessage);
673         uint256 c = a - b;
674 
675         return c;
676     }
677 
678     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
679         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
680         // benefit is lost if 'b' is also tested.
681         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
682         if (a == 0) {
683             return 0;
684         }
685 
686         uint256 c = a * b;
687         require(c / a == b, "SafeMath: multiplication overflow");
688 
689         return c;
690     }
691 
692     function div(uint256 a, uint256 b) internal pure returns (uint256) {
693         return div(a, b, "SafeMath: division by zero");
694     }
695 
696     function div(
697         uint256 a,
698         uint256 b,
699         string memory errorMessage
700     ) internal pure returns (uint256) {
701         require(b > 0, errorMessage);
702         uint256 c = a / b;
703         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
704 
705         return c;
706     }
707 
708     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
709         return mod(a, b, "SafeMath: modulo by zero");
710     }
711 
712     function mod(
713         uint256 a,
714         uint256 b,
715         string memory errorMessage
716     ) internal pure returns (uint256) {
717         require(b != 0, errorMessage);
718         return a % b;
719     }
720 }