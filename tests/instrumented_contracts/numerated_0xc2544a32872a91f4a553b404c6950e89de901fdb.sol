1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.9.0 https://hardhat.org
5 
6 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
9 
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `to`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address to, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `from` to `to` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address from,
70         address to,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
145 
146 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
147 
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `to` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address to, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _transfer(owner, to, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
271      * `transferFrom`. This is semantically equivalent to an infinite approval.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * NOTE: Does not update the allowance if the current allowance
290      * is the maximum `uint256`.
291      *
292      * Requirements:
293      *
294      * - `from` and `to` cannot be the zero address.
295      * - `from` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``from``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         address spender = _msgSender();
305         _spendAllowance(from, spender, amount);
306         _transfer(from, to, amount);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         _approve(owner, spender, _allowances[owner][spender] + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = _allowances[owner][spender];
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `sender` to `recipient`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `from` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {
372         require(from != address(0), "ERC20: transfer from the zero address");
373         require(to != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(from, to, amount);
376 
377         uint256 fromBalance = _balances[from];
378         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[from] = fromBalance - amount;
381         }
382         _balances[to] += amount;
383 
384         emit Transfer(from, to, amount);
385 
386         _afterTokenTransfer(from, to, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430         }
431         _totalSupply -= amount;
432 
433         emit Transfer(account, address(0), amount);
434 
435         _afterTokenTransfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(currentAllowance >= amount, "ERC20: insufficient allowance");
479             unchecked {
480                 _approve(owner, spender, currentAllowance - amount);
481             }
482         }
483     }
484 
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 
505     /**
506      * @dev Hook that is called after any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * has been transferred to `to`.
513      * - when `from` is zero, `amount` tokens have been minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 }
525 
526 
527 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.5.0
528 
529 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
530 
531 
532 
533 /**
534  * @dev Extension of {ERC20} that allows token holders to destroy both their own
535  * tokens and those that they have an allowance for, in a way that can be
536  * recognized off-chain (via event analysis).
537  */
538 abstract contract ERC20Burnable is Context, ERC20 {
539     /**
540      * @dev Destroys `amount` tokens from the caller.
541      *
542      * See {ERC20-_burn}.
543      */
544     function burn(uint256 amount) public virtual {
545         _burn(_msgSender(), amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
550      * allowance.
551      *
552      * See {ERC20-_burn} and {ERC20-allowance}.
553      *
554      * Requirements:
555      *
556      * - the caller must have allowance for ``accounts``'s tokens of at least
557      * `amount`.
558      */
559     function burnFrom(address account, uint256 amount) public virtual {
560         _spendAllowance(account, _msgSender(), amount);
561         _burn(account, amount);
562     }
563 }
564 
565 
566 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
567 
568 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
569 
570 
571 /**
572  * @dev Contract module which allows children to implement an emergency stop
573  * mechanism that can be triggered by an authorized account.
574  *
575  * This module is used through inheritance. It will make available the
576  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
577  * the functions of your contract. Note that they will not be pausable by
578  * simply including this module, only once the modifiers are put in place.
579  */
580 abstract contract Pausable is Context {
581     /**
582      * @dev Emitted when the pause is triggered by `account`.
583      */
584     event Paused(address account);
585 
586     /**
587      * @dev Emitted when the pause is lifted by `account`.
588      */
589     event Unpaused(address account);
590 
591     bool private _paused;
592 
593     /**
594      * @dev Initializes the contract in unpaused state.
595      */
596     constructor() {
597         _paused = false;
598     }
599 
600     /**
601      * @dev Returns true if the contract is paused, and false otherwise.
602      */
603     function paused() public view virtual returns (bool) {
604         return _paused;
605     }
606 
607     /**
608      * @dev Modifier to make a function callable only when the contract is not paused.
609      *
610      * Requirements:
611      *
612      * - The contract must not be paused.
613      */
614     modifier whenNotPaused() {
615         require(!paused(), "Pausable: paused");
616         _;
617     }
618 
619     /**
620      * @dev Modifier to make a function callable only when the contract is paused.
621      *
622      * Requirements:
623      *
624      * - The contract must be paused.
625      */
626     modifier whenPaused() {
627         require(paused(), "Pausable: not paused");
628         _;
629     }
630 
631     /**
632      * @dev Triggers stopped state.
633      *
634      * Requirements:
635      *
636      * - The contract must not be paused.
637      */
638     function _pause() internal virtual whenNotPaused {
639         _paused = true;
640         emit Paused(_msgSender());
641     }
642 
643     /**
644      * @dev Returns to normal state.
645      *
646      * Requirements:
647      *
648      * - The contract must be paused.
649      */
650     function _unpause() internal virtual whenPaused {
651         _paused = false;
652         emit Unpaused(_msgSender());
653     }
654 }
655 
656 
657 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.5.0
658 
659 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
660 
661 
662 /**
663  * @dev External interface of AccessControl declared to support ERC165 detection.
664  */
665 interface IAccessControl {
666     /**
667      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
668      *
669      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
670      * {RoleAdminChanged} not being emitted signaling this.
671      *
672      * _Available since v3.1._
673      */
674     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
675 
676     /**
677      * @dev Emitted when `account` is granted `role`.
678      *
679      * `sender` is the account that originated the contract call, an admin role
680      * bearer except when using {AccessControl-_setupRole}.
681      */
682     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
683 
684     /**
685      * @dev Emitted when `account` is revoked `role`.
686      *
687      * `sender` is the account that originated the contract call:
688      *   - if using `revokeRole`, it is the admin role bearer
689      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
690      */
691     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
692 
693     /**
694      * @dev Returns `true` if `account` has been granted `role`.
695      */
696     function hasRole(bytes32 role, address account) external view returns (bool);
697 
698     /**
699      * @dev Returns the admin role that controls `role`. See {grantRole} and
700      * {revokeRole}.
701      *
702      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
703      */
704     function getRoleAdmin(bytes32 role) external view returns (bytes32);
705 
706     /**
707      * @dev Grants `role` to `account`.
708      *
709      * If `account` had not been already granted `role`, emits a {RoleGranted}
710      * event.
711      *
712      * Requirements:
713      *
714      * - the caller must have ``role``'s admin role.
715      */
716     function grantRole(bytes32 role, address account) external;
717 
718     /**
719      * @dev Revokes `role` from `account`.
720      *
721      * If `account` had been granted `role`, emits a {RoleRevoked} event.
722      *
723      * Requirements:
724      *
725      * - the caller must have ``role``'s admin role.
726      */
727     function revokeRole(bytes32 role, address account) external;
728 
729     /**
730      * @dev Revokes `role` from the calling account.
731      *
732      * Roles are often managed via {grantRole} and {revokeRole}: this function's
733      * purpose is to provide a mechanism for accounts to lose their privileges
734      * if they are compromised (such as when a trusted device is misplaced).
735      *
736      * If the calling account had been granted `role`, emits a {RoleRevoked}
737      * event.
738      *
739      * Requirements:
740      *
741      * - the caller must be `account`.
742      */
743     function renounceRole(bytes32 role, address account) external;
744 }
745 
746 
747 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
750 
751 
752 /**
753  * @dev String operations.
754  */
755 library Strings {
756     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
757 
758     /**
759      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
760      */
761     function toString(uint256 value) internal pure returns (string memory) {
762         // Inspired by OraclizeAPI's implementation - MIT licence
763         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
764 
765         if (value == 0) {
766             return "0";
767         }
768         uint256 temp = value;
769         uint256 digits;
770         while (temp != 0) {
771             digits++;
772             temp /= 10;
773         }
774         bytes memory buffer = new bytes(digits);
775         while (value != 0) {
776             digits -= 1;
777             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
778             value /= 10;
779         }
780         return string(buffer);
781     }
782 
783     /**
784      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
785      */
786     function toHexString(uint256 value) internal pure returns (string memory) {
787         if (value == 0) {
788             return "0x00";
789         }
790         uint256 temp = value;
791         uint256 length = 0;
792         while (temp != 0) {
793             length++;
794             temp >>= 8;
795         }
796         return toHexString(value, length);
797     }
798 
799     /**
800      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
801      */
802     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
803         bytes memory buffer = new bytes(2 * length + 2);
804         buffer[0] = "0";
805         buffer[1] = "x";
806         for (uint256 i = 2 * length + 1; i > 1; --i) {
807             buffer[i] = _HEX_SYMBOLS[value & 0xf];
808             value >>= 4;
809         }
810         require(value == 0, "Strings: hex length insufficient");
811         return string(buffer);
812     }
813 }
814 
815 
816 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
817 
818 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
819 
820 
821 /**
822  * @dev Interface of the ERC165 standard, as defined in the
823  * https://eips.ethereum.org/EIPS/eip-165[EIP].
824  *
825  * Implementers can declare support of contract interfaces, which can then be
826  * queried by others ({ERC165Checker}).
827  *
828  * For an implementation, see {ERC165}.
829  */
830 interface IERC165 {
831     /**
832      * @dev Returns true if this contract implements the interface defined by
833      * `interfaceId`. See the corresponding
834      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
835      * to learn more about how these ids are created.
836      *
837      * This function call must use less than 30 000 gas.
838      */
839     function supportsInterface(bytes4 interfaceId) external view returns (bool);
840 }
841 
842 
843 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
844 
845 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
846 
847 
848 /**
849  * @dev Implementation of the {IERC165} interface.
850  *
851  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
852  * for the additional interface id that will be supported. For example:
853  *
854  * ```solidity
855  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
856  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
857  * }
858  * ```
859  *
860  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
861  */
862 abstract contract ERC165 is IERC165 {
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
867         return interfaceId == type(IERC165).interfaceId;
868     }
869 }
870 
871 
872 // File @openzeppelin/contracts/access/AccessControl.sol@v4.5.0
873 
874 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
875 
876 
877 
878 
879 
880 /**
881  * @dev Contract module that allows children to implement role-based access
882  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
883  * members except through off-chain means by accessing the contract event logs. Some
884  * applications may benefit from on-chain enumerability, for those cases see
885  * {AccessControlEnumerable}.
886  *
887  * Roles are referred to by their `bytes32` identifier. These should be exposed
888  * in the external API and be unique. The best way to achieve this is by
889  * using `public constant` hash digests:
890  *
891  * ```
892  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
893  * ```
894  *
895  * Roles can be used to represent a set of permissions. To restrict access to a
896  * function call, use {hasRole}:
897  *
898  * ```
899  * function foo() public {
900  *     require(hasRole(MY_ROLE, msg.sender));
901  *     ...
902  * }
903  * ```
904  *
905  * Roles can be granted and revoked dynamically via the {grantRole} and
906  * {revokeRole} functions. Each role has an associated admin role, and only
907  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
908  *
909  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
910  * that only accounts with this role will be able to grant or revoke other
911  * roles. More complex role relationships can be created by using
912  * {_setRoleAdmin}.
913  *
914  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
915  * grant and revoke this role. Extra precautions should be taken to secure
916  * accounts that have been granted it.
917  */
918 abstract contract AccessControl is Context, IAccessControl, ERC165 {
919     struct RoleData {
920         mapping(address => bool) members;
921         bytes32 adminRole;
922     }
923 
924     mapping(bytes32 => RoleData) private _roles;
925 
926     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
927 
928     /**
929      * @dev Modifier that checks that an account has a specific role. Reverts
930      * with a standardized message including the required role.
931      *
932      * The format of the revert reason is given by the following regular expression:
933      *
934      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
935      *
936      * _Available since v4.1._
937      */
938     modifier onlyRole(bytes32 role) {
939         _checkRole(role, _msgSender());
940         _;
941     }
942 
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      */
946     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
947         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
948     }
949 
950     /**
951      * @dev Returns `true` if `account` has been granted `role`.
952      */
953     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
954         return _roles[role].members[account];
955     }
956 
957     /**
958      * @dev Revert with a standard message if `account` is missing `role`.
959      *
960      * The format of the revert reason is given by the following regular expression:
961      *
962      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
963      */
964     function _checkRole(bytes32 role, address account) internal view virtual {
965         if (!hasRole(role, account)) {
966             revert(
967                 string(
968                     abi.encodePacked(
969                         "AccessControl: account ",
970                         Strings.toHexString(uint160(account), 20),
971                         " is missing role ",
972                         Strings.toHexString(uint256(role), 32)
973                     )
974                 )
975             );
976         }
977     }
978 
979     /**
980      * @dev Returns the admin role that controls `role`. See {grantRole} and
981      * {revokeRole}.
982      *
983      * To change a role's admin, use {_setRoleAdmin}.
984      */
985     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
986         return _roles[role].adminRole;
987     }
988 
989     /**
990      * @dev Grants `role` to `account`.
991      *
992      * If `account` had not been already granted `role`, emits a {RoleGranted}
993      * event.
994      *
995      * Requirements:
996      *
997      * - the caller must have ``role``'s admin role.
998      */
999     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1000         _grantRole(role, account);
1001     }
1002 
1003     /**
1004      * @dev Revokes `role` from `account`.
1005      *
1006      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1007      *
1008      * Requirements:
1009      *
1010      * - the caller must have ``role``'s admin role.
1011      */
1012     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1013         _revokeRole(role, account);
1014     }
1015 
1016     /**
1017      * @dev Revokes `role` from the calling account.
1018      *
1019      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1020      * purpose is to provide a mechanism for accounts to lose their privileges
1021      * if they are compromised (such as when a trusted device is misplaced).
1022      *
1023      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1024      * event.
1025      *
1026      * Requirements:
1027      *
1028      * - the caller must be `account`.
1029      */
1030     function renounceRole(bytes32 role, address account) public virtual override {
1031         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1032 
1033         _revokeRole(role, account);
1034     }
1035 
1036     /**
1037      * @dev Grants `role` to `account`.
1038      *
1039      * If `account` had not been already granted `role`, emits a {RoleGranted}
1040      * event. Note that unlike {grantRole}, this function doesn't perform any
1041      * checks on the calling account.
1042      *
1043      * [WARNING]
1044      * ====
1045      * This function should only be called from the constructor when setting
1046      * up the initial roles for the system.
1047      *
1048      * Using this function in any other way is effectively circumventing the admin
1049      * system imposed by {AccessControl}.
1050      * ====
1051      *
1052      * NOTE: This function is deprecated in favor of {_grantRole}.
1053      */
1054     function _setupRole(bytes32 role, address account) internal virtual {
1055         _grantRole(role, account);
1056     }
1057 
1058     /**
1059      * @dev Sets `adminRole` as ``role``'s admin role.
1060      *
1061      * Emits a {RoleAdminChanged} event.
1062      */
1063     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1064         bytes32 previousAdminRole = getRoleAdmin(role);
1065         _roles[role].adminRole = adminRole;
1066         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1067     }
1068 
1069     /**
1070      * @dev Grants `role` to `account`.
1071      *
1072      * Internal function without access restriction.
1073      */
1074     function _grantRole(bytes32 role, address account) internal virtual {
1075         if (!hasRole(role, account)) {
1076             _roles[role].members[account] = true;
1077             emit RoleGranted(role, account, _msgSender());
1078         }
1079     }
1080 
1081     /**
1082      * @dev Revokes `role` from `account`.
1083      *
1084      * Internal function without access restriction.
1085      */
1086     function _revokeRole(bytes32 role, address account) internal virtual {
1087         if (hasRole(role, account)) {
1088             _roles[role].members[account] = false;
1089             emit RoleRevoked(role, account, _msgSender());
1090         }
1091     }
1092 }
1093 
1094 
1095 // File contracts/Staking/Owned.sol
1096 
1097 
1098 // https://docs.synthetix.io/contracts/Owned
1099 contract Owned {
1100     address public owner;
1101     address public nominatedOwner;
1102 
1103     constructor (address _owner) public {
1104         require(_owner != address(0), "Owner address cannot be 0");
1105         owner = _owner;
1106         emit OwnerChanged(address(0), _owner);
1107     }
1108 
1109     function nominateNewOwner(address _owner) external onlyOwner {
1110         nominatedOwner = _owner;
1111         emit OwnerNominated(_owner);
1112     }
1113 
1114     function acceptOwnership() external {
1115         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
1116         emit OwnerChanged(owner, nominatedOwner);
1117         owner = nominatedOwner;
1118         nominatedOwner = address(0);
1119     }
1120 
1121     modifier onlyOwner {
1122         require(msg.sender == owner, "Only the contract owner may perform this action");
1123         _;
1124     }
1125 
1126     event OwnerNominated(address newOwner);
1127     event OwnerChanged(address oldOwner, address newOwner);
1128 }
1129 
1130 
1131 // File contracts/ERC20/ERC20PermissionedMint.sol
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 contract ERC20PermissionedMint is ERC20, ERC20Burnable, Owned {
1140 
1141     // Core
1142     address public timelock_address;
1143 
1144     // Minters
1145     address[] public minters_array; // Allowed to mint
1146     mapping(address => bool) public minters; // Mapping is also used for faster verification
1147 
1148     /* ========== CONSTRUCTOR ========== */
1149 
1150     constructor(
1151         address _creator_address,
1152         address _timelock_address,
1153         string memory _name,
1154         string memory _symbol
1155     ) 
1156     ERC20(_name, _symbol) 
1157     Owned(_creator_address)
1158     {
1159       timelock_address = _timelock_address;
1160     }
1161 
1162 
1163     /* ========== MODIFIERS ========== */
1164 
1165     modifier onlyByOwnGov() {
1166         require(msg.sender == timelock_address || msg.sender == owner, "Not owner or timelock");
1167         _;
1168     }
1169 
1170     modifier onlyMinters() {
1171        require(minters[msg.sender] == true, "Only minters");
1172         _;
1173     } 
1174 
1175     /* ========== RESTRICTED FUNCTIONS ========== */
1176 
1177     // Used by minters when user redeems
1178     function minter_burn_from(address b_address, uint256 b_amount) public onlyMinters {
1179         super.burnFrom(b_address, b_amount);
1180         emit TokenMinterBurned(b_address, msg.sender, b_amount);
1181     }
1182 
1183     // This function is what other minters will call to mint new tokens 
1184     function minter_mint(address m_address, uint256 m_amount) public onlyMinters {
1185         super._mint(m_address, m_amount);
1186         emit TokenMinterMinted(msg.sender, m_address, m_amount);
1187     }
1188 
1189     // Adds whitelisted minters 
1190     function addMinter(address minter_address) public onlyByOwnGov {
1191         require(minter_address != address(0), "Zero address detected");
1192 
1193         require(minters[minter_address] == false, "Address already exists");
1194         minters[minter_address] = true; 
1195         minters_array.push(minter_address);
1196 
1197         emit MinterAdded(minter_address);
1198     }
1199 
1200     // Remove a minter 
1201     function removeMinter(address minter_address) public onlyByOwnGov {
1202         require(minter_address != address(0), "Zero address detected");
1203         require(minters[minter_address] == true, "Address nonexistant");
1204         
1205         // Delete from the mapping
1206         delete minters[minter_address];
1207 
1208         // 'Delete' from the array by setting the address to 0x0
1209         for (uint i = 0; i < minters_array.length; i++){ 
1210             if (minters_array[i] == minter_address) {
1211                 minters_array[i] = address(0); // This will leave a null in the array and keep the indices the same
1212                 break;
1213             }
1214         }
1215 
1216         emit MinterRemoved(minter_address);
1217     }
1218 
1219     /* ========== EVENTS ========== */
1220     
1221     event TokenMinterBurned(address indexed from, address indexed to, uint256 amount);
1222     event TokenMinterMinted(address indexed from, address indexed to, uint256 amount);
1223     event MinterAdded(address minter_address);
1224     event MinterRemoved(address minter_address);
1225 }
1226 
1227 
1228 // File contracts/FPI/FPIS.sol
1229 
1230 
1231 // ====================================================================
1232 // |     ______                   _______                             |
1233 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1234 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1235 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1236 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1237 // |                                                                  |
1238 // ====================================================================
1239 // =============================== FPIS ===============================
1240 // ====================================================================
1241 // Frax Price Index Share
1242 // FPI Utility Token
1243 
1244 // Frax Finance: https://github.com/FraxFinance
1245 
1246 // Primary Author(s)
1247 // Travis Moore: https://github.com/FortisFortuna
1248 // Jack Corddry: https://github.com/corddry
1249 
1250 // Reviewer(s) / Contributor(s)
1251 // Sam Kazemian: https://github.com/samkazemian
1252 // Rich Gee: https://github.com/zer0blockchain
1253 // Dennis: https://github.com/denett
1254 contract FPIS is ERC20PermissionedMint {
1255 
1256     // Core
1257     ERC20PermissionedMint public FPI_TKN;
1258 
1259     /* ========== CONSTRUCTOR ========== */
1260 
1261     constructor(
1262       address _creator_address,
1263       address _timelock_address,
1264       address _fpi_address
1265     ) 
1266     ERC20PermissionedMint(_creator_address, _timelock_address, "Frax Price Index Share", "FPIS") 
1267     {
1268       FPI_TKN = ERC20PermissionedMint(_fpi_address);
1269       
1270       _mint(_creator_address, 100000000e18); // Genesis mint
1271     }
1272 
1273 
1274     /* ========== RESTRICTED FUNCTIONS ========== */
1275 
1276     function setFPIAddress(address fpi_contract_address) external onlyByOwnGov {
1277         require(fpi_contract_address != address(0), "Zero address detected");
1278 
1279         FPI_TKN = ERC20PermissionedMint(fpi_contract_address);
1280 
1281         emit FPIAddressSet(fpi_contract_address);
1282     }
1283 
1284     /* ========== EVENTS ========== */
1285     event FPIAddressSet(address addr);
1286 }