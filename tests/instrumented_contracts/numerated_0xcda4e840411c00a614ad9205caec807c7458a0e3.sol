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
29 /*
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
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 
116 
117 
118 interface IBotProtector {
119     function isPotentialBot(address account) external returns (bool);
120     function isPotentialBotTransfer(address from, address to) external returns (bool);
121 }
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 
134 
135 
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `recipient`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `sender` to `recipient` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) external returns (bool);
199 
200     /**
201      * @dev Emitted when `value` tokens are moved from one account (`from`) to
202      * another (`to`).
203      *
204      * Note that `value` may be zero.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     /**
209      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
210      * a call to {approve}. `value` is the new allowance.
211      */
212     event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 
216 
217 
218 
219 
220 
221 /**
222  * @dev Interface for the optional metadata functions from the ERC20 standard.
223  *
224  * _Available since v4.1._
225  */
226 interface IERC20Metadata is IERC20 {
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the symbol of the token.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the decimals places of the token.
239      */
240     function decimals() external view returns (uint8);
241 }
242 
243 
244 
245 /**
246  * @dev Implementation of the {IERC20} interface.
247  *
248  * This implementation is agnostic to the way tokens are created. This means
249  * that a supply mechanism has to be added in a derived contract using {_mint}.
250  * For a generic mechanism see {ERC20PresetMinterPauser}.
251  *
252  * TIP: For a detailed writeup see our guide
253  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
254  * to implement supply mechanisms].
255  *
256  * We have followed general OpenZeppelin guidelines: functions revert instead
257  * of returning `false` on failure. This behavior is nonetheless conventional
258  * and does not conflict with the expectations of ERC20 applications.
259  *
260  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
261  * This allows applications to reconstruct the allowance for all accounts just
262  * by listening to said events. Other implementations of the EIP may not emit
263  * these events, as it isn't required by the specification.
264  *
265  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
266  * functions have been added to mitigate the well-known issues around setting
267  * allowances. See {IERC20-approve}.
268  */
269 contract ERC20 is Context, IERC20, IERC20Metadata {
270     mapping(address => uint256) private _balances;
271 
272     mapping(address => mapping(address => uint256)) private _allowances;
273 
274     uint256 private _totalSupply;
275 
276     string private _name;
277     string private _symbol;
278 
279     /**
280      * @dev Sets the values for {name} and {symbol}.
281      *
282      * The default value of {decimals} is 18. To select a different value for
283      * {decimals} you should overload it.
284      *
285      * All two of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor(string memory name_, string memory symbol_) {
289         _name = name_;
290         _symbol = symbol_;
291     }
292 
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() public view virtual override returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @dev Returns the symbol of the token, usually a shorter version of the
302      * name.
303      */
304     function symbol() public view virtual override returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @dev Returns the number of decimals used to get its user representation.
310      * For example, if `decimals` equals `2`, a balance of `505` tokens should
311      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
312      *
313      * Tokens usually opt for a value of 18, imitating the relationship between
314      * Ether and Wei. This is the value {ERC20} uses, unless this function is
315      * overridden;
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view virtual override returns (uint8) {
322         return 18;
323     }
324 
325     /**
326      * @dev See {IERC20-totalSupply}.
327      */
328     function totalSupply() public view virtual override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See {IERC20-balanceOf}.
334      */
335     function balanceOf(address account) public view virtual override returns (uint256) {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See {IERC20-transfer}.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
348         _transfer(_msgSender(), recipient, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-allowance}.
354      */
355     function allowance(address owner, address spender) public view virtual override returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See {IERC20-approve}.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 amount) public virtual override returns (bool) {
367         _approve(_msgSender(), spender, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-transferFrom}.
373      *
374      * Emits an {Approval} event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of {ERC20}.
376      *
377      * Requirements:
378      *
379      * - `sender` and `recipient` cannot be the zero address.
380      * - `sender` must have a balance of at least `amount`.
381      * - the caller must have allowance for ``sender``'s tokens of at least
382      * `amount`.
383      */
384     function transferFrom(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) public virtual override returns (bool) {
389         _transfer(sender, recipient, amount);
390 
391         uint256 currentAllowance = _allowances[sender][_msgSender()];
392         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
393         unchecked {
394             _approve(sender, _msgSender(), currentAllowance - amount);
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
432         uint256 currentAllowance = _allowances[_msgSender()][spender];
433         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
434         unchecked {
435             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
436         }
437 
438         return true;
439     }
440 
441     /**
442      * @dev Moves `amount` of tokens from `sender` to `recipient`.
443      *
444      * This internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(
456         address sender,
457         address recipient,
458         uint256 amount
459     ) internal virtual {
460         require(sender != address(0), "ERC20: transfer from the zero address");
461         require(recipient != address(0), "ERC20: transfer to the zero address");
462 
463         _beforeTokenTransfer(sender, recipient, amount);
464 
465         uint256 senderBalance = _balances[sender];
466         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
467         unchecked {
468             _balances[sender] = senderBalance - amount;
469         }
470         _balances[recipient] += amount;
471 
472         emit Transfer(sender, recipient, amount);
473 
474         _afterTokenTransfer(sender, recipient, amount);
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
492         _balances[account] += amount;
493         emit Transfer(address(0), account, amount);
494 
495         _afterTokenTransfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint256 amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         uint256 accountBalance = _balances[account];
515         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
516         unchecked {
517             _balances[account] = accountBalance - amount;
518         }
519         _totalSupply -= amount;
520 
521         emit Transfer(account, address(0), amount);
522 
523         _afterTokenTransfer(account, address(0), amount);
524     }
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
528      *
529      * This internal function is equivalent to `approve`, and can be used to
530      * e.g. set automatic allowances for certain subsystems, etc.
531      *
532      * Emits an {Approval} event.
533      *
534      * Requirements:
535      *
536      * - `owner` cannot be the zero address.
537      * - `spender` cannot be the zero address.
538      */
539     function _approve(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         require(owner != address(0), "ERC20: approve from the zero address");
545         require(spender != address(0), "ERC20: approve to the zero address");
546 
547         _allowances[owner][spender] = amount;
548         emit Approval(owner, spender, amount);
549     }
550 
551     /**
552      * @dev Hook that is called before any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * will be transferred to `to`.
559      * - when `from` is zero, `amount` tokens will be minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _beforeTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 
571     /**
572      * @dev Hook that is called after any transfer of tokens. This includes
573      * minting and burning.
574      *
575      * Calling conditions:
576      *
577      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
578      * has been transferred to `to`.
579      * - when `from` is zero, `amount` tokens have been minted for `to`.
580      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
581      * - `from` and `to` are never both zero.
582      *
583      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
584      */
585     function _afterTokenTransfer(
586         address from,
587         address to,
588         uint256 amount
589     ) internal virtual {}
590 }
591 
592 
593 
594 
595 
596 
597 
598 /**
599  * @dev Contract module which allows children to implement an emergency stop
600  * mechanism that can be triggered by an authorized account.
601  *
602  * This module is used through inheritance. It will make available the
603  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
604  * the functions of your contract. Note that they will not be pausable by
605  * simply including this module, only once the modifiers are put in place.
606  */
607 abstract contract Pausable is Context {
608     /**
609      * @dev Emitted when the pause is triggered by `account`.
610      */
611     event Paused(address account);
612 
613     /**
614      * @dev Emitted when the pause is lifted by `account`.
615      */
616     event Unpaused(address account);
617 
618     bool private _paused;
619 
620     /**
621      * @dev Initializes the contract in unpaused state.
622      */
623     constructor() {
624         _paused = false;
625     }
626 
627     /**
628      * @dev Returns true if the contract is paused, and false otherwise.
629      */
630     function paused() public view virtual returns (bool) {
631         return _paused;
632     }
633 
634     /**
635      * @dev Modifier to make a function callable only when the contract is not paused.
636      *
637      * Requirements:
638      *
639      * - The contract must not be paused.
640      */
641     modifier whenNotPaused() {
642         require(!paused(), "Pausable: paused");
643         _;
644     }
645 
646     /**
647      * @dev Modifier to make a function callable only when the contract is paused.
648      *
649      * Requirements:
650      *
651      * - The contract must be paused.
652      */
653     modifier whenPaused() {
654         require(paused(), "Pausable: not paused");
655         _;
656     }
657 
658     /**
659      * @dev Triggers stopped state.
660      *
661      * Requirements:
662      *
663      * - The contract must not be paused.
664      */
665     function _pause() internal virtual whenNotPaused {
666         _paused = true;
667         emit Paused(_msgSender());
668     }
669 
670     /**
671      * @dev Returns to normal state.
672      *
673      * Requirements:
674      *
675      * - The contract must be paused.
676      */
677     function _unpause() internal virtual whenPaused {
678         _paused = false;
679         emit Unpaused(_msgSender());
680     }
681 }
682 
683 
684 /**
685  * @dev ERC20 token with pausable token transfers, minting and burning.
686  *
687  * Useful for scenarios such as preventing trades until the end of an evaluation
688  * period, or having an emergency switch for freezing all token transfers in the
689  * event of a large bug.
690  */
691 abstract contract ERC20Pausable is ERC20, Pausable {
692     /**
693      * @dev See {ERC20-_beforeTokenTransfer}.
694      *
695      * Requirements:
696      *
697      * - the contract must not be paused.
698      */
699     function _beforeTokenTransfer(
700         address from,
701         address to,
702         uint256 amount
703     ) internal virtual override {
704         super._beforeTokenTransfer(from, to, amount);
705 
706         require(!paused(), "ERC20Pausable: token transfer while paused");
707     }
708 }
709 
710 
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 
721 
722 /**
723  * @dev Implementation of the {IERC165} interface.
724  *
725  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
726  * for the additional interface id that will be supported. For example:
727  *
728  * ```solidity
729  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
731  * }
732  * ```
733  *
734  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
735  */
736 abstract contract ERC165 is IERC165 {
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         return interfaceId == type(IERC165).interfaceId;
742     }
743 }
744 
745 
746 /**
747  * @dev External interface of AccessControl declared to support ERC165 detection.
748  */
749 interface IAccessControl {
750     function hasRole(bytes32 role, address account) external view returns (bool);
751 
752     function getRoleAdmin(bytes32 role) external view returns (bytes32);
753 
754     function grantRole(bytes32 role, address account) external;
755 
756     function revokeRole(bytes32 role, address account) external;
757 
758     function renounceRole(bytes32 role, address account) external;
759 }
760 
761 /**
762  * @dev Contract module that allows children to implement role-based access
763  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
764  * members except through off-chain means by accessing the contract event logs. Some
765  * applications may benefit from on-chain enumerability, for those cases see
766  * {AccessControlEnumerable}.
767  *
768  * Roles are referred to by their `bytes32` identifier. These should be exposed
769  * in the external API and be unique. The best way to achieve this is by
770  * using `public constant` hash digests:
771  *
772  * ```
773  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
774  * ```
775  *
776  * Roles can be used to represent a set of permissions. To restrict access to a
777  * function call, use {hasRole}:
778  *
779  * ```
780  * function foo() public {
781  *     require(hasRole(MY_ROLE, msg.sender));
782  *     ...
783  * }
784  * ```
785  *
786  * Roles can be granted and revoked dynamically via the {grantRole} and
787  * {revokeRole} functions. Each role has an associated admin role, and only
788  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
789  *
790  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
791  * that only accounts with this role will be able to grant or revoke other
792  * roles. More complex role relationships can be created by using
793  * {_setRoleAdmin}.
794  *
795  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
796  * grant and revoke this role. Extra precautions should be taken to secure
797  * accounts that have been granted it.
798  */
799 abstract contract AccessControl is Context, IAccessControl, ERC165 {
800     struct RoleData {
801         mapping(address => bool) members;
802         bytes32 adminRole;
803     }
804 
805     mapping(bytes32 => RoleData) private _roles;
806 
807     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
808 
809     /**
810      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
811      *
812      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
813      * {RoleAdminChanged} not being emitted signaling this.
814      *
815      * _Available since v3.1._
816      */
817     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
818 
819     /**
820      * @dev Emitted when `account` is granted `role`.
821      *
822      * `sender` is the account that originated the contract call, an admin role
823      * bearer except when using {_setupRole}.
824      */
825     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
826 
827     /**
828      * @dev Emitted when `account` is revoked `role`.
829      *
830      * `sender` is the account that originated the contract call:
831      *   - if using `revokeRole`, it is the admin role bearer
832      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
833      */
834     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
835 
836     /**
837      * @dev Modifier that checks that an account has a specific role. Reverts
838      * with a standardized message including the required role.
839      *
840      * The format of the revert reason is given by the following regular expression:
841      *
842      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
843      *
844      * _Available since v4.1._
845      */
846     modifier onlyRole(bytes32 role) {
847         _checkRole(role, _msgSender());
848         _;
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
855         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev Returns `true` if `account` has been granted `role`.
860      */
861     function hasRole(bytes32 role, address account) public view override returns (bool) {
862         return _roles[role].members[account];
863     }
864 
865     /**
866      * @dev Revert with a standard message if `account` is missing `role`.
867      *
868      * The format of the revert reason is given by the following regular expression:
869      *
870      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
871      */
872     function _checkRole(bytes32 role, address account) internal view {
873         if (!hasRole(role, account)) {
874             revert(
875                 string(
876                     abi.encodePacked(
877                         "AccessControl: account ",
878                         Strings.toHexString(uint160(account), 20),
879                         " is missing role ",
880                         Strings.toHexString(uint256(role), 32)
881                     )
882                 )
883             );
884         }
885     }
886 
887     /**
888      * @dev Returns the admin role that controls `role`. See {grantRole} and
889      * {revokeRole}.
890      *
891      * To change a role's admin, use {_setRoleAdmin}.
892      */
893     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
894         return _roles[role].adminRole;
895     }
896 
897     /**
898      * @dev Grants `role` to `account`.
899      *
900      * If `account` had not been already granted `role`, emits a {RoleGranted}
901      * event.
902      *
903      * Requirements:
904      *
905      * - the caller must have ``role``'s admin role.
906      */
907     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
908         _grantRole(role, account);
909     }
910 
911     /**
912      * @dev Revokes `role` from `account`.
913      *
914      * If `account` had been granted `role`, emits a {RoleRevoked} event.
915      *
916      * Requirements:
917      *
918      * - the caller must have ``role``'s admin role.
919      */
920     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
921         _revokeRole(role, account);
922     }
923 
924     /**
925      * @dev Revokes `role` from the calling account.
926      *
927      * Roles are often managed via {grantRole} and {revokeRole}: this function's
928      * purpose is to provide a mechanism for accounts to lose their privileges
929      * if they are compromised (such as when a trusted device is misplaced).
930      *
931      * If the calling account had been granted `role`, emits a {RoleRevoked}
932      * event.
933      *
934      * Requirements:
935      *
936      * - the caller must be `account`.
937      */
938     function renounceRole(bytes32 role, address account) public virtual override {
939         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
940 
941         _revokeRole(role, account);
942     }
943 
944     /**
945      * @dev Grants `role` to `account`.
946      *
947      * If `account` had not been already granted `role`, emits a {RoleGranted}
948      * event. Note that unlike {grantRole}, this function doesn't perform any
949      * checks on the calling account.
950      *
951      * [WARNING]
952      * ====
953      * This function should only be called from the constructor when setting
954      * up the initial roles for the system.
955      *
956      * Using this function in any other way is effectively circumventing the admin
957      * system imposed by {AccessControl}.
958      * ====
959      */
960     function _setupRole(bytes32 role, address account) internal virtual {
961         _grantRole(role, account);
962     }
963 
964     /**
965      * @dev Sets `adminRole` as ``role``'s admin role.
966      *
967      * Emits a {RoleAdminChanged} event.
968      */
969     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
970         bytes32 previousAdminRole = getRoleAdmin(role);
971         _roles[role].adminRole = adminRole;
972         emit RoleAdminChanged(role, previousAdminRole, adminRole);
973     }
974 
975     function _grantRole(bytes32 role, address account) private {
976         if (!hasRole(role, account)) {
977             _roles[role].members[account] = true;
978             emit RoleGranted(role, account, _msgSender());
979         }
980     }
981 
982     function _revokeRole(bytes32 role, address account) private {
983         if (hasRole(role, account)) {
984             _roles[role].members[account] = false;
985             emit RoleRevoked(role, account, _msgSender());
986         }
987     }
988 }
989 
990 
991 
992 contract PureFiToken is ERC20Pausable, AccessControl {
993 
994     address botProtector;
995 
996     constructor(address _admin) 
997     ERC20("PureFi Token", "UFI") {
998         _mint(_admin, 100000000 * (10 ** uint(decimals())));
999         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
1000     }
1001 
1002     modifier onlyAdmin() {
1003         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not the Admin");
1004         _;
1005     }
1006 
1007     //admin functions
1008     function pause() onlyAdmin public {
1009         super._pause();
1010     }
1011 
1012     function unpause() onlyAdmin public {
1013         super._unpause();
1014     }
1015 
1016     function setBotProtector(address _botProtector) onlyAdmin public{
1017         botProtector = _botProtector;
1018     }
1019 
1020     //internal functions
1021     function _transfer(address sender, address recipient, uint256 amount) internal override {
1022         if(botProtector != address(0)){
1023             require(!IBotProtector(botProtector).isPotentialBotTransfer(sender, recipient), "PureFiToken: Bot transaction debounced");
1024         }
1025         super._transfer(sender, recipient, amount);
1026     }
1027 }