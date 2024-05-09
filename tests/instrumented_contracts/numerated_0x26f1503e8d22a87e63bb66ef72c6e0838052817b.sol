1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
33 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 
195 
196 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
227 
228 pragma solidity ^0.8.0;
229 
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
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
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
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
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
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
421         uint256 currentAllowance = _allowances[_msgSender()][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address sender,
446         address recipient,
447         uint256 amount
448     ) internal virtual {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(sender, recipient, amount);
453 
454         uint256 senderBalance = _balances[sender];
455         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[sender] = senderBalance - amount;
458         }
459         _balances[recipient] += amount;
460 
461         emit Transfer(sender, recipient, amount);
462 
463         _afterTokenTransfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 
560     /**
561      * @dev Hook that is called after any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * has been transferred to `to`.
568      * - when `from` is zero, `amount` tokens have been minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _afterTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/ERC20Burnable.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 /**
591  * @dev Extension of {ERC20} that allows token holders to destroy both their own
592  * tokens and those that they have an allowance for, in a way that can be
593  * recognized off-chain (via event analysis).
594  */
595 abstract contract ERC20Burnable is Context, ERC20 {
596     /**
597      * @dev Destroys `amount` tokens from the caller.
598      *
599      * See {ERC20-_burn}.
600      */
601     function burn(uint256 amount) public virtual {
602         _burn(_msgSender(), amount);
603     }
604 
605     /**
606      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
607      * allowance.
608      *
609      * See {ERC20-_burn} and {ERC20-allowance}.
610      *
611      * Requirements:
612      *
613      * - the caller must have allowance for ``accounts``'s tokens of at least
614      * `amount`.
615      */
616     function burnFrom(address account, uint256 amount) public virtual {
617         uint256 currentAllowance = allowance(account, _msgSender());
618         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
619         unchecked {
620             _approve(account, _msgSender(), currentAllowance - amount);
621         }
622         _burn(account, amount);
623     }
624 }
625 
626 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
627 
628 
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @title ERC20Decimals
635  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
636  */
637 abstract contract ERC20Decimals is ERC20 {
638     uint8 private immutable _decimals;
639 
640     /**
641      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
642      * set once during construction.
643      */
644     constructor(uint8 decimals_) {
645         _decimals = decimals_;
646     }
647 
648     function decimals() public view virtual override returns (uint8) {
649         return _decimals;
650     }
651 }
652 
653 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
654 
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC20Mintable
662  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
663  */
664 abstract contract ERC20Mintable is ERC20 {
665     // indicates if minting is finished
666     bool private _mintingFinished = false;
667 
668     /**
669      * @dev Emitted during finish minting
670      */
671     event MintFinished();
672 
673     /**
674      * @dev Tokens can be minted only before minting finished.
675      */
676     modifier canMint() {
677         require(!_mintingFinished, "ERC20Mintable: minting is finished");
678         _;
679     }
680 
681     /**
682      * @return if minting is finished or not.
683      */
684     function mintingFinished() external view returns (bool) {
685         return _mintingFinished;
686     }
687 
688     /**
689      * @dev Function to mint tokens.
690      *
691      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
692      *
693      * @param account The address that will receive the minted tokens
694      * @param amount The amount of tokens to mint
695      */
696     function mint(address account, uint256 amount) external canMint {
697         _mint(account, amount);
698     }
699 
700     /**
701      * @dev Function to stop minting new tokens.
702      *
703      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
704      */
705     function finishMinting() external canMint {
706         _finishMinting();
707     }
708 
709     /**
710      * @dev Function to stop minting new tokens.
711      */
712     function _finishMinting() internal virtual {
713         _mintingFinished = true;
714 
715         emit MintFinished();
716     }
717 }
718 
719 // File: @openzeppelin/contracts/access/IAccessControl.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @dev External interface of AccessControl declared to support ERC165 detection.
728  */
729 interface IAccessControl {
730     /**
731      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
732      *
733      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
734      * {RoleAdminChanged} not being emitted signaling this.
735      *
736      * _Available since v3.1._
737      */
738     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
739 
740     /**
741      * @dev Emitted when `account` is granted `role`.
742      *
743      * `sender` is the account that originated the contract call, an admin role
744      * bearer except when using {AccessControl-_setupRole}.
745      */
746     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
747 
748     /**
749      * @dev Emitted when `account` is revoked `role`.
750      *
751      * `sender` is the account that originated the contract call:
752      *   - if using `revokeRole`, it is the admin role bearer
753      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
754      */
755     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
756 
757     /**
758      * @dev Returns `true` if `account` has been granted `role`.
759      */
760     function hasRole(bytes32 role, address account) external view returns (bool);
761 
762     /**
763      * @dev Returns the admin role that controls `role`. See {grantRole} and
764      * {revokeRole}.
765      *
766      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
767      */
768     function getRoleAdmin(bytes32 role) external view returns (bytes32);
769 
770     /**
771      * @dev Grants `role` to `account`.
772      *
773      * If `account` had not been already granted `role`, emits a {RoleGranted}
774      * event.
775      *
776      * Requirements:
777      *
778      * - the caller must have ``role``'s admin role.
779      */
780     function grantRole(bytes32 role, address account) external;
781 
782     /**
783      * @dev Revokes `role` from `account`.
784      *
785      * If `account` had been granted `role`, emits a {RoleRevoked} event.
786      *
787      * Requirements:
788      *
789      * - the caller must have ``role``'s admin role.
790      */
791     function revokeRole(bytes32 role, address account) external;
792 
793     /**
794      * @dev Revokes `role` from the calling account.
795      *
796      * Roles are often managed via {grantRole} and {revokeRole}: this function's
797      * purpose is to provide a mechanism for accounts to lose their privileges
798      * if they are compromised (such as when a trusted device is misplaced).
799      *
800      * If the calling account had been granted `role`, emits a {RoleRevoked}
801      * event.
802      *
803      * Requirements:
804      *
805      * - the caller must be `account`.
806      */
807     function renounceRole(bytes32 role, address account) external;
808 }
809 
810 // File: @openzeppelin/contracts/utils/Strings.sol
811 
812 
813 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 /**
818  * @dev String operations.
819  */
820 library Strings {
821     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
822 
823     /**
824      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
825      */
826     function toString(uint256 value) internal pure returns (string memory) {
827         // Inspired by OraclizeAPI's implementation - MIT licence
828         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
829 
830         if (value == 0) {
831             return "0";
832         }
833         uint256 temp = value;
834         uint256 digits;
835         while (temp != 0) {
836             digits++;
837             temp /= 10;
838         }
839         bytes memory buffer = new bytes(digits);
840         while (value != 0) {
841             digits -= 1;
842             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
843             value /= 10;
844         }
845         return string(buffer);
846     }
847 
848     /**
849      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
850      */
851     function toHexString(uint256 value) internal pure returns (string memory) {
852         if (value == 0) {
853             return "0x00";
854         }
855         uint256 temp = value;
856         uint256 length = 0;
857         while (temp != 0) {
858             length++;
859             temp >>= 8;
860         }
861         return toHexString(value, length);
862     }
863 
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
866      */
867     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
868         bytes memory buffer = new bytes(2 * length + 2);
869         buffer[0] = "0";
870         buffer[1] = "x";
871         for (uint256 i = 2 * length + 1; i > 1; --i) {
872             buffer[i] = _HEX_SYMBOLS[value & 0xf];
873             value >>= 4;
874         }
875         require(value == 0, "Strings: hex length insufficient");
876         return string(buffer);
877     }
878 }
879 
880 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
881 
882 
883 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @dev Interface of the ERC165 standard, as defined in the
889  * https://eips.ethereum.org/EIPS/eip-165[EIP].
890  *
891  * Implementers can declare support of contract interfaces, which can then be
892  * queried by others ({ERC165Checker}).
893  *
894  * For an implementation, see {ERC165}.
895  */
896 interface IERC165 {
897     /**
898      * @dev Returns true if this contract implements the interface defined by
899      * `interfaceId`. See the corresponding
900      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
901      * to learn more about how these ids are created.
902      *
903      * This function call must use less than 30 000 gas.
904      */
905     function supportsInterface(bytes4 interfaceId) external view returns (bool);
906 }
907 
908 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
909 
910 
911 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @dev Implementation of the {IERC165} interface.
918  *
919  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
920  * for the additional interface id that will be supported. For example:
921  *
922  * ```solidity
923  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
924  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
925  * }
926  * ```
927  *
928  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
929  */
930 abstract contract ERC165 is IERC165 {
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
935         return interfaceId == type(IERC165).interfaceId;
936     }
937 }
938 
939 // File: @openzeppelin/contracts/access/AccessControl.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 
947 
948 
949 
950 /**
951  * @dev Contract module that allows children to implement role-based access
952  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
953  * members except through off-chain means by accessing the contract event logs. Some
954  * applications may benefit from on-chain enumerability, for those cases see
955  * {AccessControlEnumerable}.
956  *
957  * Roles are referred to by their `bytes32` identifier. These should be exposed
958  * in the external API and be unique. The best way to achieve this is by
959  * using `public constant` hash digests:
960  *
961  * ```
962  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
963  * ```
964  *
965  * Roles can be used to represent a set of permissions. To restrict access to a
966  * function call, use {hasRole}:
967  *
968  * ```
969  * function foo() public {
970  *     require(hasRole(MY_ROLE, msg.sender));
971  *     ...
972  * }
973  * ```
974  *
975  * Roles can be granted and revoked dynamically via the {grantRole} and
976  * {revokeRole} functions. Each role has an associated admin role, and only
977  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
978  *
979  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
980  * that only accounts with this role will be able to grant or revoke other
981  * roles. More complex role relationships can be created by using
982  * {_setRoleAdmin}.
983  *
984  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
985  * grant and revoke this role. Extra precautions should be taken to secure
986  * accounts that have been granted it.
987  */
988 abstract contract AccessControl is Context, IAccessControl, ERC165 {
989     struct RoleData {
990         mapping(address => bool) members;
991         bytes32 adminRole;
992     }
993 
994     mapping(bytes32 => RoleData) private _roles;
995 
996     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
997 
998     /**
999      * @dev Modifier that checks that an account has a specific role. Reverts
1000      * with a standardized message including the required role.
1001      *
1002      * The format of the revert reason is given by the following regular expression:
1003      *
1004      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1005      *
1006      * _Available since v4.1._
1007      */
1008     modifier onlyRole(bytes32 role) {
1009         _checkRole(role, _msgSender());
1010         _;
1011     }
1012 
1013     /**
1014      * @dev See {IERC165-supportsInterface}.
1015      */
1016     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1017         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1018     }
1019 
1020     /**
1021      * @dev Returns `true` if `account` has been granted `role`.
1022      */
1023     function hasRole(bytes32 role, address account) public view override returns (bool) {
1024         return _roles[role].members[account];
1025     }
1026 
1027     /**
1028      * @dev Revert with a standard message if `account` is missing `role`.
1029      *
1030      * The format of the revert reason is given by the following regular expression:
1031      *
1032      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1033      */
1034     function _checkRole(bytes32 role, address account) internal view {
1035         if (!hasRole(role, account)) {
1036             revert(
1037                 string(
1038                     abi.encodePacked(
1039                         "AccessControl: account ",
1040                         Strings.toHexString(uint160(account), 20),
1041                         " is missing role ",
1042                         Strings.toHexString(uint256(role), 32)
1043                     )
1044                 )
1045             );
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns the admin role that controls `role`. See {grantRole} and
1051      * {revokeRole}.
1052      *
1053      * To change a role's admin, use {_setRoleAdmin}.
1054      */
1055     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1056         return _roles[role].adminRole;
1057     }
1058 
1059     /**
1060      * @dev Grants `role` to `account`.
1061      *
1062      * If `account` had not been already granted `role`, emits a {RoleGranted}
1063      * event.
1064      *
1065      * Requirements:
1066      *
1067      * - the caller must have ``role``'s admin role.
1068      */
1069     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1070         _grantRole(role, account);
1071     }
1072 
1073     /**
1074      * @dev Revokes `role` from `account`.
1075      *
1076      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1077      *
1078      * Requirements:
1079      *
1080      * - the caller must have ``role``'s admin role.
1081      */
1082     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1083         _revokeRole(role, account);
1084     }
1085 
1086     /**
1087      * @dev Revokes `role` from the calling account.
1088      *
1089      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1090      * purpose is to provide a mechanism for accounts to lose their privileges
1091      * if they are compromised (such as when a trusted device is misplaced).
1092      *
1093      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1094      * event.
1095      *
1096      * Requirements:
1097      *
1098      * - the caller must be `account`.
1099      */
1100     function renounceRole(bytes32 role, address account) public virtual override {
1101         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1102 
1103         _revokeRole(role, account);
1104     }
1105 
1106     /**
1107      * @dev Grants `role` to `account`.
1108      *
1109      * If `account` had not been already granted `role`, emits a {RoleGranted}
1110      * event. Note that unlike {grantRole}, this function doesn't perform any
1111      * checks on the calling account.
1112      *
1113      * [WARNING]
1114      * ====
1115      * This function should only be called from the constructor when setting
1116      * up the initial roles for the system.
1117      *
1118      * Using this function in any other way is effectively circumventing the admin
1119      * system imposed by {AccessControl}.
1120      * ====
1121      *
1122      * NOTE: This function is deprecated in favor of {_grantRole}.
1123      */
1124     function _setupRole(bytes32 role, address account) internal virtual {
1125         _grantRole(role, account);
1126     }
1127 
1128     /**
1129      * @dev Sets `adminRole` as ``role``'s admin role.
1130      *
1131      * Emits a {RoleAdminChanged} event.
1132      */
1133     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1134         bytes32 previousAdminRole = getRoleAdmin(role);
1135         _roles[role].adminRole = adminRole;
1136         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1137     }
1138 
1139     /**
1140      * @dev Grants `role` to `account`.
1141      *
1142      * Internal function without access restriction.
1143      */
1144     function _grantRole(bytes32 role, address account) internal virtual {
1145         if (!hasRole(role, account)) {
1146             _roles[role].members[account] = true;
1147             emit RoleGranted(role, account, _msgSender());
1148         }
1149     }
1150 
1151     /**
1152      * @dev Revokes `role` from `account`.
1153      *
1154      * Internal function without access restriction.
1155      */
1156     function _revokeRole(bytes32 role, address account) internal virtual {
1157         if (hasRole(role, account)) {
1158             _roles[role].members[account] = false;
1159             emit RoleRevoked(role, account, _msgSender());
1160         }
1161     }
1162 }
1163 
1164 // File: contracts/access/Roles.sol
1165 
1166 
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 contract Roles is AccessControl {
1172     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1173 
1174     constructor() {
1175         _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
1176         _grantRole(MINTER_ROLE, _msgSender());
1177     }
1178 
1179     modifier onlyMinter() {
1180         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1181         _;
1182     }
1183 }
1184 
1185 // File: contracts/service/ServicePayer.sol
1186 
1187 
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 interface IPayable {
1192     function pay(string memory serviceName) external payable;
1193 }
1194 
1195 /**
1196  * @title ServicePayer
1197  * @dev Implementation of the ServicePayer
1198  */
1199 abstract contract ServicePayer {
1200     constructor(address payable receiver, string memory serviceName) payable {
1201         IPayable(receiver).pay{value: msg.value}(serviceName);
1202     }
1203 }
1204 
1205 // File: contracts/token/ERC20/UnlimitedERC20.sol
1206 
1207 
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 
1212 
1213 
1214 
1215 
1216 
1217 /**
1218  * @title UnlimitedERC20
1219  * @dev Implementation of the UnlimitedERC20
1220  */
1221 contract UnlimitedERC20 is ERC20Decimals, ERC20Mintable, ERC20Burnable, Ownable, Roles, ServicePayer {
1222     constructor(
1223         string memory name_,
1224         string memory symbol_,
1225         uint8 decimals_,
1226         uint256 initialBalance_,
1227         address payable feeReceiver_
1228     ) payable ERC20(name_, symbol_) ERC20Decimals(decimals_) ServicePayer(feeReceiver_, "UnlimitedERC20") {
1229         _mint(_msgSender(), initialBalance_);
1230     }
1231 
1232     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1233         return super.decimals();
1234     }
1235 
1236     /**
1237      * @dev Function to mint tokens.
1238      *
1239      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1240      *
1241      * @param account The address that will receive the minted tokens
1242      * @param amount The amount of tokens to mint
1243      */
1244     function _mint(address account, uint256 amount) internal override onlyMinter {
1245         super._mint(account, amount);
1246     }
1247 
1248     /**
1249      * @dev Function to stop minting new tokens.
1250      *
1251      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1252      */
1253     function _finishMinting() internal override onlyOwner {
1254         super._finishMinting();
1255     }
1256 }
