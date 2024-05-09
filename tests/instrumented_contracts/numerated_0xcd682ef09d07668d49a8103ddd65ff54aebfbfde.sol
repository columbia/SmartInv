1 //SPDX-License-Identifier: MIT
2 
3 /**
4  * Contract: Surge Token
5  * Developed by: Heisenman
6  * Team: t.me/ALBINO_RHINOOO, t.me/Heisenman, t.me/STFGNZ
7  * Trade without dex fees. $SURGE is the inception of the next generation of decentralized protocols.
8  * Socials:
9  * TG: https://t.me/SURGEPROTOCOL
10  * Website: https://surgeprotocol.io/
11  * Twitter: https://twitter.com/SURGEPROTOCOL
12  */
13 
14 pragma solidity 0.8.17;
15 
16 abstract contract ReentrancyGuard {
17     uint256 private constant _NOT_ENTERED = 1;
18     uint256 private constant _ENTERED = 2;
19     uint256 private _status;
20 
21     constructor() {
22         _status = _NOT_ENTERED;
23     }
24 
25     modifier nonReentrant() {
26         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
27         _status = _ENTERED;
28         _;
29         _status = _NOT_ENTERED;
30     }
31 }
32 
33 interface IPancakePair {
34     function token0() external view returns (address);
35 
36     function token1() external view returns (address);
37 
38     function getReserves()
39         external
40         view
41         returns (
42             uint112 reserve0,
43             uint112 reserve1,
44             uint32 blockTimestampLast
45         );
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address account) external view returns (uint256);
52 
53     function transfer(address recipient, uint256 amount)
54         external
55         returns (bool);
56 
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(
72         address indexed owner,
73         address indexed spender,
74         uint256 value
75     );
76 
77     function decimals() external view returns (uint8);
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address payable) {
82         return payable(msg.sender);
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(
90         address indexed previousOwner,
91         address indexed newOwner
92     );
93 
94     constructor() {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(
116             newOwner != address(0),
117             "Ownable: new owner is the zero address"
118         );
119         emit OwnershipTransferred(_owner, newOwner);
120         _owner = newOwner;
121     }
122 }
123 
124 contract SURGE is IERC20, Context, Ownable, ReentrancyGuard {
125     event Bought(
126         address indexed from,
127         address indexed to,
128         uint256 tokens,
129         uint256 beans,
130         uint256 dollarBuy
131     );
132     event Sold(
133         address indexed from,
134         address indexed to,
135         uint256 tokens,
136         uint256 beans,
137         uint256 dollarSell
138     );
139     event FeesMulChanged(uint256 newBuyMul, uint256 newSellMul);
140     event StablePairChanged(address newStablePair, address newStableToken);
141     event MaxBagChanged(uint256 newMaxBag);
142 
143     // token data
144     string private constant _name = "SURGE";
145     string private constant _symbol = "SRG";
146     uint8 private constant _decimals = 9;
147     uint256 private constant _decMultiplier = 10**_decimals;
148 
149     // Total Supply
150     uint256 public constant _totalSupply = 10**8 * _decMultiplier;
151 
152     // balances
153     mapping(address => uint256) public _balances;
154     mapping(address => mapping(address => uint256)) internal _allowances;
155 
156     //Fees
157     mapping(address => bool) public isFeeExempt;
158     uint256 public sellMul = 95;
159     uint256 public buyMul = 95;
160     uint256 public constant DIVISOR = 100;
161 
162     //Max bag requirements
163     mapping(address => bool) public isTxLimitExempt;
164     uint256 public maxBag = _totalSupply / 100;
165 
166     //Tax collection
167     uint256 public taxBalance = 0;
168 
169     //Tax wallets
170     address public teamWallet = 0xDa17D158bC42f9C29E626b836d9231bB173bab06;
171     address public treasuryWallet = 0xF526A924c406D31d16a844FF04810b79E71804Ef;
172 
173     // Tax Split
174     uint256 public teamShare = 40;
175     uint256 public treasuryShare = 60;
176     uint256 public constant SHAREDIVISOR = 100;
177 
178     //Known Wallets
179     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
180 
181     //trading parameters
182     uint256 public liquidity = 4 ether;
183     uint256 public liqConst = liquidity * _totalSupply;
184     uint256 public constant TRADE_OPEN_TIME = 1673544600;
185 
186     //volume trackers
187     mapping(address => uint256) public indVol;
188     mapping(uint256 => uint256) public tVol;
189     uint256 public totalVolume = 0;
190 
191     //candlestick data
192     uint256 public totalTx;
193     mapping(uint256 => uint256) public txTimeStamp;
194 
195     struct candleStick {
196         uint256 time;
197         uint256 open;
198         uint256 close;
199         uint256 high;
200         uint256 low;
201     }
202 
203     mapping(uint256 => candleStick) public candleStickData;
204 
205     //Frontrun Guard
206     mapping(address => uint256) private _lastBuyBlock;
207 
208     //Migration Wallet
209     address public constant MIGRATION_WALLET =
210         0xc207cd3f61Da958AA6f4209C5f0a145C056B576f;
211 
212     // initialize supply
213     constructor() {
214         _balances[address(this)] = _totalSupply;
215 
216         isFeeExempt[msg.sender] = true;
217         isFeeExempt[MIGRATION_WALLET] = true;
218         
219         isTxLimitExempt[MIGRATION_WALLET] = true;
220         isTxLimitExempt[msg.sender] = true;
221         isTxLimitExempt[address(this)] = true;
222         isTxLimitExempt[DEAD] = true;
223         isTxLimitExempt[address(0)] = true;
224 
225         emit Transfer(address(0), address(this), _totalSupply);
226     }
227 
228     function totalSupply() external pure override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     function balanceOf(address account) public view override returns (uint256) {
233         return _balances[account];
234     }
235 
236     function allowance(address holder, address spender)
237         external
238         view
239         override
240         returns (uint256)
241     {
242         return _allowances[holder][spender];
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function approve(address spender, uint256 amount)
258         public
259         override
260         returns (bool)
261     {
262         require(spender != address(0), "SRG20: approve to the zero address");
263         require(
264             msg.sender != address(0),
265             "SRG20: approve from the zero address"
266         );
267 
268         _allowances[msg.sender][spender] = amount;
269         emit Approval(msg.sender, spender, amount);
270         return true;
271     }
272 
273     function approveMax(address spender) external returns (bool) {
274         return approve(spender, type(uint256).max);
275     }
276 
277     function getCirculatingSupply() public view returns (uint256) {
278         return _totalSupply - _balances[DEAD];
279     }
280 
281     function changeWalletLimit(uint256 newLimit) external onlyOwner {
282         require(
283             newLimit >= _totalSupply / 100,
284             "New wallet limit should be at least 1% of total supply"
285         );
286         maxBag = newLimit;
287         emit MaxBagChanged(newLimit);
288     }
289 
290     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
291         isFeeExempt[holder] = exempt;
292     }
293 
294     function changeIsTxLimitExempt(address holder, bool exempt)
295         external
296         onlyOwner
297     {
298         isTxLimitExempt[holder] = exempt;
299     }
300 
301     /** Transfer Function */
302     function transfer(address recipient, uint256 amount)
303         external
304         override
305         returns (bool)
306     {
307         return _transferFrom(msg.sender, recipient, amount);
308     }
309 
310     /** TransferFrom Function */
311     function transferFrom(
312         address sender,
313         address recipient,
314         uint256 amount
315     ) external override returns (bool) {
316         address spender = msg.sender;
317         //check allowance requirement
318         _spendAllowance(sender, spender, amount);
319         return _transferFrom(sender, recipient, amount);
320     }
321 
322     /** Internal Transfer */
323     function _transferFrom(
324         address sender,
325         address recipient,
326         uint256 amount
327     ) internal returns (bool) {
328         // make standard checks
329         require(
330             recipient != address(0) && recipient != address(this),
331             "transfer to the zero address or CA"
332         );
333         require(amount > 0, "Transfer amount must be greater than zero");
334         require(
335             isTxLimitExempt[recipient] ||
336                 _balances[recipient] + amount <= maxBag,
337             "Max wallet exceeded!"
338         );
339 
340         // subtract from sender
341         _balances[sender] = _balances[sender] - amount;
342 
343         // give amount to receiver
344         _balances[recipient] = _balances[recipient] + amount;
345 
346         // Transfer Event
347         emit Transfer(sender, recipient, amount);
348         return true;
349     }
350 
351     function _spendAllowance(
352         address owner,
353         address spender,
354         uint256 amount
355     ) internal virtual {
356         uint256 currentAllowance = _allowances[owner][spender];
357         if (currentAllowance != type(uint256).max) {
358             require(
359                 currentAllowance >= amount,
360                 "SRG20: insufficient allowance"
361             );
362 
363             unchecked {
364                 // decrease allowance
365                 _approve(owner, spender, currentAllowance - amount);
366             }
367         }
368     }
369 
370     function _approve(
371         address owner,
372         address spender,
373         uint256 amount
374     ) internal virtual {
375         require(owner != address(0), "ERC20: approve from the zero address");
376         require(spender != address(0), "ERC20: approve to the zero address");
377 
378         _allowances[owner][spender] = amount;
379         emit Approval(owner, spender, amount);
380     }
381 
382     /** Purchases SURGE Tokens and Deposits Them in Sender's Address*/
383     function _buy(uint256 minTokenOut, uint256 deadline)
384         public
385         payable
386         nonReentrant
387         returns (bool)
388     {
389         // deadline requirement
390         require(deadline >= block.timestamp, "Deadline EXPIRED");
391 
392         // Frontrun Guard
393         _lastBuyBlock[msg.sender] = block.number;
394 
395         // liquidity is set
396         require(liquidity > 0, "The token has no liquidity");
397 
398         // check if trading is open or whether the buying wallet is the migration one
399         require(
400             block.timestamp >= TRADE_OPEN_TIME ||
401                 msg.sender == MIGRATION_WALLET,
402             "Trading is not Open"
403         );
404 
405         //remove the buy tax
406         uint256 bnbAmount = isFeeExempt[msg.sender]
407             ? msg.value
408             : (msg.value * buyMul) / DIVISOR;
409 
410         // how much they should purchase?
411         uint256 tokensToSend = _balances[address(this)] -
412             (liqConst / (bnbAmount + liquidity));
413 
414         //revert for max bag
415         require(
416             _balances[msg.sender] + tokensToSend <= maxBag ||
417                 isTxLimitExempt[msg.sender],
418             "Max wallet exceeded"
419         );
420 
421         // revert if under 1
422         require(tokensToSend > 1, "Must Buy more than 1 decimal of Surge");
423 
424         // revert for slippage
425         require(tokensToSend >= minTokenOut, "INSUFFICIENT OUTPUT AMOUNT");
426 
427         // transfer the tokens from CA to the buyer
428         buy(msg.sender, tokensToSend);
429 
430         //update available tax to extract and Liquidity
431         uint256 taxAmount = msg.value - bnbAmount;
432         taxBalance = taxBalance + taxAmount;
433         liquidity = liquidity + bnbAmount;
434 
435         //update volume
436         uint256 cTime = block.timestamp;
437         uint256 dollarBuy = msg.value * getBNBPrice();
438         totalVolume += dollarBuy;
439         indVol[msg.sender] += dollarBuy;
440         tVol[cTime] += dollarBuy;
441 
442         //update candleStickData
443         totalTx += 1;
444         txTimeStamp[totalTx] = cTime;
445         uint256 cPrice = calculatePrice() * getBNBPrice();
446         candleStickData[cTime].time = cTime;
447         if (candleStickData[cTime].open == 0) {
448             if (totalTx == 1) {
449                 candleStickData[cTime].open =
450                     ((liquidity - bnbAmount) / (_totalSupply)) *
451                     getBNBPrice();
452             } else {
453                 candleStickData[cTime].open = candleStickData[
454                     txTimeStamp[totalTx - 1]
455                 ].close;
456             }
457         }
458         candleStickData[cTime].close = cPrice;
459 
460         if (
461             candleStickData[cTime].high < cPrice ||
462             candleStickData[cTime].high == 0
463         ) {
464             candleStickData[cTime].high = cPrice;
465         }
466 
467         if (
468             candleStickData[cTime].low > cPrice ||
469             candleStickData[cTime].low == 0
470         ) {
471             candleStickData[cTime].low = cPrice;
472         }
473 
474         //emit transfer and buy events
475         emit Transfer(address(this), msg.sender, tokensToSend);
476         emit Bought(
477             msg.sender,
478             address(this),
479             tokensToSend,
480             msg.value,
481             bnbAmount * getBNBPrice()
482         );
483         return true;
484     }
485 
486     /** Sends Tokens to the buyer Address */
487     function buy(address receiver, uint256 amount) internal {
488         _balances[receiver] = _balances[receiver] + amount;
489         _balances[address(this)] = _balances[address(this)] - amount;
490     }
491 
492     /** Sells SURGE Tokens And Deposits the BNB into Seller's Address */
493     function _sell(
494         uint256 tokenAmount,
495         uint256 deadline,
496         uint256 minBNBOut
497     ) public nonReentrant returns (bool) {
498         // deadline requirement
499         require(deadline >= block.timestamp, "Deadline EXPIRED");
500 
501         //Frontrun Guard
502         require(
503             _lastBuyBlock[msg.sender] != block.number,
504             "Buying and selling in the same block is not allowed!"
505         );
506 
507         address seller = msg.sender;
508 
509         // make sure seller has this balance
510         require(
511             _balances[seller] >= tokenAmount,
512             "cannot sell above token amount"
513         );
514 
515         // get how much beans are the tokens worth
516         uint256 amountBNB = liquidity -
517             (liqConst / (_balances[address(this)] + tokenAmount));
518         uint256 amountTax = (amountBNB * (DIVISOR - sellMul)) / DIVISOR;
519         uint256 BNBToSend = amountBNB - amountTax;
520 
521         //slippage revert
522         require(amountBNB >= minBNBOut, "INSUFFICIENT OUTPUT AMOUNT");
523 
524         // send BNB to Seller
525         (bool successful, ) = isFeeExempt[msg.sender]
526             ? payable(seller).call{value: amountBNB}("")
527             : payable(seller).call{value: BNBToSend}("");
528         require(successful, "BNB/ETH transfer failed");
529 
530         // subtract full amount from sender
531         _balances[seller] = _balances[seller] - tokenAmount;
532 
533         //add tax allowance to be withdrawn and remove from liq the amount of beans taken by the seller
534         taxBalance = isFeeExempt[msg.sender]
535             ? taxBalance
536             : taxBalance + amountTax;
537         liquidity = liquidity - amountBNB;
538 
539         // add tokens back into the contract
540         _balances[address(this)] = _balances[address(this)] + tokenAmount;
541 
542         //update volume
543         uint256 cTime = block.timestamp;
544         uint256 dollarSell = amountBNB * getBNBPrice();
545         totalVolume += dollarSell;
546         indVol[msg.sender] += dollarSell;
547         tVol[cTime] += dollarSell;
548 
549         //update candleStickData
550         totalTx += 1;
551         txTimeStamp[totalTx] = cTime;
552         uint256 cPrice = calculatePrice() * getBNBPrice();
553         candleStickData[cTime].time = cTime;
554         if (candleStickData[cTime].open == 0) {
555             candleStickData[cTime].open = candleStickData[
556                 txTimeStamp[totalTx - 1]
557             ].close;
558         }
559         candleStickData[cTime].close = cPrice;
560 
561         if (
562             candleStickData[cTime].high < cPrice ||
563             candleStickData[cTime].high == 0
564         ) {
565             candleStickData[cTime].high = cPrice;
566         }
567 
568         if (
569             candleStickData[cTime].low > cPrice ||
570             candleStickData[cTime].low == 0
571         ) {
572             candleStickData[cTime].low = cPrice;
573         }
574 
575         // emit transfer and sell events
576         emit Transfer(seller, address(this), tokenAmount);
577         if (isFeeExempt[msg.sender]) {
578             emit Sold(
579                 address(this),
580                 msg.sender,
581                 tokenAmount,
582                 amountBNB,
583                 dollarSell
584             );
585         } else {
586             emit Sold(
587                 address(this),
588                 msg.sender,
589                 tokenAmount,
590                 BNBToSend,
591                 BNBToSend * getBNBPrice()
592             );
593         }
594         return true;
595     }
596 
597     /** Amount of BNB in Contract */
598     function getLiquidity() public view returns (uint256) {
599         return liquidity;
600     }
601 
602     /** Returns the value of your holdings before the sell fee */
603     function getValueOfHoldings(address holder) public view returns (uint256) {
604         return
605             ((_balances[holder] * liquidity) / _balances[address(this)]) *
606             getBNBPrice();
607     }
608 
609     function changeFees(uint256 newBuyMul, uint256 newSellMul)
610         external
611         onlyOwner
612     {
613         require(
614             newBuyMul >= 90 &&
615                 newSellMul >= 90 &&
616                 newBuyMul <= 100 &&
617                 newSellMul <= 100,
618             "Fees are too high"
619         );
620 
621         buyMul = newBuyMul;
622         sellMul = newSellMul;
623 
624         emit FeesMulChanged(newBuyMul, newSellMul);
625     }
626 
627     function changeTaxDistribution(
628         uint256 newteamShare,
629         uint256 newtreasuryShare
630     ) external onlyOwner {
631         require(
632             newteamShare + newtreasuryShare == SHAREDIVISOR,
633             "Sum of shares must be 100"
634         );
635 
636         teamShare = newteamShare;
637         treasuryShare = newtreasuryShare;
638     }
639 
640     function changeFeeReceivers(
641         address newTeamWallet,
642         address newTreasuryWallet
643     ) external onlyOwner {
644         require(
645             newTeamWallet != address(0) && newTreasuryWallet != address(0),
646             "New wallets must not be the ZERO address"
647         );
648 
649         teamWallet = newTeamWallet;
650         treasuryWallet = newTreasuryWallet;
651     }
652 
653     function withdrawTaxBalance() external nonReentrant onlyOwner {
654         (bool temp1, ) = payable(teamWallet).call{
655             value: (taxBalance * teamShare) / SHAREDIVISOR
656         }("");
657         (bool temp2, ) = payable(treasuryWallet).call{
658             value: (taxBalance * treasuryShare) / SHAREDIVISOR
659         }("");
660         assert(temp1 && temp2);
661         taxBalance = 0;
662     }
663 
664     function getTokenAmountOut(uint256 amountBNBIn)
665         external
666         view
667         returns (uint256)
668     {
669         uint256 amountAfter = liqConst / (liquidity - amountBNBIn);
670         uint256 amountBefore = liqConst / liquidity;
671         return amountAfter - amountBefore;
672     }
673 
674     function getBNBAmountOut(uint256 amountIn) public view returns (uint256) {
675         uint256 beansBefore = liqConst / _balances[address(this)];
676         uint256 beansAfter = liqConst / (_balances[address(this)] + amountIn);
677         return beansBefore - beansAfter;
678     }
679 
680     function addLiquidity() external payable onlyOwner {
681         uint256 tokensToAdd = (_balances[address(this)] * msg.value) /
682             liquidity;
683         require(_balances[msg.sender] >= tokensToAdd, "Not enough tokens!");
684 
685         uint256 oldLiq = liquidity;
686         liquidity = liquidity + msg.value;
687         _balances[address(this)] += tokensToAdd;
688         _balances[msg.sender] -= tokensToAdd;
689         liqConst = (liqConst * liquidity) / oldLiq;
690 
691         emit Transfer(msg.sender, address(this), tokensToAdd);
692     }
693 
694     function getMarketCap() external view returns (uint256) {
695         return (getCirculatingSupply() * calculatePrice() * getBNBPrice());
696     }
697 
698     address private stablePairAddress =
699         0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
700     address private stableAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
701 
702     function changeStablePair(address newStablePair, address newStableAddress)
703         external
704         onlyOwner
705     {
706         require(
707             newStablePair != address(0) && newStableAddress != address(0),
708             "New addresses must not be the ZERO address"
709         );
710 
711         stablePairAddress = newStablePair;
712         stableAddress = newStableAddress;
713         emit StablePairChanged(newStablePair, newStableAddress);
714     }
715 
716     // calculate price based on pair reserves
717     function getBNBPrice() public view returns (uint256) {
718         IPancakePair pair = IPancakePair(stablePairAddress);
719         IERC20 token1 = pair.token0() == stableAddress
720             ? IERC20(pair.token1())
721             : IERC20(pair.token0());
722 
723         (uint256 Res0, uint256 Res1, ) = pair.getReserves();
724 
725         if (pair.token0() != stableAddress) {
726             (Res1, Res0, ) = pair.getReserves();
727         }
728         uint256 res0 = Res0 * 10**token1.decimals();
729         return (res0 / Res1); // return amount of token0 needed to buy token1
730     }
731 
732     // Returns the Current Price of the Token in beans
733     function calculatePrice() public view returns (uint256) {
734         require(liquidity > 0, "No Liquidity");
735         return liquidity / _balances[address(this)];
736     }
737 }