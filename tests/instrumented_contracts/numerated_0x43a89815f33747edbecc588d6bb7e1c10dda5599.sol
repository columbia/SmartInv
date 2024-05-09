1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 /**
136  * @dev Implementation of the {IERC20} interface.
137  *
138  * This implementation is agnostic to the way tokens are created. This means
139  * that a supply mechanism has to be added in a derived contract using {_mint}.
140  * For a generic mechanism see {ERC20PresetMinterPauser}.
141  *
142  * TIP: For a detailed writeup see our guide
143  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
144  * to implement supply mechanisms].
145  *
146  * We have followed general OpenZeppelin guidelines: functions revert instead
147  * of returning `false` on failure. This behavior is nonetheless conventional
148  * and does not conflict with the expectations of ERC20 applications.
149  *
150  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
151  * This allows applications to reconstruct the allowance for all accounts just
152  * by listening to said events. Other implementations of the EIP may not emit
153  * these events, as it isn't required by the specification.
154  *
155  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
156  * functions have been added to mitigate the well-known issues around setting
157  * allowances. See {IERC20-approve}.
158  */
159 contract ERC20 is Context, IERC20, IERC20Metadata {
160     mapping(address => uint256) private _balances;
161 
162     mapping(address => mapping(address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168 
169     /**
170      * @dev Sets the values for {name} and {symbol}.
171      *
172      * The defaut value of {decimals} is 18. To select a different value for
173      * {decimals} you should overload it.
174      *
175      * All two of these values are immutable: they can only be set once during
176      * construction.
177      */
178     constructor(string memory name_, string memory symbol_) {
179         _name = name_;
180         _symbol = symbol_;
181     }
182 
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() public view virtual override returns (string memory) {
187         return _name;
188     }
189 
190     /**
191      * @dev Returns the symbol of the token, usually a shorter version of the
192      * name.
193      */
194     function symbol() public view virtual override returns (string memory) {
195         return _symbol;
196     }
197 
198     /**
199      * @dev Returns the number of decimals used to get its user representation.
200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
201      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
202      *
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the value {ERC20} uses, unless this function is
205      * overridden;
206      *
207      * NOTE: This information is only used for _display_ purposes: it in
208      * no way affects any of the arithmetic of the contract, including
209      * {IERC20-balanceOf} and {IERC20-transfer}.
210      */
211     function decimals() public view virtual override returns (uint8) {
212         return 18;
213     }
214 
215     /**
216      * @dev See {IERC20-totalSupply}.
217      */
218     function totalSupply() public view virtual override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See {IERC20-balanceOf}.
224      */
225     function balanceOf(address account)
226         public
227         view
228         virtual
229         override
230         returns (uint256)
231     {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `recipient` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address recipient, uint256 amount)
244         public
245         virtual
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender)
257         public
258         view
259         virtual
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount)
274         public
275         virtual
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * Requirements:
290      *
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``sender``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302 
303         uint256 currentAllowance = _allowances[sender][_msgSender()];
304         require(
305             currentAllowance >= amount,
306             "ERC20: transfer amount exceeds allowance"
307         );
308         _approve(sender, _msgSender(), currentAllowance - amount);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue)
326         public
327         virtual
328         returns (bool)
329     {
330         _approve(
331             _msgSender(),
332             spender,
333             _allowances[_msgSender()][spender] + addedValue
334         );
335         return true;
336     }
337 
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue)
353         public
354         virtual
355         returns (bool)
356     {
357         uint256 currentAllowance = _allowances[_msgSender()][spender];
358         require(
359             currentAllowance >= subtractedValue,
360             "ERC20: decreased allowance below zero"
361         );
362         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
363 
364         return true;
365     }
366 
367     /**
368      * @dev Moves tokens `amount` from `sender` to `recipient`.
369      *
370      * This is internal function is equivalent to {transfer}, and can be used to
371      * e.g. implement automatic token fees, slashing mechanisms, etc.
372      *
373      * Emits a {Transfer} event.
374      *
375      * Requirements:
376      *
377      * - `sender` cannot be the zero address.
378      * - `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `amount`.
380      */
381     function _transfer(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) internal virtual {
386         require(sender != address(0), "ERC20: transfer from the zero address");
387         require(recipient != address(0), "ERC20: transfer to the zero address");
388 
389         _beforeTokenTransfer(sender, recipient, amount);
390 
391         uint256 senderBalance = _balances[sender];
392         require(
393             senderBalance >= amount,
394             "ERC20: transfer amount exceeds balance"
395         );
396         _balances[sender] = senderBalance - amount;
397         _balances[recipient] += amount;
398 
399         emit Transfer(sender, recipient, amount);
400     }
401 
402     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
403      * the total supply.
404      *
405      * Emits a {Transfer} event with `from` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `to` cannot be the zero address.
410      */
411     function _mint(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: mint to the zero address");
413 
414         _beforeTokenTransfer(address(0), account, amount);
415 
416         _totalSupply += amount;
417         _balances[account] += amount;
418         emit Transfer(address(0), account, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`, reducing the
423      * total supply.
424      *
425      * Emits a {Transfer} event with `to` set to the zero address.
426      *
427      * Requirements:
428      *
429      * - `account` cannot be the zero address.
430      * - `account` must have at least `amount` tokens.
431      */
432     function _burn(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: burn from the zero address");
434 
435         _beforeTokenTransfer(account, address(0), amount);
436 
437         uint256 accountBalance = _balances[account];
438         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
439         _balances[account] = accountBalance - amount;
440         _totalSupply -= amount;
441 
442         emit Transfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be to transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 }
490 
491 contract Owned {
492     address public owner;
493     address public proposedOwner;
494 
495     event OwnershipTransferred(
496         address indexed previousOwner,
497         address indexed newOwner
498     );
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor() {
504         owner = msg.sender;
505         emit OwnershipTransferred(address(0), msg.sender);
506     }
507 
508     /**
509      * @dev Throws if called by any account other than the owner.
510      */
511     modifier onlyOwner() virtual {
512         require(msg.sender == owner);
513         _;
514     }
515 
516     /**
517      * @dev propeses a new owner
518      * Can only be called by the current owner.
519      */
520     function proposeOwner(address payable _newOwner) external onlyOwner {
521         proposedOwner = _newOwner;
522     }
523 
524     /**
525      * @dev claims ownership of the contract
526      * Can only be called by the new proposed owner.
527      */
528     function claimOwnership() external {
529         require(msg.sender == proposedOwner);
530         emit OwnershipTransferred(owner, proposedOwner);
531         owner = proposedOwner;
532     }
533 }
534 
535 interface IPika {
536     function minSupply() external returns (uint256);
537 
538     function totalSupply() external view returns (uint256);
539 
540     function balanceOf(address account) external view returns (uint256);
541 
542     function transfer(address recipient, uint256 amount)
543         external
544         returns (bool);
545 
546     function transferFrom(
547         address sender,
548         address recipient,
549         uint256 amount
550     ) external returns (bool);
551 
552     function burn(uint256 value) external;
553 }
554 
555 struct Wallets {
556     address team;
557     address charity;
558     address staking;
559     address liquidity;
560 }
561 
562 contract Thunder is ERC20, Owned {
563     IPika pika;
564     Wallets public pikaWallets;
565     address public beneficiary;
566     bool public feesEnabled;
567     mapping(address => bool) public isExcludedFromFee;
568 
569     event BeneficiaryUpdated(address oldBeneficiary, address newBeneficiary);
570     event FeesEnabledUpdated(bool enabled);
571     event ExcludedFromFeeUpdated(address account, bool excluded);
572     event PikaWalletsUpdated();
573     event Evolved(uint256 amountPika, uint256 amountThunder);
574 
575     constructor(address _pika, Wallets memory _pikaWallets)
576         ERC20("THUNDER", "THUN")
577     {
578         pika = IPika(_pika);
579         pikaWallets = _pikaWallets;
580         // premine for uniswap liquidity
581         uint256 totalSupply = 70000000 ether;
582         feesEnabled = false;
583         _mint(_msgSender(), totalSupply);
584         isExcludedFromFee[msg.sender] = true;
585         isExcludedFromFee[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
586         beneficiary = msg.sender;
587     }
588 
589     function evolve(uint256 _amountPika) external {
590         pika.transferFrom(msg.sender, address(this), _amountPika);
591         uint256 amountThunder = _amountPika / 10000;
592 
593         uint256 burnedPika = calculateFee(_amountPika, 2500);
594         if (pika.totalSupply() - burnedPika >= pika.minSupply()) {
595             pika.burn(burnedPika);
596         } else {
597             burnedPika = 0;
598         }
599 
600         uint256 lpRewards = calculateFee(_amountPika, 100);
601         uint256 charityTeamAmount = lpRewards / 4;
602         pika.transfer(pikaWallets.liquidity, lpRewards);
603         pika.transfer(pikaWallets.charity, charityTeamAmount);
604         pika.transfer(pikaWallets.team, charityTeamAmount);
605 
606         pika.transfer(
607             pikaWallets.staking,
608             _amountPika - burnedPika - lpRewards - charityTeamAmount * 2
609         );
610 
611         _mint(msg.sender, amountThunder);
612         emit Evolved(_amountPika, amountThunder);
613     }
614 
615     /**
616      * @dev if fees are enabled, subtract 2.25% fee and send it to beneficiary
617      * @dev after a certain threshold, try to swap collected fees automatically
618      * @dev if automatic swap fails (or beneficiary does not implement swapTokens function) transfer should still succeed
619      */
620     function _transfer(
621         address sender,
622         address recipient,
623         uint256 amount
624     ) internal override {
625         require(
626             recipient != address(this),
627             "Cannot send tokens to token contract"
628         );
629         if (
630             !feesEnabled ||
631             isExcludedFromFee[sender] ||
632             isExcludedFromFee[recipient]
633         ) {
634             ERC20._transfer(sender, recipient, amount);
635             return;
636         }
637         uint256 burnedFee = calculateFee(amount, 25);
638         _burn(sender, burnedFee);
639 
640         uint256 transferFee = calculateFee(amount, 200);
641         ERC20._transfer(sender, beneficiary, transferFee);
642         ERC20._transfer(sender, recipient, amount - transferFee - burnedFee);
643     }
644 
645     function calculateFee(uint256 _amount, uint256 _fee)
646         public
647         pure
648         returns (uint256)
649     {
650         return (_amount * _fee) / 10000;
651     }
652 
653     /**
654      * @notice allows to burn tokens from own balance
655      * @dev only allows burning tokens until minimum supply is reached
656      * @param value amount of tokens to burn
657      */
658     function burn(uint256 value) public {
659         _burn(_msgSender(), value);
660     }
661 
662     /**
663      * @notice sets recipient of transfer fee
664      * @dev only callable by owner
665      * @param _newBeneficiary new beneficiary
666      */
667     function setBeneficiary(address _newBeneficiary) public onlyOwner {
668         setExcludeFromFee(_newBeneficiary, true);
669         emit BeneficiaryUpdated(beneficiary, _newBeneficiary);
670         beneficiary = _newBeneficiary;
671     }
672 
673     /**
674      * @notice sets the wallets for the pika tokens
675      * @dev only callable by owner
676      * @param _newWallets updated wallets
677      */
678     function setPikaWallets(Wallets memory _newWallets) public onlyOwner {
679         emit PikaWalletsUpdated();
680         pikaWallets = _newWallets;
681     }
682 
683     /**
684      * @notice sets whether account collects fees on token transfer
685      * @dev only callable by owner
686      * @param _enabled bool whether fees are enabled
687      */
688     function setFeesEnabled(bool _enabled) public onlyOwner {
689         emit FeesEnabledUpdated(_enabled);
690         feesEnabled = _enabled;
691     }
692 
693     /**
694      * @notice adds or removes an account that is exempt from fee collection
695      * @dev only callable by owner
696      * @param _account account to modify
697      * @param _excluded new value
698      */
699     function setExcludeFromFee(address _account, bool _excluded)
700         public
701         onlyOwner
702     {
703         isExcludedFromFee[_account] = _excluded;
704         emit ExcludedFromFeeUpdated(_account, _excluded);
705     }
706 }