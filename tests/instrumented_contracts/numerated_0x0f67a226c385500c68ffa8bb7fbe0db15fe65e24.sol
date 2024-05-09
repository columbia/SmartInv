1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Emitted when `value` tokens are moved from one account (`from`) to
17      * another (`to`).
18      *
19      * Note that `value` may be zero.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
25      * a call to {approve}. `value` is the new allowance.
26      */
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 }
88 
89 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Interface of the ERC165 standard, as defined in the
128  * https://eips.ethereum.org/EIPS/eip-165[EIP].
129  *
130  * Implementers can declare support of contract interfaces, which can then be
131  * queried by others ({ERC165Checker}).
132  *
133  * For an implementation, see {ERC165}.
134  */
135 interface IERC165 {
136     /**
137      * @dev Returns true if this contract implements the interface defined by
138      * `interfaceId`. See the corresponding
139      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
140      * to learn more about how these ids are created.
141      *
142      * This function call must use less than 30 000 gas.
143      */
144     function supportsInterface(bytes4 interfaceId) external view returns (bool);
145 }
146 
147 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 /**
156  * @dev Implementation of the {IERC165} interface.
157  *
158  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
159  * for the additional interface id that will be supported. For example:
160  *
161  * ```solidity
162  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
163  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
164  * }
165  * ```
166  *
167  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
168  */
169 abstract contract ERC165 is IERC165 {
170     /**
171      * @dev See {IERC165-supportsInterface}.
172      */
173     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
174         return interfaceId == type(IERC165).interfaceId;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Strings.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190     uint8 private constant _ADDRESS_LENGTH = 20;
191 
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
194      */
195     function toString(uint256 value) internal pure returns (string memory) {
196         // Inspired by OraclizeAPI's implementation - MIT licence
197         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
198 
199         if (value == 0) {
200             return "0";
201         }
202         uint256 temp = value;
203         uint256 digits;
204         while (temp != 0) {
205             digits++;
206             temp /= 10;
207         }
208         bytes memory buffer = new bytes(digits);
209         while (value != 0) {
210             digits -= 1;
211             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
212             value /= 10;
213         }
214         return string(buffer);
215     }
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
219      */
220     function toHexString(uint256 value) internal pure returns (string memory) {
221         if (value == 0) {
222             return "0x00";
223         }
224         uint256 temp = value;
225         uint256 length = 0;
226         while (temp != 0) {
227             length++;
228             temp >>= 8;
229         }
230         return toHexString(value, length);
231     }
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
235      */
236     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
237         bytes memory buffer = new bytes(2 * length + 2);
238         buffer[0] = "0";
239         buffer[1] = "x";
240         for (uint256 i = 2 * length + 1; i > 1; --i) {
241             buffer[i] = _HEX_SYMBOLS[value & 0xf];
242             value >>= 4;
243         }
244         require(value == 0, "Strings: hex length insufficient");
245         return string(buffer);
246     }
247 
248     /**
249      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
250      */
251     function toHexString(address addr) internal pure returns (string memory) {
252         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
253     }
254 }
255 
256 // File: @openzeppelin/contracts/utils/Context.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Provides information about the current execution context, including the
265  * sender of the transaction and its data. While these are generally available
266  * via msg.sender and msg.data, they should not be accessed in such a direct
267  * manner, since when dealing with meta-transactions the account sending and
268  * paying for execution may not be the actual sender (as far as an application
269  * is concerned).
270  *
271  * This contract is only required for intermediate, library-like contracts.
272  */
273 abstract contract Context {
274     function _msgSender() internal view virtual returns (address) {
275         return msg.sender;
276     }
277 
278     function _msgData() internal view virtual returns (bytes calldata) {
279         return msg.data;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 
291 
292 
293 /**
294  * @dev Implementation of the {IERC20} interface.
295  *
296  * This implementation is agnostic to the way tokens are created. This means
297  * that a supply mechanism has to be added in a derived contract using {_mint}.
298  * For a generic mechanism see {ERC20PresetMinterPauser}.
299  *
300  * TIP: For a detailed writeup see our guide
301  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
302  * to implement supply mechanisms].
303  *
304  * We have followed general OpenZeppelin Contracts guidelines: functions revert
305  * instead returning `false` on failure. This behavior is nonetheless
306  * conventional and does not conflict with the expectations of ERC20
307  * applications.
308  *
309  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
310  * This allows applications to reconstruct the allowance for all accounts just
311  * by listening to said events. Other implementations of the EIP may not emit
312  * these events, as it isn't required by the specification.
313  *
314  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
315  * functions have been added to mitigate the well-known issues around setting
316  * allowances. See {IERC20-approve}.
317  */
318 contract ERC20 is Context, IERC20, IERC20Metadata {
319     mapping(address => uint256) private _balances;
320 
321     mapping(address => mapping(address => uint256)) private _allowances;
322 
323     uint256 private _totalSupply;
324 
325     string private _name;
326     string private _symbol;
327 
328     /**
329      * @dev Sets the values for {name} and {symbol}.
330      *
331      * The default value of {decimals} is 18. To select a different value for
332      * {decimals} you should overload it.
333      *
334      * All two of these values are immutable: they can only be set once during
335      * construction.
336      */
337     constructor(string memory name_, string memory symbol_) {
338         _name = name_;
339         _symbol = symbol_;
340     }
341 
342     /**
343      * @dev Returns the name of the token.
344      */
345     function name() public view virtual override returns (string memory) {
346         return _name;
347     }
348 
349     /**
350      * @dev Returns the symbol of the token, usually a shorter version of the
351      * name.
352      */
353     function symbol() public view virtual override returns (string memory) {
354         return _symbol;
355     }
356 
357     /**
358      * @dev Returns the number of decimals used to get its user representation.
359      * For example, if `decimals` equals `2`, a balance of `505` tokens should
360      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
361      *
362      * Tokens usually opt for a value of 18, imitating the relationship between
363      * Ether and Wei. This is the value {ERC20} uses, unless this function is
364      * overridden;
365      *
366      * NOTE: This information is only used for _display_ purposes: it in
367      * no way affects any of the arithmetic of the contract, including
368      * {IERC20-balanceOf} and {IERC20-transfer}.
369      */
370     function decimals() public view virtual override returns (uint8) {
371         return 18;
372     }
373 
374     /**
375      * @dev See {IERC20-totalSupply}.
376      */
377     function totalSupply() public view virtual override returns (uint256) {
378         return _totalSupply;
379     }
380 
381     /**
382      * @dev See {IERC20-balanceOf}.
383      */
384     function balanceOf(address account) public view virtual override returns (uint256) {
385         return _balances[account];
386     }
387 
388     /**
389      * @dev See {IERC20-transfer}.
390      *
391      * Requirements:
392      *
393      * - `to` cannot be the zero address.
394      * - the caller must have a balance of at least `amount`.
395      */
396     function transfer(address to, uint256 amount) public virtual override returns (bool) {
397         address owner = _msgSender();
398         _transfer(owner, to, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-allowance}.
404      */
405     function allowance(address owner, address spender) public view virtual override returns (uint256) {
406         return _allowances[owner][spender];
407     }
408 
409     /**
410      * @dev See {IERC20-approve}.
411      *
412      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
413      * `transferFrom`. This is semantically equivalent to an infinite approval.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function approve(address spender, uint256 amount) public virtual override returns (bool) {
420         address owner = _msgSender();
421         _approve(owner, spender, amount);
422         return true;
423     }
424 
425     /**
426      * @dev See {IERC20-transferFrom}.
427      *
428      * Emits an {Approval} event indicating the updated allowance. This is not
429      * required by the EIP. See the note at the beginning of {ERC20}.
430      *
431      * NOTE: Does not update the allowance if the current allowance
432      * is the maximum `uint256`.
433      *
434      * Requirements:
435      *
436      * - `from` and `to` cannot be the zero address.
437      * - `from` must have a balance of at least `amount`.
438      * - the caller must have allowance for ``from``'s tokens of at least
439      * `amount`.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 amount
445     ) public virtual override returns (bool) {
446         address spender = _msgSender();
447         _spendAllowance(from, spender, amount);
448         _transfer(from, to, amount);
449         return true;
450     }
451 
452     /**
453      * @dev Atomically increases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
465         address owner = _msgSender();
466         _approve(owner, spender, allowance(owner, spender) + addedValue);
467         return true;
468     }
469 
470     /**
471      * @dev Atomically decreases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      * - `spender` must have allowance for the caller of at least
482      * `subtractedValue`.
483      */
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         address owner = _msgSender();
486         uint256 currentAllowance = allowance(owner, spender);
487         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
488         unchecked {
489             _approve(owner, spender, currentAllowance - subtractedValue);
490         }
491 
492         return true;
493     }
494 
495     /**
496      * @dev Moves `amount` of tokens from `from` to `to`.
497      *
498      * This internal function is equivalent to {transfer}, and can be used to
499      * e.g. implement automatic token fees, slashing mechanisms, etc.
500      *
501      * Emits a {Transfer} event.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `from` must have a balance of at least `amount`.
508      */
509     function _transfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal virtual {
514         require(from != address(0), "ERC20: transfer from the zero address");
515         require(to != address(0), "ERC20: transfer to the zero address");
516 
517         _beforeTokenTransfer(from, to, amount);
518 
519         uint256 fromBalance = _balances[from];
520         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
521         unchecked {
522             _balances[from] = fromBalance - amount;
523         }
524         _balances[to] += amount;
525 
526         emit Transfer(from, to, amount);
527 
528         _afterTokenTransfer(from, to, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `account` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply += amount;
546         _balances[account] += amount;
547         emit Transfer(address(0), account, amount);
548 
549         _afterTokenTransfer(address(0), account, amount);
550     }
551 
552     /**
553      * @dev Destroys `amount` tokens from `account`, reducing the
554      * total supply.
555      *
556      * Emits a {Transfer} event with `to` set to the zero address.
557      *
558      * Requirements:
559      *
560      * - `account` cannot be the zero address.
561      * - `account` must have at least `amount` tokens.
562      */
563     function _burn(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: burn from the zero address");
565 
566         _beforeTokenTransfer(account, address(0), amount);
567 
568         uint256 accountBalance = _balances[account];
569         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
570         unchecked {
571             _balances[account] = accountBalance - amount;
572         }
573         _totalSupply -= amount;
574 
575         emit Transfer(account, address(0), amount);
576 
577         _afterTokenTransfer(account, address(0), amount);
578     }
579 
580     /**
581      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
582      *
583      * This internal function is equivalent to `approve`, and can be used to
584      * e.g. set automatic allowances for certain subsystems, etc.
585      *
586      * Emits an {Approval} event.
587      *
588      * Requirements:
589      *
590      * - `owner` cannot be the zero address.
591      * - `spender` cannot be the zero address.
592      */
593     function _approve(
594         address owner,
595         address spender,
596         uint256 amount
597     ) internal virtual {
598         require(owner != address(0), "ERC20: approve from the zero address");
599         require(spender != address(0), "ERC20: approve to the zero address");
600 
601         _allowances[owner][spender] = amount;
602         emit Approval(owner, spender, amount);
603     }
604 
605     /**
606      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
607      *
608      * Does not update the allowance amount in case of infinite allowance.
609      * Revert if not enough allowance is available.
610      *
611      * Might emit an {Approval} event.
612      */
613     function _spendAllowance(
614         address owner,
615         address spender,
616         uint256 amount
617     ) internal virtual {
618         uint256 currentAllowance = allowance(owner, spender);
619         if (currentAllowance != type(uint256).max) {
620             require(currentAllowance >= amount, "ERC20: insufficient allowance");
621             unchecked {
622                 _approve(owner, spender, currentAllowance - amount);
623             }
624         }
625     }
626 
627     /**
628      * @dev Hook that is called before any transfer of tokens. This includes
629      * minting and burning.
630      *
631      * Calling conditions:
632      *
633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
634      * will be transferred to `to`.
635      * - when `from` is zero, `amount` tokens will be minted for `to`.
636      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
637      * - `from` and `to` are never both zero.
638      *
639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
640      */
641     function _beforeTokenTransfer(
642         address from,
643         address to,
644         uint256 amount
645     ) internal virtual {}
646 
647     /**
648      * @dev Hook that is called after any transfer of tokens. This includes
649      * minting and burning.
650      *
651      * Calling conditions:
652      *
653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
654      * has been transferred to `to`.
655      * - when `from` is zero, `amount` tokens have been minted for `to`.
656      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
657      * - `from` and `to` are never both zero.
658      *
659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
660      */
661     function _afterTokenTransfer(
662         address from,
663         address to,
664         uint256 amount
665     ) internal virtual {}
666 }
667 
668 // File: @openzeppelin/contracts/access/IAccessControl.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev External interface of AccessControl declared to support ERC165 detection.
677  */
678 interface IAccessControl {
679     /**
680      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
681      *
682      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
683      * {RoleAdminChanged} not being emitted signaling this.
684      *
685      * _Available since v3.1._
686      */
687     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
688 
689     /**
690      * @dev Emitted when `account` is granted `role`.
691      *
692      * `sender` is the account that originated the contract call, an admin role
693      * bearer except when using {AccessControl-_setupRole}.
694      */
695     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
696 
697     /**
698      * @dev Emitted when `account` is revoked `role`.
699      *
700      * `sender` is the account that originated the contract call:
701      *   - if using `revokeRole`, it is the admin role bearer
702      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
703      */
704     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
705 
706     /**
707      * @dev Returns `true` if `account` has been granted `role`.
708      */
709     function hasRole(bytes32 role, address account) external view returns (bool);
710 
711     /**
712      * @dev Returns the admin role that controls `role`. See {grantRole} and
713      * {revokeRole}.
714      *
715      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
716      */
717     function getRoleAdmin(bytes32 role) external view returns (bytes32);
718 
719     /**
720      * @dev Grants `role` to `account`.
721      *
722      * If `account` had not been already granted `role`, emits a {RoleGranted}
723      * event.
724      *
725      * Requirements:
726      *
727      * - the caller must have ``role``'s admin role.
728      */
729     function grantRole(bytes32 role, address account) external;
730 
731     /**
732      * @dev Revokes `role` from `account`.
733      *
734      * If `account` had been granted `role`, emits a {RoleRevoked} event.
735      *
736      * Requirements:
737      *
738      * - the caller must have ``role``'s admin role.
739      */
740     function revokeRole(bytes32 role, address account) external;
741 
742     /**
743      * @dev Revokes `role` from the calling account.
744      *
745      * Roles are often managed via {grantRole} and {revokeRole}: this function's
746      * purpose is to provide a mechanism for accounts to lose their privileges
747      * if they are compromised (such as when a trusted device is misplaced).
748      *
749      * If the calling account had been granted `role`, emits a {RoleRevoked}
750      * event.
751      *
752      * Requirements:
753      *
754      * - the caller must be `account`.
755      */
756     function renounceRole(bytes32 role, address account) external;
757 }
758 
759 // File: @openzeppelin/contracts/access/AccessControl.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 
768 
769 
770 /**
771  * @dev Contract module that allows children to implement role-based access
772  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
773  * members except through off-chain means by accessing the contract event logs. Some
774  * applications may benefit from on-chain enumerability, for those cases see
775  * {AccessControlEnumerable}.
776  *
777  * Roles are referred to by their `bytes32` identifier. These should be exposed
778  * in the external API and be unique. The best way to achieve this is by
779  * using `public constant` hash digests:
780  *
781  * ```
782  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
783  * ```
784  *
785  * Roles can be used to represent a set of permissions. To restrict access to a
786  * function call, use {hasRole}:
787  *
788  * ```
789  * function foo() public {
790  *     require(hasRole(MY_ROLE, msg.sender));
791  *     ...
792  * }
793  * ```
794  *
795  * Roles can be granted and revoked dynamically via the {grantRole} and
796  * {revokeRole} functions. Each role has an associated admin role, and only
797  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
798  *
799  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
800  * that only accounts with this role will be able to grant or revoke other
801  * roles. More complex role relationships can be created by using
802  * {_setRoleAdmin}.
803  *
804  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
805  * grant and revoke this role. Extra precautions should be taken to secure
806  * accounts that have been granted it.
807  */
808 abstract contract AccessControl is Context, IAccessControl, ERC165 {
809     struct RoleData {
810         mapping(address => bool) members;
811         bytes32 adminRole;
812     }
813 
814     mapping(bytes32 => RoleData) private _roles;
815 
816     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
817 
818     /**
819      * @dev Modifier that checks that an account has a specific role. Reverts
820      * with a standardized message including the required role.
821      *
822      * The format of the revert reason is given by the following regular expression:
823      *
824      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
825      *
826      * _Available since v4.1._
827      */
828     modifier onlyRole(bytes32 role) {
829         _checkRole(role);
830         _;
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
837         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
838     }
839 
840     /**
841      * @dev Returns `true` if `account` has been granted `role`.
842      */
843     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
844         return _roles[role].members[account];
845     }
846 
847     /**
848      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
849      * Overriding this function changes the behavior of the {onlyRole} modifier.
850      *
851      * Format of the revert message is described in {_checkRole}.
852      *
853      * _Available since v4.6._
854      */
855     function _checkRole(bytes32 role) internal view virtual {
856         _checkRole(role, _msgSender());
857     }
858 
859     /**
860      * @dev Revert with a standard message if `account` is missing `role`.
861      *
862      * The format of the revert reason is given by the following regular expression:
863      *
864      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
865      */
866     function _checkRole(bytes32 role, address account) internal view virtual {
867         if (!hasRole(role, account)) {
868             revert(
869                 string(
870                     abi.encodePacked(
871                         "AccessControl: account ",
872                         Strings.toHexString(uint160(account), 20),
873                         " is missing role ",
874                         Strings.toHexString(uint256(role), 32)
875                     )
876                 )
877             );
878         }
879     }
880 
881     /**
882      * @dev Returns the admin role that controls `role`. See {grantRole} and
883      * {revokeRole}.
884      *
885      * To change a role's admin, use {_setRoleAdmin}.
886      */
887     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
888         return _roles[role].adminRole;
889     }
890 
891     /**
892      * @dev Grants `role` to `account`.
893      *
894      * If `account` had not been already granted `role`, emits a {RoleGranted}
895      * event.
896      *
897      * Requirements:
898      *
899      * - the caller must have ``role``'s admin role.
900      *
901      * May emit a {RoleGranted} event.
902      */
903     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
904         _grantRole(role, account);
905     }
906 
907     /**
908      * @dev Revokes `role` from `account`.
909      *
910      * If `account` had been granted `role`, emits a {RoleRevoked} event.
911      *
912      * Requirements:
913      *
914      * - the caller must have ``role``'s admin role.
915      *
916      * May emit a {RoleRevoked} event.
917      */
918     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
919         _revokeRole(role, account);
920     }
921 
922     /**
923      * @dev Revokes `role` from the calling account.
924      *
925      * Roles are often managed via {grantRole} and {revokeRole}: this function's
926      * purpose is to provide a mechanism for accounts to lose their privileges
927      * if they are compromised (such as when a trusted device is misplaced).
928      *
929      * If the calling account had been revoked `role`, emits a {RoleRevoked}
930      * event.
931      *
932      * Requirements:
933      *
934      * - the caller must be `account`.
935      *
936      * May emit a {RoleRevoked} event.
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
951      * May emit a {RoleGranted} event.
952      *
953      * [WARNING]
954      * ====
955      * This function should only be called from the constructor when setting
956      * up the initial roles for the system.
957      *
958      * Using this function in any other way is effectively circumventing the admin
959      * system imposed by {AccessControl}.
960      * ====
961      *
962      * NOTE: This function is deprecated in favor of {_grantRole}.
963      */
964     function _setupRole(bytes32 role, address account) internal virtual {
965         _grantRole(role, account);
966     }
967 
968     /**
969      * @dev Sets `adminRole` as ``role``'s admin role.
970      *
971      * Emits a {RoleAdminChanged} event.
972      */
973     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
974         bytes32 previousAdminRole = getRoleAdmin(role);
975         _roles[role].adminRole = adminRole;
976         emit RoleAdminChanged(role, previousAdminRole, adminRole);
977     }
978 
979     /**
980      * @dev Grants `role` to `account`.
981      *
982      * Internal function without access restriction.
983      *
984      * May emit a {RoleGranted} event.
985      */
986     function _grantRole(bytes32 role, address account) internal virtual {
987         if (!hasRole(role, account)) {
988             _roles[role].members[account] = true;
989             emit RoleGranted(role, account, _msgSender());
990         }
991     }
992 
993     /**
994      * @dev Revokes `role` from `account`.
995      *
996      * Internal function without access restriction.
997      *
998      * May emit a {RoleRevoked} event.
999      */
1000     function _revokeRole(bytes32 role, address account) internal virtual {
1001         if (hasRole(role, account)) {
1002             _roles[role].members[account] = false;
1003             emit RoleRevoked(role, account, _msgSender());
1004         }
1005     }
1006 }
1007 
1008 // File: contracts/TokenSwap.sol
1009 
1010 
1011 
1012 pragma solidity ^0.8.15;
1013 
1014 
1015 
1016 contract TokenSwap is AccessControl, ERC20 {
1017   // Commission Price
1018   mapping(string => uint256) public commissionPrice;
1019   address private recipientCommission;
1020 
1021   mapping(string => bool) public blockchainExisting;
1022 
1023   /// ROLES
1024   bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
1025   bytes32 private constant SETTING_CONTRACT = keccak256("SETTING_CONTRACT");
1026 
1027   constructor(
1028     string memory name,
1029     string memory symbol,
1030     address _minter,
1031     address _settingContract,
1032     address _recipientCommission
1033   ) ERC20(name, symbol) {
1034     _setupRole(MINTER_ROLE, _minter);
1035     _setupRole(SETTING_CONTRACT, _settingContract);
1036     recipientCommission = _recipientCommission;
1037   }
1038 
1039   /// EVENTS
1040 
1041   event SwapToken(
1042     address indexed sender,
1043     address indexed recipient,
1044     string externalRecipient,
1045     string blockchain,
1046     uint256 amount
1047   );
1048 
1049   /// CONSTANS
1050 
1051   function decimals() public view virtual override returns (uint8) {
1052     return 6;
1053   }
1054 
1055   /// PUBLIC FUNCTION
1056 
1057   /// @notice Transfer of the token to other blockchains
1058   /// @param externalRecipient - The address of the token recipient in another blockchain.
1059   /// @param toBlockchain - The blockchain into which we transfer funds
1060   /// @param amount - Number of tokens.
1061   function swap(
1062     string memory externalRecipient,
1063     string memory toBlockchain,
1064     uint256 amount
1065   ) public payable virtual {
1066     require(msg.value >= commissionPrice[toBlockchain], "TokenSwap: low gas price.");
1067     payable(recipientCommission).transfer(msg.value);
1068     _swap(msg.sender, address(this), externalRecipient, toBlockchain, amount);
1069   }
1070 
1071   /// ROLE FUNCTION
1072 
1073   /// @notice Available only for MINTER_ROLE. Mint token.
1074   /// @param recipient - Token Recipient
1075   /// @param amount - Number of tokens.
1076   function mint(address recipient, uint256 amount) external onlyRole(MINTER_ROLE) {
1077     _mint(recipient, amount);
1078   }
1079 
1080   function setSwapBlockchain(string memory toBlockchain, bool status) public virtual onlyRole(SETTING_CONTRACT) {
1081     require(blockchainExisting[toBlockchain] != status, "Already in this status");
1082     blockchainExisting[toBlockchain] = status;
1083   }
1084 
1085   function setCommissionPrice(string memory toBlockchain, uint256 value) public virtual onlyRole(SETTING_CONTRACT) {
1086     commissionPrice[toBlockchain] = value;
1087   }
1088 
1089   /// PRIVATE FUNCTION
1090 
1091   function _swap(
1092     address sender,
1093     address recipient,
1094     string memory externalRecipient,
1095     string memory toBlockchain,
1096     uint256 amount
1097   ) internal virtual {
1098     require(blockchainExisting[toBlockchain], "TokenSwap: Swap is prohibited.");
1099     require(sender != address(0), "TokenSwap: swap sender the zero address");
1100     require(recipient != address(0), "TokenSwap: swap recipient the zero address");
1101 
1102     _beforeTokenSwap(sender, recipient, externalRecipient, amount);
1103     _burn(sender, amount);
1104     emit SwapToken(sender, recipient, externalRecipient, toBlockchain, amount);
1105   }
1106 
1107   function _beforeTokenSwap(
1108     address sender,
1109     address recipient,
1110     string memory externalRecipient,
1111     uint256 amount
1112   ) internal virtual {}
1113 }