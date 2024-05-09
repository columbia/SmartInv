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
33 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
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
85      * `onlyOwner` functions. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby disabling any functionality that is only available to the owner.
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
117 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
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
192     function transferFrom(address from, address to, uint256 amount) external returns (bool);
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * The default value of {decimals} is 18. To change this, you should override
245  * this function so it returns a different value.
246  *
247  * We have followed general OpenZeppelin Contracts guidelines: functions revert
248  * instead returning `false` on failure. This behavior is nonetheless
249  * conventional and does not conflict with the expectations of ERC20
250  * applications.
251  *
252  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
253  * This allows applications to reconstruct the allowance for all accounts just
254  * by listening to said events. Other implementations of the EIP may not emit
255  * these events, as it isn't required by the specification.
256  *
257  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
258  * functions have been added to mitigate the well-known issues around setting
259  * allowances. See {IERC20-approve}.
260  */
261 contract ERC20 is Context, IERC20, IERC20Metadata {
262     mapping(address => uint256) private _balances;
263 
264     mapping(address => mapping(address => uint256)) private _allowances;
265 
266     uint256 private _totalSupply;
267 
268     string private _name;
269     string private _symbol;
270 
271     /**
272      * @dev Sets the values for {name} and {symbol}.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the default value returned by this function, unless
304      * it's overridden.
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `to` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address to, uint256 amount) public virtual override returns (bool) {
337         address owner = _msgSender();
338         _transfer(owner, to, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-allowance}.
344      */
345     function allowance(address owner, address spender) public view virtual override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     /**
350      * @dev See {IERC20-approve}.
351      *
352      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
353      * `transferFrom`. This is semantically equivalent to an infinite approval.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public virtual override returns (bool) {
360         address owner = _msgSender();
361         _approve(owner, spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * NOTE: Does not update the allowance if the current allowance
372      * is the maximum `uint256`.
373      *
374      * Requirements:
375      *
376      * - `from` and `to` cannot be the zero address.
377      * - `from` must have a balance of at least `amount`.
378      * - the caller must have allowance for ``from``'s tokens of at least
379      * `amount`.
380      */
381     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
382         address spender = _msgSender();
383         _spendAllowance(from, spender, amount);
384         _transfer(from, to, amount);
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         address owner = _msgSender();
402         _approve(owner, spender, allowance(owner, spender) + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         address owner = _msgSender();
422         uint256 currentAllowance = allowance(owner, spender);
423         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
424         unchecked {
425             _approve(owner, spender, currentAllowance - subtractedValue);
426         }
427 
428         return true;
429     }
430 
431     /**
432      * @dev Moves `amount` of tokens from `from` to `to`.
433      *
434      * This internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `from` must have a balance of at least `amount`.
444      */
445     function _transfer(address from, address to, uint256 amount) internal virtual {
446         require(from != address(0), "ERC20: transfer from the zero address");
447         require(to != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(from, to, amount);
450 
451         uint256 fromBalance = _balances[from];
452         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
453         unchecked {
454             _balances[from] = fromBalance - amount;
455             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
456             // decrementing then incrementing.
457             _balances[to] += amount;
458         }
459 
460         emit Transfer(from, to, amount);
461 
462         _afterTokenTransfer(from, to, amount);
463     }
464 
465     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
466      * the total supply.
467      *
468      * Emits a {Transfer} event with `from` set to the zero address.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function _mint(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: mint to the zero address");
476 
477         _beforeTokenTransfer(address(0), account, amount);
478 
479         _totalSupply += amount;
480         unchecked {
481             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
482             _balances[account] += amount;
483         }
484         emit Transfer(address(0), account, amount);
485 
486         _afterTokenTransfer(address(0), account, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         uint256 accountBalance = _balances[account];
506         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
507         unchecked {
508             _balances[account] = accountBalance - amount;
509             // Overflow not possible: amount <= accountBalance <= totalSupply.
510             _totalSupply -= amount;
511         }
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(address owner, address spender, uint256 amount) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
541      *
542      * Does not update the allowance amount in case of infinite allowance.
543      * Revert if not enough allowance is available.
544      *
545      * Might emit an {Approval} event.
546      */
547     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
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
571     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
572 
573     /**
574      * @dev Hook that is called after any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * has been transferred to `to`.
581      * - when `from` is zero, `amount` tokens have been minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
599  */
600 abstract contract ERC20Capped is ERC20 {
601     uint256 private immutable _cap;
602 
603     /**
604      * @dev Sets the value of the `cap`. This value is immutable, it can only be
605      * set once during construction.
606      */
607     constructor(uint256 cap_) {
608         require(cap_ > 0, "ERC20Capped: cap is 0");
609         _cap = cap_;
610     }
611 
612     /**
613      * @dev Returns the cap on the token's total supply.
614      */
615     function cap() public view virtual returns (uint256) {
616         return _cap;
617     }
618 
619     /**
620      * @dev See {ERC20-_mint}.
621      */
622     function _mint(address account, uint256 amount) internal virtual override {
623         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
624         super._mint(account, amount);
625     }
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
629 
630 
631 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 /**
637  * @dev Extension of {ERC20} that allows token holders to destroy both their own
638  * tokens and those that they have an allowance for, in a way that can be
639  * recognized off-chain (via event analysis).
640  */
641 abstract contract ERC20Burnable is Context, ERC20 {
642     /**
643      * @dev Destroys `amount` tokens from the caller.
644      *
645      * See {ERC20-_burn}.
646      */
647     function burn(uint256 amount) public virtual {
648         _burn(_msgSender(), amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
653      * allowance.
654      *
655      * See {ERC20-_burn} and {ERC20-allowance}.
656      *
657      * Requirements:
658      *
659      * - the caller must have allowance for ``accounts``'s tokens of at least
660      * `amount`.
661      */
662     function burnFrom(address account, uint256 amount) public virtual {
663         _spendAllowance(account, _msgSender(), amount);
664         _burn(account, amount);
665     }
666 }
667 
668 // File: contracts/token/ERC20/extensions/ERC20Decimals.sol
669 
670 
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @title ERC20Decimals
676  * @dev Extension of {ERC20} that adds decimals storage slot.
677  */
678 abstract contract ERC20Decimals is ERC20 {
679     uint8 private immutable _decimals;
680 
681     /**
682      * @dev Sets the value of the `_decimals`.
683      * This value is immutable, it can only be set once during construction.
684      */
685     constructor(uint8 decimals_) {
686         _decimals = decimals_;
687     }
688 
689     function decimals() public view virtual override returns (uint8) {
690         return _decimals;
691     }
692 }
693 
694 // File: contracts/token/ERC20/extensions/ERC20Detailed.sol
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @title ERC20Detailed
702  * @dev Extension of {ERC20} and {ERC20Decimals}.
703  */
704 contract ERC20Detailed is ERC20Decimals {
705     constructor(
706         string memory name_,
707         string memory symbol_,
708         uint8 decimals_
709     ) ERC20(name_, symbol_) ERC20Decimals(decimals_) {}
710 }
711 
712 // File: contracts/token/ERC20/extensions/ERC20Mintable.sol
713 
714 
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @title ERC20Mintable
720  * @dev Extension of {ERC20} that adds a minting behaviour.
721  */
722 abstract contract ERC20Mintable is ERC20 {
723     // indicates if minting is finished
724     bool private _mintingFinished = false;
725 
726     /**
727      * @dev Emitted during finish minting.
728      */
729     event MintFinished();
730 
731     /**
732      * @dev Tokens can be minted only before minting finished.
733      */
734     modifier canMint() {
735         require(!_mintingFinished, "ERC20Mintable: minting is finished");
736         _;
737     }
738 
739     /**
740      * @return if minting is finished or not.
741      */
742     function mintingFinished() external view returns (bool) {
743         return _mintingFinished;
744     }
745 
746     /**
747      * @dev Function to mint tokens.
748      *
749      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
750      *
751      * @param account The address that will receive the minted tokens
752      * @param amount The amount of tokens to mint
753      */
754     function mint(address account, uint256 amount) external canMint {
755         _mint(account, amount);
756     }
757 
758     /**
759      * @dev Function to stop minting new tokens.
760      *
761      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
762      */
763     function finishMinting() external canMint {
764         _finishMinting();
765     }
766 
767     /**
768      * @dev Function to stop minting new tokens.
769      */
770     function _finishMinting() internal virtual {
771         _mintingFinished = true;
772 
773         emit MintFinished();
774     }
775 }
776 
777 // File: contracts/service/ServicePayer.sol
778 
779 
780 
781 pragma solidity ^0.8.0;
782 
783 interface IPayable {
784     function pay(string memory serviceName, bytes memory signature, address wallet) external payable;
785 }
786 
787 /**
788  * @title ServicePayer
789  * @dev Implementation of the ServicePayer
790  */
791 abstract contract ServicePayer {
792     constructor(address payable receiver, string memory serviceName, bytes memory signature, address wallet) payable {
793         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
794     }
795 }
796 
797 // File: contracts/token/ERC20/CommonERC20.sol
798 
799 
800 
801 pragma solidity ^0.8.0;
802 
803 
804 
805 
806 
807 /**
808  * @title CommonERC20
809  * @dev Implementation of the CommonERC20
810  */
811 contract CommonERC20 is ERC20Detailed, ERC20Capped, ERC20Mintable, ERC20Burnable, Ownable, ServicePayer {
812     constructor(
813         string memory name_,
814         string memory symbol_,
815         uint8 decimals_,
816         uint256 cap_,
817         uint256 initialBalance_,
818         bytes memory signature_,
819         address payable feeReceiver_
820     )
821         payable
822         ERC20Detailed(name_, symbol_, decimals_)
823         ERC20Capped(cap_)
824         ServicePayer(feeReceiver_, "CommonERC20", signature_, _msgSender())
825     {
826         _mint(_msgSender(), initialBalance_);
827     }
828 
829     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
830         return super.decimals();
831     }
832 
833     /**
834      * @dev Function to mint tokens.
835      *
836      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
837      *
838      * @param account The address that will receive the minted tokens
839      * @param amount The amount of tokens to mint
840      */
841     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyOwner {
842         super._mint(account, amount);
843     }
844 
845     /**
846      * @dev Function to stop minting new tokens.
847      *
848      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
849      */
850     function _finishMinting() internal override onlyOwner {
851         super._finishMinting();
852     }
853 }
