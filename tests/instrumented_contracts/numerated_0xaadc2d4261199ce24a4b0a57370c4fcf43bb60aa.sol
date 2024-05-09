1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/utils/Strings.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant alphabet = "0123456789abcdef";
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
42      */
43     function toString(uint256 value) internal pure returns (string memory) {
44         // Inspired by OraclizeAPI's implementation - MIT licence
45         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = alphabet[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 
96 }
97 
98 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
99 
100 
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC165 standard, as defined in the
106  * https://eips.ethereum.org/EIPS/eip-165[EIP].
107  *
108  * Implementers can declare support of contract interfaces, which can then be
109  * queried by others ({ERC165Checker}).
110  *
111  * For an implementation, see {ERC165}.
112  */
113 interface IERC165 {
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30 000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 }
124 
125 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
126 
127 
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Implementation of the {IERC165} interface.
134  *
135  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
136  * for the additional interface id that will be supported. For example:
137  *
138  * ```solidity
139  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
140  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
141  * }
142  * ```
143  *
144  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
145  */
146 abstract contract ERC165 is IERC165 {
147     /**
148      * @dev See {IERC165-supportsInterface}.
149      */
150     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
151         return interfaceId == type(IERC165).interfaceId;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/access/AccessControl.sol
156 
157 
158 
159 pragma solidity ^0.8.0;
160 
161 
162 
163 
164 /**
165  * @dev External interface of AccessControl declared to support ERC165 detection.
166  */
167 interface IAccessControl {
168     function hasRole(bytes32 role, address account) external view returns (bool);
169     function getRoleAdmin(bytes32 role) external view returns (bytes32);
170     function grantRole(bytes32 role, address account) external;
171     function revokeRole(bytes32 role, address account) external;
172     function renounceRole(bytes32 role, address account) external;
173 }
174 
175 /**
176  * @dev Contract module that allows children to implement role-based access
177  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
178  * members except through off-chain means by accessing the contract event logs. Some
179  * applications may benefit from on-chain enumerability, for those cases see
180  * {AccessControlEnumerable}.
181  *
182  * Roles are referred to by their `bytes32` identifier. These should be exposed
183  * in the external API and be unique. The best way to achieve this is by
184  * using `public constant` hash digests:
185  *
186  * ```
187  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
188  * ```
189  *
190  * Roles can be used to represent a set of permissions. To restrict access to a
191  * function call, use {hasRole}:
192  *
193  * ```
194  * function foo() public {
195  *     require(hasRole(MY_ROLE, msg.sender));
196  *     ...
197  * }
198  * ```
199  *
200  * Roles can be granted and revoked dynamically via the {grantRole} and
201  * {revokeRole} functions. Each role has an associated admin role, and only
202  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
203  *
204  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
205  * that only accounts with this role will be able to grant or revoke other
206  * roles. More complex role relationships can be created by using
207  * {_setRoleAdmin}.
208  *
209  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
210  * grant and revoke this role. Extra precautions should be taken to secure
211  * accounts that have been granted it.
212  */
213 abstract contract AccessControl is Context, IAccessControl, ERC165 {
214     struct RoleData {
215         mapping (address => bool) members;
216         bytes32 adminRole;
217     }
218 
219     mapping (bytes32 => RoleData) private _roles;
220 
221     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
222 
223     /**
224      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
225      *
226      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
227      * {RoleAdminChanged} not being emitted signaling this.
228      *
229      * _Available since v3.1._
230      */
231     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
232 
233     /**
234      * @dev Emitted when `account` is granted `role`.
235      *
236      * `sender` is the account that originated the contract call, an admin role
237      * bearer except when using {_setupRole}.
238      */
239     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
240 
241     /**
242      * @dev Emitted when `account` is revoked `role`.
243      *
244      * `sender` is the account that originated the contract call:
245      *   - if using `revokeRole`, it is the admin role bearer
246      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
247      */
248     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
249 
250     /**
251      * @dev Modifier that checks that an account has a specific role. Reverts
252      * with a standardized message including the required role.
253      *
254      * The format of the revert reason is given by the following regular expression:
255      *
256      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
257      *
258      * _Available since v4.1._
259      */
260     modifier onlyRole(bytes32 role) {
261         _checkRole(role, _msgSender());
262         _;
263     }
264 
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IAccessControl).interfaceId
270             || super.supportsInterface(interfaceId);
271     }
272 
273     /**
274      * @dev Returns `true` if `account` has been granted `role`.
275      */
276     function hasRole(bytes32 role, address account) public view override returns (bool) {
277         return _roles[role].members[account];
278     }
279 
280     /**
281      * @dev Revert with a standard message if `account` is missing `role`.
282      *
283      * The format of the revert reason is given by the following regular expression:
284      *
285      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
286      */
287     function _checkRole(bytes32 role, address account) internal view {
288         if(!hasRole(role, account)) {
289             revert(string(abi.encodePacked(
290                 "AccessControl: account ",
291                 Strings.toHexString(uint160(account), 20),
292                 " is missing role ",
293                 Strings.toHexString(uint256(role), 32)
294             )));
295         }
296     }
297 
298     /**
299      * @dev Returns the admin role that controls `role`. See {grantRole} and
300      * {revokeRole}.
301      *
302      * To change a role's admin, use {_setRoleAdmin}.
303      */
304     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
305         return _roles[role].adminRole;
306     }
307 
308     /**
309      * @dev Grants `role` to `account`.
310      *
311      * If `account` had not been already granted `role`, emits a {RoleGranted}
312      * event.
313      *
314      * Requirements:
315      *
316      * - the caller must have ``role``'s admin role.
317      */
318     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
319         _grantRole(role, account);
320     }
321 
322     /**
323      * @dev Revokes `role` from `account`.
324      *
325      * If `account` had been granted `role`, emits a {RoleRevoked} event.
326      *
327      * Requirements:
328      *
329      * - the caller must have ``role``'s admin role.
330      */
331     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
332         _revokeRole(role, account);
333     }
334 
335     /**
336      * @dev Revokes `role` from the calling account.
337      *
338      * Roles are often managed via {grantRole} and {revokeRole}: this function's
339      * purpose is to provide a mechanism for accounts to lose their privileges
340      * if they are compromised (such as when a trusted device is misplaced).
341      *
342      * If the calling account had been granted `role`, emits a {RoleRevoked}
343      * event.
344      *
345      * Requirements:
346      *
347      * - the caller must be `account`.
348      */
349     function renounceRole(bytes32 role, address account) public virtual override {
350         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
351 
352         _revokeRole(role, account);
353     }
354 
355     /**
356      * @dev Grants `role` to `account`.
357      *
358      * If `account` had not been already granted `role`, emits a {RoleGranted}
359      * event. Note that unlike {grantRole}, this function doesn't perform any
360      * checks on the calling account.
361      *
362      * [WARNING]
363      * ====
364      * This function should only be called from the constructor when setting
365      * up the initial roles for the system.
366      *
367      * Using this function in any other way is effectively circumventing the admin
368      * system imposed by {AccessControl}.
369      * ====
370      */
371     function _setupRole(bytes32 role, address account) internal virtual {
372         _grantRole(role, account);
373     }
374 
375     /**
376      * @dev Sets `adminRole` as ``role``'s admin role.
377      *
378      * Emits a {RoleAdminChanged} event.
379      */
380     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
381         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
382         _roles[role].adminRole = adminRole;
383     }
384 
385     function _grantRole(bytes32 role, address account) private {
386         if (!hasRole(role, account)) {
387             _roles[role].members[account] = true;
388             emit RoleGranted(role, account, _msgSender());
389         }
390     }
391 
392     function _revokeRole(bytes32 role, address account) private {
393         if (hasRole(role, account)) {
394             _roles[role].members[account] = false;
395             emit RoleRevoked(role, account, _msgSender());
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Required interface of an ERC721 compliant contract.
409  */
410 interface IERC721 is IERC165 {
411     /**
412      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
418      */
419     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
420 
421     /**
422      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
423      */
424     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
425 
426     /**
427      * @dev Returns the number of tokens in ``owner``'s account.
428      */
429     function balanceOf(address owner) external view returns (uint256 balance);
430 
431     /**
432      * @dev Returns the owner of the `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function ownerOf(uint256 tokenId) external view returns (address owner);
439 
440     /**
441      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
442      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(address from, address to, uint256 tokenId) external;
455 
456     /**
457      * @dev Transfers `tokenId` token from `from` to `to`.
458      *
459      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(address from, address to, uint256 tokenId) external;
471 
472     /**
473      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
474      * The approval is cleared when the token is transferred.
475      *
476      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
477      *
478      * Requirements:
479      *
480      * - The caller must own the token or be an approved operator.
481      * - `tokenId` must exist.
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address to, uint256 tokenId) external;
486 
487     /**
488      * @dev Returns the account approved for `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function getApproved(uint256 tokenId) external view returns (address operator);
495 
496     /**
497      * @dev Approve or remove `operator` as an operator for the caller.
498      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
499      *
500      * Requirements:
501      *
502      * - The `operator` cannot be the caller.
503      *
504      * Emits an {ApprovalForAll} event.
505      */
506     function setApprovalForAll(address operator, bool _approved) external;
507 
508     /**
509      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
510      *
511      * See {setApprovalForAll}
512      */
513     function isApprovedForAll(address owner, address operator) external view returns (bool);
514 
515     /**
516       * @dev Safely transfers `tokenId` token from `from` to `to`.
517       *
518       * Requirements:
519       *
520       * - `from` cannot be the zero address.
521       * - `to` cannot be the zero address.
522       * - `tokenId` token must exist and be owned by `from`.
523       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
524       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525       *
526       * Emits a {Transfer} event.
527       */
528     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 interface IERC721Receiver {
543     /**
544      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
545      * by `operator` from `from`, this function is called.
546      *
547      * It must return its Solidity selector to confirm the token transfer.
548      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
549      *
550      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
551      */
552     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
556 
557 
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Metadata is IERC721 {
567 
568     /**
569      * @dev Returns the token collection name.
570      */
571     function name() external view returns (string memory);
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() external view returns (string memory);
577 
578     /**
579      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
580      */
581     function tokenURI(uint256 tokenId) external view returns (string memory);
582 }
583 
584 // File: @openzeppelin/contracts/utils/Address.sol
585 
586 
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Collection of functions related to the address type
592  */
593 library Address {
594     /**
595      * @dev Returns true if `account` is a contract.
596      *
597      * [IMPORTANT]
598      * ====
599      * It is unsafe to assume that an address for which this function returns
600      * false is an externally-owned account (EOA) and not a contract.
601      *
602      * Among others, `isContract` will return false for the following
603      * types of addresses:
604      *
605      *  - an externally-owned account
606      *  - a contract in construction
607      *  - an address where a contract will be created
608      *  - an address where a contract lived, but was destroyed
609      * ====
610      */
611     function isContract(address account) internal view returns (bool) {
612         // This method relies on extcodesize, which returns 0 for contracts in
613         // construction, since the code is only stored at the end of the
614         // constructor execution.
615 
616         uint256 size;
617         // solhint-disable-next-line no-inline-assembly
618         assembly { size := extcodesize(account) }
619         return size > 0;
620     }
621 
622     /**
623      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
624      * `recipient`, forwarding all available gas and reverting on errors.
625      *
626      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
627      * of certain opcodes, possibly making contracts go over the 2300 gas limit
628      * imposed by `transfer`, making them unable to receive funds via
629      * `transfer`. {sendValue} removes this limitation.
630      *
631      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
632      *
633      * IMPORTANT: because control is transferred to `recipient`, care must be
634      * taken to not create reentrancy vulnerabilities. Consider using
635      * {ReentrancyGuard} or the
636      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
637      */
638     function sendValue(address payable recipient, uint256 amount) internal {
639         require(address(this).balance >= amount, "Address: insufficient balance");
640 
641         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
642         (bool success, ) = recipient.call{ value: amount }("");
643         require(success, "Address: unable to send value, recipient may have reverted");
644     }
645 
646     /**
647      * @dev Performs a Solidity function call using a low level `call`. A
648      * plain`call` is an unsafe replacement for a function call: use this
649      * function instead.
650      *
651      * If `target` reverts with a revert reason, it is bubbled up by this
652      * function (like regular Solidity function calls).
653      *
654      * Returns the raw returned data. To convert to the expected return value,
655      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
656      *
657      * Requirements:
658      *
659      * - `target` must be a contract.
660      * - calling `target` with `data` must not revert.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
665       return functionCall(target, data, "Address: low-level call failed");
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
670      * `errorMessage` as a fallback revert reason when `target` reverts.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
675         return functionCallWithValue(target, data, 0, errorMessage);
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
680      * but also transferring `value` wei to `target`.
681      *
682      * Requirements:
683      *
684      * - the calling contract must have an ETH balance of at least `value`.
685      * - the called Solidity function must be `payable`.
686      *
687      * _Available since v3.1._
688      */
689     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
690         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
695      * with `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
700         require(address(this).balance >= value, "Address: insufficient balance for call");
701         require(isContract(target), "Address: call to non-contract");
702 
703         // solhint-disable-next-line avoid-low-level-calls
704         (bool success, bytes memory returndata) = target.call{ value: value }(data);
705         return _verifyCallResult(success, returndata, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but performing a static call.
711      *
712      * _Available since v3.3._
713      */
714     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
715         return functionStaticCall(target, data, "Address: low-level static call failed");
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
720      * but performing a static call.
721      *
722      * _Available since v3.3._
723      */
724     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
725         require(isContract(target), "Address: static call to non-contract");
726 
727         // solhint-disable-next-line avoid-low-level-calls
728         (bool success, bytes memory returndata) = target.staticcall(data);
729         return _verifyCallResult(success, returndata, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but performing a delegate call.
735      *
736      * _Available since v3.4._
737      */
738     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
739         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
749         require(isContract(target), "Address: delegate call to non-contract");
750 
751         // solhint-disable-next-line avoid-low-level-calls
752         (bool success, bytes memory returndata) = target.delegatecall(data);
753         return _verifyCallResult(success, returndata, errorMessage);
754     }
755 
756     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
757         if (success) {
758             return returndata;
759         } else {
760             // Look for revert reason and bubble it up if present
761             if (returndata.length > 0) {
762                 // The easiest way to bubble the revert reason is using memory via assembly
763 
764                 // solhint-disable-next-line no-inline-assembly
765                 assembly {
766                     let returndata_size := mload(returndata)
767                     revert(add(32, returndata), returndata_size)
768                 }
769             } else {
770                 revert(errorMessage);
771             }
772         }
773     }
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
777 
778 
779 
780 pragma solidity ^0.8.0;
781 
782 
783 
784 
785 
786 
787 
788 
789 /**
790  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
791  * the Metadata extension, but not including the Enumerable extension, which is available separately as
792  * {ERC721Enumerable}.
793  */
794 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
795     using Address for address;
796     using Strings for uint256;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to owner address
805     mapping (uint256 => address) private _owners;
806 
807     // Mapping owner address to token count
808     mapping (address => uint256) private _balances;
809 
810     // Mapping from token ID to approved address
811     mapping (uint256 => address) private _tokenApprovals;
812 
813     // Mapping from owner to operator approvals
814     mapping (address => mapping (address => bool)) private _operatorApprovals;
815 
816     /**
817      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
818      */
819     constructor (string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822     }
823 
824     /**
825      * @dev See {IERC165-supportsInterface}.
826      */
827     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
828         return interfaceId == type(IERC721).interfaceId
829             || interfaceId == type(IERC721Metadata).interfaceId
830             || super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view virtual override returns (uint256) {
837         require(owner != address(0), "ERC721: balance query for the zero address");
838         return _balances[owner];
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
845         address owner = _owners[tokenId];
846         require(owner != address(0), "ERC721: owner query for nonexistent token");
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0
872             ? string(abi.encodePacked(baseURI, tokenId.toString()))
873             : '';
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
878      * in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return "";
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public virtual override {
888         address owner = ERC721.ownerOf(tokenId);
889         require(to != owner, "ERC721: approval to current owner");
890 
891         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             "ERC721: approve caller is not owner nor approved for all"
893         );
894 
895         _approve(to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view virtual override returns (address) {
902         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public virtual override {
911         require(operator != _msgSender(), "ERC721: approve to caller");
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
928         //solhint-disable-next-line max-line-length
929         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
930 
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
938         safeTransferFrom(from, to, tokenId, "");
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
945         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
946         _safeTransfer(from, to, tokenId, _data);
947     }
948 
949     /**
950      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
951      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
952      *
953      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
954      *
955      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
956      * implement alternative mechanisms to perform token transfer, such as signature-based.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must exist and be owned by `from`.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
968         _transfer(from, to, tokenId);
969         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
970     }
971 
972     /**
973      * @dev Returns whether `tokenId` exists.
974      *
975      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
976      *
977      * Tokens start existing when they are minted (`_mint`),
978      * and stop existing when they are burned (`_burn`).
979      */
980     function _exists(uint256 tokenId) internal view virtual returns (bool) {
981         return _owners[tokenId] != address(0);
982     }
983 
984     /**
985      * @dev Returns whether `spender` is allowed to manage `tokenId`.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      */
991     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
992         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
993         address owner = ERC721.ownerOf(tokenId);
994         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
995     }
996 
997     /**
998      * @dev Safely mints `tokenId` and transfers it to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must not exist.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeMint(address to, uint256 tokenId) internal virtual {
1008         _safeMint(to, tokenId, "");
1009     }
1010 
1011     /**
1012      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1013      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1014      */
1015     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1016         _mint(to, tokenId);
1017         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1018     }
1019 
1020     /**
1021      * @dev Mints `tokenId` and transfers it to `to`.
1022      *
1023      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1024      *
1025      * Requirements:
1026      *
1027      * - `tokenId` must not exist.
1028      * - `to` cannot be the zero address.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _mint(address to, uint256 tokenId) internal virtual {
1033         require(to != address(0), "ERC721: mint to the zero address");
1034         require(!_exists(tokenId), "ERC721: token already minted");
1035 
1036         _beforeTokenTransfer(address(0), to, tokenId);
1037 
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(address(0), to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Destroys `tokenId`.
1046      * The approval is cleared when the token is burned.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must exist.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _burn(uint256 tokenId) internal virtual {
1055         address owner = ERC721.ownerOf(tokenId);
1056 
1057         _beforeTokenTransfer(owner, address(0), tokenId);
1058 
1059         // Clear approvals
1060         _approve(address(0), tokenId);
1061 
1062         _balances[owner] -= 1;
1063         delete _owners[tokenId];
1064 
1065         emit Transfer(owner, address(0), tokenId);
1066     }
1067 
1068     /**
1069      * @dev Transfers `tokenId` from `from` to `to`.
1070      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1080         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1081         require(to != address(0), "ERC721: transfer to the zero address");
1082 
1083         _beforeTokenTransfer(from, to, tokenId);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId);
1087 
1088         _balances[from] -= 1;
1089         _balances[to] += 1;
1090         _owners[tokenId] = to;
1091 
1092         emit Transfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `to` to operate on `tokenId`
1097      *
1098      * Emits a {Approval} event.
1099      */
1100     function _approve(address to, uint256 tokenId) internal virtual {
1101         _tokenApprovals[tokenId] = to;
1102         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1107      * The call is not executed if the target address is not a contract.
1108      *
1109      * @param from address representing the previous owner of the given token ID
1110      * @param to target address that will receive the tokens
1111      * @param tokenId uint256 ID of the token to be transferred
1112      * @param _data bytes optional data to send along with the call
1113      * @return bool whether the call correctly returned the expected magic value
1114      */
1115     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1116         private returns (bool)
1117     {
1118         if (to.isContract()) {
1119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1120                 return retval == IERC721Receiver(to).onERC721Received.selector;
1121             } catch (bytes memory reason) {
1122                 if (reason.length == 0) {
1123                     revert("ERC721: transfer to non ERC721Receiver implementer");
1124                 } else {
1125                     // solhint-disable-next-line no-inline-assembly
1126                     assembly {
1127                         revert(add(32, reason), mload(reason))
1128                     }
1129                 }
1130             }
1131         } else {
1132             return true;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any token transfer. This includes minting
1138      * and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1146      * - `from` cannot be the zero address.
1147      * - `to` cannot be the zero address.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1155 
1156 
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1163  * @dev See https://eips.ethereum.org/EIPS/eip-721
1164  */
1165 interface IERC721Enumerable is IERC721 {
1166 
1167     /**
1168      * @dev Returns the total amount of tokens stored by the contract.
1169      */
1170     function totalSupply() external view returns (uint256);
1171 
1172     /**
1173      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1174      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1175      */
1176     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1177 
1178     /**
1179      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1180      * Use along with {totalSupply} to enumerate all tokens.
1181      */
1182     function tokenByIndex(uint256 index) external view returns (uint256);
1183 }
1184 
1185 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1186 
1187 
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 
1192 
1193 /**
1194  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1195  * enumerability of all the token ids in the contract as well as all token ids owned by each
1196  * account.
1197  */
1198 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1199     // Mapping from owner to list of owned token IDs
1200     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1201 
1202     // Mapping from token ID to index of the owner tokens list
1203     mapping(uint256 => uint256) private _ownedTokensIndex;
1204 
1205     // Array with all token ids, used for enumeration
1206     uint256[] private _allTokens;
1207 
1208     // Mapping from token id to position in the allTokens array
1209     mapping(uint256 => uint256) private _allTokensIndex;
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1215         return interfaceId == type(IERC721Enumerable).interfaceId
1216             || super.supportsInterface(interfaceId);
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1221      */
1222     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1223         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1224         return _ownedTokens[owner][index];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721Enumerable-totalSupply}.
1229      */
1230     function totalSupply() public view virtual override returns (uint256) {
1231         return _allTokens.length;
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-tokenByIndex}.
1236      */
1237     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1238         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1239         return _allTokens[index];
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before any token transfer. This includes minting
1244      * and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      *
1255      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1256      */
1257     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1258         super._beforeTokenTransfer(from, to, tokenId);
1259 
1260         if (from == address(0)) {
1261             _addTokenToAllTokensEnumeration(tokenId);
1262         } else if (from != to) {
1263             _removeTokenFromOwnerEnumeration(from, tokenId);
1264         }
1265         if (to == address(0)) {
1266             _removeTokenFromAllTokensEnumeration(tokenId);
1267         } else if (to != from) {
1268             _addTokenToOwnerEnumeration(to, tokenId);
1269         }
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1274      * @param to address representing the new owner of the given token ID
1275      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1276      */
1277     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1278         uint256 length = ERC721.balanceOf(to);
1279         _ownedTokens[to][length] = tokenId;
1280         _ownedTokensIndex[tokenId] = length;
1281     }
1282 
1283     /**
1284      * @dev Private function to add a token to this extension's token tracking data structures.
1285      * @param tokenId uint256 ID of the token to be added to the tokens list
1286      */
1287     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1288         _allTokensIndex[tokenId] = _allTokens.length;
1289         _allTokens.push(tokenId);
1290     }
1291 
1292     /**
1293      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1294      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1295      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1296      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1297      * @param from address representing the previous owner of the given token ID
1298      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1299      */
1300     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1301         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1302         // then delete the last slot (swap and pop).
1303 
1304         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1305         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1306 
1307         // When the token to delete is the last token, the swap operation is unnecessary
1308         if (tokenIndex != lastTokenIndex) {
1309             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1310 
1311             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1312             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1313         }
1314 
1315         // This also deletes the contents at the last position of the array
1316         delete _ownedTokensIndex[tokenId];
1317         delete _ownedTokens[from][lastTokenIndex];
1318     }
1319 
1320     /**
1321      * @dev Private function to remove a token from this extension's token tracking data structures.
1322      * This has O(1) time complexity, but alters the order of the _allTokens array.
1323      * @param tokenId uint256 ID of the token to be removed from the tokens list
1324      */
1325     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1326         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1327         // then delete the last slot (swap and pop).
1328 
1329         uint256 lastTokenIndex = _allTokens.length - 1;
1330         uint256 tokenIndex = _allTokensIndex[tokenId];
1331 
1332         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1333         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1334         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1335         uint256 lastTokenId = _allTokens[lastTokenIndex];
1336 
1337         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1338         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1339 
1340         // This also deletes the contents at the last position of the array
1341         delete _allTokensIndex[tokenId];
1342         _allTokens.pop();
1343     }
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1347 
1348 
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 
1353 
1354 /**
1355  * @title ERC721 Burnable Token
1356  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1357  */
1358 abstract contract ERC721Burnable is Context, ERC721 {
1359     /**
1360      * @dev Burns `tokenId`. See {ERC721-_burn}.
1361      *
1362      * Requirements:
1363      *
1364      * - The caller must own `tokenId` or be an approved operator.
1365      */
1366     function burn(uint256 tokenId) public virtual {
1367         //solhint-disable-next-line max-line-length
1368         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1369         _burn(tokenId);
1370     }
1371 }
1372 
1373 // File: @openzeppelin/contracts/security/Pausable.sol
1374 
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 
1380 /**
1381  * @dev Contract module which allows children to implement an emergency stop
1382  * mechanism that can be triggered by an authorized account.
1383  *
1384  * This module is used through inheritance. It will make available the
1385  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1386  * the functions of your contract. Note that they will not be pausable by
1387  * simply including this module, only once the modifiers are put in place.
1388  */
1389 abstract contract Pausable is Context {
1390     /**
1391      * @dev Emitted when the pause is triggered by `account`.
1392      */
1393     event Paused(address account);
1394 
1395     /**
1396      * @dev Emitted when the pause is lifted by `account`.
1397      */
1398     event Unpaused(address account);
1399 
1400     bool private _paused;
1401 
1402     /**
1403      * @dev Initializes the contract in unpaused state.
1404      */
1405     constructor () {
1406         _paused = false;
1407     }
1408 
1409     /**
1410      * @dev Returns true if the contract is paused, and false otherwise.
1411      */
1412     function paused() public view virtual returns (bool) {
1413         return _paused;
1414     }
1415 
1416     /**
1417      * @dev Modifier to make a function callable only when the contract is not paused.
1418      *
1419      * Requirements:
1420      *
1421      * - The contract must not be paused.
1422      */
1423     modifier whenNotPaused() {
1424         require(!paused(), "Pausable: paused");
1425         _;
1426     }
1427 
1428     /**
1429      * @dev Modifier to make a function callable only when the contract is paused.
1430      *
1431      * Requirements:
1432      *
1433      * - The contract must be paused.
1434      */
1435     modifier whenPaused() {
1436         require(paused(), "Pausable: not paused");
1437         _;
1438     }
1439 
1440     /**
1441      * @dev Triggers stopped state.
1442      *
1443      * Requirements:
1444      *
1445      * - The contract must not be paused.
1446      */
1447     function _pause() internal virtual whenNotPaused {
1448         _paused = true;
1449         emit Paused(_msgSender());
1450     }
1451 
1452     /**
1453      * @dev Returns to normal state.
1454      *
1455      * Requirements:
1456      *
1457      * - The contract must be paused.
1458      */
1459     function _unpause() internal virtual whenPaused {
1460         _paused = false;
1461         emit Unpaused(_msgSender());
1462     }
1463 }
1464 
1465 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1466 
1467 
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 
1472 
1473 /**
1474  * @dev ERC721 token with pausable token transfers, minting and burning.
1475  *
1476  * Useful for scenarios such as preventing trades until the end of an evaluation
1477  * period, or having an emergency switch for freezing all token transfers in the
1478  * event of a large bug.
1479  */
1480 abstract contract ERC721Pausable is ERC721, Pausable {
1481     /**
1482      * @dev See {ERC721-_beforeTokenTransfer}.
1483      *
1484      * Requirements:
1485      *
1486      * - the contract must not be paused.
1487      */
1488     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1489         super._beforeTokenTransfer(from, to, tokenId);
1490 
1491         require(!paused(), "ERC721Pausable: token transfer while paused");
1492     }
1493 }
1494 
1495 // File: contracts/IERC2981.sol
1496 
1497 
1498 pragma solidity 0.8.6;
1499 
1500 // https://eips.ethereum.org/EIPS/eip-2981
1501 
1502 /// @dev Interface for the NFT Royalty Standard
1503 interface IERC2981 {
1504     /**
1505      * @notice Called with the sale price to determine how much royalty
1506      *         is owed and to whom.
1507      * @param tokenId - the NFT asset queried for royalty information
1508      * @param value - the sale price of the NFT asset specified by _tokenId
1509      * @return receiver - address of who should be sent the royalty payment
1510      * @return royaltyAmount - the royalty payment amount for _value sale price
1511      */
1512     function royaltyInfo(
1513         uint256 tokenId,
1514         uint256 value
1515     )
1516         external
1517         returns (
1518             address receiver,
1519             uint256 royaltyAmount
1520         );
1521 }
1522 
1523 // File: contracts/ERC2981.sol
1524 
1525 
1526 pragma solidity 0.8.6;
1527 
1528 
1529 
1530 abstract contract ERC2981 is ERC165, IERC2981 {
1531     function royaltyInfo(
1532         uint256 _tokenId,
1533         uint256 _value
1534     )
1535         external
1536         virtual
1537         override
1538         returns (
1539             address _receiver,
1540             uint256 _royaltyAmount
1541         );
1542 
1543     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
1544         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1545     }
1546 }
1547 
1548 // File: contracts/NFT.sol
1549 
1550 
1551 pragma solidity 0.8.6;
1552 
1553 
1554 
1555 
1556 
1557 
1558 contract NFT is AccessControl, ERC2981, ERC721Enumerable, ERC721Burnable, ERC721Pausable {
1559     event RoyaltyWalletChanged(address indexed previousWallet, address indexed newWallet);
1560     event RoyaltyFeeChanged(uint256 previousFee, uint256 newFee);
1561     event BaseURIChanged(string previousURI, string newURI);
1562 
1563     bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
1564     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1565 
1566     uint256 public constant ROYALTY_FEE_DENOMINATOR = 100000;
1567     uint256 public royaltyFee;
1568     address public royaltyWallet;
1569 
1570     string private _baseTokenURI;
1571 
1572     /**
1573      * @param _name ERC721 token name
1574      * @param _symbol ERC721 token symbol
1575      * @param _uri Base token uri
1576      * @param _royaltyWallet Wallet where royalties should be sent
1577      * @param _royaltyFee Fee numerator to be used for fees
1578      */
1579     constructor(
1580         string memory _name,
1581         string memory _symbol,
1582         string memory _uri,
1583         address _royaltyWallet,
1584         uint256 _royaltyFee
1585     ) ERC721(_name, _symbol) {
1586         _setBaseTokenURI(_uri);
1587         _setRoyaltyWallet(_royaltyWallet);
1588         _setRoyaltyFee(_royaltyFee);
1589         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1590         _setupRole(OWNER_ROLE, msg.sender);
1591         _setupRole(MINTER_ROLE, msg.sender);
1592     }
1593 
1594     /**
1595      * @dev Throws if called by any account other than owners. Implemented using the underlying AccessControl methods.
1596      */
1597     modifier onlyOwners() {
1598         require(hasRole(OWNER_ROLE, _msgSender()), "Caller does not have the OWNER_ROLE");
1599         _;
1600     }
1601 
1602     /**
1603      * @dev Throws if called by any account other than minters. Implemented using the underlying AccessControl methods.
1604      */
1605     modifier onlyMinters() {
1606         require(hasRole(MINTER_ROLE, _msgSender()), "Caller does not have the MINTER_ROLE");
1607         _;
1608     }
1609 
1610     /**
1611      * @dev Mints the specified token ids to the recipient addresses
1612      * @param recipient Address that will receive the tokens
1613      * @param tokenIds Array of tokenIds to be minted
1614      */
1615     function mint(address recipient, uint256[] calldata tokenIds) external onlyMinters {
1616         for (uint256 i = 0; i < tokenIds.length; i++) {
1617             _mint(recipient, tokenIds[i]);
1618         }
1619     }
1620 
1621     /**
1622      * @dev Mints the specified token id to the recipient addresses
1623      * @dev The unused string parameter exists to support the API used by ChainBridge.
1624      * @param recipient Address that will receive the tokens
1625      * @param tokenId tokenId to be minted
1626      */
1627     function mint(address recipient, uint256 tokenId, string calldata) external onlyMinters {
1628         _mint(recipient, tokenId);
1629     }
1630 
1631     /**
1632      * @dev Pauses token transfers
1633      */
1634     function pause() external onlyOwners {
1635         _pause();
1636     }
1637 
1638     /**
1639      * @dev Unpauses token transfers
1640      */
1641     function unpause() external onlyOwners {
1642         _unpause();
1643     }
1644 
1645     /**
1646      * @dev Sets the base token URI
1647      * @param uri Base token URI
1648      */
1649     function setBaseTokenURI(string calldata uri) external onlyOwners {
1650         _setBaseTokenURI(uri);
1651     }
1652 
1653     /**
1654      * @dev Sets the wallet to which royalties should be sent
1655      * @param _royaltyWallet Address that should receive the royalties
1656      */
1657     function setRoyaltyWallet(address _royaltyWallet) external onlyOwners {
1658         _setRoyaltyWallet(_royaltyWallet);
1659     }
1660 
1661     /**
1662      * @dev Sets the fee percentage for royalties
1663      * @param _royaltyFee Basis points to compute royalty percentage
1664      */
1665     function setRoyaltyFee(uint256 _royaltyFee) external onlyOwners {
1666         _setRoyaltyFee(_royaltyFee);
1667     }
1668 
1669     /**
1670      * @dev Function defined by ERC2981, which provides information about fees.
1671      * @param value Price being paid for the token (in base units)
1672      */
1673     function royaltyInfo(
1674         uint256, // tokenId is not used in this case as all tokens take the same fee
1675         uint256 value
1676     )
1677         external
1678         view
1679         override
1680         returns (
1681             address, // receiver
1682             uint256 // royaltyAmount
1683         )
1684     {
1685         return (royaltyWallet, (value * royaltyFee) / ROYALTY_FEE_DENOMINATOR);
1686     }
1687 
1688     /**
1689      * @dev For each existing tokenId, it returns the URI where metadata is stored
1690      * @param tokenId Token id
1691      */
1692     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1693         string memory uri = super.tokenURI(tokenId);
1694         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1695     }
1696 
1697     function supportsInterface(bytes4 interfaceId)
1698         public
1699         view
1700         override(AccessControl, ERC2981, ERC721, ERC721Enumerable)
1701         returns (bool)
1702     {
1703         return super.supportsInterface(interfaceId);
1704     }
1705 
1706     function _beforeTokenTransfer(
1707         address from,
1708         address to,
1709         uint256 tokenId
1710     ) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
1711         super._beforeTokenTransfer(from, to, tokenId);
1712     }
1713 
1714     function _setBaseTokenURI(string memory newURI) internal {
1715         emit BaseURIChanged(_baseTokenURI, newURI);
1716         _baseTokenURI = newURI;
1717     }
1718 
1719     function _setRoyaltyWallet(address _royaltyWallet) internal {
1720         require(_royaltyWallet != address(0), "INVALID_WALLET");
1721         emit RoyaltyWalletChanged(royaltyWallet, _royaltyWallet);
1722         royaltyWallet = _royaltyWallet;
1723     }
1724 
1725     function _setRoyaltyFee(uint256 _royaltyFee) internal {
1726         require(_royaltyFee <= ROYALTY_FEE_DENOMINATOR, "INVALID_FEE");
1727         emit RoyaltyFeeChanged(royaltyFee, _royaltyFee);
1728         royaltyFee = _royaltyFee;
1729     }
1730 
1731     function _baseURI() internal view override returns (string memory) {
1732         return _baseTokenURI;
1733     }
1734 }