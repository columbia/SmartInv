1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25  
26 /**
27  * @dev Standard math utilities missing in the Solidity language.
28  */
29 library Math {
30     /**
31      * @dev Returns the largest of two numbers.
32      */
33     function max(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a >= b ? a : b;
35     }
36 
37     /**
38      * @dev Returns the smallest of two numbers.
39      */
40     function min(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 
44     /**
45      * @dev Returns the average of two numbers. The result is rounded towards
46      * zero.
47      */
48     function average(uint256 a, uint256 b) internal pure returns (uint256) {
49         // (a + b) / 2 can overflow, so we distribute
50         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
51     }
52 }
53 
54 
55 
56 /**
57  * @dev Collection of functions related to array types.
58  */
59 library Arrays {
60    /**
61      * @dev Searches a sorted `array` and returns the first index that contains
62      * a value greater or equal to `element`. If no such index exists (i.e. all
63      * values in the array are strictly less than `element`), the array length is
64      * returned. Time complexity O(log n).
65      *
66      * `array` is expected to be sorted in ascending order, and to contain no
67      * repeated elements.
68      */
69     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
70         if (array.length == 0) {
71             return 0;
72         }
73 
74         uint256 low = 0;
75         uint256 high = array.length;
76 
77         while (low < high) {
78             uint256 mid = Math.average(low, high);
79 
80             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
81             // because Math.average rounds down (it does integer division with truncation).
82             if (array[mid] > element) {
83                 high = mid;
84             } else {
85                 low = mid + 1;
86             }
87         }
88 
89         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
90         if (low > 0 && array[low - 1] == element) {
91             return low - 1;
92         } else {
93             return low;
94         }
95     }
96 }
97 
98  
99 /**
100  * @title Counters
101  * @author Matt Condon (@shrugs)
102  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
103  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
104  *
105  * Include with `using Counters for Counters.Counter;`
106  */
107 library Counters {
108     struct Counter {
109         // This variable should never be directly accessed by users of the library: interactions must be restricted to
110         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
111         // this feature: see https://github.com/ethereum/solidity/issues/4637
112         uint256 _value; // default: 0
113     }
114 
115     function current(Counter storage counter) internal view returns (uint256) {
116         return counter._value;
117     }
118 
119     function increment(Counter storage counter) internal {
120         unchecked {
121             counter._value += 1;
122         }
123     }
124 
125     function decrement(Counter storage counter) internal {
126         uint256 value = counter._value;
127         require(value > 0, "Counter: decrement overflow");
128         unchecked {
129             counter._value = value - 1;
130         }
131     }
132 }
133 
134 
135 
136 
137 contract Initializable {
138     bool inited = false;
139 
140     modifier initializer() {
141         require(!inited, "already inited");
142         _;
143         inited = true;
144     }
145 }
146 
147 
148 
149 abstract contract IERC677Receiver {
150   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public virtual;
151 }
152 
153 
154 
155 /**
156  * @dev Interface of the ERC165 standard, as defined in the
157  * https://eips.ethereum.org/EIPS/eip-165[EIP].
158  *
159  * Implementers can declare support of contract interfaces, which can then be
160  * queried by others ({ERC165Checker}).
161  *
162  * For an implementation, see {ERC165}.
163  */
164 interface IERC165 {
165     /**
166      * @dev Returns true if this contract implements the interface defined by
167      * `interfaceId`. See the corresponding
168      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
169      * to learn more about how these ids are created.
170      *
171      * This function call must use less than 30 000 gas.
172      */
173     function supportsInterface(bytes4 interfaceId) external view returns (bool);
174 }
175 
176 
177 
178 
179 
180  
181 /**
182  * @dev Implementation of the {IERC165} interface.
183  *
184  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
185  * for the additional interface id that will be supported. For example:
186  *
187  * ```solidity
188  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
189  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
190  * }
191  * ```
192  *
193  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
194  */
195 abstract contract ERC165 is IERC165 {
196     /**
197      * @dev See {IERC165-supportsInterface}.
198      */
199     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
200         return interfaceId == type(IERC165).interfaceId;
201     }
202 }
203 
204 
205 
206  
207 /**
208  * @dev Interface of the ERC20 standard as defined in the EIP.
209  */
210 interface IERC20 {
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `recipient`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address recipient, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Returns the remaining number of tokens that `spender` will be
232      * allowed to spend on behalf of `owner` through {transferFrom}. This is
233      * zero by default.
234      *
235      * This value changes when {approve} or {transferFrom} are called.
236      */
237     function allowance(address owner, address spender) external view returns (uint256);
238 
239     /**
240      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * IMPORTANT: Beware that changing an allowance with this method brings the risk
245      * that someone may use both the old and the new allowance by unfortunate
246      * transaction ordering. One possible solution to mitigate this race
247      * condition is to first reduce the spender's allowance to 0 and set the
248      * desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Moves `amount` tokens from `sender` to `recipient` using the
257      * allowance mechanism. `amount` is then deducted from the caller's
258      * allowance.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 
282 
283 contract EIP712Base is Initializable {
284     struct EIP712Domain {
285         string name;
286         string version;
287         address verifyingContract;
288         bytes32 salt;
289     }
290 
291     string constant public ERC712_VERSION = "1";
292 
293     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
294         bytes(
295             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
296         )
297     );
298     bytes32 internal domainSeperator;
299 
300     function _initializeEIP712(string memory name) internal initializer {
301         _setDomainSeperator(name);
302     }
303 
304     function _setDomainSeperator(string memory name) internal {
305         domainSeperator = keccak256(
306             abi.encode(
307                 EIP712_DOMAIN_TYPEHASH,
308                 keccak256(bytes(name)),
309                 keccak256(bytes(ERC712_VERSION)),
310                 address(this),
311                 bytes32(getChainId())
312             )
313         );
314     }
315 
316     function getDomainSeperator() public view returns (bytes32) {
317         return domainSeperator;
318     }
319 
320     function getChainId() public view returns (uint256) {
321         uint256 id;
322         assembly {
323             id := chainid()
324         }
325         return id;
326     }
327 
328     /**
329      * Accept message hash and returns hash message in EIP712 compatible form
330      * So that it can be used to recover signer from signature signed using EIP712 formatted data
331      * https://eips.ethereum.org/EIPS/eip-712
332      * "\\x19" makes the encoding deterministic
333      * "\\x01" is the version byte to make it compatible to EIP-191
334      */
335     function toTypedMessageHash(bytes32 messageHash)
336         internal
337         view
338         returns (bytes32)
339     {
340         return
341             keccak256(
342                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
343             );
344     }
345 }
346 
347 
348  
349  
350  
351 /**
352  * @dev Implementation of the {IERC20} interface.
353  *
354  * This implementation is agnostic to the way tokens are created. This means
355  * that a supply mechanism has to be added in a derived contract using {_mint}.
356  * For a generic mechanism see {ERC20PresetMinterPauser}.
357  *
358  * TIP: For a detailed writeup see our guide
359  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
360  * to implement supply mechanisms].
361  *
362  * We have followed general OpenZeppelin guidelines: functions revert instead
363  * of returning `false` on failure. This behavior is nonetheless conventional
364  * and does not conflict with the expectations of ERC20 applications.
365  *
366  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
367  * This allows applications to reconstruct the allowance for all accounts just
368  * by listening to said events. Other implementations of the EIP may not emit
369  * these events, as it isn't required by the specification.
370  *
371  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
372  * functions have been added to mitigate the well-known issues around setting
373  * allowances. See {IERC20-approve}.
374  */
375 contract ERC20 is Context, IERC20 {
376     mapping (address => uint256) private _balances;
377 
378     mapping (address => mapping (address => uint256)) private _allowances;
379 
380     uint256 private _totalSupply;
381 
382     string private _name;
383     string private _symbol;
384 
385     /**
386      * @dev Sets the values for {name} and {symbol}.
387      *
388      * The defaut value of {decimals} is 18. To select a different value for
389      * {decimals} you should overload it.
390      *
391      * All three of these values are immutable: they can only be set once during
392      * construction.
393      */
394     constructor (string memory name_, string memory symbol_) {
395         _name = name_;
396         _symbol = symbol_;
397     }
398 
399     /**
400      * @dev Returns the name of the token.
401      */
402     function name() public view virtual returns (string memory) {
403         return _name;
404     }
405 
406     /**
407      * @dev Returns the symbol of the token, usually a shorter version of the
408      * name.
409      */
410     function symbol() public view virtual returns (string memory) {
411         return _symbol;
412     }
413 
414     /**
415      * @dev Returns the number of decimals used to get its user representation.
416      * For example, if `decimals` equals `2`, a balance of `505` tokens should
417      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
418      *
419      * Tokens usually opt for a value of 18, imitating the relationship between
420      * Ether and Wei. This is the value {ERC20} uses, unless this function is
421      * overloaded;
422      *
423      * NOTE: This information is only used for _display_ purposes: it in
424      * no way affects any of the arithmetic of the contract, including
425      * {IERC20-balanceOf} and {IERC20-transfer}.
426      */
427     function decimals() public view virtual returns (uint8) {
428         return 18;
429     }
430 
431     /**
432      * @dev See {IERC20-totalSupply}.
433      */
434     function totalSupply() public view virtual override returns (uint256) {
435         return _totalSupply;
436     }
437 
438     /**
439      * @dev See {IERC20-balanceOf}.
440      */
441     function balanceOf(address account) public view virtual override returns (uint256) {
442         return _balances[account];
443     }
444 
445     /**
446      * @dev See {IERC20-transfer}.
447      *
448      * Requirements:
449      *
450      * - `recipient` cannot be the zero address.
451      * - the caller must have a balance of at least `amount`.
452      */
453     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
454         _transfer(_msgSender(), recipient, amount);
455         return true;
456     }
457 
458     /**
459      * @dev See {IERC20-allowance}.
460      */
461     function allowance(address owner, address spender) public view virtual override returns (uint256) {
462         return _allowances[owner][spender];
463     }
464 
465     /**
466      * @dev See {IERC20-approve}.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function approve(address spender, uint256 amount) public virtual override returns (bool) {
473         _approve(_msgSender(), spender, amount);
474         return true;
475     }
476 
477     /**
478      * @dev See {IERC20-transferFrom}.
479      *
480      * Emits an {Approval} event indicating the updated allowance. This is not
481      * required by the EIP. See the note at the beginning of {ERC20}.
482      *
483      * Requirements:
484      *
485      * - `sender` and `recipient` cannot be the zero address.
486      * - `sender` must have a balance of at least `amount`.
487      * - the caller must have allowance for ``sender``'s tokens of at least
488      * `amount`.
489      */
490     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
491         _transfer(sender, recipient, amount);
492 
493         uint256 currentAllowance = _allowances[sender][_msgSender()];
494         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
495         _approve(sender, _msgSender(), currentAllowance - amount);
496 
497         return true;
498     }
499 
500     /**
501      * @dev Atomically increases the allowance granted to `spender` by the caller.
502      *
503      * This is an alternative to {approve} that can be used as a mitigation for
504      * problems described in {IERC20-approve}.
505      *
506      * Emits an {Approval} event indicating the updated allowance.
507      *
508      * Requirements:
509      *
510      * - `spender` cannot be the zero address.
511      */
512     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
514         return true;
515     }
516 
517     /**
518      * @dev Atomically decreases the allowance granted to `spender` by the caller.
519      *
520      * This is an alternative to {approve} that can be used as a mitigation for
521      * problems described in {IERC20-approve}.
522      *
523      * Emits an {Approval} event indicating the updated allowance.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      * - `spender` must have allowance for the caller of at least
529      * `subtractedValue`.
530      */
531     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
532         uint256 currentAllowance = _allowances[_msgSender()][spender];
533         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
534         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
535 
536         return true;
537     }
538 
539     /**
540      * @dev Moves tokens `amount` from `sender` to `recipient`.
541      *
542      * This is internal function is equivalent to {transfer}, and can be used to
543      * e.g. implement automatic token fees, slashing mechanisms, etc.
544      *
545      * Emits a {Transfer} event.
546      *
547      * Requirements:
548      *
549      * - `sender` cannot be the zero address.
550      * - `recipient` cannot be the zero address.
551      * - `sender` must have a balance of at least `amount`.
552      */
553     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
554         require(sender != address(0), "ERC20: transfer from the zero address");
555         require(recipient != address(0), "ERC20: transfer to the zero address");
556 
557         _beforeTokenTransfer(sender, recipient, amount);
558 
559         uint256 senderBalance = _balances[sender];
560         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
561         _balances[sender] = senderBalance - amount;
562         _balances[recipient] += amount;
563 
564         emit Transfer(sender, recipient, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements:
573      *
574      * - `to` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _beforeTokenTransfer(address(0), account, amount);
580 
581         _totalSupply += amount;
582         _balances[account] += amount;
583         emit Transfer(address(0), account, amount);
584     }
585 
586     /**
587      * @dev Destroys `amount` tokens from `account`, reducing the
588      * total supply.
589      *
590      * Emits a {Transfer} event with `to` set to the zero address.
591      *
592      * Requirements:
593      *
594      * - `account` cannot be the zero address.
595      * - `account` must have at least `amount` tokens.
596      */
597     function _burn(address account, uint256 amount) internal virtual {
598         require(account != address(0), "ERC20: burn from the zero address");
599 
600         _beforeTokenTransfer(account, address(0), amount);
601 
602         uint256 accountBalance = _balances[account];
603         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
604         _balances[account] = accountBalance - amount;
605         _totalSupply -= amount;
606 
607         emit Transfer(account, address(0), amount);
608     }
609 
610     /**
611      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
612      *
613      * This internal function is equivalent to `approve`, and can be used to
614      * e.g. set automatic allowances for certain subsystems, etc.
615      *
616      * Emits an {Approval} event.
617      *
618      * Requirements:
619      *
620      * - `owner` cannot be the zero address.
621      * - `spender` cannot be the zero address.
622      */
623     function _approve(address owner, address spender, uint256 amount) internal virtual {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     /**
632      * @dev Hook that is called before any transfer of tokens. This includes
633      * minting and burning.
634      *
635      * Calling conditions:
636      *
637      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
638      * will be to transferred to `to`.
639      * - when `from` is zero, `amount` tokens will be minted for `to`.
640      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
646 }
647 
648 
649 
650  
651 /**
652  * @dev External interface of AccessControl declared to support ERC165 detection.
653  */
654 interface IAccessControl {
655     function hasRole(bytes32 role, address account) external view returns (bool);
656     function getRoleAdmin(bytes32 role) external view returns (bytes32);
657     function grantRole(bytes32 role, address account) external;
658     function revokeRole(bytes32 role, address account) external;
659     function renounceRole(bytes32 role, address account) external;
660 }
661 
662 /**
663  * @dev Contract module that allows children to implement role-based access
664  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
665  * members except through off-chain means by accessing the contract event logs. Some
666  * applications may benefit from on-chain enumerability, for those cases see
667  * {AccessControlEnumerable}.
668  *
669  * Roles are referred to by their `bytes32` identifier. These should be exposed
670  * in the external API and be unique. The best way to achieve this is by
671  * using `public constant` hash digests:
672  *
673  * ```
674  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
675  * ```
676  *
677  * Roles can be used to represent a set of permissions. To restrict access to a
678  * function call, use {hasRole}:
679  *
680  * ```
681  * function foo() public {
682  *     require(hasRole(MY_ROLE, msg.sender));
683  *     ...
684  * }
685  * ```
686  *
687  * Roles can be granted and revoked dynamically via the {grantRole} and
688  * {revokeRole} functions. Each role has an associated admin role, and only
689  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
690  *
691  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
692  * that only accounts with this role will be able to grant or revoke other
693  * roles. More complex role relationships can be created by using
694  * {_setRoleAdmin}.
695  *
696  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
697  * grant and revoke this role. Extra precautions should be taken to secure
698  * accounts that have been granted it.
699  */
700 abstract contract AccessControl is Context, IAccessControl, ERC165 {
701     struct RoleData {
702         mapping (address => bool) members;
703         bytes32 adminRole;
704     }
705 
706     mapping (bytes32 => RoleData) private _roles;
707 
708     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
709 
710     /**
711      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
712      *
713      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
714      * {RoleAdminChanged} not being emitted signaling this.
715      *
716      * _Available since v3.1._
717      */
718     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
719 
720     /**
721      * @dev Emitted when `account` is granted `role`.
722      *
723      * `sender` is the account that originated the contract call, an admin role
724      * bearer except when using {_setupRole}.
725      */
726     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
727 
728     /**
729      * @dev Emitted when `account` is revoked `role`.
730      *
731      * `sender` is the account that originated the contract call:
732      *   - if using `revokeRole`, it is the admin role bearer
733      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
734      */
735     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
736 
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         return interfaceId == type(IAccessControl).interfaceId
742             || super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev Returns `true` if `account` has been granted `role`.
747      */
748     function hasRole(bytes32 role, address account) public view override returns (bool) {
749         return _roles[role].members[account];
750     }
751 
752     /**
753      * @dev Returns the admin role that controls `role`. See {grantRole} and
754      * {revokeRole}.
755      *
756      * To change a role's admin, use {_setRoleAdmin}.
757      */
758     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
759         return _roles[role].adminRole;
760     }
761 
762     /**
763      * @dev Grants `role` to `account`.
764      *
765      * If `account` had not been already granted `role`, emits a {RoleGranted}
766      * event.
767      *
768      * Requirements:
769      *
770      * - the caller must have ``role``'s admin role.
771      */
772     function grantRole(bytes32 role, address account) public virtual override {
773         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
774 
775         _grantRole(role, account);
776     }
777 
778     /**
779      * @dev Revokes `role` from `account`.
780      *
781      * If `account` had been granted `role`, emits a {RoleRevoked} event.
782      *
783      * Requirements:
784      *
785      * - the caller must have ``role``'s admin role.
786      */
787     function revokeRole(bytes32 role, address account) public virtual override {
788         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
789 
790         _revokeRole(role, account);
791     }
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
807     function renounceRole(bytes32 role, address account) public virtual override {
808         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
809 
810         _revokeRole(role, account);
811     }
812 
813     /**
814      * @dev Grants `role` to `account`.
815      *
816      * If `account` had not been already granted `role`, emits a {RoleGranted}
817      * event. Note that unlike {grantRole}, this function doesn't perform any
818      * checks on the calling account.
819      *
820      * [WARNING]
821      * ====
822      * This function should only be called from the constructor when setting
823      * up the initial roles for the system.
824      *
825      * Using this function in any other way is effectively circumventing the admin
826      * system imposed by {AccessControl}.
827      * ====
828      */
829     function _setupRole(bytes32 role, address account) internal virtual {
830         _grantRole(role, account);
831     }
832 
833     /**
834      * @dev Sets `adminRole` as ``role``'s admin role.
835      *
836      * Emits a {RoleAdminChanged} event.
837      */
838     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
839         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
840         _roles[role].adminRole = adminRole;
841     }
842 
843     function _grantRole(bytes32 role, address account) private {
844         if (!hasRole(role, account)) {
845             _roles[role].members[account] = true;
846             emit RoleGranted(role, account, _msgSender());
847         }
848     }
849 
850     function _revokeRole(bytes32 role, address account) private {
851         if (hasRole(role, account)) {
852             _roles[role].members[account] = false;
853             emit RoleRevoked(role, account, _msgSender());
854         }
855     }
856 }
857 
858 
859 
860  
861 
862 /**
863  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
864  * total supply at the time are recorded for later access.
865  *
866  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
867  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
868  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
869  * used to create an efficient ERC20 forking mechanism.
870  *
871  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
872  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
873  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
874  * and the account address.
875  *
876  * ==== Gas Costs
877  *
878  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
879  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
880  * smaller since identical balances in subsequent snapshots are stored as a single entry.
881  *
882  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
883  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
884  * transfers will have normal cost until the next snapshot, and so on.
885  */
886 abstract contract ERC20Snapshot is ERC20 {
887     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
888     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
889 
890     using Arrays for uint256[];
891     using Counters for Counters.Counter;
892 
893     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
894     // Snapshot struct, but that would impede usage of functions that work on an array.
895     struct Snapshots {
896         uint256[] ids;
897         uint256[] values;
898     }
899 
900     mapping (address => Snapshots) private _accountBalanceSnapshots;
901     Snapshots private _totalSupplySnapshots;
902 
903     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
904     Counters.Counter private _currentSnapshotId;
905 
906     /**
907      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
908      */
909     event Snapshot(uint256 id);
910 
911     /**
912      * @dev Creates a new snapshot and returns its snapshot id.
913      *
914      * Emits a {Snapshot} event that contains the same id.
915      *
916      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
917      * set of accounts, for example using {AccessControl}, or it may be open to the public.
918      *
919      * [WARNING]
920      * ====
921      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
922      * you must consider that it can potentially be used by attackers in two ways.
923      *
924      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
925      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
926      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
927      * section above.
928      *
929      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
930      * ====
931      */
932     function _snapshot() internal virtual returns (uint256) {
933         _currentSnapshotId.increment();
934 
935         uint256 currentId = _currentSnapshotId.current();
936         emit Snapshot(currentId);
937         return currentId;
938     }
939 
940     /**
941      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
942      */
943     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
944         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
945 
946         return snapshotted ? value : balanceOf(account);
947     }
948 
949     /**
950      * @dev Retrieves the total supply at the time `snapshotId` was created.
951      */
952     function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {
953         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
954 
955         return snapshotted ? value : totalSupply();
956     }
957 
958 
959     // Update balance and/or total supply snapshots before the values are modified. This is implemented
960     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
961     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
962       super._beforeTokenTransfer(from, to, amount);
963 
964       if (from == address(0)) {
965         // mint
966         _updateAccountSnapshot(to);
967         _updateTotalSupplySnapshot();
968       } else if (to == address(0)) {
969         // burn
970         _updateAccountSnapshot(from);
971         _updateTotalSupplySnapshot();
972       } else {
973         // transfer
974         _updateAccountSnapshot(from);
975         _updateAccountSnapshot(to);
976       }
977     }
978 
979     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
980         private view returns (bool, uint256)
981     {
982         require(snapshotId > 0, "ERC20Snapshot: id is 0");
983         // solhint-disable-next-line max-line-length
984         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
985 
986         // When a valid snapshot is queried, there are three possibilities:
987         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
988         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
989         //  to this id is the current one.
990         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
991         //  requested id, and its value is the one to return.
992         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
993         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
994         //  larger than the requested one.
995         //
996         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
997         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
998         // exactly this.
999 
1000         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1001 
1002         if (index == snapshots.ids.length) {
1003             return (false, 0);
1004         } else {
1005             return (true, snapshots.values[index]);
1006         }
1007     }
1008 
1009     function _updateAccountSnapshot(address account) private {
1010         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1011     }
1012 
1013     function _updateTotalSupplySnapshot() private {
1014         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1015     }
1016 
1017     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1018         uint256 currentId = _currentSnapshotId.current();
1019         if (_lastSnapshotId(snapshots.ids) < currentId) {
1020             snapshots.ids.push(currentId);
1021             snapshots.values.push(currentValue);
1022         }
1023     }
1024 
1025     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1026         if (ids.length == 0) {
1027             return 0;
1028         } else {
1029             return ids[ids.length - 1];
1030         }
1031     }
1032 }
1033 
1034 
1035 
1036 // ERC20 token
1037 // - Burnable
1038 // - Snapshot
1039 // - EIP712 - human readable signed messages
1040 // - ERC677 - transfer and call - approve tokens and call a function on another contract in one transaction
1041 contract WasderToken is ERC20Snapshot, AccessControl, EIP712Base {
1042 
1043     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**18; //1,000,000,000 tokens (18 decimals)
1044 
1045     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1046 
1047     constructor(address to) ERC20("Wasder Token", "WAS") {
1048         _mint(to, INITIAL_SUPPLY); 
1049 
1050         _initializeEIP712("Wasder Token"); // domain
1051 
1052         _setupRole(DEFAULT_ADMIN_ROLE, to);
1053 
1054     }
1055 
1056     function burn(uint256 amount) external {
1057         require(hasRole(BURNER_ROLE, _msgSender()), "Caller is not a burner");
1058         require(amount > 0, "Amount to burn cannot be zero");
1059 
1060         _burn(msg.sender, amount);
1061     }
1062 
1063     function snapshot() external {
1064         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1065 
1066         _snapshot();
1067     }
1068 
1069     // ERC677 Transfer and call
1070     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
1071 
1072     /**
1073     * @dev transfer token to a contract address with additional data if the recipient is a contact.
1074     * @param _to The address to transfer to.
1075     * @param _value The amount to be transferred.
1076     * @param _data The extra data to be passed to the receiving contract.
1077     */
1078     function transferAndCall(address _to, uint _value, bytes memory _data)
1079         external
1080         returns (bool success)
1081     {
1082         super.transfer(_to, _value);
1083         emit Transfer(_msgSender(), _to, _value, _data);
1084         if (isContract(_to)) {
1085             IERC677Receiver receiver = IERC677Receiver(_to);
1086             receiver.onTokenTransfer(_msgSender(), _value, _data);
1087         }
1088         return true;
1089     }
1090 
1091     function isContract(address _addr) private view returns (bool hasCode)
1092     {
1093         uint length;
1094         assembly { length := extcodesize(_addr) }
1095         return length > 0;
1096     }
1097 
1098 }