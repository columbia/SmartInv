1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant alphabet = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = alphabet[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 
95 }
96 
97 
98 
99 
100 /**
101  * @dev Interface of the ERC165 standard, as defined in the
102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
103  *
104  * Implementers can declare support of contract interfaces, which can then be
105  * queried by others ({ERC165Checker}).
106  *
107  * For an implementation, see {ERC165}.
108  */
109 interface IERC165 {
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 }
120 
121 
122 /**
123  * @dev Implementation of the {IERC165} interface.
124  *
125  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
126  * for the additional interface id that will be supported. For example:
127  *
128  * ```solidity
129  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
130  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
131  * }
132  * ```
133  *
134  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
135  */
136 abstract contract ERC165 is IERC165 {
137     /**
138      * @dev See {IERC165-supportsInterface}.
139      */
140     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
141         return interfaceId == type(IERC165).interfaceId;
142     }
143 }
144 
145 
146 /**
147  * @dev External interface of AccessControl declared to support ERC165 detection.
148  */
149 interface IAccessControl {
150     function hasRole(bytes32 role, address account) external view returns (bool);
151     function getRoleAdmin(bytes32 role) external view returns (bytes32);
152     function grantRole(bytes32 role, address account) external;
153     function revokeRole(bytes32 role, address account) external;
154     function renounceRole(bytes32 role, address account) external;
155 }
156 
157 /**
158  * @dev Contract module that allows children to implement role-based access
159  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
160  * members except through off-chain means by accessing the contract event logs. Some
161  * applications may benefit from on-chain enumerability, for those cases see
162  * {AccessControlEnumerable}.
163  *
164  * Roles are referred to by their `bytes32` identifier. These should be exposed
165  * in the external API and be unique. The best way to achieve this is by
166  * using `public constant` hash digests:
167  *
168  * ```
169  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
170  * ```
171  *
172  * Roles can be used to represent a set of permissions. To restrict access to a
173  * function call, use {hasRole}:
174  *
175  * ```
176  * function foo() public {
177  *     require(hasRole(MY_ROLE, msg.sender));
178  *     ...
179  * }
180  * ```
181  *
182  * Roles can be granted and revoked dynamically via the {grantRole} and
183  * {revokeRole} functions. Each role has an associated admin role, and only
184  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
185  *
186  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
187  * that only accounts with this role will be able to grant or revoke other
188  * roles. More complex role relationships can be created by using
189  * {_setRoleAdmin}.
190  *
191  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
192  * grant and revoke this role. Extra precautions should be taken to secure
193  * accounts that have been granted it.
194  */
195 abstract contract AccessControl is Context, IAccessControl, ERC165 {
196     struct RoleData {
197         mapping (address => bool) members;
198         bytes32 adminRole;
199     }
200 
201     mapping (bytes32 => RoleData) private _roles;
202 
203     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
204 
205     /**
206      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
207      *
208      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
209      * {RoleAdminChanged} not being emitted signaling this.
210      *
211      * _Available since v3.1._
212      */
213     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
214 
215     /**
216      * @dev Emitted when `account` is granted `role`.
217      *
218      * `sender` is the account that originated the contract call, an admin role
219      * bearer except when using {_setupRole}.
220      */
221     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
222 
223     /**
224      * @dev Emitted when `account` is revoked `role`.
225      *
226      * `sender` is the account that originated the contract call:
227      *   - if using `revokeRole`, it is the admin role bearer
228      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
229      */
230     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
231 
232     /**
233      * @dev Modifier that checks that an account has a specific role. Reverts
234      * with a standardized message including the required role.
235      *
236      * The format of the revert reason is given by the following regular expression:
237      *
238      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
239      *
240      * _Available since v4.1._
241      */
242     modifier onlyRole(bytes32 role) {
243         _checkRole(role, _msgSender());
244         _;
245     }
246 
247     /**
248      * @dev See {IERC165-supportsInterface}.
249      */
250     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
251         return interfaceId == type(IAccessControl).interfaceId
252             || super.supportsInterface(interfaceId);
253     }
254 
255     /**
256      * @dev Returns `true` if `account` has been granted `role`.
257      */
258     function hasRole(bytes32 role, address account) public view override returns (bool) {
259         return _roles[role].members[account];
260     }
261 
262     /**
263      * @dev Revert with a standard message if `account` is missing `role`.
264      *
265      * The format of the revert reason is given by the following regular expression:
266      *
267      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
268      */
269     function _checkRole(bytes32 role, address account) internal view {
270         if(!hasRole(role, account)) {
271             revert(string(abi.encodePacked(
272                 "AccessControl: account ",
273                 Strings.toHexString(uint160(account), 20),
274                 " is missing role ",
275                 Strings.toHexString(uint256(role), 32)
276             )));
277         }
278     }
279 
280     /**
281      * @dev Returns the admin role that controls `role`. See {grantRole} and
282      * {revokeRole}.
283      *
284      * To change a role's admin, use {_setRoleAdmin}.
285      */
286     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
287         return _roles[role].adminRole;
288     }
289 
290     /**
291      * @dev Grants `role` to `account`.
292      *
293      * If `account` had not been already granted `role`, emits a {RoleGranted}
294      * event.
295      *
296      * Requirements:
297      *
298      * - the caller must have ``role``'s admin role.
299      */
300     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
301         _grantRole(role, account);
302     }
303 
304     /**
305      * @dev Revokes `role` from `account`.
306      *
307      * If `account` had been granted `role`, emits a {RoleRevoked} event.
308      *
309      * Requirements:
310      *
311      * - the caller must have ``role``'s admin role.
312      */
313     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
314         _revokeRole(role, account);
315     }
316 
317     /**
318      * @dev Revokes `role` from the calling account.
319      *
320      * Roles are often managed via {grantRole} and {revokeRole}: this function's
321      * purpose is to provide a mechanism for accounts to lose their privileges
322      * if they are compromised (such as when a trusted device is misplaced).
323      *
324      * If the calling account had been granted `role`, emits a {RoleRevoked}
325      * event.
326      *
327      * Requirements:
328      *
329      * - the caller must be `account`.
330      */
331     function renounceRole(bytes32 role, address account) public virtual override {
332         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
333 
334         _revokeRole(role, account);
335     }
336 
337     /**
338      * @dev Grants `role` to `account`.
339      *
340      * If `account` had not been already granted `role`, emits a {RoleGranted}
341      * event. Note that unlike {grantRole}, this function doesn't perform any
342      * checks on the calling account.
343      *
344      * [WARNING]
345      * ====
346      * This function should only be called from the constructor when setting
347      * up the initial roles for the system.
348      *
349      * Using this function in any other way is effectively circumventing the admin
350      * system imposed by {AccessControl}.
351      * ====
352      */
353     function _setupRole(bytes32 role, address account) internal virtual {
354         _grantRole(role, account);
355     }
356 
357     /**
358      * @dev Sets `adminRole` as ``role``'s admin role.
359      *
360      * Emits a {RoleAdminChanged} event.
361      */
362     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
363         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
364         _roles[role].adminRole = adminRole;
365     }
366 
367     function _grantRole(bytes32 role, address account) private {
368         if (!hasRole(role, account)) {
369             _roles[role].members[account] = true;
370             emit RoleGranted(role, account, _msgSender());
371         }
372     }
373 
374     function _revokeRole(bytes32 role, address account) private {
375         if (hasRole(role, account)) {
376             _roles[role].members[account] = false;
377             emit RoleRevoked(role, account, _msgSender());
378         }
379     }
380 }
381 
382 
383 /**
384  * @dev Required interface of an ERC721 compliant contract.
385  */
386 interface IERC721 is IERC165 {
387     /**
388      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
394      */
395     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in ``owner``'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
418      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(address from, address to, uint256 tokenId) external;
431 
432     /**
433      * @dev Transfers `tokenId` token from `from` to `to`.
434      *
435      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transferFrom(address from, address to, uint256 tokenId) external;
447 
448     /**
449      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
450      * The approval is cleared when the token is transferred.
451      *
452      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
453      *
454      * Requirements:
455      *
456      * - The caller must own the token or be an approved operator.
457      * - `tokenId` must exist.
458      *
459      * Emits an {Approval} event.
460      */
461     function approve(address to, uint256 tokenId) external;
462 
463     /**
464      * @dev Returns the account approved for `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function getApproved(uint256 tokenId) external view returns (address operator);
471 
472     /**
473      * @dev Approve or remove `operator` as an operator for the caller.
474      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
475      *
476      * Requirements:
477      *
478      * - The `operator` cannot be the caller.
479      *
480      * Emits an {ApprovalForAll} event.
481      */
482     function setApprovalForAll(address operator, bool _approved) external;
483 
484     /**
485      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
486      *
487      * See {setApprovalForAll}
488      */
489     function isApprovedForAll(address owner, address operator) external view returns (bool);
490 
491     /**
492       * @dev Safely transfers `tokenId` token from `from` to `to`.
493       *
494       * Requirements:
495       *
496       * - `from` cannot be the zero address.
497       * - `to` cannot be the zero address.
498       * - `tokenId` token must exist and be owned by `from`.
499       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
500       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
501       *
502       * Emits a {Transfer} event.
503       */
504     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
505 }
506 
507 
508 /**
509  * @title ERC721 token receiver interface
510  * @dev Interface for any contract that wants to support safeTransfers
511  * from ERC721 asset contracts.
512  */
513 interface IERC721Receiver {
514     /**
515      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
516      * by `operator` from `from`, this function is called.
517      *
518      * It must return its Solidity selector to confirm the token transfer.
519      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
520      *
521      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
522      */
523     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
524 }
525 
526 
527 
528 
529 
530 /**
531  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
532  * @dev See https://eips.ethereum.org/EIPS/eip-721
533  */
534 interface IERC721Metadata is IERC721 {
535 
536     /**
537      * @dev Returns the token collection name.
538      */
539     function name() external view returns (string memory);
540 
541     /**
542      * @dev Returns the token collection symbol.
543      */
544     function symbol() external view returns (string memory);
545 
546     /**
547      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
548      */
549     function tokenURI(uint256 tokenId) external view returns (string memory);
550 }
551 
552 
553 /**
554  * @dev Collection of functions related to the address type
555  */
556 library Address {
557     /**
558      * @dev Returns true if `account` is a contract.
559      *
560      * [IMPORTANT]
561      * ====
562      * It is unsafe to assume that an address for which this function returns
563      * false is an externally-owned account (EOA) and not a contract.
564      *
565      * Among others, `isContract` will return false for the following
566      * types of addresses:
567      *
568      *  - an externally-owned account
569      *  - a contract in construction
570      *  - an address where a contract will be created
571      *  - an address where a contract lived, but was destroyed
572      * ====
573      */
574     function isContract(address account) internal view returns (bool) {
575         // This method relies on extcodesize, which returns 0 for contracts in
576         // construction, since the code is only stored at the end of the
577         // constructor execution.
578 
579         uint256 size;
580         // solhint-disable-next-line no-inline-assembly
581         assembly { size := extcodesize(account) }
582         return size > 0;
583     }
584 
585     /**
586      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
587      * `recipient`, forwarding all available gas and reverting on errors.
588      *
589      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
590      * of certain opcodes, possibly making contracts go over the 2300 gas limit
591      * imposed by `transfer`, making them unable to receive funds via
592      * `transfer`. {sendValue} removes this limitation.
593      *
594      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
595      *
596      * IMPORTANT: because control is transferred to `recipient`, care must be
597      * taken to not create reentrancy vulnerabilities. Consider using
598      * {ReentrancyGuard} or the
599      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
600      */
601     function sendValue(address payable recipient, uint256 amount) internal {
602         require(address(this).balance >= amount, "Address: insufficient balance");
603 
604         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
605         (bool success, ) = recipient.call{ value: amount }("");
606         require(success, "Address: unable to send value, recipient may have reverted");
607     }
608 
609     /**
610      * @dev Performs a Solidity function call using a low level `call`. A
611      * plain`call` is an unsafe replacement for a function call: use this
612      * function instead.
613      *
614      * If `target` reverts with a revert reason, it is bubbled up by this
615      * function (like regular Solidity function calls).
616      *
617      * Returns the raw returned data. To convert to the expected return value,
618      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
619      *
620      * Requirements:
621      *
622      * - `target` must be a contract.
623      * - calling `target` with `data` must not revert.
624      *
625      * _Available since v3.1._
626      */
627     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
628       return functionCall(target, data, "Address: low-level call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
633      * `errorMessage` as a fallback revert reason when `target` reverts.
634      *
635      * _Available since v3.1._
636      */
637     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
638         return functionCallWithValue(target, data, 0, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but also transferring `value` wei to `target`.
644      *
645      * Requirements:
646      *
647      * - the calling contract must have an ETH balance of at least `value`.
648      * - the called Solidity function must be `payable`.
649      *
650      * _Available since v3.1._
651      */
652     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
653         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
658      * with `errorMessage` as a fallback revert reason when `target` reverts.
659      *
660      * _Available since v3.1._
661      */
662     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
663         require(address(this).balance >= value, "Address: insufficient balance for call");
664         require(isContract(target), "Address: call to non-contract");
665 
666         // solhint-disable-next-line avoid-low-level-calls
667         (bool success, bytes memory returndata) = target.call{ value: value }(data);
668         return _verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a static call.
674      *
675      * _Available since v3.3._
676      */
677     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
678         return functionStaticCall(target, data, "Address: low-level static call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a static call.
684      *
685      * _Available since v3.3._
686      */
687     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
688         require(isContract(target), "Address: static call to non-contract");
689 
690         // solhint-disable-next-line avoid-low-level-calls
691         (bool success, bytes memory returndata) = target.staticcall(data);
692         return _verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but performing a delegate call.
698      *
699      * _Available since v3.4._
700      */
701     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
702         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
707      * but performing a delegate call.
708      *
709      * _Available since v3.4._
710      */
711     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
712         require(isContract(target), "Address: delegate call to non-contract");
713 
714         // solhint-disable-next-line avoid-low-level-calls
715         (bool success, bytes memory returndata) = target.delegatecall(data);
716         return _verifyCallResult(success, returndata, errorMessage);
717     }
718 
719     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
720         if (success) {
721             return returndata;
722         } else {
723             // Look for revert reason and bubble it up if present
724             if (returndata.length > 0) {
725                 // The easiest way to bubble the revert reason is using memory via assembly
726 
727                 // solhint-disable-next-line no-inline-assembly
728                 assembly {
729                     let returndata_size := mload(returndata)
730                     revert(add(32, returndata), returndata_size)
731                 }
732             } else {
733                 revert(errorMessage);
734             }
735         }
736     }
737 }
738 
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension, but not including the Enumerable extension, which is available separately as
743  * {ERC721Enumerable}.
744  */
745 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to owner address
756     mapping (uint256 => address) private _owners;
757 
758     // Mapping owner address to token count
759     mapping (address => uint256) private _balances;
760 
761     // Mapping from token ID to approved address
762     mapping (uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping (address => mapping (address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
769      */
770     constructor (string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return interfaceId == type(IERC721).interfaceId
780             || interfaceId == type(IERC721Metadata).interfaceId
781             || super.supportsInterface(interfaceId);
782     }
783 
784     /**
785      * @dev See {IERC721-balanceOf}.
786      */
787     function balanceOf(address owner) public view virtual override returns (uint256) {
788         require(owner != address(0), "ERC721: balance query for the zero address");
789         return _balances[owner];
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         address owner = _owners[tokenId];
797         require(owner != address(0), "ERC721: owner query for nonexistent token");
798         return owner;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-name}.
803      */
804     function name() public view virtual override returns (string memory) {
805         return _name;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-symbol}.
810      */
811     function symbol() public view virtual override returns (string memory) {
812         return _symbol;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-tokenURI}.
817      */
818     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
819         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
820 
821         string memory baseURI = _baseURI();
822         return bytes(baseURI).length > 0
823             ? string(abi.encodePacked(baseURI, tokenId.toString()))
824             : '';
825     }
826 
827     /**
828      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
829      * in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return "";
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public virtual override {
839         address owner = ERC721.ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
843             "ERC721: approve caller is not owner nor approved for all"
844         );
845 
846         _approve(to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view virtual override returns (address) {
853         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         require(operator != _msgSender(), "ERC721: approve to caller");
863 
864         _operatorApprovals[_msgSender()][operator] = approved;
865         emit ApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
889         safeTransferFrom(from, to, tokenId, "");
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897         _safeTransfer(from, to, tokenId, _data);
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
902      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
903      *
904      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
905      *
906      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
907      * implement alternative mechanisms to perform token transfer, such as signature-based.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
946     }
947 
948     /**
949      * @dev Safely mints `tokenId` and transfers it to `to`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(address to, uint256 tokenId) internal virtual {
959         _safeMint(to, tokenId, "");
960     }
961 
962     /**
963      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
964      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
965      */
966     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
967         _mint(to, tokenId);
968         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993     }
994 
995     /**
996      * @dev Destroys `tokenId`.
997      * The approval is cleared when the token is burned.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _burn(uint256 tokenId) internal virtual {
1006         address owner = ERC721.ownerOf(tokenId);
1007 
1008         _beforeTokenTransfer(owner, address(0), tokenId);
1009 
1010         // Clear approvals
1011         _approve(address(0), tokenId);
1012 
1013         _balances[owner] -= 1;
1014         delete _owners[tokenId];
1015 
1016         emit Transfer(owner, address(0), tokenId);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1031         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1032         require(to != address(0), "ERC721: transfer to the zero address");
1033 
1034         _beforeTokenTransfer(from, to, tokenId);
1035 
1036         // Clear approvals from the previous owner
1037         _approve(address(0), tokenId);
1038 
1039         _balances[from] -= 1;
1040         _balances[to] += 1;
1041         _owners[tokenId] = to;
1042 
1043         emit Transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Approve `to` to operate on `tokenId`
1048      *
1049      * Emits a {Approval} event.
1050      */
1051     function _approve(address to, uint256 tokenId) internal virtual {
1052         _tokenApprovals[tokenId] = to;
1053         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1058      * The call is not executed if the target address is not a contract.
1059      *
1060      * @param from address representing the previous owner of the given token ID
1061      * @param to target address that will receive the tokens
1062      * @param tokenId uint256 ID of the token to be transferred
1063      * @param _data bytes optional data to send along with the call
1064      * @return bool whether the call correctly returned the expected magic value
1065      */
1066     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1067         private returns (bool)
1068     {
1069         if (to.isContract()) {
1070             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1071                 return retval == IERC721Receiver(to).onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert("ERC721: transfer to non ERC721Receiver implementer");
1075                 } else {
1076                     // solhint-disable-next-line no-inline-assembly
1077                     assembly {
1078                         revert(add(32, reason), mload(reason))
1079                     }
1080                 }
1081             }
1082         } else {
1083             return true;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      *
1100      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1101      */
1102     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1103 }
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Enumerable is IERC721 {
1111 
1112     /**
1113      * @dev Returns the total amount of tokens stored by the contract.
1114      */
1115     function totalSupply() external view returns (uint256);
1116 
1117     /**
1118      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1119      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1120      */
1121     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1122 
1123     /**
1124      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1125      * Use along with {totalSupply} to enumerate all tokens.
1126      */
1127     function tokenByIndex(uint256 index) external view returns (uint256);
1128 }
1129 
1130 
1131 /**
1132  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1133  * enumerability of all the token ids in the contract as well as all token ids owned by each
1134  * account.
1135  */
1136 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1137     // Mapping from owner to list of owned token IDs
1138     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1139 
1140     // Mapping from token ID to index of the owner tokens list
1141     mapping(uint256 => uint256) private _ownedTokensIndex;
1142 
1143     // Array with all token ids, used for enumeration
1144     uint256[] private _allTokens;
1145 
1146     // Mapping from token id to position in the allTokens array
1147     mapping(uint256 => uint256) private _allTokensIndex;
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1153         return interfaceId == type(IERC721Enumerable).interfaceId
1154             || super.supportsInterface(interfaceId);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1159      */
1160     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1161         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1162         return _ownedTokens[owner][index];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-totalSupply}.
1167      */
1168     function totalSupply() public view virtual override returns (uint256) {
1169         return _allTokens.length;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Enumerable-tokenByIndex}.
1174      */
1175     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1176         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1177         return _allTokens[index];
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before any token transfer. This includes minting
1182      * and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1190      * - `from` cannot be the zero address.
1191      * - `to` cannot be the zero address.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1196         super._beforeTokenTransfer(from, to, tokenId);
1197 
1198         if (from == address(0)) {
1199             _addTokenToAllTokensEnumeration(tokenId);
1200         } else if (from != to) {
1201             _removeTokenFromOwnerEnumeration(from, tokenId);
1202         }
1203         if (to == address(0)) {
1204             _removeTokenFromAllTokensEnumeration(tokenId);
1205         } else if (to != from) {
1206             _addTokenToOwnerEnumeration(to, tokenId);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1212      * @param to address representing the new owner of the given token ID
1213      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1214      */
1215     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1216         uint256 length = ERC721.balanceOf(to);
1217         _ownedTokens[to][length] = tokenId;
1218         _ownedTokensIndex[tokenId] = length;
1219     }
1220 
1221     /**
1222      * @dev Private function to add a token to this extension's token tracking data structures.
1223      * @param tokenId uint256 ID of the token to be added to the tokens list
1224      */
1225     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1226         _allTokensIndex[tokenId] = _allTokens.length;
1227         _allTokens.push(tokenId);
1228     }
1229 
1230     /**
1231      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1232      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1233      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1234      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1235      * @param from address representing the previous owner of the given token ID
1236      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1237      */
1238     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1239         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1240         // then delete the last slot (swap and pop).
1241 
1242         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1243         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1244 
1245         // When the token to delete is the last token, the swap operation is unnecessary
1246         if (tokenIndex != lastTokenIndex) {
1247             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1248 
1249             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1250             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1251         }
1252 
1253         // This also deletes the contents at the last position of the array
1254         delete _ownedTokensIndex[tokenId];
1255         delete _ownedTokens[from][lastTokenIndex];
1256     }
1257 
1258     /**
1259      * @dev Private function to remove a token from this extension's token tracking data structures.
1260      * This has O(1) time complexity, but alters the order of the _allTokens array.
1261      * @param tokenId uint256 ID of the token to be removed from the tokens list
1262      */
1263     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1264         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1265         // then delete the last slot (swap and pop).
1266 
1267         uint256 lastTokenIndex = _allTokens.length - 1;
1268         uint256 tokenIndex = _allTokensIndex[tokenId];
1269 
1270         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1271         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1272         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1273         uint256 lastTokenId = _allTokens[lastTokenIndex];
1274 
1275         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1276         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1277 
1278         // This also deletes the contents at the last position of the array
1279         delete _allTokensIndex[tokenId];
1280         _allTokens.pop();
1281     }
1282 }
1283 
1284 
1285 /**
1286  * @title ERC721 Burnable Token
1287  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1288  */
1289 abstract contract ERC721Burnable is Context, ERC721 {
1290     /**
1291      * @dev Burns `tokenId`. See {ERC721-_burn}.
1292      *
1293      * Requirements:
1294      *
1295      * - The caller must own `tokenId` or be an approved operator.
1296      */
1297     function burn(uint256 tokenId) public virtual {
1298         //solhint-disable-next-line max-line-length
1299         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1300         _burn(tokenId);
1301     }
1302 }
1303 
1304 
1305 /**
1306  * @dev Contract module which allows children to implement an emergency stop
1307  * mechanism that can be triggered by an authorized account.
1308  *
1309  * This module is used through inheritance. It will make available the
1310  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1311  * the functions of your contract. Note that they will not be pausable by
1312  * simply including this module, only once the modifiers are put in place.
1313  */
1314 abstract contract Pausable is Context {
1315     /**
1316      * @dev Emitted when the pause is triggered by `account`.
1317      */
1318     event Paused(address account);
1319 
1320     /**
1321      * @dev Emitted when the pause is lifted by `account`.
1322      */
1323     event Unpaused(address account);
1324 
1325     bool private _paused;
1326 
1327     /**
1328      * @dev Initializes the contract in unpaused state.
1329      */
1330     constructor () {
1331         _paused = false;
1332     }
1333 
1334     /**
1335      * @dev Returns true if the contract is paused, and false otherwise.
1336      */
1337     function paused() public view virtual returns (bool) {
1338         return _paused;
1339     }
1340 
1341     /**
1342      * @dev Modifier to make a function callable only when the contract is not paused.
1343      *
1344      * Requirements:
1345      *
1346      * - The contract must not be paused.
1347      */
1348     modifier whenNotPaused() {
1349         require(!paused(), "Pausable: paused");
1350         _;
1351     }
1352 
1353     /**
1354      * @dev Modifier to make a function callable only when the contract is paused.
1355      *
1356      * Requirements:
1357      *
1358      * - The contract must be paused.
1359      */
1360     modifier whenPaused() {
1361         require(paused(), "Pausable: not paused");
1362         _;
1363     }
1364 
1365     /**
1366      * @dev Triggers stopped state.
1367      *
1368      * Requirements:
1369      *
1370      * - The contract must not be paused.
1371      */
1372     function _pause() internal virtual whenNotPaused {
1373         _paused = true;
1374         emit Paused(_msgSender());
1375     }
1376 
1377     /**
1378      * @dev Returns to normal state.
1379      *
1380      * Requirements:
1381      *
1382      * - The contract must be paused.
1383      */
1384     function _unpause() internal virtual whenPaused {
1385         _paused = false;
1386         emit Unpaused(_msgSender());
1387     }
1388 }
1389 
1390 
1391 /**
1392  * @dev ERC721 token with pausable token transfers, minting and burning.
1393  *
1394  * Useful for scenarios such as preventing trades until the end of an evaluation
1395  * period, or having an emergency switch for freezing all token transfers in the
1396  * event of a large bug.
1397  */
1398 abstract contract ERC721Pausable is ERC721, Pausable {
1399     /**
1400      * @dev See {ERC721-_beforeTokenTransfer}.
1401      *
1402      * Requirements:
1403      *
1404      * - the contract must not be paused.
1405      */
1406     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1407         super._beforeTokenTransfer(from, to, tokenId);
1408 
1409         require(!paused(), "ERC721Pausable: token transfer while paused");
1410     }
1411 }
1412 
1413 
1414 // https://eips.ethereum.org/EIPS/eip-2981
1415 
1416 /// @dev Interface for the NFT Royalty Standard
1417 interface IERC2981 {
1418     /**
1419      * @notice Called with the sale price to determine how much royalty
1420      *         is owed and to whom.
1421      * @param tokenId - the NFT asset queried for royalty information
1422      * @param value - the sale price of the NFT asset specified by _tokenId
1423      * @return receiver - address of who should be sent the royalty payment
1424      * @return royaltyAmount - the royalty payment amount for _value sale price
1425      */
1426     function royaltyInfo(
1427         uint256 tokenId,
1428         uint256 value
1429     )
1430         external
1431         returns (
1432             address receiver,
1433             uint256 royaltyAmount
1434         );
1435 }
1436 
1437 abstract contract ERC2981 is ERC165, IERC2981 {
1438     function royaltyInfo(
1439         uint256 _tokenId,
1440         uint256 _value
1441     )
1442         external
1443         virtual
1444         override
1445         returns (
1446             address _receiver,
1447             uint256 _royaltyAmount
1448         );
1449 
1450     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
1451         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1452     }
1453 }
1454 
1455 /**
1456  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1457  *
1458  * These functions can be used to verify that a message was signed by the holder
1459  * of the private keys of a given address.
1460  */
1461 library ECDSA {
1462     enum RecoverError {
1463         NoError,
1464         InvalidSignature,
1465         InvalidSignatureLength,
1466         InvalidSignatureS,
1467         InvalidSignatureV
1468     }
1469 
1470     function _throwError(RecoverError error) private pure {
1471         if (error == RecoverError.NoError) {
1472             return; // no error: do nothing
1473         } else if (error == RecoverError.InvalidSignature) {
1474             revert("ECDSA: invalid signature");
1475         } else if (error == RecoverError.InvalidSignatureLength) {
1476             revert("ECDSA: invalid signature length");
1477         } else if (error == RecoverError.InvalidSignatureS) {
1478             revert("ECDSA: invalid signature 's' value");
1479         } else if (error == RecoverError.InvalidSignatureV) {
1480             revert("ECDSA: invalid signature 'v' value");
1481         }
1482     }
1483 
1484     /**
1485      * @dev Returns the address that signed a hashed message (`hash`) with
1486      * `signature` or error string. This address can then be used for verification purposes.
1487      *
1488      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1489      * this function rejects them by requiring the `s` value to be in the lower
1490      * half order, and the `v` value to be either 27 or 28.
1491      *
1492      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1493      * verification to be secure: it is possible to craft signatures that
1494      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1495      * this is by receiving a hash of the original message (which may otherwise
1496      * be too long), and then calling {toEthSignedMessageHash} on it.
1497      *
1498      * Documentation for signature generation:
1499      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1500      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1501      *
1502      * _Available since v4.3._
1503      */
1504     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1505         // Check the signature length
1506         // - case 65: r,s,v signature (standard)
1507         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1508         if (signature.length == 65) {
1509             bytes32 r;
1510             bytes32 s;
1511             uint8 v;
1512             // ecrecover takes the signature parameters, and the only way to get them
1513             // currently is to use assembly.
1514             assembly {
1515                 r := mload(add(signature, 0x20))
1516                 s := mload(add(signature, 0x40))
1517                 v := byte(0, mload(add(signature, 0x60)))
1518             }
1519             return tryRecover(hash, v, r, s);
1520         } else if (signature.length == 64) {
1521             bytes32 r;
1522             bytes32 vs;
1523             // ecrecover takes the signature parameters, and the only way to get them
1524             // currently is to use assembly.
1525             assembly {
1526                 r := mload(add(signature, 0x20))
1527                 vs := mload(add(signature, 0x40))
1528             }
1529             return tryRecover(hash, r, vs);
1530         } else {
1531             return (address(0), RecoverError.InvalidSignatureLength);
1532         }
1533     }
1534 
1535     /**
1536      * @dev Returns the address that signed a hashed message (`hash`) with
1537      * `signature`. This address can then be used for verification purposes.
1538      *
1539      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1540      * this function rejects them by requiring the `s` value to be in the lower
1541      * half order, and the `v` value to be either 27 or 28.
1542      *
1543      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1544      * verification to be secure: it is possible to craft signatures that
1545      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1546      * this is by receiving a hash of the original message (which may otherwise
1547      * be too long), and then calling {toEthSignedMessageHash} on it.
1548      */
1549     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1550         (address recovered, RecoverError error) = tryRecover(hash, signature);
1551         _throwError(error);
1552         return recovered;
1553     }
1554 
1555     /**
1556      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1557      *
1558      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1559      *
1560      * _Available since v4.3._
1561      */
1562     function tryRecover(
1563         bytes32 hash,
1564         bytes32 r,
1565         bytes32 vs
1566     ) internal pure returns (address, RecoverError) {
1567         bytes32 s;
1568         uint8 v;
1569         assembly {
1570             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1571             v := add(shr(255, vs), 27)
1572         }
1573         return tryRecover(hash, v, r, s);
1574     }
1575 
1576     /**
1577      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1578      *
1579      * _Available since v4.2._
1580      */
1581     function recover(
1582         bytes32 hash,
1583         bytes32 r,
1584         bytes32 vs
1585     ) internal pure returns (address) {
1586         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1587         _throwError(error);
1588         return recovered;
1589     }
1590 
1591     /**
1592      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1593      * `r` and `s` signature fields separately.
1594      *
1595      * _Available since v4.3._
1596      */
1597     function tryRecover(
1598         bytes32 hash,
1599         uint8 v,
1600         bytes32 r,
1601         bytes32 s
1602     ) internal pure returns (address, RecoverError) {
1603         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1604         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1605         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1606         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1607         //
1608         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1609         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1610         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1611         // these malleable signatures as well.
1612         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1613             return (address(0), RecoverError.InvalidSignatureS);
1614         }
1615         if (v != 27 && v != 28) {
1616             return (address(0), RecoverError.InvalidSignatureV);
1617         }
1618 
1619         // If the signature is valid (and not malleable), return the signer address
1620         address signer = ecrecover(hash, v, r, s);
1621         if (signer == address(0)) {
1622             return (address(0), RecoverError.InvalidSignature);
1623         }
1624 
1625         return (signer, RecoverError.NoError);
1626     }
1627 
1628     /**
1629      * @dev Overload of {ECDSA-recover} that receives the `v`,
1630      * `r` and `s` signature fields separately.
1631      */
1632     function recover(
1633         bytes32 hash,
1634         uint8 v,
1635         bytes32 r,
1636         bytes32 s
1637     ) internal pure returns (address) {
1638         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1639         _throwError(error);
1640         return recovered;
1641     }
1642 
1643     /**
1644      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1645      * produces hash corresponding to the one signed with the
1646      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1647      * JSON-RPC method as part of EIP-191.
1648      *
1649      * See {recover}.
1650      */
1651     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1652         // 32 is the length in bytes of hash,
1653         // enforced by the type signature above
1654         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1655     }
1656 
1657     /**
1658      * @dev Returns an Ethereum Signed Message, created from `s`. This
1659      * produces hash corresponding to the one signed with the
1660      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1661      * JSON-RPC method as part of EIP-191.
1662      *
1663      * See {recover}.
1664      */
1665     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1666         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1667     }
1668 
1669     /**
1670      * @dev Returns an Ethereum Signed Typed Data, created from a
1671      * `domainSeparator` and a `structHash`. This produces hash corresponding
1672      * to the one signed with the
1673      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1674      * JSON-RPC method as part of EIP-712.
1675      *
1676      * See {recover}.
1677      */
1678     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1679         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1680     }
1681 }
1682 
1683 /**
1684  * @dev Contract module that helps prevent reentrant calls to a function.
1685  *
1686  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1687  * available, which can be applied to functions to make sure there are no nested
1688  * (reentrant) calls to them.
1689  *
1690  * Note that because there is a single `nonReentrant` guard, functions marked as
1691  * `nonReentrant` may not call one another. This can be worked around by making
1692  * those functions `private`, and then adding `external` `nonReentrant` entry
1693  * points to them.
1694  *
1695  * TIP: If you would like to learn more about reentrancy and alternative ways
1696  * to protect against it, check out our blog post
1697  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1698  */
1699 abstract contract ReentrancyGuard {
1700     // Booleans are more expensive than uint256 or any type that takes up a full
1701     // word because each write operation emits an extra SLOAD to first read the
1702     // slot's contents, replace the bits taken up by the boolean, and then write
1703     // back. This is the compiler's defense against contract upgrades and
1704     // pointer aliasing, and it cannot be disabled.
1705 
1706     // The values being non-zero value makes deployment a bit more expensive,
1707     // but in exchange the refund on every call to nonReentrant will be lower in
1708     // amount. Since refunds are capped to a percentage of the total
1709     // transaction's gas, it is best to keep them low in cases like this one, to
1710     // increase the likelihood of the full refund coming into effect.
1711     uint256 private constant _NOT_ENTERED = 1;
1712     uint256 private constant _ENTERED = 2;
1713 
1714     uint256 private _status;
1715 
1716     constructor() {
1717         _status = _NOT_ENTERED;
1718     }
1719 
1720     /**
1721      * @dev Prevents a contract from calling itself, directly or indirectly.
1722      * Calling a `nonReentrant` function from another `nonReentrant`
1723      * function is not supported. It is possible to prevent this from happening
1724      * by making the `nonReentrant` function external, and making it call a
1725      * `private` function that does the actual work.
1726      */
1727     modifier nonReentrant() {
1728         // On the first call to nonReentrant, _notEntered will be true
1729         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1730 
1731         // Any calls to nonReentrant after this point will fail
1732         _status = _ENTERED;
1733 
1734         _;
1735 
1736         // By storing the original value once again, a refund is triggered (see
1737         // https://eips.ethereum.org/EIPS/eip-2200)
1738         _status = _NOT_ENTERED;
1739     }
1740 }
1741 
1742 
1743 // Little Mutants main contract
1744 contract LittleMutants is AccessControl, ERC2981, ERC721Enumerable, ERC721Burnable, ERC721Pausable, ReentrancyGuard {
1745     event RoyaltyWalletChanged(address indexed previousWallet, address indexed newWallet);
1746     event RoyaltyFeeChanged(uint256 previousFee, uint256 newFee);
1747     event BaseURIChanged(string previousURI, string newURI);
1748 
1749     bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
1750 
1751     uint256 public constant ROYALTY_FEE_DENOMINATOR = 100000;
1752     uint256 public royaltyFee;
1753     address public immutable royaltyWallet;
1754     address public immutable mintWallet;
1755 
1756     uint256 public MINT_PRICE = 0.05 ether;
1757     uint256 public COLLECTION_SIZE = 5000;
1758     uint256 public constant COLLECTION_SIZE_MAX = 5000;
1759     uint256 public RESERVED = 100;
1760     uint256 public MINT_WALLET_CAP = 10;
1761     uint256 public WL_WALLET_CAP = 5;
1762 
1763     mapping(address => uint256) public numMinted;
1764 
1765     bool public publicSaleIsActive;
1766 
1767     // Signer address
1768     address public signerAddress = address(0x79c95a5841637857787762cF1443095a64894315);
1769 
1770     string private _baseTokenURI;
1771 
1772     /**
1773      * @param _royaltyWallet Wallet where royalties should be sent
1774      * @param _royaltyFee Fee numerator to be used for fees
1775      */
1776     constructor(
1777         address _royaltyWallet,
1778         address _mintWallet,
1779         uint256 _royaltyFee
1780     ) ERC721("Little Mutants", "LMC") {
1781         royaltyWallet = _royaltyWallet;
1782         _setRoyaltyFee(_royaltyFee);
1783         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1784         _setupRole(OWNER_ROLE, msg.sender);
1785 
1786         mintWallet = _mintWallet;
1787 
1788         //mint token #0 to owner
1789         _mint(msg.sender, 0);
1790 
1791         //pause token transfers until owner enables WL sale, can never be paused again
1792         _pause();
1793     }
1794 
1795     /**
1796      * @dev Throws if called by any account other than owners. Implemented using the underlying AccessControl methods.
1797      */
1798     modifier onlyOwners() {
1799         require(hasRole(OWNER_ROLE, _msgSender()), "Caller does not have the OWNER_ROLE");
1800         _;
1801     }
1802 
1803     /**
1804      * @dev Public mint
1805      */
1806     function mint(uint256 amount) external payable nonReentrant {
1807         uint256 supply = totalSupply();
1808         require( publicSaleIsActive, "Public sale not active");
1809         require( numMinted[msg.sender] + amount <= MINT_WALLET_CAP, "Exceeds mint transaction limit");
1810         require( supply + amount <= COLLECTION_SIZE - RESERVED, "Exceeds maximum supply" );
1811         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1812         for (uint256 i = 0; i < amount; i++) {
1813             _mint(msg.sender, supply + i);
1814         }
1815         numMinted[msg.sender] += amount;
1816     }
1817 
1818     /**
1819      * @dev Whitelist mint
1820      */
1821     function mintWL(uint256 amount, bytes calldata signature) external payable nonReentrant {
1822         uint256 supply = totalSupply();
1823         require( numMinted[msg.sender] + amount <= WL_WALLET_CAP, "Exceeds per transaction limit" );
1824         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1825         require(_validateSignature(
1826           signature,
1827           msg.sender
1828         ), "Invalid data provided");
1829         for (uint256 i = 0; i < amount; i++) {
1830             _mint(msg.sender, supply + i);
1831         }
1832         numMinted[msg.sender] += amount;
1833     }
1834 
1835     function giveAway(address _to, uint256 amount) external onlyOwners {
1836         require( amount <= RESERVED, "Amount exceeds reserved amount for giveaways" );
1837         uint256 supply = totalSupply();
1838         for (uint256 i = 0; i < amount; i++) {
1839             _mint(_to, supply + i);
1840         }
1841         RESERVED -= amount;
1842     }
1843 
1844     /**
1845      * @dev Unpauses token transfers, initiates WL sale. Token transfers can never be paused again.
1846      */
1847     function unpause() external onlyOwners {
1848         _unpause();
1849     }
1850 
1851     /**
1852      * @dev Sets the base token URI
1853      * @param uri Base token URI
1854      */
1855     function setBaseTokenURI(string calldata uri) external onlyOwners {
1856         _setBaseTokenURI(uri);
1857     }
1858 
1859 
1860     /**
1861      * @dev Sets the fee percentage for royalties
1862      * @param _royaltyFee Basis points to compute royalty percentage
1863      */
1864     function setRoyaltyFee(uint256 _royaltyFee) external onlyOwners {
1865         _setRoyaltyFee(_royaltyFee);
1866     }
1867 
1868     /**
1869      * @dev Sets the mint price
1870      */
1871     function setMintPrice(uint256 _mintPrice) external onlyOwners {
1872         MINT_PRICE = _mintPrice;
1873     }
1874 
1875     /**
1876      * @dev Gets the mint price
1877      */
1878     function getMintPrice() external view returns (uint256) {
1879         return MINT_PRICE;
1880     }
1881 
1882     /**
1883      * @dev Sets the mint wallet limit
1884      */
1885     function setMintWalletLimit(uint256 _mintWalletLimit) external onlyOwners {
1886         MINT_WALLET_CAP = _mintWalletLimit;
1887     }
1888 
1889     /**
1890      * @dev Get the mint wallet limit
1891      */
1892     function getMintWalletLimit() external view returns (uint256) {
1893         return MINT_WALLET_CAP;
1894     }
1895 
1896     /**
1897      * @dev Sets the wl mint wallet limit
1898      */
1899     function setWLMintWalletLimit(uint256 _wlMintWalletLimit) external onlyOwners {
1900         WL_WALLET_CAP = _wlMintWalletLimit;
1901     }
1902 
1903     /**
1904      * @dev Get the wl mint wallet limit
1905      */
1906     function getWLMintWalletLimit() external view returns (uint256) {
1907         return WL_WALLET_CAP;
1908     }
1909 
1910     /**
1911      * @dev Sets the signer address
1912      */
1913     function setSignerAddress(address _signerAddress) external onlyOwners {
1914         signerAddress = _signerAddress;
1915     }
1916 
1917     /**
1918      * @dev Set public sale active
1919      */
1920     function setPublicSaleActive(bool _publicSaleIsActive) external onlyOwners {
1921         publicSaleIsActive = _publicSaleIsActive;
1922     }
1923 
1924     /**
1925      * @dev Get public sale active
1926      */
1927     function getPublicSaleIsActive() external view returns (bool) {
1928         return publicSaleIsActive;
1929     }
1930 
1931     /**
1932      * @dev Sets the collection size
1933      */
1934     function setCollectionSize(uint256 _collectionSize) external onlyOwners {
1935         require(_collectionSize <= COLLECTION_SIZE_MAX);
1936         COLLECTION_SIZE = _collectionSize;
1937     }
1938 
1939     /**
1940      * @dev Function defined by ERC2981, which provides information about fees.
1941      * @param value Price being paid for the token (in base units)
1942      */
1943     function royaltyInfo(
1944         uint256, // tokenId is not used in this case as all tokens take the same fee
1945         uint256 value
1946     )
1947         external
1948         view
1949         override
1950         returns (
1951             address, // receiver
1952             uint256 // royaltyAmount
1953         )
1954     {
1955         return (royaltyWallet, (value * royaltyFee) / ROYALTY_FEE_DENOMINATOR);
1956     }
1957 
1958     /**
1959      * @dev For each existing tokenId, it returns the URI where metadata is stored
1960      * @param tokenId Token id
1961      */
1962     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1963         string memory uri = super.tokenURI(tokenId);
1964         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1965     }
1966 
1967     function supportsInterface(bytes4 interfaceId)
1968         public
1969         view
1970         override(AccessControl, ERC2981, ERC721, ERC721Enumerable)
1971         returns (bool)
1972     {
1973         return super.supportsInterface(interfaceId);
1974     }
1975 
1976     function _beforeTokenTransfer(
1977         address from,
1978         address to,
1979         uint256 tokenId
1980     ) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
1981         super._beforeTokenTransfer(from, to, tokenId);
1982     }
1983 
1984     function _setBaseTokenURI(string memory newURI) internal {
1985         emit BaseURIChanged(_baseTokenURI, newURI);
1986         _baseTokenURI = newURI;
1987     }
1988 
1989     function _setRoyaltyFee(uint256 _royaltyFee) internal {
1990         require(_royaltyFee <= ROYALTY_FEE_DENOMINATOR, "INVALID_FEE");
1991         emit RoyaltyFeeChanged(royaltyFee, _royaltyFee);
1992         royaltyFee = _royaltyFee;
1993     }
1994 
1995     function _baseURI() internal view override returns (string memory) {
1996         return _baseTokenURI;
1997     }
1998 
1999     function _validateSignature(
2000         bytes calldata signature,
2001         address senderAddress
2002         ) internal view returns (bool) {
2003         bytes32 dataHash = keccak256(abi.encodePacked(senderAddress));
2004         bytes32 message = ECDSA.toEthSignedMessageHash(dataHash);
2005 
2006         address receivedAddress = ECDSA.recover(message, signature);
2007         return (receivedAddress != address(0) && receivedAddress == signerAddress);
2008     }
2009 
2010     function withdraw() external onlyOwners {
2011         uint256 balance = address(this).balance;
2012         payable(mintWallet).transfer(balance);
2013     }
2014 }