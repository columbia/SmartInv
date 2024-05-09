1 // Sources flattened with hardhat v2.9.2 https://hardhat.org
2 
3 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
4 
5 
6 pragma solidity >=0.8.0;
7 
8 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
9 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
10 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
11 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
12 abstract contract ERC20 {
13     /*///////////////////////////////////////////////////////////////
14                                   EVENTS
15     //////////////////////////////////////////////////////////////*/
16 
17     event Transfer(address indexed from, address indexed to, uint256 amount);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 amount);
20 
21     /*///////////////////////////////////////////////////////////////
22                              METADATA STORAGE
23     //////////////////////////////////////////////////////////////*/
24 
25     string public name;
26 
27     string public symbol;
28 
29     uint8 public immutable decimals;
30 
31     /*///////////////////////////////////////////////////////////////
32                               ERC20 STORAGE
33     //////////////////////////////////////////////////////////////*/
34 
35     uint256 public totalSupply;
36 
37     mapping(address => uint256) public balanceOf;
38 
39     mapping(address => mapping(address => uint256)) public allowance;
40 
41     /*///////////////////////////////////////////////////////////////
42                              EIP-2612 STORAGE
43     //////////////////////////////////////////////////////////////*/
44 
45     bytes32 public constant PERMIT_TYPEHASH =
46         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
47 
48     uint256 internal immutable INITIAL_CHAIN_ID;
49 
50     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
51 
52     mapping(address => uint256) public nonces;
53 
54     /*///////////////////////////////////////////////////////////////
55                                CONSTRUCTOR
56     //////////////////////////////////////////////////////////////*/
57 
58     constructor(
59         string memory _name,
60         string memory _symbol,
61         uint8 _decimals
62     ) {
63         name = _name;
64         symbol = _symbol;
65         decimals = _decimals;
66 
67         INITIAL_CHAIN_ID = block.chainid;
68         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
69     }
70 
71     /*///////////////////////////////////////////////////////////////
72                               ERC20 LOGIC
73     //////////////////////////////////////////////////////////////*/
74 
75     function approve(address spender, uint256 amount) public virtual returns (bool) {
76         allowance[msg.sender][spender] = amount;
77 
78         emit Approval(msg.sender, spender, amount);
79 
80         return true;
81     }
82 
83     function transfer(address to, uint256 amount) public virtual returns (bool) {
84         balanceOf[msg.sender] -= amount;
85 
86         // Cannot overflow because the sum of all user
87         // balances can't exceed the max uint256 value.
88         unchecked {
89             balanceOf[to] += amount;
90         }
91 
92         emit Transfer(msg.sender, to, amount);
93 
94         return true;
95     }
96 
97     function transferFrom(
98         address from,
99         address to,
100         uint256 amount
101     ) public virtual returns (bool) {
102         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
103 
104         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
105 
106         balanceOf[from] -= amount;
107 
108         // Cannot overflow because the sum of all user
109         // balances can't exceed the max uint256 value.
110         unchecked {
111             balanceOf[to] += amount;
112         }
113 
114         emit Transfer(from, to, amount);
115 
116         return true;
117     }
118 
119     /*///////////////////////////////////////////////////////////////
120                               EIP-2612 LOGIC
121     //////////////////////////////////////////////////////////////*/
122 
123     function permit(
124         address owner,
125         address spender,
126         uint256 value,
127         uint256 deadline,
128         uint8 v,
129         bytes32 r,
130         bytes32 s
131     ) public virtual {
132         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
133 
134         // Unchecked because the only math done is incrementing
135         // the owner's nonce which cannot realistically overflow.
136         unchecked {
137             bytes32 digest = keccak256(
138                 abi.encodePacked(
139                     "\x19\x01",
140                     DOMAIN_SEPARATOR(),
141                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
142                 )
143             );
144 
145             address recoveredAddress = ecrecover(digest, v, r, s);
146 
147             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
148 
149             allowance[recoveredAddress][spender] = value;
150         }
151 
152         emit Approval(owner, spender, value);
153     }
154 
155     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
156         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
157     }
158 
159     function computeDomainSeparator() internal view virtual returns (bytes32) {
160         return
161             keccak256(
162                 abi.encode(
163                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
164                     keccak256(bytes(name)),
165                     keccak256("1"),
166                     block.chainid,
167                     address(this)
168                 )
169             );
170     }
171 
172     /*///////////////////////////////////////////////////////////////
173                        INTERNAL MINT/BURN LOGIC
174     //////////////////////////////////////////////////////////////*/
175 
176     function _mint(address to, uint256 amount) internal virtual {
177         totalSupply += amount;
178 
179         // Cannot overflow because the sum of all user
180         // balances can't exceed the max uint256 value.
181         unchecked {
182             balanceOf[to] += amount;
183         }
184 
185         emit Transfer(address(0), to, amount);
186     }
187 
188     function _burn(address from, uint256 amount) internal virtual {
189         balanceOf[from] -= amount;
190 
191         // Cannot underflow because a user's balance
192         // will never be larger than the total supply.
193         unchecked {
194             totalSupply -= amount;
195         }
196 
197         emit Transfer(from, address(0), amount);
198     }
199 }
200 
201 
202 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.5.0
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
206 
207 
208 
209 /**
210  * @dev External interface of AccessControl declared to support ERC165 detection.
211  */
212 interface IAccessControl {
213     /**
214      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
215      *
216      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
217      * {RoleAdminChanged} not being emitted signaling this.
218      *
219      * _Available since v3.1._
220      */
221     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
222 
223     /**
224      * @dev Emitted when `account` is granted `role`.
225      *
226      * `sender` is the account that originated the contract call, an admin role
227      * bearer except when using {AccessControl-_setupRole}.
228      */
229     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
230 
231     /**
232      * @dev Emitted when `account` is revoked `role`.
233      *
234      * `sender` is the account that originated the contract call:
235      *   - if using `revokeRole`, it is the admin role bearer
236      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
237      */
238     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
239 
240     /**
241      * @dev Returns `true` if `account` has been granted `role`.
242      */
243     function hasRole(bytes32 role, address account) external view returns (bool);
244 
245     /**
246      * @dev Returns the admin role that controls `role`. See {grantRole} and
247      * {revokeRole}.
248      *
249      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
250      */
251     function getRoleAdmin(bytes32 role) external view returns (bytes32);
252 
253     /**
254      * @dev Grants `role` to `account`.
255      *
256      * If `account` had not been already granted `role`, emits a {RoleGranted}
257      * event.
258      *
259      * Requirements:
260      *
261      * - the caller must have ``role``'s admin role.
262      */
263     function grantRole(bytes32 role, address account) external;
264 
265     /**
266      * @dev Revokes `role` from `account`.
267      *
268      * If `account` had been granted `role`, emits a {RoleRevoked} event.
269      *
270      * Requirements:
271      *
272      * - the caller must have ``role``'s admin role.
273      */
274     function revokeRole(bytes32 role, address account) external;
275 
276     /**
277      * @dev Revokes `role` from the calling account.
278      *
279      * Roles are often managed via {grantRole} and {revokeRole}: this function's
280      * purpose is to provide a mechanism for accounts to lose their privileges
281      * if they are compromised (such as when a trusted device is misplaced).
282      *
283      * If the calling account had been granted `role`, emits a {RoleRevoked}
284      * event.
285      *
286      * Requirements:
287      *
288      * - the caller must be `account`.
289      */
290     function renounceRole(bytes32 role, address account) external;
291 }
292 
293 
294 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 
322 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
326 
327 
328 
329 /**
330  * @dev String operations.
331  */
332 library Strings {
333     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
337      */
338     function toString(uint256 value) internal pure returns (string memory) {
339         // Inspired by OraclizeAPI's implementation - MIT licence
340         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
341 
342         if (value == 0) {
343             return "0";
344         }
345         uint256 temp = value;
346         uint256 digits;
347         while (temp != 0) {
348             digits++;
349             temp /= 10;
350         }
351         bytes memory buffer = new bytes(digits);
352         while (value != 0) {
353             digits -= 1;
354             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
355             value /= 10;
356         }
357         return string(buffer);
358     }
359 
360     /**
361      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
362      */
363     function toHexString(uint256 value) internal pure returns (string memory) {
364         if (value == 0) {
365             return "0x00";
366         }
367         uint256 temp = value;
368         uint256 length = 0;
369         while (temp != 0) {
370             length++;
371             temp >>= 8;
372         }
373         return toHexString(value, length);
374     }
375 
376     /**
377      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
378      */
379     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
380         bytes memory buffer = new bytes(2 * length + 2);
381         buffer[0] = "0";
382         buffer[1] = "x";
383         for (uint256 i = 2 * length + 1; i > 1; --i) {
384             buffer[i] = _HEX_SYMBOLS[value & 0xf];
385             value >>= 4;
386         }
387         require(value == 0, "Strings: hex length insufficient");
388         return string(buffer);
389     }
390 }
391 
392 
393 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
397 
398 
399 
400 /**
401  * @dev Interface of the ERC165 standard, as defined in the
402  * https://eips.ethereum.org/EIPS/eip-165[EIP].
403  *
404  * Implementers can declare support of contract interfaces, which can then be
405  * queried by others ({ERC165Checker}).
406  *
407  * For an implementation, see {ERC165}.
408  */
409 interface IERC165 {
410     /**
411      * @dev Returns true if this contract implements the interface defined by
412      * `interfaceId`. See the corresponding
413      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
414      * to learn more about how these ids are created.
415      *
416      * This function call must use less than 30 000 gas.
417      */
418     function supportsInterface(bytes4 interfaceId) external view returns (bool);
419 }
420 
421 
422 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
426 
427 
428 
429 /**
430  * @dev Implementation of the {IERC165} interface.
431  *
432  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
433  * for the additional interface id that will be supported. For example:
434  *
435  * ```solidity
436  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
438  * }
439  * ```
440  *
441  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
442  */
443 abstract contract ERC165 is IERC165 {
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
448         return interfaceId == type(IERC165).interfaceId;
449     }
450 }
451 
452 
453 // File @openzeppelin/contracts/access/AccessControl.sol@v4.5.0
454 
455 
456 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
457 
458 
459 
460 
461 
462 
463 /**
464  * @dev Contract module that allows children to implement role-based access
465  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
466  * members except through off-chain means by accessing the contract event logs. Some
467  * applications may benefit from on-chain enumerability, for those cases see
468  * {AccessControlEnumerable}.
469  *
470  * Roles are referred to by their `bytes32` identifier. These should be exposed
471  * in the external API and be unique. The best way to achieve this is by
472  * using `public constant` hash digests:
473  *
474  * ```
475  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
476  * ```
477  *
478  * Roles can be used to represent a set of permissions. To restrict access to a
479  * function call, use {hasRole}:
480  *
481  * ```
482  * function foo() public {
483  *     require(hasRole(MY_ROLE, msg.sender));
484  *     ...
485  * }
486  * ```
487  *
488  * Roles can be granted and revoked dynamically via the {grantRole} and
489  * {revokeRole} functions. Each role has an associated admin role, and only
490  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
491  *
492  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
493  * that only accounts with this role will be able to grant or revoke other
494  * roles. More complex role relationships can be created by using
495  * {_setRoleAdmin}.
496  *
497  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
498  * grant and revoke this role. Extra precautions should be taken to secure
499  * accounts that have been granted it.
500  */
501 abstract contract AccessControl is Context, IAccessControl, ERC165 {
502     struct RoleData {
503         mapping(address => bool) members;
504         bytes32 adminRole;
505     }
506 
507     mapping(bytes32 => RoleData) private _roles;
508 
509     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
510 
511     /**
512      * @dev Modifier that checks that an account has a specific role. Reverts
513      * with a standardized message including the required role.
514      *
515      * The format of the revert reason is given by the following regular expression:
516      *
517      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
518      *
519      * _Available since v4.1._
520      */
521     modifier onlyRole(bytes32 role) {
522         _checkRole(role, _msgSender());
523         _;
524     }
525 
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
531     }
532 
533     /**
534      * @dev Returns `true` if `account` has been granted `role`.
535      */
536     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
537         return _roles[role].members[account];
538     }
539 
540     /**
541      * @dev Revert with a standard message if `account` is missing `role`.
542      *
543      * The format of the revert reason is given by the following regular expression:
544      *
545      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
546      */
547     function _checkRole(bytes32 role, address account) internal view virtual {
548         if (!hasRole(role, account)) {
549             revert(
550                 string(
551                     abi.encodePacked(
552                         "AccessControl: account ",
553                         Strings.toHexString(uint160(account), 20),
554                         " is missing role ",
555                         Strings.toHexString(uint256(role), 32)
556                     )
557                 )
558             );
559         }
560     }
561 
562     /**
563      * @dev Returns the admin role that controls `role`. See {grantRole} and
564      * {revokeRole}.
565      *
566      * To change a role's admin, use {_setRoleAdmin}.
567      */
568     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
569         return _roles[role].adminRole;
570     }
571 
572     /**
573      * @dev Grants `role` to `account`.
574      *
575      * If `account` had not been already granted `role`, emits a {RoleGranted}
576      * event.
577      *
578      * Requirements:
579      *
580      * - the caller must have ``role``'s admin role.
581      */
582     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
583         _grantRole(role, account);
584     }
585 
586     /**
587      * @dev Revokes `role` from `account`.
588      *
589      * If `account` had been granted `role`, emits a {RoleRevoked} event.
590      *
591      * Requirements:
592      *
593      * - the caller must have ``role``'s admin role.
594      */
595     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
596         _revokeRole(role, account);
597     }
598 
599     /**
600      * @dev Revokes `role` from the calling account.
601      *
602      * Roles are often managed via {grantRole} and {revokeRole}: this function's
603      * purpose is to provide a mechanism for accounts to lose their privileges
604      * if they are compromised (such as when a trusted device is misplaced).
605      *
606      * If the calling account had been revoked `role`, emits a {RoleRevoked}
607      * event.
608      *
609      * Requirements:
610      *
611      * - the caller must be `account`.
612      */
613     function renounceRole(bytes32 role, address account) public virtual override {
614         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
615 
616         _revokeRole(role, account);
617     }
618 
619     /**
620      * @dev Grants `role` to `account`.
621      *
622      * If `account` had not been already granted `role`, emits a {RoleGranted}
623      * event. Note that unlike {grantRole}, this function doesn't perform any
624      * checks on the calling account.
625      *
626      * [WARNING]
627      * ====
628      * This function should only be called from the constructor when setting
629      * up the initial roles for the system.
630      *
631      * Using this function in any other way is effectively circumventing the admin
632      * system imposed by {AccessControl}.
633      * ====
634      *
635      * NOTE: This function is deprecated in favor of {_grantRole}.
636      */
637     function _setupRole(bytes32 role, address account) internal virtual {
638         _grantRole(role, account);
639     }
640 
641     /**
642      * @dev Sets `adminRole` as ``role``'s admin role.
643      *
644      * Emits a {RoleAdminChanged} event.
645      */
646     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
647         bytes32 previousAdminRole = getRoleAdmin(role);
648         _roles[role].adminRole = adminRole;
649         emit RoleAdminChanged(role, previousAdminRole, adminRole);
650     }
651 
652     /**
653      * @dev Grants `role` to `account`.
654      *
655      * Internal function without access restriction.
656      */
657     function _grantRole(bytes32 role, address account) internal virtual {
658         if (!hasRole(role, account)) {
659             _roles[role].members[account] = true;
660             emit RoleGranted(role, account, _msgSender());
661         }
662     }
663 
664     /**
665      * @dev Revokes `role` from `account`.
666      *
667      * Internal function without access restriction.
668      */
669     function _revokeRole(bytes32 role, address account) internal virtual {
670         if (hasRole(role, account)) {
671             _roles[role].members[account] = false;
672             emit RoleRevoked(role, account, _msgSender());
673         }
674     }
675 }
676 
677 
678 // File contracts/core/BTRFLYV2.sol
679 
680 // SPDX-License-Identifier: MIT
681 pragma solidity 0.8.12;
682 
683 
684 /// @title BTRFLYV2
685 /// @author Realkinando
686 
687 /**
688     @notice 
689     Minimum viable token for BTRFLYV2, follows same patterns as V1 token, but with improved readability
690 */
691 
692 contract BTRFLYV2 is AccessControl, ERC20("BTRFLY", "BTRFLY", 18) {
693     bytes32 public constant MINTER_ROLE = "MINTER_ROLE";
694 
695     constructor() {
696         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
697     }
698 
699     /**
700         @notice Mint tokens
701         @param  to      address  Address to receive tokens
702         @param  amount  uint256  Amount to mint
703      */
704     function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
705         _mint(to, amount);
706     }
707 
708     /**
709         @notice Burn tokens
710         @param  amount  uint256  Amount to burn
711      */
712     function burn(uint256 amount) external {
713         _burn(msg.sender, amount);
714     }
715 }