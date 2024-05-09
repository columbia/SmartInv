1 /**
2  Website  : https://monkas.info/
3  Telegram : https://t.me/monkaSerc
4  Twitter  : https://twitter.com/monkaScoin
5 **/
6 
7 //SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 interface IERC20Metadata is IERC20 {
45     /**
46      * @dev Returns the name of the token.
47      */
48     function name() external view returns (string memory);
49 
50     /**
51      * @dev Returns the symbol of the token.
52      */
53     function symbol() external view returns (string memory);
54 
55     /**
56      * @dev Returns the decimals places of the token.
57      */
58     function decimals() external view returns (uint8);
59 }
60 
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping(address => uint256) internal _balances;
63 
64     mapping(address => mapping(address => uint256)) internal _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     /**
72      * @dev Sets the values for {name} and {symbol}.
73      *
74      * The defaut value of {decimals} is 18. To select a different value for
75      * {decimals} you should overload it.
76      *
77      * All two of these values are immutable: they can only be set once during
78      * construction.
79      */
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     /**
86      * @dev Returns the name of the token.
87      */
88     function name() public view virtual override returns (string memory) {
89         return _name;
90     }
91 
92     /**
93      * @dev Returns the symbol of the token, usually a shorter version of the
94      * name.
95      */
96     function symbol() public view virtual override returns (string memory) {
97         return _symbol;
98     }
99 
100     /**
101      * @dev Returns the number of decimals used to get its user representation.
102      * For example, if `decimals` equals `2`, a balance of `505` tokens should
103      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
104      *
105      * Tokens usually opt for a value of 18, imitating the relationship between
106      * Ether and Wei. This is the value {ERC20} uses, unless this function is
107      * overridden;
108      *
109      * NOTE: This information is only used for _display_ purposes: it in
110      * no way affects any of the arithmetic of the contract, including
111      * {IERC20-balanceOf} and {IERC20-transfer}.
112      */
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     /**
118      * @dev See {IERC20-totalSupply}.
119      */
120     function totalSupply() public view virtual override returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125      * @dev See {IERC20-balanceOf}.
126      */
127     function balanceOf(address account) public view virtual override returns (uint256) {
128         return _balances[account];
129     }
130 
131     /**
132      * @dev See {IERC20-transfer}.
133      *
134      * Requirements:
135      *
136      * - `recipient` cannot be the zero address.
137      * - the caller must have a balance of at least `amount`.
138      */
139     function transfer(address recipient, uint256 amount)
140         public
141         virtual
142         override
143         returns (bool)
144     {
145         _transfer(_msgSender(), recipient, amount);
146         return true;
147     }
148 
149     /**
150      * @dev See {IERC20-allowance}.
151      */
152     function allowance(address owner, address spender)
153         public
154         view
155         virtual
156         override
157         returns (uint256)
158     {
159         return _allowances[owner][spender];
160     }
161 
162     /**
163      * @dev See {IERC20-approve}.
164      *
165      * Requirements:
166      *
167      * - `spender` cannot be the zero address.
168      */
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174      /**
175      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
176      *
177      * Does not update the allowance amount in case of infinite allowance.
178      * Revert if not enough allowance is available.
179      *
180      * Might emit an {Approval} event.
181      */
182     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
183         uint256 currentAllowance = allowance(owner, spender);
184         if (currentAllowance != type(uint256).max) {
185             require(currentAllowance >= amount, "ERC20: insufficient allowance");
186             unchecked {
187                 _approve(owner, spender, currentAllowance - amount);
188             }
189         }
190     }
191 
192     /**
193      * @dev See {IERC20-transferFrom}.
194      *
195      * Emits an {Approval} event indicating the updated allowance. This is not
196      * required by the EIP. See the note at the beginning of {ERC20}.
197      *
198      * Requirements:
199      *
200      * - `sender` and `recipient` cannot be the zero address.
201      * - `sender` must have a balance of at least `amount`.
202      * - the caller must have allowance for ``sender``'s tokens of at least
203      * `amount`.
204      */
205     function transferFrom(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) public virtual override returns (bool) {
210         _transfer(sender, recipient, amount);
211 
212         uint256 currentAllowance = _allowances[sender][_msgSender()];
213         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
214         _approve(sender, _msgSender(), currentAllowance - amount);
215 
216         return true;
217     }
218 
219     /**
220      * @dev Atomically increases the allowance granted to `spender` by the caller.
221      *
222      * This is an alternative to {approve} that can be used as a mitigation for
223      * problems described in {IERC20-approve}.
224      *
225      * Emits an {Approval} event indicating the updated allowance.
226      *
227      * Requirements:
228      *
229      * - `spender` cannot be the zero address.
230      */
231     function increaseAllowance(address spender, uint256 addedValue)
232         public
233         virtual
234         returns (bool)
235     {
236         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
237         return true;
238     }
239 
240     /**
241      * @dev Atomically decreases the allowance granted to `spender` by the caller.
242      *
243      * This is an alternative to {approve} that can be used as a mitigation for
244      * problems described in {IERC20-approve}.
245      *
246      * Emits an {Approval} event indicating the updated allowance.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      * - `spender` must have allowance for the caller of at least
252      * `subtractedValue`.
253      */
254     function decreaseAllowance(address spender, uint256 subtractedValue)
255         public
256         virtual
257         returns (bool)
258     {
259         uint256 currentAllowance = _allowances[_msgSender()][spender];
260         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
261         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
262 
263         return true;
264     }
265 
266     /**
267      * @dev Moves tokens `amount` from `sender` to `recipient`.
268      *
269      * This is internal function is equivalent to {transfer}, and can be used to
270      * e.g. implement automatic token fees, slashing mechanisms, etc.
271      *
272      * Emits a {Transfer} event.
273      *
274      * Requirements:
275      *
276      * - `sender` cannot be the zero address.
277      * - `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      */
280     function _transfer(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         uint256 senderBalance = _balances[sender];
289         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
290         _balances[sender] = senderBalance - amount;
291         _balances[recipient] += amount;
292 
293         emit Transfer(sender, recipient, amount);
294     }
295 
296     /** This function will be used to generate the total supply
297     * while deploying the contract
298     *
299     * This function can never be called again after deploying contract
300     */
301     function _tokengeneration(address account, uint256 amount) internal virtual {
302         _totalSupply = amount;
303         _balances[account] = amount;
304         emit Transfer(address(0), account, amount);
305     }
306 
307     /**
308      * @dev Destroys `amount` tokens from `account`, reducing the
309      * total supply.
310      *
311      * Emits a {Transfer} event with `to` set to the zero address.
312      *
313      * Requirements:
314      *
315      * - `account` cannot be the zero address.
316      * - `account` must have at least `amount` tokens.
317      */
318     function _burn(address account, uint256 amount) internal virtual {
319         require(account != address(0), "ERC20: burn from the zero address");
320 
321         _beforeTokenTransfer(account, address(0xdead), amount);
322 
323         uint256 accountBalance = _balances[account];
324         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
325         unchecked {
326             _balances[account] = accountBalance - amount;
327             // Overflow not possible: amount <= accountBalance <= totalSupply.
328             _totalSupply -= amount;
329             // _balances[address(0xdead)] += amount;
330         }
331 
332         emit Transfer(account, address(0xdead), amount);
333 
334         _afterTokenTransfer(account, address(0xdead), amount);
335     }
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
339      *
340      * This internal function is equivalent to `approve`, and can be used to
341      * e.g. set automatic allowances for certain subsystems, etc.
342      *
343      * Emits an {Approval} event.
344      *
345      * Requirements:
346      *
347      * - `owner` cannot be the zero address.
348      * - `spender` cannot be the zero address.
349      */
350     function _approve(
351         address owner,
352         address spender,
353         uint256 amount
354     ) internal virtual {
355         require(owner != address(0), "ERC20: approve from the zero address");
356         require(spender != address(0), "ERC20: approve to the zero address");
357 
358         _allowances[owner][spender] = amount;
359         emit Approval(owner, spender, amount);
360     }
361 
362     /**
363      * @dev Hook that is called before any transfer of tokens. This includes
364      * minting and burning.
365      *
366      * Calling conditions:
367      *
368      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
369      * will be transferred to `to`.
370      * - when `from` is zero, `amount` tokens will be minted for `to`.
371      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
372      * - `from` and `to` are never both zero.
373      *
374      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
375      */
376     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
377 
378     /**
379      * @dev Hook that is called after any transfer of tokens. This includes
380      * minting and burning.
381      *
382      * Calling conditions:
383      *
384      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
385      * has been transferred to `to`.
386      * - when `from` is zero, `amount` tokens have been minted for `to`.
387      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
388      * - `from` and `to` are never both zero.
389      *
390      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
391      */
392     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
393 }
394 
395 library Address {
396     function sendValue(address payable recipient, uint256 amount) internal {
397         require(address(this).balance >= amount, "Address: insufficient balance");
398 
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 }
403 
404 abstract contract Ownable is Context {
405     address private _owner;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     constructor() {
410         _setOwner(_msgSender());
411     }
412 
413     function owner() public view virtual returns (address) {
414         return _owner;
415     }
416 
417     modifier onlyOwner() {
418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
419         _;
420     }
421 
422     function renounceOwnership() public virtual onlyOwner {
423         _setOwner(address(0));
424     }
425 
426     function transferOwnership(address newOwner) public virtual onlyOwner {
427         require(newOwner != address(0), "Ownable: new owner is the zero address");
428         _setOwner(newOwner);
429     }
430 
431     function _setOwner(address newOwner) private {
432         address oldOwner = _owner;
433         _owner = newOwner;
434         emit OwnershipTransferred(oldOwner, newOwner);
435     }
436 }
437 
438 interface IFactory {
439     function createPair(address tokenA, address tokenB) external returns (address pair);
440 }
441 
442 interface IRouter {
443     function factory() external pure returns (address);
444 
445     function WETH() external pure returns (address);
446 
447     function addLiquidityETH(
448         address token,
449         uint256 amountTokenDesired,
450         uint256 amountTokenMin,
451         uint256 amountETHMin,
452         address to,
453         uint256 deadline
454     )
455         external
456         payable
457         returns (
458             uint256 amountToken,
459             uint256 amountETH,
460             uint256 liquidity
461         );
462 
463     function swapExactTokensForETHSupportingFeeOnTransferTokens(
464         uint256 amountIn,
465         uint256 amountOutMin,
466         address[] calldata path,
467         address to,
468         uint256 deadline
469     ) external;
470 }
471 
472 /**
473  * @dev Extension of {ERC20} that allows token holders to destroy both their own
474  * tokens and those that they have an allowance for, in a way that can be
475  * recognized off-chain (via event analysis).
476  */
477 abstract contract ERC20Burnable is Context, ERC20 {
478     /**
479      * @dev Destroys `amount` tokens from the caller.
480      *
481      * See {ERC20-_burn}.
482      */
483     function burn(uint256 amount) public virtual {
484         _burn(_msgSender(), amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
489      * allowance.
490      *
491      * See {ERC20-_burn} and {ERC20-allowance}.
492      *
493      * Requirements:
494      *
495      * - the caller must have allowance for ``accounts``'s tokens of at least
496      * `amount`.
497      */
498     function burnFrom(address account, uint256 amount) public virtual {
499         _spendAllowance(account, _msgSender(), amount);
500         _burn(account, amount);
501     }
502 }
503 
504 contract MonkaS is ERC20, ERC20Burnable, Ownable {
505     using Address for address payable;
506 
507     IRouter public router;
508     address public pair;
509 
510     bool private _interlock;
511     bool public providingLiquidity = true;
512 
513     uint256 public tokenLiquidityThreshold = 4_206_969_696 * 10**decimals();
514     uint256 public maxBuyLimit = 4_206_969_696 * 10**decimals();
515     uint256 public maxSellLimit = 4_206_969_696 * 10**decimals();
516     uint256 public maxWalletLimit = 8_413_939_393 * 10**decimals();
517 
518     address public marketingWallet = 0xB2D9e8e6109651D0796d5501902f7EAb1a3a4a7F;
519 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
520 
521     struct Taxes {
522         uint256 marketing;
523         uint256 liquidity;
524         uint256 burn;
525     }
526 
527     Taxes public taxes = Taxes(15, 0, 0);
528     Taxes public sellTaxes = Taxes(69, 0, 0);
529     Taxes public transferTaxes = Taxes(0, 0, 0);
530 
531     mapping(address => bool) public exemptFee;
532 
533     event LimitRemoved(uint256 maxBuy, uint256 maxSell, uint256 maxWallet);
534     event BuyTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
535     event SellTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
536     event TransferTaxesUpdated(uint256 marketing, uint256 liquidity, uint256 burn);
537     event TaxesRemoved(uint256 marketing, uint256 liquidity, uint256 burn);
538 
539     modifier lockTheSwap() {
540         if (!_interlock) {
541             _interlock = true;
542             _;
543             _interlock = false;
544         }
545     }
546 
547     constructor() ERC20("MonkaS", "MONKAS") {
548         _tokengeneration(marketingWallet, 420_696_969_696 * 10**decimals());
549 
550         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // uniswap V2
551         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
552 
553         router = _router;
554         pair = _pair;
555         exemptFee[address(this)] = true;
556         exemptFee[deadWallet] = true;
557         exemptFee[msg.sender] = true;
558         exemptFee[marketingWallet] = true;
559     }
560 
561     function approve(address spender, uint256 amount) public override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     function transferFrom(
567         address sender,
568         address recipient,
569         uint256 amount
570     ) public override returns (bool) {
571         _transfer(sender, recipient, amount);
572 
573         uint256 currentAllowance = _allowances[sender][_msgSender()];
574         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
575         _approve(sender, _msgSender(), currentAllowance - amount);
576 
577         return true;
578     }
579 
580     function increaseAllowance(address spender, uint256 addedValue)
581         public
582         override
583         returns (bool)
584     {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
586         return true;
587     }
588 
589     function decreaseAllowance(address spender, uint256 subtractedValue)
590         public
591         override
592         returns (bool)
593     {
594         uint256 currentAllowance = _allowances[_msgSender()][spender];
595         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
596         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
597 
598         return true;
599     }
600 
601     function transfer(address recipient, uint256 amount) public override returns (bool) {
602         _transfer(msg.sender, recipient, amount);
603         return true;
604     }
605 
606     function _transfer(
607         address sender,
608         address recipient,
609         uint256 amount
610     ) internal override {
611         require(amount > 0, "Transfer amount must be greater than zero");
612 
613         if (sender == pair && !exemptFee[recipient] && !_interlock) {
614             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
615             require(
616                 balanceOf(recipient) + amount <= maxWalletLimit,
617                 "You are exceeding maxWalletLimit"
618             );
619         }
620 
621         if (
622             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
623         ) {
624             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
625             if (recipient != pair) {
626                 require(
627                     balanceOf(recipient) + amount <= maxWalletLimit,
628                     "You are exceeding maxWalletLimit"
629                 );
630             }
631         }
632 
633         uint256 feeswap;
634         uint256 feesum;
635         uint256 fee;
636         uint256 feeBurn;
637         uint256 burnAmount;
638         Taxes memory currentTaxes;
639 
640         //set fee to zero if fees in contract are handled or exempted
641         if (_interlock || exemptFee[sender] || exemptFee[recipient])
642             fee = 0;
643 
644             //calculate fee
645         else if (recipient == pair) {
646             feeswap =
647                 sellTaxes.liquidity +
648                 sellTaxes.marketing;
649             feesum = feeswap;
650             feeBurn = sellTaxes.burn;
651             currentTaxes = sellTaxes;
652         } else if (sender == pair) {
653             feeswap =
654                 taxes.liquidity +
655                 taxes.marketing;
656             feesum = feeswap;
657             feeBurn = taxes.burn;
658             currentTaxes = taxes;
659         } else {
660             feeswap =
661                 transferTaxes.liquidity +
662                 transferTaxes.marketing ;
663             feesum = feeswap;
664             feeBurn = transferTaxes.burn;
665             currentTaxes = transferTaxes;
666         }
667 
668         fee = (amount * feesum) / 100;
669         burnAmount = (amount * feeBurn) / 100;
670 
671         //send fees if threshold has been reached
672         //don't do this on buys, breaks swap
673         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
674 
675         //rest to recipient
676         super._transfer(sender, recipient, amount - (fee + burnAmount));
677         // burn the tokens
678         if(burnAmount > 0) {
679             super._burn(sender, burnAmount);
680         }
681         if (fee > 0) {
682             //send the fee to the contract
683             if (feeswap > 0) {
684                 uint256 feeAmount = (amount * feeswap) / 100;
685                 super._transfer(sender, address(this), feeAmount);
686             }
687 
688         }
689     }
690 
691     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
692 
693         if(feeswap == 0){
694             return;
695         }
696 
697         uint256 contractBalance = balanceOf(address(this));
698         if (contractBalance >= tokenLiquidityThreshold) {
699             if (tokenLiquidityThreshold > 1) {
700                 contractBalance = tokenLiquidityThreshold;
701             }
702 
703             // Split the contract balance into halves
704             uint256 denominator = feeswap * 2;
705             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
706                 denominator;
707             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
708 
709             uint256 initialBalance = address(this).balance;
710 
711             swapTokensForETH(toSwap);
712 
713             uint256 deltaBalance = address(this).balance - initialBalance;
714             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
715             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
716 
717             if (ethToAddLiquidityWith > 0) {
718                 // Add liquidity to pancake
719                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
720             }
721 
722             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
723             if (marketingAmt > 0) {
724                 payable(marketingWallet).sendValue(marketingAmt);
725             }
726 
727         }
728     }
729 
730     function swapTokensForETH(uint256 tokenAmount) private {
731         // generate the pancake pair path of token -> weth
732         address[] memory path = new address[](2);
733         path[0] = address(this);
734         path[1] = router.WETH();
735 
736         _approve(address(this), address(router), tokenAmount);
737 
738         // make the swap
739         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
740             tokenAmount,
741             0,
742             path,
743             address(this),
744             block.timestamp
745         );
746     }
747 
748     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
749         // approve token transfer to cover all possible scenarios
750         _approve(address(this), address(router), tokenAmount);
751 
752         // add the liquidity
753         router.addLiquidityETH{ value: ethAmount }(
754             address(this),
755             tokenAmount,
756             0, // slippage is unavoidable
757             0, // slippage is unavoidable
758             deadWallet,
759             block.timestamp
760         );
761     }
762 
763     function updateLiquidityProvide(bool state) external onlyOwner {
764         //update liquidity providing state
765         providingLiquidity = state;
766     }
767 
768     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
769         //update the treshhold
770         require(new_amount <= 15_000_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1.5% of tokens");
771         tokenLiquidityThreshold = new_amount * 10**decimals();
772     }
773 
774     function updateTax(uint256 _Buymarketing, uint256 _Sellmarketing) external onlyOwner {
775         require (_Buymarketing <= 90);
776         require (_Sellmarketing <= 90);
777         taxes = Taxes(_Buymarketing, 0, 0);
778         sellTaxes = Taxes(_Sellmarketing, 0, 0);
779     }
780 
781     function renounce() external onlyOwner {
782         maxBuyLimit = totalSupply();
783         maxSellLimit = totalSupply();
784         maxWalletLimit = totalSupply();
785 
786         taxes = Taxes(0, 0, 0);
787         sellTaxes = Taxes(0, 0, 0);
788 
789         renounceOwnership();
790 
791         emit LimitRemoved(maxBuyLimit, maxSellLimit, maxWalletLimit);
792         emit TaxesRemoved(0, 0, 0);
793     }
794 
795     function rescueETH(uint256 weiAmount) external onlyOwner{
796         payable(owner()).transfer(weiAmount);
797     }
798 
799     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
800         IERC20(tokenAdd).transfer(owner(), amount);
801     }
802 
803     // fallbacks
804     receive() external payable {}
805 }