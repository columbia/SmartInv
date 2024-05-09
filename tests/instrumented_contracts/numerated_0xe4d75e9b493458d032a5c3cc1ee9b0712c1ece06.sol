1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 // SPDX-License-Identifier: MIT
3 
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
81 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
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
110 // File: @openzeppelin/contracts/utils/Context.sol
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
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
443 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 
451 /**
452  * @dev Extension of {ERC20} that allows token holders to destroy both their own
453  * tokens and those that they have an allowance for, in a way that can be
454  * recognized off-chain (via event analysis).
455  */
456 abstract contract ERC20Burnable is Context, ERC20 {
457     /**
458      * @dev Destroys `amount` tokens from the caller.
459      *
460      * See {ERC20-_burn}.
461      */
462     function burn(uint256 amount) public virtual {
463         _burn(_msgSender(), amount);
464     }
465 
466     /**
467      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
468      * allowance.
469      *
470      * See {ERC20-_burn} and {ERC20-allowance}.
471      *
472      * Requirements:
473      *
474      * - the caller must have allowance for ``accounts``'s tokens of at least
475      * `amount`.
476      */
477     function burnFrom(address account, uint256 amount) public virtual {
478         uint256 currentAllowance = allowance(account, _msgSender());
479         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
480         _approve(account, _msgSender(), currentAllowance - amount);
481         _burn(account, amount);
482     }
483 }
484 
485 // File: @openzeppelin/contracts/security/Pausable.sol
486 
487 
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Contract module which allows children to implement an emergency stop
494  * mechanism that can be triggered by an authorized account.
495  *
496  * This module is used through inheritance. It will make available the
497  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
498  * the functions of your contract. Note that they will not be pausable by
499  * simply including this module, only once the modifiers are put in place.
500  */
501 abstract contract Pausable is Context {
502     /**
503      * @dev Emitted when the pause is triggered by `account`.
504      */
505     event Paused(address account);
506 
507     /**
508      * @dev Emitted when the pause is lifted by `account`.
509      */
510     event Unpaused(address account);
511 
512     bool private _paused;
513 
514     /**
515      * @dev Initializes the contract in unpaused state.
516      */
517     constructor () {
518         _paused = false;
519     }
520 
521     /**
522      * @dev Returns true if the contract is paused, and false otherwise.
523      */
524     function paused() public view virtual returns (bool) {
525         return _paused;
526     }
527 
528     /**
529      * @dev Modifier to make a function callable only when the contract is not paused.
530      *
531      * Requirements:
532      *
533      * - The contract must not be paused.
534      */
535     modifier whenNotPaused() {
536         require(!paused(), "Pausable: paused");
537         _;
538     }
539 
540     /**
541      * @dev Modifier to make a function callable only when the contract is paused.
542      *
543      * Requirements:
544      *
545      * - The contract must be paused.
546      */
547     modifier whenPaused() {
548         require(paused(), "Pausable: not paused");
549         _;
550     }
551 
552     /**
553      * @dev Triggers stopped state.
554      *
555      * Requirements:
556      *
557      * - The contract must not be paused.
558      */
559     function _pause() internal virtual whenNotPaused {
560         _paused = true;
561         emit Paused(_msgSender());
562     }
563 
564     /**
565      * @dev Returns to normal state.
566      *
567      * Requirements:
568      *
569      * - The contract must be paused.
570      */
571     function _unpause() internal virtual whenPaused {
572         _paused = false;
573         emit Unpaused(_msgSender());
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 
584 
585 /**
586  * @dev ERC20 token with pausable token transfers, minting and burning.
587  *
588  * Useful for scenarios such as preventing trades until the end of an evaluation
589  * period, or having an emergency switch for freezing all token transfers in the
590  * event of a large bug.
591  */
592 abstract contract ERC20Pausable is ERC20, Pausable {
593     /**
594      * @dev See {ERC20-_beforeTokenTransfer}.
595      *
596      * Requirements:
597      *
598      * - the contract must not be paused.
599      */
600     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
601         super._beforeTokenTransfer(from, to, amount);
602 
603         require(!paused(), "ERC20Pausable: token transfer while paused");
604     }
605 }
606 
607 // File: @openzeppelin/contracts/utils/Strings.sol
608 
609 
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant alphabet = "0123456789abcdef";
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
621      */
622     function toString(uint256 value) internal pure returns (string memory) {
623         // Inspired by OraclizeAPI's implementation - MIT licence
624         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
625 
626         if (value == 0) {
627             return "0";
628         }
629         uint256 temp = value;
630         uint256 digits;
631         while (temp != 0) {
632             digits++;
633             temp /= 10;
634         }
635         bytes memory buffer = new bytes(digits);
636         while (value != 0) {
637             digits -= 1;
638             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
639             value /= 10;
640         }
641         return string(buffer);
642     }
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
646      */
647     function toHexString(uint256 value) internal pure returns (string memory) {
648         if (value == 0) {
649             return "0x00";
650         }
651         uint256 temp = value;
652         uint256 length = 0;
653         while (temp != 0) {
654             length++;
655             temp >>= 8;
656         }
657         return toHexString(value, length);
658     }
659 
660     /**
661      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
662      */
663     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
664         bytes memory buffer = new bytes(2 * length + 2);
665         buffer[0] = "0";
666         buffer[1] = "x";
667         for (uint256 i = 2 * length + 1; i > 1; --i) {
668             buffer[i] = alphabet[value & 0xf];
669             value >>= 4;
670         }
671         require(value == 0, "Strings: hex length insufficient");
672         return string(buffer);
673     }
674 
675 }
676 
677 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Interface of the ERC165 standard, as defined in the
685  * https://eips.ethereum.org/EIPS/eip-165[EIP].
686  *
687  * Implementers can declare support of contract interfaces, which can then be
688  * queried by others ({ERC165Checker}).
689  *
690  * For an implementation, see {ERC165}.
691  */
692 interface IERC165 {
693     /**
694      * @dev Returns true if this contract implements the interface defined by
695      * `interfaceId`. See the corresponding
696      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
697      * to learn more about how these ids are created.
698      *
699      * This function call must use less than 30 000 gas.
700      */
701     function supportsInterface(bytes4 interfaceId) external view returns (bool);
702 }
703 
704 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
705 
706 
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @dev Implementation of the {IERC165} interface.
713  *
714  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
715  * for the additional interface id that will be supported. For example:
716  *
717  * ```solidity
718  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
720  * }
721  * ```
722  *
723  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
724  */
725 abstract contract ERC165 is IERC165 {
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730         return interfaceId == type(IERC165).interfaceId;
731     }
732 }
733 
734 // File: @openzeppelin/contracts/access/AccessControl.sol
735 
736 
737 
738 pragma solidity ^0.8.0;
739 
740 
741 
742 
743 /**
744  * @dev External interface of AccessControl declared to support ERC165 detection.
745  */
746 interface IAccessControl {
747     function hasRole(bytes32 role, address account) external view returns (bool);
748     function getRoleAdmin(bytes32 role) external view returns (bytes32);
749     function grantRole(bytes32 role, address account) external;
750     function revokeRole(bytes32 role, address account) external;
751     function renounceRole(bytes32 role, address account) external;
752 }
753 
754 /**
755  * @dev Contract module that allows children to implement role-based access
756  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
757  * members except through off-chain means by accessing the contract event logs. Some
758  * applications may benefit from on-chain enumerability, for those cases see
759  * {AccessControlEnumerable}.
760  *
761  * Roles are referred to by their `bytes32` identifier. These should be exposed
762  * in the external API and be unique. The best way to achieve this is by
763  * using `public constant` hash digests:
764  *
765  * ```
766  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
767  * ```
768  *
769  * Roles can be used to represent a set of permissions. To restrict access to a
770  * function call, use {hasRole}:
771  *
772  * ```
773  * function foo() public {
774  *     require(hasRole(MY_ROLE, msg.sender));
775  *     ...
776  * }
777  * ```
778  *
779  * Roles can be granted and revoked dynamically via the {grantRole} and
780  * {revokeRole} functions. Each role has an associated admin role, and only
781  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
782  *
783  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
784  * that only accounts with this role will be able to grant or revoke other
785  * roles. More complex role relationships can be created by using
786  * {_setRoleAdmin}.
787  *
788  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
789  * grant and revoke this role. Extra precautions should be taken to secure
790  * accounts that have been granted it.
791  */
792 abstract contract AccessControl is Context, IAccessControl, ERC165 {
793     struct RoleData {
794         mapping (address => bool) members;
795         bytes32 adminRole;
796     }
797 
798     mapping (bytes32 => RoleData) private _roles;
799 
800     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
801 
802     /**
803      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
804      *
805      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
806      * {RoleAdminChanged} not being emitted signaling this.
807      *
808      * _Available since v3.1._
809      */
810     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
811 
812     /**
813      * @dev Emitted when `account` is granted `role`.
814      *
815      * `sender` is the account that originated the contract call, an admin role
816      * bearer except when using {_setupRole}.
817      */
818     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
819 
820     /**
821      * @dev Emitted when `account` is revoked `role`.
822      *
823      * `sender` is the account that originated the contract call:
824      *   - if using `revokeRole`, it is the admin role bearer
825      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
826      */
827     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
828 
829     /**
830      * @dev Modifier that checks that an account has a specific role. Reverts
831      * with a standardized message including the required role.
832      *
833      * The format of the revert reason is given by the following regular expression:
834      *
835      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
836      *
837      * _Available since v4.1._
838      */
839     modifier onlyRole(bytes32 role) {
840         _checkRole(role, _msgSender());
841         _;
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
848         return interfaceId == type(IAccessControl).interfaceId
849             || super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev Returns `true` if `account` has been granted `role`.
854      */
855     function hasRole(bytes32 role, address account) public view override returns (bool) {
856         return _roles[role].members[account];
857     }
858 
859     /**
860      * @dev Revert with a standard message if `account` is missing `role`.
861      *
862      * The format of the revert reason is given by the following regular expression:
863      *
864      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
865      */
866     function _checkRole(bytes32 role, address account) internal view {
867         if(!hasRole(role, account)) {
868             revert(string(abi.encodePacked(
869                 "AccessControl: account ",
870                 Strings.toHexString(uint160(account), 20),
871                 " is missing role ",
872                 Strings.toHexString(uint256(role), 32)
873             )));
874         }
875     }
876 
877     /**
878      * @dev Returns the admin role that controls `role`. See {grantRole} and
879      * {revokeRole}.
880      *
881      * To change a role's admin, use {_setRoleAdmin}.
882      */
883     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
884         return _roles[role].adminRole;
885     }
886 
887     /**
888      * @dev Grants `role` to `account`.
889      *
890      * If `account` had not been already granted `role`, emits a {RoleGranted}
891      * event.
892      *
893      * Requirements:
894      *
895      * - the caller must have ``role``'s admin role.
896      */
897     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
898         _grantRole(role, account);
899     }
900 
901     /**
902      * @dev Revokes `role` from `account`.
903      *
904      * If `account` had been granted `role`, emits a {RoleRevoked} event.
905      *
906      * Requirements:
907      *
908      * - the caller must have ``role``'s admin role.
909      */
910     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
911         _revokeRole(role, account);
912     }
913 
914     /**
915      * @dev Revokes `role` from the calling account.
916      *
917      * Roles are often managed via {grantRole} and {revokeRole}: this function's
918      * purpose is to provide a mechanism for accounts to lose their privileges
919      * if they are compromised (such as when a trusted device is misplaced).
920      *
921      * If the calling account had been granted `role`, emits a {RoleRevoked}
922      * event.
923      *
924      * Requirements:
925      *
926      * - the caller must be `account`.
927      */
928     function renounceRole(bytes32 role, address account) public virtual override {
929         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
930 
931         _revokeRole(role, account);
932     }
933 
934     /**
935      * @dev Grants `role` to `account`.
936      *
937      * If `account` had not been already granted `role`, emits a {RoleGranted}
938      * event. Note that unlike {grantRole}, this function doesn't perform any
939      * checks on the calling account.
940      *
941      * [WARNING]
942      * ====
943      * This function should only be called from the constructor when setting
944      * up the initial roles for the system.
945      *
946      * Using this function in any other way is effectively circumventing the admin
947      * system imposed by {AccessControl}.
948      * ====
949      */
950     function _setupRole(bytes32 role, address account) internal virtual {
951         _grantRole(role, account);
952     }
953 
954     /**
955      * @dev Sets `adminRole` as ``role``'s admin role.
956      *
957      * Emits a {RoleAdminChanged} event.
958      */
959     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
960         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
961         _roles[role].adminRole = adminRole;
962     }
963 
964     function _grantRole(bytes32 role, address account) private {
965         if (!hasRole(role, account)) {
966             _roles[role].members[account] = true;
967             emit RoleGranted(role, account, _msgSender());
968         }
969     }
970 
971     function _revokeRole(bytes32 role, address account) private {
972         if (hasRole(role, account)) {
973             _roles[role].members[account] = false;
974             emit RoleRevoked(role, account, _msgSender());
975         }
976     }
977 }
978 
979 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
980 
981 
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986  * @dev Library for managing
987  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
988  * types.
989  *
990  * Sets have the following properties:
991  *
992  * - Elements are added, removed, and checked for existence in constant time
993  * (O(1)).
994  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
995  *
996  * ```
997  * contract Example {
998  *     // Add the library methods
999  *     using EnumerableSet for EnumerableSet.AddressSet;
1000  *
1001  *     // Declare a set state variable
1002  *     EnumerableSet.AddressSet private mySet;
1003  * }
1004  * ```
1005  *
1006  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1007  * and `uint256` (`UintSet`) are supported.
1008  */
1009 library EnumerableSet {
1010     // To implement this library for multiple types with as little code
1011     // repetition as possible, we write it in terms of a generic Set type with
1012     // bytes32 values.
1013     // The Set implementation uses private functions, and user-facing
1014     // implementations (such as AddressSet) are just wrappers around the
1015     // underlying Set.
1016     // This means that we can only create new EnumerableSets for types that fit
1017     // in bytes32.
1018 
1019     struct Set {
1020         // Storage of set values
1021         bytes32[] _values;
1022 
1023         // Position of the value in the `values` array, plus 1 because index 0
1024         // means a value is not in the set.
1025         mapping (bytes32 => uint256) _indexes;
1026     }
1027 
1028     /**
1029      * @dev Add a value to a set. O(1).
1030      *
1031      * Returns true if the value was added to the set, that is if it was not
1032      * already present.
1033      */
1034     function _add(Set storage set, bytes32 value) private returns (bool) {
1035         if (!_contains(set, value)) {
1036             set._values.push(value);
1037             // The value is stored at length-1, but we add 1 to all indexes
1038             // and use 0 as a sentinel value
1039             set._indexes[value] = set._values.length;
1040             return true;
1041         } else {
1042             return false;
1043         }
1044     }
1045 
1046     /**
1047      * @dev Removes a value from a set. O(1).
1048      *
1049      * Returns true if the value was removed from the set, that is if it was
1050      * present.
1051      */
1052     function _remove(Set storage set, bytes32 value) private returns (bool) {
1053         // We read and store the value's index to prevent multiple reads from the same storage slot
1054         uint256 valueIndex = set._indexes[value];
1055 
1056         if (valueIndex != 0) { // Equivalent to contains(set, value)
1057             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1058             // the array, and then remove the last element (sometimes called as 'swap and pop').
1059             // This modifies the order of the array, as noted in {at}.
1060 
1061             uint256 toDeleteIndex = valueIndex - 1;
1062             uint256 lastIndex = set._values.length - 1;
1063 
1064             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1065             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1066 
1067             bytes32 lastvalue = set._values[lastIndex];
1068 
1069             // Move the last value to the index where the value to delete is
1070             set._values[toDeleteIndex] = lastvalue;
1071             // Update the index for the moved value
1072             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1073 
1074             // Delete the slot where the moved value was stored
1075             set._values.pop();
1076 
1077             // Delete the index for the deleted slot
1078             delete set._indexes[value];
1079 
1080             return true;
1081         } else {
1082             return false;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns true if the value is in the set. O(1).
1088      */
1089     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1090         return set._indexes[value] != 0;
1091     }
1092 
1093     /**
1094      * @dev Returns the number of values on the set. O(1).
1095      */
1096     function _length(Set storage set) private view returns (uint256) {
1097         return set._values.length;
1098     }
1099 
1100    /**
1101     * @dev Returns the value stored at position `index` in the set. O(1).
1102     *
1103     * Note that there are no guarantees on the ordering of values inside the
1104     * array, and it may change when more values are added or removed.
1105     *
1106     * Requirements:
1107     *
1108     * - `index` must be strictly less than {length}.
1109     */
1110     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1111         require(set._values.length > index, "EnumerableSet: index out of bounds");
1112         return set._values[index];
1113     }
1114 
1115     // Bytes32Set
1116 
1117     struct Bytes32Set {
1118         Set _inner;
1119     }
1120 
1121     /**
1122      * @dev Add a value to a set. O(1).
1123      *
1124      * Returns true if the value was added to the set, that is if it was not
1125      * already present.
1126      */
1127     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1128         return _add(set._inner, value);
1129     }
1130 
1131     /**
1132      * @dev Removes a value from a set. O(1).
1133      *
1134      * Returns true if the value was removed from the set, that is if it was
1135      * present.
1136      */
1137     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1138         return _remove(set._inner, value);
1139     }
1140 
1141     /**
1142      * @dev Returns true if the value is in the set. O(1).
1143      */
1144     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1145         return _contains(set._inner, value);
1146     }
1147 
1148     /**
1149      * @dev Returns the number of values in the set. O(1).
1150      */
1151     function length(Bytes32Set storage set) internal view returns (uint256) {
1152         return _length(set._inner);
1153     }
1154 
1155    /**
1156     * @dev Returns the value stored at position `index` in the set. O(1).
1157     *
1158     * Note that there are no guarantees on the ordering of values inside the
1159     * array, and it may change when more values are added or removed.
1160     *
1161     * Requirements:
1162     *
1163     * - `index` must be strictly less than {length}.
1164     */
1165     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1166         return _at(set._inner, index);
1167     }
1168 
1169     // AddressSet
1170 
1171     struct AddressSet {
1172         Set _inner;
1173     }
1174 
1175     /**
1176      * @dev Add a value to a set. O(1).
1177      *
1178      * Returns true if the value was added to the set, that is if it was not
1179      * already present.
1180      */
1181     function add(AddressSet storage set, address value) internal returns (bool) {
1182         return _add(set._inner, bytes32(uint256(uint160(value))));
1183     }
1184 
1185     /**
1186      * @dev Removes a value from a set. O(1).
1187      *
1188      * Returns true if the value was removed from the set, that is if it was
1189      * present.
1190      */
1191     function remove(AddressSet storage set, address value) internal returns (bool) {
1192         return _remove(set._inner, bytes32(uint256(uint160(value))));
1193     }
1194 
1195     /**
1196      * @dev Returns true if the value is in the set. O(1).
1197      */
1198     function contains(AddressSet storage set, address value) internal view returns (bool) {
1199         return _contains(set._inner, bytes32(uint256(uint160(value))));
1200     }
1201 
1202     /**
1203      * @dev Returns the number of values in the set. O(1).
1204      */
1205     function length(AddressSet storage set) internal view returns (uint256) {
1206         return _length(set._inner);
1207     }
1208 
1209    /**
1210     * @dev Returns the value stored at position `index` in the set. O(1).
1211     *
1212     * Note that there are no guarantees on the ordering of values inside the
1213     * array, and it may change when more values are added or removed.
1214     *
1215     * Requirements:
1216     *
1217     * - `index` must be strictly less than {length}.
1218     */
1219     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1220         return address(uint160(uint256(_at(set._inner, index))));
1221     }
1222 
1223 
1224     // UintSet
1225 
1226     struct UintSet {
1227         Set _inner;
1228     }
1229 
1230     /**
1231      * @dev Add a value to a set. O(1).
1232      *
1233      * Returns true if the value was added to the set, that is if it was not
1234      * already present.
1235      */
1236     function add(UintSet storage set, uint256 value) internal returns (bool) {
1237         return _add(set._inner, bytes32(value));
1238     }
1239 
1240     /**
1241      * @dev Removes a value from a set. O(1).
1242      *
1243      * Returns true if the value was removed from the set, that is if it was
1244      * present.
1245      */
1246     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1247         return _remove(set._inner, bytes32(value));
1248     }
1249 
1250     /**
1251      * @dev Returns true if the value is in the set. O(1).
1252      */
1253     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1254         return _contains(set._inner, bytes32(value));
1255     }
1256 
1257     /**
1258      * @dev Returns the number of values on the set. O(1).
1259      */
1260     function length(UintSet storage set) internal view returns (uint256) {
1261         return _length(set._inner);
1262     }
1263 
1264    /**
1265     * @dev Returns the value stored at position `index` in the set. O(1).
1266     *
1267     * Note that there are no guarantees on the ordering of values inside the
1268     * array, and it may change when more values are added or removed.
1269     *
1270     * Requirements:
1271     *
1272     * - `index` must be strictly less than {length}.
1273     */
1274     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1275         return uint256(_at(set._inner, index));
1276     }
1277 }
1278 
1279 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1280 
1281 
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 
1286 
1287 /**
1288  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1289  */
1290 interface IAccessControlEnumerable {
1291     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1292     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1293 }
1294 
1295 /**
1296  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1297  */
1298 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1299     using EnumerableSet for EnumerableSet.AddressSet;
1300 
1301     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1302 
1303     /**
1304      * @dev See {IERC165-supportsInterface}.
1305      */
1306     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1307         return interfaceId == type(IAccessControlEnumerable).interfaceId
1308             || super.supportsInterface(interfaceId);
1309     }
1310 
1311     /**
1312      * @dev Returns one of the accounts that have `role`. `index` must be a
1313      * value between 0 and {getRoleMemberCount}, non-inclusive.
1314      *
1315      * Role bearers are not sorted in any particular way, and their ordering may
1316      * change at any point.
1317      *
1318      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1319      * you perform all queries on the same block. See the following
1320      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1321      * for more information.
1322      */
1323     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1324         return _roleMembers[role].at(index);
1325     }
1326 
1327     /**
1328      * @dev Returns the number of accounts that have `role`. Can be used
1329      * together with {getRoleMember} to enumerate all bearers of a role.
1330      */
1331     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1332         return _roleMembers[role].length();
1333     }
1334 
1335     /**
1336      * @dev Overload {grantRole} to track enumerable memberships
1337      */
1338     function grantRole(bytes32 role, address account) public virtual override {
1339         super.grantRole(role, account);
1340         _roleMembers[role].add(account);
1341     }
1342 
1343     /**
1344      * @dev Overload {revokeRole} to track enumerable memberships
1345      */
1346     function revokeRole(bytes32 role, address account) public virtual override {
1347         super.revokeRole(role, account);
1348         _roleMembers[role].remove(account);
1349     }
1350 
1351     /**
1352      * @dev Overload {renounceRole} to track enumerable memberships
1353      */
1354     function renounceRole(bytes32 role, address account) public virtual override {
1355         super.renounceRole(role, account);
1356         _roleMembers[role].remove(account);
1357     }
1358 
1359     /**
1360      * @dev Overload {_setupRole} to track enumerable memberships
1361      */
1362     function _setupRole(bytes32 role, address account) internal virtual override {
1363         super._setupRole(role, account);
1364         _roleMembers[role].add(account);
1365     }
1366 }
1367 
1368 // File: contracts/bitcciCash.sol
1369 
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 
1376 /**
1377  * @dev {ERC20} token, including:
1378  *
1379  *  - ability for holders to burn (destroy) their tokens
1380  *  - a minter role that allows for token minting (creation)
1381  *  - a pauser role that allows to stop all token transfers
1382  *
1383  * This contract uses {AccessControl} to lock permissioned functions using the
1384  * different roles - head to its documentation for details.
1385  *
1386  * The account that deploys the contract will be granted the minter and pauser
1387  * roles, as well as the default admin role, which will let it grant both minter
1388  * and pauser roles to other accounts.
1389  */
1390 contract bitcciCash is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable{
1391     uint256 immutable private _cap;
1392     uint8 immutable private _decimals;
1393 
1394     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1395     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1396     bytes32 public constant BLACKLISTED_ROLE = keccak256("BLACKLISTED_ROLE");
1397 
1398     /**
1399      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1400      * account that deploys the contract.
1401      *
1402      * See {ERC20-constructor}.
1403      */
1404      /**
1405      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1406      * set once during construction.
1407      */
1408     constructor(string memory bitcciCashName, string memory bitcciCashSymbol, uint8 decimals_,uint256 cap_) ERC20(bitcciCashName, bitcciCashSymbol) {
1409          require(cap_ > 0, "ERC20Capped: cap is 0");
1410         _cap = cap_;
1411         _decimals = decimals_;
1412         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1413 
1414         _setupRole(MINTER_ROLE, _msgSender());
1415         _setupRole(PAUSER_ROLE, _msgSender());
1416     }
1417 
1418      /**
1419      * @dev Returns the cap on the token's total supply.
1420      */
1421     function cap() public view virtual returns (uint256) {
1422         return _cap;
1423     }
1424     function decimals() public view virtual override returns (uint8) {
1425         return _decimals;
1426     }
1427 
1428     function addBlackListed(address account) public {
1429         grantRole(BLACKLISTED_ROLE, account);
1430     }
1431 
1432     function removeBlackListed(address account) public {
1433         revokeRole(BLACKLISTED_ROLE, account);
1434     }
1435 
1436     function renounceRole(bytes32 role, address account)
1437         public
1438         virtual
1439         override
1440     {
1441         require(role != BLACKLISTED_ROLE, "bitcciCash: cannot renounce blacklisted role");
1442 
1443         super.renounceRole(role, account);
1444     }
1445 
1446     /**
1447      * @dev Creates `amount` new tokens for `to`.
1448      *
1449      * See {ERC20-_mint}.
1450      *
1451      * Requirements:
1452      *
1453      * - the caller must have the `MINTER_ROLE`.
1454      */
1455     function mint(address to, uint256 amount) public virtual {
1456         require(ERC20.totalSupply() + amount <= cap(), "bitcciCash: cap exceeded");
1457         require(hasRole(MINTER_ROLE, _msgSender()), "bitcciCash: must have minter role to mint");
1458         _mint(to, amount);
1459     }
1460 
1461     /**
1462      * @dev Pauses all token transfers.
1463      *
1464      * See {ERC20Pausable} and {Pausable-_pause}.
1465      *
1466      * Requirements:
1467      *
1468      * - the caller must have the `PAUSER_ROLE`.
1469      */
1470     function pause() public virtual {
1471         require(hasRole(PAUSER_ROLE, _msgSender()), "bitcciCash: must have pauser role to pause");
1472         _pause();
1473     }
1474 
1475     /**
1476      * @dev Unpauses all token transfers.
1477      *
1478      * See {ERC20Pausable} and {Pausable-_unpause}.
1479      *
1480      * Requirements:
1481      *
1482      * - the caller must have the `PAUSER_ROLE`.
1483      */
1484     function unpause() public virtual {
1485         require(hasRole(PAUSER_ROLE, _msgSender()), "bitcciCash: must have pauser role to unpause");
1486         _unpause();
1487     }
1488 
1489     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1490          require(!(hasRole(BLACKLISTED_ROLE, msg.sender)), "bitcciCash: sender is Blacklisted");
1491          require(!(hasRole(BLACKLISTED_ROLE, to)),"bitcciCash: receiver is Blacklisted");
1492         super._beforeTokenTransfer(from, to, amount);
1493     }
1494 }