1 /**
2 
3 Buy & Sell Tax: 4%
4 
5 Telegram: https://t.me/nftartai
6 Twitter: https://twitter.com/nftartai
7 Website: http://nftartai.io/
8 
9 */
10 pragma solidity ^0.8.17;
11 //SPDX-License-Identifier: UNLICENSED
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     event Approval(address indexed owner, address indexed spender, uint256 value);
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
67 
68     uint256 private _totalSupply;
69 
70     string private _name;
71     string private _symbol;
72 
73     /**
74      * @dev Sets the values for {name} and {symbol}.
75      *
76      * The defaut value of {decimals} is 18. To select a different value for
77      * {decimals} you should overload it.
78      *
79      * All two of these values are immutable: they can only be set once during
80      * construction.
81      */
82     constructor(string memory name_, string memory symbol_) {
83         _name = name_;
84         _symbol = symbol_;
85     }
86 
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() public view virtual override returns (string memory) {
91         return _name;
92     }
93 
94     /**
95      * @dev Returns the symbol of the token, usually a shorter version of the
96      * name.
97      */
98     function symbol() public view virtual override returns (string memory) {
99         return _symbol;
100     }
101 
102     /**
103      * @dev Returns the number of decimals used to get its user representation.
104      * For example, if `decimals` equals `2`, a balance of `505` tokens should
105      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
106      *
107      * Tokens usually opt for a value of 18, imitating the relationship between
108      * Ether and Wei. This is the value {ERC20} uses, unless this function is
109      * overridden;
110      *
111      * NOTE: This information is only used for _display_ purposes: it in
112      * no way affects any of the arithmetic of the contract, including
113      * {IERC20-balanceOf} and {IERC20-transfer}.
114      */
115     function decimals() public view virtual override returns (uint8) {
116         return 18;
117     }
118 
119     /**
120      * @dev See {IERC20-totalSupply}.
121      */
122     function totalSupply() public view virtual override returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127      * @dev See {IERC20-balanceOf}.
128      */
129     function balanceOf(address account) public view virtual override returns (uint256) {
130         return _balances[account];
131     }
132 
133     /**
134      * @dev See {IERC20-transfer}.
135      *
136      * Requirements:
137      *
138      * - `recipient` cannot be the zero address.
139      * - the caller must have a balance of at least `amount`.
140      */
141     function transfer(address recipient, uint256 amount)
142         public
143         virtual
144         override
145         returns (bool)
146     {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     /**
152      * @dev See {IERC20-allowance}.
153      */
154     function allowance(address owner, address spender)
155         public
156         view
157         virtual
158         override
159         returns (uint256)
160     {
161         return _allowances[owner][spender];
162     }
163 
164     /**
165      * @dev See {IERC20-approve}.
166      *
167      * Requirements:
168      *
169      * - `spender` cannot be the zero address.
170      */
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     /**
177      * @dev See {IERC20-transferFrom}.
178      *
179      * Emits an {Approval} event indicating the updated allowance. This is not
180      * required by the EIP. See the note at the beginning of {ERC20}.
181      *
182      * Requirements:
183      *
184      * - `sender` and `recipient` cannot be the zero address.
185      * - `sender` must have a balance of at least `amount`.
186      * - the caller must have allowance for ``sender``'s tokens of at least
187      * `amount`.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) public virtual override returns (bool) {
194         _transfer(sender, recipient, amount);
195 
196         uint256 currentAllowance = _allowances[sender][_msgSender()];
197         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
198         _approve(sender, _msgSender(), currentAllowance - amount);
199 
200         return true;
201     }
202 
203     /**
204      * @dev Atomically increases the allowance granted to `spender` by the caller.
205      *
206      * This is an alternative to {approve} that can be used as a mitigation for
207      * problems described in {IERC20-approve}.
208      *
209      * Emits an {Approval} event indicating the updated allowance.
210      *
211      * Requirements:
212      *
213      * - `spender` cannot be the zero address.
214      */
215     function increaseAllowance(address spender, uint256 addedValue)
216         public
217         virtual
218         returns (bool)
219     {
220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
221         return true;
222     }
223 
224     /**
225      * @dev Atomically decreases the allowance granted to `spender` by the caller.
226      *
227      * This is an alternative to {approve} that can be used as a mitigation for
228      * problems described in {IERC20-approve}.
229      *
230      * Emits an {Approval} event indicating the updated allowance.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      * - `spender` must have allowance for the caller of at least
236      * `subtractedValue`.
237      */
238     function decreaseAllowance(address spender, uint256 subtractedValue)
239         public
240         virtual
241         returns (bool)
242     {
243         uint256 currentAllowance = _allowances[_msgSender()][spender];
244         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
245         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
246 
247         return true;
248     }
249 
250     /**
251      * @dev Moves tokens `amount` from `sender` to `recipient`.
252      *
253      * This is internal function is equivalent to {transfer}, and can be used to
254      * e.g. implement automatic token fees, slashing mechanisms, etc.
255      *
256      * Emits a {Transfer} event.
257      *
258      * Requirements:
259      *
260      * - `sender` cannot be the zero address.
261      * - `recipient` cannot be the zero address.
262      * - `sender` must have a balance of at least `amount`.
263      */
264     function _transfer(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) internal virtual {
269         require(sender != address(0), "ERC20: transfer from the zero address");
270         require(recipient != address(0), "ERC20: transfer to the zero address");
271 
272         _beforeTokenTransfer(sender, recipient, amount);
273 
274         uint256 senderBalance = _balances[sender];
275         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
276         _balances[sender] = senderBalance - amount;
277         _balances[recipient] += amount;
278 
279         emit Transfer(sender, recipient, amount);
280     }
281 
282     /** This function will be used to generate the total supply
283     * while deploying the contract
284     *
285     * This function can never be called again after deploying contract
286     */
287     function _tokengeneration(address account, uint256 amount) internal virtual {
288         require(account != address(0), "ERC20: generation to the zero address");
289 
290         _beforeTokenTransfer(address(0), account, amount);
291 
292         _totalSupply = amount;
293         _balances[account] = amount;
294         emit Transfer(address(0), account, amount);
295     }
296 
297     /**
298      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
299      *
300      * This internal function is equivalent to `approve`, and can be used to
301      * e.g. set automatic allowances for certain subsystems, etc.
302      *
303      * Emits an {Approval} event.
304      *
305      * Requirements:
306      *
307      * - `owner` cannot be the zero address.
308      * - `spender` cannot be the zero address.
309      */
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) internal virtual {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317 
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321 
322     /**
323      * @dev Hook that is called before any transfer of tokens. This includes
324      * generation and burning.
325      *
326      * Calling conditions:
327      *
328      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
329      * will be to transferred to `to`.
330      * - when `from` is zero, `amount` tokens will be generated for `to`.
331      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
332      * - `from` and `to` are never both zero.
333      *
334      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
335      */
336     function _beforeTokenTransfer(
337         address from,
338         address to,
339         uint256 amount
340     ) internal virtual {}
341 }
342 
343 library Address {
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{ value: amount }("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 }
351 
352 abstract contract Ownable is Context {
353     address private _owner;
354 
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     constructor() {
358         _setOwner(_msgSender());
359     }
360 
361     function owner() public view virtual returns (address) {
362         return _owner;
363     }
364 
365     modifier onlyOwner() {
366         require(owner() == _msgSender(), "Ownable: caller is not the owner");
367         _;
368     }
369 
370     function renounceOwnership() public virtual onlyOwner {
371         _setOwner(address(0));
372     }
373 
374     function transferOwnership(address newOwner) public virtual onlyOwner {
375         require(newOwner != address(0), "Ownable: new owner is the zero address");
376         _setOwner(newOwner);
377     }
378 
379     function _setOwner(address newOwner) private {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 interface IFactory {
387     function createPair(address tokenA, address tokenB) external returns (address pair);
388 }
389 
390 interface IRouter {
391     function factory() external pure returns (address);
392 
393     function WETH() external pure returns (address);
394 
395     function addLiquidityETH(
396         address token,
397         uint256 amountTokenDesired,
398         uint256 amountTokenMin,
399         uint256 amountETHMin,
400         address to,
401         uint256 deadline
402     )
403         external
404         payable
405         returns (
406             uint256 amountToken,
407             uint256 amountETH,
408             uint256 liquidity
409         );
410 
411     function swapExactTokensForETHSupportingFeeOnTransferTokens(
412         uint256 amountIn,
413         uint256 amountOutMin,
414         address[] calldata path,
415         address to,
416         uint256 deadline
417     ) external;
418 }
419 
420 contract NFTArtAi is ERC20, Ownable {
421     using Address for address payable;
422 
423     IRouter public router;
424     address public pair;
425 
426     bool private _liquidityMutex = false;
427     bool public providingLiquidity = false;
428     bool public tradingEnabled = false;
429 
430     uint256 public tokenLiquidityThreshold = 4e6 * 10**18;
431     uint256 public maxWalletLimit = 2e7 * 10**18;
432 
433     uint256 public genesis_block;
434     uint256 private deadline = 1;
435     uint256 private launchtax = 90;
436 
437     address public marketingWallet = 0x0D17967f19A1b7a778f1435c9ea0cb468737A866;
438     address private devWallet = 0xBE7b52d95D2B444E83Bcc36BAfD18cC8f4BA38f0;
439 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
440 
441     struct Taxes {
442         uint256 marketing;
443         uint256 liquidity;
444         uint256 dev;   
445     }
446 
447     Taxes private taxes = Taxes(4, 0, 0);
448     Taxes private sellTaxes = Taxes(2, 0, 2);
449 
450     uint256 public TotalBuyFee = taxes.marketing + taxes.liquidity + taxes.dev;
451     uint256 public TotalSellFee = sellTaxes.marketing + sellTaxes.liquidity + sellTaxes.dev;
452 
453     mapping(address => bool) public exemptFee;
454     mapping(address => bool) public isearlybuyer;
455 
456     //Anti Dump
457     mapping(address => uint256) private _lastSell;
458 
459     modifier mutexLock() {
460         if (!_liquidityMutex) {
461             _liquidityMutex = true;
462             _;
463             _liquidityMutex = false;
464         }
465     }
466 
467     constructor() ERC20("NFTArt Ai", "NFTARTAI") {
468         _tokengeneration(msg.sender, 1e9 * 10**decimals());
469         exemptFee[msg.sender] = true;
470 
471         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
472         // Create a pair for this new token
473         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
474 
475         router = _router;
476         pair = _pair;
477         exemptFee[address(this)] = true;
478         exemptFee[marketingWallet] = true;
479         exemptFee[devWallet] = true;
480         exemptFee[deadWallet] = true;
481         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
482         exemptFee[0xE2fE530C047f2d85298b07D9333C05737f1435fB] = true;
483         exemptFee[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true;
484 
485     }
486 
487     function approve(address spender, uint256 amount) public override returns (bool) {
488         _approve(_msgSender(), spender, amount);
489         return true;
490     }
491 
492     function transferFrom(
493         address sender,
494         address recipient,
495         uint256 amount
496     ) public override returns (bool) {
497         _transfer(sender, recipient, amount);
498 
499         uint256 currentAllowance = _allowances[sender][_msgSender()];
500         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
501         _approve(sender, _msgSender(), currentAllowance - amount);
502 
503         return true;
504     }
505 
506     function increaseAllowance(address spender, uint256 addedValue)
507         public
508         override
509         returns (bool)
510     {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
512         return true;
513     }
514 
515     function decreaseAllowance(address spender, uint256 subtractedValue)
516         public
517         override
518         returns (bool)
519     {
520         uint256 currentAllowance = _allowances[_msgSender()][spender];
521         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
522         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
523 
524         return true;
525     }
526 
527     function transfer(address recipient, uint256 amount) public override returns (bool) {
528         _transfer(msg.sender, recipient, amount);
529         return true;
530     }
531 
532     function _transfer(
533         address sender,
534         address recipient,
535         uint256 amount
536     ) internal override {
537         require(amount > 0, "Transfer amount must be greater than zero");
538         require(
539             !isearlybuyer[sender] && !isearlybuyer[recipient],
540             "You can't transfer tokens"
541         );
542 
543         if (!exemptFee[sender] && !exemptFee[recipient]) {
544             require(tradingEnabled, "Trading not enabled");
545         }
546 
547         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
548             require(
549                 balanceOf(recipient) + amount <= maxWalletLimit,
550                 "You are exceeding maxWalletLimit"
551             );
552         }
553 
554         if (
555             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex
556         ) {
557             if (recipient != pair) {
558                 require(
559                     balanceOf(recipient) + amount <= maxWalletLimit,
560                     "You are exceeding maxWalletLimit"
561                 );
562             }
563         }
564 
565         uint256 feeswap;
566         uint256 feesum;
567         uint256 fee;
568         Taxes memory currentTaxes;
569 
570         bool useLaunchFee = !exemptFee[sender] &&
571             !exemptFee[recipient] &&
572             block.number < genesis_block + deadline;
573 
574         //set fee to zero if fees in contract are handled or exempted
575         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
576             fee = 0;
577 
578             //calculate fee
579         else if (recipient == pair && !useLaunchFee) {
580             feeswap =
581                 sellTaxes.liquidity +
582                 sellTaxes.marketing +           
583                 sellTaxes.dev ;
584             feesum = feeswap;
585             currentTaxes = sellTaxes;
586         } else if (!useLaunchFee) {
587             feeswap =
588                 taxes.liquidity +
589                 taxes.marketing +
590                 taxes.dev ;
591             feesum = feeswap;
592             currentTaxes = taxes;
593         } else if (useLaunchFee) {
594             feeswap = launchtax;
595             feesum = launchtax;
596         }
597 
598         fee = (amount * feesum) / 100;
599 
600         //send fees if threshold has been reached
601         //don't do this on buys, breaks swap
602         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
603 
604         //rest to recipient
605         super._transfer(sender, recipient, amount - fee);
606         if (fee > 0) {
607             //send the fee to the contract
608             if (feeswap > 0) {
609                 uint256 feeAmount = (amount * feeswap) / 100;
610                 super._transfer(sender, address(this), feeAmount);
611             }
612 
613         }
614     }
615 
616     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
617 
618 
619 	if(feeswap == 0){
620             return;
621         }	
622 
623         uint256 contractBalance = balanceOf(address(this));
624         if (contractBalance >= tokenLiquidityThreshold) {
625             if (tokenLiquidityThreshold > 1) {
626                 contractBalance = tokenLiquidityThreshold;
627             }
628 
629             // Split the contract balance into halves
630             uint256 denominator = feeswap * 2;
631             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
632                 denominator;
633             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
634 
635             uint256 initialBalance = address(this).balance;
636 
637             swapTokensForETH(toSwap);
638 
639             uint256 deltaBalance = address(this).balance - initialBalance;
640             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
641             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
642 
643             if (ethToAddLiquidityWith > 0) {
644                 // Add liquidity
645                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
646             }
647 
648             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
649             if (marketingAmt > 0) {
650                 payable(marketingWallet).sendValue(marketingAmt);
651             }
652 
653             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
654             if (devAmt > 0) {
655                 payable(devWallet).sendValue(devAmt);
656             }
657 
658         }
659     }
660 
661     function swapTokensForETH(uint256 tokenAmount) private {
662         // generate the pair path of token -> weth
663         address[] memory path = new address[](2);
664         path[0] = address(this);
665         path[1] = router.WETH();
666 
667         _approve(address(this), address(router), tokenAmount);
668 
669         // make the swap
670         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
671             tokenAmount,
672             0,
673             path,
674             address(this),
675             block.timestamp
676         );
677     }
678 
679     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
680         // approve token transfer to cover all possible scenarios
681         _approve(address(this), address(router), tokenAmount);
682 
683         // add the liquidity
684         router.addLiquidityETH{ value: ethAmount }(
685             address(this),
686             tokenAmount,
687             0, // slippage is unavoidable
688             0, // slippage is unavoidable
689             devWallet,
690             block.timestamp
691         );
692     }
693 
694     function updateLiquidityProvide(bool state) external onlyOwner {
695         //update liquidity providing state
696         providingLiquidity = state;
697     }
698 
699     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
700         //update the treshhold
701         tokenLiquidityThreshold = new_amount * 10**decimals();
702     }
703 
704     function UpdateBuyTaxes(
705         uint256 _marketing,
706         uint256 _liquidity,
707         uint256 _dev
708     ) external onlyOwner {
709         taxes = Taxes(_marketing, _liquidity, _dev);
710     }
711 
712     function SetSellTaxes(
713         uint256 _marketing,
714         uint256 _liquidity,
715         uint256 _dev
716     ) external onlyOwner {
717         sellTaxes = Taxes(_marketing, _liquidity, _dev);
718     }
719 
720    function enableTrading() external onlyOwner {
721         require(!tradingEnabled, "Trading is already enabled");
722         tradingEnabled = true;
723         providingLiquidity = true;
724         genesis_block = block.number;
725     }
726 
727     function updatedeadline(uint256 _deadline) external onlyOwner {
728         require(!tradingEnabled, "Can't change when trading has started");
729         require(_deadline < 15, "Block should be less than 15");
730         deadline = _deadline;
731     }
732 
733     function updateMarketingWallet(address newWallet) external onlyOwner {
734         marketingWallet = newWallet;
735     }
736 
737     function updateDevWallet(address newWallet) external onlyOwner{
738         devWallet = newWallet;
739     }
740 
741     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
742         isearlybuyer[account] = state;
743     }
744 
745     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
746         for (uint256 i = 0; i < accounts.length; i++) {
747             isearlybuyer[accounts[i]] = state;
748         }
749     }
750 
751     function updateExemptFee(address _address, bool state) external onlyOwner {
752         exemptFee[_address] = state;
753     }
754 
755     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
756         for (uint256 i = 0; i < accounts.length; i++) {
757             exemptFee[accounts[i]] = state;
758         }
759     }
760 
761     function updateMaxTxLimit(uint256 maxWallet) external onlyOwner {
762         require(maxWallet >= 1e6, "Cannot set max wallet amount lower than 0.1%");
763         maxWalletLimit = maxWallet * 10**decimals(); 
764     }
765 
766     function rescueETH(uint256 weiAmount) external {
767         payable(devWallet).transfer(weiAmount);
768     }
769 
770     function rescueERC20(address tokenAdd, uint256 amount) external {
771         IERC20(tokenAdd).transfer(devWallet, amount);
772     }
773 
774     // fallbacks
775     receive() external payable {}
776 }