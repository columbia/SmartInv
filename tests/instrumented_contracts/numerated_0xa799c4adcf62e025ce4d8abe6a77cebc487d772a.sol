1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 
50 
51 
52 /**
53  * @dev Interface of the ERC20 standard as defined in the EIP.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 
132 
133 /**
134  * @dev String operations.
135  */
136 library Strings {
137     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
141      */
142     function toString(uint256 value) internal pure returns (string memory) {
143         // Inspired by OraclizeAPI's implementation - MIT licence
144         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
145 
146         if (value == 0) {
147             return "0";
148         }
149         uint256 temp = value;
150         uint256 digits;
151         while (temp != 0) {
152             digits++;
153             temp /= 10;
154         }
155         bytes memory buffer = new bytes(digits);
156         while (value != 0) {
157             digits -= 1;
158             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
159             value /= 10;
160         }
161         return string(buffer);
162     }
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
166      */
167     function toHexString(uint256 value) internal pure returns (string memory) {
168         if (value == 0) {
169             return "0x00";
170         }
171         uint256 temp = value;
172         uint256 length = 0;
173         while (temp != 0) {
174             length++;
175             temp >>= 8;
176         }
177         return toHexString(value, length);
178     }
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
182      */
183     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
184         bytes memory buffer = new bytes(2 * length + 2);
185         buffer[0] = "0";
186         buffer[1] = "x";
187         for (uint256 i = 2 * length + 1; i > 1; --i) {
188             buffer[i] = _HEX_SYMBOLS[value & 0xf];
189             value >>= 4;
190         }
191         require(value == 0, "Strings: hex length insufficient");
192         return string(buffer);
193     }
194 }
195 
196 
197 
198 
199 
200 
201 
202 
203 
204 
205 
206 
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
381         unchecked {
382             _approve(sender, _msgSender(), currentAllowance - amount);
383         }
384 
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
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
420         uint256 currentAllowance = _allowances[_msgSender()][spender];
421         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
422         unchecked {
423             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
424         }
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves `amount` of tokens from `sender` to `recipient`.
431      *
432      * This internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(
444         address sender,
445         address recipient,
446         uint256 amount
447     ) internal virtual {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(sender, recipient, amount);
452 
453         uint256 senderBalance = _balances[sender];
454         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[sender] = senderBalance - amount;
457         }
458         _balances[recipient] += amount;
459 
460         emit Transfer(sender, recipient, amount);
461 
462         _afterTokenTransfer(sender, recipient, amount);
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
480         _balances[account] += amount;
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506         }
507         _totalSupply -= amount;
508 
509         emit Transfer(account, address(0), amount);
510 
511         _afterTokenTransfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(
528         address owner,
529         address spender,
530         uint256 amount
531     ) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Hook that is called before any transfer of tokens. This includes
541      * minting and burning.
542      *
543      * Calling conditions:
544      *
545      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
546      * will be transferred to `to`.
547      * - when `from` is zero, `amount` tokens will be minted for `to`.
548      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
549      * - `from` and `to` are never both zero.
550      *
551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
552      */
553     function _beforeTokenTransfer(
554         address from,
555         address to,
556         uint256 amount
557     ) internal virtual {}
558 
559     /**
560      * @dev Hook that is called after any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * has been transferred to `to`.
567      * - when `from` is zero, `amount` tokens have been minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _afterTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 }
579 
580 
581 
582 
583 
584 
585 
586 
587 
588 
589 
590 
591 /**
592  * @dev Contract module which allows children to implement an emergency stop
593  * mechanism that can be triggered by an authorized account.
594  *
595  * This module is used through inheritance. It will make available the
596  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
597  * the functions of your contract. Note that they will not be pausable by
598  * simply including this module, only once the modifiers are put in place.
599  */
600 abstract contract Pausable is Context {
601     /**
602      * @dev Emitted when the pause is triggered by `account`.
603      */
604     event Paused(address account);
605 
606     /**
607      * @dev Emitted when the pause is lifted by `account`.
608      */
609     event Unpaused(address account);
610 
611     bool private _paused;
612 
613     /**
614      * @dev Initializes the contract in unpaused state.
615      */
616     constructor() {
617         _paused = false;
618     }
619 
620     /**
621      * @dev Returns true if the contract is paused, and false otherwise.
622      */
623     function paused() public view virtual returns (bool) {
624         return _paused;
625     }
626 
627     /**
628      * @dev Modifier to make a function callable only when the contract is not paused.
629      *
630      * Requirements:
631      *
632      * - The contract must not be paused.
633      */
634     modifier whenNotPaused() {
635         require(!paused(), "Pausable: paused");
636         _;
637     }
638 
639     /**
640      * @dev Modifier to make a function callable only when the contract is paused.
641      *
642      * Requirements:
643      *
644      * - The contract must be paused.
645      */
646     modifier whenPaused() {
647         require(paused(), "Pausable: not paused");
648         _;
649     }
650 
651     /**
652      * @dev Triggers stopped state.
653      *
654      * Requirements:
655      *
656      * - The contract must not be paused.
657      */
658     function _pause() internal virtual whenNotPaused {
659         _paused = true;
660         emit Paused(_msgSender());
661     }
662 
663     /**
664      * @dev Returns to normal state.
665      *
666      * Requirements:
667      *
668      * - The contract must be paused.
669      */
670     function _unpause() internal virtual whenPaused {
671         _paused = false;
672         emit Unpaused(_msgSender());
673     }
674 }
675 
676 
677 /**
678  * @dev ERC20 token with pausable token transfers, minting and burning.
679  *
680  * Useful for scenarios such as preventing trades until the end of an evaluation
681  * period, or having an emergency switch for freezing all token transfers in the
682  * event of a large bug.
683  */
684 abstract contract ERC20Pausable is ERC20, Pausable {
685     /**
686      * @dev See {ERC20-_beforeTokenTransfer}.
687      *
688      * Requirements:
689      *
690      * - the contract must not be paused.
691      */
692     function _beforeTokenTransfer(
693         address from,
694         address to,
695         uint256 amount
696     ) internal virtual override {
697         super._beforeTokenTransfer(from, to, amount);
698 
699         require(!paused(), "ERC20Pausable: token transfer while paused");
700     }
701 }
702 
703 
704 
705 
706 
707 
708 
709 /**
710  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
711  */
712 abstract contract ERC20Capped is ERC20 {
713     uint256 private immutable _cap;
714 
715     /**
716      * @dev Sets the value of the `cap`. This value is immutable, it can only be
717      * set once during construction.
718      */
719     constructor(uint256 cap_) {
720         require(cap_ > 0, "ERC20Capped: cap is 0");
721         _cap = cap_;
722     }
723 
724     /**
725      * @dev Returns the cap on the token's total supply.
726      */
727     function cap() public view virtual returns (uint256) {
728         return _cap;
729     }
730 
731     /**
732      * @dev See {ERC20-_mint}.
733      */
734     function _mint(address account, uint256 amount) internal virtual override {
735         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
736         super._mint(account, amount);
737     }
738 }
739 
740 
741 
742 
743 
744 
745 
746 
747 
748 /**
749  * @dev External interface of AccessControl declared to support ERC165 detection.
750  */
751 interface IAccessControl {
752     /**
753      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
754      *
755      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
756      * {RoleAdminChanged} not being emitted signaling this.
757      *
758      * _Available since v3.1._
759      */
760     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
761 
762     /**
763      * @dev Emitted when `account` is granted `role`.
764      *
765      * `sender` is the account that originated the contract call, an admin role
766      * bearer except when using {AccessControl-_setupRole}.
767      */
768     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
769 
770     /**
771      * @dev Emitted when `account` is revoked `role`.
772      *
773      * `sender` is the account that originated the contract call:
774      *   - if using `revokeRole`, it is the admin role bearer
775      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
776      */
777     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
778 
779     /**
780      * @dev Returns `true` if `account` has been granted `role`.
781      */
782     function hasRole(bytes32 role, address account) external view returns (bool);
783 
784     /**
785      * @dev Returns the admin role that controls `role`. See {grantRole} and
786      * {revokeRole}.
787      *
788      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
789      */
790     function getRoleAdmin(bytes32 role) external view returns (bytes32);
791 
792     /**
793      * @dev Grants `role` to `account`.
794      *
795      * If `account` had not been already granted `role`, emits a {RoleGranted}
796      * event.
797      *
798      * Requirements:
799      *
800      * - the caller must have ``role``'s admin role.
801      */
802     function grantRole(bytes32 role, address account) external;
803 
804     /**
805      * @dev Revokes `role` from `account`.
806      *
807      * If `account` had been granted `role`, emits a {RoleRevoked} event.
808      *
809      * Requirements:
810      *
811      * - the caller must have ``role``'s admin role.
812      */
813     function revokeRole(bytes32 role, address account) external;
814 
815     /**
816      * @dev Revokes `role` from the calling account.
817      *
818      * Roles are often managed via {grantRole} and {revokeRole}: this function's
819      * purpose is to provide a mechanism for accounts to lose their privileges
820      * if they are compromised (such as when a trusted device is misplaced).
821      *
822      * If the calling account had been granted `role`, emits a {RoleRevoked}
823      * event.
824      *
825      * Requirements:
826      *
827      * - the caller must be `account`.
828      */
829     function renounceRole(bytes32 role, address account) external;
830 }
831 
832 
833 
834 
835 
836 
837 
838 
839 
840 /**
841  * @dev Implementation of the {IERC165} interface.
842  *
843  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
844  * for the additional interface id that will be supported. For example:
845  *
846  * ```solidity
847  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
848  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
849  * }
850  * ```
851  *
852  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
853  */
854 abstract contract ERC165 is IERC165 {
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
859         return interfaceId == type(IERC165).interfaceId;
860     }
861 }
862 
863 
864 /**
865  * @dev Contract module that allows children to implement role-based access
866  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
867  * members except through off-chain means by accessing the contract event logs. Some
868  * applications may benefit from on-chain enumerability, for those cases see
869  * {AccessControlEnumerable}.
870  *
871  * Roles are referred to by their `bytes32` identifier. These should be exposed
872  * in the external API and be unique. The best way to achieve this is by
873  * using `public constant` hash digests:
874  *
875  * ```
876  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
877  * ```
878  *
879  * Roles can be used to represent a set of permissions. To restrict access to a
880  * function call, use {hasRole}:
881  *
882  * ```
883  * function foo() public {
884  *     require(hasRole(MY_ROLE, msg.sender));
885  *     ...
886  * }
887  * ```
888  *
889  * Roles can be granted and revoked dynamically via the {grantRole} and
890  * {revokeRole} functions. Each role has an associated admin role, and only
891  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
892  *
893  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
894  * that only accounts with this role will be able to grant or revoke other
895  * roles. More complex role relationships can be created by using
896  * {_setRoleAdmin}.
897  *
898  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
899  * grant and revoke this role. Extra precautions should be taken to secure
900  * accounts that have been granted it.
901  */
902 abstract contract AccessControl is Context, IAccessControl, ERC165 {
903     struct RoleData {
904         mapping(address => bool) members;
905         bytes32 adminRole;
906     }
907 
908     mapping(bytes32 => RoleData) private _roles;
909 
910     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
911 
912     /**
913      * @dev Modifier that checks that an account has a specific role. Reverts
914      * with a standardized message including the required role.
915      *
916      * The format of the revert reason is given by the following regular expression:
917      *
918      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
919      *
920      * _Available since v4.1._
921      */
922     modifier onlyRole(bytes32 role) {
923         _checkRole(role, _msgSender());
924         _;
925     }
926 
927     /**
928      * @dev See {IERC165-supportsInterface}.
929      */
930     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
931         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
932     }
933 
934     /**
935      * @dev Returns `true` if `account` has been granted `role`.
936      */
937     function hasRole(bytes32 role, address account) public view override returns (bool) {
938         return _roles[role].members[account];
939     }
940 
941     /**
942      * @dev Revert with a standard message if `account` is missing `role`.
943      *
944      * The format of the revert reason is given by the following regular expression:
945      *
946      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
947      */
948     function _checkRole(bytes32 role, address account) internal view {
949         if (!hasRole(role, account)) {
950             revert(
951                 string(
952                     abi.encodePacked(
953                         "AccessControl: account ",
954                         Strings.toHexString(uint160(account), 20),
955                         " is missing role ",
956                         Strings.toHexString(uint256(role), 32)
957                     )
958                 )
959             );
960         }
961     }
962 
963     /**
964      * @dev Returns the admin role that controls `role`. See {grantRole} and
965      * {revokeRole}.
966      *
967      * To change a role's admin, use {_setRoleAdmin}.
968      */
969     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
970         return _roles[role].adminRole;
971     }
972 
973     /**
974      * @dev Grants `role` to `account`.
975      *
976      * If `account` had not been already granted `role`, emits a {RoleGranted}
977      * event.
978      *
979      * Requirements:
980      *
981      * - the caller must have ``role``'s admin role.
982      */
983     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
984         _grantRole(role, account);
985     }
986 
987     /**
988      * @dev Revokes `role` from `account`.
989      *
990      * If `account` had been granted `role`, emits a {RoleRevoked} event.
991      *
992      * Requirements:
993      *
994      * - the caller must have ``role``'s admin role.
995      */
996     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
997         _revokeRole(role, account);
998     }
999 
1000     /**
1001      * @dev Revokes `role` from the calling account.
1002      *
1003      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1004      * purpose is to provide a mechanism for accounts to lose their privileges
1005      * if they are compromised (such as when a trusted device is misplaced).
1006      *
1007      * If the calling account had been granted `role`, emits a {RoleRevoked}
1008      * event.
1009      *
1010      * Requirements:
1011      *
1012      * - the caller must be `account`.
1013      */
1014     function renounceRole(bytes32 role, address account) public virtual override {
1015         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1016 
1017         _revokeRole(role, account);
1018     }
1019 
1020     /**
1021      * @dev Grants `role` to `account`.
1022      *
1023      * If `account` had not been already granted `role`, emits a {RoleGranted}
1024      * event. Note that unlike {grantRole}, this function doesn't perform any
1025      * checks on the calling account.
1026      *
1027      * [WARNING]
1028      * ====
1029      * This function should only be called from the constructor when setting
1030      * up the initial roles for the system.
1031      *
1032      * Using this function in any other way is effectively circumventing the admin
1033      * system imposed by {AccessControl}.
1034      * ====
1035      */
1036     function _setupRole(bytes32 role, address account) internal virtual {
1037         _grantRole(role, account);
1038     }
1039 
1040     /**
1041      * @dev Sets `adminRole` as ``role``'s admin role.
1042      *
1043      * Emits a {RoleAdminChanged} event.
1044      */
1045     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1046         bytes32 previousAdminRole = getRoleAdmin(role);
1047         _roles[role].adminRole = adminRole;
1048         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1049     }
1050 
1051     function _grantRole(bytes32 role, address account) private {
1052         if (!hasRole(role, account)) {
1053             _roles[role].members[account] = true;
1054             emit RoleGranted(role, account, _msgSender());
1055         }
1056     }
1057 
1058     function _revokeRole(bytes32 role, address account) private {
1059         if (hasRole(role, account)) {
1060             _roles[role].members[account] = false;
1061             emit RoleRevoked(role, account, _msgSender());
1062         }
1063     }
1064 }
1065 
1066 
1067 contract Token is Context, AccessControl, ERC20, ERC20Pausable, ERC20Capped {
1068     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1069     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1070     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1071 
1072     constructor(string memory name, string memory symbol, address account, uint256 cap) ERC20(name, symbol) ERC20Capped(cap) {
1073         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1074         _setupRole(MINTER_ROLE, account);
1075         _setupRole(PAUSER_ROLE, account);
1076         _setupRole(BURNER_ROLE, account);
1077     }
1078 
1079     function mint(address to, uint256 amount) public virtual {
1080         require(hasRole(MINTER_ROLE, _msgSender()), "must have minter role to mint");
1081         _mint(to, amount);
1082     }
1083 
1084     function pause() public virtual {
1085         require(hasRole(PAUSER_ROLE, _msgSender()), "must have pauser role to pause");
1086         _pause();
1087     }
1088 
1089     function unpause() public virtual {
1090         require(hasRole(PAUSER_ROLE, _msgSender()), "must have pauser role to unpause");
1091         _unpause();
1092     }
1093 
1094     function burn(uint256 amount) public virtual {
1095         require(hasRole(BURNER_ROLE, _msgSender()), "must have burner role to burn");
1096         _burn(_msgSender(), amount);
1097     }
1098 
1099     function burnFrom(address account, uint256 amount) public virtual {
1100         require(hasRole(BURNER_ROLE, _msgSender()), "must have burner role to burn");
1101         uint256 currentAllowance = allowance(account, _msgSender());
1102         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1103         unchecked {
1104             _approve(account, _msgSender(), currentAllowance - amount);
1105         }
1106         _burn(account, amount);
1107     }
1108 
1109     function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1110         super._mint(account, amount);
1111     }
1112 
1113     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1114         super._beforeTokenTransfer(from, to, amount);
1115     }
1116 }