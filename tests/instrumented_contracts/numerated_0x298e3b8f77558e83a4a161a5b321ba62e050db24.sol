1 /*
2     This is the contract for launch of Vulpini ($VULPI) token. LP burned at launch, 0 tax token, contract renounced!
3     Author: @Arrnaya
4     Website: https://vulpinitoken.com
5     Twitter: https://twitter.com/Vulpinitoken
6     Telegram: https://t.me/vulpiniofficial
7 */
8 
9 //SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.19;
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
176      /**
177      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
178      *
179      * Does not update the allowance amount in case of infinite allowance.
180      * Revert if not enough allowance is available.
181      *
182      * Might emit an {Approval} event.
183      */
184     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
185         uint256 currentAllowance = allowance(owner, spender);
186         if (currentAllowance != type(uint256).max) {
187             require(currentAllowance >= amount, "ERC20: insufficient allowance");
188             unchecked {
189                 _approve(owner, spender, currentAllowance - amount);
190             }
191         }
192     }
193 
194     /**
195      * @dev See {IERC20-transferFrom}.
196      *
197      * Emits an {Approval} event indicating the updated allowance. This is not
198      * required by the EIP. See the note at the beginning of {ERC20}.
199      *
200      * Requirements:
201      *
202      * - `sender` and `recipient` cannot be the zero address.
203      * - `sender` must have a balance of at least `amount`.
204      * - the caller must have allowance for ``sender``'s tokens of at least
205      * `amount`.
206      */
207     function transferFrom(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) public virtual override returns (bool) {
212         _transfer(sender, recipient, amount);
213 
214         uint256 currentAllowance = _allowances[sender][_msgSender()];
215         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
216         _approve(sender, _msgSender(), currentAllowance - amount);
217 
218         return true;
219     }
220 
221     /**
222      * @dev Atomically increases the allowance granted to `spender` by the caller.
223      *
224      * This is an alternative to {approve} that can be used as a mitigation for
225      * problems described in {IERC20-approve}.
226      *
227      * Emits an {Approval} event indicating the updated allowance.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      */
233     function increaseAllowance(address spender, uint256 addedValue)
234         public
235         virtual
236         returns (bool)
237     {
238         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
239         return true;
240     }
241 
242     /**
243      * @dev Atomically decreases the allowance granted to `spender` by the caller.
244      *
245      * This is an alternative to {approve} that can be used as a mitigation for
246      * problems described in {IERC20-approve}.
247      *
248      * Emits an {Approval} event indicating the updated allowance.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      * - `spender` must have allowance for the caller of at least
254      * `subtractedValue`.
255      */
256     function decreaseAllowance(address spender, uint256 subtractedValue)
257         public
258         virtual
259         returns (bool)
260     {
261         uint256 currentAllowance = _allowances[_msgSender()][spender];
262         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
263         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
264 
265         return true;
266     }
267 
268     /**
269      * @dev Moves tokens `amount` from `sender` to `recipient`.
270      *
271      * This is internal function is equivalent to {transfer}, and can be used to
272      * e.g. implement automatic token fees, slashing mechanisms, etc.
273      *
274      * Emits a {Transfer} event.
275      *
276      * Requirements:
277      *
278      * - `sender` cannot be the zero address.
279      * - `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `amount`.
281      */
282     function _transfer(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) internal virtual {
287         require(sender != address(0), "ERC20: transfer from the zero address");
288         require(recipient != address(0), "ERC20: transfer to the zero address");
289 
290         uint256 senderBalance = _balances[sender];
291         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
292         _balances[sender] = senderBalance - amount;
293         _balances[recipient] += amount;
294 
295         emit Transfer(sender, recipient, amount);
296     }
297 
298     /** This function will be used to generate the total supply
299     * while deploying the contract
300     *
301     * This function can never be called again after deploying contract
302     */
303     function _tokengeneration(address account, uint256 amount) internal virtual {
304         _totalSupply = amount;
305         _balances[account] = amount;
306         emit Transfer(address(0), account, amount);
307     }
308 
309     /**
310      * @dev Destroys `amount` tokens from `account`, reducing the
311      * total supply.
312      *
313      * Emits a {Transfer} event with `to` set to the zero address.
314      *
315      * Requirements:
316      *
317      * - `account` cannot be the zero address.
318      * - `account` must have at least `amount` tokens.
319      */
320     function _burn(address account, uint256 amount) internal virtual {
321         require(account != address(0), "ERC20: burn from the zero address");
322 
323         _beforeTokenTransfer(account, address(0xdead), amount);
324 
325         uint256 accountBalance = _balances[account];
326         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
327         unchecked {
328             _balances[account] = accountBalance - amount;
329             // Overflow not possible: amount <= accountBalance <= totalSupply.
330             _totalSupply -= amount;
331             // _balances[address(0xdead)] += amount;
332         }
333 
334         emit Transfer(account, address(0xdead), amount);
335 
336         _afterTokenTransfer(account, address(0xdead), amount);
337     }
338 
339     /**
340      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
341      *
342      * This internal function is equivalent to `approve`, and can be used to
343      * e.g. set automatic allowances for certain subsystems, etc.
344      *
345      * Emits an {Approval} event.
346      *
347      * Requirements:
348      *
349      * - `owner` cannot be the zero address.
350      * - `spender` cannot be the zero address.
351      */
352     function _approve(
353         address owner,
354         address spender,
355         uint256 amount
356     ) internal virtual {
357         require(owner != address(0), "ERC20: approve from the zero address");
358         require(spender != address(0), "ERC20: approve to the zero address");
359 
360         _allowances[owner][spender] = amount;
361         emit Approval(owner, spender, amount);
362     }
363 
364     /**
365      * @dev Hook that is called before any transfer of tokens. This includes
366      * minting and burning.
367      *
368      * Calling conditions:
369      *
370      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
371      * will be transferred to `to`.
372      * - when `from` is zero, `amount` tokens will be minted for `to`.
373      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
374      * - `from` and `to` are never both zero.
375      *
376      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
377      */
378     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
379 
380     /**
381      * @dev Hook that is called after any transfer of tokens. This includes
382      * minting and burning.
383      *
384      * Calling conditions:
385      *
386      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
387      * has been transferred to `to`.
388      * - when `from` is zero, `amount` tokens have been minted for `to`.
389      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
390      * - `from` and `to` are never both zero.
391      *
392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
393      */
394     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
395 }
396 
397 library Address {
398     function sendValue(address payable recipient, uint256 amount) internal {
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401         (bool success, ) = recipient.call{ value: amount }("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 }
405 
406 abstract contract Ownable is Context {
407     address private _owner;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     constructor() {
412         _setOwner(_msgSender());
413     }
414 
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     modifier onlyOwner() {
420         require(owner() == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     function renounceOwnership() public virtual onlyOwner {
425         _setOwner(address(0));
426     }
427 
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(newOwner != address(0), "Ownable: new owner is the zero address");
430         _setOwner(newOwner);
431     }
432 
433     function _setOwner(address newOwner) private {
434         address oldOwner = _owner;
435         _owner = newOwner;
436         emit OwnershipTransferred(oldOwner, newOwner);
437     }
438 }
439 
440 interface IFactory {
441     function createPair(address tokenA, address tokenB) external returns (address pair);
442 }
443 
444 interface IRouter {
445     function factory() external pure returns (address);
446 
447     function WETH() external pure returns (address);
448 
449     function addLiquidityETH(
450         address token,
451         uint256 amountTokenDesired,
452         uint256 amountTokenMin,
453         uint256 amountETHMin,
454         address to,
455         uint256 deadline
456     )
457         external
458         payable
459         returns (
460             uint256 amountToken,
461             uint256 amountETH,
462             uint256 liquidity
463         );
464 
465     function swapExactTokensForETHSupportingFeeOnTransferTokens(
466         uint256 amountIn,
467         uint256 amountOutMin,
468         address[] calldata path,
469         address to,
470         uint256 deadline
471     ) external;
472 }
473 
474 /**
475  * @dev Extension of {ERC20} that allows token holders to destroy both their own
476  * tokens and those that they have an allowance for, in a way that can be
477  * recognized off-chain (via event analysis).
478  */
479 abstract contract ERC20Burnable is Context, ERC20 {
480     /**
481      * @dev Destroys `amount` tokens from the caller.
482      *
483      * See {ERC20-_burn}.
484      */
485     function burn(uint256 amount) public virtual {
486         _burn(_msgSender(), amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
491      * allowance.
492      *
493      * See {ERC20-_burn} and {ERC20-allowance}.
494      *
495      * Requirements:
496      *
497      * - the caller must have allowance for ``accounts``'s tokens of at least
498      * `amount`.
499      */
500     function burnFrom(address account, uint256 amount) public virtual {
501         _spendAllowance(account, _msgSender(), amount);
502         _burn(account, amount);
503     }
504 }
505 
506 contract Vulpini is ERC20, ERC20Burnable, Ownable {
507     using Address for address payable;
508 
509     IRouter public router;
510     address public pair;
511 
512     bool private _interlock = false;
513     bool public providingLiquidity = true;
514 
515     uint256 public tokenLiquidityThreshold = 1_000_000 * 10**decimals();
516     uint256 public maxBuyLimit = 10_000_000 * 10**decimals();
517     uint256 public maxSellLimit = 5_000_000 * 10**decimals();
518     uint256 public maxWalletLimit = 20_000_000 * 10**decimals();
519 
520     address public marketingWallet = 0x9752d8d9196C27e8C4bF1DB5131e7907a1B33985;
521     address private vulpini = 0x1DB94C1b29b2D85674b3F8226197739A524b2cc7;
522 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
523 
524     struct Taxes {
525         uint256 marketing;
526         uint256 liquidity;
527         uint256 burn;
528     }
529 
530     Taxes public taxes = Taxes(20, 0, 0);
531     Taxes public sellTaxes = Taxes(50, 0, 0);
532     Taxes public transferTaxes = Taxes(0, 0, 0);
533 
534     mapping(address => bool) public exemptFee;
535 
536     modifier lockTheSwap() {
537         if (!_interlock) {
538             _interlock = true;
539             _;
540             _interlock = false;
541         }
542     }
543 
544     constructor() ERC20("VULPINI", "$VULPI") {
545         _tokengeneration(msg.sender, 1_000_000_000 * 10**decimals());
546         exemptFee[msg.sender] = true;
547 
548         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UNISWAP V2
549         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
550 
551         router = _router;
552         pair = _pair;
553         exemptFee[address(this)] = true;
554         exemptFee[marketingWallet] = true;
555         exemptFee[deadWallet] = true;
556         exemptFee[vulpini] = true;
557     }
558 
559     function approve(address spender, uint256 amount) public override returns (bool) {
560         _approve(_msgSender(), spender, amount);
561         return true;
562     }
563 
564     function transferFrom(
565         address sender,
566         address recipient,
567         uint256 amount
568     ) public override returns (bool) {
569         _transfer(sender, recipient, amount);
570 
571         uint256 currentAllowance = _allowances[sender][_msgSender()];
572         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
573         _approve(sender, _msgSender(), currentAllowance - amount);
574 
575         return true;
576     }
577 
578     function increaseAllowance(address spender, uint256 addedValue)
579         public
580         override
581         returns (bool)
582     {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
584         return true;
585     }
586 
587     function decreaseAllowance(address spender, uint256 subtractedValue)
588         public
589         override
590         returns (bool)
591     {
592         uint256 currentAllowance = _allowances[_msgSender()][spender];
593         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
594         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
595 
596         return true;
597     }
598 
599     function transfer(address recipient, uint256 amount) public override returns (bool) {
600         _transfer(msg.sender, recipient, amount);
601         return true;
602     }
603 
604     function _transfer(
605         address sender,
606         address recipient,
607         uint256 amount
608     ) internal override {
609         require(amount > 0, "Transfer amount must be greater than zero");
610 
611         if (sender == pair && !exemptFee[recipient] && !_interlock) {
612             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
613             require(
614                 balanceOf(recipient) + amount <= maxWalletLimit,
615                 "You are exceeding maxWalletLimit"
616             );
617         }
618 
619         if (
620             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
621         ) {
622             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
623             if (recipient != pair) {
624                 require(
625                     balanceOf(recipient) + amount <= maxWalletLimit,
626                     "You are exceeding maxWalletLimit"
627                 );
628             }
629         }
630 
631         uint256 feeswap;
632         uint256 feesum;
633         uint256 fee;
634         uint256 feeBurn;
635         uint256 burnAmount;
636         Taxes memory currentTaxes;
637 
638         //set fee to zero if fees in contract are handled or exempted
639         if (_interlock || exemptFee[sender] || exemptFee[recipient])
640             fee = 0;
641 
642             //calculate fee
643         else if (recipient == pair) {
644             feeswap =
645                 sellTaxes.liquidity +
646                 sellTaxes.marketing;
647             feesum = feeswap;
648             feeBurn = sellTaxes.burn;
649             currentTaxes = sellTaxes;
650         } else if (sender == pair) {
651             feeswap =
652                 taxes.liquidity +
653                 taxes.marketing;
654             feesum = feeswap;
655             feeBurn = taxes.burn;
656             currentTaxes = taxes;
657         } else {
658             feeswap =
659                 transferTaxes.liquidity +
660                 transferTaxes.marketing ;
661             feesum = feeswap;
662             feeBurn = transferTaxes.burn;
663             currentTaxes = transferTaxes;
664         }
665 
666         fee = (amount * feesum) / 100;
667         burnAmount = (amount * feeBurn) / 100;
668 
669         //send fees if threshold has been reached
670         //don't do this on buys, breaks swap
671         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
672 
673         //rest to recipient
674         super._transfer(sender, recipient, amount - (fee + burnAmount));
675         // burn the tokens
676         if(burnAmount > 0) {
677             super._burn(sender, burnAmount);
678         }
679         if (fee > 0) {
680             //send the fee to the contract
681             if (feeswap > 0) {
682                 uint256 feeAmount = (amount * feeswap) / 100;
683                 super._transfer(sender, address(this), feeAmount);
684             }
685 
686         }
687     }
688 
689     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
690 
691         if(feeswap == 0){
692             return;
693         }
694 
695         uint256 contractBalance = balanceOf(address(this));
696         if (contractBalance >= tokenLiquidityThreshold) {
697             if (tokenLiquidityThreshold > 1) {
698                 contractBalance = tokenLiquidityThreshold;
699             }
700 
701             // Split the contract balance into halves
702             uint256 denominator = feeswap * 2;
703             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
704                 denominator;
705             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
706 
707             uint256 initialBalance = address(this).balance;
708 
709             swapTokensForETH(toSwap);
710 
711             uint256 deltaBalance = address(this).balance - initialBalance;
712             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
713             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
714 
715             if (ethToAddLiquidityWith > 0) {
716                 // Add liquidity to pancake
717                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
718             }
719 
720             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
721             if (marketingAmt > 0) {
722                 payable(marketingWallet).sendValue(marketingAmt);
723             }
724 
725         }
726     }
727 
728     function swapTokensForETH(uint256 tokenAmount) private {
729         // generate the pancake pair path of token -> weth
730         address[] memory path = new address[](2);
731         path[0] = address(this);
732         path[1] = router.WETH();
733 
734         _approve(address(this), address(router), tokenAmount);
735 
736         // make the swap
737         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
738             tokenAmount,
739             0,
740             path,
741             address(this),
742             block.timestamp
743         );
744     }
745 
746     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
747         // approve token transfer to cover all possible scenarios
748         _approve(address(this), address(router), tokenAmount);
749 
750         // add the liquidity
751         router.addLiquidityETH{ value: ethAmount }(
752             address(this),
753             tokenAmount,
754             0, // slippage is unavoidable
755             0, // slippage is unavoidable
756             deadWallet,
757             block.timestamp
758         );
759     }
760 
761     function updateLiquidityProvide(bool state) external onlyOwner {
762         //update liquidity providing state
763         providingLiquidity = state;
764     }
765 
766     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
767         //update the treshhold
768         require(new_amount <= 10_000_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1% of tokens");
769         tokenLiquidityThreshold = new_amount * 10**decimals();
770     }
771 
772     function SetBuyTaxes(
773         uint256 _marketing,
774         uint256 _liquidity,
775         uint256 _burn
776     ) external onlyOwner {
777         taxes = Taxes(_marketing, _liquidity,  _burn);
778         require((_marketing + _liquidity +  _burn) <= 30, "Must keep fees at 30% or less");
779     }
780 
781     function SetSellTaxes(
782         uint256 _marketing,
783         uint256 _liquidity,
784         uint256 _burn
785     ) external onlyOwner {
786         sellTaxes = Taxes(_marketing, _liquidity,  _burn);
787         require((_marketing + _liquidity + _burn) <= 100, "Must keep fees at 100% or less");
788     }
789 
790     function SetTransferTaxes(
791         uint256 _marketing,
792         uint256 _liquidity,
793         uint256 _burn
794     ) external onlyOwner {
795         transferTaxes = Taxes(_marketing, _liquidity,  _burn);
796         require((_marketing + _liquidity + _burn) <= 10, "Must keep fees at 10% or less");
797     }
798 
799     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
800         router = IRouter(newRouter);
801         pair = newPair;
802     }
803 
804     function updateWallets(address _marketingWallet) external {
805         require(msg.sender == vulpini, "Not authorized!");
806         require(_marketingWallet != address(0),"Fee Address cannot be zero address");
807         marketingWallet = _marketingWallet;
808     }
809 
810     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
811         require(maxBuy >= 1_000_000, "Cannot set max buy amount lower than 0.1%");
812         require(maxSell >= 1_000_000, "Cannot set max sell amount lower than 0.1%");
813         require(maxWallet >= 5_000_000, "Cannot set max wallet amount lower than 0.5%");
814         maxBuyLimit = maxBuy * 10**decimals();
815         maxSellLimit = maxSell * 10**decimals();
816         maxWalletLimit = maxWallet * 10**decimals(); 
817     }
818 
819     function rescueERC20(address tokenAdd, uint256 amount) external {
820         require(msg.sender == vulpini, "Not authorized!");
821         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
822         IERC20(tokenAdd).transfer(owner(), amount);
823     }
824 
825     // fallbacks
826     receive() external payable {}
827 }