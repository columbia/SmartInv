1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 pragma solidity 0.8.0;
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
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
119 
120 /*
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
141 
142 /**
143  * @dev Implementation of the {IERC20} interface.
144  *
145  * This implementation is agnostic to the way tokens are created. This means
146  * that a supply mechanism has to be added in a derived contract using {_mint}.
147  * For a generic mechanism see {ERC20PresetMinterPauser}.
148  *
149  * TIP: For a detailed writeup see our guide
150  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
151  * to implement supply mechanisms].
152  *
153  * We have followed general OpenZeppelin guidelines: functions revert instead
154  * of returning `false` on failure. This behavior is nonetheless conventional
155  * and does not conflict with the expectations of ERC20 applications.
156  *
157  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
158  * This allows applications to reconstruct the allowance for all accounts just
159  * by listening to said events. Other implementations of the EIP may not emit
160  * these events, as it isn't required by the specification.
161  *
162  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
163  * functions have been added to mitigate the well-known issues around setting
164  * allowances. See {IERC20-approve}.
165  */
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping(address => uint256) private _balances;
168 
169     mapping(address => mapping(address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * The default value of {decimals} is 18. To select a different value for
180      * {decimals} you should overload it.
181      *
182      * All two of these values are immutable: they can only be set once during
183      * construction.
184      */
185     constructor(string memory name_, string memory symbol_) {
186         _name = name_;
187         _symbol = symbol_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
209      *
210      * Tokens usually opt for a value of 18, imitating the relationship between
211      * Ether and Wei. This is the value {ERC20} uses, unless this function is
212      * overridden;
213      *
214      * NOTE: This information is only used for _display_ purposes: it in
215      * no way affects any of the arithmetic of the contract, including
216      * {IERC20-balanceOf} and {IERC20-transfer}.
217      */
218     function decimals() public view virtual override returns (uint8) {
219         return 18;
220     }
221 
222     /**
223      * @dev See {IERC20-totalSupply}.
224      */
225     function totalSupply() public view virtual override returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See {IERC20-balanceOf}.
231      */
232     function balanceOf(address account)
233         public
234         view
235         virtual
236         override
237         returns (uint256)
238     {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount)
251         public
252         virtual
253         override
254         returns (bool)
255     {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender)
264         public
265         view
266         virtual
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount)
281         public
282         virtual
283         override
284         returns (bool)
285     {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309 
310         uint256 currentAllowance = _allowances[sender][_msgSender()];
311         require(
312             currentAllowance >= amount,
313             "ERC20: transfer amount exceeds allowance"
314         );
315         unchecked {
316             _approve(sender, _msgSender(), currentAllowance - amount);
317         }
318 
319         return true;
320     }
321 
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue)
335         public
336         virtual
337         returns (bool)
338     {
339         _approve(
340             _msgSender(),
341             spender,
342             _allowances[_msgSender()][spender] + addedValue
343         );
344         return true;
345     }
346 
347     /**
348      * @dev Atomically decreases the allowance granted to `spender` by the caller.
349      *
350      * This is an alternative to {approve} that can be used as a mitigation for
351      * problems described in {IERC20-approve}.
352      *
353      * Emits an {Approval} event indicating the updated allowance.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      * - `spender` must have allowance for the caller of at least
359      * `subtractedValue`.
360      */
361     function decreaseAllowance(address spender, uint256 subtractedValue)
362         public
363         virtual
364         returns (bool)
365     {
366         uint256 currentAllowance = _allowances[_msgSender()][spender];
367         require(
368             currentAllowance >= subtractedValue,
369             "ERC20: decreased allowance below zero"
370         );
371         unchecked {
372             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
373         }
374 
375         return true;
376     }
377 
378     /**
379      * @dev Moves `amount` of tokens from `sender` to `recipient`.
380      *
381      * This internal function is equivalent to {transfer}, and can be used to
382      * e.g. implement automatic token fees, slashing mechanisms, etc.
383      *
384      * Emits a {Transfer} event.
385      *
386      * Requirements:
387      *
388      * - `sender` cannot be the zero address.
389      * - `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      */
392     function _transfer(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) internal virtual {
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         _beforeTokenTransfer(sender, recipient, amount);
401 
402         uint256 senderBalance = _balances[sender];
403         require(
404             senderBalance >= amount,
405             "ERC20: transfer amount exceeds balance"
406         );
407         unchecked {
408             _balances[sender] = senderBalance - amount;
409         }
410         _balances[recipient] += amount;
411 
412         emit Transfer(sender, recipient, amount);
413 
414         _afterTokenTransfer(sender, recipient, amount);
415     }
416 
417     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
418      * the total supply.
419      *
420      * Emits a {Transfer} event with `from` set to the zero address.
421      *
422      * Requirements:
423      *
424      * - `account` cannot be the zero address.
425      */
426     function _mint(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: mint to the zero address");
428 
429         _beforeTokenTransfer(address(0), account, amount);
430 
431         _totalSupply += amount;
432         _balances[account] += amount;
433         emit Transfer(address(0), account, amount);
434 
435         _afterTokenTransfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal virtual {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _beforeTokenTransfer(account, address(0), amount);
453 
454         uint256 accountBalance = _balances[account];
455         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
456         unchecked {
457             _balances[account] = accountBalance - amount;
458         }
459         _totalSupply -= amount;
460 
461         emit Transfer(account, address(0), amount);
462 
463         _afterTokenTransfer(account, address(0), amount);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
468      *
469      * This internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(
480         address owner,
481         address spender,
482         uint256 amount
483     ) internal virtual {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     /**
492      * @dev Hook that is called before any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * will be transferred to `to`.
499      * - when `from` is zero, `amount` tokens will be minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _beforeTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 
511     /**
512      * @dev Hook that is called after any transfer of tokens. This includes
513      * minting and burning.
514      *
515      * Calling conditions:
516      *
517      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518      * has been transferred to `to`.
519      * - when `from` is zero, `amount` tokens have been minted for `to`.
520      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
521      * - `from` and `to` are never both zero.
522      *
523      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524      */
525     function _afterTokenTransfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal virtual {}
530 }
531 
532 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.2.0
533 
534 /**
535  * @dev Extension of {ERC20} that allows token holders to destroy both their own
536  * tokens and those that they have an allowance for, in a way that can be
537  * recognized off-chain (via event analysis).
538  */
539 abstract contract ERC20Burnable is Context, ERC20 {
540     /**
541      * @dev Destroys `amount` tokens from the caller.
542      *
543      * See {ERC20-_burn}.
544      */
545     function burn(uint256 amount) public virtual {
546         _burn(_msgSender(), amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
551      * allowance.
552      *
553      * See {ERC20-_burn} and {ERC20-allowance}.
554      *
555      * Requirements:
556      *
557      * - the caller must have allowance for ``accounts``'s tokens of at least
558      * `amount`.
559      */
560     function burnFrom(address account, uint256 amount) public virtual {
561         uint256 currentAllowance = allowance(account, _msgSender());
562         require(
563             currentAllowance >= amount,
564             "ERC20: burn amount exceeds allowance"
565         );
566         unchecked {
567             _approve(account, _msgSender(), currentAllowance - amount);
568         }
569         _burn(account, amount);
570     }
571 }
572 
573 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
574 
575 /**
576  * @dev String operations.
577  */
578 library Strings {
579     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
583      */
584     function toString(uint256 value) internal pure returns (string memory) {
585         // Inspired by OraclizeAPI's implementation - MIT licence
586         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
587 
588         if (value == 0) {
589             return "0";
590         }
591         uint256 temp = value;
592         uint256 digits;
593         while (temp != 0) {
594             digits++;
595             temp /= 10;
596         }
597         bytes memory buffer = new bytes(digits);
598         while (value != 0) {
599             digits -= 1;
600             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
601             value /= 10;
602         }
603         return string(buffer);
604     }
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
608      */
609     function toHexString(uint256 value) internal pure returns (string memory) {
610         if (value == 0) {
611             return "0x00";
612         }
613         uint256 temp = value;
614         uint256 length = 0;
615         while (temp != 0) {
616             length++;
617             temp >>= 8;
618         }
619         return toHexString(value, length);
620     }
621 
622     /**
623      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
624      */
625     function toHexString(uint256 value, uint256 length)
626         internal
627         pure
628         returns (string memory)
629     {
630         bytes memory buffer = new bytes(2 * length + 2);
631         buffer[0] = "0";
632         buffer[1] = "x";
633         for (uint256 i = 2 * length + 1; i > 1; --i) {
634             buffer[i] = _HEX_SYMBOLS[value & 0xf];
635             value >>= 4;
636         }
637         require(value == 0, "Strings: hex length insufficient");
638         return string(buffer);
639     }
640 }
641 
642 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
643 
644 /**
645  * @dev Interface of the ERC165 standard, as defined in the
646  * https://eips.ethereum.org/EIPS/eip-165[EIP].
647  *
648  * Implementers can declare support of contract interfaces, which can then be
649  * queried by others ({ERC165Checker}).
650  *
651  * For an implementation, see {ERC165}.
652  */
653 interface IERC165 {
654     /**
655      * @dev Returns true if this contract implements the interface defined by
656      * `interfaceId`. See the corresponding
657      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
658      * to learn more about how these ids are created.
659      *
660      * This function call must use less than 30 000 gas.
661      */
662     function supportsInterface(bytes4 interfaceId) external view returns (bool);
663 }
664 
665 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
666 
667 /**
668  * @dev Implementation of the {IERC165} interface.
669  *
670  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
671  * for the additional interface id that will be supported. For example:
672  *
673  * ```solidity
674  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
676  * }
677  * ```
678  *
679  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
680  */
681 abstract contract ERC165 is IERC165 {
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId)
686         public
687         view
688         virtual
689         override
690         returns (bool)
691     {
692         return interfaceId == type(IERC165).interfaceId;
693     }
694 }
695 
696 // File @openzeppelin/contracts/access/AccessControl.sol@v4.2.0
697 
698 /**
699  * @dev External interface of AccessControl declared to support ERC165 detection.
700  */
701 interface IAccessControl {
702     function hasRole(bytes32 role, address account)
703         external
704         view
705         returns (bool);
706 
707     function getRoleAdmin(bytes32 role) external view returns (bytes32);
708 
709     function grantRole(bytes32 role, address account) external;
710 
711     function revokeRole(bytes32 role, address account) external;
712 
713     function renounceRole(bytes32 role, address account) external;
714 }
715 
716 /**
717  * @dev Contract module that allows children to implement role-based access
718  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
719  * members except through off-chain means by accessing the contract event logs. Some
720  * applications may benefit from on-chain enumerability, for those cases see
721  * {AccessControlEnumerable}.
722  *
723  * Roles are referred to by their `bytes32` identifier. These should be exposed
724  * in the external API and be unique. The best way to achieve this is by
725  * using `public constant` hash digests:
726  *
727  * ```
728  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
729  * ```
730  *
731  * Roles can be used to represent a set of permissions. To restrict access to a
732  * function call, use {hasRole}:
733  *
734  * ```
735  * function foo() public {
736  *     require(hasRole(MY_ROLE, msg.sender));
737  *     ...
738  * }
739  * ```
740  *
741  * Roles can be granted and revoked dynamically via the {grantRole} and
742  * {revokeRole} functions. Each role has an associated admin role, and only
743  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
744  *
745  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
746  * that only accounts with this role will be able to grant or revoke other
747  * roles. More complex role relationships can be created by using
748  * {_setRoleAdmin}.
749  *
750  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
751  * grant and revoke this role. Extra precautions should be taken to secure
752  * accounts that have been granted it.
753  */
754 abstract contract AccessControl is Context, IAccessControl, ERC165 {
755     struct RoleData {
756         mapping(address => bool) members;
757         bytes32 adminRole;
758     }
759 
760     mapping(bytes32 => RoleData) private _roles;
761 
762     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
763 
764     /**
765      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
766      *
767      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
768      * {RoleAdminChanged} not being emitted signaling this.
769      *
770      * _Available since v3.1._
771      */
772     event RoleAdminChanged(
773         bytes32 indexed role,
774         bytes32 indexed previousAdminRole,
775         bytes32 indexed newAdminRole
776     );
777 
778     /**
779      * @dev Emitted when `account` is granted `role`.
780      *
781      * `sender` is the account that originated the contract call, an admin role
782      * bearer except when using {_setupRole}.
783      */
784     event RoleGranted(
785         bytes32 indexed role,
786         address indexed account,
787         address indexed sender
788     );
789 
790     /**
791      * @dev Emitted when `account` is revoked `role`.
792      *
793      * `sender` is the account that originated the contract call:
794      *   - if using `revokeRole`, it is the admin role bearer
795      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
796      */
797     event RoleRevoked(
798         bytes32 indexed role,
799         address indexed account,
800         address indexed sender
801     );
802 
803     /**
804      * @dev Modifier that checks that an account has a specific role. Reverts
805      * with a standardized message including the required role.
806      *
807      * The format of the revert reason is given by the following regular expression:
808      *
809      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
810      *
811      * _Available since v4.1._
812      */
813     modifier onlyRole(bytes32 role) {
814         _checkRole(role, _msgSender());
815         _;
816     }
817 
818     /**
819      * @dev See {IERC165-supportsInterface}.
820      */
821     function supportsInterface(bytes4 interfaceId)
822         public
823         view
824         virtual
825         override
826         returns (bool)
827     {
828         return
829             interfaceId == type(IAccessControl).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev Returns `true` if `account` has been granted `role`.
835      */
836     function hasRole(bytes32 role, address account)
837         public
838         view
839         override
840         returns (bool)
841     {
842         return _roles[role].members[account];
843     }
844 
845     /**
846      * @dev Revert with a standard message if `account` is missing `role`.
847      *
848      * The format of the revert reason is given by the following regular expression:
849      *
850      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
851      */
852     function _checkRole(bytes32 role, address account) internal view {
853         if (!hasRole(role, account)) {
854             revert(
855                 string(
856                     abi.encodePacked(
857                         "AccessControl: account ",
858                         Strings.toHexString(uint160(account), 20),
859                         " is missing role ",
860                         Strings.toHexString(uint256(role), 32)
861                     )
862                 )
863             );
864         }
865     }
866 
867     /**
868      * @dev Returns the admin role that controls `role`. See {grantRole} and
869      * {revokeRole}.
870      *
871      * To change a role's admin, use {_setRoleAdmin}.
872      */
873     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
874         return _roles[role].adminRole;
875     }
876 
877     /**
878      * @dev Grants `role` to `account`.
879      *
880      * If `account` had not been already granted `role`, emits a {RoleGranted}
881      * event.
882      *
883      * Requirements:
884      *
885      * - the caller must have ``role``'s admin role.
886      */
887     function grantRole(bytes32 role, address account)
888         public
889         virtual
890         override
891         onlyRole(getRoleAdmin(role))
892     {
893         _grantRole(role, account);
894     }
895 
896     /**
897      * @dev Revokes `role` from `account`.
898      *
899      * If `account` had been granted `role`, emits a {RoleRevoked} event.
900      *
901      * Requirements:
902      *
903      * - the caller must have ``role``'s admin role.
904      */
905     function revokeRole(bytes32 role, address account)
906         public
907         virtual
908         override
909         onlyRole(getRoleAdmin(role))
910     {
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
928     function renounceRole(bytes32 role, address account)
929         public
930         virtual
931         override
932     {
933         require(
934             account == _msgSender(),
935             "AccessControl: can only renounce roles for self"
936         );
937 
938         _revokeRole(role, account);
939     }
940 
941     /**
942      * @dev Grants `role` to `account`.
943      *
944      * If `account` had not been already granted `role`, emits a {RoleGranted}
945      * event. Note that unlike {grantRole}, this function doesn't perform any
946      * checks on the calling account.
947      *
948      * [WARNING]
949      * ====
950      * This function should only be called from the constructor when setting
951      * up the initial roles for the system.
952      *
953      * Using this function in any other way is effectively circumventing the admin
954      * system imposed by {AccessControl}.
955      * ====
956      */
957     function _setupRole(bytes32 role, address account) internal virtual {
958         _grantRole(role, account);
959     }
960 
961     /**
962      * @dev Sets `adminRole` as ``role``'s admin role.
963      *
964      * Emits a {RoleAdminChanged} event.
965      */
966     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
967         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
968         _roles[role].adminRole = adminRole;
969     }
970 
971     function _grantRole(bytes32 role, address account) private {
972         if (!hasRole(role, account)) {
973             _roles[role].members[account] = true;
974             emit RoleGranted(role, account, _msgSender());
975         }
976     }
977 
978     function _revokeRole(bytes32 role, address account) private {
979         if (hasRole(role, account)) {
980             _roles[role].members[account] = false;
981             emit RoleRevoked(role, account, _msgSender());
982         }
983     }
984 }
985 
986 // File contracts/BridgeBank/IbcToken.sol
987 
988 /**
989  * @title IbcToken
990  * @dev Mintable, ERC20Burnable, ERC20 compatible BankToken for use by BridgeBank
991  **/
992 contract IbcToken is ERC20Burnable, AccessControl {
993     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
994 
995     /**
996      * @dev Number of decimals this token uses
997      */
998     uint8 private _decimals;
999 
1000     /**
1001      * @dev The Cosmos denom of this token
1002      */
1003     string public cosmosDenom;
1004 
1005     constructor(
1006         string memory _name,
1007         string memory _symbol,
1008         uint8 _tokenDecimals,
1009         string memory _cosmosDenom
1010     ) ERC20(_name, _symbol) {
1011         _decimals = _tokenDecimals;
1012         cosmosDenom = _cosmosDenom;
1013         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1014     }
1015 
1016     /**
1017      * @notice If sender is a Minter, mints `amount` to `user`
1018      * @param user Address of the recipient
1019      * @param amount How much should be minted
1020      * @return true if the operation succeeds
1021      */
1022     function mint(address user, uint256 amount)
1023         external
1024         onlyRole(MINTER_ROLE)
1025         returns (bool)
1026     {
1027         _mint(user, amount);
1028         return true;
1029     }
1030 
1031     /**
1032      * @notice Number of decimals this token has
1033      */
1034     function decimals() public view override returns (uint8) {
1035         return _decimals;
1036     }
1037 
1038     /**
1039      * @notice Sets the cosmosDenom
1040      * @param denom The new cosmos denom
1041      * @return true if the operation succeeds
1042      */
1043     function setDenom(string calldata denom)
1044         external
1045         onlyRole(DEFAULT_ADMIN_ROLE)
1046         returns (bool)
1047     {
1048         cosmosDenom = denom;
1049         return true;
1050     }
1051 }