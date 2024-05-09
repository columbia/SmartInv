1 // Sources flattened with hardhat v2.6.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev External interface of AccessControl declared to support ERC165 detection.
11  */
12 interface IAccessControl {
13   /**
14    * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
15    *
16    * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
17    * {RoleAdminChanged} not being emitted signaling this.
18    *
19    * _Available since v3.1._
20    */
21   event RoleAdminChanged(
22     bytes32 indexed role,
23     bytes32 indexed previousAdminRole,
24     bytes32 indexed newAdminRole
25   );
26 
27   /**
28    * @dev Emitted when `account` is granted `role`.
29    *
30    * `sender` is the account that originated the contract call, an admin role
31    * bearer except when using {AccessControl-_setupRole}.
32    */
33   event RoleGranted(
34     bytes32 indexed role,
35     address indexed account,
36     address indexed sender
37   );
38 
39   /**
40    * @dev Emitted when `account` is revoked `role`.
41    *
42    * `sender` is the account that originated the contract call:
43    *   - if using `revokeRole`, it is the admin role bearer
44    *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
45    */
46   event RoleRevoked(
47     bytes32 indexed role,
48     address indexed account,
49     address indexed sender
50   );
51 
52   /**
53    * @dev Returns `true` if `account` has been granted `role`.
54    */
55   function hasRole(bytes32 role, address account) external view returns (bool);
56 
57   /**
58    * @dev Returns the admin role that controls `role`. See {grantRole} and
59    * {revokeRole}.
60    *
61    * To change a role's admin, use {AccessControl-_setRoleAdmin}.
62    */
63   function getRoleAdmin(bytes32 role) external view returns (bytes32);
64 
65   /**
66    * @dev Grants `role` to `account`.
67    *
68    * If `account` had not been already granted `role`, emits a {RoleGranted}
69    * event.
70    *
71    * Requirements:
72    *
73    * - the caller must have ``role``'s admin role.
74    */
75   function grantRole(bytes32 role, address account) external;
76 
77   /**
78    * @dev Revokes `role` from `account`.
79    *
80    * If `account` had been granted `role`, emits a {RoleRevoked} event.
81    *
82    * Requirements:
83    *
84    * - the caller must have ``role``'s admin role.
85    */
86   function revokeRole(bytes32 role, address account) external;
87 
88   /**
89    * @dev Revokes `role` from the calling account.
90    *
91    * Roles are often managed via {grantRole} and {revokeRole}: this function's
92    * purpose is to provide a mechanism for accounts to lose their privileges
93    * if they are compromised (such as when a trusted device is misplaced).
94    *
95    * If the calling account had been granted `role`, emits a {RoleRevoked}
96    * event.
97    *
98    * Requirements:
99    *
100    * - the caller must be `account`.
101    */
102   function renounceRole(bytes32 role, address account) external;
103 }
104 
105 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120   function _msgSender() internal view virtual returns (address) {
121     return msg.sender;
122   }
123 
124   function _msgData() internal view virtual returns (bytes calldata) {
125     return msg.data;
126   }
127 }
128 
129 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev String operations.
135  */
136 library Strings {
137   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138 
139   /**
140    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
141    */
142   function toString(uint256 value) internal pure returns (string memory) {
143     // Inspired by OraclizeAPI's implementation - MIT licence
144     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
145 
146     if (value == 0) {
147       return "0";
148     }
149     uint256 temp = value;
150     uint256 digits;
151     while (temp != 0) {
152       digits++;
153       temp /= 10;
154     }
155     bytes memory buffer = new bytes(digits);
156     while (value != 0) {
157       digits -= 1;
158       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
159       value /= 10;
160     }
161     return string(buffer);
162   }
163 
164   /**
165    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
166    */
167   function toHexString(uint256 value) internal pure returns (string memory) {
168     if (value == 0) {
169       return "0x00";
170     }
171     uint256 temp = value;
172     uint256 length = 0;
173     while (temp != 0) {
174       length++;
175       temp >>= 8;
176     }
177     return toHexString(value, length);
178   }
179 
180   /**
181    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
182    */
183   function toHexString(uint256 value, uint256 length)
184     internal
185     pure
186     returns (string memory)
187   {
188     bytes memory buffer = new bytes(2 * length + 2);
189     buffer[0] = "0";
190     buffer[1] = "x";
191     for (uint256 i = 2 * length + 1; i > 1; --i) {
192       buffer[i] = _HEX_SYMBOLS[value & 0xf];
193       value >>= 4;
194     }
195     require(value == 0, "Strings: hex length insufficient");
196     return string(buffer);
197   }
198 }
199 
200 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Interface of the ERC165 standard, as defined in the
206  * https://eips.ethereum.org/EIPS/eip-165[EIP].
207  *
208  * Implementers can declare support of contract interfaces, which can then be
209  * queried by others ({ERC165Checker}).
210  *
211  * For an implementation, see {ERC165}.
212  */
213 interface IERC165 {
214   /**
215    * @dev Returns true if this contract implements the interface defined by
216    * `interfaceId`. See the corresponding
217    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
218    * to learn more about how these ids are created.
219    *
220    * This function call must use less than 30 000 gas.
221    */
222   function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 }
224 
225 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Implementation of the {IERC165} interface.
231  *
232  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
233  * for the additional interface id that will be supported. For example:
234  *
235  * ```solidity
236  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
237  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
238  * }
239  * ```
240  *
241  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
242  */
243 abstract contract ERC165 is IERC165 {
244   /**
245    * @dev See {IERC165-supportsInterface}.
246    */
247   function supportsInterface(bytes4 interfaceId)
248     public
249     view
250     virtual
251     override
252     returns (bool)
253   {
254     return interfaceId == type(IERC165).interfaceId;
255   }
256 }
257 
258 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.2
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Contract module that allows children to implement role-based access
264  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
265  * members except through off-chain means by accessing the contract event logs. Some
266  * applications may benefit from on-chain enumerability, for those cases see
267  * {AccessControlEnumerable}.
268  *
269  * Roles are referred to by their `bytes32` identifier. These should be exposed
270  * in the external API and be unique. The best way to achieve this is by
271  * using `public constant` hash digests:
272  *
273  * ```
274  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
275  * ```
276  *
277  * Roles can be used to represent a set of permissions. To restrict access to a
278  * function call, use {hasRole}:
279  *
280  * ```
281  * function foo() public {
282  *     require(hasRole(MY_ROLE, msg.sender));
283  *     ...
284  * }
285  * ```
286  *
287  * Roles can be granted and revoked dynamically via the {grantRole} and
288  * {revokeRole} functions. Each role has an associated admin role, and only
289  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
290  *
291  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
292  * that only accounts with this role will be able to grant or revoke other
293  * roles. More complex role relationships can be created by using
294  * {_setRoleAdmin}.
295  *
296  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
297  * grant and revoke this role. Extra precautions should be taken to secure
298  * accounts that have been granted it.
299  */
300 abstract contract AccessControl is Context, IAccessControl, ERC165 {
301   struct RoleData {
302     mapping(address => bool) members;
303     bytes32 adminRole;
304   }
305 
306   mapping(bytes32 => RoleData) private _roles;
307 
308   bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
309 
310   /**
311    * @dev Modifier that checks that an account has a specific role. Reverts
312    * with a standardized message including the required role.
313    *
314    * The format of the revert reason is given by the following regular expression:
315    *
316    *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
317    *
318    * _Available since v4.1._
319    */
320   modifier onlyRole(bytes32 role) {
321     _checkRole(role, _msgSender());
322     _;
323   }
324 
325   /**
326    * @dev See {IERC165-supportsInterface}.
327    */
328   function supportsInterface(bytes4 interfaceId)
329     public
330     view
331     virtual
332     override
333     returns (bool)
334   {
335     return
336       interfaceId == type(IAccessControl).interfaceId ||
337       super.supportsInterface(interfaceId);
338   }
339 
340   /**
341    * @dev Returns `true` if `account` has been granted `role`.
342    */
343   function hasRole(bytes32 role, address account)
344     public
345     view
346     override
347     returns (bool)
348   {
349     return _roles[role].members[account];
350   }
351 
352   /**
353    * @dev Revert with a standard message if `account` is missing `role`.
354    *
355    * The format of the revert reason is given by the following regular expression:
356    *
357    *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
358    */
359   function _checkRole(bytes32 role, address account) internal view {
360     if (!hasRole(role, account)) {
361       revert(
362         string(
363           abi.encodePacked(
364             "AccessControl: account ",
365             Strings.toHexString(uint160(account), 20),
366             " is missing role ",
367             Strings.toHexString(uint256(role), 32)
368           )
369         )
370       );
371     }
372   }
373 
374   /**
375    * @dev Returns the admin role that controls `role`. See {grantRole} and
376    * {revokeRole}.
377    *
378    * To change a role's admin, use {_setRoleAdmin}.
379    */
380   function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
381     return _roles[role].adminRole;
382   }
383 
384   /**
385    * @dev Grants `role` to `account`.
386    *
387    * If `account` had not been already granted `role`, emits a {RoleGranted}
388    * event.
389    *
390    * Requirements:
391    *
392    * - the caller must have ``role``'s admin role.
393    */
394   function grantRole(bytes32 role, address account)
395     public
396     virtual
397     override
398     onlyRole(getRoleAdmin(role))
399   {
400     _grantRole(role, account);
401   }
402 
403   /**
404    * @dev Revokes `role` from `account`.
405    *
406    * If `account` had been granted `role`, emits a {RoleRevoked} event.
407    *
408    * Requirements:
409    *
410    * - the caller must have ``role``'s admin role.
411    */
412   function revokeRole(bytes32 role, address account)
413     public
414     virtual
415     override
416     onlyRole(getRoleAdmin(role))
417   {
418     _revokeRole(role, account);
419   }
420 
421   /**
422    * @dev Revokes `role` from the calling account.
423    *
424    * Roles are often managed via {grantRole} and {revokeRole}: this function's
425    * purpose is to provide a mechanism for accounts to lose their privileges
426    * if they are compromised (such as when a trusted device is misplaced).
427    *
428    * If the calling account had been granted `role`, emits a {RoleRevoked}
429    * event.
430    *
431    * Requirements:
432    *
433    * - the caller must be `account`.
434    */
435   function renounceRole(bytes32 role, address account) public virtual override {
436     require(
437       account == _msgSender(),
438       "AccessControl: can only renounce roles for self"
439     );
440 
441     _revokeRole(role, account);
442   }
443 
444   /**
445    * @dev Grants `role` to `account`.
446    *
447    * If `account` had not been already granted `role`, emits a {RoleGranted}
448    * event. Note that unlike {grantRole}, this function doesn't perform any
449    * checks on the calling account.
450    *
451    * [WARNING]
452    * ====
453    * This function should only be called from the constructor when setting
454    * up the initial roles for the system.
455    *
456    * Using this function in any other way is effectively circumventing the admin
457    * system imposed by {AccessControl}.
458    * ====
459    */
460   function _setupRole(bytes32 role, address account) internal virtual {
461     _grantRole(role, account);
462   }
463 
464   /**
465    * @dev Sets `adminRole` as ``role``'s admin role.
466    *
467    * Emits a {RoleAdminChanged} event.
468    */
469   function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
470     bytes32 previousAdminRole = getRoleAdmin(role);
471     _roles[role].adminRole = adminRole;
472     emit RoleAdminChanged(role, previousAdminRole, adminRole);
473   }
474 
475   function _grantRole(bytes32 role, address account) private {
476     if (!hasRole(role, account)) {
477       _roles[role].members[account] = true;
478       emit RoleGranted(role, account, _msgSender());
479     }
480   }
481 
482   function _revokeRole(bytes32 role, address account) private {
483     if (hasRole(role, account)) {
484       _roles[role].members[account] = false;
485       emit RoleRevoked(role, account, _msgSender());
486     }
487   }
488 }
489 
490 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @dev Required interface of an ERC721 compliant contract.
496  */
497 interface IERC721 is IERC165 {
498   /**
499    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500    */
501   event Transfer(
502     address indexed from,
503     address indexed to,
504     uint256 indexed tokenId
505   );
506 
507   /**
508    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509    */
510   event Approval(
511     address indexed owner,
512     address indexed approved,
513     uint256 indexed tokenId
514   );
515 
516   /**
517    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
518    */
519   event ApprovalForAll(
520     address indexed owner,
521     address indexed operator,
522     bool approved
523   );
524 
525   /**
526    * @dev Returns the number of tokens in ``owner``'s account.
527    */
528   function balanceOf(address owner) external view returns (uint256 balance);
529 
530   /**
531    * @dev Returns the owner of the `tokenId` token.
532    *
533    * Requirements:
534    *
535    * - `tokenId` must exist.
536    */
537   function ownerOf(uint256 tokenId) external view returns (address owner);
538 
539   /**
540    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
541    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
542    *
543    * Requirements:
544    *
545    * - `from` cannot be the zero address.
546    * - `to` cannot be the zero address.
547    * - `tokenId` token must exist and be owned by `from`.
548    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
549    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550    *
551    * Emits a {Transfer} event.
552    */
553   function safeTransferFrom(
554     address from,
555     address to,
556     uint256 tokenId
557   ) external;
558 
559   /**
560    * @dev Transfers `tokenId` token from `from` to `to`.
561    *
562    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
563    *
564    * Requirements:
565    *
566    * - `from` cannot be the zero address.
567    * - `to` cannot be the zero address.
568    * - `tokenId` token must be owned by `from`.
569    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570    *
571    * Emits a {Transfer} event.
572    */
573   function transferFrom(
574     address from,
575     address to,
576     uint256 tokenId
577   ) external;
578 
579   /**
580    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
581    * The approval is cleared when the token is transferred.
582    *
583    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
584    *
585    * Requirements:
586    *
587    * - The caller must own the token or be an approved operator.
588    * - `tokenId` must exist.
589    *
590    * Emits an {Approval} event.
591    */
592   function approve(address to, uint256 tokenId) external;
593 
594   /**
595    * @dev Returns the account approved for `tokenId` token.
596    *
597    * Requirements:
598    *
599    * - `tokenId` must exist.
600    */
601   function getApproved(uint256 tokenId)
602     external
603     view
604     returns (address operator);
605 
606   /**
607    * @dev Approve or remove `operator` as an operator for the caller.
608    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609    *
610    * Requirements:
611    *
612    * - The `operator` cannot be the caller.
613    *
614    * Emits an {ApprovalForAll} event.
615    */
616   function setApprovalForAll(address operator, bool _approved) external;
617 
618   /**
619    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
620    *
621    * See {setApprovalForAll}
622    */
623   function isApprovedForAll(address owner, address operator)
624     external
625     view
626     returns (bool);
627 
628   /**
629    * @dev Safely transfers `tokenId` token from `from` to `to`.
630    *
631    * Requirements:
632    *
633    * - `from` cannot be the zero address.
634    * - `to` cannot be the zero address.
635    * - `tokenId` token must exist and be owned by `from`.
636    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638    *
639    * Emits a {Transfer} event.
640    */
641   function safeTransferFrom(
642     address from,
643     address to,
644     uint256 tokenId,
645     bytes calldata data
646   ) external;
647 }
648 
649 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @title ERC721 token receiver interface
655  * @dev Interface for any contract that wants to support safeTransfers
656  * from ERC721 asset contracts.
657  */
658 interface IERC721Receiver {
659   /**
660    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
661    * by `operator` from `from`, this function is called.
662    *
663    * It must return its Solidity selector to confirm the token transfer.
664    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
665    *
666    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
667    */
668   function onERC721Received(
669     address operator,
670     address from,
671     uint256 tokenId,
672     bytes calldata data
673   ) external returns (bytes4);
674 }
675 
676 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
682  * @dev See https://eips.ethereum.org/EIPS/eip-721
683  */
684 interface IERC721Metadata is IERC721 {
685   /**
686    * @dev Returns the token collection name.
687    */
688   function name() external view returns (string memory);
689 
690   /**
691    * @dev Returns the token collection symbol.
692    */
693   function symbol() external view returns (string memory);
694 
695   /**
696    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
697    */
698   function tokenURI(uint256 tokenId) external view returns (string memory);
699 }
700 
701 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Collection of functions related to the address type
707  */
708 library Address {
709   /**
710    * @dev Returns true if `account` is a contract.
711    *
712    * [IMPORTANT]
713    * ====
714    * It is unsafe to assume that an address for which this function returns
715    * false is an externally-owned account (EOA) and not a contract.
716    *
717    * Among others, `isContract` will return false for the following
718    * types of addresses:
719    *
720    *  - an externally-owned account
721    *  - a contract in construction
722    *  - an address where a contract will be created
723    *  - an address where a contract lived, but was destroyed
724    * ====
725    */
726   function isContract(address account) internal view returns (bool) {
727     // This method relies on extcodesize, which returns 0 for contracts in
728     // construction, since the code is only stored at the end of the
729     // constructor execution.
730 
731     uint256 size;
732     assembly {
733       size := extcodesize(account)
734     }
735     return size > 0;
736   }
737 
738   /**
739    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
740    * `recipient`, forwarding all available gas and reverting on errors.
741    *
742    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
743    * of certain opcodes, possibly making contracts go over the 2300 gas limit
744    * imposed by `transfer`, making them unable to receive funds via
745    * `transfer`. {sendValue} removes this limitation.
746    *
747    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
748    *
749    * IMPORTANT: because control is transferred to `recipient`, care must be
750    * taken to not create reentrancy vulnerabilities. Consider using
751    * {ReentrancyGuard} or the
752    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
753    */
754   function sendValue(address payable recipient, uint256 amount) internal {
755     require(address(this).balance >= amount, "Address: insufficient balance");
756 
757     (bool success, ) = recipient.call{ value: amount }("");
758     require(
759       success,
760       "Address: unable to send value, recipient may have reverted"
761     );
762   }
763 
764   /**
765    * @dev Performs a Solidity function call using a low level `call`. A
766    * plain `call` is an unsafe replacement for a function call: use this
767    * function instead.
768    *
769    * If `target` reverts with a revert reason, it is bubbled up by this
770    * function (like regular Solidity function calls).
771    *
772    * Returns the raw returned data. To convert to the expected return value,
773    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
774    *
775    * Requirements:
776    *
777    * - `target` must be a contract.
778    * - calling `target` with `data` must not revert.
779    *
780    * _Available since v3.1._
781    */
782   function functionCall(address target, bytes memory data)
783     internal
784     returns (bytes memory)
785   {
786     return functionCall(target, data, "Address: low-level call failed");
787   }
788 
789   /**
790    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
791    * `errorMessage` as a fallback revert reason when `target` reverts.
792    *
793    * _Available since v3.1._
794    */
795   function functionCall(
796     address target,
797     bytes memory data,
798     string memory errorMessage
799   ) internal returns (bytes memory) {
800     return functionCallWithValue(target, data, 0, errorMessage);
801   }
802 
803   /**
804    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
805    * but also transferring `value` wei to `target`.
806    *
807    * Requirements:
808    *
809    * - the calling contract must have an ETH balance of at least `value`.
810    * - the called Solidity function must be `payable`.
811    *
812    * _Available since v3.1._
813    */
814   function functionCallWithValue(
815     address target,
816     bytes memory data,
817     uint256 value
818   ) internal returns (bytes memory) {
819     return
820       functionCallWithValue(
821         target,
822         data,
823         value,
824         "Address: low-level call with value failed"
825       );
826   }
827 
828   /**
829    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
830    * with `errorMessage` as a fallback revert reason when `target` reverts.
831    *
832    * _Available since v3.1._
833    */
834   function functionCallWithValue(
835     address target,
836     bytes memory data,
837     uint256 value,
838     string memory errorMessage
839   ) internal returns (bytes memory) {
840     require(
841       address(this).balance >= value,
842       "Address: insufficient balance for call"
843     );
844     require(isContract(target), "Address: call to non-contract");
845 
846     (bool success, bytes memory returndata) = target.call{ value: value }(data);
847     return verifyCallResult(success, returndata, errorMessage);
848   }
849 
850   /**
851    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
852    * but performing a static call.
853    *
854    * _Available since v3.3._
855    */
856   function functionStaticCall(address target, bytes memory data)
857     internal
858     view
859     returns (bytes memory)
860   {
861     return
862       functionStaticCall(target, data, "Address: low-level static call failed");
863   }
864 
865   /**
866    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
867    * but performing a static call.
868    *
869    * _Available since v3.3._
870    */
871   function functionStaticCall(
872     address target,
873     bytes memory data,
874     string memory errorMessage
875   ) internal view returns (bytes memory) {
876     require(isContract(target), "Address: static call to non-contract");
877 
878     (bool success, bytes memory returndata) = target.staticcall(data);
879     return verifyCallResult(success, returndata, errorMessage);
880   }
881 
882   /**
883    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
884    * but performing a delegate call.
885    *
886    * _Available since v3.4._
887    */
888   function functionDelegateCall(address target, bytes memory data)
889     internal
890     returns (bytes memory)
891   {
892     return
893       functionDelegateCall(
894         target,
895         data,
896         "Address: low-level delegate call failed"
897       );
898   }
899 
900   /**
901    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
902    * but performing a delegate call.
903    *
904    * _Available since v3.4._
905    */
906   function functionDelegateCall(
907     address target,
908     bytes memory data,
909     string memory errorMessage
910   ) internal returns (bytes memory) {
911     require(isContract(target), "Address: delegate call to non-contract");
912 
913     (bool success, bytes memory returndata) = target.delegatecall(data);
914     return verifyCallResult(success, returndata, errorMessage);
915   }
916 
917   /**
918    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
919    * revert reason using the provided one.
920    *
921    * _Available since v4.3._
922    */
923   function verifyCallResult(
924     bool success,
925     bytes memory returndata,
926     string memory errorMessage
927   ) internal pure returns (bytes memory) {
928     if (success) {
929       return returndata;
930     } else {
931       // Look for revert reason and bubble it up if present
932       if (returndata.length > 0) {
933         // The easiest way to bubble the revert reason is using memory via assembly
934 
935         assembly {
936           let returndata_size := mload(returndata)
937           revert(add(32, returndata), returndata_size)
938         }
939       } else {
940         revert(errorMessage);
941       }
942     }
943   }
944 }
945 
946 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
947 
948 pragma solidity ^0.8.0;
949 
950 /**
951  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
952  * the Metadata extension, but not including the Enumerable extension, which is available separately as
953  * {ERC721Enumerable}.
954  */
955 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
956   using Address for address;
957   using Strings for uint256;
958 
959   // Token name
960   string private _name;
961 
962   // Token symbol
963   string private _symbol;
964 
965   // Mapping from token ID to owner address
966   mapping(uint256 => address) private _owners;
967 
968   // Mapping owner address to token count
969   mapping(address => uint256) private _balances;
970 
971   // Mapping from token ID to approved address
972   mapping(uint256 => address) private _tokenApprovals;
973 
974   // Mapping from owner to operator approvals
975   mapping(address => mapping(address => bool)) private _operatorApprovals;
976 
977   /**
978    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
979    */
980   constructor(string memory name_, string memory symbol_) {
981     _name = name_;
982     _symbol = symbol_;
983   }
984 
985   /**
986    * @dev See {IERC165-supportsInterface}.
987    */
988   function supportsInterface(bytes4 interfaceId)
989     public
990     view
991     virtual
992     override(ERC165, IERC165)
993     returns (bool)
994   {
995     return
996       interfaceId == type(IERC721).interfaceId ||
997       interfaceId == type(IERC721Metadata).interfaceId ||
998       super.supportsInterface(interfaceId);
999   }
1000 
1001   /**
1002    * @dev See {IERC721-balanceOf}.
1003    */
1004   function balanceOf(address owner)
1005     public
1006     view
1007     virtual
1008     override
1009     returns (uint256)
1010   {
1011     require(owner != address(0), "ERC721: balance query for the zero address");
1012     return _balances[owner];
1013   }
1014 
1015   /**
1016    * @dev See {IERC721-ownerOf}.
1017    */
1018   function ownerOf(uint256 tokenId)
1019     public
1020     view
1021     virtual
1022     override
1023     returns (address)
1024   {
1025     address owner = _owners[tokenId];
1026     require(owner != address(0), "ERC721: owner query for nonexistent token");
1027     return owner;
1028   }
1029 
1030   /**
1031    * @dev See {IERC721Metadata-name}.
1032    */
1033   function name() public view virtual override returns (string memory) {
1034     return _name;
1035   }
1036 
1037   /**
1038    * @dev See {IERC721Metadata-symbol}.
1039    */
1040   function symbol() public view virtual override returns (string memory) {
1041     return _symbol;
1042   }
1043 
1044   /**
1045    * @dev See {IERC721Metadata-tokenURI}.
1046    */
1047   function tokenURI(uint256 tokenId)
1048     public
1049     view
1050     virtual
1051     override
1052     returns (string memory)
1053   {
1054     require(
1055       _exists(tokenId),
1056       "ERC721Metadata: URI query for nonexistent token"
1057     );
1058 
1059     string memory baseURI = _baseURI();
1060     return
1061       bytes(baseURI).length > 0
1062         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1063         : "";
1064   }
1065 
1066   /**
1067    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1068    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1069    * by default, can be overriden in child contracts.
1070    */
1071   function _baseURI() internal view virtual returns (string memory) {
1072     return "";
1073   }
1074 
1075   /**
1076    * @dev See {IERC721-approve}.
1077    */
1078   function approve(address to, uint256 tokenId) public virtual override {
1079     address owner = ERC721.ownerOf(tokenId);
1080     require(to != owner, "ERC721: approval to current owner");
1081 
1082     require(
1083       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1084       "ERC721: approve caller is not owner nor approved for all"
1085     );
1086 
1087     _approve(to, tokenId);
1088   }
1089 
1090   /**
1091    * @dev See {IERC721-getApproved}.
1092    */
1093   function getApproved(uint256 tokenId)
1094     public
1095     view
1096     virtual
1097     override
1098     returns (address)
1099   {
1100     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1101 
1102     return _tokenApprovals[tokenId];
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-setApprovalForAll}.
1107    */
1108   function setApprovalForAll(address operator, bool approved)
1109     public
1110     virtual
1111     override
1112   {
1113     require(operator != _msgSender(), "ERC721: approve to caller");
1114 
1115     _operatorApprovals[_msgSender()][operator] = approved;
1116     emit ApprovalForAll(_msgSender(), operator, approved);
1117   }
1118 
1119   /**
1120    * @dev See {IERC721-isApprovedForAll}.
1121    */
1122   function isApprovedForAll(address owner, address operator)
1123     public
1124     view
1125     virtual
1126     override
1127     returns (bool)
1128   {
1129     return _operatorApprovals[owner][operator];
1130   }
1131 
1132   /**
1133    * @dev See {IERC721-transferFrom}.
1134    */
1135   function transferFrom(
1136     address from,
1137     address to,
1138     uint256 tokenId
1139   ) public virtual override {
1140     //solhint-disable-next-line max-line-length
1141     require(
1142       _isApprovedOrOwner(_msgSender(), tokenId),
1143       "ERC721: transfer caller is not owner nor approved"
1144     );
1145 
1146     _transfer(from, to, tokenId);
1147   }
1148 
1149   /**
1150    * @dev See {IERC721-safeTransferFrom}.
1151    */
1152   function safeTransferFrom(
1153     address from,
1154     address to,
1155     uint256 tokenId
1156   ) public virtual override {
1157     safeTransferFrom(from, to, tokenId, "");
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-safeTransferFrom}.
1162    */
1163   function safeTransferFrom(
1164     address from,
1165     address to,
1166     uint256 tokenId,
1167     bytes memory _data
1168   ) public virtual override {
1169     require(
1170       _isApprovedOrOwner(_msgSender(), tokenId),
1171       "ERC721: transfer caller is not owner nor approved"
1172     );
1173     _safeTransfer(from, to, tokenId, _data);
1174   }
1175 
1176   /**
1177    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1178    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1179    *
1180    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1181    *
1182    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1183    * implement alternative mechanisms to perform token transfer, such as signature-based.
1184    *
1185    * Requirements:
1186    *
1187    * - `from` cannot be the zero address.
1188    * - `to` cannot be the zero address.
1189    * - `tokenId` token must exist and be owned by `from`.
1190    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1191    *
1192    * Emits a {Transfer} event.
1193    */
1194   function _safeTransfer(
1195     address from,
1196     address to,
1197     uint256 tokenId,
1198     bytes memory _data
1199   ) internal virtual {
1200     _transfer(from, to, tokenId);
1201     require(
1202       _checkOnERC721Received(from, to, tokenId, _data),
1203       "ERC721: transfer to non ERC721Receiver implementer"
1204     );
1205   }
1206 
1207   /**
1208    * @dev Returns whether `tokenId` exists.
1209    *
1210    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1211    *
1212    * Tokens start existing when they are minted (`_mint`),
1213    * and stop existing when they are burned (`_burn`).
1214    */
1215   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1216     return _owners[tokenId] != address(0);
1217   }
1218 
1219   /**
1220    * @dev Returns whether `spender` is allowed to manage `tokenId`.
1221    *
1222    * Requirements:
1223    *
1224    * - `tokenId` must exist.
1225    */
1226   function _isApprovedOrOwner(address spender, uint256 tokenId)
1227     internal
1228     view
1229     virtual
1230     returns (bool)
1231   {
1232     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1233     address owner = ERC721.ownerOf(tokenId);
1234     return (spender == owner ||
1235       getApproved(tokenId) == spender ||
1236       isApprovedForAll(owner, spender));
1237   }
1238 
1239   /**
1240    * @dev Safely mints `tokenId` and transfers it to `to`.
1241    *
1242    * Requirements:
1243    *
1244    * - `tokenId` must not exist.
1245    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1246    *
1247    * Emits a {Transfer} event.
1248    */
1249   function _safeMint(address to, uint256 tokenId) internal virtual {
1250     _safeMint(to, tokenId, "");
1251   }
1252 
1253   /**
1254    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1255    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1256    */
1257   function _safeMint(
1258     address to,
1259     uint256 tokenId,
1260     bytes memory _data
1261   ) internal virtual {
1262     _mint(to, tokenId);
1263     require(
1264       _checkOnERC721Received(address(0), to, tokenId, _data),
1265       "ERC721: transfer to non ERC721Receiver implementer"
1266     );
1267   }
1268 
1269   /**
1270    * @dev Mints `tokenId` and transfers it to `to`.
1271    *
1272    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1273    *
1274    * Requirements:
1275    *
1276    * - `tokenId` must not exist.
1277    * - `to` cannot be the zero address.
1278    *
1279    * Emits a {Transfer} event.
1280    */
1281   function _mint(address to, uint256 tokenId) internal virtual {
1282     require(to != address(0), "ERC721: mint to the zero address");
1283     require(!_exists(tokenId), "ERC721: token already minted");
1284 
1285     _beforeTokenTransfer(address(0), to, tokenId);
1286 
1287     _balances[to] += 1;
1288     _owners[tokenId] = to;
1289 
1290     emit Transfer(address(0), to, tokenId);
1291   }
1292 
1293   /**
1294    * @dev Destroys `tokenId`.
1295    * The approval is cleared when the token is burned.
1296    *
1297    * Requirements:
1298    *
1299    * - `tokenId` must exist.
1300    *
1301    * Emits a {Transfer} event.
1302    */
1303   function _burn(uint256 tokenId) internal virtual {
1304     address owner = ERC721.ownerOf(tokenId);
1305 
1306     _beforeTokenTransfer(owner, address(0), tokenId);
1307 
1308     // Clear approvals
1309     _approve(address(0), tokenId);
1310 
1311     _balances[owner] -= 1;
1312     delete _owners[tokenId];
1313 
1314     emit Transfer(owner, address(0), tokenId);
1315   }
1316 
1317   /**
1318    * @dev Transfers `tokenId` from `from` to `to`.
1319    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1320    *
1321    * Requirements:
1322    *
1323    * - `to` cannot be the zero address.
1324    * - `tokenId` token must be owned by `from`.
1325    *
1326    * Emits a {Transfer} event.
1327    */
1328   function _transfer(
1329     address from,
1330     address to,
1331     uint256 tokenId
1332   ) internal virtual {
1333     require(
1334       ERC721.ownerOf(tokenId) == from,
1335       "ERC721: transfer of token that is not own"
1336     );
1337     require(to != address(0), "ERC721: transfer to the zero address");
1338 
1339     _beforeTokenTransfer(from, to, tokenId);
1340 
1341     // Clear approvals from the previous owner
1342     _approve(address(0), tokenId);
1343 
1344     _balances[from] -= 1;
1345     _balances[to] += 1;
1346     _owners[tokenId] = to;
1347 
1348     emit Transfer(from, to, tokenId);
1349   }
1350 
1351   /**
1352    * @dev Approve `to` to operate on `tokenId`
1353    *
1354    * Emits a {Approval} event.
1355    */
1356   function _approve(address to, uint256 tokenId) internal virtual {
1357     _tokenApprovals[tokenId] = to;
1358     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1359   }
1360 
1361   /**
1362    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1363    * The call is not executed if the target address is not a contract.
1364    *
1365    * @param from address representing the previous owner of the given token ID
1366    * @param to target address that will receive the tokens
1367    * @param tokenId uint256 ID of the token to be transferred
1368    * @param _data bytes optional data to send along with the call
1369    * @return bool whether the call correctly returned the expected magic value
1370    */
1371   function _checkOnERC721Received(
1372     address from,
1373     address to,
1374     uint256 tokenId,
1375     bytes memory _data
1376   ) private returns (bool) {
1377     if (to.isContract()) {
1378       try
1379         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1380       returns (bytes4 retval) {
1381         return retval == IERC721Receiver.onERC721Received.selector;
1382       } catch (bytes memory reason) {
1383         if (reason.length == 0) {
1384           revert("ERC721: transfer to non ERC721Receiver implementer");
1385         } else {
1386           assembly {
1387             revert(add(32, reason), mload(reason))
1388           }
1389         }
1390       }
1391     } else {
1392       return true;
1393     }
1394   }
1395 
1396   /**
1397    * @dev Hook that is called before any token transfer. This includes minting
1398    * and burning.
1399    *
1400    * Calling conditions:
1401    *
1402    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1403    * transferred to `to`.
1404    * - When `from` is zero, `tokenId` will be minted for `to`.
1405    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1406    * - `from` and `to` are never both zero.
1407    *
1408    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1409    */
1410   function _beforeTokenTransfer(
1411     address from,
1412     address to,
1413     uint256 tokenId
1414   ) internal virtual {}
1415 }
1416 
1417 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1418 
1419 pragma solidity ^0.8.0;
1420 
1421 /**
1422  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1423  * @dev See https://eips.ethereum.org/EIPS/eip-721
1424  */
1425 interface IERC721Enumerable is IERC721 {
1426   /**
1427    * @dev Returns the total amount of tokens stored by the contract.
1428    */
1429   function totalSupply() external view returns (uint256);
1430 
1431   /**
1432    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1433    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1434    */
1435   function tokenOfOwnerByIndex(address owner, uint256 index)
1436     external
1437     view
1438     returns (uint256 tokenId);
1439 
1440   /**
1441    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1442    * Use along with {totalSupply} to enumerate all tokens.
1443    */
1444   function tokenByIndex(uint256 index) external view returns (uint256);
1445 }
1446 
1447 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 /**
1452  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1453  * enumerability of all the token ids in the contract as well as all token ids owned by each
1454  * account.
1455  */
1456 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1457   // Mapping from owner to list of owned token IDs
1458   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1459 
1460   // Mapping from token ID to index of the owner tokens list
1461   mapping(uint256 => uint256) private _ownedTokensIndex;
1462 
1463   // Array with all token ids, used for enumeration
1464   uint256[] private _allTokens;
1465 
1466   // Mapping from token id to position in the allTokens array
1467   mapping(uint256 => uint256) private _allTokensIndex;
1468 
1469   /**
1470    * @dev See {IERC165-supportsInterface}.
1471    */
1472   function supportsInterface(bytes4 interfaceId)
1473     public
1474     view
1475     virtual
1476     override(IERC165, ERC721)
1477     returns (bool)
1478   {
1479     return
1480       interfaceId == type(IERC721Enumerable).interfaceId ||
1481       super.supportsInterface(interfaceId);
1482   }
1483 
1484   /**
1485    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1486    */
1487   function tokenOfOwnerByIndex(address owner, uint256 index)
1488     public
1489     view
1490     virtual
1491     override
1492     returns (uint256)
1493   {
1494     require(
1495       index < ERC721.balanceOf(owner),
1496       "ERC721Enumerable: owner index out of bounds"
1497     );
1498     return _ownedTokens[owner][index];
1499   }
1500 
1501   /**
1502    * @dev See {IERC721Enumerable-totalSupply}.
1503    */
1504   function totalSupply() public view virtual override returns (uint256) {
1505     return _allTokens.length;
1506   }
1507 
1508   /**
1509    * @dev See {IERC721Enumerable-tokenByIndex}.
1510    */
1511   function tokenByIndex(uint256 index)
1512     public
1513     view
1514     virtual
1515     override
1516     returns (uint256)
1517   {
1518     require(
1519       index < ERC721Enumerable.totalSupply(),
1520       "ERC721Enumerable: global index out of bounds"
1521     );
1522     return _allTokens[index];
1523   }
1524 
1525   /**
1526    * @dev Hook that is called before any token transfer. This includes minting
1527    * and burning.
1528    *
1529    * Calling conditions:
1530    *
1531    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1532    * transferred to `to`.
1533    * - When `from` is zero, `tokenId` will be minted for `to`.
1534    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1535    * - `from` cannot be the zero address.
1536    * - `to` cannot be the zero address.
1537    *
1538    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1539    */
1540   function _beforeTokenTransfer(
1541     address from,
1542     address to,
1543     uint256 tokenId
1544   ) internal virtual override {
1545     super._beforeTokenTransfer(from, to, tokenId);
1546 
1547     if (from == address(0)) {
1548       _addTokenToAllTokensEnumeration(tokenId);
1549     } else if (from != to) {
1550       _removeTokenFromOwnerEnumeration(from, tokenId);
1551     }
1552     if (to == address(0)) {
1553       _removeTokenFromAllTokensEnumeration(tokenId);
1554     } else if (to != from) {
1555       _addTokenToOwnerEnumeration(to, tokenId);
1556     }
1557   }
1558 
1559   /**
1560    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1561    * @param to address representing the new owner of the given token ID
1562    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1563    */
1564   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1565     uint256 length = ERC721.balanceOf(to);
1566     _ownedTokens[to][length] = tokenId;
1567     _ownedTokensIndex[tokenId] = length;
1568   }
1569 
1570   /**
1571    * @dev Private function to add a token to this extension's token tracking data structures.
1572    * @param tokenId uint256 ID of the token to be added to the tokens list
1573    */
1574   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1575     _allTokensIndex[tokenId] = _allTokens.length;
1576     _allTokens.push(tokenId);
1577   }
1578 
1579   /**
1580    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1581    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1582    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1583    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1584    * @param from address representing the previous owner of the given token ID
1585    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1586    */
1587   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1588     private
1589   {
1590     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1591     // then delete the last slot (swap and pop).
1592 
1593     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1594     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1595 
1596     // When the token to delete is the last token, the swap operation is unnecessary
1597     if (tokenIndex != lastTokenIndex) {
1598       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1599 
1600       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1601       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1602     }
1603 
1604     // This also deletes the contents at the last position of the array
1605     delete _ownedTokensIndex[tokenId];
1606     delete _ownedTokens[from][lastTokenIndex];
1607   }
1608 
1609   /**
1610    * @dev Private function to remove a token from this extension's token tracking data structures.
1611    * This has O(1) time complexity, but alters the order of the _allTokens array.
1612    * @param tokenId uint256 ID of the token to be removed from the tokens list
1613    */
1614   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1615     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1616     // then delete the last slot (swap and pop).
1617 
1618     uint256 lastTokenIndex = _allTokens.length - 1;
1619     uint256 tokenIndex = _allTokensIndex[tokenId];
1620 
1621     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1622     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1623     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1624     uint256 lastTokenId = _allTokens[lastTokenIndex];
1625 
1626     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1627     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1628 
1629     // This also deletes the contents at the last position of the array
1630     delete _allTokensIndex[tokenId];
1631     _allTokens.pop();
1632   }
1633 }
1634 
1635 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.3.2
1636 
1637 pragma solidity ^0.8.0;
1638 
1639 /**
1640  * @title ERC721 Burnable Token
1641  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1642  */
1643 abstract contract ERC721Burnable is Context, ERC721 {
1644   /**
1645    * @dev Burns `tokenId`. See {ERC721-_burn}.
1646    *
1647    * Requirements:
1648    *
1649    * - The caller must own `tokenId` or be an approved operator.
1650    */
1651   function burn(uint256 tokenId) public virtual {
1652     //solhint-disable-next-line max-line-length
1653     require(
1654       _isApprovedOrOwner(_msgSender(), tokenId),
1655       "ERC721Burnable: caller is not owner nor approved"
1656     );
1657     _burn(tokenId);
1658   }
1659 }
1660 
1661 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.2
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 /**
1666  * @dev Contract module which allows children to implement an emergency stop
1667  * mechanism that can be triggered by an authorized account.
1668  *
1669  * This module is used through inheritance. It will make available the
1670  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1671  * the functions of your contract. Note that they will not be pausable by
1672  * simply including this module, only once the modifiers are put in place.
1673  */
1674 abstract contract Pausable is Context {
1675   /**
1676    * @dev Emitted when the pause is triggered by `account`.
1677    */
1678   event Paused(address account);
1679 
1680   /**
1681    * @dev Emitted when the pause is lifted by `account`.
1682    */
1683   event Unpaused(address account);
1684 
1685   bool private _paused;
1686 
1687   /**
1688    * @dev Initializes the contract in unpaused state.
1689    */
1690   constructor() {
1691     _paused = false;
1692   }
1693 
1694   /**
1695    * @dev Returns true if the contract is paused, and false otherwise.
1696    */
1697   function paused() public view virtual returns (bool) {
1698     return _paused;
1699   }
1700 
1701   /**
1702    * @dev Modifier to make a function callable only when the contract is not paused.
1703    *
1704    * Requirements:
1705    *
1706    * - The contract must not be paused.
1707    */
1708   modifier whenNotPaused() {
1709     require(!paused(), "Pausable: paused");
1710     _;
1711   }
1712 
1713   /**
1714    * @dev Modifier to make a function callable only when the contract is paused.
1715    *
1716    * Requirements:
1717    *
1718    * - The contract must be paused.
1719    */
1720   modifier whenPaused() {
1721     require(paused(), "Pausable: not paused");
1722     _;
1723   }
1724 
1725   /**
1726    * @dev Triggers stopped state.
1727    *
1728    * Requirements:
1729    *
1730    * - The contract must not be paused.
1731    */
1732   function _pause() internal virtual whenNotPaused {
1733     _paused = true;
1734     emit Paused(_msgSender());
1735   }
1736 
1737   /**
1738    * @dev Returns to normal state.
1739    *
1740    * Requirements:
1741    *
1742    * - The contract must be paused.
1743    */
1744   function _unpause() internal virtual whenPaused {
1745     _paused = false;
1746     emit Unpaused(_msgSender());
1747   }
1748 }
1749 
1750 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.3.2
1751 
1752 pragma solidity ^0.8.0;
1753 
1754 /**
1755  * @dev ERC721 token with pausable token transfers, minting and burning.
1756  *
1757  * Useful for scenarios such as preventing trades until the end of an evaluation
1758  * period, or having an emergency switch for freezing all token transfers in the
1759  * event of a large bug.
1760  */
1761 abstract contract ERC721Pausable is ERC721, Pausable {
1762   /**
1763    * @dev See {ERC721-_beforeTokenTransfer}.
1764    *
1765    * Requirements:
1766    *
1767    * - the contract must not be paused.
1768    */
1769   function _beforeTokenTransfer(
1770     address from,
1771     address to,
1772     uint256 tokenId
1773   ) internal virtual override {
1774     super._beforeTokenTransfer(from, to, tokenId);
1775 
1776     require(!paused(), "ERC721Pausable: token transfer while paused");
1777   }
1778 }
1779 
1780 // File contracts/IERC2981.sol
1781 
1782 // https://eips.ethereum.org/EIPS/eip-2981
1783 
1784 /// @dev Interface for the NFT Royalty Standard
1785 interface IERC2981 {
1786   /**
1787    * @notice Called with the sale price to determine how much royalty
1788    *         is owed and to whom.
1789    * @param tokenId - the NFT asset queried for royalty information
1790    * @param value - the sale price of the NFT asset specified by _tokenId
1791    * @return receiver - address of who should be sent the royalty payment
1792    * @return royaltyAmount - the royalty payment amount for _value sale price
1793    */
1794   function royaltyInfo(uint256 tokenId, uint256 value)
1795     external
1796     returns (address receiver, uint256 royaltyAmount);
1797 }
1798 
1799 // File contracts/ERC2981.sol
1800 
1801 abstract contract ERC2981 is ERC165, IERC2981 {
1802   function royaltyInfo(uint256 _tokenId, uint256 _value)
1803     external
1804     virtual
1805     override
1806     returns (address _receiver, uint256 _royaltyAmount);
1807 
1808   function supportsInterface(bytes4 interfaceId)
1809     public
1810     view
1811     virtual
1812     override(ERC165)
1813     returns (bool)
1814   {
1815     return
1816       interfaceId == type(IERC2981).interfaceId ||
1817       super.supportsInterface(interfaceId);
1818   }
1819 }
1820 
1821 // File contracts/NFT.sol
1822 
1823 contract NFT is
1824   AccessControl,
1825   ERC2981,
1826   ERC721Enumerable,
1827   ERC721Burnable,
1828   ERC721Pausable
1829 {
1830   event RoyaltyWalletChanged(
1831     address indexed previousWallet,
1832     address indexed newWallet
1833   );
1834   event RoyaltyFeeChanged(uint256 previousFee, uint256 newFee);
1835   event BaseURIChanged(string previousURI, string newURI);
1836 
1837   bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
1838   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1839 
1840   uint256 public constant ROYALTY_FEE_DENOMINATOR = 100000;
1841   uint256 public royaltyFee;
1842   address public royaltyWallet;
1843 
1844   string private _baseTokenURI;
1845 
1846   /**
1847    * @param _name ERC721 token name
1848    * @param _symbol ERC721 token symbol
1849    * @param _uri Base token uri
1850    * @param _royaltyWallet Wallet where royalties should be sent
1851    * @param _royaltyFee Fee numerator to be used for fees
1852    */
1853   constructor(
1854     string memory _name,
1855     string memory _symbol,
1856     string memory _uri,
1857     address _royaltyWallet,
1858     uint256 _royaltyFee
1859   ) ERC721(_name, _symbol) {
1860     _setBaseTokenURI(_uri);
1861     _setRoyaltyWallet(_royaltyWallet);
1862     _setRoyaltyFee(_royaltyFee);
1863     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1864     _setupRole(OWNER_ROLE, msg.sender);
1865     _setupRole(MINTER_ROLE, msg.sender);
1866   }
1867 
1868   /**
1869    * @dev Throws if called by any account other than owners. Implemented using the underlying AccessControl methods.
1870    */
1871   modifier onlyOwners() {
1872     require(
1873       hasRole(OWNER_ROLE, _msgSender()),
1874       "Caller does not have the OWNER_ROLE"
1875     );
1876     _;
1877   }
1878 
1879   /**
1880    * @dev Throws if called by any account other than minters. Implemented using the underlying AccessControl methods.
1881    */
1882   modifier onlyMinters() {
1883     require(
1884       hasRole(MINTER_ROLE, _msgSender()),
1885       "Caller does not have the MINTER_ROLE"
1886     );
1887     _;
1888   }
1889 
1890   /**
1891    * @dev Mints the specified token ids to the recipient addresses
1892    * @param recipient Address that will receive the tokens
1893    * @param tokenIds Array of tokenIds to be minted
1894    */
1895   function mint(address recipient, uint256[] calldata tokenIds)
1896     external
1897     onlyMinters
1898   {
1899     for (uint256 i = 0; i < tokenIds.length; i++) {
1900       _mint(recipient, tokenIds[i]);
1901     }
1902   }
1903 
1904   /**
1905    * @dev Mints the specified token id to the recipient addresses
1906    * @dev The unused string parameter exists to support the API used by ChainBridge.
1907    * @param recipient Address that will receive the tokens
1908    * @param tokenId tokenId to be minted
1909    */
1910   function mint(
1911     address recipient,
1912     uint256 tokenId,
1913     string calldata
1914   ) external onlyMinters {
1915     _mint(recipient, tokenId);
1916   }
1917 
1918   /**
1919    * @dev Pauses token transfers
1920    */
1921   function pause() external onlyOwners {
1922     _pause();
1923   }
1924 
1925   /**
1926    * @dev Unpauses token transfers
1927    */
1928   function unpause() external onlyOwners {
1929     _unpause();
1930   }
1931 
1932   /**
1933    * @dev Sets the base token URI
1934    * @param uri Base token URI
1935    */
1936   function setBaseTokenURI(string calldata uri) external onlyOwners {
1937     _setBaseTokenURI(uri);
1938   }
1939 
1940   /**
1941    * @dev Sets the wallet to which royalties should be sent
1942    * @param _royaltyWallet Address that should receive the royalties
1943    */
1944   function setRoyaltyWallet(address _royaltyWallet) external onlyOwners {
1945     _setRoyaltyWallet(_royaltyWallet);
1946   }
1947 
1948   /**
1949    * @dev Sets the fee percentage for royalties
1950    * @param _royaltyFee Basis points to compute royalty percentage
1951    */
1952   function setRoyaltyFee(uint256 _royaltyFee) external onlyOwners {
1953     _setRoyaltyFee(_royaltyFee);
1954   }
1955 
1956   /**
1957    * @dev Function defined by ERC2981, which provides information about fees.
1958    * @param value Price being paid for the token (in base units)
1959    */
1960   function royaltyInfo(
1961     uint256, // tokenId is not used in this case as all tokens take the same fee
1962     uint256 value
1963   )
1964     external
1965     view
1966     override
1967     returns (
1968       address, // receiver
1969       uint256 // royaltyAmount
1970     )
1971   {
1972     return (royaltyWallet, (value * royaltyFee) / ROYALTY_FEE_DENOMINATOR);
1973   }
1974 
1975   /**
1976    * @dev For each existing tokenId, it returns the URI where metadata is stored
1977    * @param tokenId Token id
1978    */
1979   function tokenURI(uint256 tokenId)
1980     public
1981     view
1982     override
1983     returns (string memory)
1984   {
1985     string memory uri = super.tokenURI(tokenId);
1986     return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1987   }
1988 
1989   function supportsInterface(bytes4 interfaceId)
1990     public
1991     view
1992     override(AccessControl, ERC2981, ERC721, ERC721Enumerable)
1993     returns (bool)
1994   {
1995     return super.supportsInterface(interfaceId);
1996   }
1997 
1998   function _beforeTokenTransfer(
1999     address from,
2000     address to,
2001     uint256 tokenId
2002   ) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
2003     super._beforeTokenTransfer(from, to, tokenId);
2004   }
2005 
2006   function _setBaseTokenURI(string memory newURI) internal {
2007     emit BaseURIChanged(_baseTokenURI, newURI);
2008     _baseTokenURI = newURI;
2009   }
2010 
2011   function _setRoyaltyWallet(address _royaltyWallet) internal {
2012     require(_royaltyWallet != address(0), "INVALID_WALLET");
2013     emit RoyaltyWalletChanged(royaltyWallet, _royaltyWallet);
2014     royaltyWallet = _royaltyWallet;
2015   }
2016 
2017   function _setRoyaltyFee(uint256 _royaltyFee) internal {
2018     require(_royaltyFee <= ROYALTY_FEE_DENOMINATOR, "INVALID_FEE");
2019     emit RoyaltyFeeChanged(royaltyFee, _royaltyFee);
2020     royaltyFee = _royaltyFee;
2021   }
2022 
2023   function _baseURI() internal view override returns (string memory) {
2024     return _baseTokenURI;
2025   }
2026 }