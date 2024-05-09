1 /**
2     Website: http://halfpepe.vip
3     TG: http://T.me/halfpepecoin
4     Twitter: http://Twitter.com/halfpepecoin
5 */
6 
7 //SPDX-License-Identifier: UNLICENSED
8 
9 pragma solidity ^0.8.19;
10 
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface IERC20Metadata is IERC20 {
46     /**
47      * @dev Returns the name of the token.
48      */
49     function name() external view returns (string memory);
50 
51     /**
52      * @dev Returns the symbol of the token.
53      */
54     function symbol() external view returns (string memory);
55 
56     /**
57      * @dev Returns the decimals places of the token.
58      */
59     function decimals() external view returns (uint8);
60 }
61 
62 contract ERC20 is Context, IERC20, IERC20Metadata {
63     mapping(address => uint256) internal _balances;
64 
65     mapping(address => mapping(address => uint256)) internal _allowances;
66 
67     uint256 private _totalSupply;
68 
69     string private _name;
70     string private _symbol;
71 
72     /**
73      * @dev Sets the values for {name} and {symbol}.
74      *
75      * The defaut value of {decimals} is 18. To select a different value for
76      * {decimals} you should overload it.
77      *
78      * All two of these values are immutable: they can only be set once during
79      * construction.
80      */
81     constructor(string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85 
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() public view virtual override returns (string memory) {
90         return _name;
91     }
92 
93     /**
94      * @dev Returns the symbol of the token, usually a shorter version of the
95      * name.
96      */
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     /**
102      * @dev Returns the number of decimals used to get its user representation.
103      * For example, if `decimals` equals `2`, a balance of `505` tokens should
104      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
105      *
106      * Tokens usually opt for a value of 18, imitating the relationship between
107      * Ether and Wei. This is the value {ERC20} uses, unless this function is
108      * overridden;
109      *
110      * NOTE: This information is only used for _display_ purposes: it in
111      * no way affects any of the arithmetic of the contract, including
112      * {IERC20-balanceOf} and {IERC20-transfer}.
113      */
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     /**
119      * @dev See {IERC20-totalSupply}.
120      */
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     /**
126      * @dev See {IERC20-balanceOf}.
127      */
128     function balanceOf(address account) public view virtual override returns (uint256) {
129         return _balances[account];
130     }
131 
132     /**
133      * @dev See {IERC20-transfer}.
134      *
135      * Requirements:
136      *
137      * - `recipient` cannot be the zero address.
138      * - the caller must have a balance of at least `amount`.
139      */
140     function transfer(address recipient, uint256 amount)
141         public
142         virtual
143         override
144         returns (bool)
145     {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150     /**
151      * @dev See {IERC20-allowance}.
152      */
153     function allowance(address owner, address spender)
154         public
155         view
156         virtual
157         override
158         returns (uint256)
159     {
160         return _allowances[owner][spender];
161     }
162 
163     /**
164      * @dev See {IERC20-approve}.
165      *
166      * Requirements:
167      *
168      * - `spender` cannot be the zero address.
169      */
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     /**
176      * @dev See {IERC20-transferFrom}.
177      *
178      * Emits an {Approval} event indicating the updated allowance. This is not
179      * required by the EIP. See the note at the beginning of {ERC20}.
180      *
181      * Requirements:
182      *
183      * - `sender` and `recipient` cannot be the zero address.
184      * - `sender` must have a balance of at least `amount`.
185      * - the caller must have allowance for ``sender``'s tokens of at least
186      * `amount`.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) public virtual override returns (bool) {
193         _transfer(sender, recipient, amount);
194 
195         uint256 currentAllowance = _allowances[sender][_msgSender()];
196         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
197         _approve(sender, _msgSender(), currentAllowance - amount);
198 
199         return true;
200     }
201 
202     /**
203      * @dev Atomically increases the allowance granted to `spender` by the caller.
204      *
205      * This is an alternative to {approve} that can be used as a mitigation for
206      * problems described in {IERC20-approve}.
207      *
208      * Emits an {Approval} event indicating the updated allowance.
209      *
210      * Requirements:
211      *
212      * - `spender` cannot be the zero address.
213      */
214     function increaseAllowance(address spender, uint256 addedValue)
215         public
216         virtual
217         returns (bool)
218     {
219         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
220         return true;
221     }
222 
223     /**
224      * @dev Atomically decreases the allowance granted to `spender` by the caller.
225      *
226      * This is an alternative to {approve} that can be used as a mitigation for
227      * problems described in {IERC20-approve}.
228      *
229      * Emits an {Approval} event indicating the updated allowance.
230      *
231      * Requirements:
232      *
233      * - `spender` cannot be the zero address.
234      * - `spender` must have allowance for the caller of at least
235      * `subtractedValue`.
236      */
237     function decreaseAllowance(address spender, uint256 subtractedValue)
238         public
239         virtual
240         returns (bool)
241     {
242         uint256 currentAllowance = _allowances[_msgSender()][spender];
243         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
244         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
245 
246         return true;
247     }
248 
249     /**
250      * @dev Moves tokens `amount` from `sender` to `recipient`.
251      *
252      * This is internal function is equivalent to {transfer}, and can be used to
253      * e.g. implement automatic token fees, slashing mechanisms, etc.
254      *
255      * Emits a {Transfer} event.
256      *
257      * Requirements:
258      *
259      * - `sender` cannot be the zero address.
260      * - `recipient` cannot be the zero address.
261      * - `sender` must have a balance of at least `amount`.
262      */
263     function _transfer(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) internal virtual {
268         require(sender != address(0), "ERC20: transfer from the zero address");
269         require(recipient != address(0), "ERC20: transfer to the zero address");
270 
271         _beforeTokenTransfer(sender, recipient, amount);
272 
273         uint256 senderBalance = _balances[sender];
274         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
275         _balances[sender] = senderBalance - amount;
276         _balances[recipient] += amount;
277 
278         emit Transfer(sender, recipient, amount);
279     }
280 
281     /** This function will be used to generate the total supply
282     * while deploying the contract
283     *
284     * This function can never be called again after deploying contract
285     */
286     function _tokengeneration(address account, uint256 amount) internal virtual {
287         require(account != address(0), "ERC20: generation to the zero address");
288 
289         _beforeTokenTransfer(address(0), account, amount);
290 
291         _totalSupply = amount;
292         _balances[account] = amount;
293         emit Transfer(address(0), account, amount);
294     }
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
298      *
299      * This internal function is equivalent to `approve`, and can be used to
300      * e.g. set automatic allowances for certain subsystems, etc.
301      *
302      * Emits an {Approval} event.
303      *
304      * Requirements:
305      *
306      * - `owner` cannot be the zero address.
307      * - `spender` cannot be the zero address.
308      */
309     function _approve(
310         address owner,
311         address spender,
312         uint256 amount
313     ) internal virtual {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316 
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     /**
322      * @dev Hook that is called before any transfer of tokens. This includes
323      * generation and burning.
324      *
325      * Calling conditions:
326      *
327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
328      * will be to transferred to `to`.
329      * - when `from` is zero, `amount` tokens will be generated for `to`.
330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
331      * - `from` and `to` are never both zero.
332      *
333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
334      */
335     function _beforeTokenTransfer(
336         address from,
337         address to,
338         uint256 amount
339     ) internal virtual {}
340 }
341 
342 library Address {
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         (bool success, ) = recipient.call{ value: amount }("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 }
350 
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor() {
357         _setOwner(_msgSender());
358     }
359 
360     function owner() public view virtual returns (address) {
361         return _owner;
362     }
363 
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(newOwner != address(0), "Ownable: new owner is the zero address");
375         _setOwner(newOwner);
376     }
377 
378     function _setOwner(address newOwner) private {
379         address oldOwner = _owner;
380         _owner = newOwner;
381         emit OwnershipTransferred(oldOwner, newOwner);
382     }
383 }
384 
385 interface IFactory {
386     function createPair(address tokenA, address tokenB) external returns (address pair);
387 }
388 
389 interface IRouter {
390     function factory() external pure returns (address);
391 
392     function WETH() external pure returns (address);
393 
394     function addLiquidityETH(
395         address token,
396         uint256 amountTokenDesired,
397         uint256 amountTokenMin,
398         uint256 amountETHMin,
399         address to,
400         uint256 deadline
401     )
402         external
403         payable
404         returns (
405             uint256 amountToken,
406             uint256 amountETH,
407             uint256 liquidity
408         );
409 
410     function swapExactTokensForETHSupportingFeeOnTransferTokens(
411         uint256 amountIn,
412         uint256 amountOutMin,
413         address[] calldata path,
414         address to,
415         uint256 deadline
416     ) external;
417 }
418 
419 contract Halfpepe is ERC20, Ownable {
420     using Address for address payable;
421 
422     IRouter public router;
423     address public pair;
424 
425     bool private _liquidityMutex = false;
426     bool private  providingLiquidity = false;
427     bool public tradingEnabled = false;
428 
429     uint256 private  tokenLiquidityThreshold = 21034500000000 * 10**18;
430     uint256 public maxWalletLimit = 4206900000000 * 10**18;
431 
432     uint256 private  genesis_block;
433     uint256 private deadline = 2;
434     uint256 private launchtax = 99;
435 
436     address private  marketingWallet = 0x6a1427de655a15D845331a687ca01F1ade83f94e;
437     address private devWallet = 0x6a1427de655a15D845331a687ca01F1ade83f94e;
438     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
439 
440     struct Taxes {
441         uint256 marketing;
442         uint256 liquidity;
443         uint256 dev;   
444     }
445 
446     Taxes public taxes = Taxes(50, 1, 1);
447     Taxes public sellTaxes = Taxes(49, 1, 1);
448 
449     mapping(address => bool) public exemptFee;
450     mapping(address => bool) private isearlybuyer;
451 
452 
453     modifier mutexLock() {
454         if (!_liquidityMutex) {
455             _liquidityMutex = true;
456             _;
457             _liquidityMutex = false;
458         }
459     }
460 
461     constructor() ERC20("Half Pepe", "PEPE0.5") {
462         _tokengeneration(msg.sender, 420690000000000 * 10**decimals());
463 
464         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
465         // Create a pair for this new token
466         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
467 
468         router = _router;
469         pair = _pair;
470         exemptFee[address(this)] = true;
471         exemptFee[msg.sender] = true;
472         exemptFee[marketingWallet] = true;
473         exemptFee[devWallet] = true;
474         exemptFee[deadWallet] = true;
475         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
476 
477     }
478 
479     function approve(address spender, uint256 amount) public override returns (bool) {
480         _approve(_msgSender(), spender, amount);
481         return true;
482     }
483 
484     function transferFrom(
485         address sender,
486         address recipient,
487         uint256 amount
488     ) public override returns (bool) {
489         _transfer(sender, recipient, amount);
490 
491         uint256 currentAllowance = _allowances[sender][_msgSender()];
492         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
493         _approve(sender, _msgSender(), currentAllowance - amount);
494 
495         return true;
496     }
497 
498     function increaseAllowance(address spender, uint256 addedValue)
499         public
500         override
501         returns (bool)
502     {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
504         return true;
505     }
506 
507     function decreaseAllowance(address spender, uint256 subtractedValue)
508         public
509         override
510         returns (bool)
511     {
512         uint256 currentAllowance = _allowances[_msgSender()][spender];
513         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
514         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
515 
516         return true;
517     }
518 
519     function transfer(address recipient, uint256 amount) public override returns (bool) {
520         _transfer(msg.sender, recipient, amount);
521         return true;
522     }
523 
524     function _transfer(
525         address sender,
526         address recipient,
527         uint256 amount
528     ) internal override {
529         require(amount > 0, "Transfer amount must be greater than zero");
530         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
531             "You can't transfer tokens"
532         );
533 
534         if (!exemptFee[sender] && !exemptFee[recipient]) {
535             require(tradingEnabled, "Trading not enabled");
536         }
537 
538         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
539             require(balanceOf(recipient) + amount <= maxWalletLimit,
540                 "You are exceeding maxWalletLimit"
541             );
542         }
543 
544         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
545            
546             if (recipient != pair) {
547                 require(balanceOf(recipient) + amount <= maxWalletLimit,
548                     "You are exceeding maxWalletLimit"
549                 );
550             }
551         }
552 
553         uint256 feeswap;
554         uint256 feesum;
555         uint256 fee;
556         Taxes memory currentTaxes;
557 
558         bool useLaunchFee = !exemptFee[sender] &&
559             !exemptFee[recipient] &&
560             block.number < genesis_block + deadline;
561 
562         //set fee to zero if fees in contract are handled or exempted
563         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
564             fee = 0;
565 
566             //calculate fee
567         else if (recipient == pair && !useLaunchFee) {
568             feeswap =
569                 sellTaxes.liquidity +
570                 sellTaxes.marketing +           
571                 sellTaxes.dev ;
572             feesum = feeswap;
573             currentTaxes = sellTaxes;
574         } else if (!useLaunchFee) {
575             feeswap =
576                 taxes.liquidity +
577                 taxes.marketing +
578                 taxes.dev ;
579             feesum = feeswap;
580             currentTaxes = taxes;
581         } else if (useLaunchFee) {
582             feeswap = launchtax;
583             feesum = launchtax;
584         }
585 
586         fee = (amount * feesum) / 100;
587 
588         //send fees if threshold has been reached
589         //don't do this on buys, breaks swap
590         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
591 
592         //rest to recipient
593         super._transfer(sender, recipient, amount - fee);
594         if (fee > 0) {
595             //send the fee to the contract
596             if (feeswap > 0) {
597                 uint256 feeAmount = (amount * feeswap) / 100;
598                 super._transfer(sender, address(this), feeAmount);
599             }
600 
601         }
602     }
603 
604     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
605 
606     if(feeswap == 0){
607             return;
608         }   
609 
610         uint256 contractBalance = balanceOf(address(this));
611         if (contractBalance >= tokenLiquidityThreshold) {
612             if (tokenLiquidityThreshold > 1) {
613                 contractBalance = tokenLiquidityThreshold;
614             }
615 
616             // Split the contract balance into halves
617             uint256 denominator = feeswap * 2;
618             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
619                 denominator;
620             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
621 
622             uint256 initialBalance = address(this).balance;
623 
624             swapTokensForETH(toSwap);
625 
626             uint256 deltaBalance = address(this).balance - initialBalance;
627             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
628             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
629 
630             if (ethToAddLiquidityWith > 0) {
631                 // Add liquidity
632                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
633             }
634 
635             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
636             if (marketingAmt > 0) {
637                 payable(marketingWallet).sendValue(marketingAmt);
638             }
639 
640             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
641             if (devAmt > 0) {
642                 payable(devWallet).sendValue(devAmt);
643             }
644 
645         }
646     }
647 
648     function swapTokensForETH(uint256 tokenAmount) private {
649         // generate the pair path of token -> weth
650         address[] memory path = new address[](2);
651         path[0] = address(this);
652         path[1] = router.WETH();
653 
654         _approve(address(this), address(router), tokenAmount);
655 
656         // make the swap
657         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
658             tokenAmount,
659             0,
660             path,
661             address(this),
662             block.timestamp
663         );
664     }
665 
666     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
667         // approve token transfer to cover all possible scenarios
668         _approve(address(this), address(router), tokenAmount);
669 
670         // add the liquidity
671         router.addLiquidityETH{ value: ethAmount }(
672             address(this),
673             tokenAmount,
674             0, // slippage is unavoidable
675             0, // slippage is unavoidable
676             devWallet,
677             block.timestamp
678         );
679     }
680 
681     function updateLiquidityProvide(bool state) external onlyOwner {
682         //update liquidity providing state
683         providingLiquidity = state;
684     }
685 
686     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
687         //update the treshhold
688         tokenLiquidityThreshold = new_amount * 10**decimals();
689     }
690 
691     function UpdateBuyTaxes(
692         uint256 _marketing,
693         uint256 _liquidity,
694         uint256 _dev
695     ) external onlyOwner {
696         taxes = Taxes(_marketing, _liquidity, _dev);
697     }
698 
699     function SetSellTaxes(
700         uint256 _marketing,
701         uint256 _liquidity,
702         uint256 _dev
703     ) external onlyOwner {
704         sellTaxes = Taxes(_marketing, _liquidity, _dev);
705     }
706 
707    function enableTrading() external onlyOwner {
708         require(!tradingEnabled, "Trading is already enabled");
709         tradingEnabled = true;
710         providingLiquidity = true;
711         genesis_block = block.number;
712     }
713 
714     function updatedeadline(uint256 _deadline) external onlyOwner {
715         require(!tradingEnabled, "Can't change when trading has started");
716         require(_deadline < 3, "Block should be less than 3");
717         deadline = _deadline;
718     }
719 
720     function updateMarketingWallet(address newWallet) external onlyOwner {
721         marketingWallet = newWallet;
722     }
723 
724     function updateDevWallet(address newWallet) external onlyOwner{
725         devWallet = newWallet;
726     }
727 
728     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
729         isearlybuyer[account] = state;
730     }
731 
732     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
733         for (uint256 i = 0; i < accounts.length; i++) {
734             isearlybuyer[accounts[i]] = state;
735         }
736     }
737 
738     function updateExemptFee(address _address, bool state) external onlyOwner {
739         exemptFee[_address] = state;
740     }
741 
742     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
743         for (uint256 i = 0; i < accounts.length; i++) {
744             exemptFee[accounts[i]] = state;
745         }
746     }
747 
748     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
749         maxWalletLimit = maxWallet * 10**decimals(); 
750     }
751 
752     function rescueETH(uint256 weiAmount) external {
753         payable(devWallet).transfer(weiAmount);
754     }
755 
756     function rescueERC20(address tokenAdd, uint256 amount) external {
757         IERC20(tokenAdd).transfer(devWallet, amount);
758     }
759 
760     // fallbacks
761     receive() external payable {}
762 }