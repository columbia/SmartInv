1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.9.3 https://hardhat.org
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
1228 // File contracts/FPI/FPI.sol
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
1239 // ================================ FPI ===============================
1240 // ====================================================================
1241 // Frax Price Index
1242 // Initial peg target is the US CPI-U (Consumer Price Index, All Urban Consumers)
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
1254 contract FPI is ERC20PermissionedMint {
1255 
1256     /* ========== CONSTRUCTOR ========== */
1257 
1258     constructor(
1259       address _creator_address,
1260       address _timelock_address
1261     ) 
1262     ERC20PermissionedMint(_creator_address, _timelock_address, "Frax Price Index", "FPI") 
1263     {
1264       _mint(_creator_address, 100000000e18); // Genesis mint
1265     }
1266 
1267 }
1268 
1269 
1270 // File contracts/Frax/IFrax.sol
1271 
1272 
1273 interface IFrax {
1274   function COLLATERAL_RATIO_PAUSER() external view returns (bytes32);
1275   function DEFAULT_ADMIN_ADDRESS() external view returns (address);
1276   function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
1277   function addPool(address pool_address ) external;
1278   function allowance(address owner, address spender ) external view returns (uint256);
1279   function approve(address spender, uint256 amount ) external returns (bool);
1280   function balanceOf(address account ) external view returns (uint256);
1281   function burn(uint256 amount ) external;
1282   function burnFrom(address account, uint256 amount ) external;
1283   function collateral_ratio_paused() external view returns (bool);
1284   function controller_address() external view returns (address);
1285   function creator_address() external view returns (address);
1286   function decimals() external view returns (uint8);
1287   function decreaseAllowance(address spender, uint256 subtractedValue ) external returns (bool);
1288   function eth_usd_consumer_address() external view returns (address);
1289   function eth_usd_price() external view returns (uint256);
1290   function frax_eth_oracle_address() external view returns (address);
1291   function frax_info() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256);
1292   function frax_pools(address ) external view returns (bool);
1293   function frax_pools_array(uint256 ) external view returns (address);
1294   function frax_price() external view returns (uint256);
1295   function frax_step() external view returns (uint256);
1296   function fxs_address() external view returns (address);
1297   function fxs_eth_oracle_address() external view returns (address);
1298   function fxs_price() external view returns (uint256);
1299   function genesis_supply() external view returns (uint256);
1300   function getRoleAdmin(bytes32 role ) external view returns (bytes32);
1301   function getRoleMember(bytes32 role, uint256 index ) external view returns (address);
1302   function getRoleMemberCount(bytes32 role ) external view returns (uint256);
1303   function globalCollateralValue() external view returns (uint256);
1304   function global_collateral_ratio() external view returns (uint256);
1305   function grantRole(bytes32 role, address account ) external;
1306   function hasRole(bytes32 role, address account ) external view returns (bool);
1307   function increaseAllowance(address spender, uint256 addedValue ) external returns (bool);
1308   function last_call_time() external view returns (uint256);
1309   function minting_fee() external view returns (uint256);
1310   function name() external view returns (string memory);
1311   function owner_address() external view returns (address);
1312   function pool_burn_from(address b_address, uint256 b_amount ) external;
1313   function pool_mint(address m_address, uint256 m_amount ) external;
1314   function price_band() external view returns (uint256);
1315   function price_target() external view returns (uint256);
1316   function redemption_fee() external view returns (uint256);
1317   function refreshCollateralRatio() external;
1318   function refresh_cooldown() external view returns (uint256);
1319   function removePool(address pool_address ) external;
1320   function renounceRole(bytes32 role, address account ) external;
1321   function revokeRole(bytes32 role, address account ) external;
1322   function setController(address _controller_address ) external;
1323   function setETHUSDOracle(address _eth_usd_consumer_address ) external;
1324   function setFRAXEthOracle(address _frax_oracle_addr, address _weth_address ) external;
1325   function setFXSAddress(address _fxs_address ) external;
1326   function setFXSEthOracle(address _fxs_oracle_addr, address _weth_address ) external;
1327   function setFraxStep(uint256 _new_step ) external;
1328   function setMintingFee(uint256 min_fee ) external;
1329   function setOwner(address _owner_address ) external;
1330   function setPriceBand(uint256 _price_band ) external;
1331   function setPriceTarget(uint256 _new_price_target ) external;
1332   function setRedemptionFee(uint256 red_fee ) external;
1333   function setRefreshCooldown(uint256 _new_cooldown ) external;
1334   function setTimelock(address new_timelock ) external;
1335   function symbol() external view returns (string memory);
1336   function timelock_address() external view returns (address);
1337   function toggleCollateralRatio() external;
1338   function totalSupply() external view returns (uint256);
1339   function transfer(address recipient, uint256 amount ) external returns (bool);
1340   function transferFrom(address sender, address recipient, uint256 amount ) external returns (bool);
1341   function weth_address() external view returns (address);
1342 }
1343 
1344 
1345 // File contracts/Frax/IFraxAMOMinter.sol
1346 
1347 
1348 // MAY need to be updated
1349 interface IFraxAMOMinter {
1350   function FRAX() external view returns(address);
1351   function FXS() external view returns(address);
1352   function acceptOwnership() external;
1353   function addAMO(address amo_address, bool sync_too) external;
1354   function allAMOAddresses() external view returns(address[] memory);
1355   function allAMOsLength() external view returns(uint256);
1356   function amos(address) external view returns(bool);
1357   function amos_array(uint256) external view returns(address);
1358   function burnFraxFromAMO(uint256 frax_amount) external;
1359   function burnFxsFromAMO(uint256 fxs_amount) external;
1360   function col_idx() external view returns(uint256);
1361   function collatDollarBalance() external view returns(uint256);
1362   function collatDollarBalanceStored() external view returns(uint256);
1363   function collat_borrow_cap() external view returns(int256);
1364   function collat_borrowed_balances(address) external view returns(int256);
1365   function collat_borrowed_sum() external view returns(int256);
1366   function collateral_address() external view returns(address);
1367   function collateral_token() external view returns(address);
1368   function correction_offsets_amos(address, uint256) external view returns(int256);
1369   function custodian_address() external view returns(address);
1370   function dollarBalances() external view returns(uint256 frax_val_e18, uint256 collat_val_e18);
1371   // function execute(address _to, uint256 _value, bytes _data) external returns(bool, bytes);
1372   function fraxDollarBalanceStored() external view returns(uint256);
1373   function fraxTrackedAMO(address amo_address) external view returns(int256);
1374   function fraxTrackedGlobal() external view returns(int256);
1375   function frax_mint_balances(address) external view returns(int256);
1376   function frax_mint_cap() external view returns(int256);
1377   function frax_mint_sum() external view returns(int256);
1378   function fxs_mint_balances(address) external view returns(int256);
1379   function fxs_mint_cap() external view returns(int256);
1380   function fxs_mint_sum() external view returns(int256);
1381   function giveCollatToAMO(address destination_amo, uint256 collat_amount) external;
1382   function min_cr() external view returns(uint256);
1383   function mintFraxForAMO(address destination_amo, uint256 frax_amount) external;
1384   function mintFxsForAMO(address destination_amo, uint256 fxs_amount) external;
1385   function missing_decimals() external view returns(uint256);
1386   function nominateNewOwner(address _owner) external;
1387   function nominatedOwner() external view returns(address);
1388   function oldPoolCollectAndGive(address destination_amo) external;
1389   function oldPoolRedeem(uint256 frax_amount) external;
1390   function old_pool() external view returns(address);
1391   function owner() external view returns(address);
1392   function pool() external view returns(address);
1393   function receiveCollatFromAMO(uint256 usdc_amount) external;
1394   function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
1395   function removeAMO(address amo_address, bool sync_too) external;
1396   function setAMOCorrectionOffsets(address amo_address, int256 frax_e18_correction, int256 collat_e18_correction) external;
1397   function setCollatBorrowCap(uint256 _collat_borrow_cap) external;
1398   function setCustodian(address _custodian_address) external;
1399   function setFraxMintCap(uint256 _frax_mint_cap) external;
1400   function setFraxPool(address _pool_address) external;
1401   function setFxsMintCap(uint256 _fxs_mint_cap) external;
1402   function setMinimumCollateralRatio(uint256 _min_cr) external;
1403   function setTimelock(address new_timelock) external;
1404   function syncDollarBalances() external;
1405   function timelock_address() external view returns(address);
1406 }
1407 
1408 
1409 // File contracts/Oracle/AggregatorV3Interface.sol
1410 
1411 
1412 interface AggregatorV3Interface {
1413 
1414   function decimals() external view returns (uint8);
1415   function description() external view returns (string memory);
1416   function version() external view returns (uint256);
1417 
1418   // getRoundData and latestRoundData should both raise "No data present"
1419   // if they do not have data to report, instead of returning unset values
1420   // which could be misinterpreted as actual reported values.
1421   function getRoundData(uint80 _roundId)
1422     external
1423     view
1424     returns (
1425       uint80 roundId,
1426       int256 answer,
1427       uint256 startedAt,
1428       uint256 updatedAt,
1429       uint80 answeredInRound
1430     );
1431   function latestRoundData()
1432     external
1433     view
1434     returns (
1435       uint80 roundId,
1436       int256 answer,
1437       uint256 startedAt,
1438       uint256 updatedAt,
1439       uint80 answeredInRound
1440     );
1441 
1442 }
1443 
1444 
1445 // File @chainlink/contracts/src/v0.8/vendor/BufferChainlink.sol@v0.4.0
1446 
1447 
1448 /**
1449  * @dev A library for working with mutable byte buffers in Solidity.
1450  *
1451  * Byte buffers are mutable and expandable, and provide a variety of primitives
1452  * for writing to them. At any time you can fetch a bytes object containing the
1453  * current contents of the buffer. The bytes object should not be stored between
1454  * operations, as it may change due to resizing of the buffer.
1455  */
1456 library BufferChainlink {
1457   /**
1458    * @dev Represents a mutable buffer. Buffers have a current value (buf) and
1459    *      a capacity. The capacity may be longer than the current value, in
1460    *      which case it can be extended without the need to allocate more memory.
1461    */
1462   struct buffer {
1463     bytes buf;
1464     uint256 capacity;
1465   }
1466 
1467   /**
1468    * @dev Initializes a buffer with an initial capacity.
1469    * @param buf The buffer to initialize.
1470    * @param capacity The number of bytes of space to allocate the buffer.
1471    * @return The buffer, for chaining.
1472    */
1473   function init(buffer memory buf, uint256 capacity) internal pure returns (buffer memory) {
1474     if (capacity % 32 != 0) {
1475       capacity += 32 - (capacity % 32);
1476     }
1477     // Allocate space for the buffer data
1478     buf.capacity = capacity;
1479     assembly {
1480       let ptr := mload(0x40)
1481       mstore(buf, ptr)
1482       mstore(ptr, 0)
1483       mstore(0x40, add(32, add(ptr, capacity)))
1484     }
1485     return buf;
1486   }
1487 
1488   /**
1489    * @dev Initializes a new buffer from an existing bytes object.
1490    *      Changes to the buffer may mutate the original value.
1491    * @param b The bytes object to initialize the buffer with.
1492    * @return A new buffer.
1493    */
1494   function fromBytes(bytes memory b) internal pure returns (buffer memory) {
1495     buffer memory buf;
1496     buf.buf = b;
1497     buf.capacity = b.length;
1498     return buf;
1499   }
1500 
1501   function resize(buffer memory buf, uint256 capacity) private pure {
1502     bytes memory oldbuf = buf.buf;
1503     init(buf, capacity);
1504     append(buf, oldbuf);
1505   }
1506 
1507   function max(uint256 a, uint256 b) private pure returns (uint256) {
1508     if (a > b) {
1509       return a;
1510     }
1511     return b;
1512   }
1513 
1514   /**
1515    * @dev Sets buffer length to 0.
1516    * @param buf The buffer to truncate.
1517    * @return The original buffer, for chaining..
1518    */
1519   function truncate(buffer memory buf) internal pure returns (buffer memory) {
1520     assembly {
1521       let bufptr := mload(buf)
1522       mstore(bufptr, 0)
1523     }
1524     return buf;
1525   }
1526 
1527   /**
1528    * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
1529    *      the capacity of the buffer.
1530    * @param buf The buffer to append to.
1531    * @param off The start offset to write to.
1532    * @param data The data to append.
1533    * @param len The number of bytes to copy.
1534    * @return The original buffer, for chaining.
1535    */
1536   function write(
1537     buffer memory buf,
1538     uint256 off,
1539     bytes memory data,
1540     uint256 len
1541   ) internal pure returns (buffer memory) {
1542     require(len <= data.length);
1543 
1544     if (off + len > buf.capacity) {
1545       resize(buf, max(buf.capacity, len + off) * 2);
1546     }
1547 
1548     uint256 dest;
1549     uint256 src;
1550     assembly {
1551       // Memory address of the buffer data
1552       let bufptr := mload(buf)
1553       // Length of existing buffer data
1554       let buflen := mload(bufptr)
1555       // Start address = buffer address + offset + sizeof(buffer length)
1556       dest := add(add(bufptr, 32), off)
1557       // Update buffer length if we're extending it
1558       if gt(add(len, off), buflen) {
1559         mstore(bufptr, add(len, off))
1560       }
1561       src := add(data, 32)
1562     }
1563 
1564     // Copy word-length chunks while possible
1565     for (; len >= 32; len -= 32) {
1566       assembly {
1567         mstore(dest, mload(src))
1568       }
1569       dest += 32;
1570       src += 32;
1571     }
1572 
1573     // Copy remaining bytes
1574     unchecked {
1575       uint256 mask = (256**(32 - len)) - 1;
1576       assembly {
1577         let srcpart := and(mload(src), not(mask))
1578         let destpart := and(mload(dest), mask)
1579         mstore(dest, or(destpart, srcpart))
1580       }
1581     }
1582 
1583     return buf;
1584   }
1585 
1586   /**
1587    * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
1588    *      the capacity of the buffer.
1589    * @param buf The buffer to append to.
1590    * @param data The data to append.
1591    * @param len The number of bytes to copy.
1592    * @return The original buffer, for chaining.
1593    */
1594   function append(
1595     buffer memory buf,
1596     bytes memory data,
1597     uint256 len
1598   ) internal pure returns (buffer memory) {
1599     return write(buf, buf.buf.length, data, len);
1600   }
1601 
1602   /**
1603    * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
1604    *      the capacity of the buffer.
1605    * @param buf The buffer to append to.
1606    * @param data The data to append.
1607    * @return The original buffer, for chaining.
1608    */
1609   function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
1610     return write(buf, buf.buf.length, data, data.length);
1611   }
1612 
1613   /**
1614    * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
1615    *      capacity of the buffer.
1616    * @param buf The buffer to append to.
1617    * @param off The offset to write the byte at.
1618    * @param data The data to append.
1619    * @return The original buffer, for chaining.
1620    */
1621   function writeUint8(
1622     buffer memory buf,
1623     uint256 off,
1624     uint8 data
1625   ) internal pure returns (buffer memory) {
1626     if (off >= buf.capacity) {
1627       resize(buf, buf.capacity * 2);
1628     }
1629 
1630     assembly {
1631       // Memory address of the buffer data
1632       let bufptr := mload(buf)
1633       // Length of existing buffer data
1634       let buflen := mload(bufptr)
1635       // Address = buffer address + sizeof(buffer length) + off
1636       let dest := add(add(bufptr, off), 32)
1637       mstore8(dest, data)
1638       // Update buffer length if we extended it
1639       if eq(off, buflen) {
1640         mstore(bufptr, add(buflen, 1))
1641       }
1642     }
1643     return buf;
1644   }
1645 
1646   /**
1647    * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
1648    *      capacity of the buffer.
1649    * @param buf The buffer to append to.
1650    * @param data The data to append.
1651    * @return The original buffer, for chaining.
1652    */
1653   function appendUint8(buffer memory buf, uint8 data) internal pure returns (buffer memory) {
1654     return writeUint8(buf, buf.buf.length, data);
1655   }
1656 
1657   /**
1658    * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
1659    *      exceed the capacity of the buffer.
1660    * @param buf The buffer to append to.
1661    * @param off The offset to write at.
1662    * @param data The data to append.
1663    * @param len The number of bytes to write (left-aligned).
1664    * @return The original buffer, for chaining.
1665    */
1666   function write(
1667     buffer memory buf,
1668     uint256 off,
1669     bytes32 data,
1670     uint256 len
1671   ) private pure returns (buffer memory) {
1672     if (len + off > buf.capacity) {
1673       resize(buf, (len + off) * 2);
1674     }
1675 
1676     unchecked {
1677       uint256 mask = (256**len) - 1;
1678       // Right-align data
1679       data = data >> (8 * (32 - len));
1680       assembly {
1681         // Memory address of the buffer data
1682         let bufptr := mload(buf)
1683         // Address = buffer address + sizeof(buffer length) + off + len
1684         let dest := add(add(bufptr, off), len)
1685         mstore(dest, or(and(mload(dest), not(mask)), data))
1686         // Update buffer length if we extended it
1687         if gt(add(off, len), mload(bufptr)) {
1688           mstore(bufptr, add(off, len))
1689         }
1690       }
1691     }
1692     return buf;
1693   }
1694 
1695   /**
1696    * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
1697    *      capacity of the buffer.
1698    * @param buf The buffer to append to.
1699    * @param off The offset to write at.
1700    * @param data The data to append.
1701    * @return The original buffer, for chaining.
1702    */
1703   function writeBytes20(
1704     buffer memory buf,
1705     uint256 off,
1706     bytes20 data
1707   ) internal pure returns (buffer memory) {
1708     return write(buf, off, bytes32(data), 20);
1709   }
1710 
1711   /**
1712    * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
1713    *      the capacity of the buffer.
1714    * @param buf The buffer to append to.
1715    * @param data The data to append.
1716    * @return The original buffer, for chhaining.
1717    */
1718   function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
1719     return write(buf, buf.buf.length, bytes32(data), 20);
1720   }
1721 
1722   /**
1723    * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
1724    *      the capacity of the buffer.
1725    * @param buf The buffer to append to.
1726    * @param data The data to append.
1727    * @return The original buffer, for chaining.
1728    */
1729   function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
1730     return write(buf, buf.buf.length, data, 32);
1731   }
1732 
1733   /**
1734    * @dev Writes an integer to the buffer. Resizes if doing so would exceed
1735    *      the capacity of the buffer.
1736    * @param buf The buffer to append to.
1737    * @param off The offset to write at.
1738    * @param data The data to append.
1739    * @param len The number of bytes to write (right-aligned).
1740    * @return The original buffer, for chaining.
1741    */
1742   function writeInt(
1743     buffer memory buf,
1744     uint256 off,
1745     uint256 data,
1746     uint256 len
1747   ) private pure returns (buffer memory) {
1748     if (len + off > buf.capacity) {
1749       resize(buf, (len + off) * 2);
1750     }
1751 
1752     uint256 mask = (256**len) - 1;
1753     assembly {
1754       // Memory address of the buffer data
1755       let bufptr := mload(buf)
1756       // Address = buffer address + off + sizeof(buffer length) + len
1757       let dest := add(add(bufptr, off), len)
1758       mstore(dest, or(and(mload(dest), not(mask)), data))
1759       // Update buffer length if we extended it
1760       if gt(add(off, len), mload(bufptr)) {
1761         mstore(bufptr, add(off, len))
1762       }
1763     }
1764     return buf;
1765   }
1766 
1767   /**
1768    * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1769    * exceed the capacity of the buffer.
1770    * @param buf The buffer to append to.
1771    * @param data The data to append.
1772    * @return The original buffer.
1773    */
1774   function appendInt(
1775     buffer memory buf,
1776     uint256 data,
1777     uint256 len
1778   ) internal pure returns (buffer memory) {
1779     return writeInt(buf, buf.buf.length, data, len);
1780   }
1781 }
1782 
1783 
1784 // File @chainlink/contracts/src/v0.8/vendor/CBORChainlink.sol@v0.4.0
1785 
1786 
1787 library CBORChainlink {
1788   using BufferChainlink for BufferChainlink.buffer;
1789 
1790   uint8 private constant MAJOR_TYPE_INT = 0;
1791   uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1792   uint8 private constant MAJOR_TYPE_BYTES = 2;
1793   uint8 private constant MAJOR_TYPE_STRING = 3;
1794   uint8 private constant MAJOR_TYPE_ARRAY = 4;
1795   uint8 private constant MAJOR_TYPE_MAP = 5;
1796   uint8 private constant MAJOR_TYPE_TAG = 6;
1797   uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1798 
1799   uint8 private constant TAG_TYPE_BIGNUM = 2;
1800   uint8 private constant TAG_TYPE_NEGATIVE_BIGNUM = 3;
1801 
1802   function encodeFixedNumeric(BufferChainlink.buffer memory buf, uint8 major, uint64 value) private pure {
1803     if(value <= 23) {
1804       buf.appendUint8(uint8((major << 5) | value));
1805     } else if (value <= 0xFF) {
1806       buf.appendUint8(uint8((major << 5) | 24));
1807       buf.appendInt(value, 1);
1808     } else if (value <= 0xFFFF) {
1809       buf.appendUint8(uint8((major << 5) | 25));
1810       buf.appendInt(value, 2);
1811     } else if (value <= 0xFFFFFFFF) {
1812       buf.appendUint8(uint8((major << 5) | 26));
1813       buf.appendInt(value, 4);
1814     } else {
1815       buf.appendUint8(uint8((major << 5) | 27));
1816       buf.appendInt(value, 8);
1817     }
1818   }
1819 
1820   function encodeIndefiniteLengthType(BufferChainlink.buffer memory buf, uint8 major) private pure {
1821     buf.appendUint8(uint8((major << 5) | 31));
1822   }
1823 
1824   function encodeUInt(BufferChainlink.buffer memory buf, uint value) internal pure {
1825     if(value > 0xFFFFFFFFFFFFFFFF) {
1826       encodeBigNum(buf, value);
1827     } else {
1828       encodeFixedNumeric(buf, MAJOR_TYPE_INT, uint64(value));
1829     }
1830   }
1831 
1832   function encodeInt(BufferChainlink.buffer memory buf, int value) internal pure {
1833     if(value < -0x10000000000000000) {
1834       encodeSignedBigNum(buf, value);
1835     } else if(value > 0xFFFFFFFFFFFFFFFF) {
1836       encodeBigNum(buf, uint(value));
1837     } else if(value >= 0) {
1838       encodeFixedNumeric(buf, MAJOR_TYPE_INT, uint64(uint256(value)));
1839     } else {
1840       encodeFixedNumeric(buf, MAJOR_TYPE_NEGATIVE_INT, uint64(uint256(-1 - value)));
1841     }
1842   }
1843 
1844   function encodeBytes(BufferChainlink.buffer memory buf, bytes memory value) internal pure {
1845     encodeFixedNumeric(buf, MAJOR_TYPE_BYTES, uint64(value.length));
1846     buf.append(value);
1847   }
1848 
1849   function encodeBigNum(BufferChainlink.buffer memory buf, uint value) internal pure {
1850     buf.appendUint8(uint8((MAJOR_TYPE_TAG << 5) | TAG_TYPE_BIGNUM));
1851     encodeBytes(buf, abi.encode(value));
1852   }
1853 
1854   function encodeSignedBigNum(BufferChainlink.buffer memory buf, int input) internal pure {
1855     buf.appendUint8(uint8((MAJOR_TYPE_TAG << 5) | TAG_TYPE_NEGATIVE_BIGNUM));
1856     encodeBytes(buf, abi.encode(uint256(-1 - input)));
1857   }
1858 
1859   function encodeString(BufferChainlink.buffer memory buf, string memory value) internal pure {
1860     encodeFixedNumeric(buf, MAJOR_TYPE_STRING, uint64(bytes(value).length));
1861     buf.append(bytes(value));
1862   }
1863 
1864   function startArray(BufferChainlink.buffer memory buf) internal pure {
1865     encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1866   }
1867 
1868   function startMap(BufferChainlink.buffer memory buf) internal pure {
1869     encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1870   }
1871 
1872   function endSequence(BufferChainlink.buffer memory buf) internal pure {
1873     encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1874   }
1875 }
1876 
1877 
1878 // File @chainlink/contracts/src/v0.8/Chainlink.sol@v0.4.0
1879 
1880 
1881 
1882 /**
1883  * @title Library for common Chainlink functions
1884  * @dev Uses imported CBOR library for encoding to buffer
1885  */
1886 library Chainlink {
1887   uint256 internal constant defaultBufferSize = 256; // solhint-disable-line const-name-snakecase
1888 
1889   using CBORChainlink for BufferChainlink.buffer;
1890 
1891   struct Request {
1892     bytes32 id;
1893     address callbackAddress;
1894     bytes4 callbackFunctionId;
1895     uint256 nonce;
1896     BufferChainlink.buffer buf;
1897   }
1898 
1899   /**
1900    * @notice Initializes a Chainlink request
1901    * @dev Sets the ID, callback address, and callback function signature on the request
1902    * @param self The uninitialized request
1903    * @param jobId The Job Specification ID
1904    * @param callbackAddr The callback address
1905    * @param callbackFunc The callback function signature
1906    * @return The initialized request
1907    */
1908   function initialize(
1909     Request memory self,
1910     bytes32 jobId,
1911     address callbackAddr,
1912     bytes4 callbackFunc
1913   ) internal pure returns (Chainlink.Request memory) {
1914     BufferChainlink.init(self.buf, defaultBufferSize);
1915     self.id = jobId;
1916     self.callbackAddress = callbackAddr;
1917     self.callbackFunctionId = callbackFunc;
1918     return self;
1919   }
1920 
1921   /**
1922    * @notice Sets the data for the buffer without encoding CBOR on-chain
1923    * @dev CBOR can be closed with curly-brackets {} or they can be left off
1924    * @param self The initialized request
1925    * @param data The CBOR data
1926    */
1927   function setBuffer(Request memory self, bytes memory data) internal pure {
1928     BufferChainlink.init(self.buf, data.length);
1929     BufferChainlink.append(self.buf, data);
1930   }
1931 
1932   /**
1933    * @notice Adds a string value to the request with a given key name
1934    * @param self The initialized request
1935    * @param key The name of the key
1936    * @param value The string value to add
1937    */
1938   function add(
1939     Request memory self,
1940     string memory key,
1941     string memory value
1942   ) internal pure {
1943     self.buf.encodeString(key);
1944     self.buf.encodeString(value);
1945   }
1946 
1947   /**
1948    * @notice Adds a bytes value to the request with a given key name
1949    * @param self The initialized request
1950    * @param key The name of the key
1951    * @param value The bytes value to add
1952    */
1953   function addBytes(
1954     Request memory self,
1955     string memory key,
1956     bytes memory value
1957   ) internal pure {
1958     self.buf.encodeString(key);
1959     self.buf.encodeBytes(value);
1960   }
1961 
1962   /**
1963    * @notice Adds a int256 value to the request with a given key name
1964    * @param self The initialized request
1965    * @param key The name of the key
1966    * @param value The int256 value to add
1967    */
1968   function addInt(
1969     Request memory self,
1970     string memory key,
1971     int256 value
1972   ) internal pure {
1973     self.buf.encodeString(key);
1974     self.buf.encodeInt(value);
1975   }
1976 
1977   /**
1978    * @notice Adds a uint256 value to the request with a given key name
1979    * @param self The initialized request
1980    * @param key The name of the key
1981    * @param value The uint256 value to add
1982    */
1983   function addUint(
1984     Request memory self,
1985     string memory key,
1986     uint256 value
1987   ) internal pure {
1988     self.buf.encodeString(key);
1989     self.buf.encodeUInt(value);
1990   }
1991 
1992   /**
1993    * @notice Adds an array of strings to the request with a given key name
1994    * @param self The initialized request
1995    * @param key The name of the key
1996    * @param values The array of string values to add
1997    */
1998   function addStringArray(
1999     Request memory self,
2000     string memory key,
2001     string[] memory values
2002   ) internal pure {
2003     self.buf.encodeString(key);
2004     self.buf.startArray();
2005     for (uint256 i = 0; i < values.length; i++) {
2006       self.buf.encodeString(values[i]);
2007     }
2008     self.buf.endSequence();
2009   }
2010 }
2011 
2012 
2013 // File @chainlink/contracts/src/v0.8/interfaces/ENSInterface.sol@v0.4.0
2014 
2015 
2016 interface ENSInterface {
2017   // Logged when the owner of a node assigns a new owner to a subnode.
2018   event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2019 
2020   // Logged when the owner of a node transfers ownership to a new account.
2021   event Transfer(bytes32 indexed node, address owner);
2022 
2023   // Logged when the resolver for a node changes.
2024   event NewResolver(bytes32 indexed node, address resolver);
2025 
2026   // Logged when the TTL of a node changes
2027   event NewTTL(bytes32 indexed node, uint64 ttl);
2028 
2029   function setSubnodeOwner(
2030     bytes32 node,
2031     bytes32 label,
2032     address owner
2033   ) external;
2034 
2035   function setResolver(bytes32 node, address resolver) external;
2036 
2037   function setOwner(bytes32 node, address owner) external;
2038 
2039   function setTTL(bytes32 node, uint64 ttl) external;
2040 
2041   function owner(bytes32 node) external view returns (address);
2042 
2043   function resolver(bytes32 node) external view returns (address);
2044 
2045   function ttl(bytes32 node) external view returns (uint64);
2046 }
2047 
2048 
2049 // File @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol@v0.4.0
2050 
2051 
2052 interface LinkTokenInterface {
2053   function allowance(address owner, address spender) external view returns (uint256 remaining);
2054 
2055   function approve(address spender, uint256 value) external returns (bool success);
2056 
2057   function balanceOf(address owner) external view returns (uint256 balance);
2058 
2059   function decimals() external view returns (uint8 decimalPlaces);
2060 
2061   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
2062 
2063   function increaseApproval(address spender, uint256 subtractedValue) external;
2064 
2065   function name() external view returns (string memory tokenName);
2066 
2067   function symbol() external view returns (string memory tokenSymbol);
2068 
2069   function totalSupply() external view returns (uint256 totalTokensIssued);
2070 
2071   function transfer(address to, uint256 value) external returns (bool success);
2072 
2073   function transferAndCall(
2074     address to,
2075     uint256 value,
2076     bytes calldata data
2077   ) external returns (bool success);
2078 
2079   function transferFrom(
2080     address from,
2081     address to,
2082     uint256 value
2083   ) external returns (bool success);
2084 }
2085 
2086 
2087 // File @chainlink/contracts/src/v0.8/interfaces/ChainlinkRequestInterface.sol@v0.4.0
2088 
2089 
2090 interface ChainlinkRequestInterface {
2091   function oracleRequest(
2092     address sender,
2093     uint256 requestPrice,
2094     bytes32 serviceAgreementID,
2095     address callbackAddress,
2096     bytes4 callbackFunctionId,
2097     uint256 nonce,
2098     uint256 dataVersion,
2099     bytes calldata data
2100   ) external;
2101 
2102   function cancelOracleRequest(
2103     bytes32 requestId,
2104     uint256 payment,
2105     bytes4 callbackFunctionId,
2106     uint256 expiration
2107   ) external;
2108 }
2109 
2110 
2111 // File @chainlink/contracts/src/v0.8/interfaces/OracleInterface.sol@v0.4.0
2112 
2113 
2114 interface OracleInterface {
2115   function fulfillOracleRequest(
2116     bytes32 requestId,
2117     uint256 payment,
2118     address callbackAddress,
2119     bytes4 callbackFunctionId,
2120     uint256 expiration,
2121     bytes32 data
2122   ) external returns (bool);
2123 
2124   function isAuthorizedSender(address node) external view returns (bool);
2125 
2126   function withdraw(address recipient, uint256 amount) external;
2127 
2128   function withdrawable() external view returns (uint256);
2129 }
2130 
2131 
2132 // File @chainlink/contracts/src/v0.8/interfaces/OperatorInterface.sol@v0.4.0
2133 
2134 
2135 
2136 interface OperatorInterface is OracleInterface, ChainlinkRequestInterface {
2137   function operatorRequest(
2138     address sender,
2139     uint256 payment,
2140     bytes32 specId,
2141     bytes4 callbackFunctionId,
2142     uint256 nonce,
2143     uint256 dataVersion,
2144     bytes calldata data
2145   ) external;
2146 
2147   function fulfillOracleRequest2(
2148     bytes32 requestId,
2149     uint256 payment,
2150     address callbackAddress,
2151     bytes4 callbackFunctionId,
2152     uint256 expiration,
2153     bytes calldata data
2154   ) external returns (bool);
2155 
2156   function ownerTransferAndCall(
2157     address to,
2158     uint256 value,
2159     bytes calldata data
2160   ) external returns (bool success);
2161 
2162   function distributeFunds(address payable[] calldata receivers, uint256[] calldata amounts) external payable;
2163 
2164   function getAuthorizedSenders() external returns (address[] memory);
2165 
2166   function setAuthorizedSenders(address[] calldata senders) external;
2167 
2168   function getForwarder() external returns (address);
2169 }
2170 
2171 
2172 // File @chainlink/contracts/src/v0.8/interfaces/PointerInterface.sol@v0.4.0
2173 
2174 
2175 interface PointerInterface {
2176   function getAddress() external view returns (address);
2177 }
2178 
2179 
2180 // File @chainlink/contracts/src/v0.8/vendor/ENSResolver.sol@v0.4.0
2181 
2182 
2183 abstract contract ENSResolver_Chainlink {
2184   function addr(bytes32 node) public view virtual returns (address);
2185 }
2186 
2187 
2188 // File @chainlink/contracts/src/v0.8/ChainlinkClient.sol@v0.4.0
2189 
2190 
2191 
2192 
2193 
2194 
2195 
2196 
2197 /**
2198  * @title The ChainlinkClient contract
2199  * @notice Contract writers can inherit this contract in order to create requests for the
2200  * Chainlink network
2201  */
2202 abstract contract ChainlinkClient {
2203   using Chainlink for Chainlink.Request;
2204 
2205   uint256 internal constant LINK_DIVISIBILITY = 10**18;
2206   uint256 private constant AMOUNT_OVERRIDE = 0;
2207   address private constant SENDER_OVERRIDE = address(0);
2208   uint256 private constant ORACLE_ARGS_VERSION = 1;
2209   uint256 private constant OPERATOR_ARGS_VERSION = 2;
2210   bytes32 private constant ENS_TOKEN_SUBNAME = keccak256("link");
2211   bytes32 private constant ENS_ORACLE_SUBNAME = keccak256("oracle");
2212   address private constant LINK_TOKEN_POINTER = 0xC89bD4E1632D3A43CB03AAAd5262cbe4038Bc571;
2213 
2214   ENSInterface private s_ens;
2215   bytes32 private s_ensNode;
2216   LinkTokenInterface private s_link;
2217   OperatorInterface private s_oracle;
2218   uint256 private s_requestCount = 1;
2219   mapping(bytes32 => address) private s_pendingRequests;
2220 
2221   event ChainlinkRequested(bytes32 indexed id);
2222   event ChainlinkFulfilled(bytes32 indexed id);
2223   event ChainlinkCancelled(bytes32 indexed id);
2224 
2225   /**
2226    * @notice Creates a request that can hold additional parameters
2227    * @param specId The Job Specification ID that the request will be created for
2228    * @param callbackAddr address to operate the callback on
2229    * @param callbackFunctionSignature function signature to use for the callback
2230    * @return A Chainlink Request struct in memory
2231    */
2232   function buildChainlinkRequest(
2233     bytes32 specId,
2234     address callbackAddr,
2235     bytes4 callbackFunctionSignature
2236   ) internal pure returns (Chainlink.Request memory) {
2237     Chainlink.Request memory req;
2238     return req.initialize(specId, callbackAddr, callbackFunctionSignature);
2239   }
2240 
2241   /**
2242    * @notice Creates a request that can hold additional parameters
2243    * @param specId The Job Specification ID that the request will be created for
2244    * @param callbackFunctionSignature function signature to use for the callback
2245    * @return A Chainlink Request struct in memory
2246    */
2247   function buildOperatorRequest(bytes32 specId, bytes4 callbackFunctionSignature)
2248     internal
2249     view
2250     returns (Chainlink.Request memory)
2251   {
2252     Chainlink.Request memory req;
2253     return req.initialize(specId, address(this), callbackFunctionSignature);
2254   }
2255 
2256   /**
2257    * @notice Creates a Chainlink request to the stored oracle address
2258    * @dev Calls `chainlinkRequestTo` with the stored oracle address
2259    * @param req The initialized Chainlink Request
2260    * @param payment The amount of LINK to send for the request
2261    * @return requestId The request ID
2262    */
2263   function sendChainlinkRequest(Chainlink.Request memory req, uint256 payment) internal returns (bytes32) {
2264     return sendChainlinkRequestTo(address(s_oracle), req, payment);
2265   }
2266 
2267   /**
2268    * @notice Creates a Chainlink request to the specified oracle address
2269    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
2270    * send LINK which creates a request on the target oracle contract.
2271    * Emits ChainlinkRequested event.
2272    * @param oracleAddress The address of the oracle for the request
2273    * @param req The initialized Chainlink Request
2274    * @param payment The amount of LINK to send for the request
2275    * @return requestId The request ID
2276    */
2277   function sendChainlinkRequestTo(
2278     address oracleAddress,
2279     Chainlink.Request memory req,
2280     uint256 payment
2281   ) internal returns (bytes32 requestId) {
2282     uint256 nonce = s_requestCount;
2283     s_requestCount = nonce + 1;
2284     bytes memory encodedRequest = abi.encodeWithSelector(
2285       ChainlinkRequestInterface.oracleRequest.selector,
2286       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
2287       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
2288       req.id,
2289       address(this),
2290       req.callbackFunctionId,
2291       nonce,
2292       ORACLE_ARGS_VERSION,
2293       req.buf.buf
2294     );
2295     return _rawRequest(oracleAddress, nonce, payment, encodedRequest);
2296   }
2297 
2298   /**
2299    * @notice Creates a Chainlink request to the stored oracle address
2300    * @dev This function supports multi-word response
2301    * @dev Calls `sendOperatorRequestTo` with the stored oracle address
2302    * @param req The initialized Chainlink Request
2303    * @param payment The amount of LINK to send for the request
2304    * @return requestId The request ID
2305    */
2306   function sendOperatorRequest(Chainlink.Request memory req, uint256 payment) internal returns (bytes32) {
2307     return sendOperatorRequestTo(address(s_oracle), req, payment);
2308   }
2309 
2310   /**
2311    * @notice Creates a Chainlink request to the specified oracle address
2312    * @dev This function supports multi-word response
2313    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
2314    * send LINK which creates a request on the target oracle contract.
2315    * Emits ChainlinkRequested event.
2316    * @param oracleAddress The address of the oracle for the request
2317    * @param req The initialized Chainlink Request
2318    * @param payment The amount of LINK to send for the request
2319    * @return requestId The request ID
2320    */
2321   function sendOperatorRequestTo(
2322     address oracleAddress,
2323     Chainlink.Request memory req,
2324     uint256 payment
2325   ) internal returns (bytes32 requestId) {
2326     uint256 nonce = s_requestCount;
2327     s_requestCount = nonce + 1;
2328     bytes memory encodedRequest = abi.encodeWithSelector(
2329       OperatorInterface.operatorRequest.selector,
2330       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
2331       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
2332       req.id,
2333       req.callbackFunctionId,
2334       nonce,
2335       OPERATOR_ARGS_VERSION,
2336       req.buf.buf
2337     );
2338     return _rawRequest(oracleAddress, nonce, payment, encodedRequest);
2339   }
2340 
2341   /**
2342    * @notice Make a request to an oracle
2343    * @param oracleAddress The address of the oracle for the request
2344    * @param nonce used to generate the request ID
2345    * @param payment The amount of LINK to send for the request
2346    * @param encodedRequest data encoded for request type specific format
2347    * @return requestId The request ID
2348    */
2349   function _rawRequest(
2350     address oracleAddress,
2351     uint256 nonce,
2352     uint256 payment,
2353     bytes memory encodedRequest
2354   ) private returns (bytes32 requestId) {
2355     requestId = keccak256(abi.encodePacked(this, nonce));
2356     s_pendingRequests[requestId] = oracleAddress;
2357     emit ChainlinkRequested(requestId);
2358     require(s_link.transferAndCall(oracleAddress, payment, encodedRequest), "unable to transferAndCall to oracle");
2359   }
2360 
2361   /**
2362    * @notice Allows a request to be cancelled if it has not been fulfilled
2363    * @dev Requires keeping track of the expiration value emitted from the oracle contract.
2364    * Deletes the request from the `pendingRequests` mapping.
2365    * Emits ChainlinkCancelled event.
2366    * @param requestId The request ID
2367    * @param payment The amount of LINK sent for the request
2368    * @param callbackFunc The callback function specified for the request
2369    * @param expiration The time of the expiration for the request
2370    */
2371   function cancelChainlinkRequest(
2372     bytes32 requestId,
2373     uint256 payment,
2374     bytes4 callbackFunc,
2375     uint256 expiration
2376   ) internal {
2377     OperatorInterface requested = OperatorInterface(s_pendingRequests[requestId]);
2378     delete s_pendingRequests[requestId];
2379     emit ChainlinkCancelled(requestId);
2380     requested.cancelOracleRequest(requestId, payment, callbackFunc, expiration);
2381   }
2382 
2383   /**
2384    * @notice the next request count to be used in generating a nonce
2385    * @dev starts at 1 in order to ensure consistent gas cost
2386    * @return returns the next request count to be used in a nonce
2387    */
2388   function getNextRequestCount() internal view returns (uint256) {
2389     return s_requestCount;
2390   }
2391 
2392   /**
2393    * @notice Sets the stored oracle address
2394    * @param oracleAddress The address of the oracle contract
2395    */
2396   function setChainlinkOracle(address oracleAddress) internal {
2397     s_oracle = OperatorInterface(oracleAddress);
2398   }
2399 
2400   /**
2401    * @notice Sets the LINK token address
2402    * @param linkAddress The address of the LINK token contract
2403    */
2404   function setChainlinkToken(address linkAddress) internal {
2405     s_link = LinkTokenInterface(linkAddress);
2406   }
2407 
2408   /**
2409    * @notice Sets the Chainlink token address for the public
2410    * network as given by the Pointer contract
2411    */
2412   function setPublicChainlinkToken() internal {
2413     setChainlinkToken(PointerInterface(LINK_TOKEN_POINTER).getAddress());
2414   }
2415 
2416   /**
2417    * @notice Retrieves the stored address of the LINK token
2418    * @return The address of the LINK token
2419    */
2420   function chainlinkTokenAddress() internal view returns (address) {
2421     return address(s_link);
2422   }
2423 
2424   /**
2425    * @notice Retrieves the stored address of the oracle contract
2426    * @return The address of the oracle contract
2427    */
2428   function chainlinkOracleAddress() internal view returns (address) {
2429     return address(s_oracle);
2430   }
2431 
2432   /**
2433    * @notice Allows for a request which was created on another contract to be fulfilled
2434    * on this contract
2435    * @param oracleAddress The address of the oracle contract that will fulfill the request
2436    * @param requestId The request ID used for the response
2437    */
2438   function addChainlinkExternalRequest(address oracleAddress, bytes32 requestId) internal notPendingRequest(requestId) {
2439     s_pendingRequests[requestId] = oracleAddress;
2440   }
2441 
2442   /**
2443    * @notice Sets the stored oracle and LINK token contracts with the addresses resolved by ENS
2444    * @dev Accounts for subnodes having different resolvers
2445    * @param ensAddress The address of the ENS contract
2446    * @param node The ENS node hash
2447    */
2448   function useChainlinkWithENS(address ensAddress, bytes32 node) internal {
2449     s_ens = ENSInterface(ensAddress);
2450     s_ensNode = node;
2451     bytes32 linkSubnode = keccak256(abi.encodePacked(s_ensNode, ENS_TOKEN_SUBNAME));
2452     ENSResolver_Chainlink resolver = ENSResolver_Chainlink(s_ens.resolver(linkSubnode));
2453     setChainlinkToken(resolver.addr(linkSubnode));
2454     updateChainlinkOracleWithENS();
2455   }
2456 
2457   /**
2458    * @notice Sets the stored oracle contract with the address resolved by ENS
2459    * @dev This may be called on its own as long as `useChainlinkWithENS` has been called previously
2460    */
2461   function updateChainlinkOracleWithENS() internal {
2462     bytes32 oracleSubnode = keccak256(abi.encodePacked(s_ensNode, ENS_ORACLE_SUBNAME));
2463     ENSResolver_Chainlink resolver = ENSResolver_Chainlink(s_ens.resolver(oracleSubnode));
2464     setChainlinkOracle(resolver.addr(oracleSubnode));
2465   }
2466 
2467   /**
2468    * @notice Ensures that the fulfillment is valid for this contract
2469    * @dev Use if the contract developer prefers methods instead of modifiers for validation
2470    * @param requestId The request ID for fulfillment
2471    */
2472   function validateChainlinkCallback(bytes32 requestId)
2473     internal
2474     recordChainlinkFulfillment(requestId)
2475   // solhint-disable-next-line no-empty-blocks
2476   {
2477 
2478   }
2479 
2480   /**
2481    * @dev Reverts if the sender is not the oracle of the request.
2482    * Emits ChainlinkFulfilled event.
2483    * @param requestId The request ID for fulfillment
2484    */
2485   modifier recordChainlinkFulfillment(bytes32 requestId) {
2486     require(msg.sender == s_pendingRequests[requestId], "Source must be the oracle of the request");
2487     delete s_pendingRequests[requestId];
2488     emit ChainlinkFulfilled(requestId);
2489     _;
2490   }
2491 
2492   /**
2493    * @dev Reverts if the request is already pending
2494    * @param requestId The request ID for fulfillment
2495    */
2496   modifier notPendingRequest(bytes32 requestId) {
2497     require(s_pendingRequests[requestId] == address(0), "Request is already pending");
2498     _;
2499   }
2500 }
2501 
2502 
2503 // File contracts/Math/BokkyPooBahsDateTimeLibrary.sol
2504 
2505 
2506 // ----------------------------------------------------------------------------
2507 // BokkyPooBah's DateTime Library v1.01
2508 //
2509 // A gas-efficient Solidity date and time library
2510 //
2511 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
2512 //
2513 // Tested date range 1970/01/01 to 2345/12/31
2514 //
2515 // Conventions:
2516 // Unit      | Range         | Notes
2517 // :-------- |:-------------:|:-----
2518 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
2519 // year      | 1970 ... 2345 |
2520 // month     | 1 ... 12      |
2521 // day       | 1 ... 31      |
2522 // hour      | 0 ... 23      |
2523 // minute    | 0 ... 59      |
2524 // second    | 0 ... 59      |
2525 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
2526 //
2527 //
2528 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
2529 // ----------------------------------------------------------------------------
2530 
2531 library BokkyPooBahsDateTimeLibrary {
2532 
2533     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
2534     uint constant SECONDS_PER_HOUR = 60 * 60;
2535     uint constant SECONDS_PER_MINUTE = 60;
2536     int constant OFFSET19700101 = 2440588;
2537 
2538     uint constant DOW_MON = 1;
2539     uint constant DOW_TUE = 2;
2540     uint constant DOW_WED = 3;
2541     uint constant DOW_THU = 4;
2542     uint constant DOW_FRI = 5;
2543     uint constant DOW_SAT = 6;
2544     uint constant DOW_SUN = 7;
2545 
2546     // ------------------------------------------------------------------------
2547     // Calculate the number of days from 1970/01/01 to year/month/day using
2548     // the date conversion algorithm from
2549     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
2550     // and subtracting the offset 2440588 so that 1970/01/01 is day 0
2551     //
2552     // days = day
2553     //      - 32075
2554     //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
2555     //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
2556     //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
2557     //      - offset
2558     // ------------------------------------------------------------------------
2559     function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
2560         require(year >= 1970);
2561         int _year = int(year);
2562         int _month = int(month);
2563         int _day = int(day);
2564 
2565         int __days = _day
2566           - 32075
2567           + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
2568           + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
2569           - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
2570           - OFFSET19700101;
2571 
2572         _days = uint(__days);
2573     }
2574 
2575     // ------------------------------------------------------------------------
2576     // Calculate year/month/day from the number of days since 1970/01/01 using
2577     // the date conversion algorithm from
2578     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
2579     // and adding the offset 2440588 so that 1970/01/01 is day 0
2580     //
2581     // int L = days + 68569 + offset
2582     // int N = 4 * L / 146097
2583     // L = L - (146097 * N + 3) / 4
2584     // year = 4000 * (L + 1) / 1461001
2585     // L = L - 1461 * year / 4 + 31
2586     // month = 80 * L / 2447
2587     // dd = L - 2447 * month / 80
2588     // L = month / 11
2589     // month = month + 2 - 12 * L
2590     // year = 100 * (N - 49) + year + L
2591     // ------------------------------------------------------------------------
2592     function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
2593         int __days = int(_days);
2594 
2595         int L = __days + 68569 + OFFSET19700101;
2596         int N = 4 * L / 146097;
2597         L = L - (146097 * N + 3) / 4;
2598         int _year = 4000 * (L + 1) / 1461001;
2599         L = L - 1461 * _year / 4 + 31;
2600         int _month = 80 * L / 2447;
2601         int _day = L - 2447 * _month / 80;
2602         L = _month / 11;
2603         _month = _month + 2 - 12 * L;
2604         _year = 100 * (N - 49) + _year + L;
2605 
2606         year = uint(_year);
2607         month = uint(_month);
2608         day = uint(_day);
2609     }
2610 
2611     function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
2612         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
2613     }
2614     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
2615         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
2616     }
2617     function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
2618         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2619     }
2620     function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
2621         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2622         uint secs = timestamp % SECONDS_PER_DAY;
2623         hour = secs / SECONDS_PER_HOUR;
2624         secs = secs % SECONDS_PER_HOUR;
2625         minute = secs / SECONDS_PER_MINUTE;
2626         second = secs % SECONDS_PER_MINUTE;
2627     }
2628 
2629     function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
2630         if (year >= 1970 && month > 0 && month <= 12) {
2631             uint daysInMonth = _getDaysInMonth(year, month);
2632             if (day > 0 && day <= daysInMonth) {
2633                 valid = true;
2634             }
2635         }
2636     }
2637     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
2638         if (isValidDate(year, month, day)) {
2639             if (hour < 24 && minute < 60 && second < 60) {
2640                 valid = true;
2641             }
2642         }
2643     }
2644     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
2645         (uint year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
2646         leapYear = _isLeapYear(year);
2647     }
2648     function _isLeapYear(uint year) internal pure returns (bool leapYear) {
2649         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
2650     }
2651     function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
2652         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
2653     }
2654     function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
2655         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
2656     }
2657     function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
2658         (uint year, uint month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
2659         daysInMonth = _getDaysInMonth(year, month);
2660     }
2661     function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
2662         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
2663             daysInMonth = 31;
2664         } else if (month != 2) {
2665             daysInMonth = 30;
2666         } else {
2667             daysInMonth = _isLeapYear(year) ? 29 : 28;
2668         }
2669     }
2670     // 1 = Monday, 7 = Sunday
2671     function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
2672         uint _days = timestamp / SECONDS_PER_DAY;
2673         dayOfWeek = (_days + 3) % 7 + 1;
2674     }
2675 
2676     function getYear(uint timestamp) internal pure returns (uint year) {
2677         (year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
2678     }
2679     function getMonth(uint timestamp) internal pure returns (uint month) {
2680         (,month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
2681     }
2682     function getDay(uint timestamp) internal pure returns (uint day) {
2683         (,,day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2684     }
2685     function getHour(uint timestamp) internal pure returns (uint hour) {
2686         uint secs = timestamp % SECONDS_PER_DAY;
2687         hour = secs / SECONDS_PER_HOUR;
2688     }
2689     function getMinute(uint timestamp) internal pure returns (uint minute) {
2690         uint secs = timestamp % SECONDS_PER_HOUR;
2691         minute = secs / SECONDS_PER_MINUTE;
2692     }
2693     function getSecond(uint timestamp) internal pure returns (uint second) {
2694         second = timestamp % SECONDS_PER_MINUTE;
2695     }
2696 
2697     function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
2698         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2699         year += _years;
2700         uint daysInMonth = _getDaysInMonth(year, month);
2701         if (day > daysInMonth) {
2702             day = daysInMonth;
2703         }
2704         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
2705         require(newTimestamp >= timestamp);
2706     }
2707     function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
2708         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2709         month += _months;
2710         year += (month - 1) / 12;
2711         month = (month - 1) % 12 + 1;
2712         uint daysInMonth = _getDaysInMonth(year, month);
2713         if (day > daysInMonth) {
2714             day = daysInMonth;
2715         }
2716         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
2717         require(newTimestamp >= timestamp);
2718     }
2719     function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
2720         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
2721         require(newTimestamp >= timestamp);
2722     }
2723     function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
2724         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
2725         require(newTimestamp >= timestamp);
2726     }
2727     function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
2728         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
2729         require(newTimestamp >= timestamp);
2730     }
2731     function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
2732         newTimestamp = timestamp + _seconds;
2733         require(newTimestamp >= timestamp);
2734     }
2735 
2736     function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
2737         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2738         year -= _years;
2739         uint daysInMonth = _getDaysInMonth(year, month);
2740         if (day > daysInMonth) {
2741             day = daysInMonth;
2742         }
2743         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
2744         require(newTimestamp <= timestamp);
2745     }
2746     function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
2747         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
2748         uint yearMonth = year * 12 + (month - 1) - _months;
2749         year = yearMonth / 12;
2750         month = yearMonth % 12 + 1;
2751         uint daysInMonth = _getDaysInMonth(year, month);
2752         if (day > daysInMonth) {
2753             day = daysInMonth;
2754         }
2755         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
2756         require(newTimestamp <= timestamp);
2757     }
2758     function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
2759         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
2760         require(newTimestamp <= timestamp);
2761     }
2762     function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
2763         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
2764         require(newTimestamp <= timestamp);
2765     }
2766     function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
2767         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
2768         require(newTimestamp <= timestamp);
2769     }
2770     function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
2771         newTimestamp = timestamp - _seconds;
2772         require(newTimestamp <= timestamp);
2773     }
2774 
2775     function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
2776         require(fromTimestamp <= toTimestamp);
2777         (uint fromYear,,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
2778         (uint toYear,,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
2779         _years = toYear - fromYear;
2780     }
2781     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
2782         require(fromTimestamp <= toTimestamp);
2783         (uint fromYear, uint fromMonth,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
2784         (uint toYear, uint toMonth,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
2785         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
2786     }
2787     function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
2788         require(fromTimestamp <= toTimestamp);
2789         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
2790     }
2791     function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
2792         require(fromTimestamp <= toTimestamp);
2793         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
2794     }
2795     function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
2796         require(fromTimestamp <= toTimestamp);
2797         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
2798     }
2799     function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
2800         require(fromTimestamp <= toTimestamp);
2801         _seconds = toTimestamp - fromTimestamp;
2802     }
2803 }
2804 
2805 
2806 // File contracts/Math/BokkyPooBahsDateTimeContract.sol
2807 
2808 
2809 // ----------------------------------------------------------------------------
2810 // BokkyPooBah's DateTime Library v1.00 - Contract Instance
2811 //
2812 // A gas-efficient Solidity date and time library
2813 //
2814 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
2815 //
2816 // Tested date range 1970/01/01 to 2345/12/31
2817 //
2818 // Conventions:
2819 // Unit      | Range         | Notes
2820 // :-------- |:-------------:|:-----
2821 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
2822 // year      | 1970 ... 2345 |
2823 // month     | 1 ... 12      |
2824 // day       | 1 ... 31      |
2825 // hour      | 0 ... 23      |
2826 // minute    | 0 ... 59      |
2827 // second    | 0 ... 59      |
2828 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
2829 //
2830 //
2831 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018.
2832 //
2833 // GNU Lesser General Public License 3.0
2834 // https://www.gnu.org/licenses/lgpl-3.0.en.html
2835 // ----------------------------------------------------------------------------
2836 
2837 contract BokkyPooBahsDateTimeContract {
2838     uint public constant SECONDS_PER_DAY = 24 * 60 * 60;
2839     uint public constant SECONDS_PER_HOUR = 60 * 60;
2840     uint public constant SECONDS_PER_MINUTE = 60;
2841     int public constant OFFSET19700101 = 2440588;
2842 
2843     uint public constant DOW_MON = 1;
2844     uint public constant DOW_TUE = 2;
2845     uint public constant DOW_WED = 3;
2846     uint public constant DOW_THU = 4;
2847     uint public constant DOW_FRI = 5;
2848     uint public constant DOW_SAT = 6;
2849     uint public constant DOW_SUN = 7;
2850 
2851     function _now() public view returns (uint timestamp) {
2852         timestamp = block.timestamp;
2853     }
2854     function _nowDateTime() public view returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
2855         (year, month, day, hour, minute, second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(block.timestamp);
2856     }
2857     function _daysFromDate(uint year, uint month, uint day) public pure returns (uint _days) {
2858         return BokkyPooBahsDateTimeLibrary._daysFromDate(year, month, day);
2859     }
2860     function _daysToDate(uint _days) public pure returns (uint year, uint month, uint day) {
2861         return BokkyPooBahsDateTimeLibrary._daysToDate(_days);
2862     }
2863     function timestampFromDate(uint year, uint month, uint day) public pure returns (uint timestamp) {
2864         return BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, day);
2865     }
2866     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (uint timestamp) {
2867         return BokkyPooBahsDateTimeLibrary.timestampFromDateTime(year, month, day, hour, minute, second);
2868     }
2869     function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
2870         (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
2871     }
2872     function timestampToDateTime(uint timestamp) public pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
2873         (year, month, day, hour, minute, second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(timestamp);
2874     }
2875 
2876     function isValidDate(uint year, uint month, uint day) public pure returns (bool valid) {
2877         valid = BokkyPooBahsDateTimeLibrary.isValidDate(year, month, day);
2878     }
2879     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (bool valid) {
2880         valid = BokkyPooBahsDateTimeLibrary.isValidDateTime(year, month, day, hour, minute, second);
2881     }
2882     function isLeapYear(uint timestamp) public pure returns (bool leapYear) {
2883         leapYear = BokkyPooBahsDateTimeLibrary.isLeapYear(timestamp);
2884     }
2885     function _isLeapYear(uint year) public pure returns (bool leapYear) {
2886         leapYear = BokkyPooBahsDateTimeLibrary._isLeapYear(year);
2887     }
2888     function isWeekDay(uint timestamp) public pure returns (bool weekDay) {
2889         weekDay = BokkyPooBahsDateTimeLibrary.isWeekDay(timestamp);
2890     }
2891     function isWeekEnd(uint timestamp) public pure returns (bool weekEnd) {
2892         weekEnd = BokkyPooBahsDateTimeLibrary.isWeekEnd(timestamp);
2893     }
2894 
2895     function getDaysInMonth(uint timestamp) public pure returns (uint daysInMonth) {
2896         daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth(timestamp);
2897     }
2898     function _getDaysInMonth(uint year, uint month) public pure returns (uint daysInMonth) {
2899         daysInMonth = BokkyPooBahsDateTimeLibrary._getDaysInMonth(year, month);
2900     }
2901     function getDayOfWeek(uint timestamp) public pure returns (uint dayOfWeek) {
2902         dayOfWeek = BokkyPooBahsDateTimeLibrary.getDayOfWeek(timestamp);
2903     }
2904 
2905     function getYear(uint timestamp) public pure returns (uint year) {
2906         year = BokkyPooBahsDateTimeLibrary.getYear(timestamp);
2907     }
2908     function getMonth(uint timestamp) public pure returns (uint month) {
2909         month = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
2910     }
2911     function getDay(uint timestamp) public pure returns (uint day) {
2912         day = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
2913     }
2914     function getHour(uint timestamp) public pure returns (uint hour) {
2915         hour = BokkyPooBahsDateTimeLibrary.getHour(timestamp);
2916     }
2917     function getMinute(uint timestamp) public pure returns (uint minute) {
2918         minute = BokkyPooBahsDateTimeLibrary.getMinute(timestamp);
2919     }
2920     function getSecond(uint timestamp) public pure returns (uint second) {
2921         second = BokkyPooBahsDateTimeLibrary.getSecond(timestamp);
2922     }
2923 
2924     function addYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
2925         newTimestamp = BokkyPooBahsDateTimeLibrary.addYears(timestamp, _years);
2926     }
2927     function addMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
2928         newTimestamp = BokkyPooBahsDateTimeLibrary.addMonths(timestamp, _months);
2929     }
2930     function addDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
2931         newTimestamp = BokkyPooBahsDateTimeLibrary.addDays(timestamp, _days);
2932     }
2933     function addHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
2934         newTimestamp = BokkyPooBahsDateTimeLibrary.addHours(timestamp, _hours);
2935     }
2936     function addMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
2937         newTimestamp = BokkyPooBahsDateTimeLibrary.addMinutes(timestamp, _minutes);
2938     }
2939     function addSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
2940         newTimestamp = BokkyPooBahsDateTimeLibrary.addSeconds(timestamp, _seconds);
2941     }
2942 
2943     function subYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
2944         newTimestamp = BokkyPooBahsDateTimeLibrary.subYears(timestamp, _years);
2945     }
2946     function subMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
2947         newTimestamp = BokkyPooBahsDateTimeLibrary.subMonths(timestamp, _months);
2948     }
2949     function subDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
2950         newTimestamp = BokkyPooBahsDateTimeLibrary.subDays(timestamp, _days);
2951     }
2952     function subHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
2953         newTimestamp = BokkyPooBahsDateTimeLibrary.subHours(timestamp, _hours);
2954     }
2955     function subMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
2956         newTimestamp = BokkyPooBahsDateTimeLibrary.subMinutes(timestamp, _minutes);
2957     }
2958     function subSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
2959         newTimestamp = BokkyPooBahsDateTimeLibrary.subSeconds(timestamp, _seconds);
2960     }
2961 
2962     function diffYears(uint fromTimestamp, uint toTimestamp) public pure returns (uint _years) {
2963         _years = BokkyPooBahsDateTimeLibrary.diffYears(fromTimestamp, toTimestamp);
2964     }
2965     function diffMonths(uint fromTimestamp, uint toTimestamp) public pure returns (uint _months) {
2966         _months = BokkyPooBahsDateTimeLibrary.diffMonths(fromTimestamp, toTimestamp);
2967     }
2968     function diffDays(uint fromTimestamp, uint toTimestamp) public pure returns (uint _days) {
2969         _days = BokkyPooBahsDateTimeLibrary.diffDays(fromTimestamp, toTimestamp);
2970     }
2971     function diffHours(uint fromTimestamp, uint toTimestamp) public pure returns (uint _hours) {
2972         _hours = BokkyPooBahsDateTimeLibrary.diffHours(fromTimestamp, toTimestamp);
2973     }
2974     function diffMinutes(uint fromTimestamp, uint toTimestamp) public pure returns (uint _minutes) {
2975         _minutes = BokkyPooBahsDateTimeLibrary.diffMinutes(fromTimestamp, toTimestamp);
2976     }
2977     function diffSeconds(uint fromTimestamp, uint toTimestamp) public pure returns (uint _seconds) {
2978         _seconds = BokkyPooBahsDateTimeLibrary.diffSeconds(fromTimestamp, toTimestamp);
2979     }
2980 }
2981 
2982 
2983 // File contracts/Uniswap/TransferHelper.sol
2984 
2985 
2986 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
2987 library TransferHelper {
2988     function safeApprove(address token, address to, uint value) internal {
2989         // bytes4(keccak256(bytes('approve(address,uint256)')));
2990         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
2991         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
2992     }
2993 
2994     function safeTransfer(address token, address to, uint value) internal {
2995         // bytes4(keccak256(bytes('transfer(address,uint256)')));
2996         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
2997         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
2998     }
2999 
3000     function safeTransferFrom(address token, address from, address to, uint value) internal {
3001         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
3002         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
3003         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
3004     }
3005 
3006     function safeTransferETH(address to, uint value) internal {
3007         (bool success,) = to.call{value:value}(new bytes(0));
3008         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
3009     }
3010 }
3011 
3012 
3013 // File contracts/Oracle/CPITrackerOracle.sol
3014 
3015 
3016 // ====================================================================
3017 // |     ______                   _______                             |
3018 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
3019 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
3020 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
3021 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
3022 // |                                                                  |
3023 // ====================================================================
3024 // ========================= CPITrackerOracle =========================
3025 // ====================================================================
3026 // Pull in CPI data and track it in Dec 2021 dollars
3027 
3028 // Frax Finance: https://github.com/FraxFinance
3029 
3030 // Primary Author(s)
3031 // Travis Moore: https://github.com/FortisFortuna
3032 
3033 // Reviewer(s) / Contributor(s)
3034 // Sam Kazemian: https://github.com/samkazemian
3035 // Rich Gee: https://github.com/zer0blockchain
3036 // Dennis: https://github.com/denett
3037 
3038 // References
3039 // https://docs.chain.link/docs/make-a-http-get-request/#api-consumer-example
3040 
3041 
3042 
3043 
3044 
3045 
3046 contract CPITrackerOracle is Owned, ChainlinkClient {
3047     using Chainlink for Chainlink.Request;
3048   
3049     // Core
3050     BokkyPooBahsDateTimeContract public time_contract;
3051     address public timelock_address;
3052     address public bot_address;
3053 
3054     // Data
3055     uint256 public cpi_last = 28012600000; // Dec 2021 CPI-U, 280.126 * 100000000
3056     uint256 public cpi_target = 28193300000; // Jan 2022 CPI-U, 281.933 * 100000000
3057     uint256 public peg_price_last = 1e18; // Use currPegPrice(). Will always be in Dec 2021 dollars
3058     uint256 public peg_price_target = 1006450668627688968; // Will always be in Dec 2021 dollars
3059 
3060     // Chainlink
3061     address public oracle; // Chainlink CPI oracle address
3062     bytes32 public jobId; // Job ID for the CPI-U date
3063     uint256 public fee; // LINK token fee
3064 
3065     // Tracking
3066     uint256 public stored_year = 2022; // Last time (year) the stored CPI data was updated
3067     uint256 public stored_month = 1; // Last time (month) the stored CPI data was updated
3068     uint256 public lastUpdateTime = 1644886800; // Last time the stored CPI data was updated.
3069     uint256 public ramp_period = 28 * 86400; // Apply the CPI delta to the peg price over a set period
3070     uint256 public future_ramp_period = 28 * 86400;
3071     CPIObservation[] public cpi_observations; // Historical tracking of CPI data
3072 
3073     // Safety
3074     uint256 public max_delta_frac = 25000; // 2.5%. Max month-to-month CPI delta. 
3075 
3076     // Misc
3077     string[13] public month_names; // English names of the 12 months
3078     uint256 public fulfill_ready_day = 15; // Date of the month that CPI data is expected to by ready by
3079 
3080 
3081     /* ========== STRUCTS ========== */
3082     
3083     struct CPIObservation {
3084         uint256 result_year;
3085         uint256 result_month;
3086         uint256 cpi_target;
3087         uint256 peg_price_target;
3088         uint256 timestamp;
3089     }
3090 
3091     /* ========== MODIFIERS ========== */
3092 
3093     modifier onlyByOwnGov() {
3094         require(msg.sender == owner || msg.sender == timelock_address, "Not owner or timelock");
3095         _;
3096     }
3097 
3098     modifier onlyByOwnGovBot() {
3099         require(msg.sender == owner || msg.sender == timelock_address || msg.sender == bot_address, "Not owner, tlck, or bot");
3100         _;
3101     }
3102 
3103     /* ========== CONSTRUCTOR ========== */
3104 
3105     constructor (
3106         address _creator_address,
3107         address _timelock_address
3108     ) Owned(_creator_address) {
3109         timelock_address = _timelock_address;
3110 
3111         // Initialize the array. Cannot be done in the declaration
3112         month_names = [
3113             '',
3114             'January',
3115             'February',
3116             'March',
3117             'April',
3118             'May',
3119             'June',
3120             'July',
3121             'August',
3122             'September',
3123             'October',
3124             'November',
3125             'December'
3126         ];
3127 
3128         // CPI [Ethereum]
3129         // =================================
3130         // setPublicChainlinkToken();
3131         // time_contract = BokkyPooBahsDateTimeContract(0x90503D86E120B3B309CEBf00C2CA013aB3624736);
3132         // oracle = 0x049Bd8C3adC3fE7d3Fc2a44541d955A537c2A484;
3133         // jobId = "1c309d42c7084b34b1acf1a89e7b51fc";
3134         // fee = 50e18; // 50 LINK
3135 
3136         // CPI [Polygon Mainnet]
3137         // =================================
3138         // setChainlinkToken(0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39);
3139         // time_contract = BokkyPooBahsDateTimeContract(0x998da4fCB229Db1AA84395ef6f0c6be6Ef3dbE58);
3140         // oracle = 0x9B44870bcc35734c08e40F847cC068c0bA618194;
3141         // jobId = "8107f18343a24980b2fe7d3c8f32630f";
3142         // fee = 1e17; // 0.1 LINK
3143 
3144         // CPI [Polygon Mumbai]
3145         // =================================
3146         setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
3147         time_contract = BokkyPooBahsDateTimeContract(0x2Dd1B4D4548aCCeA497050619965f91f78b3b532);
3148         oracle = 0x3c30c5c415B2410326297F0f65f5Cbb32f3aefCc;
3149         jobId = "32c3e7b12fe44665a4e2bb87aa9779af";
3150         fee = 1e17; // 0.1 LINK
3151 
3152         // Add the first observation
3153         cpi_observations.push(CPIObservation(
3154             2021,
3155             12,
3156             cpi_last,
3157             peg_price_last,
3158             1642208400 // Dec data observed on Jan 15 2021
3159         ));
3160 
3161         // Add the second observation
3162         cpi_observations.push(CPIObservation(
3163             2022,
3164             1,
3165             cpi_target,
3166             peg_price_target,
3167             1644886800 // Jan data observed on Feb 15 2022
3168         ));
3169     }
3170 
3171     /* ========== VIEWS ========== */
3172     function upcomingCPIParams() public view returns (
3173         uint256 upcoming_year,
3174         uint256 upcoming_month, 
3175         uint256 upcoming_timestamp
3176     ) {
3177         if (stored_month == 12) {
3178             upcoming_year = stored_year + 1;
3179             upcoming_month = 1;
3180         }
3181         else {
3182             upcoming_year = stored_year;
3183             upcoming_month = stored_month + 1;
3184         }
3185 
3186         // Data is usually released by the 15th day of the next month (fulfill_ready_day)
3187         // https://www.usinflationcalculator.com/inflation/consumer-price-index-release-schedule/
3188         upcoming_timestamp = time_contract.timestampFromDate(upcoming_year, upcoming_month, fulfill_ready_day);
3189     }
3190 
3191     // Display the upcoming CPI month
3192     function upcomingSerie() external view returns (string memory serie_name) {
3193         // Get the upcoming CPI params
3194         (uint256 upcoming_year, uint256 upcoming_month, ) = upcomingCPIParams();
3195 
3196         // Convert to a string
3197         return string(abi.encodePacked("CUSR0000SA0", " ", month_names[upcoming_month], " ", Strings.toString(upcoming_year)));
3198     }
3199 
3200     // Delta between the current and previous peg prices
3201     function currDeltaFracE6() public view returns (int256) {
3202         return int256(((peg_price_target - peg_price_last) * 1e6) / peg_price_last);
3203     }
3204 
3205     // Absolute value of the delta between the current and previous peg prices
3206     function currDeltaFracAbsE6() public view returns (uint256) {
3207         int256 curr_delta_frac = currDeltaFracE6();
3208         if (curr_delta_frac > 0) return uint256(curr_delta_frac);
3209         else return uint256(-curr_delta_frac);
3210     }
3211 
3212     // Current peg price in E18, accounting for the ramping
3213     function currPegPrice() external view returns (uint256) {
3214         uint256 elapsed_time = block.timestamp - lastUpdateTime;
3215         if (elapsed_time >= ramp_period) {
3216             return peg_price_target;
3217         }
3218         else {
3219             // Calculate the fraction of the delta to use, based on the elapsed time
3220             // Can be negative in case of deflation (that never happens right :])
3221             int256 fractional_price_delta = (int256(peg_price_target - peg_price_last) * int256(elapsed_time)) / int256(ramp_period);
3222             return uint256(int256(peg_price_last) + int256(fractional_price_delta));
3223         }
3224     }
3225 
3226     /* ========== MUTATIVE ========== */
3227 
3228     // Fetch the CPI data from the Chainlink oracle
3229     function requestCPIData() external onlyByOwnGovBot returns (bytes32 requestId) 
3230     {
3231         Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
3232 
3233         // Get the upcoming CPI params
3234         (uint256 upcoming_year, uint256 upcoming_month, uint256 upcoming_timestamp) = upcomingCPIParams();
3235 
3236         // Don't update too fast
3237         require(block.timestamp >= upcoming_timestamp, "Too early");
3238 
3239         request.add("serie", "CUSR0000SA0"); // CPI-U: https://data.bls.gov/timeseries/CUSR0000SA0
3240         request.add("month", month_names[upcoming_month]);
3241         request.add("year", Strings.toString(upcoming_year)); 
3242         return sendChainlinkRequestTo(oracle, request, fee);
3243     }
3244 
3245     /**
3246      * Callback function
3247      */
3248     //  Called by the Chainlink oracle
3249     function fulfill(bytes32 _requestId, uint256 result) public recordChainlinkFulfillment(_requestId)
3250     {
3251         // Set the stored CPI and price to the old targets
3252         cpi_last = cpi_target;
3253         peg_price_last = peg_price_target;
3254 
3255         // Set the target CPI and price based on the results
3256         cpi_target = result;
3257         peg_price_target = (peg_price_last * cpi_target) / cpi_last;
3258 
3259         // Make sure the delta isn't too large
3260         require(currDeltaFracAbsE6() <= max_delta_frac, "Delta too high");
3261 
3262         // Update the timestamp
3263         lastUpdateTime = block.timestamp;
3264 
3265         // Update the year and month
3266         (uint256 result_year, uint256 result_month, ) = upcomingCPIParams();
3267         stored_year = result_year;
3268         stored_month = result_month;
3269 
3270         // Update the future ramp period, if applicable
3271         // A ramp cannot be updated mid-month as it will mess up the last_price math;
3272         ramp_period = future_ramp_period;
3273 
3274         // Add the observation
3275         cpi_observations.push(CPIObservation(
3276             result_year,
3277             result_month,
3278             cpi_target,
3279             peg_price_target,
3280             block.timestamp
3281         ));
3282 
3283         emit CPIUpdated(result_year, result_month, result, peg_price_target, ramp_period);
3284     }
3285 
3286     function cancelRequest(
3287         bytes32 _requestId,
3288         uint256 _payment,
3289         bytes4 _callbackFunc,
3290         uint256 _expiration
3291     ) external onlyByOwnGovBot {
3292         cancelChainlinkRequest(_requestId, _payment, _callbackFunc, _expiration);
3293     }
3294     
3295     /* ========== RESTRICTED FUNCTIONS ========== */
3296 
3297     function setTimelock(address _new_timelock_address) external onlyByOwnGov {
3298         timelock_address = _new_timelock_address;
3299     }
3300 
3301     function setBot(address _new_bot_address) external onlyByOwnGov {
3302         bot_address = _new_bot_address;
3303     }
3304 
3305     function setOracleInfo(address _oracle, bytes32 _jobId, uint256 _fee) external onlyByOwnGov {
3306         oracle = _oracle;
3307         jobId = _jobId;
3308         fee = _fee;
3309     }
3310 
3311     function setMaxDeltaFrac(uint256 _max_delta_frac) external onlyByOwnGov {
3312         max_delta_frac = _max_delta_frac; 
3313     }
3314 
3315     function setFulfillReadyDay(uint256 _fulfill_ready_day) external onlyByOwnGov {
3316         fulfill_ready_day = _fulfill_ready_day; 
3317     }
3318 
3319     function setFutureRampPeriod(uint256 _future_ramp_period) external onlyByOwnGov {
3320         future_ramp_period = _future_ramp_period; // In sec
3321     }
3322 
3323     // Mainly for recovering LINK
3324     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyByOwnGov {
3325         // Only the owner address can ever receive the recovery withdrawal
3326         TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
3327     }
3328 
3329     /* ========== EVENTS ========== */
3330     
3331     event CPIUpdated(uint256 year, uint256 month, uint256 result, uint256 peg_price_target, uint256 ramp_period);
3332 }
3333 
3334 
3335 // File contracts/Fraxswap/core/interfaces/IUniswapV2PairV5.sol
3336 
3337 
3338 interface IUniswapV2PairV5 {
3339     event Approval(address indexed owner, address indexed spender, uint value);
3340     event Transfer(address indexed from, address indexed to, uint value);
3341 
3342     function name() external pure returns (string memory);
3343     function symbol() external pure returns (string memory);
3344     function decimals() external pure returns (uint8);
3345     function totalSupply() external view returns (uint);
3346     function balanceOf(address owner) external view returns (uint);
3347     function allowance(address owner, address spender) external view returns (uint);
3348 
3349     function approve(address spender, uint value) external returns (bool);
3350     function transfer(address to, uint value) external returns (bool);
3351     function transferFrom(address from, address to, uint value) external returns (bool);
3352 
3353     function DOMAIN_SEPARATOR() external view returns (bytes32);
3354     function PERMIT_TYPEHASH() external pure returns (bytes32);
3355     function nonces(address owner) external view returns (uint);
3356 
3357     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
3358 
3359     event Mint(address indexed sender, uint amount0, uint amount1);
3360     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
3361     event Swap(
3362         address indexed sender,
3363         uint amount0In,
3364         uint amount1In,
3365         uint amount0Out,
3366         uint amount1Out,
3367         address indexed to
3368     );
3369     event Sync(uint112 reserve0, uint112 reserve1);
3370 
3371     function MINIMUM_LIQUIDITY() external pure returns (uint);
3372     function factory() external view returns (address);
3373     function token0() external view returns (address);
3374     function token1() external view returns (address);
3375     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
3376     function price0CumulativeLast() external view returns (uint);
3377     function price1CumulativeLast() external view returns (uint);
3378     function kLast() external view returns (uint);
3379 
3380     function mint(address to) external returns (uint liquidity);
3381     function burn(address to) external returns (uint amount0, uint amount1);
3382     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
3383     function skim(address to) external;
3384     function sync() external;
3385     function initialize(address, address) external;
3386 }
3387 
3388 
3389 // File contracts/Fraxswap/core/interfaces/IFraxswapPair.sol
3390 
3391 
3392 // ====================================================================
3393 // |     ______                   _______                             |
3394 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
3395 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
3396 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
3397 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
3398 // |                                                                  |
3399 // ====================================================================
3400 // ========================= IFraxswapPair ==========================
3401 // ====================================================================
3402 // Fraxswap LP Pair Interface
3403 // Inspired by https://www.paradigm.xyz/2021/07/twamm
3404 // https://github.com/para-dave/twamm
3405 
3406 // Frax Finance: https://github.com/FraxFinance
3407 
3408 // Primary Author(s)
3409 // Rich Gee: https://github.com/zer0blockchain
3410 // Dennis: https://github.com/denett
3411 
3412 // Reviewer(s) / Contributor(s)
3413 // Travis Moore: https://github.com/FortisFortuna
3414 // Sam Kazemian: https://github.com/samkazemian
3415 
3416 interface IFraxswapPair is IUniswapV2PairV5 {
3417     // TWAMM
3418 
3419     event LongTermSwap0To1(address indexed addr, uint256 orderId, uint256 amount0In, uint256 numberOfTimeIntervals);
3420     event LongTermSwap1To0(address indexed addr, uint256 orderId, uint256 amount1In, uint256 numberOfTimeIntervals);
3421     event CancelLongTermOrder(address indexed addr, uint256 orderId, address sellToken, uint256 unsoldAmount, address buyToken, uint256 purchasedAmount);
3422     event WithdrawProceedsFromLongTermOrder(address indexed addr, uint256 orderId, address indexed proceedToken, uint256 proceeds, bool orderExpired);
3423 
3424     function longTermSwapFrom0To1(uint256 amount0In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
3425     function longTermSwapFrom1To0(uint256 amount1In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
3426     function cancelLongTermSwap(uint256 orderId) external;
3427     function withdrawProceedsFromLongTermSwap(uint256 orderId) external returns (bool is_expired, address rewardTkn, uint256 totalReward);
3428     function executeVirtualOrders(uint256 blockTimestamp) external;
3429 
3430     function orderTimeInterval() external returns (uint256);
3431     function getTWAPHistoryLength() external view returns (uint);
3432     function getTwammReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast, uint112 _twammReserve0, uint112 _twammReserve1);
3433     function getReserveAfterTwamm(uint256 blockTimestamp) external view returns (uint112 _reserve0, uint112 _reserve1, uint256 lastVirtualOrderTimestamp, uint112 _twammReserve0, uint112 _twammReserve1);
3434     function getNextOrderID() external view returns (uint256);
3435     function getOrderIDsForUser(address user) external view returns (uint256[] memory);
3436     function getOrderIDsForUserLength(address user) external view returns (uint256);
3437 //    function getDetailedOrdersForUser(address user, uint256 offset, uint256 limit) external view returns (LongTermOrdersLib.Order[] memory detailed_orders);
3438     function twammUpToDate() external view returns (bool);
3439     function getTwammState() external view returns (uint256 token0Rate, uint256 token1Rate, uint256 lastVirtualOrderTimestamp, uint256 orderTimeInterval_rtn, uint256 rewardFactorPool0, uint256 rewardFactorPool1);
3440     function getTwammSalesRateEnding(uint256 _blockTimestamp) external view returns (uint256 orderPool0SalesRateEnding, uint256 orderPool1SalesRateEnding);
3441     function getTwammRewardFactor(uint256 _blockTimestamp) external view returns (uint256 rewardFactorPool0AtTimestamp, uint256 rewardFactorPool1AtTimestamp);
3442     function getTwammOrder(uint256 orderId) external view returns (uint256 id, uint256 expirationTimestamp, uint256 saleRate, address owner, address sellTokenAddr, address buyTokenAddr);
3443     function getTwammOrderProceedsView(uint256 orderId, uint256 blockTimestamp) external view returns (bool orderExpired, uint256 totalReward);
3444     function getTwammOrderProceeds(uint256 orderId) external returns (bool orderExpired, uint256 totalReward);
3445 
3446 
3447     function togglePauseNewSwaps() external;
3448 }
3449 
3450 
3451 // File contracts/Fraxswap/core/interfaces/IUniswapV2FactoryV5.sol
3452 
3453 
3454 interface IUniswapV2FactoryV5 {
3455     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
3456 
3457     function feeTo() external view returns (address);
3458     function feeToSetter() external view returns (address);
3459 
3460     function getPair(address tokenA, address tokenB) external view returns (address pair);
3461     function allPairs(uint) external view returns (address pair);
3462     function allPairsLength() external view returns (uint);
3463 
3464     function createPair(address tokenA, address tokenB) external returns (address pair);
3465 
3466     function setFeeTo(address) external;
3467     function setFeeToSetter(address) external;
3468 }
3469 
3470 
3471 // File contracts/Fraxswap/libraries/Babylonian.sol
3472 
3473 
3474 
3475 // computes square roots using the babylonian method
3476 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
3477 library Babylonian {
3478     // credit for this implementation goes to
3479     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
3480     function sqrt(uint256 x) internal pure returns (uint256) {
3481         if (x == 0) return 0;
3482         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
3483         // however that code costs significantly more gas
3484         uint256 xx = x;
3485         uint256 r = 1;
3486         if (xx >= 0x100000000000000000000000000000000) {
3487             xx >>= 128;
3488             r <<= 64;
3489         }
3490         if (xx >= 0x10000000000000000) {
3491             xx >>= 64;
3492             r <<= 32;
3493         }
3494         if (xx >= 0x100000000) {
3495             xx >>= 32;
3496             r <<= 16;
3497         }
3498         if (xx >= 0x10000) {
3499             xx >>= 16;
3500             r <<= 8;
3501         }
3502         if (xx >= 0x100) {
3503             xx >>= 8;
3504             r <<= 4;
3505         }
3506         if (xx >= 0x10) {
3507             xx >>= 4;
3508             r <<= 2;
3509         }
3510         if (xx >= 0x8) {
3511             r <<= 1;
3512         }
3513         r = (r + x / r) >> 1;
3514         r = (r + x / r) >> 1;
3515         r = (r + x / r) >> 1;
3516         r = (r + x / r) >> 1;
3517         r = (r + x / r) >> 1;
3518         r = (r + x / r) >> 1;
3519         r = (r + x / r) >> 1; // Seven iterations should be enough
3520         uint256 r1 = x / r;
3521         return (r < r1 ? r : r1);
3522     }
3523 }
3524 
3525 
3526 // File contracts/Fraxswap/libraries/FullMath.sol
3527 
3528 
3529 
3530 /// @notice Math library that facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision.
3531 /// @author Adapted from https://github.com/Uniswap/uniswap-v3-core/blob/main/contracts/libraries/FullMath.sol.
3532 /// @dev Handles "phantom overflow", i.e., allows multiplication and division where an intermediate value overflows 256 bits.
3533 library FullMath {
3534     /// @notice Calculates floor(a×b÷denominator) with full precision - throws if result overflows an uint256 or denominator == 0.
3535     /// @param a The multiplicand.
3536     /// @param b The multiplier.
3537     /// @param denominator The divisor.
3538     /// @return result The 256-bit result.
3539     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv.
3540     function mulDiv(
3541         uint256 a,
3542         uint256 b,
3543         uint256 denominator
3544     ) internal pure returns (uint256 result) {
3545     unchecked {
3546         // 512-bit multiply [prod1 prod0] = a * b.
3547         // Compute the product mod 2**256 and mod 2**256 - 1,
3548         // then use the Chinese Remainder Theorem to reconstruct
3549         // the 512 bit result. The result is stored in two 256
3550         // variables such that product = prod1 * 2**256 + prod0.
3551         uint256 prod0; // Least significant 256 bits of the product.
3552         uint256 prod1; // Most significant 256 bits of the product.
3553         assembly {
3554             let mm := mulmod(a, b, not(0))
3555             prod0 := mul(a, b)
3556             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
3557         }
3558         // Handle non-overflow cases, 256 by 256 division.
3559         if (prod1 == 0) {
3560             require(denominator > 0);
3561             assembly {
3562                 result := div(prod0, denominator)
3563             }
3564             return result;
3565         }
3566         // Make sure the result is less than 2**256 -
3567         // also prevents denominator == 0.
3568         require(denominator > prod1);
3569         ///////////////////////////////////////////////
3570         // 512 by 256 division.
3571         ///////////////////////////////////////////////
3572         // Make division exact by subtracting the remainder from [prod1 prod0] -
3573         // compute remainder using mulmod.
3574         uint256 remainder;
3575         assembly {
3576             remainder := mulmod(a, b, denominator)
3577         }
3578         // Subtract 256 bit number from 512 bit number.
3579         assembly {
3580             prod1 := sub(prod1, gt(remainder, prod0))
3581             prod0 := sub(prod0, remainder)
3582         }
3583         // Factor powers of two out of denominator -
3584         // compute largest power of two divisor of denominator
3585         // (always >= 1).
3586         uint256 twos = uint256(-int256(denominator)) & denominator;
3587         // Divide denominator by power of two.
3588         assembly {
3589             denominator := div(denominator, twos)
3590         }
3591         // Divide [prod1 prod0] by the factors of two.
3592         assembly {
3593             prod0 := div(prod0, twos)
3594         }
3595         // Shift in bits from prod1 into prod0. For this we need
3596         // to flip `twos` such that it is 2**256 / twos -
3597         // if twos is zero, then it becomes one.
3598         assembly {
3599             twos := add(div(sub(0, twos), twos), 1)
3600         }
3601         prod0 |= prod1 * twos;
3602         // Invert denominator mod 2**256 -
3603         // now that denominator is an odd number, it has an inverse
3604         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
3605         // Compute the inverse by starting with a seed that is correct
3606         // for four bits. That is, denominator * inv = 1 mod 2**4.
3607         uint256 inv = (3 * denominator) ^ 2;
3608         // Now use Newton-Raphson iteration to improve the precision.
3609         // Thanks to Hensel's lifting lemma, this also works in modular
3610         // arithmetic, doubling the correct bits in each step.
3611         inv *= 2 - denominator * inv; // Inverse mod 2**8.
3612         inv *= 2 - denominator * inv; // Inverse mod 2**16.
3613         inv *= 2 - denominator * inv; // Inverse mod 2**32.
3614         inv *= 2 - denominator * inv; // Inverse mod 2**64.
3615         inv *= 2 - denominator * inv; // Inverse mod 2**128.
3616         inv *= 2 - denominator * inv; // Inverse mod 2**256.
3617         // Because the division is now exact we can divide by multiplying
3618         // with the modular inverse of denominator. This will give us the
3619         // correct result modulo 2**256. Since the precoditions guarantee
3620         // that the outcome is less than 2**256, this is the final result.
3621         // We don't need to compute the high bits of the result and prod1
3622         // is no longer required.
3623         result = prod0 * inv;
3624         return result;
3625     }
3626     }
3627 
3628     /// @notice Calculates ceil(a×b÷denominator) with full precision - throws if result overflows an uint256 or denominator == 0.
3629     /// @param a The multiplicand.
3630     /// @param b The multiplier.
3631     /// @param denominator The divisor.
3632     /// @return result The 256-bit result.
3633     function mulDivRoundingUp(
3634         uint256 a,
3635         uint256 b,
3636         uint256 denominator
3637     ) internal pure returns (uint256 result) {
3638         result = mulDiv(a, b, denominator);
3639     unchecked {
3640         if (mulmod(a, b, denominator) != 0) {
3641             require(result < type(uint256).max);
3642             result++;
3643         }
3644     }
3645     }
3646 }
3647 
3648 
3649 // File contracts/Fraxswap/periphery/libraries/UniswapV2LiquidityMathLibraryMini.sol
3650 
3651 
3652 
3653 
3654 
3655 // library containing some math for dealing with the liquidity shares of a pair, e.g. computing their exact value
3656 // in terms of the underlying tokens
3657 library UniswapV2LiquidityMathLibraryMini {
3658 
3659     // computes the direction and magnitude of the profit-maximizing trade
3660     // function computeProfitMaximizingTrade(
3661     //     uint256 truePriceTokenA,
3662     //     uint256 truePriceTokenB,
3663     //     uint256 reserveA,
3664     //     uint256 reserveB
3665     // ) pure internal returns (uint256 amountIn) {
3666     //     bool aToB = ((reserveA * truePriceTokenB) / reserveB) < truePriceTokenA;
3667 
3668     //     uint256 invariant = reserveA * reserveB;
3669 
3670     //     // true price is expressed as a ratio, so both values must be non-zero
3671     //     require(truePriceTokenA != 0 && truePriceTokenB != 0, "CPMT: ZERO_PRICE");
3672 
3673     //     uint256 leftSide = Babylonian.sqrt(
3674     //         FullMath.mulDiv(
3675     //             (invariant * 1000),
3676     //             aToB ? truePriceTokenA : truePriceTokenB,
3677     //             (aToB ? truePriceTokenB : truePriceTokenA) * 997
3678     //         )
3679     //     );
3680     //     uint256 rightSide = (aToB ? reserveA * 1000 : reserveB * 1000) / 997;
3681 
3682     //     if (leftSide < rightSide) return (0);
3683 
3684     //     // compute the amount that must be sent to move the price to the profit-maximizing price
3685     //     amountIn = leftSide - rightSide;
3686     // }
3687 
3688     function computeProfitMaximizingTrade(
3689         uint256 inTokenTruePrice,
3690         uint256 outTokenTruePrice,
3691         uint256 reserveIn,
3692         uint256 reserveOut
3693     ) pure internal returns (uint256 amountIn) {
3694         uint256 invariant = reserveIn * reserveOut;
3695 
3696         // true price is expressed as a ratio, so both values must be non-zero
3697         require(inTokenTruePrice != 0 && outTokenTruePrice != 0, "CPMT: ZERO_PRICE");
3698 
3699         uint256 leftSide = Babylonian.sqrt(
3700             FullMath.mulDiv(
3701                 (invariant * 1000),
3702                 inTokenTruePrice,
3703                 outTokenTruePrice * 997
3704             )
3705         );
3706         uint256 rightSide = (reserveIn * 1000) / 997;
3707 
3708         if (leftSide < rightSide) return (0);
3709 
3710         // compute the amount that must be sent to move the price to the profit-maximizing price
3711         amountIn = leftSide - rightSide;
3712     }
3713 }
3714 
3715 
3716 // File contracts/FPI/FPIControllerPool.sol
3717 
3718 
3719 // ====================================================================
3720 // |     ______                   _______                             |
3721 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
3722 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
3723 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
3724 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
3725 // |                                                                  |
3726 // ====================================================================
3727 // ========================= FPIControllerPool =========================
3728 // ====================================================================
3729 // Makes sure FPI is targeting the CPI peg
3730 // First method is minting / redeeming with FRAX
3731 // Second is bulk TWAMM trades
3732 // Frax Finance: https://github.com/FraxFinance
3733 
3734 // Primary Author(s)
3735 // Travis Moore: https://github.com/FortisFortuna
3736 
3737 // Reviewer(s) / Contributor(s)
3738 // Sam Kazemian: https://github.com/samkazemian
3739 // Rich Gee: https://github.com/zer0blockchain
3740 // Dennis: https://github.com/denett
3741 // Jack Corddry: https://github.com/corddry
3742 
3743 
3744 
3745 
3746 
3747 
3748 
3749 
3750 contract FPIControllerPool is Owned {
3751 
3752     // Core
3753     address public timelock_address;
3754     FPI public FPI_TKN;
3755     IFrax public FRAX;
3756     IFraxswapPair public TWAMM;
3757 
3758     // Oracles
3759     AggregatorV3Interface public priceFeedFRAXUSD;
3760     AggregatorV3Interface public priceFeedFPIUSD;
3761     uint256 public chainlink_frax_usd_decimals;
3762     uint256 public chainlink_fpi_usd_decimals;
3763     CPITrackerOracle public cpiTracker;
3764 
3765     // Tracking
3766     uint256 public last_order_id_twamm; // Last TWAMM order ID that was used
3767 
3768    // AMO addresses (lend out FRAX)
3769     address[] public amos_array;
3770     mapping(address => bool) public amos; // Mapping is also used for faster verification
3771 
3772     // FRAX borrowed balances
3773     mapping(address => int256) public frax_borrowed_balances; // Amount of FRAX the contract borrowed, by AMO
3774     int256 public frax_borrowed_sum = 0; // Across all AMOs
3775     int256 public frax_borrow_cap = int256(10000000e18); // Max amount of FRAX the contract can borrow from this contract
3776 
3777     // Mint Fee Related
3778     bool public use_manual_mint_fee = true;
3779     uint256 public mint_fee_manual = 3000; // E6
3780     uint256 public mint_fee_multiplier = 1000000; // E6
3781     
3782     // Redeem Fee Related
3783     bool public use_manual_redeem_fee = true;
3784     uint256 public redeem_fee_manual = 3000; // E6
3785     uint256 public redeem_fee_multiplier = 1000000; // E6
3786     
3787     // Safety
3788     uint256 public fpi_mint_cap = 110000000e18; // 110M
3789     uint256 public peg_band_mint_redeem = 50000; // 5%
3790     uint256 public peg_band_twamm = 100000; // 10%
3791     uint256 public max_swap_frax_amt_in = 10000000e18; // 10M, mainly fat-finger precautions
3792     uint256 public max_swap_fpi_amt_in = 10000000e18; // 10M, mainly fat-finger precautions
3793     bool public mints_paused = false;
3794     bool public redeems_paused = false;
3795 
3796     // Constants for various precisions
3797     uint256 public constant PRICE_PRECISION = 1e18;
3798     uint256 public constant FEE_PRECISION = 1e6;
3799     uint256 public constant PEG_BAND_PRECISION = 1e6;
3800 
3801     // Misc
3802     bool public frax_is_token0;
3803     bool public pending_twamm_order = false;
3804     uint256 public num_twamm_intervals = 168; // Each interval is default 3600 sec (1 hr)
3805     uint256 public swap_period = 7 * 86400; // 7 days
3806 
3807     /* ========== MODIFIERS ========== */
3808 
3809     modifier onlyByOwnGov() {
3810         require(msg.sender == owner || msg.sender == timelock_address, "Not owner or timelock");
3811         _;
3812     }
3813 
3814     modifier validAMO(address amo_address) {
3815         require(amos[amo_address], "Invalid AMO");
3816         _;
3817     }
3818 
3819     /* ========== CONSTRUCTOR ========== */
3820 
3821     constructor (
3822         address _creator_address,
3823         address _timelock_address,
3824         address[6] memory _address_pack
3825     ) Owned(_creator_address) {
3826         timelock_address = _timelock_address;
3827 
3828         // Set instances
3829         FRAX = IFrax(_address_pack[0]);
3830         FPI_TKN = FPI(_address_pack[1]);
3831         TWAMM = IFraxswapPair(_address_pack[2]);
3832         priceFeedFRAXUSD = AggregatorV3Interface(_address_pack[3]);
3833         priceFeedFPIUSD = AggregatorV3Interface(_address_pack[4]);
3834         cpiTracker = CPITrackerOracle(_address_pack[5]);
3835 
3836         // Set the oracle decimals
3837         chainlink_frax_usd_decimals = priceFeedFRAXUSD.decimals();
3838         chainlink_fpi_usd_decimals = priceFeedFPIUSD.decimals();
3839 
3840         // Need to know which token FRAX is (0 or 1)
3841         address token0 = TWAMM.token0();
3842         if (token0 == address(FRAX)) frax_is_token0 = true;
3843         else frax_is_token0 = false;
3844 
3845         // Get the number of TWAMM intervals. Truncation desired
3846         num_twamm_intervals = swap_period / TWAMM.orderTimeInterval();
3847     }
3848 
3849 
3850     /* ========== VIEWS ========== */
3851 
3852     // Needed as a FRAX AMO
3853     function dollarBalances() public view returns (uint256 frax_val_e18, uint256 collat_val_e18) {
3854         // Dummy values here. FPI is not FRAX and should not be treated as FRAX collateral
3855         frax_val_e18 = 1e18;
3856         collat_val_e18 = 1e18;
3857     }
3858 
3859     // In Chainlink decimals
3860     function getFRAXPriceE18() public view returns (uint256) {
3861         (uint80 roundID, int price, , uint256 updatedAt, uint80 answeredInRound) = priceFeedFRAXUSD.latestRoundData();
3862         require(price >= 0 && updatedAt!= 0 && answeredInRound >= roundID, "Invalid chainlink price");
3863 
3864         return ((uint256(price) * 1e18) / (10 ** chainlink_frax_usd_decimals));
3865     }
3866 
3867     // In Chainlink decimals    
3868     function getFPIPriceE18() public view returns (uint256) {
3869         (uint80 roundID, int price, , uint256 updatedAt, uint80 answeredInRound) = priceFeedFPIUSD.latestRoundData();
3870         require(price >= 0 && updatedAt!= 0 && answeredInRound >= roundID, "Invalid chainlink price");
3871 
3872         return ((uint256(price) * 1e18) / (10 ** chainlink_fpi_usd_decimals));
3873     }
3874 
3875     // Reserve spot price (fpi_price is dangerous / flash loan susceptible, so use carefully)    
3876     function getReservesAndFPISpot() public returns (uint256 reserveFRAX, uint256 reserveFPI, uint256 fpi_price) {
3877         // Update and get the reserves
3878         TWAMM.executeVirtualOrders(block.timestamp);
3879         {
3880             (uint256 reserveA, uint256 reserveB, ) = TWAMM.getReserves();
3881             if (frax_is_token0){
3882                 reserveFRAX = reserveA;
3883                 reserveFPI = reserveB;
3884                 
3885             }
3886             else {
3887                 reserveFRAX = reserveB;
3888                 reserveFPI = reserveA;
3889             }
3890         }
3891 
3892         // Get the TWAMM reserve spot price
3893         fpi_price = (reserveFRAX * 1e18) / reserveFPI;
3894     }
3895 
3896     // function getTwammToPegAmt() public returns (uint256 frax_in, uint256 fpi_in) {
3897     //     // Update and get the reserves
3898     //     (uint256 reserveFRAX, uint256 reserveFPI, uint256 reservePriceFPI) = getReservesAndFPISpot();
3899         
3900     //     // Get the CPI price
3901     //     uint256 cpi_peg_price = cpiTracker.currPegPrice();
3902 
3903     //     // Sort the pricing. NOTE: IN RATIOS, NOT PRICE
3904     //     uint256 truePriceFRAX = 1e18;
3905     //     uint256 truePriceFPI = cpi_peg_price;
3906 
3907     //     // Determine the direction
3908     //     if (fpi_to_frax) {
3909     //         return UniswapV2LiquidityMathLibraryMini.computeProfitMaximizingTrade(
3910     //             truePriceFPI, truePriceFRAX,
3911     //             reserveFPI, reserveFRAX
3912     //         );
3913     //     }
3914     //     else {
3915     //         return UniswapV2LiquidityMathLibraryMini.computeProfitMaximizingTrade(
3916     //             truePriceFRAX, truePriceFPI,
3917     //             reserveFRAX, reserveFPI
3918     //         );
3919     //     }
3920     // }
3921 
3922     // In E6
3923     function mint_fee() public view returns (uint256 fee) {
3924         if (use_manual_mint_fee) fee = mint_fee_manual;
3925         else {
3926             // For future variable fees
3927             fee = 0;
3928 
3929             // Apply the multiplier
3930             fee = (fee * mint_fee_multiplier) / 1e6;
3931         }
3932     }
3933 
3934     // In E6
3935     function redeem_fee() public view returns (uint256 fee) {
3936         if (use_manual_redeem_fee) fee = redeem_fee_manual;
3937         else {
3938             // For future variable fees
3939             fee = 0;
3940 
3941             // Apply the multiplier
3942             fee = (fee * redeem_fee_multiplier) / 1e6;
3943         }
3944 
3945         
3946     }
3947 
3948     // Get some info about the peg status
3949     function pegStatusMntRdm() public view returns (uint256 cpi_peg_price, uint256 diff_frac_abs, bool within_range) {
3950         uint256 fpi_price = getFPIPriceE18();
3951         cpi_peg_price = cpiTracker.currPegPrice();
3952 
3953         if (fpi_price > cpi_peg_price){
3954             diff_frac_abs = ((fpi_price - cpi_peg_price) * PEG_BAND_PRECISION) / fpi_price;
3955         }
3956         else {
3957             diff_frac_abs = ((cpi_peg_price - fpi_price) * PEG_BAND_PRECISION) / fpi_price;
3958         }
3959 
3960         within_range = (diff_frac_abs <= peg_band_mint_redeem);
3961     }
3962 
3963     // Get additional info about the peg status
3964     function price_info() public view returns (
3965         int256 collat_imbalance, 
3966         uint256 cpi_peg_price,
3967         uint256 fpi_price,
3968         uint256 price_diff_frac_abs
3969     ) {
3970         fpi_price = getFPIPriceE18();
3971         cpi_peg_price = cpiTracker.currPegPrice();
3972         uint256 fpi_supply = FPI_TKN.totalSupply();
3973 
3974         if (fpi_price > cpi_peg_price){
3975             collat_imbalance = int256(((fpi_price - cpi_peg_price) * fpi_supply) / PRICE_PRECISION);
3976             price_diff_frac_abs = ((fpi_price - cpi_peg_price) * PEG_BAND_PRECISION) / fpi_price;
3977         }
3978         else {
3979             collat_imbalance = -1 * int256(((cpi_peg_price - fpi_price) * fpi_supply) / PRICE_PRECISION);
3980             price_diff_frac_abs = ((cpi_peg_price - fpi_price) * PEG_BAND_PRECISION) / fpi_price;
3981         }
3982     }
3983 
3984     /* ========== MUTATIVE ========== */
3985 
3986     // Calculate Mint FPI with FRAX
3987     function calcMintFPI(uint256 frax_in, uint256 min_fpi_out) public view returns (uint256 fpi_out) {
3988         require(!mints_paused, "Mints paused");
3989 
3990         // Fetch the CPI price and other info
3991         (uint256 cpi_peg_price, , bool within_range) = pegStatusMntRdm();
3992 
3993         // Make sure the peg is within range for minting
3994         // Helps combat oracle errors and megadumping
3995         require(within_range, "Peg band [Mint]");
3996 
3997         // Calculate the amount of FPI that the incoming FRAX should give
3998         fpi_out = (frax_in * PRICE_PRECISION) / cpi_peg_price;
3999 
4000         // Apply the fee
4001         fpi_out -= (fpi_out * mint_fee()) / FEE_PRECISION;
4002 
4003         // Make sure enough FPI is generated
4004         require(fpi_out >= min_fpi_out, "Slippage [Mint]");
4005 
4006         // Check the mint cap
4007         require(FPI_TKN.totalSupply() + fpi_out <= fpi_mint_cap, "FPI mint cap");
4008     }
4009 
4010     // Mint FPI with FRAX
4011     function mintFPI(uint256 frax_in, uint256 min_fpi_out) external returns (uint256 fpi_out) {
4012         fpi_out = calcMintFPI(frax_in, min_fpi_out);
4013 
4014         // Pull in the FRAX
4015         TransferHelper.safeTransferFrom(address(FRAX), msg.sender, address(this), frax_in);
4016 
4017         // Mint FPI to the sender
4018         FPI_TKN.minter_mint(msg.sender, fpi_out);
4019 
4020         emit FPIMinted(frax_in, fpi_out);
4021     }
4022 
4023     // Calculate Redeem FPI for FRAX
4024     function calcRedeemFPI(uint256 fpi_in, uint256 min_frax_out) public view returns (uint256 frax_out) {
4025         require(!redeems_paused, "Redeems paused");
4026 
4027         // Fetch the CPI price and other info
4028         (uint256 cpi_peg_price, , bool within_range) = pegStatusMntRdm();
4029 
4030         // Make sure the peg is within range for minting
4031         // Helps combat oracle errors and megadumping
4032         require(within_range, "Peg band [Redeem]");
4033 
4034         // Calculate the amount of FRAX that the incoming FPI should give
4035         frax_out = (fpi_in * cpi_peg_price) / PRICE_PRECISION;
4036 
4037         // Apply the fee
4038         frax_out -= (frax_out * redeem_fee()) / FEE_PRECISION;
4039 
4040         // Make sure enough FRAX is generated
4041         require(frax_out >= min_frax_out, "Slippage [Redeem]");
4042     }
4043 
4044     // Redeem FPI for FRAX
4045     function redeemFPI(uint256 fpi_in, uint256 min_frax_out) external returns (uint256 frax_out) {
4046         frax_out = calcRedeemFPI(fpi_in, min_frax_out);
4047 
4048         // Pull in the FPI
4049         TransferHelper.safeTransferFrom(address(FPI_TKN), msg.sender, address(this), fpi_in);
4050 
4051         // Give FRAX to the sender
4052         TransferHelper.safeTransfer(address(FRAX), msg.sender, frax_out);
4053 
4054         emit FPIRedeemed(fpi_in, frax_out);
4055     }
4056 
4057     // Use the TWAMM for bulk peg corrections
4058     function twammManual(uint256 frax_sell_amt, uint256 fpi_sell_amt, uint256 override_intervals) external onlyByOwnGov returns (uint256 frax_to_use, uint256 fpi_to_use) {
4059         // Make sure only one direction occurs
4060         require(!((frax_sell_amt > 0) && (fpi_sell_amt > 0)), "Can only sell in one direction");
4061 
4062         // Update and get the reserves
4063         // longTermSwapFrom0to1 and longTermSwapFrom1To0 do it automatically
4064         // TWAMM.executeVirtualOrders(block.timestamp);
4065         
4066         // Cancel the previous order (if any) and collect any leftover tokens
4067         if (pending_twamm_order) TWAMM.cancelLongTermSwap(last_order_id_twamm);
4068 
4069         // Now calculate the imbalance after the burn
4070         (, , , uint256 price_diff_abs) = price_info();
4071 
4072         // Make sure the FPI oracle price hasn't moved away too much from the target peg price
4073         require(price_diff_abs <= peg_band_twamm, "Peg band [TWAMM]");
4074 
4075         // Create a new order
4076         last_order_id_twamm = TWAMM.getNextOrderID(); 
4077         {
4078             if (fpi_sell_amt > 0) {
4079                 // Mint FPI and sell for FRAX
4080                 // --------------------------------
4081                 fpi_to_use = fpi_sell_amt;
4082     
4083                 // Make sure nonzero
4084                 require(fpi_to_use > 0, "FPI sold must be nonzero");
4085 
4086                 // Safety check
4087                 require(fpi_to_use <= max_swap_fpi_amt_in, "Too much FPI sold");
4088 
4089                 // Mint some FPI
4090                 FPI_TKN.minter_mint(address(this), fpi_to_use);
4091 
4092                 // Approve FPI first
4093                 FPI_TKN.approve(address(TWAMM), fpi_to_use);
4094 
4095                 // Sell FPI for FRAX
4096                 if (frax_is_token0) {
4097                     TWAMM.longTermSwapFrom1To0(fpi_to_use, override_intervals > 0 ? override_intervals : num_twamm_intervals);
4098                 }
4099                 else {
4100                     TWAMM.longTermSwapFrom0To1(fpi_to_use, override_intervals > 0 ? override_intervals : num_twamm_intervals);
4101                 }
4102             }
4103             else {
4104                 // Use FRAX to buy FPI
4105                 // --------------------------------
4106                 frax_to_use = frax_sell_amt;
4107 
4108                 // Make sure nonzero
4109                 require(frax_to_use > 0, "FRAX sold must be nonzero");
4110 
4111                 // Safety check
4112                 require(frax_to_use <= max_swap_frax_amt_in, "Too much FRAX sold");
4113 
4114                 // Approve FRAX first
4115                 FRAX.approve(address(TWAMM), frax_to_use);
4116 
4117                 // Sell FRAX for FPI
4118                 if (frax_is_token0) {
4119                     TWAMM.longTermSwapFrom0To1(frax_to_use, override_intervals > 0 ? override_intervals : num_twamm_intervals);
4120                 }
4121                 else {
4122                     TWAMM.longTermSwapFrom1To0(frax_to_use, override_intervals > 0 ? override_intervals : num_twamm_intervals);
4123                 }
4124             }
4125         }
4126 
4127         // Mark that there is a pending order
4128         pending_twamm_order = true;
4129 
4130         emit TWAMMedToPeg(last_order_id_twamm, frax_to_use, fpi_to_use, block.timestamp);
4131     }
4132 
4133     function cancelCurrTWAMMOrder(uint256 order_id_override) public onlyByOwnGov {
4134         // Get the order id
4135         uint256 order_id_to_use = (order_id_override == 0 ? last_order_id_twamm : order_id_override);
4136 
4137         // Cancel the order
4138         TWAMM.cancelLongTermSwap(order_id_to_use);
4139 
4140         // Clear the pending order indicator
4141         pending_twamm_order = false;
4142 
4143         emit TWAMMOrderCancelled(order_id_to_use);
4144     }
4145 
4146     function collectCurrTWAMMProceeds(uint256 order_id_override) external onlyByOwnGov {
4147         // Get the order id
4148         uint256 order_id_to_use = (order_id_override == 0 ? last_order_id_twamm : order_id_override);
4149 
4150         // Withdraw current proceeds
4151         (bool is_expired, address rewardTkn, uint256 totalReward) = TWAMM.withdrawProceedsFromLongTermSwap(order_id_to_use);
4152         
4153         // If using the last_order_id_twamm and it is expired, clear the pending order indicator
4154         if (is_expired && (order_id_override == 0)) pending_twamm_order = false;
4155 
4156         emit TWAMMProceedsCollected(order_id_to_use, rewardTkn, totalReward);
4157     }
4158 
4159     /* ========== Burns and givebacks ========== */
4160 
4161     // Burn unneeded or excess FPI.
4162     function burnFPI(bool burn_all, uint256 fpi_amount) public onlyByOwnGov {
4163         uint256 amt_to_burn = burn_all ? FPI_TKN.balanceOf(address(this)) : fpi_amount;
4164 
4165         // Burn
4166         FPI_TKN.burn(amt_to_burn);
4167 
4168         emit FPIBurned(amt_to_burn);
4169     }
4170 
4171     // ------------------------------------------------------------------
4172     // ------------------------------ FRAX ------------------------------
4173     // ------------------------------------------------------------------
4174 
4175     // Lend the FRAX collateral to an AMO
4176     function giveFRAXToAMO(address destination_amo, uint256 frax_amount) external onlyByOwnGov validAMO(destination_amo) {
4177         require(frax_amount <= (2**255 - 1), "int256 overflow");
4178         int256 frax_amount_i256 = int256(frax_amount);
4179 
4180         // Update the balances first
4181         require((frax_borrowed_sum + frax_amount_i256) <= frax_borrow_cap, "Borrow cap");
4182         frax_borrowed_balances[destination_amo] += frax_amount_i256;
4183         frax_borrowed_sum += frax_amount_i256;
4184 
4185         // Give the FRAX to the AMO
4186         TransferHelper.safeTransfer(address(FRAX), destination_amo, frax_amount);
4187 
4188         emit FRAXGivenToAMO(destination_amo, frax_amount);
4189     }
4190 
4191     // AMO gives back FRAX. Needed for proper accounting
4192     function receiveFRAXFromAMO(uint256 frax_amount) external validAMO(msg.sender) {
4193         require(frax_amount <= (2**255 - 1), "int256 overflow");
4194         int256 frax_amt_i256 = int256(frax_amount);
4195 
4196         // Give back first
4197         TransferHelper.safeTransferFrom(address(FRAX), msg.sender, address(this), frax_amount);
4198 
4199         // Then update the balances
4200         frax_borrowed_balances[msg.sender] -= frax_amt_i256;
4201         frax_borrowed_sum -= frax_amt_i256;
4202 
4203         emit FRAXReceivedFromAMO(msg.sender, frax_amount);
4204     }
4205 
4206     /* ========== RESTRICTED FUNCTIONS ========== */
4207 
4208     // Adds an AMO 
4209     function addAMO(address amo_address) public onlyByOwnGov {
4210         require(amo_address != address(0), "Zero address detected");
4211 
4212         require(amos[amo_address] == false, "Address already exists");
4213         amos[amo_address] = true; 
4214         amos_array.push(amo_address);
4215 
4216         emit AMOAdded(amo_address);
4217     }
4218 
4219     // Removes an AMO
4220     function removeAMO(address amo_address) public onlyByOwnGov {
4221         require(amo_address != address(0), "Zero address detected");
4222         require(amos[amo_address] == true, "Address nonexistant");
4223         
4224         // Delete from the mapping
4225         delete amos[amo_address];
4226 
4227         // 'Delete' from the array by setting the address to 0x0
4228         for (uint i = 0; i < amos_array.length; i++){ 
4229             if (amos_array[i] == amo_address) {
4230                 amos_array[i] = address(0); // This will leave a null in the array and keep the indices the same
4231                 break;
4232             }
4233         }
4234 
4235         emit AMORemoved(amo_address);
4236     }
4237 
4238     function setOracles(address _frax_oracle, address _fpi_oracle, address _cpi_oracle) external onlyByOwnGov {
4239         priceFeedFRAXUSD = AggregatorV3Interface(_frax_oracle);
4240         priceFeedFPIUSD = AggregatorV3Interface(_fpi_oracle);
4241         cpiTracker = CPITrackerOracle(_cpi_oracle);
4242 
4243         // Set the Chainlink oracle decimals
4244         chainlink_frax_usd_decimals = priceFeedFRAXUSD.decimals();
4245         chainlink_fpi_usd_decimals = priceFeedFPIUSD.decimals();
4246     }
4247 
4248     function setTWAMMAndSwapPeriod(address _twamm_addr, uint256 _swap_period) external onlyByOwnGov {
4249         // Cancel an outstanding order, if present
4250         if (pending_twamm_order) cancelCurrTWAMMOrder(last_order_id_twamm);
4251         
4252         // Change the TWAMM parameters
4253         TWAMM = IFraxswapPair(_twamm_addr);
4254         swap_period = _swap_period;
4255         num_twamm_intervals = _swap_period / TWAMM.orderTimeInterval();
4256     }
4257 
4258     function toggleMints() external onlyByOwnGov {
4259         mints_paused = !mints_paused;
4260     }
4261 
4262     function toggleRedeems() external onlyByOwnGov {
4263         redeems_paused = !redeems_paused;
4264     }
4265 
4266     function setFraxBorrowCap(int256 _frax_borrow_cap) external onlyByOwnGov {
4267         require(_frax_borrow_cap >= 0, "int256 underflow");
4268         require(_frax_borrow_cap <= (2**255 - 1), "int256 overflow");
4269         frax_borrow_cap = _frax_borrow_cap;
4270     }
4271 
4272     function setMintCap(uint256 _fpi_mint_cap) external onlyByOwnGov {
4273         fpi_mint_cap = _fpi_mint_cap;
4274     }
4275 
4276     function setPegBands(uint256 _peg_band_mint_redeem, uint256 _peg_band_twamm) external onlyByOwnGov {
4277         peg_band_mint_redeem = _peg_band_mint_redeem;
4278         peg_band_twamm = _peg_band_twamm;
4279     }
4280 
4281     function setMintRedeemFees(
4282         bool _use_manual_mint_fee,
4283         uint256 _mint_fee_manual, 
4284         uint256 _mint_fee_multiplier, 
4285         bool _use_manual_redeem_fee,
4286         uint256 _redeem_fee_manual, 
4287         uint256 _redeem_fee_multiplier
4288     ) external onlyByOwnGov {
4289         use_manual_mint_fee = _use_manual_mint_fee;
4290         mint_fee_manual = _mint_fee_manual;
4291         mint_fee_multiplier = _mint_fee_multiplier;
4292         use_manual_redeem_fee = _use_manual_redeem_fee;
4293         redeem_fee_manual = _redeem_fee_manual;
4294         redeem_fee_multiplier = _redeem_fee_multiplier;
4295     }
4296 
4297     function setTWAMMMaxSwapIn(uint256 _max_swap_frax_amt_in, uint256 _max_swap_fpi_amt_in) external onlyByOwnGov {
4298         max_swap_frax_amt_in = _max_swap_frax_amt_in;
4299         max_swap_fpi_amt_in = _max_swap_fpi_amt_in;
4300     }
4301 
4302     function setTimelock(address _new_timelock_address) external onlyByOwnGov {
4303         timelock_address = _new_timelock_address;
4304     }
4305 
4306     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
4307     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyByOwnGov {
4308         // Only the owner address can ever receive the recovery withdrawal
4309         TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
4310         emit RecoveredERC20(tokenAddress, tokenAmount);
4311     }
4312 
4313     /* ========== EVENTS ========== */
4314     event FPIMinted(uint256 frax_in, uint256 fpi_out);
4315     event FPIRedeemed(uint256 fpi_in, uint256 frax_out);
4316     event TWAMMedToPeg(uint256 order_id, uint256 frax_amt, uint256 fpi_amt, uint256 timestamp);
4317     event TWAMMOrderCancelled(uint256 order_id);
4318     event TWAMMProceedsCollected(uint256 order_id, address reward_tkn, uint256 ttl_reward);
4319     event FPIBurned(uint256 amt_burned);
4320     event FRAXGivenToAMO(address destination_amo, uint256 frax_amount);
4321     event FRAXReceivedFromAMO(address source_amo, uint256 frax_amount);
4322     event AMOAdded(address amo_address);
4323     event AMORemoved(address amo_address);
4324     event RecoveredERC20(address token, uint256 amount);
4325 }