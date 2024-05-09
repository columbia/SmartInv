1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: node_modules\@openzeppelin\contracts\security\Pausable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Contract module which allows children to implement an emergency stop
452  * mechanism that can be triggered by an authorized account.
453  *
454  * This module is used through inheritance. It will make available the
455  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
456  * the functions of your contract. Note that they will not be pausable by
457  * simply including this module, only once the modifiers are put in place.
458  */
459 abstract contract Pausable is Context {
460     /**
461      * @dev Emitted when the pause is triggered by `account`.
462      */
463     event Paused(address account);
464 
465     /**
466      * @dev Emitted when the pause is lifted by `account`.
467      */
468     event Unpaused(address account);
469 
470     bool private _paused;
471 
472     /**
473      * @dev Initializes the contract in unpaused state.
474      */
475     constructor () {
476         _paused = false;
477     }
478 
479     /**
480      * @dev Returns true if the contract is paused, and false otherwise.
481      */
482     function paused() public view virtual returns (bool) {
483         return _paused;
484     }
485 
486     /**
487      * @dev Modifier to make a function callable only when the contract is not paused.
488      *
489      * Requirements:
490      *
491      * - The contract must not be paused.
492      */
493     modifier whenNotPaused() {
494         require(!paused(), "Pausable: paused");
495         _;
496     }
497 
498     /**
499      * @dev Modifier to make a function callable only when the contract is paused.
500      *
501      * Requirements:
502      *
503      * - The contract must be paused.
504      */
505     modifier whenPaused() {
506         require(paused(), "Pausable: not paused");
507         _;
508     }
509 
510     /**
511      * @dev Triggers stopped state.
512      *
513      * Requirements:
514      *
515      * - The contract must not be paused.
516      */
517     function _pause() internal virtual whenNotPaused {
518         _paused = true;
519         emit Paused(_msgSender());
520     }
521 
522     /**
523      * @dev Returns to normal state.
524      *
525      * Requirements:
526      *
527      * - The contract must be paused.
528      */
529     function _unpause() internal virtual whenPaused {
530         _paused = false;
531         emit Unpaused(_msgSender());
532     }
533 }
534 
535 // File: @openzeppelin\contracts\token\ERC20\extensions\ERC20Pausable.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 /**
544  * @dev ERC20 token with pausable token transfers, minting and burning.
545  *
546  * Useful for scenarios such as preventing trades until the end of an evaluation
547  * period, or having an emergency switch for freezing all token transfers in the
548  * event of a large bug.
549  */
550 abstract contract ERC20Pausable is ERC20, Pausable {
551     /**
552      * @dev See {ERC20-_beforeTokenTransfer}.
553      *
554      * Requirements:
555      *
556      * - the contract must not be paused.
557      */
558     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
559         super._beforeTokenTransfer(from, to, amount);
560 
561         require(!paused(), "ERC20Pausable: token transfer while paused");
562     }
563 }
564 
565 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
566 
567 
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev String operations.
573  */
574 library Strings {
575     bytes16 private constant alphabet = "0123456789abcdef";
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
579      */
580     function toString(uint256 value) internal pure returns (string memory) {
581         // Inspired by OraclizeAPI's implementation - MIT licence
582         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
583 
584         if (value == 0) {
585             return "0";
586         }
587         uint256 temp = value;
588         uint256 digits;
589         while (temp != 0) {
590             digits++;
591             temp /= 10;
592         }
593         bytes memory buffer = new bytes(digits);
594         while (value != 0) {
595             digits -= 1;
596             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
597             value /= 10;
598         }
599         return string(buffer);
600     }
601 
602     /**
603      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
604      */
605     function toHexString(uint256 value) internal pure returns (string memory) {
606         if (value == 0) {
607             return "0x00";
608         }
609         uint256 temp = value;
610         uint256 length = 0;
611         while (temp != 0) {
612             length++;
613             temp >>= 8;
614         }
615         return toHexString(value, length);
616     }
617 
618     /**
619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
620      */
621     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
622         bytes memory buffer = new bytes(2 * length + 2);
623         buffer[0] = "0";
624         buffer[1] = "x";
625         for (uint256 i = 2 * length + 1; i > 1; --i) {
626             buffer[i] = alphabet[value & 0xf];
627             value >>= 4;
628         }
629         require(value == 0, "Strings: hex length insufficient");
630         return string(buffer);
631     }
632 
633 }
634 
635 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
636 
637 
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Interface of the ERC165 standard, as defined in the
643  * https://eips.ethereum.org/EIPS/eip-165[EIP].
644  *
645  * Implementers can declare support of contract interfaces, which can then be
646  * queried by others ({ERC165Checker}).
647  *
648  * For an implementation, see {ERC165}.
649  */
650 interface IERC165 {
651     /**
652      * @dev Returns true if this contract implements the interface defined by
653      * `interfaceId`. See the corresponding
654      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
655      * to learn more about how these ids are created.
656      *
657      * This function call must use less than 30 000 gas.
658      */
659     function supportsInterface(bytes4 interfaceId) external view returns (bool);
660 }
661 
662 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @dev Implementation of the {IERC165} interface.
671  *
672  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
673  * for the additional interface id that will be supported. For example:
674  *
675  * ```solidity
676  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
678  * }
679  * ```
680  *
681  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
682  */
683 abstract contract ERC165 is IERC165 {
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688         return interfaceId == type(IERC165).interfaceId;
689     }
690 }
691 
692 // File: node_modules\@openzeppelin\contracts\access\AccessControl.sol
693 
694 
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 
701 /**
702  * @dev External interface of AccessControl declared to support ERC165 detection.
703  */
704 interface IAccessControl {
705     function hasRole(bytes32 role, address account) external view returns (bool);
706     function getRoleAdmin(bytes32 role) external view returns (bytes32);
707     function grantRole(bytes32 role, address account) external;
708     function revokeRole(bytes32 role, address account) external;
709     function renounceRole(bytes32 role, address account) external;
710 }
711 
712 /**
713  * @dev Contract module that allows children to implement role-based access
714  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
715  * members except through off-chain means by accessing the contract event logs. Some
716  * applications may benefit from on-chain enumerability, for those cases see
717  * {AccessControlEnumerable}.
718  *
719  * Roles are referred to by their `bytes32` identifier. These should be exposed
720  * in the external API and be unique. The best way to achieve this is by
721  * using `public constant` hash digests:
722  *
723  * ```
724  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
725  * ```
726  *
727  * Roles can be used to represent a set of permissions. To restrict access to a
728  * function call, use {hasRole}:
729  *
730  * ```
731  * function foo() public {
732  *     require(hasRole(MY_ROLE, msg.sender));
733  *     ...
734  * }
735  * ```
736  *
737  * Roles can be granted and revoked dynamically via the {grantRole} and
738  * {revokeRole} functions. Each role has an associated admin role, and only
739  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
740  *
741  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
742  * that only accounts with this role will be able to grant or revoke other
743  * roles. More complex role relationships can be created by using
744  * {_setRoleAdmin}.
745  *
746  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
747  * grant and revoke this role. Extra precautions should be taken to secure
748  * accounts that have been granted it.
749  */
750 abstract contract AccessControl is Context, IAccessControl, ERC165 {
751     struct RoleData {
752         mapping (address => bool) members;
753         bytes32 adminRole;
754     }
755 
756     mapping (bytes32 => RoleData) private _roles;
757 
758     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
759 
760     /**
761      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
762      *
763      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
764      * {RoleAdminChanged} not being emitted signaling this.
765      *
766      * _Available since v3.1._
767      */
768     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
769 
770     /**
771      * @dev Emitted when `account` is granted `role`.
772      *
773      * `sender` is the account that originated the contract call, an admin role
774      * bearer except when using {_setupRole}.
775      */
776     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
777 
778     /**
779      * @dev Emitted when `account` is revoked `role`.
780      *
781      * `sender` is the account that originated the contract call:
782      *   - if using `revokeRole`, it is the admin role bearer
783      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
784      */
785     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
786 
787     /**
788      * @dev Modifier that checks that an account has a specific role. Reverts
789      * with a standardized message including the required role.
790      *
791      * The format of the revert reason is given by the following regular expression:
792      *
793      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
794      *
795      * _Available since v4.1._
796      */
797     modifier onlyRole(bytes32 role) {
798         _checkRole(role, _msgSender());
799         _;
800     }
801 
802     /**
803      * @dev See {IERC165-supportsInterface}.
804      */
805     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
806         return interfaceId == type(IAccessControl).interfaceId
807             || super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev Returns `true` if `account` has been granted `role`.
812      */
813     function hasRole(bytes32 role, address account) public view override returns (bool) {
814         return _roles[role].members[account];
815     }
816 
817     /**
818      * @dev Revert with a standard message if `account` is missing `role`.
819      *
820      * The format of the revert reason is given by the following regular expression:
821      *
822      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
823      */
824     function _checkRole(bytes32 role, address account) internal view {
825         if(!hasRole(role, account)) {
826             revert(string(abi.encodePacked(
827                 "AccessControl: account ",
828                 Strings.toHexString(uint160(account), 20),
829                 " is missing role ",
830                 Strings.toHexString(uint256(role), 32)
831             )));
832         }
833     }
834 
835     /**
836      * @dev Returns the admin role that controls `role`. See {grantRole} and
837      * {revokeRole}.
838      *
839      * To change a role's admin, use {_setRoleAdmin}.
840      */
841     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
842         return _roles[role].adminRole;
843     }
844 
845     /**
846      * @dev Grants `role` to `account`.
847      *
848      * If `account` had not been already granted `role`, emits a {RoleGranted}
849      * event.
850      *
851      * Requirements:
852      *
853      * - the caller must have ``role``'s admin role.
854      */
855     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
856         _grantRole(role, account);
857     }
858 
859     /**
860      * @dev Revokes `role` from `account`.
861      *
862      * If `account` had been granted `role`, emits a {RoleRevoked} event.
863      *
864      * Requirements:
865      *
866      * - the caller must have ``role``'s admin role.
867      */
868     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
869         _revokeRole(role, account);
870     }
871 
872     /**
873      * @dev Revokes `role` from the calling account.
874      *
875      * Roles are often managed via {grantRole} and {revokeRole}: this function's
876      * purpose is to provide a mechanism for accounts to lose their privileges
877      * if they are compromised (such as when a trusted device is misplaced).
878      *
879      * If the calling account had been granted `role`, emits a {RoleRevoked}
880      * event.
881      *
882      * Requirements:
883      *
884      * - the caller must be `account`.
885      */
886     function renounceRole(bytes32 role, address account) public virtual override {
887         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
888 
889         _revokeRole(role, account);
890     }
891 
892     /**
893      * @dev Grants `role` to `account`.
894      *
895      * If `account` had not been already granted `role`, emits a {RoleGranted}
896      * event. Note that unlike {grantRole}, this function doesn't perform any
897      * checks on the calling account.
898      *
899      * [WARNING]
900      * ====
901      * This function should only be called from the constructor when setting
902      * up the initial roles for the system.
903      *
904      * Using this function in any other way is effectively circumventing the admin
905      * system imposed by {AccessControl}.
906      * ====
907      */
908     function _setupRole(bytes32 role, address account) internal virtual {
909         _grantRole(role, account);
910     }
911 
912     /**
913      * @dev Sets `adminRole` as ``role``'s admin role.
914      *
915      * Emits a {RoleAdminChanged} event.
916      */
917     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
918         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
919         _roles[role].adminRole = adminRole;
920     }
921 
922     function _grantRole(bytes32 role, address account) private {
923         if (!hasRole(role, account)) {
924             _roles[role].members[account] = true;
925             emit RoleGranted(role, account, _msgSender());
926         }
927     }
928 
929     function _revokeRole(bytes32 role, address account) private {
930         if (hasRole(role, account)) {
931             _roles[role].members[account] = false;
932             emit RoleRevoked(role, account, _msgSender());
933         }
934     }
935 }
936 
937 // File: node_modules\@openzeppelin\contracts\utils\structs\EnumerableSet.sol
938 
939 
940 
941 pragma solidity ^0.8.0;
942 
943 /**
944  * @dev Library for managing
945  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
946  * types.
947  *
948  * Sets have the following properties:
949  *
950  * - Elements are added, removed, and checked for existence in constant time
951  * (O(1)).
952  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
953  *
954  * ```
955  * contract Example {
956  *     // Add the library methods
957  *     using EnumerableSet for EnumerableSet.AddressSet;
958  *
959  *     // Declare a set state variable
960  *     EnumerableSet.AddressSet private mySet;
961  * }
962  * ```
963  *
964  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
965  * and `uint256` (`UintSet`) are supported.
966  */
967 library EnumerableSet {
968     // To implement this library for multiple types with as little code
969     // repetition as possible, we write it in terms of a generic Set type with
970     // bytes32 values.
971     // The Set implementation uses private functions, and user-facing
972     // implementations (such as AddressSet) are just wrappers around the
973     // underlying Set.
974     // This means that we can only create new EnumerableSets for types that fit
975     // in bytes32.
976 
977     struct Set {
978         // Storage of set values
979         bytes32[] _values;
980 
981         // Position of the value in the `values` array, plus 1 because index 0
982         // means a value is not in the set.
983         mapping (bytes32 => uint256) _indexes;
984     }
985 
986     /**
987      * @dev Add a value to a set. O(1).
988      *
989      * Returns true if the value was added to the set, that is if it was not
990      * already present.
991      */
992     function _add(Set storage set, bytes32 value) private returns (bool) {
993         if (!_contains(set, value)) {
994             set._values.push(value);
995             // The value is stored at length-1, but we add 1 to all indexes
996             // and use 0 as a sentinel value
997             set._indexes[value] = set._values.length;
998             return true;
999         } else {
1000             return false;
1001         }
1002     }
1003 
1004     /**
1005      * @dev Removes a value from a set. O(1).
1006      *
1007      * Returns true if the value was removed from the set, that is if it was
1008      * present.
1009      */
1010     function _remove(Set storage set, bytes32 value) private returns (bool) {
1011         // We read and store the value's index to prevent multiple reads from the same storage slot
1012         uint256 valueIndex = set._indexes[value];
1013 
1014         if (valueIndex != 0) { // Equivalent to contains(set, value)
1015             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1016             // the array, and then remove the last element (sometimes called as 'swap and pop').
1017             // This modifies the order of the array, as noted in {at}.
1018 
1019             uint256 toDeleteIndex = valueIndex - 1;
1020             uint256 lastIndex = set._values.length - 1;
1021 
1022             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1023             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1024 
1025             bytes32 lastvalue = set._values[lastIndex];
1026 
1027             // Move the last value to the index where the value to delete is
1028             set._values[toDeleteIndex] = lastvalue;
1029             // Update the index for the moved value
1030             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1031 
1032             // Delete the slot where the moved value was stored
1033             set._values.pop();
1034 
1035             // Delete the index for the deleted slot
1036             delete set._indexes[value];
1037 
1038             return true;
1039         } else {
1040             return false;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns true if the value is in the set. O(1).
1046      */
1047     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1048         return set._indexes[value] != 0;
1049     }
1050 
1051     /**
1052      * @dev Returns the number of values on the set. O(1).
1053      */
1054     function _length(Set storage set) private view returns (uint256) {
1055         return set._values.length;
1056     }
1057 
1058    /**
1059     * @dev Returns the value stored at position `index` in the set. O(1).
1060     *
1061     * Note that there are no guarantees on the ordering of values inside the
1062     * array, and it may change when more values are added or removed.
1063     *
1064     * Requirements:
1065     *
1066     * - `index` must be strictly less than {length}.
1067     */
1068     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1069         require(set._values.length > index, "EnumerableSet: index out of bounds");
1070         return set._values[index];
1071     }
1072 
1073     // Bytes32Set
1074 
1075     struct Bytes32Set {
1076         Set _inner;
1077     }
1078 
1079     /**
1080      * @dev Add a value to a set. O(1).
1081      *
1082      * Returns true if the value was added to the set, that is if it was not
1083      * already present.
1084      */
1085     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1086         return _add(set._inner, value);
1087     }
1088 
1089     /**
1090      * @dev Removes a value from a set. O(1).
1091      *
1092      * Returns true if the value was removed from the set, that is if it was
1093      * present.
1094      */
1095     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1096         return _remove(set._inner, value);
1097     }
1098 
1099     /**
1100      * @dev Returns true if the value is in the set. O(1).
1101      */
1102     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1103         return _contains(set._inner, value);
1104     }
1105 
1106     /**
1107      * @dev Returns the number of values in the set. O(1).
1108      */
1109     function length(Bytes32Set storage set) internal view returns (uint256) {
1110         return _length(set._inner);
1111     }
1112 
1113    /**
1114     * @dev Returns the value stored at position `index` in the set. O(1).
1115     *
1116     * Note that there are no guarantees on the ordering of values inside the
1117     * array, and it may change when more values are added or removed.
1118     *
1119     * Requirements:
1120     *
1121     * - `index` must be strictly less than {length}.
1122     */
1123     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1124         return _at(set._inner, index);
1125     }
1126 
1127     // AddressSet
1128 
1129     struct AddressSet {
1130         Set _inner;
1131     }
1132 
1133     /**
1134      * @dev Add a value to a set. O(1).
1135      *
1136      * Returns true if the value was added to the set, that is if it was not
1137      * already present.
1138      */
1139     function add(AddressSet storage set, address value) internal returns (bool) {
1140         return _add(set._inner, bytes32(uint256(uint160(value))));
1141     }
1142 
1143     /**
1144      * @dev Removes a value from a set. O(1).
1145      *
1146      * Returns true if the value was removed from the set, that is if it was
1147      * present.
1148      */
1149     function remove(AddressSet storage set, address value) internal returns (bool) {
1150         return _remove(set._inner, bytes32(uint256(uint160(value))));
1151     }
1152 
1153     /**
1154      * @dev Returns true if the value is in the set. O(1).
1155      */
1156     function contains(AddressSet storage set, address value) internal view returns (bool) {
1157         return _contains(set._inner, bytes32(uint256(uint160(value))));
1158     }
1159 
1160     /**
1161      * @dev Returns the number of values in the set. O(1).
1162      */
1163     function length(AddressSet storage set) internal view returns (uint256) {
1164         return _length(set._inner);
1165     }
1166 
1167    /**
1168     * @dev Returns the value stored at position `index` in the set. O(1).
1169     *
1170     * Note that there are no guarantees on the ordering of values inside the
1171     * array, and it may change when more values are added or removed.
1172     *
1173     * Requirements:
1174     *
1175     * - `index` must be strictly less than {length}.
1176     */
1177     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1178         return address(uint160(uint256(_at(set._inner, index))));
1179     }
1180 
1181 
1182     // UintSet
1183 
1184     struct UintSet {
1185         Set _inner;
1186     }
1187 
1188     /**
1189      * @dev Add a value to a set. O(1).
1190      *
1191      * Returns true if the value was added to the set, that is if it was not
1192      * already present.
1193      */
1194     function add(UintSet storage set, uint256 value) internal returns (bool) {
1195         return _add(set._inner, bytes32(value));
1196     }
1197 
1198     /**
1199      * @dev Removes a value from a set. O(1).
1200      *
1201      * Returns true if the value was removed from the set, that is if it was
1202      * present.
1203      */
1204     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1205         return _remove(set._inner, bytes32(value));
1206     }
1207 
1208     /**
1209      * @dev Returns true if the value is in the set. O(1).
1210      */
1211     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1212         return _contains(set._inner, bytes32(value));
1213     }
1214 
1215     /**
1216      * @dev Returns the number of values on the set. O(1).
1217      */
1218     function length(UintSet storage set) internal view returns (uint256) {
1219         return _length(set._inner);
1220     }
1221 
1222    /**
1223     * @dev Returns the value stored at position `index` in the set. O(1).
1224     *
1225     * Note that there are no guarantees on the ordering of values inside the
1226     * array, and it may change when more values are added or removed.
1227     *
1228     * Requirements:
1229     *
1230     * - `index` must be strictly less than {length}.
1231     */
1232     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1233         return uint256(_at(set._inner, index));
1234     }
1235 }
1236 
1237 // File: @openzeppelin\contracts\access\AccessControlEnumerable.sol
1238 
1239 
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 
1244 
1245 /**
1246  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1247  */
1248 interface IAccessControlEnumerable {
1249     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1250     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1251 }
1252 
1253 /**
1254  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1255  */
1256 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1257     using EnumerableSet for EnumerableSet.AddressSet;
1258 
1259     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1260 
1261     /**
1262      * @dev See {IERC165-supportsInterface}.
1263      */
1264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1265         return interfaceId == type(IAccessControlEnumerable).interfaceId
1266             || super.supportsInterface(interfaceId);
1267     }
1268 
1269     /**
1270      * @dev Returns one of the accounts that have `role`. `index` must be a
1271      * value between 0 and {getRoleMemberCount}, non-inclusive.
1272      *
1273      * Role bearers are not sorted in any particular way, and their ordering may
1274      * change at any point.
1275      *
1276      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1277      * you perform all queries on the same block. See the following
1278      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1279      * for more information.
1280      */
1281     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1282         return _roleMembers[role].at(index);
1283     }
1284 
1285     /**
1286      * @dev Returns the number of accounts that have `role`. Can be used
1287      * together with {getRoleMember} to enumerate all bearers of a role.
1288      */
1289     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1290         return _roleMembers[role].length();
1291     }
1292 
1293     /**
1294      * @dev Overload {grantRole} to track enumerable memberships
1295      */
1296     function grantRole(bytes32 role, address account) public virtual override {
1297         super.grantRole(role, account);
1298         _roleMembers[role].add(account);
1299     }
1300 
1301     /**
1302      * @dev Overload {revokeRole} to track enumerable memberships
1303      */
1304     function revokeRole(bytes32 role, address account) public virtual override {
1305         super.revokeRole(role, account);
1306         _roleMembers[role].remove(account);
1307     }
1308 
1309     /**
1310      * @dev Overload {renounceRole} to track enumerable memberships
1311      */
1312     function renounceRole(bytes32 role, address account) public virtual override {
1313         super.renounceRole(role, account);
1314         _roleMembers[role].remove(account);
1315     }
1316 
1317     /**
1318      * @dev Overload {_setupRole} to track enumerable memberships
1319      */
1320     function _setupRole(bytes32 role, address account) internal virtual override {
1321         super._setupRole(role, account);
1322         _roleMembers[role].add(account);
1323     }
1324 }
1325 
1326 // File: contracts\ZesCoin.sol
1327 
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 
1332 
1333 // ----------------------------------------------------------------------------
1334 // ZesCoin contract by SecLab LLC
1335 //
1336 // Symbol      : ZESC
1337 // Name        : ZesCoin
1338 // Total supply: 5,114,477,611
1339 // Decimals    : 4
1340 // Access Control : Role Based Access Control
1341 // 
1342 // Copyright (c) 2021 zOS Global Limited, The MIT License
1343 // ----------------------------------------------------------------------------
1344 
1345 
1346 contract Zescoin is AccessControlEnumerable, ERC20Pausable {
1347     uint256 private initialSupply;
1348     string private _name = "ZesCoin";
1349     string private _symbol = "ZESC";
1350     uint8 private _decimals;
1351     
1352     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1353     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1354     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1355 
1356     constructor() ERC20(_name, _symbol)  {
1357         _decimals = 4;
1358         initialSupply = 5114477611 * 10**uint(_decimals);
1359         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1360         _mint(msg.sender, initialSupply);
1361     }
1362     function decimals() public view override virtual returns (uint8) {
1363         return 4;
1364     }
1365     /**
1366      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1367      * allowance.
1368      *
1369      * Requirements:
1370      *
1371      * - the caller must have allowance for ``accounts``'s tokens of at least
1372      * `amount`.
1373      * - the caller must have the `BURNER_ROLE`.
1374      */
1375     function burnFrom(address account, uint256 amount) public virtual {
1376         require(hasRole(BURNER_ROLE, _msgSender()), "ERC20: must have burner role to mint");
1377         uint256 currentAllowance = allowance(account, _msgSender());
1378         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1379         _approve(account, _msgSender(), currentAllowance - amount);
1380         _burn(account, amount);
1381     }    
1382     /**
1383      * @dev Creates `amount` new tokens for `to`.
1384      *
1385      * Requirements:
1386      *
1387      * - the caller must have the `MINTER_ROLE`.
1388      */
1389     function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
1390         _mint(to, amount);
1391     }   
1392     /**
1393     * @dev Pauses all token transfers.
1394     *
1395     * Requirements:
1396     *
1397     * - the caller must have the `PAUSER_ROLE`.
1398     */
1399     function pause() public virtual {
1400         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20Pausable: must have pauser role to pause");
1401         _pause();
1402     }
1403     /**
1404     * @dev Unpauses all token transfers.
1405     *
1406     * Requirements:
1407     *
1408     * - the caller must have the `PAUSER_ROLE`.
1409     */    
1410     function unpause() public virtual {
1411         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20Pausable: must have pauser role to unpause");
1412         _unpause();
1413     }
1414     
1415 }