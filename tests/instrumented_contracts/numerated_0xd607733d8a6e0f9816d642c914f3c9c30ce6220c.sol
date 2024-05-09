1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.7;
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
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 interface IERC20Metadata is IERC20 {
38     /**
39      * @dev Returns the name of the token.
40      */
41     function name() external view returns (string memory);
42 
43     /**
44      * @dev Returns the symbol of the token.
45      */
46     function symbol() external view returns (string memory);
47 
48     /**
49      * @dev Returns the decimals places of the token.
50      */
51     function decimals() external view returns (uint8);
52 }
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     mapping(address => uint256) internal _balances;
56 
57     mapping(address => mapping(address => uint256)) internal _allowances;
58 
59     uint256 private _totalSupply;
60 
61     string private _name;
62     string private _symbol;
63 
64     /**
65      * @dev Sets the values for {name} and {symbol}.
66      *
67      * The defaut value of {decimals} is 18. To select a different value for
68      * {decimals} you should overload it.
69      *
70      * All two of these values are immutable: they can only be set once during
71      * construction.
72      */
73     constructor(string memory name_, string memory symbol_) {
74         _name = name_;
75         _symbol = symbol_;
76     }
77 
78     /**
79      * @dev Returns the name of the token.
80      */
81     function name() public view virtual override returns (string memory) {
82         return _name;
83     }
84 
85     /**
86      * @dev Returns the symbol of the token, usually a shorter version of the
87      * name.
88      */
89     function symbol() public view virtual override returns (string memory) {
90         return _symbol;
91     }
92 
93     /**
94      * @dev Returns the number of decimals used to get its user representation.
95      * For example, if `decimals` equals `2`, a balance of `505` tokens should
96      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
97      *
98      * Tokens usually opt for a value of 18, imitating the relationship between
99      * Ether and Wei. This is the value {ERC20} uses, unless this function is
100      * overridden;
101      *
102      * NOTE: This information is only used for _display_ purposes: it in
103      * no way affects any of the arithmetic of the contract, including
104      * {IERC20-balanceOf} and {IERC20-transfer}.
105      */
106     function decimals() public view virtual override returns (uint8) {
107         return 18;
108     }
109 
110     /**
111      * @dev See {IERC20-totalSupply}.
112      */
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev See {IERC20-balanceOf}.
119      */
120     function balanceOf(address account) public view virtual override returns (uint256) {
121         return _balances[account];
122     }
123 
124     /**
125      * @dev See {IERC20-transfer}.
126      *
127      * Requirements:
128      *
129      * - `recipient` cannot be the zero address.
130      * - the caller must have a balance of at least `amount`.
131      */
132     function transfer(address recipient, uint256 amount)
133         public
134         virtual
135         override
136         returns (bool)
137     {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     /**
143      * @dev See {IERC20-allowance}.
144      */
145     function allowance(address owner, address spender)
146         public
147         view
148         virtual
149         override
150         returns (uint256)
151     {
152         return _allowances[owner][spender];
153     }
154 
155     /**
156      * @dev See {IERC20-approve}.
157      *
158      * Requirements:
159      *
160      * - `spender` cannot be the zero address.
161      */
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     /**
168      * @dev See {IERC20-transferFrom}.
169      *
170      * Emits an {Approval} event indicating the updated allowance. This is not
171      * required by the EIP. See the note at the beginning of {ERC20}.
172      *
173      * Requirements:
174      *
175      * - `sender` and `recipient` cannot be the zero address.
176      * - `sender` must have a balance of at least `amount`.
177      * - the caller must have allowance for ``sender``'s tokens of at least
178      * `amount`.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         _approve(sender, _msgSender(), currentAllowance - amount);
190 
191         return true;
192     }
193 
194     /**
195      * @dev Atomically increases the allowance granted to `spender` by the caller.
196      *
197      * This is an alternative to {approve} that can be used as a mitigation for
198      * problems described in {IERC20-approve}.
199      *
200      * Emits an {Approval} event indicating the updated allowance.
201      *
202      * Requirements:
203      *
204      * - `spender` cannot be the zero address.
205      */
206     function increaseAllowance(address spender, uint256 addedValue)
207         public
208         virtual
209         returns (bool)
210     {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
212         return true;
213     }
214 
215     /**
216      * @dev Atomically decreases the allowance granted to `spender` by the caller.
217      *
218      * This is an alternative to {approve} that can be used as a mitigation for
219      * problems described in {IERC20-approve}.
220      *
221      * Emits an {Approval} event indicating the updated allowance.
222      *
223      * Requirements:
224      *
225      * - `spender` cannot be the zero address.
226      * - `spender` must have allowance for the caller of at least
227      * `subtractedValue`.
228      */
229     function decreaseAllowance(address spender, uint256 subtractedValue)
230         public
231         virtual
232         returns (bool)
233     {
234         uint256 currentAllowance = _allowances[_msgSender()][spender];
235         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
236         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
237 
238         return true;
239     }
240 
241     /**
242      * @dev Moves tokens `amount` from `sender` to `recipient`.
243      *
244      * This is internal function is equivalent to {transfer}, and can be used to
245      * e.g. implement automatic token fees, slashing mechanisms, etc.
246      *
247      * Emits a {Transfer} event.
248      *
249      * Requirements:
250      *
251      * - `sender` cannot be the zero address.
252      * - `recipient` cannot be the zero address.
253      * - `sender` must have a balance of at least `amount`.
254      */
255     function _transfer(
256         address sender,
257         address recipient,
258         uint256 amount
259     ) internal virtual {
260         require(sender != address(0), "ERC20: transfer from the zero address");
261         require(recipient != address(0), "ERC20: transfer to the zero address");
262 
263         _beforeTokenTransfer(sender, recipient, amount);
264 
265         uint256 senderBalance = _balances[sender];
266         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
267         _balances[sender] = senderBalance - amount;
268         _balances[recipient] += amount;
269 
270         emit Transfer(sender, recipient, amount);
271     }
272 
273     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
274      * the total supply.
275      *
276      * Emits a {Transfer} event with `from` set to the zero address.
277      *
278      * Requirements:
279      *
280      * - `to` cannot be the zero address.
281      */
282     function _tokengeneration(address account, uint256 amount) internal virtual {
283         require(account != address(0), "ERC20: generation to the zero address");
284 
285         _beforeTokenTransfer(address(0), account, amount);
286 
287         _totalSupply += amount;
288         _balances[account] += amount;
289         emit Transfer(address(0), account, amount);
290     }
291 
292     /**
293      * @dev Destroys `amount` tokens from `account`, reducing the
294      * total supply.
295      *
296      * Emits a {Transfer} event with `to` set to the zero address.
297      *
298      * Requirements:
299      *
300      * - `account` cannot be the zero address.
301      * - `account` must have at least `amount` tokens.
302      */
303     function _burn(address account, uint256 amount) internal virtual {
304         require(account != address(0), "ERC20: burn from the zero address");
305 
306         _beforeTokenTransfer(account, address(0), amount);
307 
308         uint256 accountBalance = _balances[account];
309         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
310         _balances[account] = accountBalance - amount;
311         _totalSupply -= amount;
312 
313         emit Transfer(account, address(0), amount);
314     }
315 
316     /**
317      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
318      *
319      * This internal function is equivalent to `approve`, and can be used to
320      * e.g. set automatic allowances for certain subsystems, etc.
321      *
322      * Emits an {Approval} event.
323      *
324      * Requirements:
325      *
326      * - `owner` cannot be the zero address.
327      * - `spender` cannot be the zero address.
328      */
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) internal virtual {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336 
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340 
341     /**
342      * @dev Hook that is called before any transfer of tokens. This includes
343      * generation and burning.
344      *
345      * Calling conditions:
346      *
347      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
348      * will be to transferred to `to`.
349      * - when `from` is zero, `amount` tokens will be generated for `to`.
350      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
351      * - `from` and `to` are never both zero.
352      *
353      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
354      */
355     function _beforeTokenTransfer(
356         address from,
357         address to,
358         uint256 amount
359     ) internal virtual {}
360 }
361 
362 library Address {
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{ value: amount }("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 }
370 
371 abstract contract Ownable is Context {
372     address private _owner;
373 
374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376     constructor() {
377         _setOwner(_msgSender());
378     }
379 
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     modifier onlyOwner() {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386         _;
387     }
388 
389     function renounceOwnership() public virtual onlyOwner {
390         _setOwner(address(0));
391     }
392 
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         _setOwner(newOwner);
396     }
397 
398     function _setOwner(address newOwner) private {
399         address oldOwner = _owner;
400         _owner = newOwner;
401         emit OwnershipTransferred(oldOwner, newOwner);
402     }
403 }
404 
405 interface IFactory {
406     function createPair(address tokenA, address tokenB) external returns (address pair);
407 }
408 
409 interface IRouter {
410     function factory() external pure returns (address);
411 
412     function WETH() external pure returns (address);
413 
414     function addLiquidityETH(
415         address token,
416         uint256 amountTokenDesired,
417         uint256 amountTokenMin,
418         uint256 amountETHMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         payable
424         returns (
425             uint256 amountToken,
426             uint256 amountETH,
427             uint256 liquidity
428         );
429 
430     function swapExactTokensForETHSupportingFeeOnTransferTokens(
431         uint256 amountIn,
432         uint256 amountOutMin,
433         address[] calldata path,
434         address to,
435         uint256 deadline
436     ) external;
437 }
438 
439 contract Jokerinu is ERC20, Ownable {
440     using Address for address payable;
441 
442     IRouter public router;
443     address public pair;
444 
445     bool private _liquidityMutex = false;
446     bool public providingLiquidity = false;
447     bool public tradingEnabled = false;
448 
449     uint256 public tokenLiquidityThreshold = 250_000_000 * 10**18;
450     uint256 public maxBuyLimit = 1_000_000_000 * 10**18;
451     uint256 public maxSellLimit = 1_000_000_000 * 10**18;
452     uint256 public maxWalletLimit = 2_000_000_000 * 10**18;
453 
454     uint256 public genesis_block;
455     uint256 private deadline;
456     uint256 private launchtax;
457 
458     address public marketingWallet = 0x06607bF9AAC33605F4Bf0480d582902756dC9341;
459     address public devWallet = 0xc25166e92903390570f2C2315024317d9eAC842f;
460     address public opsWallet = 0x2631AF698376054D2E1f586a0Ed6aF37564ec406;
461     address public raffleWallet = 0x999648a6ee9062973cC499E93AceFAfc16BEE9E1;
462 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
463 
464     struct Taxes {
465         uint256 marketing;
466         uint256 liquidity;
467         uint256 raffle;
468         uint256 dev;
469         uint256 ops;
470     }
471 
472     Taxes public taxes = Taxes(5, 2, 2, 1, 1);
473     Taxes public sellTaxes = Taxes(5, 2, 2, 1, 1);
474 
475     mapping(address => bool) public exemptFee;
476     mapping(address => bool) public isBlacklisted;
477     mapping(address => bool) public allowedTransfer;
478 
479     //Anti Dump
480     mapping(address => uint256) private _lastSell;
481     bool public coolDownEnabled = true;
482     uint256 public coolDownTime = 60 seconds;
483 
484     modifier mutexLock() {
485         if (!_liquidityMutex) {
486             _liquidityMutex = true;
487             _;
488             _liquidityMutex = false;
489         }
490     }
491 
492     constructor(address routerAdd) ERC20("Jokerinu", "JOKER") {
493         _tokengeneration(msg.sender, 1e11 * 10**decimals());
494         exemptFee[msg.sender] = true;
495 
496         IRouter _router = IRouter(routerAdd);
497         // Create a uniswap pair for this new token
498         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
499 
500         router = _router;
501         pair = _pair;
502         exemptFee[address(this)] = true;
503         exemptFee[marketingWallet] = true;
504         exemptFee[raffleWallet] = true;
505         exemptFee[devWallet] = true;
506         exemptFee[opsWallet] = true;
507         exemptFee[deadWallet] = true;
508         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
509         exemptFee[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true;
510         exemptFee[0x33d4cC8716Beb13F814F538Ad3b2de3b036f5e2A] = true;
511         
512 
513         allowedTransfer[address(this)] = true;
514         allowedTransfer[owner()] = true;
515         allowedTransfer[pair] = true;
516         allowedTransfer[marketingWallet] = true;
517         allowedTransfer[raffleWallet] = true;
518         allowedTransfer[devWallet] = true;
519         allowedTransfer[opsWallet] = true;
520         allowedTransfer[deadWallet] = true;
521         allowedTransfer[0xD152f549545093347A162Dce210e7293f1452150] = true;
522         allowedTransfer[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true;
523         allowedTransfer[0x33d4cC8716Beb13F814F538Ad3b2de3b036f5e2A] = true;
524 
525     }
526 
527     function approve(address spender, uint256 amount) public override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     function transferFrom(
533         address sender,
534         address recipient,
535         uint256 amount
536     ) public override returns (bool) {
537         _transfer(sender, recipient, amount);
538 
539         uint256 currentAllowance = _allowances[sender][_msgSender()];
540         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
541         _approve(sender, _msgSender(), currentAllowance - amount);
542 
543         return true;
544     }
545 
546     function increaseAllowance(address spender, uint256 addedValue)
547         public
548         override
549         returns (bool)
550     {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
552         return true;
553     }
554 
555     function decreaseAllowance(address spender, uint256 subtractedValue)
556         public
557         override
558         returns (bool)
559     {
560         uint256 currentAllowance = _allowances[_msgSender()][spender];
561         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
562         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
563 
564         return true;
565     }
566 
567     function transfer(address recipient, uint256 amount) public override returns (bool) {
568         _transfer(msg.sender, recipient, amount);
569         return true;
570     }
571 
572     function _transfer(
573         address sender,
574         address recipient,
575         uint256 amount
576     ) internal override {
577         require(amount > 0, "Transfer amount must be greater than zero");
578         require(
579             !isBlacklisted[sender] && !isBlacklisted[recipient],
580             "You can't transfer tokens"
581         );
582 
583         if (!exemptFee[sender] && !exemptFee[recipient]) {
584             require(tradingEnabled, "Trading not enabled");
585         }
586 
587         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
588             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
589             require(
590                 balanceOf(recipient) + amount <= maxWalletLimit,
591                 "You are exceeding maxWalletLimit"
592             );
593         }
594 
595         if (
596             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex
597         ) {
598             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
599             if (recipient != pair) {
600                 require(
601                     balanceOf(recipient) + amount <= maxWalletLimit,
602                     "You are exceeding maxWalletLimit"
603                 );
604             }
605             if (coolDownEnabled) {
606                 uint256 timePassed = block.timestamp - _lastSell[sender];
607                 require(timePassed >= coolDownTime, "Cooldown enabled");
608                 _lastSell[sender] = block.timestamp;
609             }
610         }
611 
612         uint256 feeswap;
613         uint256 feesum;
614         uint256 fee;
615         Taxes memory currentTaxes;
616 
617         bool useLaunchFee = !exemptFee[sender] &&
618             !exemptFee[recipient] &&
619             block.number < genesis_block + deadline;
620 
621         //set fee to zero if fees in contract are handled or exempted
622         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
623             fee = 0;
624 
625             //calculate fee
626         else if (recipient == pair && !useLaunchFee) {
627             feeswap =
628                 sellTaxes.liquidity +
629                 sellTaxes.marketing +
630                 sellTaxes.raffle +                
631                 sellTaxes.dev + 
632                 sellTaxes.ops;
633             feesum = feeswap;
634             currentTaxes = sellTaxes;
635         } else if (!useLaunchFee) {
636             feeswap =
637                 taxes.liquidity +
638                 taxes.marketing +
639                 taxes.raffle +
640                 taxes.dev +
641                 taxes.ops ;
642             feesum = feeswap;
643             currentTaxes = taxes;
644         } else if (useLaunchFee) {
645             feeswap = launchtax;
646             feesum = launchtax;
647         }
648 
649         fee = (amount * feesum) / 100;
650 
651         //send fees if threshold has been reached
652         //don't do this on buys, breaks swap
653         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
654 
655         //rest to recipient
656         super._transfer(sender, recipient, amount - fee);
657         if (fee > 0) {
658             //send the fee to the contract
659             if (feeswap > 0) {
660                 uint256 feeAmount = (amount * feeswap) / 100;
661                 super._transfer(sender, address(this), feeAmount);
662             }
663 
664         }
665     }
666 
667     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
668         uint256 contractBalance = balanceOf(address(this));
669         if (contractBalance >= tokenLiquidityThreshold) {
670             if (tokenLiquidityThreshold > 1) {
671                 contractBalance = tokenLiquidityThreshold;
672             }
673 
674             // Split the contract balance into halves
675             uint256 denominator = feeswap * 2;
676             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
677                 denominator;
678             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
679 
680             uint256 initialBalance = address(this).balance;
681 
682             swapTokensForETH(toSwap);
683 
684             uint256 deltaBalance = address(this).balance - initialBalance;
685             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
686             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
687 
688             if (ethToAddLiquidityWith > 0) {
689                 // Add liquidity to uniswap
690                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
691             }
692 
693             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
694             if (marketingAmt > 0) {
695                 payable(marketingWallet).sendValue(marketingAmt);
696             }
697 
698             uint256 raffleAmt = unitBalance * 2 * swapTaxes.raffle;
699             if (raffleAmt > 0) {
700                 payable(raffleWallet).sendValue(raffleAmt);
701             }
702 
703             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
704             if (devAmt > 0) {
705                 payable(devWallet).sendValue(devAmt);
706             }
707 
708             uint256 opsAmt = unitBalance * 2 * swapTaxes.ops;
709             if (opsAmt > 0) {
710                 payable(opsWallet).sendValue(opsAmt);
711             }
712 
713         }
714     }
715 
716     function swapTokensForETH(uint256 tokenAmount) private {
717         // generate the uniswap pair path of token -> weth
718         address[] memory path = new address[](2);
719         path[0] = address(this);
720         path[1] = router.WETH();
721 
722         _approve(address(this), address(router), tokenAmount);
723 
724         // make the swap
725         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
726             tokenAmount,
727             0,
728             path,
729             address(this),
730             block.timestamp
731         );
732     }
733 
734     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
735         // approve token transfer to cover all possible scenarios
736         _approve(address(this), address(router), tokenAmount);
737 
738         // add the liquidity
739         router.addLiquidityETH{ value: ethAmount }(
740             address(this),
741             tokenAmount,
742             0, // slippage is unavoidable
743             0, // slippage is unavoidable
744             owner(),
745             block.timestamp
746         );
747     }
748 
749     function updateLiquidityProvide(bool state) external onlyOwner {
750         //update liquidity providing state
751         providingLiquidity = state;
752     }
753 
754     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
755         //update the treshhold
756         tokenLiquidityThreshold = new_amount * 10**decimals();
757     }
758 
759     function updateTaxes(Taxes memory newTaxes) external onlyOwner {
760         taxes = newTaxes;
761     }
762 
763     function updateSellTaxes(Taxes memory newSellTaxes) external onlyOwner {
764         sellTaxes = newSellTaxes;
765     }
766 
767     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
768         router = IRouter(newRouter);
769         pair = newPair;
770     }
771 
772     function updateTradingEnabled(
773         bool state,
774         uint256 _deadline,
775         uint256 _launchtax
776     ) external onlyOwner {
777         deadline = _deadline;
778         launchtax = _launchtax;
779         tradingEnabled = state;
780         providingLiquidity = state;
781         if (state == true) genesis_block = block.number;
782     }
783 
784     function updateMarketingWallet(address newWallet) external onlyOwner {
785         marketingWallet = newWallet;
786     }
787 
788     function updateRaffleWallet(address newWallet) external onlyOwner {
789         raffleWallet = newWallet;
790     }
791 
792     function updateDevWallet(address newWallet) external onlyOwner {
793         devWallet = newWallet;
794     }
795 
796     function updateOpsWallet(address newWallet) external onlyOwner {
797         opsWallet = newWallet;
798     }
799 
800     function updateCooldown(bool state, uint256 time) external onlyOwner {
801         coolDownTime = time * 1 seconds;
802         coolDownEnabled = state;
803     }
804 
805     function updateIsBlacklisted(address account, bool state) external onlyOwner {
806         isBlacklisted[account] = state;
807     }
808 
809     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner {
810         for (uint256 i = 0; i < accounts.length; i++) {
811             isBlacklisted[accounts[i]] = state;
812         }
813     }
814 
815     function updateAllowedTransfer(address account, bool state) external onlyOwner {
816         allowedTransfer[account] = state;
817     }
818 
819     function bulkAllowedTransfer(address[] memory accounts, bool state) external onlyOwner {
820         for (uint256 i = 0; i < accounts.length; i++) {
821             allowedTransfer[accounts[i]] = state;
822         }
823     }
824 
825     function updateExemptFee(address _address, bool state) external onlyOwner {
826         exemptFee[_address] = state;
827     }
828 
829     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
830         for (uint256 i = 0; i < accounts.length; i++) {
831             exemptFee[accounts[i]] = state;
832         }
833     }
834 
835     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner {
836         maxBuyLimit = maxBuy * 10**decimals();
837         maxSellLimit = maxSell * 10**decimals();
838     }
839 
840     function updateMaxWalletlimit(uint256 amount) external onlyOwner {
841         maxWalletLimit = amount * 10**decimals();
842     }
843 
844     function rescueETH(uint256 weiAmount) external onlyOwner {
845         payable(devWallet).transfer(weiAmount);
846     }
847 
848     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
849         IERC20(tokenAdd).transfer(devWallet, amount);
850     }
851 
852     // fallbacks
853     receive() external payable {}
854 }