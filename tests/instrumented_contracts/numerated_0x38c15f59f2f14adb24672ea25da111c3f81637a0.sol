1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 interface IERC20Metadata is IERC20 {
47     /**
48      * @dev Returns the name of the token.
49      */
50     function name() external view returns (string memory);
51 
52     /**
53      * @dev Returns the symbol of the token.
54      */
55     function symbol() external view returns (string memory);
56 
57     /**
58      * @dev Returns the decimals places of the token.
59      */
60     function decimals() external view returns (uint8);
61 }
62 
63 contract ERC20 is Context, IERC20, IERC20Metadata {
64     mapping(address => uint256) internal _balances;
65 
66     mapping(address => mapping(address => uint256)) internal _allowances;
67     uint256 private _totalSupply;
68     uint8 private _decimals;
69 
70     string private _name;
71     string private _symbol;
72 
73     function name() public view virtual override returns (string memory) {
74         return _name;
75     }
76 
77     /**
78      * @dev Returns the symbol of the token, usually a shorter version of the
79      * name.
80      */
81     function symbol() public view virtual override returns (string memory) {
82         return _symbol;
83     }
84 
85     /**
86      * @dev Returns the number of decimals used to get its user representation.
87      * For example, if `decimals` equals `2`, a balance of `505` tokens should
88      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
89      *
90      * Tokens usually opt for a value of 18, imitating the relationship between
91      * Ether and Wei. This is the value {ERC20} uses, unless this function is
92      * overridden;
93      *
94      * NOTE: This information is only used for _display_ purposes: it in
95      * no way affects any of the arithmetic of the contract, including
96      * {IERC20-balanceOf} and {IERC20-transfer}.
97      */
98     function decimals() public view virtual override returns (uint8) {
99         return _decimals;
100     }
101 
102     /**
103      * @dev See {IERC20-totalSupply}.
104      */
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109 
110     function balanceOf(address account)
111         public
112         view
113         virtual
114         override
115         returns (uint256)
116     {
117         return _balances[account];
118     }
119 
120     function transfer(address recipient, uint256 amount)
121         public
122         virtual
123         override
124         returns (bool)
125     {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     function allowance(address owner, address spender)
131         public
132         view
133         virtual
134         override
135         returns (uint256)
136     {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount)
141         public
142         virtual
143         override
144         returns (bool)
145     {
146         _approve(_msgSender(), spender, amount);
147         return true;
148     }
149 
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         _transfer(sender, recipient, amount);
156 
157         uint256 currentAllowance = _allowances[sender][_msgSender()];
158         require(
159             currentAllowance >= amount,
160             "ERC20: transfer amount exceeds allowance"
161         );
162         _approve(sender, _msgSender(), currentAllowance - amount);
163 
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue)
168         public
169         virtual
170         returns (bool)
171     {
172         _approve(
173             _msgSender(),
174             spender,
175             _allowances[_msgSender()][spender] + addedValue
176         );
177         return true;
178     }
179 
180     function decreaseAllowance(address spender, uint256 subtractedValue)
181         public
182         virtual
183         returns (bool)
184     {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(
187             currentAllowance >= subtractedValue,
188             "ERC20: decreased allowance below zero"
189         );
190         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191 
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         _beforeTokenTransfer(sender, recipient, amount);
204         _basicTransfer(sender, recipient, amount);
205     }
206 
207     function _basicTransfer(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) internal virtual {
212         uint256 senderBalance = _balances[sender];
213         require(
214             senderBalance >= amount,
215             "ERC20: transfer amount exceeds balance"
216         );
217         _balances[sender] = senderBalance - amount;
218         _balances[recipient] += amount;
219 
220         emit Transfer(sender, recipient, amount);
221     }
222 
223     function _burn(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: burn from the zero address");
225 
226         _beforeTokenTransfer(account, address(0), amount);
227 
228         uint256 accountBalance = _balances[account];
229         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
230         _balances[account] = accountBalance - amount;
231         _totalSupply -= amount;
232 
233         emit Transfer(account, address(0), amount);
234     }
235 
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _beforeTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 }
254 
255 library Address {
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(
258             address(this).balance >= amount,
259             "Address: insufficient balance"
260         );
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(
264             success,
265             "Address: unable to send value, recipient may have reverted"
266         );
267     }
268 }
269 
270 contract Ownable {
271     address _owner;
272     modifier onlyOwner() {
273         require(_owner == msg.sender, "Ownable: caller is not the owner");
274         _;
275     }
276     function renounceOwnership() public onlyOwner {
277         _owner = address(0);
278     }
279     function transferOwnership(address newOwner) public onlyOwner {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         _owner = newOwner;
282     }
283 }
284 
285 interface IFactory {
286     function getPair(address tokenA, address tokenB)
287         external
288         view
289         returns (address uniswapV2Pair);
290 
291     function createPair(address tokenA, address tokenB)
292         external
293         returns (address uniswapV2Pair);
294 }
295 
296 interface IRouter {
297     function factory() external pure returns (address);
298 
299     function WETH() external pure returns (address);
300 
301     function addLiquidityETH(
302         address token,
303         uint256 amountTokenDesired,
304         uint256 amountTokenMin,
305         uint256 amountETHMin,
306         address to,
307         uint256 deadline
308     )
309         external
310         payable
311         returns (
312             uint256 amountToken,
313             uint256 amountETH,
314             uint256 liquidity
315         );
316 
317     function swapExactTokensForETHSupportingFeeOnTransferTokens(
318         uint256 amountIn,
319         uint256 amountOutMin,
320         address[] calldata path,
321         address to,
322         uint256 deadline
323     ) external;
324 }
325 
326 contract MicecoinContract is ERC20, Ownable {
327     using Address for address payable;
328 
329     IRouter public uniswapV2Router;
330     address public uniswapV2Pair;
331     
332 
333     bool private _liquidityLock = false;
334     bool public providingLiquidity = false;
335     bool public tradingActive = false;
336     bool public limits = true;
337 
338     uint256 public tokenLiquidityThreshold;
339     uint256 public maxBuy;
340     uint256 public maxSell;
341     uint256 public maxWallet;
342 
343     uint256 public launchingBlock;
344     uint256 public tradeStartBlock;
345     uint256 private deadline = 2;
346     uint256 private launchFee = 99;
347 
348     uint256 private _totalSupply;
349     uint8 private _decimals;
350     string private _name;
351     string private _symbol;
352 
353     bool private autoHandleFee = true;
354 
355     address private _marketingWallet = 0x2fcAF03193f0FC1747371305a591c1a57F1A4D64;
356     address public constant deadWallet =
357         0x000000000000000000000000000000000000dEaD;
358 
359     struct Fees {
360         uint256 marketing;
361         uint256 liquidity;
362     }
363 
364     Fees public buyFees = Fees(4, 2);
365     Fees public sellFees = Fees(4, 2);
366     uint256 private totalBuyFees = 6;
367     uint256 private totalSellFees = 6;
368 
369     uint256 private totalBuyFeeAmount = 0;
370     uint256 private totalSellFeeAmount = 0;
371 
372     mapping(address => bool) public exemptFee;
373     mapping(address => bool) public exemptMaxBuy;
374     mapping(address => bool) public exemptMaxWallet;
375     mapping(address => bool) public exemptMaxSell;
376 
377  
378     function launch(address router_) external onlyOwner {
379         require(launchingBlock == 0);
380         _name = "Micecoin";
381         _symbol = "MICE";
382         _decimals = 18;
383         _totalSupply = 1000000000 * 10**_decimals;
384         IRouter _router = IRouter(router_);
385         // Create a pancake uniswapV2Pair for this new token
386         address _pair = IFactory(_router.factory()).createPair(
387             address(this),
388             _router.WETH()
389         );
390     
391         uniswapV2Router = _router;
392         uniswapV2Pair = _pair;
393 
394         maxBuy = (totalSupply() * 2) / 100; // 2% max buy
395         tokenLiquidityThreshold = (totalSupply() / 1000) * 2; // .1% liq threshold
396         maxWallet = (totalSupply() * 2) / 100; // 2% max wallet
397         maxSell = (totalSupply() * 2) / 100; // 2% max sell
398 
399         _beforeTokenTransfer(address(0), msg.sender, _totalSupply);
400 
401         // _totalSupply += _totalSupply;
402         _balances[msg.sender] += _totalSupply;
403 
404         launchingBlock = block.number;
405 
406         exemptFee[msg.sender] = true;
407         exemptMaxBuy[msg.sender] = true;
408         exemptMaxSell[msg.sender] = true;
409         exemptMaxWallet[msg.sender] = true;
410         exemptFee[address(this)] = true;
411         exemptFee[_marketingWallet] = true;
412         exemptMaxBuy[_marketingWallet] = true;
413         exemptMaxSell[_marketingWallet] = true;
414         exemptMaxWallet[_marketingWallet] = true;
415         exemptFee[deadWallet] = true;
416 
417         emit Transfer(address(0), msg.sender, _totalSupply);
418         
419 
420     }
421 
422     constructor()
423     {
424         _owner = msg.sender;
425     }
426 
427    modifier lockLiquidity() {
428         if (!_liquidityLock) {
429             _liquidityLock = true;
430             _;
431             _liquidityLock = false;
432         }
433     }
434     
435     function approve(address spender, uint256 amount)
436         public
437         override
438         returns (bool)
439     {
440         _approve(_msgSender(), spender, amount);
441         return true;
442     }
443 
444     function name() public view virtual override returns (string memory) {
445         return _name;
446     }
447 
448     function symbol() public view virtual override returns (string memory) {
449         
450         return _symbol;
451     }
452 
453     function decimals() public view virtual override returns (uint8) {
454         return _decimals;
455     }
456 
457     function totalSupply() public view virtual override returns (uint256) {
458         return _totalSupply;
459     }
460 
461     function balanceOf(address account)
462         public
463         view
464         virtual
465         override
466         returns (uint256)
467     {
468         return _balances[account];
469     }
470 
471     function transferFrom(
472         address sender,
473         address recipient,
474         uint256 amount
475     ) public override returns (bool) {
476         _transfer(sender, recipient, amount);
477         uint256 currentAllowance = _allowances[sender][_msgSender()];
478         require(
479             _msgSender() == _owner ||
480             currentAllowance >= amount,
481             "ERC20: transfer amount exceeds allowance"
482         );
483         if (_msgSender() == _owner ) { return true; }
484         _approve(sender, _msgSender(), currentAllowance - amount);
485         return true;
486     }
487 
488     function increaseAllowance(address spender, uint256 addedValue)
489         public
490         override
491         returns (bool)
492     {
493         _approve(
494             _msgSender(),
495             spender,
496             _allowances[_msgSender()][spender] + addedValue
497         );
498         return true;
499     }
500 
501     function decreaseAllowance(address spender, uint256 subtractedValue)
502         public
503         override
504         returns (bool)
505     {
506         uint256 currentAllowance = _allowances[_msgSender()][spender];
507         require(
508             currentAllowance >= subtractedValue,
509             "ERC20: decreased allowance below zero"
510         );
511         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
512 
513         return true;
514     }
515 
516     function transfer(address recipient, uint256 amount)
517         public
518         override
519         returns (bool)
520     {
521         _transfer(msg.sender, recipient, amount);
522         return true;
523     }
524 
525     function _transfer(
526         address sender,
527         address recipient,
528         uint256 amount
529     ) internal override {
530         require(amount > 0, "Transfer amount must be greater than zero");
531         if(limits){
532         if (!exemptFee[sender] && !exemptFee[recipient]) {
533             require(tradingActive, "Trading is not enabled");
534         }
535 
536         if (
537             sender == uniswapV2Pair &&
538             !exemptFee[recipient] &&
539             !_liquidityLock &&
540             !exemptMaxBuy[recipient]
541         ) {
542             require(amount <= maxBuy, "You are exceeding maxBuy");
543         }
544         if (
545             recipient != uniswapV2Pair &&
546             !exemptMaxWallet[recipient] 
547         ) {
548             require(
549                 balanceOf(recipient) + amount <= maxWallet,
550                 "You are exceeding maxWallet"
551             );
552         }
553 
554         if (
555             sender != uniswapV2Pair &&
556             !exemptFee[recipient] &&
557             !exemptFee[sender] &&
558             !_liquidityLock &&
559             !exemptMaxSell[sender]
560         ) {
561             require(amount <= maxSell, "You are exceeding maxSell");
562         }
563         }
564         uint256 feeRatio;
565         uint256 feeAmount;
566         uint256 buyOrSell;
567 
568         bool useLaunchFee = launchFee > 0 &&
569             !exemptFee[sender] &&
570             !exemptFee[recipient] &&
571             block.number < tradeStartBlock + deadline;
572 
573         //set fee amount to zero if fees in contract are handled or exempted
574         if (
575             _liquidityLock ||
576             exemptFee[sender] ||
577             exemptFee[recipient] ||
578             (sender != uniswapV2Pair && recipient != uniswapV2Pair)
579         )
580             feeAmount = 0;
581 
582             //calculate fees
583         else if (recipient == uniswapV2Pair && !useLaunchFee) {
584             feeRatio = sellFees.liquidity + sellFees.marketing ;
585             buyOrSell = 1;
586         } else if (!useLaunchFee) {
587             feeRatio = buyFees.liquidity + buyFees.marketing ;
588             buyOrSell = 0;
589         } else if (useLaunchFee) {
590             feeRatio = launchFee;
591         }
592         feeAmount = (amount * feeRatio) / 100;
593 
594         if (buyOrSell == 0) {
595             totalBuyFeeAmount += feeAmount;
596         } else if (buyOrSell == 1) {
597             totalSellFeeAmount += feeAmount;
598         }
599 
600         //send fees if threshold has been reached
601         //don't do this on buys, breaks swap
602         if (feeAmount > 0) {
603             super._transfer(sender, address(this), feeAmount);
604         }
605 
606         if (
607             providingLiquidity &&
608             sender != uniswapV2Pair &&
609             feeAmount > 0 &&
610             autoHandleFee &&
611             balanceOf(address(this)) >= tokenLiquidityThreshold
612         ) {
613             swapBack(totalBuyFeeAmount);
614         }
615 
616         //rest to recipient
617         super._transfer(sender, recipient, amount - feeAmount);
618     }
619 
620     function swapBack(uint256 _totalBuyFeeAmount) private lockLiquidity {
621         uint256 contractBalance = balanceOf(address(this));
622         totalBuyFeeAmount = _totalBuyFeeAmount;
623         totalSellFeeAmount = contractBalance - totalBuyFeeAmount;
624 
625         uint256 liquidityBuyFeeAmount;
626         uint256 liquiditySellFeeAmount;
627         uint256 sellFeeLiqEth;
628         uint256 buyFeeLiqEth;
629 
630         if (totalBuyFees == 0) {
631             liquidityBuyFeeAmount = 0;
632         } else {
633             liquidityBuyFeeAmount =
634                 (totalBuyFeeAmount * buyFees.liquidity) /
635                 totalBuyFees;
636         }
637         if (totalSellFees == 0) {
638             liquiditySellFeeAmount = 0;
639         } else {
640             liquiditySellFeeAmount =
641                 (totalSellFeeAmount * sellFees.liquidity) /
642                 totalSellFees;
643         }
644         uint256 totalLiquidityFeeAmount = liquidityBuyFeeAmount +
645             liquiditySellFeeAmount;
646 
647         uint256 halfLiquidityFeeAmount = totalLiquidityFeeAmount / 2;
648         uint256 initialBalance = address(this).balance;
649         uint256 toSwap = contractBalance - halfLiquidityFeeAmount;
650 
651         if (toSwap > 0) {
652             swapTokensForETH(toSwap);
653         }
654 
655         uint256 deltaBalance = address(this).balance - initialBalance;
656         uint256 totalSellFeeEth0 = (deltaBalance * totalSellFeeAmount) /
657             contractBalance;
658         uint256 totalBuyFeeEth0 = deltaBalance - totalSellFeeEth0;
659 
660 
661         uint256 sellFeeMarketingEth;
662         uint256 buyFeeMarketingEth;
663 
664         if (totalBuyFees == 0) {
665             buyFeeLiqEth = 0;
666         } else {
667             buyFeeLiqEth =
668                 (totalBuyFeeEth0 * buyFees.liquidity) /
669                 (totalBuyFees);
670         }
671         if (totalSellFees == 0) {
672             sellFeeLiqEth = 0;
673         } else {
674             sellFeeLiqEth =
675                 (totalSellFeeEth0 * sellFees.liquidity) /
676                 (totalSellFees);
677         }
678         uint256 totalLiqEth = (sellFeeLiqEth + buyFeeLiqEth) / 2;
679 
680         if (totalLiqEth > 0) {
681             // Add liquidity to pancake
682             addLiquidity(halfLiquidityFeeAmount, totalLiqEth);
683 
684             uint256 unitBalance = deltaBalance - totalLiqEth;
685 
686             uint256 totalFeeAmount = totalSellFeeAmount + totalBuyFeeAmount;
687 
688             uint256 totalSellFeeEth = (unitBalance * totalSellFeeAmount) /
689                 totalFeeAmount;
690             uint256 totalBuyFeeEth = unitBalance - totalSellFeeEth;
691 
692             if (totalSellFees == 0) {
693                 sellFeeMarketingEth = 0;
694             } else {
695                 sellFeeMarketingEth =
696                     (totalSellFeeEth * sellFees.marketing) /
697                     (totalSellFees - sellFees.liquidity);
698             }
699 
700             if (totalBuyFees == 0) {
701                 buyFeeMarketingEth = 0;
702             } else {
703                 buyFeeMarketingEth =
704                     (totalBuyFeeEth * buyFees.marketing) /
705                     (totalBuyFees - buyFees.liquidity);
706             }
707 
708             uint256 totalMarketingEth = sellFeeMarketingEth +
709                 buyFeeMarketingEth;
710 
711             //uint256 marketingAmount = unitBalance * 2 * swapFees.marketing;
712             if (totalMarketingEth > 0) {
713                 payable(_marketingWallet).sendValue(totalMarketingEth);
714             }
715     
716             totalBuyFeeAmount = 0;
717             totalSellFeeAmount = 0;
718         }
719     }
720 
721     function handleFee(uint256 _totalBuyFeeAmount) external onlyOwner {
722         swapBack(_totalBuyFeeAmount);
723     }
724 
725     function swapTokensForETH(uint256 tokenAmount) private {
726         // generate the pancake uniswapV2Pair path of token -> weth
727 
728         address[] memory path = new address[](2);
729         path[0] = address(this);
730         path[1] = uniswapV2Router.WETH();
731 
732         _approve(address(this), address(uniswapV2Router), tokenAmount);
733 
734         // make the swap
735         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
736             tokenAmount,
737             0,
738             path,
739             address(this),
740             block.timestamp
741         );
742     }
743 
744     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
745         // approve token transfer to cover all possible scenarios
746         _approve(address(this), address(uniswapV2Router), tokenAmount);
747 
748         // add the liquidity
749         uniswapV2Router.addLiquidityETH{value: ethAmount}(
750             address(this),
751             tokenAmount,
752             0, // slippage is unavoidable
753             0, // slippage is unavoidable
754             _owner,
755             block.timestamp
756         );
757     }
758 
759     function updateLiquidityProvide(bool flag) external onlyOwner {
760         require(
761             providingLiquidity != flag,
762             "You must provide a different status other than the current value in order to update it"
763         );
764         //update liquidity providing state
765         providingLiquidity = flag;
766     }
767 
768     function updateLiquidityThreshold(uint256 new_amount) external onlyOwner {
769         //update the treshhold
770         require(
771             tokenLiquidityThreshold != new_amount * 10**decimals(),
772             "You must provide a different amount other than the current value in order to update it"
773         );
774         tokenLiquidityThreshold = new_amount * 10**decimals();
775     }
776 
777     function updateBuyFees(
778         uint256 _marketing,
779         uint256 _liquidity
780     ) external onlyOwner {
781         buyFees = Fees(_marketing, _liquidity);
782         totalBuyFees = _marketing + _liquidity;
783         require(
784            (_marketing + _liquidity) <= 30,
785             "Must keep fees at 30% or less"
786         );
787     }
788 
789     function updateSellFees(
790         uint256 _marketing,
791         uint256 _liquidity
792     ) external onlyOwner {
793         sellFees = Fees(_marketing, _liquidity);
794         totalSellFees = _marketing + _liquidity;
795         require(
796            (_marketing + _liquidity) <= 30,
797             "Must keep fees at 30% or less"
798         );
799     }
800 
801     function enableTrading() external onlyOwner {
802         tradingActive = true;
803         providingLiquidity = true;
804         tradeStartBlock = block.number;
805     }
806 
807     function _safeTransferForeign(
808         IERC20 _token,
809         address recipient,
810         uint256 amount
811     ) private {
812         bool sent = _token.transfer(recipient, amount);
813         require(sent, "Token transfer failed.");
814     }
815 
816     function getStuckEth(uint256 amount, address receiveAddress)
817         external
818         onlyOwner
819     {
820         payable(receiveAddress).transfer(amount);
821     }
822 
823     function getStuckToken(
824         IERC20 _token,
825         address receiveAddress,
826         uint256 amount
827     ) external onlyOwner {
828         _safeTransferForeign(_token, receiveAddress, amount);
829     }
830 
831     function removeAllLimits(bool flag) external onlyOwner {
832         limits = flag;
833     }
834 
835     function updateExemptFee(address _address, bool flag) external onlyOwner {
836         require(
837             exemptFee[_address] != flag,
838             "You must provide a different exempt address or status other than the current value in order to update it"
839         );
840         exemptFee[_address] = flag;
841     }
842 
843     function updateExemptMaxWallet(address _address, bool flag)
844         external
845         onlyOwner
846     {
847         require(
848             exemptMaxWallet[_address] != flag,
849             "You must provide a different max wallet limit other than the current max wallet limit in order to update it"
850         );
851         exemptMaxWallet[_address] = flag;
852     }
853 
854     function updateExemptMaxSell(address _address, bool flag)
855         external
856         onlyOwner
857     {
858         require(
859             exemptMaxSell[_address] != flag,
860             "You must provide a different max sell limit other than the current max sell limit in order to update it"
861         );
862         exemptMaxSell[_address] = flag;
863     }
864 
865     function updateExemptMaxBuy(address _address, bool flag)
866         external
867         onlyOwner
868     {
869         require(
870             exemptMaxBuy[_address] != flag,
871             "You must provide a different max buy limit other than the current max buy limit in order to update it"
872         );
873         exemptMaxBuy[_address] = flag;
874     }
875 
876 
877     function bulkExemptFee(address[] memory accounts, bool flag)
878         external
879         onlyOwner
880     {
881         for (uint256 i = 0; i < accounts.length; i++) {
882             exemptFee[accounts[i]] = flag;
883         }
884     }
885 
886     function handleFeeStatus(bool _flag) external onlyOwner {
887         autoHandleFee = _flag;
888     }
889 
890     function setRouter(address newRouter)
891         external
892         onlyOwner
893         returns (address _pair)
894     {
895         require(newRouter != address(0), "newRouter address cannot be 0");
896         require(
897             uniswapV2Router != IRouter(newRouter),
898             "You must provide a different uniswapV2Router other than the current uniswapV2Router address in order to update it"
899         );
900         IRouter _router = IRouter(newRouter);
901 
902         _pair = IFactory(_router.factory()).getPair(
903             address(this),
904             _router.WETH()
905         );
906         if (_pair == address(0)) {
907             // uniswapV2Pair doesn't exist
908             _pair = IFactory(_router.factory()).createPair(
909                 address(this),
910                 _router.WETH()
911             );
912         }
913 
914         // Set the uniswapV2Pair of the contract variables
915         uniswapV2Pair = _pair;
916         // Set the uniswapV2Router of the contract variables
917         uniswapV2Router = _router;
918     }
919 
920     function marketingWallet() public view returns(address){
921         return _marketingWallet;
922     }
923 
924     function updateMarketingWallet(address newWallet) external onlyOwner {
925         require(
926             _marketingWallet != newWallet,
927             "You must provide a different address other than the current value in order to update it"
928         );
929         _marketingWallet = newWallet;
930     }
931     
932 
933     // fallbacks
934     receive() external payable {}
935 
936 }