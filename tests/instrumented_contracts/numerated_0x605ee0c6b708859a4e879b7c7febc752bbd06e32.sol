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
121 contract MOOTOKEN is Context, IERC20, Ownable {
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
132     string private _name = "Moo Token";
133     string private _symbol = "MOO";
134     uint8 private _decimals = 9;
135     uint256 private _totalSupply = 100_000_000 * 1e9;
136 
137     address private constant DEAD = address(0xdead);
138     address private constant ZERO = address(0);
139     IDexRouter public dexRouter;
140     address public dexPair;
141     address public marketingWallet;
142     address public NFTRewardWallet;
143     address public liquidityReceiverWallet;
144 
145     uint256 public minTokenToSwap = _totalSupply.div(1e5); // this amount will trigger swap and distribute
146     uint256 public maxHoldLimit = _totalSupply; // this is the max wallet holding limit
147     uint256 public maxTxnLimit = _totalSupply; // this is the max transaction limit
148     uint256 public percentDivider = 1000;
149     uint256 public snipingTime = 0 seconds;
150     uint256 public launchedAt;
151 
152     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
153     bool public feesStatus = true; // enable by default
154     bool public trading; // once enable can't be disable afterwards
155 
156     uint256 public liquidityFeeOnBuying = 20; // 2% will be added to the liquidity
157     uint256 public marketingFeeOnBuying = 20; // 2% will be added to the marketing address
158     uint256 public NFTRewardFeeOnBuying = 20; // 2% will be added to the NFT rewards address
159 
160     uint256 public liquidityFeeOnSelling = 20; // 2% will be added to the liquidity
161     uint256 public marketingFeeOnSelling = 20; // 2% will be added to the marketing address
162     uint256 public NFTRewardFeeOnSelling = 20; // 2% will be added to the NFT rewards address
163 
164     uint256 liquidityFeeCounter = 0;
165     uint256 marketingFeeCounter = 0;
166     uint256 NFTRewardFeeCounter = 0;
167 
168     event SwapAndLiquify(
169         uint256 tokensSwapped,
170         uint256 ethReceived,
171         uint256 tokensIntoLiqudity
172     );
173 
174     constructor() {
175         _balances[owner()] = _totalSupply;
176         liquidityReceiverWallet = address(0);
177         marketingWallet = address(0x712dc56C7d430F6c7914AF856dAfa60f9D709b47);
178         NFTRewardWallet = address(0x21a92874b90e0997aa4D27fA358cF65Da05a2822);
179 
180         IDexRouter _dexRouter = IDexRouter(
181             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
182         );
183         // Create a dex pair for this new ERC20
184         address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
185             address(this),
186             _dexRouter.WETH()
187         );
188         dexPair = _dexPair;
189 
190         // set the rest of the contract variables
191         dexRouter = _dexRouter;
192 
193         //exclude owner and this contract from fee
194         isExcludedFromFee[owner()] = true;
195         isExcludedFromFee[address(this)] = true;
196 
197         //exclude owner and this contract from max Txn
198         isExcludedFromMaxTxn[owner()] = true;
199         isExcludedFromMaxTxn[address(this)] = true;
200 
201         //exclude owner and this contract from max hold limit
202         isExcludedFromMaxHolding[owner()] = true;
203         isExcludedFromMaxHolding[address(this)] = true;
204         isExcludedFromMaxHolding[dexPair] = true;
205         isExcludedFromMaxHolding[marketingWallet] = true;
206         isExcludedFromMaxHolding[NFTRewardWallet] = true;
207 
208         emit Transfer(address(0), owner(), _totalSupply);
209     }
210 
211     //to receive ETH from dexRouter when swapping
212     receive() external payable {}
213 
214     function name() public view returns (string memory) {
215         return _name;
216     }
217 
218     function symbol() public view returns (string memory) {
219         return _symbol;
220     }
221 
222     function decimals() public view returns (uint8) {
223         return _decimals;
224     }
225 
226     function totalSupply() public view override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     function balanceOf(address account) public view override returns (uint256) {
231         return _balances[account];
232     }
233 
234     function transfer(address recipient, uint256 amount)
235         public
236         override
237         returns (bool)
238     {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     function allowance(address owner, address spender)
244         public
245         view
246         override
247         returns (uint256)
248     {
249         return _allowances[owner][spender];
250     }
251 
252     function approve(address spender, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(
268             sender,
269             _msgSender(),
270             _allowances[sender][_msgSender()].sub(
271                 amount,
272                 "Transfer amount exceeds allowance"
273             )
274         );
275         return true;
276     }
277 
278     function increaseAllowance(address spender, uint256 addedValue)
279         public
280         virtual
281         returns (bool)
282     {
283         _approve(
284             _msgSender(),
285             spender,
286             _allowances[_msgSender()][spender].add(addedValue)
287         );
288         return true;
289     }
290 
291     function decreaseAllowance(address spender, uint256 subtractedValue)
292         public
293         virtual
294         returns (bool)
295     {
296         _approve(
297             _msgSender(),
298             spender,
299             _allowances[_msgSender()][spender].sub(
300                 subtractedValue,
301                 "Decreased allowance or below zero"
302             )
303         );
304         return true;
305     }
306 
307     function includeOrExcludeFromFee(address account, bool value)
308         external
309         onlyOwner
310     {
311         isExcludedFromFee[account] = value;
312     }
313 
314     function includeOrExcludeFromMaxTxn(address account, bool value)
315         external
316         onlyOwner
317     {
318         isExcludedFromMaxTxn[account] = value;
319     }
320 
321     function includeOrExcludeFromMaxHolding(address account, bool value)
322         external
323         onlyOwner
324     {
325         isExcludedFromMaxHolding[account] = value;
326     }
327 
328     function removeBots(address account)
329         external
330         onlyOwner
331     {
332         isBot[account] = false;
333     }
334 
335     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
336         require(_amount > 0,"Can't be 0");
337         minTokenToSwap = _amount;
338     }
339 
340     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
341         maxHoldLimit = _amount;
342     }
343 
344     function setMaxTxnLimit(uint256 _amount) external onlyOwner {
345         maxTxnLimit = _amount;
346     }
347 
348     function setBuyFeePercent(uint256 _lwFee, uint256 _marketingFee, uint256 _NFTRewardFee)
349         external
350         onlyOwner
351     {
352         marketingFeeOnBuying = _lwFee;
353         NFTRewardFeeOnBuying = _NFTRewardFee;
354         liquidityFeeOnBuying = _marketingFee;
355         require(
356             _lwFee.add(_marketingFee).add(_NFTRewardFee) <= percentDivider.div(10),
357             "Can't be more than 10%"
358         );
359     }
360 
361     function setSellFeePercent(uint256 _lwFee, uint256 _marketingFee, uint256 _NFTRewardFee)
362         external
363         onlyOwner
364     {
365         marketingFeeOnSelling = _lwFee;
366         NFTRewardFeeOnSelling = _NFTRewardFee;
367         liquidityFeeOnSelling = _marketingFee;
368         require(
369             _lwFee.add(_marketingFee).add(_NFTRewardFee) <= percentDivider.div(10),
370             "Can't be more than 10%"
371         );
372     }
373 
374     function setDistributionStatus(bool _value) public onlyOwner {
375         distributeAndLiquifyStatus = _value;
376     }
377 
378     function enableOrDisableFees(bool _value) external onlyOwner {
379         feesStatus = _value;
380     }
381 
382     function removeStuckEth(address _receiver) public onlyOwner {
383         payable(_receiver).transfer(address(this).balance);
384     }
385 
386     function updateAddresses(address _marketingWallet, address _NFTRewardWallet, address _liquidityReceiverWallet) external onlyOwner {
387         marketingWallet = _marketingWallet;
388         NFTRewardWallet = _NFTRewardWallet;
389         liquidityReceiverWallet = _liquidityReceiverWallet;
390     }
391 
392     function enableTrading() external onlyOwner {
393         require(!trading, "Already enabled");
394         trading = true;
395         feesStatus = true;
396         distributeAndLiquifyStatus = true;
397         launchedAt = block.timestamp;
398     }
399 
400     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
401         uint256 fee = amount.mul(marketingFeeOnBuying.add(liquidityFeeOnBuying).add(NFTRewardFeeOnBuying)).div(
402             percentDivider
403         );
404         return fee;
405     }
406 
407     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
408         uint256 fee = amount
409             .mul(marketingFeeOnSelling.add(liquidityFeeOnSelling).add(NFTRewardFeeOnSelling))
410             .div(percentDivider);
411         return fee;
412     }
413 
414     function _approve(
415         address owner,
416         address spender,
417         uint256 amount
418     ) private {
419         require(owner != address(0), "Approve from the zero address");
420         require(spender != address(0), "Approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     function _transfer(
427         address from,
428         address to,
429         uint256 amount
430     ) private {
431         require(from != address(0), "Transfer from the zero address");
432         require(to != address(0), "Transfer to the zero address");
433         require(amount > 0, "Amount must be greater than zero");
434         require(!isBot[from], "Bot detected");
435 
436         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
437             require(amount <= maxTxnLimit, "Max txn limit exceeds");
438 
439             // trading disable till launch
440             if (!trading) {
441                 require(
442                     dexPair != from && dexPair != to,
443                     "Trading is disabled"
444                 );
445             }
446             // antibot
447             if (
448                 block.timestamp < launchedAt + snipingTime &&
449                 from != address(dexRouter)
450             ) {
451                 if (dexPair == from) {
452                     isBot[to] = true;
453                 } else if (dexPair == to) {
454                     isBot[from] = true;
455                 }
456             }
457         }
458 
459         if (!isExcludedFromMaxHolding[to]) {
460             require(
461                 balanceOf(to).add(amount) <= maxHoldLimit,
462                 "Max hold limit exceeds"
463             );
464         }
465 
466         // swap and liquify
467         distributeAndLiquify(from, to);
468 
469         //indicates if fee should be deducted from transfer
470         bool takeFee = true;
471 
472         //if any account belongs to isExcludedFromFee account then remove the fee
473         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
474             takeFee = false;
475         }
476 
477         //transfer amount, it will take tax, burn, liquidity fee
478         _tokenTransfer(from, to, amount, takeFee);
479     }
480 
481     //this method is responsible for taking all fee, if takeFee is true
482     function _tokenTransfer(
483         address sender,
484         address recipient,
485         uint256 amount,
486         bool takeFee
487     ) private {
488         if (dexPair == sender && takeFee) {
489             uint256 allFee = totalBuyFeePerTx(amount);
490             uint256 tTransferAmount = amount.sub(allFee);
491             _balances[sender] = _balances[sender].sub(amount,"Insufficient balance");
492             _balances[recipient] = _balances[recipient].add(tTransferAmount);
493 
494             emit Transfer(sender, recipient, tTransferAmount);
495             takeTokenFee(sender, allFee);
496             setFeeCountersOnBuying(amount);
497         } else if (dexPair == recipient && takeFee) {
498             uint256 allFee = totalSellFeePerTx(amount);
499             uint256 tTransferAmount = amount.sub(allFee);
500             _balances[sender] = _balances[sender].sub(amount,"Insufficient balance");
501             _balances[recipient] = _balances[recipient].add(tTransferAmount);
502 
503             emit Transfer(sender, recipient, tTransferAmount);
504             takeTokenFee(sender, allFee);
505             setFeeCountersOnSelling(amount);
506         } else {
507             _balances[sender] = _balances[sender].sub(amount,"Insufficient balance");
508             _balances[recipient] = _balances[recipient].add(amount);
509 
510             emit Transfer(sender, recipient, amount);
511         }
512     }
513 
514     function takeTokenFee(address sender, uint256 amount) private {
515         _balances[address(this)] = _balances[address(this)].add(amount);
516 
517         emit Transfer(sender, address(this), amount);
518     }
519 
520     function setFeeCountersOnBuying(uint256 amount) private {
521         liquidityFeeCounter += amount.mul(liquidityFeeOnBuying).div(
522             percentDivider
523         );
524         marketingFeeCounter += amount.mul(marketingFeeOnBuying).div(percentDivider);
525         NFTRewardFeeCounter += amount.mul(NFTRewardFeeOnBuying).div(percentDivider);
526     }
527 
528     function setFeeCountersOnSelling(uint256 amount) private {
529         liquidityFeeCounter += amount.mul(liquidityFeeOnSelling).div(
530             percentDivider
531         );
532         marketingFeeCounter += amount.mul(marketingFeeOnSelling).div(percentDivider);
533         NFTRewardFeeCounter += amount.mul(NFTRewardFeeOnSelling).div(percentDivider);
534     }
535 
536     function distributeAndLiquify(address from, address to) private {
537         // is the token balance of this contract address over the min number of
538         // tokens that we need to initiate a swap + liquidity lock?
539         // also, don't get caught in a circular liquidity event.
540         // also, don't swap & liquify if sender is Dex pair.
541         uint256 contractTokenBalance = balanceOf(address(this));
542 
543         bool shouldSell = contractTokenBalance >= minTokenToSwap;
544 
545         if (
546             shouldSell &&
547             from != dexPair &&
548             distributeAndLiquifyStatus &&
549             !(from == address(this) && to == address(dexPair)) // swap 1 time
550         ) {
551             // approve contract
552             _approve(address(this), address(dexRouter), contractTokenBalance);
553 
554             uint256 halfLiquidity = liquidityFeeCounter.div(2);
555             uint256 otherHalfLiquidity = liquidityFeeCounter.sub(halfLiquidity);
556 
557             uint256 tokenAmountToBeSwapped = contractTokenBalance.sub(
558                 otherHalfLiquidity
559             );
560 
561             uint256 balanceBefore = address(this).balance;
562 
563             // now is to lock into liquidty pool
564             Utils.swapTokensForEth(address(dexRouter), tokenAmountToBeSwapped);
565 
566             uint256 deltaBalance = address(this).balance.sub(balanceBefore);
567             uint256 ethToBeAddedToLiquidity = deltaBalance
568                 .mul(halfLiquidity)
569                 .div(tokenAmountToBeSwapped);
570             uint256 ethFormarketing = deltaBalance.mul(marketingFeeCounter).div(
571                 tokenAmountToBeSwapped
572             );
573             uint256 ethForNFTReward = deltaBalance.sub(ethToBeAddedToLiquidity).sub(
574                 ethFormarketing
575             );
576 
577             // add liquidity to Dex
578             if (ethToBeAddedToLiquidity > 0) {
579                 Utils.addLiquidity(
580                     address(dexRouter),
581                     liquidityReceiverWallet,
582                     otherHalfLiquidity,
583                     ethToBeAddedToLiquidity
584                 );
585 
586                 emit SwapAndLiquify(
587                     halfLiquidity,
588                     ethToBeAddedToLiquidity,
589                     otherHalfLiquidity
590                 );
591             }
592 
593             // sending eth to marketing wallet
594             if (ethFormarketing > 0) payable(marketingWallet).transfer(ethFormarketing);
595 
596             // sending eth to NFT rewards wallet
597             if (ethForNFTReward > 0) payable(NFTRewardWallet).transfer(ethForNFTReward);
598 
599             // Reset all fee counters
600             liquidityFeeCounter = 0;
601             marketingFeeCounter = 0;
602             NFTRewardFeeCounter = 0;
603         }
604     }
605 }
606 
607 // Library for doing a swap on Dex
608 library Utils {
609     using SafeMath for uint256;
610 
611     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
612         internal
613     {
614         IDexRouter dexRouter = IDexRouter(routerAddress);
615 
616         // generate the Dex pair path of token -> weth
617         address[] memory path = new address[](2);
618         path[0] = address(this);
619         path[1] = dexRouter.WETH();
620 
621         // make the swap
622         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
623             tokenAmount,
624             0, // accept any amount of ETH
625             path,
626             address(this),
627             block.timestamp + 300
628         );
629     }
630 
631     function addLiquidity(
632         address routerAddress,
633         address owner,
634         uint256 tokenAmount,
635         uint256 ethAmount
636     ) internal {
637         IDexRouter dexRouter = IDexRouter(routerAddress);
638 
639         // add the liquidity
640         dexRouter.addLiquidityETH{value: ethAmount}(
641             address(this),
642             tokenAmount,
643             0, // slippage is unavoidable
644             0, // slippage is unavoidable
645             owner,
646             block.timestamp + 300
647         );
648     }
649 }
650 
651 library SafeMath {
652     function add(uint256 a, uint256 b) internal pure returns (uint256) {
653         uint256 c = a + b;
654         require(c >= a, "SafeMath: addition overflow");
655 
656         return c;
657     }
658 
659     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
660         return sub(a, b, "SafeMath: subtraction overflow");
661     }
662 
663     function sub(
664         uint256 a,
665         uint256 b,
666         string memory errorMessage
667     ) internal pure returns (uint256) {
668         require(b <= a, errorMessage);
669         uint256 c = a - b;
670 
671         return c;
672     }
673 
674     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
675         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
676         // benefit is lost if 'b' is also tested.
677         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
678         if (a == 0) {
679             return 0;
680         }
681 
682         uint256 c = a * b;
683         require(c / a == b, "SafeMath: multiplication overflow");
684 
685         return c;
686     }
687 
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         return div(a, b, "SafeMath: division by zero");
690     }
691 
692     function div(
693         uint256 a,
694         uint256 b,
695         string memory errorMessage
696     ) internal pure returns (uint256) {
697         require(b > 0, errorMessage);
698         uint256 c = a / b;
699         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
700 
701         return c;
702     }
703 
704     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
705         return mod(a, b, "SafeMath: modulo by zero");
706     }
707 
708     function mod(
709         uint256 a,
710         uint256 b,
711         string memory errorMessage
712     ) internal pure returns (uint256) {
713         require(b != 0, errorMessage);
714         return a % b;
715     }
716 }