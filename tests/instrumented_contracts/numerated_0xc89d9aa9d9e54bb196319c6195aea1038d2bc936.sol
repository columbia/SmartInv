1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `to` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address to, uint256 amount) public virtual override returns (bool) {
341         address owner = _msgSender();
342         _transfer(owner, to, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
357      * `transferFrom`. This is semantically equivalent to an infinite approval.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         address owner = _msgSender();
365         _approve(owner, spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * NOTE: Does not update the allowance if the current allowance
376      * is the maximum `uint256`.
377      *
378      * Requirements:
379      *
380      * - `from` and `to` cannot be the zero address.
381      * - `from` must have a balance of at least `amount`.
382      * - the caller must have allowance for ``from``'s tokens of at least
383      * `amount`.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 amount
389     ) public virtual override returns (bool) {
390         address spender = _msgSender();
391         _spendAllowance(from, spender, amount);
392         _transfer(from, to, amount);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically increases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
409         address owner = _msgSender();
410         _approve(owner, spender, allowance(owner, spender) + addedValue);
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         address owner = _msgSender();
430         uint256 currentAllowance = allowance(owner, spender);
431         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
432         unchecked {
433             _approve(owner, spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `from` to `to`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `from` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {
458         require(from != address(0), "ERC20: transfer from the zero address");
459         require(to != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(from, to, amount);
462 
463         uint256 fromBalance = _balances[from];
464         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
465         unchecked {
466             _balances[from] = fromBalance - amount;
467             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
468             // decrementing then incrementing.
469             _balances[to] += amount;
470         }
471 
472         emit Transfer(from, to, amount);
473 
474         _afterTokenTransfer(from, to, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply += amount;
492         unchecked {
493             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
494             _balances[account] += amount;
495         }
496         emit Transfer(address(0), account, amount);
497 
498         _afterTokenTransfer(address(0), account, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`, reducing the
503      * total supply.
504      *
505      * Emits a {Transfer} event with `to` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      * - `account` must have at least `amount` tokens.
511      */
512     function _burn(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: burn from the zero address");
514 
515         _beforeTokenTransfer(account, address(0), amount);
516 
517         uint256 accountBalance = _balances[account];
518         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
519         unchecked {
520             _balances[account] = accountBalance - amount;
521             // Overflow not possible: amount <= accountBalance <= totalSupply.
522             _totalSupply -= amount;
523         }
524 
525         emit Transfer(account, address(0), amount);
526 
527         _afterTokenTransfer(account, address(0), amount);
528     }
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
557      *
558      * Does not update the allowance amount in case of infinite allowance.
559      * Revert if not enough allowance is available.
560      *
561      * Might emit an {Approval} event.
562      */
563     function _spendAllowance(
564         address owner,
565         address spender,
566         uint256 amount
567     ) internal virtual {
568         uint256 currentAllowance = allowance(owner, spender);
569         if (currentAllowance != type(uint256).max) {
570             require(currentAllowance >= amount, "ERC20: insufficient allowance");
571             unchecked {
572                 _approve(owner, spender, currentAllowance - amount);
573             }
574         }
575     }
576 
577     /**
578      * @dev Hook that is called before any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * will be transferred to `to`.
585      * - when `from` is zero, `amount` tokens will be minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _beforeTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 
597     /**
598      * @dev Hook that is called after any transfer of tokens. This includes
599      * minting and burning.
600      *
601      * Calling conditions:
602      *
603      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
604      * has been transferred to `to`.
605      * - when `from` is zero, `amount` tokens have been minted for `to`.
606      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
607      * - `from` and `to` are never both zero.
608      *
609      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
610      */
611     function _afterTokenTransfer(
612         address from,
613         address to,
614         uint256 amount
615     ) internal virtual {}
616 }
617 
618 // File: contracts/token/ERC20/extensions/ERC20Decimals.sol
619 
620 
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @title ERC20Decimals
626  * @dev Extension of {ERC20} that adds decimals storage slot.
627  */
628 abstract contract ERC20Decimals is ERC20 {
629     uint8 private immutable _decimals;
630 
631     /**
632      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
633      * set once during construction.
634      */
635     constructor(uint8 decimals_) {
636         _decimals = decimals_;
637     }
638 
639     function decimals() public view virtual override returns (uint8) {
640         return _decimals;
641     }
642 }
643 
644 // File: contracts/token/ERC20/extensions/ERC20Taxable.sol
645 
646 
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @title ERC20Taxable
652  * @dev Extension of {ERC20} that adds a tax rate per mille.
653  */
654 abstract contract ERC20Taxable is ERC20 {
655     uint256 private _taxRate;
656     address private _taxAddress;
657 
658     mapping(address => bool) private _isExcludedFromTaxFee;
659 
660     /**
661      * @dev Sets the value of the `taxFeePerMille` and the `taxAddress`.
662      */
663     constructor(uint256 taxFeePerMille_, address taxAddress_) {
664         _setTaxRate(taxFeePerMille_);
665         _setTaxAddress(taxAddress_);
666         _setExclusionFromTaxFee(_msgSender(), true);
667         _setExclusionFromTaxFee(taxAddress_, true);
668     }
669 
670     /**
671      * @dev Moves `amount` of tokens from `sender` to `recipient` minus the tax fee.
672      * Moves the tax fee to a deposit address.
673      *
674      * Requirements:
675      *
676      * - `to` cannot be the zero address.
677      * - the caller must have a balance of at least `amount`.
678      */
679     function transfer(address to, uint256 amount) public virtual override returns (bool) {
680         address owner = _msgSender();
681 
682         if (_taxRate > 0 && !(_isExcludedFromTaxFee[owner] || _isExcludedFromTaxFee[to])) {
683             uint256 taxAmount = (amount * _taxRate) / 1000;
684 
685             if (taxAmount > 0) {
686                 _transfer(owner, _taxAddress, taxAmount);
687                 unchecked {
688                     amount -= taxAmount;
689                 }
690             }
691         }
692 
693         _transfer(owner, to, amount);
694 
695         return true;
696     }
697 
698     /**
699      * @dev Moves `amount` tokens from `from` to `to` minus the tax fee using the allowance mechanism.
700      * `amount` is then deducted from the caller's allowance.
701      * Moves the tax fee to a deposit address.
702      *
703      * Requirements:
704      *
705      * - `from` and `to` cannot be the zero address.
706      * - `from` must have a balance of at least `amount`.
707      * - the caller must have allowance for ``from``'s tokens of at least `amount`.
708      */
709     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
710         address spender = _msgSender();
711         _spendAllowance(from, spender, amount);
712 
713         if (_taxRate > 0 && !(_isExcludedFromTaxFee[from] || _isExcludedFromTaxFee[to])) {
714             uint256 taxAmount = (amount * _taxRate) / 1000;
715 
716             if (taxAmount > 0) {
717                 _transfer(from, _taxAddress, taxAmount);
718                 unchecked {
719                     amount -= taxAmount;
720                 }
721             }
722         }
723 
724         _transfer(from, to, amount);
725 
726         return true;
727     }
728 
729     /**
730      * @dev Returns the per mille rate for taxable mechanism.
731      *
732      * For each transfer the per mille amount will be calculated and moved to deposit address.
733      */
734     function taxFeePerMille() public view returns (uint256) {
735         return _taxRate;
736     }
737 
738     /**
739      * @dev Returns the deposit address for tax.
740      */
741     function taxAddress() public view returns (address) {
742         return _taxAddress;
743     }
744 
745     /**
746      * @dev Returns the status of exclusion from tax fee mechanism for a given account.
747      */
748     function isExcludedFromTaxFee(address account) public view returns (bool) {
749         return _isExcludedFromTaxFee[account];
750     }
751 
752     /**
753      * @dev Set the amount of tax fee per mille
754      *
755      * WARNING: it allows everyone to set the fee. Access controls MUST be defined in derived contracts.
756      */
757     function _setTaxRate(uint256 taxFeePerMille_) internal virtual {
758         require(taxFeePerMille_ < 1000, "ERC20Taxable: taxFeePerMille_ must be less than 1000");
759 
760         _taxRate = taxFeePerMille_;
761     }
762 
763     /**
764      * @dev Set the deposit address for tax
765      *
766      * WARNING: it allows everyone to set the address. Access controls MUST be defined in derived contracts.
767      */
768     function _setTaxAddress(address taxAddress_) internal virtual {
769         require(taxAddress_ != address(0), "ERC20Taxable: taxAddress_ cannot be the zero address");
770 
771         _taxAddress = taxAddress_;
772     }
773 
774     /**
775      * @dev Set the exclusion status from tax fee mechanism (both sending and receiving)
776      *
777      * WARNING: it allows everyone to set the status. Access controls MUST be defined in derived contracts.
778      */
779     function _setExclusionFromTaxFee(address account_, bool status_) internal virtual {
780         _isExcludedFromTaxFee[account_] = status_;
781     }
782 }
783 
784 // File: contracts/service/ServicePayer.sol
785 
786 
787 
788 pragma solidity ^0.8.0;
789 
790 interface IPayable {
791     function pay(string memory serviceName, bytes memory signature, address wallet) external payable;
792 }
793 
794 /**
795  * @title ServicePayer
796  * @dev Implementation of the ServicePayer
797  */
798 abstract contract ServicePayer {
799     constructor(address payable receiver, string memory serviceName, bytes memory signature, address wallet) payable {
800         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
801     }
802 }
803 
804 // File: contracts/token/ERC20/TaxableERC20.sol
805 
806 
807 
808 pragma solidity ^0.8.0;
809 
810 
811 
812 /**
813  * @title TaxableERC20
814  * @dev Implementation of the TaxableERC20
815  */
816 contract TaxableERC20 is ERC20Decimals, ERC20Taxable, Ownable, ServicePayer {
817     constructor(
818         string memory name_,
819         string memory symbol_,
820         uint8 decimals_,
821         uint256 initialBalance_,
822         uint256 taxFeePerMille_,
823         address taxAddress_,
824         bytes memory signature_,
825         address payable feeReceiver_
826     )
827         payable
828         ERC20(name_, symbol_)
829         ERC20Decimals(decimals_)
830         ERC20Taxable(taxFeePerMille_, taxAddress_)
831         ServicePayer(feeReceiver_, "TaxableERC20", signature_, _msgSender())
832     {
833         require(initialBalance_ > 0, "TaxableERC20: supply cannot be zero");
834 
835         _mint(_msgSender(), initialBalance_);
836     }
837 
838     /**
839      * @dev Set the amount of tax fee per mille
840      *
841      * NOTE: restricting access to owner only. See {ERC20Taxable-_setTaxRate}.
842      *
843      * @param taxFeePerMille The amount of tax fee per mille
844      */
845     function setTaxFeePerMille(uint256 taxFeePerMille) public onlyOwner {
846         _setTaxRate(taxFeePerMille);
847     }
848 
849     /**
850      * @dev Set the address where to collect tax fee
851      *
852      * NOTE: restricting access to owner only. See {ERC20Taxable-_setTaxAddress}.
853      *
854      * @param taxAddress The deposit address for tax
855      */
856     function setTaxAddress(address taxAddress) public onlyOwner {
857         _setTaxAddress(taxAddress);
858     }
859 
860     /**
861      * @dev Set the exclusion status from tax fee mechanism (both sending and receiving)
862      *
863      * NOTE: restricting access to owner only. See {ERC20Taxable-_setExclusionFromTaxFee}.
864      */
865     function setExclusionFromTaxFee(address account, bool status) public onlyOwner {
866         _setExclusionFromTaxFee(account, status);
867     }
868 
869     function transfer(address to, uint256 amount) public virtual override(ERC20, ERC20Taxable) returns (bool) {
870         return super.transfer(to, amount);
871     }
872 
873     function transferFrom(
874         address from,
875         address to,
876         uint256 amount
877     ) public virtual override(ERC20, ERC20Taxable) returns (bool) {
878         return super.transferFrom(from, to, amount);
879     }
880 
881     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
882         return super.decimals();
883     }
884 }
