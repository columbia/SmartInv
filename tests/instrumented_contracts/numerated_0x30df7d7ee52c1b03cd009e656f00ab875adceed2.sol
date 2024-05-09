1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-04-24
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-04-14
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `to`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address to, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `from` to `to` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address from,
175         address to,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Interface for the optional metadata functions from the ERC20 standard.
200  *
201  * _Available since v4.1._
202  */
203 interface IERC20Metadata is IERC20 {
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the symbol of the token.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the decimals places of the token.
216      */
217     function decimals() external view returns (uint8);
218 }
219 
220 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
221 
222 pragma solidity ^0.8.0;
223 /**
224  * @dev Implementation of the {IERC20} interface.
225  *
226  * This implementation is agnostic to the way tokens are created. This means
227  * that a supply mechanism has to be added in a derived contract using {_mint}.
228  * For a generic mechanism see {ERC20PresetMinterPauser}.
229  *
230  * TIP: For a detailed writeup see our guide
231  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
232  * to implement supply mechanisms].
233  *
234  * We have followed general OpenZeppelin Contracts guidelines: functions revert
235  * instead returning `false` on failure. This behavior is nonetheless
236  * conventional and does not conflict with the expectations of ERC20
237  * applications.
238  *
239  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
240  * This allows applications to reconstruct the allowance for all accounts just
241  * by listening to said events. Other implementations of the EIP may not emit
242  * these events, as it isn't required by the specification.
243  *
244  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
245  * functions have been added to mitigate the well-known issues around setting
246  * allowances. See {IERC20-approve}.
247  */
248 contract ERC20 is Context, IERC20, IERC20Metadata {
249     mapping(address => uint256) private _balances;
250 
251     mapping(address => mapping(address => uint256)) private _allowances;
252 
253     uint256 private _totalSupply;
254 
255     string private _name;
256     string private _symbol;
257 
258     /**
259      * @dev Sets the values for {name} and {symbol}.
260      *
261      * The default value of {decimals} is 18. To select a different value for
262      * {decimals} you should overload it.
263      *
264      * All two of these values are immutable: they can only be set once during
265      * construction.
266      */
267     constructor(string memory name_, string memory symbol_) {
268         _name = name_;
269         _symbol = symbol_;
270     }
271 
272     /**
273      * @dev Returns the name of the token.
274      */
275     function name() public view virtual override returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @dev Returns the symbol of the token, usually a shorter version of the
281      * name.
282      */
283     function symbol() public view virtual override returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @dev Returns the number of decimals used to get its user representation.
289      * For example, if `decimals` equals `2`, a balance of `505` tokens should
290      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
291      *
292      * Tokens usually opt for a value of 18, imitating the relationship between
293      * Ether and Wei. This is the value {ERC20} uses, unless this function is
294      * overridden;
295      *
296      * NOTE: This information is only used for _display_ purposes: it in
297      * no way affects any of the arithmetic of the contract, including
298      * {IERC20-balanceOf} and {IERC20-transfer}.
299      */
300     function decimals() public view virtual override returns (uint8) {
301         return 18;
302     }
303 
304     /**
305      * @dev See {IERC20-totalSupply}.
306      */
307     function totalSupply() public view virtual override returns (uint256) {
308         return _totalSupply;
309     }
310 
311     /**
312      * @dev See {IERC20-balanceOf}.
313      */
314     function balanceOf(address account) public view virtual override returns (uint256) {
315         return _balances[account];
316     }
317 
318     /**
319      * @dev See {IERC20-transfer}.
320      *
321      * Requirements:
322      *
323      * - `to` cannot be the zero address.
324      * - the caller must have a balance of at least `amount`.
325      */
326     function transfer(address to, uint256 amount) public virtual override returns (bool) {
327         address owner = _msgSender();
328         _transfer(owner, to, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-allowance}.
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See {IERC20-approve}.
341      *
342      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
343      * `transferFrom`. This is semantically equivalent to an infinite approval.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         address owner = _msgSender();
351         _approve(owner, spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * NOTE: Does not update the allowance if the current allowance
362      * is the maximum `uint256`.
363      *
364      * Requirements:
365      *
366      * - `from` and `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``from``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address from,
373         address to,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         address spender = _msgSender();
377         _spendAllowance(from, spender, amount);
378         _transfer(from, to, amount);
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
395         address owner = _msgSender();
396         _approve(owner, spender, _allowances[owner][spender] + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         address owner = _msgSender();
416         uint256 currentAllowance = _allowances[owner][spender];
417         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
418         unchecked {
419             _approve(owner, spender, currentAllowance - subtractedValue);
420         }
421 
422         return true;
423     }
424 
425     /**
426      * @dev Moves `amount` of tokens from `sender` to `recipient`.
427      *
428      * This internal function is equivalent to {transfer}, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a {Transfer} event.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `from` must have a balance of at least `amount`.
438      */
439     function _transfer(
440         address from,
441         address to,
442         uint256 amount
443     ) internal virtual {
444         require(from != address(0), "ERC20: transfer from the zero address");
445         require(to != address(0), "ERC20: transfer to the zero address");
446 
447         _beforeTokenTransfer(from, to, amount);
448 
449         uint256 fromBalance = _balances[from];
450         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
451         unchecked {
452             _balances[from] = fromBalance - amount;
453         }
454         _balances[to] += amount;
455 
456         emit Transfer(from, to, amount);
457 
458         _afterTokenTransfer(from, to, amount);
459     }
460 
461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
462      * the total supply.
463      *
464      * Emits a {Transfer} event with `from` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      */
470     function _mint(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: mint to the zero address");
472 
473         _beforeTokenTransfer(address(0), account, amount);
474 
475         _totalSupply += amount;
476         _balances[account] += amount;
477         emit Transfer(address(0), account, amount);
478 
479         _afterTokenTransfer(address(0), account, amount);
480     }
481 
482     /**
483      * @dev Destroys `amount` tokens from `account`, reducing the
484      * total supply.
485      *
486      * Emits a {Transfer} event with `to` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      * - `account` must have at least `amount` tokens.
492      */
493     function _burn(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: burn from the zero address");
495 
496         _beforeTokenTransfer(account, address(0), amount);
497 
498         uint256 accountBalance = _balances[account];
499         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
500         unchecked {
501             _balances[account] = accountBalance - amount;
502         }
503         _totalSupply -= amount;
504 
505         emit Transfer(account, address(0), amount);
506 
507         _afterTokenTransfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
512      *
513      * This internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(
524         address owner,
525         address spender,
526         uint256 amount
527     ) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
537      *
538      * Does not update the allowance amount in case of infinite allowance.
539      * Revert if not enough allowance is available.
540      *
541      * Might emit an {Approval} event.
542      */
543     function _spendAllowance(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         uint256 currentAllowance = allowance(owner, spender);
549         if (currentAllowance != type(uint256).max) {
550             require(currentAllowance >= amount, "ERC20: insufficient allowance");
551             unchecked {
552                 _approve(owner, spender, currentAllowance - amount);
553             }
554         }
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 
577     /**
578      * @dev Hook that is called after any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * has been transferred to `to`.
585      * - when `from` is zero, `amount` tokens have been minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _afterTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 }
597 
598 pragma solidity ^0.8.7;
599 
600 contract RESET is ERC20, Ownable {
601     /* Token Tax */
602     uint32 public _taxPercision = 100000;
603     address[] public _taxRecipients;
604     uint16 public _taxTotal;
605     bool public _taxActive;
606     bool public _txnLimitActive;
607 
608     uint _holdingCapPercent = 1;
609 
610     mapping(address => uint16) public _taxRecipientAmounts;
611     mapping(address => bool) private _isTaxRecipient;
612     mapping(address => bool) public _whitelisted;
613 
614     /* Events */
615     event UpdateTaxPercentage(address indexed wallet, uint16 _newTaxAmount);
616     event AddTaxRecipient(address indexed wallet, uint16 _taxAmount);
617     event RemoveFromWhitelist(address indexed wallet);
618     event RemoveTaxRecipient(address indexed wallet);
619     event AddToWhitelist(address indexed wallet);
620     event ToggleTax(bool _active);
621     event ToggleTxnLimit(bool _active);
622 
623     uint256 private _totalSupply;
624 
625     /**
626      * @dev Constructor.
627      */
628     constructor() ERC20('MetaReset', 'RESET') payable {
629       _totalSupply = 1000000000 * (10**18);
630 
631       _mint(msg.sender, _totalSupply);
632     }
633 
634 
635     /**
636       * @notice overrides ERC20 transferFrom function to introduce tax functionality
637       * @param from address amount is coming from
638       * @param to address amount is going to
639       * @param amount amount being sent
640      */
641     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
642         address spender = _msgSender();
643         _spendAllowance(from, spender, amount);
644         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
645         if(_taxActive && !_whitelisted[from] && !_whitelisted[to]) {
646           uint256 tax = amount *_taxTotal / _taxPercision;
647           amount = amount - tax;
648           _transfer(from, address(this), tax);
649         }
650         _transfer(from, to, amount);
651         return true;
652     }
653 
654 
655     /**
656       * @notice : overrides ERC20 transfer function to introduce tax functionality
657       * @param to address amount is going to
658       * @param amount amount being sent
659      */
660     function transfer(address to, uint256 amount) public virtual override returns (bool) {
661       address owner = _msgSender();
662       require(balanceOf(owner) >= amount, "ERC20: transfer amount exceeds balance");
663       require(!_txnLimitActive || balanceOf(to)+ amount <= ((_totalSupply * _holdingCapPercent) / 100), "Max holding cap breached.");
664       if(_taxActive && !_whitelisted[owner] && !_whitelisted[to]) {
665         uint256 tax = amount*_taxTotal/_taxPercision;
666         amount = amount - tax;
667         _transfer(owner, address(this), tax);
668       }
669       _transfer(owner, to, amount);
670       return true;
671     }
672 
673     /**
674      * @dev Burns a specific amount of tokens.
675      * @param value The amount of lowest token units to be burned.
676      */
677     function burn(uint256 value) public {
678       _burn(msg.sender, value);
679     }
680 
681     /* ADMIN Functions */
682     /**
683        * @notice : toggles the tax on or off
684     */
685     function toggleTax() external onlyOwner {
686       _taxActive = !_taxActive;
687       emit ToggleTax(_taxActive);
688     }
689     /**
690        * @notice : toggles the txn limit on or off
691     */
692     function toggleTxnLimit() external onlyOwner {
693       _txnLimitActive = !_txnLimitActive;
694       emit ToggleTxnLimit(_txnLimitActive);
695     }
696 
697     /**
698       * @notice : adds address with tax amount to taxable addresses list
699       * @param wallet address to add
700       * @param _tax tax amount this address receives
701     */
702     function addTaxRecipient(address wallet, uint16 _tax) external onlyOwner {
703       require(_taxRecipients.length < 100, "Reached maximum number of tax addresses");
704       require(wallet != address(0), "Cannot add 0 address");
705       require(!_isTaxRecipient[wallet], "Recipient already added");
706       require(_tax > 0 && _tax + _taxTotal <= _taxPercision/10, "Total tax amount must be between 0 and 10%");
707 
708       _isTaxRecipient[wallet] = true;
709       _taxRecipients.push(wallet);
710       _taxRecipientAmounts[wallet] = _tax;
711       _taxTotal = _taxTotal + _tax;
712       emit AddTaxRecipient(wallet, _tax);
713     }
714 
715     /**
716       * @notice : updates address tax amount
717       * @param wallet address to update
718       * @param newTax new tax amount
719      */
720     function updateTaxPercentage(address wallet, uint16 newTax) external onlyOwner {
721       require(wallet != address(0), "Cannot add 0 address");
722       require(_isTaxRecipient[wallet], "Not a tax address");
723 
724       uint16 currentTax = _taxRecipientAmounts[wallet];
725       require(currentTax != newTax, "Tax already this amount for this address");
726 
727       if(currentTax < newTax) {
728         uint16 diff = newTax - currentTax;
729         require(_taxTotal + diff <= 10000, "Tax amount too high for current tax rate");
730         _taxTotal = _taxTotal + diff;
731       } else {
732         uint16 diff = currentTax - newTax;
733         _taxTotal = _taxTotal - diff;
734       }
735       _taxRecipientAmounts[wallet] = newTax;
736       emit UpdateTaxPercentage(wallet, newTax);
737     }
738 
739     /**
740       * @notice : remove address from taxed list
741       * @param wallet address to remove
742      */
743     function removeTaxRecipient(address wallet) external onlyOwner {
744       require(wallet != address(0), "Cannot add 0 address");
745       require(_isTaxRecipient[wallet], "Recipient has not been added");
746       uint16 _tax = _taxRecipientAmounts[wallet];
747 
748       for(uint8 i = 0; i < _taxRecipients.length; i++) {
749         if(_taxRecipients[i] == wallet) {
750           _taxTotal = _taxTotal - _tax;
751           _taxRecipientAmounts[wallet] = 0;
752           _taxRecipients[i] = _taxRecipients[_taxRecipients.length - 1];
753           _isTaxRecipient[wallet] = false;
754           _taxRecipients.pop();
755           emit RemoveTaxRecipient(wallet);
756 
757           break;
758         }
759       }
760     }
761 
762     /**
763     * @notice : add address to tax whitelist
764     * @param wallet address to add to whitelist
765     */
766     function addToWhitelist(address wallet) external onlyOwner {
767       require(wallet != address(0), "Cant use 0 address");
768       require(!_whitelisted[wallet], "Address already added");
769       _whitelisted[wallet] = true;
770 
771       emit AddToWhitelist(wallet);
772     }
773 
774     /**
775     * @notice : add address to whitelist (non taxed)
776     * @param wallet address to remove from whitelist
777     */
778     function removeFromWhitelist(address wallet) external onlyOwner {
779       require(wallet != address(0), "Cant use 0 address");
780       require(_whitelisted[wallet], "Address not added");
781       _whitelisted[wallet] = false;
782 
783       emit RemoveFromWhitelist(wallet);
784     }
785 
786     /**
787     * @notice : resets tax settings to initial state
788     */
789     function taxReset() external onlyOwner {
790       _taxActive = false;
791       _taxTotal = 0;
792 
793       for(uint8 i = 0; i < _taxRecipients.length; i++) {
794         _taxRecipientAmounts[_taxRecipients[i]] = 0;
795         _isTaxRecipient[_taxRecipients[i]] = false;
796       }
797 
798       delete _taxRecipients;
799     }
800 
801     /**
802       * @notice : withdraws taxable amount to tax recipients
803      */
804     function distributeTaxes() external onlyOwner {
805       require(balanceOf(address(this)) > 0, "Nothing to withdraw");
806       uint256 taxableAmount = balanceOf(address(this));
807       for(uint8 i = 0; i < _taxRecipients.length; i++) {
808         address taxAddress = _taxRecipients[i];
809         if(i == _taxRecipients.length - 1) {
810            _transfer(address(this), taxAddress, balanceOf(address(this)));
811         } else {
812           uint256 amount = taxableAmount * _taxRecipientAmounts[taxAddress]/_taxTotal;
813           _transfer(address(this), taxAddress, amount);
814         }
815       }
816     }
817 }