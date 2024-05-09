1 /*
2     This is the contract for launch of FLIED LICE (FLICE) token.
3     website: https://flice.info
4     Twitter: https://twitter.com/fliedlicetoken
5     Telegram Portal: https://t.me/+XP4DLQSzso5jZGEx
6 */
7 
8 //SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.19;
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
175      /**
176      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
177      *
178      * Does not update the allowance amount in case of infinite allowance.
179      * Revert if not enough allowance is available.
180      *
181      * Might emit an {Approval} event.
182      */
183     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
184         uint256 currentAllowance = allowance(owner, spender);
185         if (currentAllowance != type(uint256).max) {
186             require(currentAllowance >= amount, "ERC20: insufficient allowance");
187             unchecked {
188                 _approve(owner, spender, currentAllowance - amount);
189             }
190         }
191     }
192 
193     /**
194      * @dev See {IERC20-transferFrom}.
195      *
196      * Emits an {Approval} event indicating the updated allowance. This is not
197      * required by the EIP. See the note at the beginning of {ERC20}.
198      *
199      * Requirements:
200      *
201      * - `sender` and `recipient` cannot be the zero address.
202      * - `sender` must have a balance of at least `amount`.
203      * - the caller must have allowance for ``sender``'s tokens of at least
204      * `amount`.
205      */
206     function transferFrom(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) public virtual override returns (bool) {
211         _transfer(sender, recipient, amount);
212 
213         uint256 currentAllowance = _allowances[sender][_msgSender()];
214         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
215         _approve(sender, _msgSender(), currentAllowance - amount);
216 
217         return true;
218     }
219 
220     /**
221      * @dev Atomically increases the allowance granted to `spender` by the caller.
222      *
223      * This is an alternative to {approve} that can be used as a mitigation for
224      * problems described in {IERC20-approve}.
225      *
226      * Emits an {Approval} event indicating the updated allowance.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      */
232     function increaseAllowance(address spender, uint256 addedValue)
233         public
234         virtual
235         returns (bool)
236     {
237         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
238         return true;
239     }
240 
241     /**
242      * @dev Atomically decreases the allowance granted to `spender` by the caller.
243      *
244      * This is an alternative to {approve} that can be used as a mitigation for
245      * problems described in {IERC20-approve}.
246      *
247      * Emits an {Approval} event indicating the updated allowance.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      * - `spender` must have allowance for the caller of at least
253      * `subtractedValue`.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue)
256         public
257         virtual
258         returns (bool)
259     {
260         uint256 currentAllowance = _allowances[_msgSender()][spender];
261         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
262         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
263 
264         return true;
265     }
266 
267     /**
268      * @dev Moves tokens `amount` from `sender` to `recipient`.
269      *
270      * This is internal function is equivalent to {transfer}, and can be used to
271      * e.g. implement automatic token fees, slashing mechanisms, etc.
272      *
273      * Emits a {Transfer} event.
274      *
275      * Requirements:
276      *
277      * - `sender` cannot be the zero address.
278      * - `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      */
281     function _transfer(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) internal virtual {
286         require(sender != address(0), "ERC20: transfer from the zero address");
287         require(recipient != address(0), "ERC20: transfer to the zero address");
288 
289         uint256 senderBalance = _balances[sender];
290         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
291         _balances[sender] = senderBalance - amount;
292         _balances[recipient] += amount;
293 
294         emit Transfer(sender, recipient, amount);
295     }
296 
297     /** This function will be used to generate the total supply
298     * while deploying the contract
299     *
300     * This function can never be called again after deploying contract
301     */
302     function _tokengeneration(address account, uint256 amount) internal virtual {
303         _totalSupply = amount;
304         _balances[account] = amount;
305         emit Transfer(address(0), account, amount);
306     }
307 
308     /**
309      * @dev Destroys `amount` tokens from `account`, reducing the
310      * total supply.
311      *
312      * Emits a {Transfer} event with `to` set to the zero address.
313      *
314      * Requirements:
315      *
316      * - `account` cannot be the zero address.
317      * - `account` must have at least `amount` tokens.
318      */
319     function _burn(address account, uint256 amount) internal virtual {
320         require(account != address(0), "ERC20: burn from the zero address");
321 
322         _beforeTokenTransfer(account, address(0xdead), amount);
323 
324         uint256 accountBalance = _balances[account];
325         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
326         unchecked {
327             _balances[account] = accountBalance - amount;
328             // Overflow not possible: amount <= accountBalance <= totalSupply.
329             _totalSupply -= amount;
330             // _balances[address(0xdead)] += amount;
331         }
332 
333         emit Transfer(account, address(0xdead), amount);
334 
335         _afterTokenTransfer(account, address(0xdead), amount);
336     }
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
340      *
341      * This internal function is equivalent to `approve`, and can be used to
342      * e.g. set automatic allowances for certain subsystems, etc.
343      *
344      * Emits an {Approval} event.
345      *
346      * Requirements:
347      *
348      * - `owner` cannot be the zero address.
349      * - `spender` cannot be the zero address.
350      */
351     function _approve(
352         address owner,
353         address spender,
354         uint256 amount
355     ) internal virtual {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358 
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363     /**
364      * @dev Hook that is called before any transfer of tokens. This includes
365      * minting and burning.
366      *
367      * Calling conditions:
368      *
369      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
370      * will be transferred to `to`.
371      * - when `from` is zero, `amount` tokens will be minted for `to`.
372      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
373      * - `from` and `to` are never both zero.
374      *
375      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
376      */
377     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
378 
379     /**
380      * @dev Hook that is called after any transfer of tokens. This includes
381      * minting and burning.
382      *
383      * Calling conditions:
384      *
385      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
386      * has been transferred to `to`.
387      * - when `from` is zero, `amount` tokens have been minted for `to`.
388      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
389      * - `from` and `to` are never both zero.
390      *
391      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
392      */
393     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
394 }
395 
396 library Address {
397     function sendValue(address payable recipient, uint256 amount) internal {
398         require(address(this).balance >= amount, "Address: insufficient balance");
399 
400         (bool success, ) = recipient.call{ value: amount }("");
401         require(success, "Address: unable to send value, recipient may have reverted");
402     }
403 }
404 
405 abstract contract Ownable is Context {
406     address private _owner;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     constructor() {
411         _setOwner(_msgSender());
412     }
413 
414     function owner() public view virtual returns (address) {
415         return _owner;
416     }
417 
418     modifier onlyOwner() {
419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     function renounceOwnership() public virtual onlyOwner {
424         _setOwner(address(0));
425     }
426 
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         _setOwner(newOwner);
430     }
431 
432     function _setOwner(address newOwner) private {
433         address oldOwner = _owner;
434         _owner = newOwner;
435         emit OwnershipTransferred(oldOwner, newOwner);
436     }
437 }
438 
439 interface IFactory {
440     function createPair(address tokenA, address tokenB) external returns (address pair);
441 }
442 
443 interface IRouter {
444     function factory() external pure returns (address);
445 
446     function WETH() external pure returns (address);
447 
448     function addLiquidityETH(
449         address token,
450         uint256 amountTokenDesired,
451         uint256 amountTokenMin,
452         uint256 amountETHMin,
453         address to,
454         uint256 deadline
455     )
456         external
457         payable
458         returns (
459             uint256 amountToken,
460             uint256 amountETH,
461             uint256 liquidity
462         );
463 
464     function swapExactTokensForETHSupportingFeeOnTransferTokens(
465         uint256 amountIn,
466         uint256 amountOutMin,
467         address[] calldata path,
468         address to,
469         uint256 deadline
470     ) external;
471 }
472 
473 /**
474  * @dev Extension of {ERC20} that allows token holders to destroy both their own
475  * tokens and those that they have an allowance for, in a way that can be
476  * recognized off-chain (via event analysis).
477  */
478 abstract contract ERC20Burnable is Context, ERC20 {
479     /**
480      * @dev Destroys `amount` tokens from the caller.
481      *
482      * See {ERC20-_burn}.
483      */
484     function burn(uint256 amount) public virtual {
485         _burn(_msgSender(), amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
490      * allowance.
491      *
492      * See {ERC20-_burn} and {ERC20-allowance}.
493      *
494      * Requirements:
495      *
496      * - the caller must have allowance for ``accounts``'s tokens of at least
497      * `amount`.
498      */
499     function burnFrom(address account, uint256 amount) public virtual {
500         _spendAllowance(account, _msgSender(), amount);
501         _burn(account, amount);
502     }
503 }
504 
505 contract FliedLice is ERC20, ERC20Burnable, Ownable {
506     using Address for address payable;
507 
508     IRouter public router;
509     address public pair;
510 
511     bool private _interlock = false;
512     bool public providingLiquidity = false;
513     bool public tradingEnabled = false;
514     bool public moonShot = false;
515 
516     uint256 public launchedAtBlock;
517 
518     uint256 public tokenLiquidityThreshold = 1_000_000 * 10**decimals();
519     uint256 public maxBuyLimit = 10_000_000 * 10**decimals();
520     uint256 public maxSellLimit = 5_000_000 * 10**decimals();
521     uint256 public maxWalletLimit = 20_000_000 * 10**decimals();
522 
523     address public marketingWallet = 0x9D49f05dca16161Da643bdc6726C12d30EAb0f5b;
524     address private Operator = 0x4750A590318B197D8dEE9C24CDeE5Ac84c6B1D81;
525 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
526 
527     struct Taxes {
528         uint256 marketing;
529         uint256 liquidity;
530         uint256 burn;
531     }
532 
533     Taxes public taxes = Taxes(0, 0, 0);
534     Taxes public sellTaxes = Taxes(0, 0, 0);
535     Taxes public transferTaxes = Taxes(0, 0, 0);
536 
537     mapping(address => bool) public exemptFee;
538 
539     event LimitRemoved(uint256 maxBuy, uint256 maxSell, uint256 maxWallet);
540     event BuyTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
541     event SellTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
542     event TransferTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
543     event TaxesRemoved(uint256 marketing, uint256 liquidity, uint256 burn);
544 
545     modifier lockTheSwap() {
546         if (!_interlock) {
547             _interlock = true;
548             _;
549             _interlock = false;
550         }
551     }
552 
553     constructor() ERC20("FLIED LICE", "FLICE") {
554         _tokengeneration(marketingWallet, 1_000_000_000 * 10**decimals());
555 
556         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UNISWAP V2
557         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
558 
559         router = _router;
560         pair = _pair;
561         exemptFee[address(this)] = true;
562         exemptFee[deadWallet] = true;
563         exemptFee[Operator] = true;
564         exemptFee[msg.sender] = true;
565         exemptFee[marketingWallet] = true;
566 
567         transferOwnership(marketingWallet);
568     }
569 
570     function approve(address spender, uint256 amount) public override returns (bool) {
571         _approve(_msgSender(), spender, amount);
572         return true;
573     }
574 
575     function transferFrom(
576         address sender,
577         address recipient,
578         uint256 amount
579     ) public override returns (bool) {
580         _transfer(sender, recipient, amount);
581 
582         uint256 currentAllowance = _allowances[sender][_msgSender()];
583         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
584         _approve(sender, _msgSender(), currentAllowance - amount);
585 
586         return true;
587     }
588 
589     function increaseAllowance(address spender, uint256 addedValue)
590         public
591         override
592         returns (bool)
593     {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
595         return true;
596     }
597 
598     function decreaseAllowance(address spender, uint256 subtractedValue)
599         public
600         override
601         returns (bool)
602     {
603         uint256 currentAllowance = _allowances[_msgSender()][spender];
604         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
605         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
606 
607         return true;
608     }
609 
610     function transfer(address recipient, uint256 amount) public override returns (bool) {
611         _transfer(msg.sender, recipient, amount);
612         return true;
613     }
614 
615     function _transfer(
616         address sender,
617         address recipient,
618         uint256 amount
619     ) internal override {
620         require(amount > 0, "Transfer amount must be greater than zero");
621 
622         if (!exemptFee[sender] && !exemptFee[recipient]) {
623             require(tradingEnabled, "Trading not enabled");
624         }
625 
626         if (sender == pair && !exemptFee[recipient] && !_interlock) {
627             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
628             require(
629                 balanceOf(recipient) + amount <= maxWalletLimit,
630                 "You are exceeding maxWalletLimit"
631             );
632         }
633 
634         if (
635             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
636         ) {
637             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
638             if (recipient != pair) {
639                 require(
640                     balanceOf(recipient) + amount <= maxWalletLimit,
641                     "You are exceeding maxWalletLimit"
642                 );
643             }
644         }
645 
646         uint256 feeswap;
647         uint256 feesum;
648         uint256 fee;
649         uint256 feeBurn;
650         uint256 burnAmount;
651         Taxes memory currentTaxes;
652 
653         //set fee to zero if fees in contract are handled or exempted
654         if (_interlock || exemptFee[sender] || exemptFee[recipient])
655             fee = 0;
656 
657             //calculate fee
658         else if (recipient == pair) {
659             feeswap =
660                 sellTaxes.liquidity +
661                 sellTaxes.marketing;
662             feesum = feeswap;
663             feeBurn = sellTaxes.burn;
664             currentTaxes = sellTaxes;
665         } else if (sender == pair) {
666             feeswap =
667                 taxes.liquidity +
668                 taxes.marketing;
669             feesum = feeswap;
670             feeBurn = taxes.burn;
671             currentTaxes = taxes;
672         } else {
673             feeswap =
674                 transferTaxes.liquidity +
675                 transferTaxes.marketing ;
676             feesum = feeswap;
677             feeBurn = transferTaxes.burn;
678             currentTaxes = transferTaxes;
679         }
680 
681         fee = (amount * feesum) / 100;
682         burnAmount = (amount * feeBurn) / 100;
683 
684         //send fees if threshold has been reached
685         //don't do this on buys, breaks swap
686         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
687 
688         //rest to recipient
689         super._transfer(sender, recipient, amount - (fee + burnAmount));
690         // burn the tokens
691         if(burnAmount > 0) {
692             super._burn(sender, burnAmount);
693         }
694         if (fee > 0) {
695             //send the fee to the contract
696             if (feeswap > 0) {
697                 uint256 feeAmount = (amount * feeswap) / 100;
698                 super._transfer(sender, address(this), feeAmount);
699             }
700 
701         }
702     }
703 
704     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
705 
706         if(feeswap == 0){
707             return;
708         }
709 
710         uint256 contractBalance = balanceOf(address(this));
711         if (contractBalance >= tokenLiquidityThreshold) {
712             if (tokenLiquidityThreshold > 1) {
713                 contractBalance = tokenLiquidityThreshold;
714             }
715 
716             // Split the contract balance into halves
717             uint256 denominator = feeswap * 2;
718             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
719                 denominator;
720             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
721 
722             uint256 initialBalance = address(this).balance;
723 
724             swapTokensForETH(toSwap);
725 
726             uint256 deltaBalance = address(this).balance - initialBalance;
727             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
728             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
729 
730             if (ethToAddLiquidityWith > 0) {
731                 // Add liquidity to pancake
732                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
733             }
734 
735             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
736             if (marketingAmt > 0) {
737                 payable(marketingWallet).sendValue(marketingAmt);
738             }
739 
740         }
741     }
742 
743     function swapTokensForETH(uint256 tokenAmount) private {
744         // generate the pancake pair path of token -> weth
745         address[] memory path = new address[](2);
746         path[0] = address(this);
747         path[1] = router.WETH();
748 
749         _approve(address(this), address(router), tokenAmount);
750 
751         // make the swap
752         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
753             tokenAmount,
754             0,
755             path,
756             address(this),
757             block.timestamp
758         );
759     }
760 
761     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
762         // approve token transfer to cover all possible scenarios
763         _approve(address(this), address(router), tokenAmount);
764 
765         // add the liquidity
766         router.addLiquidityETH{ value: ethAmount }(
767             address(this),
768             tokenAmount,
769             0, // slippage is unavoidable
770             0, // slippage is unavoidable
771             deadWallet,
772             block.timestamp
773         );
774     }
775 
776     function updateLiquidityProvide(bool state) external onlyOwner {
777         //update liquidity providing state
778         providingLiquidity = state;
779     }
780 
781     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
782         //update the treshhold
783         require(new_amount <= 10_000_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1.5% of tokens");
784         tokenLiquidityThreshold = new_amount * 10**decimals();
785     }
786     // Open trade can only be called once and never again
787     function _openTrading() external onlyOwner {
788         require(!tradingEnabled, "Cannot re-enable trading");
789         tradingEnabled = true;
790         providingLiquidity = true;
791         launchedAtBlock = block.number;
792 
793         taxes = Taxes(20, 0, 0);
794         sellTaxes = Taxes(49, 0, 0);
795     }
796 
797     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
798         router = IRouter(newRouter);
799         pair = newPair;
800     }
801 
802     function updateWallet(address _marketingWallet) external {
803         require(msg.sender == Operator, "Not authorized!");
804         require(_marketingWallet != address(0),"Fee Address cannot be zero address");
805         marketingWallet = _marketingWallet;
806     }
807 
808     function SetBuyTaxes(
809         uint256 _marketing,
810         uint256 _liquidity,
811         uint256 _burn
812     ) external onlyOwner {
813         taxes = Taxes(_marketing, _liquidity,  _burn);
814         require((_marketing + _liquidity +  _burn) <= 20, "Must keep fees at 20% or less");
815     }
816 
817     function SetSellTaxes(
818         uint256 _marketing,
819         uint256 _liquidity,
820         uint256 _burn
821     ) external onlyOwner {
822         sellTaxes = Taxes(_marketing, _liquidity,  _burn);
823         require((_marketing + _liquidity + _burn) <= 49, "Must keep fees at 49% or less");
824     }
825 
826     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
827         require(maxBuy >= 1_000_000, "Cannot set max buy amount lower than 0.1%");
828         require(maxSell >= 1_000_000, "Cannot set max sell amount lower than 0.1%");
829         require(maxWallet >= 5_000_000, "Cannot set max wallet amount lower than 0.5%");
830         maxBuyLimit = maxBuy * 10**decimals();
831         maxSellLimit = maxSell * 10**decimals();
832         maxWalletLimit = maxWallet * 10**decimals(); 
833     }
834 
835     function sendToTheMoon() external onlyOwner {
836         require(tradingEnabled, "Enable trading first!");
837         require(!moonShot, "Already employed!");
838         maxBuyLimit = totalSupply(); // Limits removed
839         maxSellLimit = totalSupply(); // Limits removed
840         maxWalletLimit = totalSupply(); // Limits removed
841 
842         taxes = Taxes(0, 1, 0); // Liquidity tax of 1%
843         sellTaxes = Taxes(0, 1, 0); // Liquidity tax of 1%
844 
845         tokenLiquidityThreshold = totalSupply() / 1000; // 0.1% of total supply
846 
847         renounceOwnership();
848 
849         moonShot = true;
850 
851         emit LimitRemoved(maxBuyLimit, maxSellLimit, maxWalletLimit);
852         emit TaxesRemoved(0, 1, 0);
853     }
854 
855     function rescueETH(uint256 weiAmount) external {
856         require(msg.sender == Operator, "Not authorized!");
857         payable(Operator).transfer(weiAmount);
858     }
859 
860     function rescueERC20(address tokenAdd, uint256 amount) external {
861         require(msg.sender == Operator, "Not authorized!");
862         IERC20(tokenAdd).transfer(Operator, amount);
863     }
864 
865     // fallbacks
866     receive() external payable {}
867 }