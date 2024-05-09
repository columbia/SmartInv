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
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 
93 
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 
116 
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
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
228 
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * We have followed general OpenZeppelin Contracts guidelines: functions revert
242  * instead returning `false` on failure. This behavior is nonetheless
243  * conventional and does not conflict with the expectations of ERC20
244  * applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     mapping(address => uint256) private _balances;
257 
258     mapping(address => mapping(address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264 
265     /**
266      * @dev Sets the values for {name} and {symbol}.
267      *
268      * The default value of {decimals} is 18. To select a different value for
269      * {decimals} you should overload it.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the value {ERC20} uses, unless this function is
301      * overridden;
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view virtual override returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(_msgSender(), recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view virtual override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public virtual override returns (bool) {
353         _approve(_msgSender(), spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20}.
362      *
363      * Requirements:
364      *
365      * - `sender` and `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      * - the caller must have allowance for ``sender``'s tokens of at least
368      * `amount`.
369      */
370     function transferFrom(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         _transfer(sender, recipient, amount);
376 
377         uint256 currentAllowance = _allowances[sender][_msgSender()];
378         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
379         unchecked {
380             _approve(sender, _msgSender(), currentAllowance - amount);
381         }
382 
383         return true;
384     }
385 
386     /**
387      * @dev Atomically increases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
400         return true;
401     }
402 
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         uint256 currentAllowance = _allowances[_msgSender()][spender];
419         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
420         unchecked {
421             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * @dev Moves `amount` of tokens from `sender` to `recipient`.
429      *
430      * This internal function is equivalent to {transfer}, and can be used to
431      * e.g. implement automatic token fees, slashing mechanisms, etc.
432      *
433      * Emits a {Transfer} event.
434      *
435      * Requirements:
436      *
437      * - `sender` cannot be the zero address.
438      * - `recipient` cannot be the zero address.
439      * - `sender` must have a balance of at least `amount`.
440      */
441     function _transfer(
442         address sender,
443         address recipient,
444         uint256 amount
445     ) internal virtual {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(sender, recipient, amount);
450 
451         uint256 senderBalance = _balances[sender];
452         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
453         unchecked {
454             _balances[sender] = senderBalance - amount;
455         }
456         _balances[recipient] += amount;
457 
458         emit Transfer(sender, recipient, amount);
459 
460         _afterTokenTransfer(sender, recipient, amount);
461     }
462 
463     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
464      * the total supply.
465      *
466      * Emits a {Transfer} event with `from` set to the zero address.
467      *
468      * Requirements:
469      *
470      * - `account` cannot be the zero address.
471      */
472     function _mint(address account, uint256 amount) internal virtual {
473         require(account != address(0), "ERC20: mint to the zero address");
474 
475         _beforeTokenTransfer(address(0), account, amount);
476 
477         _totalSupply += amount;
478         _balances[account] += amount;
479         emit Transfer(address(0), account, amount);
480 
481         _afterTokenTransfer(address(0), account, amount);
482     }
483 
484     /**
485      * @dev Destroys `amount` tokens from `account`, reducing the
486      * total supply.
487      *
488      * Emits a {Transfer} event with `to` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      * - `account` must have at least `amount` tokens.
494      */
495     function _burn(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: burn from the zero address");
497 
498         _beforeTokenTransfer(account, address(0), amount);
499 
500         uint256 accountBalance = _balances[account];
501         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
502         unchecked {
503             _balances[account] = accountBalance - amount;
504         }
505         _totalSupply -= amount;
506 
507         emit Transfer(account, address(0), amount);
508 
509         _afterTokenTransfer(account, address(0), amount);
510     }
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
514      *
515      * This internal function is equivalent to `approve`, and can be used to
516      * e.g. set automatic allowances for certain subsystems, etc.
517      *
518      * Emits an {Approval} event.
519      *
520      * Requirements:
521      *
522      * - `owner` cannot be the zero address.
523      * - `spender` cannot be the zero address.
524      */
525     function _approve(
526         address owner,
527         address spender,
528         uint256 amount
529     ) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Hook that is called before any transfer of tokens. This includes
539      * minting and burning.
540      *
541      * Calling conditions:
542      *
543      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
544      * will be transferred to `to`.
545      * - when `from` is zero, `amount` tokens will be minted for `to`.
546      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
547      * - `from` and `to` are never both zero.
548      *
549      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
550      */
551     function _beforeTokenTransfer(
552         address from,
553         address to,
554         uint256 amount
555     ) internal virtual {}
556 
557     /**
558      * @dev Hook that is called after any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * has been transferred to `to`.
565      * - when `from` is zero, `amount` tokens have been minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _afterTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 }
577 
578 
579 
580 
581 
582 
583 /**
584  * @dev Contract module which provides a basic access control mechanism, where
585  * there is an account (an owner) that can be granted exclusive access to
586  * specific functions.
587  *
588  * By default, the owner account will be the one that deploys the contract. This
589  * can later be changed with {transferOwnership}.
590  *
591  * This module is used through inheritance. It will make available the modifier
592  * `onlyOwner`, which can be applied to your functions to restrict their use to
593  * the owner.
594  */
595 abstract contract Ownable is Context {
596     address private _owner;
597 
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599 
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor() {
604         _setOwner(_msgSender());
605     }
606 
607     /**
608      * @dev Returns the address of the current owner.
609      */
610     function owner() public view virtual returns (address) {
611         return _owner;
612     }
613 
614     /**
615      * @dev Throws if called by any account other than the owner.
616      */
617     modifier onlyOwner() {
618         require(owner() == _msgSender(), "Ownable: caller is not the owner");
619         _;
620     }
621 
622     /**
623      * @dev Leaves the contract without owner. It will not be possible to call
624      * `onlyOwner` functions anymore. Can only be called by the current owner.
625      *
626      * NOTE: Renouncing ownership will leave the contract without an owner,
627      * thereby removing any functionality that is only available to the owner.
628      */
629     function renounceOwnership() public virtual onlyOwner {
630         _setOwner(address(0));
631     }
632 
633     /**
634      * @dev Transfers ownership of the contract to a new account (`newOwner`).
635      * Can only be called by the current owner.
636      */
637     function transferOwnership(address newOwner) public virtual onlyOwner {
638         require(newOwner != address(0), "Ownable: new owner is the zero address");
639         _setOwner(newOwner);
640     }
641 
642     function _setOwner(address newOwner) private {
643         address oldOwner = _owner;
644         _owner = newOwner;
645         emit OwnershipTransferred(oldOwner, newOwner);
646     }
647 }
648 
649 
650 
651 
652 
653 
654 
655 
656 
657 
658 
659 
660 /**
661  * @dev External interface of AccessControl declared to support ERC165 detection.
662  */
663 interface IAccessControl {
664     /**
665      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
666      *
667      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
668      * {RoleAdminChanged} not being emitted signaling this.
669      *
670      * _Available since v3.1._
671      */
672     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
673 
674     /**
675      * @dev Emitted when `account` is granted `role`.
676      *
677      * `sender` is the account that originated the contract call, an admin role
678      * bearer except when using {AccessControl-_setupRole}.
679      */
680     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
681 
682     /**
683      * @dev Emitted when `account` is revoked `role`.
684      *
685      * `sender` is the account that originated the contract call:
686      *   - if using `revokeRole`, it is the admin role bearer
687      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
688      */
689     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
690 
691     /**
692      * @dev Returns `true` if `account` has been granted `role`.
693      */
694     function hasRole(bytes32 role, address account) external view returns (bool);
695 
696     /**
697      * @dev Returns the admin role that controls `role`. See {grantRole} and
698      * {revokeRole}.
699      *
700      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
701      */
702     function getRoleAdmin(bytes32 role) external view returns (bytes32);
703 
704     /**
705      * @dev Grants `role` to `account`.
706      *
707      * If `account` had not been already granted `role`, emits a {RoleGranted}
708      * event.
709      *
710      * Requirements:
711      *
712      * - the caller must have ``role``'s admin role.
713      */
714     function grantRole(bytes32 role, address account) external;
715 
716     /**
717      * @dev Revokes `role` from `account`.
718      *
719      * If `account` had been granted `role`, emits a {RoleRevoked} event.
720      *
721      * Requirements:
722      *
723      * - the caller must have ``role``'s admin role.
724      */
725     function revokeRole(bytes32 role, address account) external;
726 
727     /**
728      * @dev Revokes `role` from the calling account.
729      *
730      * Roles are often managed via {grantRole} and {revokeRole}: this function's
731      * purpose is to provide a mechanism for accounts to lose their privileges
732      * if they are compromised (such as when a trusted device is misplaced).
733      *
734      * If the calling account had been granted `role`, emits a {RoleRevoked}
735      * event.
736      *
737      * Requirements:
738      *
739      * - the caller must be `account`.
740      */
741     function renounceRole(bytes32 role, address account) external;
742 }
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 /**
753  * @dev Implementation of the {IERC165} interface.
754  *
755  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
756  * for the additional interface id that will be supported. For example:
757  *
758  * ```solidity
759  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
760  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
761  * }
762  * ```
763  *
764  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
765  */
766 abstract contract ERC165 is IERC165 {
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771         return interfaceId == type(IERC165).interfaceId;
772     }
773 }
774 
775 
776 /**
777  * @dev Contract module that allows children to implement role-based access
778  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
779  * members except through off-chain means by accessing the contract event logs. Some
780  * applications may benefit from on-chain enumerability, for those cases see
781  * {AccessControlEnumerable}.
782  *
783  * Roles are referred to by their `bytes32` identifier. These should be exposed
784  * in the external API and be unique. The best way to achieve this is by
785  * using `public constant` hash digests:
786  *
787  * ```
788  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
789  * ```
790  *
791  * Roles can be used to represent a set of permissions. To restrict access to a
792  * function call, use {hasRole}:
793  *
794  * ```
795  * function foo() public {
796  *     require(hasRole(MY_ROLE, msg.sender));
797  *     ...
798  * }
799  * ```
800  *
801  * Roles can be granted and revoked dynamically via the {grantRole} and
802  * {revokeRole} functions. Each role has an associated admin role, and only
803  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
804  *
805  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
806  * that only accounts with this role will be able to grant or revoke other
807  * roles. More complex role relationships can be created by using
808  * {_setRoleAdmin}.
809  *
810  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
811  * grant and revoke this role. Extra precautions should be taken to secure
812  * accounts that have been granted it.
813  */
814 abstract contract AccessControl is Context, IAccessControl, ERC165 {
815     struct RoleData {
816         mapping(address => bool) members;
817         bytes32 adminRole;
818     }
819 
820     mapping(bytes32 => RoleData) private _roles;
821 
822     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
823 
824     /**
825      * @dev Modifier that checks that an account has a specific role. Reverts
826      * with a standardized message including the required role.
827      *
828      * The format of the revert reason is given by the following regular expression:
829      *
830      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
831      *
832      * _Available since v4.1._
833      */
834     modifier onlyRole(bytes32 role) {
835         _checkRole(role, _msgSender());
836         _;
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
843         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
844     }
845 
846     /**
847      * @dev Returns `true` if `account` has been granted `role`.
848      */
849     function hasRole(bytes32 role, address account) public view override returns (bool) {
850         return _roles[role].members[account];
851     }
852 
853     /**
854      * @dev Revert with a standard message if `account` is missing `role`.
855      *
856      * The format of the revert reason is given by the following regular expression:
857      *
858      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
859      */
860     function _checkRole(bytes32 role, address account) internal view {
861         if (!hasRole(role, account)) {
862             revert(
863                 string(
864                     abi.encodePacked(
865                         "AccessControl: account ",
866                         Strings.toHexString(uint160(account), 20),
867                         " is missing role ",
868                         Strings.toHexString(uint256(role), 32)
869                     )
870                 )
871             );
872         }
873     }
874 
875     /**
876      * @dev Returns the admin role that controls `role`. See {grantRole} and
877      * {revokeRole}.
878      *
879      * To change a role's admin, use {_setRoleAdmin}.
880      */
881     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
882         return _roles[role].adminRole;
883     }
884 
885     /**
886      * @dev Grants `role` to `account`.
887      *
888      * If `account` had not been already granted `role`, emits a {RoleGranted}
889      * event.
890      *
891      * Requirements:
892      *
893      * - the caller must have ``role``'s admin role.
894      */
895     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
896         _grantRole(role, account);
897     }
898 
899     /**
900      * @dev Revokes `role` from `account`.
901      *
902      * If `account` had been granted `role`, emits a {RoleRevoked} event.
903      *
904      * Requirements:
905      *
906      * - the caller must have ``role``'s admin role.
907      */
908     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
909         _revokeRole(role, account);
910     }
911 
912     /**
913      * @dev Revokes `role` from the calling account.
914      *
915      * Roles are often managed via {grantRole} and {revokeRole}: this function's
916      * purpose is to provide a mechanism for accounts to lose their privileges
917      * if they are compromised (such as when a trusted device is misplaced).
918      *
919      * If the calling account had been granted `role`, emits a {RoleRevoked}
920      * event.
921      *
922      * Requirements:
923      *
924      * - the caller must be `account`.
925      */
926     function renounceRole(bytes32 role, address account) public virtual override {
927         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
928 
929         _revokeRole(role, account);
930     }
931 
932     /**
933      * @dev Grants `role` to `account`.
934      *
935      * If `account` had not been already granted `role`, emits a {RoleGranted}
936      * event. Note that unlike {grantRole}, this function doesn't perform any
937      * checks on the calling account.
938      *
939      * [WARNING]
940      * ====
941      * This function should only be called from the constructor when setting
942      * up the initial roles for the system.
943      *
944      * Using this function in any other way is effectively circumventing the admin
945      * system imposed by {AccessControl}.
946      * ====
947      */
948     function _setupRole(bytes32 role, address account) internal virtual {
949         _grantRole(role, account);
950     }
951 
952     /**
953      * @dev Sets `adminRole` as ``role``'s admin role.
954      *
955      * Emits a {RoleAdminChanged} event.
956      */
957     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
958         bytes32 previousAdminRole = getRoleAdmin(role);
959         _roles[role].adminRole = adminRole;
960         emit RoleAdminChanged(role, previousAdminRole, adminRole);
961     }
962 
963     function _grantRole(bytes32 role, address account) private {
964         if (!hasRole(role, account)) {
965             _roles[role].members[account] = true;
966             emit RoleGranted(role, account, _msgSender());
967         }
968     }
969 
970     function _revokeRole(bytes32 role, address account) private {
971         if (hasRole(role, account)) {
972             _roles[role].members[account] = false;
973             emit RoleRevoked(role, account, _msgSender());
974         }
975     }
976 }
977 
978 
979 
980 
981 
982 
983 /**
984  * @title SupportsInterfaceWithLookup
985  * @dev Implements ERC165 using a lookup table.
986  */
987 contract SupportsInterfaceWithLookup is AccessControl {
988 
989   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
990   /**
991    * 0x01ffc9a7 ===
992    *   bytes4(keccak256('supportsInterface(bytes4)'))
993    */
994 
995   /**
996    * @dev a mapping of interface id to whether or not it's supported
997    */
998   mapping(bytes4 => bool) internal supportedInterfaces;
999 
1000   /**
1001    * @dev A contract implementing SupportsInterfaceWithLookup
1002    * implement ERC165 itself
1003    */
1004   constructor() {
1005     _registerInterface(InterfaceId_ERC165);
1006   }
1007 
1008   /**
1009    * @dev implement supportsInterface(bytes4) using a lookup table
1010    */
1011   function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
1012     return super.supportsInterface(_interfaceId) || supportedInterfaces[_interfaceId];
1013   }
1014 
1015   /**
1016    * @dev private method for registering an interface
1017    */
1018   function _registerInterface(bytes4 _interfaceId) internal {
1019     require(_interfaceId != 0xffffffff);
1020     supportedInterfaces[_interfaceId] = true;
1021   }
1022 }
1023 
1024 
1025 /**
1026  * @title Issuable
1027  * @dev The Issuable contract defines the issuer role who can perform certain kind of actions
1028  * even if he is not the owner.
1029  * An issuer can transfer his role to a new address.
1030  */
1031 contract Issuable is Ownable, SupportsInterfaceWithLookup {
1032   bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
1033 
1034   /**
1035    * @dev Throws if called by any account that's not a issuer.
1036    */
1037   modifier onlyIssuer() {
1038     require(isIssuer(_msgSender()), 'Issuable: caller is not the issuer');
1039     _;
1040   }
1041 
1042   modifier onlyOwnerOrIssuer() {
1043     require(_msgSender() == owner() || isIssuer(_msgSender()), 'Issuable: caller is not the issuer or the owner');
1044     _;
1045   }
1046 
1047   /**
1048    * @dev getter to determine if address has issuer role
1049    */
1050   function isIssuer(address _operator) public view returns (bool) {
1051     return hasRole(ISSUER_ROLE, _operator);
1052   }
1053 
1054   /**
1055    * @dev add a new issuer address
1056    * @param _operator address
1057    */
1058   function addIssuer(address _operator) public onlyOwner {
1059     grantRole(ISSUER_ROLE, _operator);
1060   }
1061 
1062   /**
1063    * @dev remove an address from issuers
1064    * @param _operator address
1065    */
1066   function removeIssuer(address _operator) public onlyOwner {
1067     revokeRole(ISSUER_ROLE, _operator);
1068   }
1069 
1070   /**
1071    * @dev Allows the current issuer to transfer his role to a newIssuer.
1072    * @param _newIssuer The address to transfer the issuer role to.
1073    */
1074   function transferIssuer(address _newIssuer) public onlyIssuer {
1075     require(_newIssuer != address(0));
1076     revokeRole(ISSUER_ROLE, _msgSender());
1077     grantRole(ISSUER_ROLE, _newIssuer);
1078   }
1079 
1080 }
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 // CAUTION
1092 // This version of SafeMath should only be used with Solidity 0.8 or later,
1093 // because it relies on the compiler's built in overflow checks.
1094 
1095 /**
1096  * @dev Wrappers over Solidity's arithmetic operations.
1097  *
1098  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1099  * now has built in overflow checking.
1100  */
1101 library SafeMath {
1102     /**
1103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1104      *
1105      * _Available since v3.4._
1106      */
1107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1108         unchecked {
1109             uint256 c = a + b;
1110             if (c < a) return (false, 0);
1111             return (true, c);
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1117      *
1118      * _Available since v3.4._
1119      */
1120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1121         unchecked {
1122             if (b > a) return (false, 0);
1123             return (true, a - b);
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1129      *
1130      * _Available since v3.4._
1131      */
1132     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1133         unchecked {
1134             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1135             // benefit is lost if 'b' is also tested.
1136             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1137             if (a == 0) return (true, 0);
1138             uint256 c = a * b;
1139             if (c / a != b) return (false, 0);
1140             return (true, c);
1141         }
1142     }
1143 
1144     /**
1145      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1146      *
1147      * _Available since v3.4._
1148      */
1149     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1150         unchecked {
1151             if (b == 0) return (false, 0);
1152             return (true, a / b);
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1158      *
1159      * _Available since v3.4._
1160      */
1161     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1162         unchecked {
1163             if (b == 0) return (false, 0);
1164             return (true, a % b);
1165         }
1166     }
1167 
1168     /**
1169      * @dev Returns the addition of two unsigned integers, reverting on
1170      * overflow.
1171      *
1172      * Counterpart to Solidity's `+` operator.
1173      *
1174      * Requirements:
1175      *
1176      * - Addition cannot overflow.
1177      */
1178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1179         return a + b;
1180     }
1181 
1182     /**
1183      * @dev Returns the subtraction of two unsigned integers, reverting on
1184      * overflow (when the result is negative).
1185      *
1186      * Counterpart to Solidity's `-` operator.
1187      *
1188      * Requirements:
1189      *
1190      * - Subtraction cannot overflow.
1191      */
1192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1193         return a - b;
1194     }
1195 
1196     /**
1197      * @dev Returns the multiplication of two unsigned integers, reverting on
1198      * overflow.
1199      *
1200      * Counterpart to Solidity's `*` operator.
1201      *
1202      * Requirements:
1203      *
1204      * - Multiplication cannot overflow.
1205      */
1206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1207         return a * b;
1208     }
1209 
1210     /**
1211      * @dev Returns the integer division of two unsigned integers, reverting on
1212      * division by zero. The result is rounded towards zero.
1213      *
1214      * Counterpart to Solidity's `/` operator.
1215      *
1216      * Requirements:
1217      *
1218      * - The divisor cannot be zero.
1219      */
1220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1221         return a / b;
1222     }
1223 
1224     /**
1225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1226      * reverting when dividing by zero.
1227      *
1228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1229      * opcode (which leaves remaining gas untouched) while Solidity uses an
1230      * invalid opcode to revert (consuming all remaining gas).
1231      *
1232      * Requirements:
1233      *
1234      * - The divisor cannot be zero.
1235      */
1236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1237         return a % b;
1238     }
1239 
1240     /**
1241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1242      * overflow (when the result is negative).
1243      *
1244      * CAUTION: This function is deprecated because it requires allocating memory for the error
1245      * message unnecessarily. For custom revert reasons use {trySub}.
1246      *
1247      * Counterpart to Solidity's `-` operator.
1248      *
1249      * Requirements:
1250      *
1251      * - Subtraction cannot overflow.
1252      */
1253     function sub(
1254         uint256 a,
1255         uint256 b,
1256         string memory errorMessage
1257     ) internal pure returns (uint256) {
1258         unchecked {
1259             require(b <= a, errorMessage);
1260             return a - b;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1266      * division by zero. The result is rounded towards zero.
1267      *
1268      * Counterpart to Solidity's `/` operator. Note: this function uses a
1269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1270      * uses an invalid opcode to revert (consuming all remaining gas).
1271      *
1272      * Requirements:
1273      *
1274      * - The divisor cannot be zero.
1275      */
1276     function div(
1277         uint256 a,
1278         uint256 b,
1279         string memory errorMessage
1280     ) internal pure returns (uint256) {
1281         unchecked {
1282             require(b > 0, errorMessage);
1283             return a / b;
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1289      * reverting with custom message when dividing by zero.
1290      *
1291      * CAUTION: This function is deprecated because it requires allocating memory for the error
1292      * message unnecessarily. For custom revert reasons use {tryMod}.
1293      *
1294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1295      * opcode (which leaves remaining gas untouched) while Solidity uses an
1296      * invalid opcode to revert (consuming all remaining gas).
1297      *
1298      * Requirements:
1299      *
1300      * - The divisor cannot be zero.
1301      */
1302     function mod(
1303         uint256 a,
1304         uint256 b,
1305         string memory errorMessage
1306     ) internal pure returns (uint256) {
1307         unchecked {
1308             require(b > 0, errorMessage);
1309             return a % b;
1310         }
1311     }
1312 }
1313 
1314 
1315 abstract contract NokuCustomTokenLite {
1316     using SafeMath for uint256;
1317 
1318     /**
1319     * @dev Presence of this function indicates the contract is a Custom Token Lite.
1320     */
1321     function isCustomTokenLite() public pure returns(bool) {
1322         return true;
1323     }
1324 
1325 }
1326 
1327 
1328 
1329 
1330 
1331 
1332 
1333 
1334 
1335 
1336 
1337 
1338 
1339 
1340 
1341 
1342 /**
1343  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1344  * tokens and those that they have an allowance for, in a way that can be
1345  * recognized off-chain (via event analysis).
1346  */
1347 abstract contract ERC20Burnable is Context, ERC20 {
1348     /**
1349      * @dev Destroys `amount` tokens from the caller.
1350      *
1351      * See {ERC20-_burn}.
1352      */
1353     function burn(uint256 amount) public virtual {
1354         _burn(_msgSender(), amount);
1355     }
1356 
1357     /**
1358      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1359      * allowance.
1360      *
1361      * See {ERC20-_burn} and {ERC20-allowance}.
1362      *
1363      * Requirements:
1364      *
1365      * - the caller must have allowance for ``accounts``'s tokens of at least
1366      * `amount`.
1367      */
1368     function burnFrom(address account, uint256 amount) public virtual {
1369         uint256 currentAllowance = allowance(account, _msgSender());
1370         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1371         unchecked {
1372             _approve(account, _msgSender(), currentAllowance - amount);
1373         }
1374         _burn(account, amount);
1375     }
1376 }
1377 
1378 
1379 
1380 abstract contract ERC20BurnableWithFinish is Ownable, ERC20Burnable {
1381 
1382     event LogBurnFinished();
1383 
1384     // Flag indicating if Custom Token burning has been permanently finished or not.
1385     bool public burningFinished;
1386 
1387     modifier canBurn() {
1388         require(!burningFinished, "burning finished");
1389         _;
1390     }
1391 
1392     /**
1393     * @dev Stop burning new tokens.
1394     * @return true if the operation was successful.
1395     */
1396     function finishBurning() public onlyOwner canBurn returns(bool) {
1397         burningFinished = true;
1398         emit LogBurnFinished();
1399         return true;
1400     }
1401 
1402     function burn(uint256 amount) public override virtual canBurn {
1403         super.burn(amount);
1404     }
1405 
1406     function burnFrom(address account, uint256 amount) public override virtual canBurn {
1407         super.burnFrom(account, amount);
1408     }
1409 
1410 }
1411 
1412 
1413 
1414 
1415 
1416 
1417 
1418 
1419 /**
1420  * @title Mintable token
1421  */
1422 abstract contract ERC20Mintable is Context, Ownable, ERC20 {
1423   event Mint(address indexed to, uint256 amount);
1424   event MintFinished();
1425 
1426   bool public mintingFinished = false;
1427 
1428   modifier canMint() {
1429     require(!mintingFinished);
1430     _;
1431   }
1432 
1433   modifier hasMintPermission() {
1434     require(_msgSender() == owner());
1435     _;
1436   }
1437 
1438   /**
1439    * @dev Function to mint tokens
1440    * @param _to The address that will receive the minted tokens.
1441    * @param _amount The amount of tokens to mint.
1442    */
1443   function mint(address _to, uint256 _amount) virtual hasMintPermission canMint public {
1444     _mint(_to, _amount);
1445   }
1446 
1447   /**
1448    * @dev Function to stop minting new tokens.
1449    * @return True if the operation was successful.
1450    */
1451   function finishMinting() onlyOwner canMint public returns (bool) {
1452     mintingFinished = true;
1453     emit MintFinished();
1454     return true;
1455   }
1456 }
1457 
1458 
1459 
1460 
1461 
1462 
1463 /**
1464  * @title Frozenlist
1465  * @dev The Frozenlist contract has a frozen list of addresses, and provides basic authorization control functions.
1466  * This simplifies the implementation of "user permissions".
1467  */
1468 contract Frozenlist is Issuable {
1469 
1470   event FundsFrozen(address target);
1471   bytes32 public constant FROZENLISTED_ROLE = keccak256("FROZENLISTED_ROLE");
1472 
1473   /**
1474    * @dev Throws if operator is frozen.
1475    * @param _operator address
1476    */
1477   modifier onlyIfNotFrozen(address _operator) {
1478     require(!hasRole(FROZENLISTED_ROLE, _operator), "Account frozen");
1479     _;
1480   }
1481 
1482   /**
1483    * @dev add an address to the frozenlist
1484    * @param _operator address
1485    */
1486   function addAddressToFrozenlist(address _operator) public onlyIssuer {
1487     grantRole(FROZENLISTED_ROLE, _operator);
1488     emit FundsFrozen(_operator);
1489   }
1490 
1491   /**
1492    * @dev getter to determine if address is in frozenlist
1493    */
1494   function frozenlist(address _operator) public view returns (bool) {
1495     return hasRole(FROZENLISTED_ROLE, _operator);
1496   }
1497 
1498   /**
1499    * @dev add addresses to the frozenlist
1500    * @param _operators addresses
1501    */
1502   function addAddressesToFrozenlist(address[] memory _operators) public onlyIssuer {
1503     for (uint256 i = 0; i < _operators.length; i++) {
1504       addAddressToFrozenlist(_operators[i]);
1505     }
1506   }
1507 
1508   /**
1509    * @dev remove an address from the frozenlist
1510    * @param _operator address
1511    */
1512   function removeAddressFromFrozenlist(address _operator) public onlyIssuer {
1513     revokeRole(FROZENLISTED_ROLE, _operator);
1514   }
1515 
1516   /**
1517    * @dev remove addresses from the frozenlist
1518    * @param _operators addresses
1519    */
1520   function removeAddressesFromFrozenlist(address[] memory _operators) public onlyIssuer {
1521     for (uint256 i = 0; i < _operators.length; i++) {
1522       removeAddressFromFrozenlist(_operators[i]);
1523     }
1524   }
1525 
1526 }
1527 
1528 
1529 
1530 
1531 
1532 
1533 /**
1534  * @title Whitelist
1535  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1536  * This simplifies the implementation of "user permissions".
1537     By default whitelist in not enabled.
1538  */
1539 contract Whitelist is Issuable {
1540   bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");
1541 
1542   bool public whitelistEnabled;
1543 
1544   constructor(bool _enableWhitelist) {
1545       whitelistEnabled = _enableWhitelist;
1546   }
1547 
1548   /**
1549    * @dev Throws if operator is not whitelisted and whitelist is enabled.
1550    * @param _operator address
1551    */
1552   modifier onlyIfWhitelisted(address _operator) {
1553     if(whitelistEnabled) {
1554       require(hasRole(WHITELISTED_ROLE, _operator), "Account not whitelisted");
1555     }
1556     _;
1557   }
1558 
1559   function enableWhitelist() public onlyOwner {
1560     whitelistEnabled = true;
1561   }
1562 
1563   function disableWhitelist() public onlyOwner {
1564     whitelistEnabled = false;
1565   }
1566 
1567   /**
1568    * @dev add an address to the whitelist
1569    * @param _operator address
1570    */
1571   function addAddressToWhitelist(address _operator) public onlyIssuer {
1572     grantRole(WHITELISTED_ROLE, _operator);
1573   }
1574 
1575   /**
1576    * @dev getter to determine if address is in whitelist
1577    */
1578   function whitelist(address _operator) public view returns (bool) {
1579     return hasRole(WHITELISTED_ROLE, _operator);
1580   }
1581 
1582   /**
1583    * @dev add addresses to the whitelist
1584    * @param _operators addresses
1585    */
1586   function addAddressesToWhitelist(address[] memory _operators) public onlyIssuer {
1587     for (uint256 i = 0; i < _operators.length; i++) {
1588       addAddressToWhitelist(_operators[i]);
1589     }
1590   }
1591 
1592   /**
1593    * @dev remove an address from the whitelist
1594    * @param _operator address
1595    */
1596   function removeAddressFromWhitelist(address _operator) public onlyIssuer {
1597     revokeRole(WHITELISTED_ROLE, _operator);
1598   }
1599 
1600   /**
1601    * @dev remove addresses from the whitelist
1602    * @param _operators addresses
1603    */
1604   function removeAddressesFromWhitelist(address[] memory _operators) public onlyIssuer {
1605     for (uint256 i = 0; i < _operators.length; i++) {
1606       removeAddressFromWhitelist(_operators[i]);
1607     }
1608   }
1609 
1610 }
1611 
1612 
1613 contract BasicSecurityToken is ERC20BurnableWithFinish, ERC20Mintable, Frozenlist, Whitelist {
1614 
1615     /// @dev This emits when funds are reassigned
1616     event FundsReassigned(address from, address to, uint256 amount);
1617 
1618     /// @dev This emits when funds are revoked
1619     event FundsRevoked(address from, uint256 amount);
1620 
1621     bytes4 internal constant InterfaceId_BasicSecurityToken = 0x4d1e390c;
1622     /**
1623     * 0x4d1e390c ===
1624     *   bytes4(keccak256('revoke(address)')) ^
1625     *   bytes4(keccak256('reassign(address,address)')) ^
1626     *   bytes4(keccak256('frozenlist(address)'))
1627     */
1628 
1629     constructor(string memory name, string memory symbol, bool enableWhitelist)
1630     Ownable()
1631     ERC20(name, symbol)
1632     Whitelist(enableWhitelist) {
1633         require(bytes(name).length > 0, "name is empty");
1634         require(bytes(symbol).length > 0, "symbol is empty");
1635 
1636         _registerInterface(InterfaceId_BasicSecurityToken);
1637         _setupRole(DEFAULT_ADMIN_ROLE, owner());
1638         addIssuer(owner());
1639         if(enableWhitelist) {
1640             addAddressToWhitelist(owner());
1641         }
1642     }
1643 
1644     function decimals() public view virtual override returns (uint8) {
1645         return 0;
1646     }
1647 
1648     //Public functions (place the view and pure functions last)
1649     function mint(address account, uint256 amount) override public onlyOwner onlyIfNotFrozen(account) onlyIfWhitelisted(account) {
1650         super.mint(account, amount);
1651     }
1652 
1653     function transfer(address recipient, uint256 amount) override public onlyIfNotFrozen(_msgSender()) onlyIfNotFrozen(recipient) onlyIfWhitelisted(recipient) returns (bool) {
1654         require(super.transfer(recipient, amount), "Transfer failed");
1655 
1656         return true;
1657     }
1658 
1659     function transferFrom(address sender, address recipient, uint256 amount) override public onlyIfNotFrozen(sender) onlyIfNotFrozen(recipient) onlyIfWhitelisted(recipient) returns (bool) {
1660         require(super.transferFrom(sender, recipient, amount), "Transfer failed");
1661 
1662         return true;
1663     }
1664 
1665     function reassign(address from, address to) public onlyIssuer {
1666         uint256 fundsReassigned = balanceOf(from);
1667         _transfer(from, to, fundsReassigned);
1668 
1669         emit FundsReassigned(from, to, fundsReassigned);
1670     }
1671 
1672     function reassign(address from, address to, uint256 amount) public onlyIssuer {
1673         _transfer(from, to, amount);
1674 
1675         emit FundsReassigned(from, to, amount);
1676     }
1677 
1678     function revoke(address from) public onlyIssuer {
1679         uint256 fundsRevoked = balanceOf(from);
1680         _transfer(from, _msgSender(), fundsRevoked);
1681 
1682         emit FundsRevoked(from, fundsRevoked);
1683     }
1684 
1685     function revoke(address from, uint256 amount) public onlyIssuer {
1686         _transfer(from, _msgSender(), amount);
1687 
1688         emit FundsRevoked(from, amount);
1689     }
1690 
1691     function transferOwnership(address _newOwner) override public onlyOwner {
1692         if(isIssuer(owner())) {
1693             if(whitelistEnabled) {
1694                 removeAddressFromWhitelist(owner());
1695                 addAddressToWhitelist(_newOwner);
1696             }
1697             transferIssuer(_newOwner);
1698         }
1699         _setupRole(DEFAULT_ADMIN_ROLE, _newOwner);
1700         renounceRole(DEFAULT_ADMIN_ROLE, owner());
1701         super.transferOwnership(_newOwner);
1702     }
1703 
1704     function renounceOwnership() override public onlyOwner {        
1705         if(whitelistEnabled) {
1706             removeAddressFromWhitelist(owner());
1707         }
1708         removeIssuer(owner());
1709         renounceRole(DEFAULT_ADMIN_ROLE, owner());
1710         super.renounceOwnership();
1711     }
1712     //Private functions
1713 
1714 }
1715 
1716 contract BasicSecurityTokenWithDecimals is BasicSecurityToken {
1717 
1718     uint8 private __decimals;
1719     bytes4 internal constant InterfaceId_BasicSecurityTokenWithDecimals = 0x7c22dc6b;
1720     /**
1721     * 0x7c22dc6b ===
1722     *   bytes4(keccak256('decimals()')) ^
1723     *   bytes4(keccak256('revoke(address)')) ^
1724     *   bytes4(keccak256('reassign(address,address)')) ^
1725     *   bytes4(keccak256('frozenlist(address)'))
1726     */
1727 
1728     constructor(string memory name, string memory symbol, uint8 _decimals, bool enableWhitelist)
1729     BasicSecurityToken(name, symbol, enableWhitelist) {
1730         _registerInterface(InterfaceId_BasicSecurityTokenWithDecimals);
1731         __decimals = _decimals;
1732     }
1733 
1734     function decimals() public view virtual override returns (uint8) {
1735         return __decimals;
1736     }
1737 
1738 }
1739 
1740 /**
1741 * @dev The NokuCustomERC20AdvancedToken contract is a custom ERC20AdvancedLite, a security token ERC20-compliant, token available in the Noku Service Platform (NSP).
1742 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
1743 * by minting or burning tokens in order to increase or decrease the token supply.
1744 */
1745 contract NokuCustomERC20AdvancedLite is NokuCustomTokenLite, BasicSecurityTokenWithDecimals {
1746 
1747     event LogNokuCustomERC20AdvancedLiteCreated(
1748         address indexed caller,
1749         string indexed name,
1750         string indexed symbol,
1751         uint8 decimals
1752     );
1753     
1754     constructor(
1755         string memory _name,
1756         string memory _symbol,
1757         uint8 _decimals,
1758         bool _enableWhitelist
1759     )
1760     NokuCustomTokenLite()
1761     BasicSecurityTokenWithDecimals(_name, _symbol, _decimals, _enableWhitelist) {
1762         emit LogNokuCustomERC20AdvancedLiteCreated(
1763             _msgSender(),
1764             _name,
1765             _symbol,
1766             _decimals
1767         );
1768     }
1769 
1770 }