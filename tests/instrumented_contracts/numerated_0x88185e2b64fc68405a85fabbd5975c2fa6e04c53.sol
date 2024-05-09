1 // SPDX-License-Identifier:MIT
2 pragma solidity ^0.8.10;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(
10         address recipient,
11         uint256 amount
12     ) external returns (bool);
13 
14     function allowance(
15         address owner,
16         address spender
17     ) external view returns (uint256);
18 
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 // Dex Factory contract interface
37 interface IDexFactory {
38     function createPair(
39         address tokenA,
40         address tokenB
41     ) external returns (address pair);
42 }
43 
44 // Dex Router contract interface
45 interface IDexRouter {
46     function factory() external pure returns (address);
47 
48     function WETH() external pure returns (address);
49 
50     function addLiquidityETH(
51         address token,
52         uint256 amountTokenDesired,
53         uint256 amountTokenMin,
54         uint256 amountETHMin,
55         address to,
56         uint256 deadline
57     )
58         external
59         payable
60         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
61 
62     function swapExactTokensForETHSupportingFeeOnTransferTokens(
63         uint256 amountIn,
64         uint256 amountOutMin,
65         address[] calldata path,
66         address to,
67         uint256 deadline
68     ) external;
69 }
70 
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address payable) {
73         return payable(msg.sender);
74     }
75 
76     function _msgData() internal view virtual returns (bytes memory) {
77         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
78         return msg.data;
79     }
80 }
81 
82 contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(
86         address indexed previousOwner,
87         address indexed newOwner
88     );
89 
90     constructor() {
91         _owner = _msgSender();
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = payable(address(0));
107     }
108 
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(
111             newOwner != address(0),
112             "Ownable: new owner is the zero address"
113         );
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 contract TotalReburnToken is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121 
122     mapping(address => uint256) private _balances;
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     mapping(address => bool) public isExcludedFromFee;
126     mapping(address => bool) public isExcludedFromMaxTxn;
127     mapping(address => bool) public isExcludedFromMaxHolding;
128     mapping(address => bool) public isBot;
129 
130     string private _name = "Total Reburn";
131     string private _symbol = unicode"TR🔥";
132     uint8 private _decimals = 9;
133     uint256 private _totalSupply = 1_000_000_000 * 1e9;
134 
135     IDexRouter public dexRouter;
136     address public dexPair;
137     address public marketingWallet;
138 
139     uint256 public minTokenToSwap = 100_000 * 1e9; // this amount will trigger swap and distribute
140     uint256 public maxHoldLimit = _totalSupply.div(100); // this is the max wallet holding limit
141     uint256 public maxTxnLimit = _totalSupply.div(100); // this is the max transaction limit
142     uint256 public botFee = 990;
143     uint256 public percentDivider = 1000;
144     uint256 public snipingTime = 0 seconds;
145     uint256 public launchedAt;
146 
147     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
148     bool public feesStatus; // enable by default
149     bool public trading; // once enable can't be disable afterwards
150 
151     uint256 public liquidityFeeOnBuying = 10;
152     uint256 public marketingFeeOnBuying = 0;
153     uint256 public burnFeeOnBuying = 10;
154 
155     uint256 public liquidityFeeOnSelling = 0;
156     uint256 public marketingFeeOnSelling = 10;
157     uint256 public burnFeeOnSelling = 10;
158 
159     uint256 liquidityFeeCounter = 0;
160     uint256 marketingFeeCounter = 0;
161 
162     event SwapAndLiquify(
163         uint256 tokensSwapped,
164         uint256 ethReceived,
165         uint256 tokensIntoLiqudity
166     );
167 
168     constructor() {
169         _balances[owner()] = _totalSupply;
170         marketingWallet = 0xF3BA4226a64CFdf927f407C6CD16635a0d182B67;
171 
172         IDexRouter _dexRouter = IDexRouter(
173             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
174         );
175         // Create a dex pair for this new ERC20
176         address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
177             address(this),
178             _dexRouter.WETH()
179         );
180         dexPair = _dexPair;
181 
182         // set the rest of the contract variables
183         dexRouter = _dexRouter;
184 
185         //exclude owner and this contract from fee
186         isExcludedFromFee[owner()] = true;
187         isExcludedFromFee[address(this)] = true;
188         isExcludedFromFee[address(dexRouter)] = true;
189 
190         //exclude owner and this contract from max Txn
191         isExcludedFromMaxTxn[owner()] = true;
192         isExcludedFromMaxTxn[address(dexRouter)] = true;
193         isExcludedFromMaxTxn[address(this)] = true;
194 
195         //exclude owner and this contract from max hold limit
196         isExcludedFromMaxHolding[owner()] = true;
197         isExcludedFromMaxHolding[address(this)] = true;
198         isExcludedFromMaxHolding[address(dexRouter)] = true;
199         isExcludedFromMaxHolding[dexPair] = true;
200         isExcludedFromMaxHolding[marketingWallet] = true;
201 
202         emit Transfer(address(0), owner(), _totalSupply);
203     }
204 
205     //to receive ETH from dexRouter when swapping
206     receive() external payable {}
207 
208     function name() public view returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public view returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public view returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public view override returns (uint256) {
221         return _totalSupply;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return _balances[account];
226     }
227 
228     function transfer(
229         address recipient,
230         uint256 amount
231     ) public override returns (bool) {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     function allowance(
237         address owner,
238         address spender
239     ) public view override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(
244         address spender,
245         uint256 amount
246     ) public override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(
252         address sender,
253         address recipient,
254         uint256 amount
255     ) public override returns (bool) {
256         _transfer(sender, recipient, amount);
257         _approve(
258             sender,
259             _msgSender(),
260             _allowances[sender][_msgSender()].sub(
261                 amount,
262                 "TR: transfer amount exceeds allowance"
263             )
264         );
265         return true;
266     }
267 
268     function increaseAllowance(
269         address spender,
270         uint256 addedValue
271     ) public virtual returns (bool) {
272         _approve(
273             _msgSender(),
274             spender,
275             _allowances[_msgSender()][spender].add(addedValue)
276         );
277         return true;
278     }
279 
280     function decreaseAllowance(
281         address spender,
282         uint256 subtractedValue
283     ) public virtual returns (bool) {
284         _approve(
285             _msgSender(),
286             spender,
287             _allowances[_msgSender()][spender].sub(
288                 subtractedValue,
289                 "TR: decreased allowance or below zero"
290             )
291         );
292         return true;
293     }
294 
295     function includeOrExcludeFromFee(
296         address account,
297         bool value
298     ) external onlyOwner {
299         isExcludedFromFee[account] = value;
300     }
301 
302     function includeOrExcludeFromMaxTxn(
303         address[] memory account,
304         bool value
305     ) external onlyOwner {
306         for (uint256 i; i < account.length; i++) {
307             isExcludedFromMaxTxn[account[i]] = value;
308         }
309     }
310 
311     function includeOrExcludeFromMaxHolding(
312         address account,
313         bool value
314     ) external onlyOwner {
315         isExcludedFromMaxHolding[account] = value;
316     }
317 
318     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
319         require(_amount > 0, "TR: can't be 0");
320         minTokenToSwap = _amount;
321     }
322 
323     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
324         require(
325             _amount >= _totalSupply.div(percentDivider),
326             "TR: should be greater than 0.1%"
327         );
328         maxHoldLimit = _amount;
329     }
330 
331     function setMaxTxnLimit(uint256 _amount) external onlyOwner {
332         require(
333             _amount >= _totalSupply / percentDivider,
334             "TR: should be greater than 0.1%"
335         );
336         maxTxnLimit = _amount;
337     }
338 
339     function setBuyFeePercent(
340         uint256 _lpFee,
341         uint256 _marketingFee,
342         uint256 _burnFee
343     ) external onlyOwner {
344         marketingFeeOnBuying = _lpFee;
345         liquidityFeeOnBuying = _marketingFee;
346         burnFeeOnBuying = _burnFee;
347         require(
348             _lpFee.add(_marketingFee).add(_burnFee) <=
349                 percentDivider.mul(35).div(100),
350             "TR: can't be more than 35%"
351         );
352     }
353 
354     function setSellFeePercent(
355         uint256 _lpFee,
356         uint256 _marketingFee,
357         uint256 _burnFee
358     ) external onlyOwner {
359         marketingFeeOnSelling = _lpFee;
360         liquidityFeeOnSelling = _marketingFee;
361         burnFeeOnSelling = _burnFee;
362         require(
363             _lpFee.add(_marketingFee).add(_burnFee) <=
364                 percentDivider.mul(35).div(100),
365             "TR: can't be more than 35%"
366         );
367     }
368 
369     function setDistributionStatus(bool _value) public onlyOwner {
370         distributeAndLiquifyStatus = _value;
371     }
372 
373     function enableOrDisableFees(bool _value) external onlyOwner {
374         feesStatus = _value;
375     }
376 
377     function updateAddresses(address _marketingWallet) external onlyOwner {
378         marketingWallet = _marketingWallet;
379     }
380 
381     function RemoveBots(address[] memory accounts) external onlyOwner {
382         for (uint256 i; i < accounts.length; i++) {
383             isBot[accounts[i]] = false;
384         }
385     }
386 
387     function enableTrading() external onlyOwner {
388         require(!trading, "TR: already enabled");
389         trading = true;
390         feesStatus = true;
391         distributeAndLiquifyStatus = true;
392         launchedAt = block.timestamp;
393     }
394 
395     function removeStuckEth(address _receiver) public onlyOwner {
396         payable(_receiver).transfer(address(this).balance);
397     }
398 
399     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
400         uint256 fee = amount
401             .mul(
402                 marketingFeeOnBuying.add(liquidityFeeOnBuying).add(
403                     burnFeeOnBuying
404                 )
405             )
406             .div(percentDivider);
407         return fee;
408     }
409 
410     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
411         uint256 fee = amount
412             .mul(
413                 marketingFeeOnSelling.add(liquidityFeeOnSelling).add(
414                     burnFeeOnSelling
415                 )
416             )
417             .div(percentDivider);
418         return fee;
419     }
420 
421     function _approve(address owner, address spender, uint256 amount) private {
422         require(owner != address(0), "TR: approve from the zero address");
423         require(spender != address(0), "TR: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     function _transfer(address from, address to, uint256 amount) private {
430         require(from != address(0), "TR: transfer from the zero address");
431         require(to != address(0), "TR: transfer to the zero address");
432         require(amount > 0, "TR: Amount must be greater than zero");
433         require(!isBot[from], "Bot detected");
434 
435         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
436             require(amount <= maxTxnLimit, "TR: max txn limit exceeds");
437 
438             // trading disable till launch
439             if (!trading) {
440                 require(
441                     dexPair != from && dexPair != to,
442                     "TR: trading is disable"
443                 );
444             }
445         }
446 
447         if (!isExcludedFromMaxHolding[to]) {
448             require(
449                 balanceOf(to).add(amount) <= maxHoldLimit,
450                 "TR: max hold limit exceeds"
451             );
452         }
453 
454         // swap and liquify
455         distributeAndLiquify(from, to);
456 
457         //indicates if fee should be deducted from transfer
458         bool takeFee = true;
459 
460         //if any account belongs to isExcludedFromFee account then remove the fee
461         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
462             takeFee = false;
463         }
464 
465         //transfer amount, it will take tax, burn, liquidity fee
466         _tokenTransfer(from, to, amount, takeFee);
467     }
468 
469     //this method is responsible for taking all fee, if takeFee is true
470     function _tokenTransfer(
471         address sender,
472         address recipient,
473         uint256 amount,
474         bool takeFee
475     ) private {
476         if (dexPair == sender && takeFee) {
477             uint256 allFee;
478             uint256 tTransferAmount;
479             // antibot
480             if (
481                 block.timestamp < launchedAt + snipingTime &&
482                 sender != address(dexRouter)
483             ) {
484                 allFee = amount.mul(botFee).div(percentDivider);
485                 marketingFeeCounter += allFee;
486                 tTransferAmount = amount.sub(allFee);
487                 _balances[sender] = _balances[sender].sub(
488                     amount,
489                     "TR: insufficient balance"
490                 );
491                 _balances[recipient] = _balances[recipient].add(
492                     tTransferAmount
493                 );
494                 emit Transfer(sender, recipient, tTransferAmount);
495 
496                 _balances[address(this)] = _balances[address(this)].add(allFee);
497                 emit Transfer(sender, address(this), allFee);
498             } else {
499                 allFee = totalBuyFeePerTx(amount);
500                 tTransferAmount = amount.sub(allFee);
501                 setFeeCountersOnBuying(amount);
502 
503                 _balances[sender] = _balances[sender].sub(
504                     amount,
505                     "TR: insufficient balance"
506                 );
507                 _balances[recipient] = _balances[recipient].add(
508                     tTransferAmount
509                 );
510                 emit Transfer(sender, recipient, tTransferAmount);
511 
512                 takeTokenBuyFee(sender, amount);
513             }
514         } else if (dexPair == recipient && takeFee) {
515             uint256 allFee = totalSellFeePerTx(amount);
516             uint256 tTransferAmount = amount.sub(allFee);
517             _balances[sender] = _balances[sender].sub(
518                 amount,
519                 "TR: insufficient balance"
520             );
521             _balances[recipient] = _balances[recipient].add(tTransferAmount);
522             emit Transfer(sender, recipient, tTransferAmount);
523 
524             takeTokenSellFee(sender, amount);
525             setFeeCountersOnSelling(amount);
526         } else {
527             _balances[sender] = _balances[sender].sub(
528                 amount,
529                 "TR: insufficient balance"
530             );
531             _balances[recipient] = _balances[recipient].add(amount);
532             emit Transfer(sender, recipient, amount);
533         }
534     }
535 
536     function takeTokenBuyFee(address sender, uint256 amount) private {
537         if (burnFeeOnBuying > 0) {
538             burn(sender, amount.mul(burnFeeOnBuying).div(percentDivider));
539         }
540         if (liquidityFeeOnBuying > 0) {
541             uint256 fee = amount.mul(liquidityFeeOnBuying).div(percentDivider);
542             _balances[address(this)] = _balances[address(this)].add(fee);
543             emit Transfer(sender, address(this), fee);
544         }
545         if (marketingFeeOnBuying > 0) {
546             uint256 fee = amount.mul(marketingFeeOnBuying).div(percentDivider);
547             _balances[address(this)] = _balances[address(this)].add(fee);
548             emit Transfer(sender, address(this), fee);
549         }
550     }
551 
552     function takeTokenSellFee(address sender, uint256 amount) private {
553         if (burnFeeOnSelling > 0) {
554             burn(sender, amount.mul(burnFeeOnSelling).div(percentDivider));
555         }
556         if (liquidityFeeOnSelling > 0) {
557             uint256 fee = amount.mul(liquidityFeeOnSelling).div(percentDivider);
558             _balances[address(this)] = _balances[address(this)].add(fee);
559             emit Transfer(sender, address(this), fee);
560         }
561         if (marketingFeeOnSelling > 0) {
562             uint256 fee = amount.mul(marketingFeeOnSelling).div(percentDivider);
563             _balances[address(this)] = _balances[address(this)].add(fee);
564             emit Transfer(sender, address(this), fee);
565         }
566     }
567 
568     function setFeeCountersOnBuying(uint256 amount) private {
569         if (liquidityFeeOnBuying > 0) {
570             liquidityFeeCounter += amount.mul(liquidityFeeOnBuying).div(
571                 percentDivider
572             );
573         }
574         if (marketingFeeOnBuying > 0) {
575             marketingFeeCounter += amount.mul(marketingFeeOnBuying).div(
576                 percentDivider
577             );
578         }
579     }
580 
581     function setFeeCountersOnSelling(uint256 amount) private {
582         if (liquidityFeeOnSelling > 0) {
583             liquidityFeeCounter += amount.mul(liquidityFeeOnSelling).div(
584                 percentDivider
585             );
586         }
587         if (marketingFeeOnSelling > 0) {
588             marketingFeeCounter += amount.mul(marketingFeeOnSelling).div(
589                 percentDivider
590             );
591         }
592     }
593 
594     function burn(address account, uint256 amount) private {
595         _totalSupply -= amount;
596 
597         emit Transfer(account, address(0), amount);
598     }
599 
600     function distributeAndLiquify(address from, address to) private {
601         if (liquidityFeeCounter.add(marketingFeeCounter) == 0) return;
602         // is the token balance of this contract address over the min number of
603         // tokens that we need to initiate a swap + liquidity lock?
604         // also, don't get caught in a circular liquidity event.
605         // also, don't swap & liquify if sender is Dex pair.
606         uint256 contractTokenBalance = balanceOf(address(this));
607 
608         bool shouldSell = contractTokenBalance >= minTokenToSwap;
609 
610         if (
611             shouldSell &&
612             from != dexPair &&
613             distributeAndLiquifyStatus &&
614             !(from == address(this) && to == dexPair) // swap 1 time
615         ) {
616             // approve contract
617             _approve(address(this), address(dexRouter), contractTokenBalance);
618 
619             uint256 halfLiquidity = liquidityFeeCounter.div(2);
620             uint256 otherHalfLiquidity = liquidityFeeCounter.sub(halfLiquidity);
621 
622             uint256 tokenAmountToBeSwapped = contractTokenBalance.sub(
623                 otherHalfLiquidity
624             );
625 
626             uint256 balanceBefore = address(this).balance;
627 
628             // now is to lock into liquidty pool
629             Utils.swapTokensForEth(address(dexRouter), tokenAmountToBeSwapped);
630 
631             uint256 deltaBalance = address(this).balance.sub(balanceBefore);
632 
633             uint256 ethToBeAddedToLiquidity = deltaBalance
634                 .mul(halfLiquidity)
635                 .div(tokenAmountToBeSwapped);
636 
637             // add liquidity to Dex
638             if (ethToBeAddedToLiquidity > 0) {
639                 Utils.addLiquidity(
640                     address(dexRouter),
641                     owner(),
642                     otherHalfLiquidity,
643                     ethToBeAddedToLiquidity
644                 );
645 
646                 emit SwapAndLiquify(
647                     halfLiquidity,
648                     ethToBeAddedToLiquidity,
649                     otherHalfLiquidity
650                 );
651             }
652 
653             uint256 ethForMarketing = address(this).balance;
654 
655             // sending Eth to Marketing wallet
656             if (ethForMarketing > 0)
657                 payable(marketingWallet).transfer(ethForMarketing);
658 
659             // Reset all fee counters
660             liquidityFeeCounter = 0;
661             marketingFeeCounter = 0;
662         }
663     }
664 }
665 
666 // Library for doing a swap on Dex
667 library Utils {
668     using SafeMath for uint256;
669 
670     function swapTokensForEth(
671         address routerAddress,
672         uint256 tokenAmount
673     ) internal {
674         IDexRouter dexRouter = IDexRouter(routerAddress);
675 
676         // generate the Dex pair path of token -> weth
677         address[] memory path = new address[](2);
678         path[0] = address(this);
679         path[1] = dexRouter.WETH();
680 
681         // make the swap
682         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
683             tokenAmount,
684             0, // accept any amount of ETH
685             path,
686             address(this),
687             block.timestamp + 300
688         );
689     }
690 
691     function addLiquidity(
692         address routerAddress,
693         address owner,
694         uint256 tokenAmount,
695         uint256 ethAmount
696     ) internal {
697         IDexRouter dexRouter = IDexRouter(routerAddress);
698 
699         // add the liquidity
700         dexRouter.addLiquidityETH{value: ethAmount}(
701             address(this),
702             tokenAmount,
703             0, // slippage is unavoidable
704             0, // slippage is unavoidable
705             owner,
706             block.timestamp + 300
707         );
708     }
709 }
710 
711 library SafeMath {
712     function add(uint256 a, uint256 b) internal pure returns (uint256) {
713         uint256 c = a + b;
714         require(c >= a, "SafeMath: addition overflow");
715 
716         return c;
717     }
718 
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         return sub(a, b, "SafeMath: subtraction overflow");
721     }
722 
723     function sub(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         require(b <= a, errorMessage);
729         uint256 c = a - b;
730 
731         return c;
732     }
733 
734     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
735         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
736         // benefit is lost if 'b' is also tested.
737         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
738         if (a == 0) {
739             return 0;
740         }
741 
742         uint256 c = a * b;
743         require(c / a == b, "SafeMath: multiplication overflow");
744 
745         return c;
746     }
747 
748     function div(uint256 a, uint256 b) internal pure returns (uint256) {
749         return div(a, b, "SafeMath: division by zero");
750     }
751 
752     function div(
753         uint256 a,
754         uint256 b,
755         string memory errorMessage
756     ) internal pure returns (uint256) {
757         require(b > 0, errorMessage);
758         uint256 c = a / b;
759         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
760 
761         return c;
762     }
763 
764     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
765         return mod(a, b, "SafeMath: modulo by zero");
766     }
767 
768     function mod(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         require(b != 0, errorMessage);
774         return a % b;
775     }
776 }