1 // File: Tiger_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/access/IAccessControl.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev External interface of AccessControl declared to support ERC165 detection.
13  */
14 interface IAccessControl {
15     /**
16      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
17      *
18      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
19      * {RoleAdminChanged} not being emitted signaling this.
20      *
21      * _Available since v3.1._
22      */
23     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
24 
25     /**
26      * @dev Emitted when `account` is granted `role`.
27      *
28      * `sender` is the account that originated the contract call, an admin role
29      * bearer except when using {AccessControl-_setupRole}.
30      */
31     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
32 
33     /**
34      * @dev Emitted when `account` is revoked `role`.
35      *
36      * `sender` is the account that originated the contract call:
37      *   - if using `revokeRole`, it is the admin role bearer
38      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
39      */
40     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
41 
42     /**
43      * @dev Returns `true` if `account` has been granted `role`.
44      */
45     function hasRole(bytes32 role, address account) external view returns (bool);
46 
47     /**
48      * @dev Returns the admin role that controls `role`. See {grantRole} and
49      * {revokeRole}.
50      *
51      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
52      */
53     function getRoleAdmin(bytes32 role) external view returns (bytes32);
54 
55     /**
56      * @dev Grants `role` to `account`.
57      *
58      * If `account` had not been already granted `role`, emits a {RoleGranted}
59      * event.
60      *
61      * Requirements:
62      *
63      * - the caller must have ``role``'s admin role.
64      */
65     function grantRole(bytes32 role, address account) external;
66 
67     /**
68      * @dev Revokes `role` from `account`.
69      *
70      * If `account` had been granted `role`, emits a {RoleRevoked} event.
71      *
72      * Requirements:
73      *
74      * - the caller must have ``role``'s admin role.
75      */
76     function revokeRole(bytes32 role, address account) external;
77 
78     /**
79      * @dev Revokes `role` from the calling account.
80      *
81      * Roles are often managed via {grantRole} and {revokeRole}: this function's
82      * purpose is to provide a mechanism for accounts to lose their privileges
83      * if they are compromised (such as when a trusted device is misplaced).
84      *
85      * If the calling account had been granted `role`, emits a {RoleRevoked}
86      * event.
87      *
88      * Requirements:
89      *
90      * - the caller must be `account`.
91      */
92     function renounceRole(bytes32 role, address account) external;
93 }
94 
95 // File: @openzeppelin/contracts/utils/Strings.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev String operations.
104  */
105 library Strings {
106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
110      */
111     function toString(uint256 value) internal pure returns (string memory) {
112         // Inspired by OraclizeAPI's implementation - MIT licence
113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
114 
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
135      */
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
151      */
152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
153         bytes memory buffer = new bytes(2 * length + 2);
154         buffer[0] = "0";
155         buffer[1] = "x";
156         for (uint256 i = 2 * length + 1; i > 1; --i) {
157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
158             value >>= 4;
159         }
160         require(value == 0, "Strings: hex length insufficient");
161         return string(buffer);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
196 
197 pragma solidity ^0.8.1;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      *
220      * [IMPORTANT]
221      * ====
222      * You shouldn't rely on `isContract` to protect against flash loan attacks!
223      *
224      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
225      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
226      * constructor.
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize/address.code.length, which returns 0
231         // for contracts in construction, since the code is only stored at the end
232         // of the constructor execution.
233 
234         return account.code.length > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Interface of the ERC165 standard, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-165[EIP].
457  *
458  * Implementers can declare support of contract interfaces, which can then be
459  * queried by others ({ERC165Checker}).
460  *
461  * For an implementation, see {ERC165}.
462  */
463 interface IERC165 {
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Implementation of the {IERC165} interface.
485  *
486  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
487  * for the additional interface id that will be supported. For example:
488  *
489  * ```solidity
490  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
492  * }
493  * ```
494  *
495  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
496  */
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         return interfaceId == type(IERC165).interfaceId;
503     }
504 }
505 
506 // File: @openzeppelin/contracts/access/AccessControl.sol
507 
508 
509 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 
515 
516 
517 /**
518  * @dev Contract module that allows children to implement role-based access
519  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
520  * members except through off-chain means by accessing the contract event logs. Some
521  * applications may benefit from on-chain enumerability, for those cases see
522  * {AccessControlEnumerable}.
523  *
524  * Roles are referred to by their `bytes32` identifier. These should be exposed
525  * in the external API and be unique. The best way to achieve this is by
526  * using `public constant` hash digests:
527  *
528  * ```
529  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
530  * ```
531  *
532  * Roles can be used to represent a set of permissions. To restrict access to a
533  * function call, use {hasRole}:
534  *
535  * ```
536  * function foo() public {
537  *     require(hasRole(MY_ROLE, msg.sender));
538  *     ...
539  * }
540  * ```
541  *
542  * Roles can be granted and revoked dynamically via the {grantRole} and
543  * {revokeRole} functions. Each role has an associated admin role, and only
544  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
545  *
546  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
547  * that only accounts with this role will be able to grant or revoke other
548  * roles. More complex role relationships can be created by using
549  * {_setRoleAdmin}.
550  *
551  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
552  * grant and revoke this role. Extra precautions should be taken to secure
553  * accounts that have been granted it.
554  */
555 abstract contract AccessControl is Context, IAccessControl, ERC165 {
556     struct RoleData {
557         mapping(address => bool) members;
558         bytes32 adminRole;
559     }
560 
561     mapping(bytes32 => RoleData) private _roles;
562 
563     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
564 
565     /**
566      * @dev Modifier that checks that an account has a specific role. Reverts
567      * with a standardized message including the required role.
568      *
569      * The format of the revert reason is given by the following regular expression:
570      *
571      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
572      *
573      * _Available since v4.1._
574      */
575     modifier onlyRole(bytes32 role) {
576         _checkRole(role);
577         _;
578     }
579 
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
585     }
586 
587     /**
588      * @dev Returns `true` if `account` has been granted `role`.
589      */
590     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
591         return _roles[role].members[account];
592     }
593 
594     /**
595      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
596      * Overriding this function changes the behavior of the {onlyRole} modifier.
597      *
598      * Format of the revert message is described in {_checkRole}.
599      *
600      * _Available since v4.6._
601      */
602     function _checkRole(bytes32 role) internal view virtual {
603         _checkRole(role, _msgSender());
604     }
605 
606     /**
607      * @dev Revert with a standard message if `account` is missing `role`.
608      *
609      * The format of the revert reason is given by the following regular expression:
610      *
611      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
612      */
613     function _checkRole(bytes32 role, address account) internal view virtual {
614         if (!hasRole(role, account)) {
615             revert(
616                 string(
617                     abi.encodePacked(
618                         "AccessControl: account ",
619                         Strings.toHexString(uint160(account), 20),
620                         " is missing role ",
621                         Strings.toHexString(uint256(role), 32)
622                     )
623                 )
624             );
625         }
626     }
627 
628     /**
629      * @dev Returns the admin role that controls `role`. See {grantRole} and
630      * {revokeRole}.
631      *
632      * To change a role's admin, use {_setRoleAdmin}.
633      */
634     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
635         return _roles[role].adminRole;
636     }
637 
638     /**
639      * @dev Grants `role` to `account`.
640      *
641      * If `account` had not been already granted `role`, emits a {RoleGranted}
642      * event.
643      *
644      * Requirements:
645      *
646      * - the caller must have ``role``'s admin role.
647      */
648     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
649         _grantRole(role, account);
650     }
651 
652     /**
653      * @dev Revokes `role` from `account`.
654      *
655      * If `account` had been granted `role`, emits a {RoleRevoked} event.
656      *
657      * Requirements:
658      *
659      * - the caller must have ``role``'s admin role.
660      */
661     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
662         _revokeRole(role, account);
663     }
664 
665     /**
666      * @dev Revokes `role` from the calling account.
667      *
668      * Roles are often managed via {grantRole} and {revokeRole}: this function's
669      * purpose is to provide a mechanism for accounts to lose their privileges
670      * if they are compromised (such as when a trusted device is misplaced).
671      *
672      * If the calling account had been revoked `role`, emits a {RoleRevoked}
673      * event.
674      *
675      * Requirements:
676      *
677      * - the caller must be `account`.
678      */
679     function renounceRole(bytes32 role, address account) public virtual override {
680         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
681 
682         _revokeRole(role, account);
683     }
684 
685     /**
686      * @dev Grants `role` to `account`.
687      *
688      * If `account` had not been already granted `role`, emits a {RoleGranted}
689      * event. Note that unlike {grantRole}, this function doesn't perform any
690      * checks on the calling account.
691      *
692      * [WARNING]
693      * ====
694      * This function should only be called from the constructor when setting
695      * up the initial roles for the system.
696      *
697      * Using this function in any other way is effectively circumventing the admin
698      * system imposed by {AccessControl}.
699      * ====
700      *
701      * NOTE: This function is deprecated in favor of {_grantRole}.
702      */
703     function _setupRole(bytes32 role, address account) internal virtual {
704         _grantRole(role, account);
705     }
706 
707     /**
708      * @dev Sets `adminRole` as ``role``'s admin role.
709      *
710      * Emits a {RoleAdminChanged} event.
711      */
712     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
713         bytes32 previousAdminRole = getRoleAdmin(role);
714         _roles[role].adminRole = adminRole;
715         emit RoleAdminChanged(role, previousAdminRole, adminRole);
716     }
717 
718     /**
719      * @dev Grants `role` to `account`.
720      *
721      * Internal function without access restriction.
722      */
723     function _grantRole(bytes32 role, address account) internal virtual {
724         if (!hasRole(role, account)) {
725             _roles[role].members[account] = true;
726             emit RoleGranted(role, account, _msgSender());
727         }
728     }
729 
730     /**
731      * @dev Revokes `role` from `account`.
732      *
733      * Internal function without access restriction.
734      */
735     function _revokeRole(bytes32 role, address account) internal virtual {
736         if (hasRole(role, account)) {
737             _roles[role].members[account] = false;
738             emit RoleRevoked(role, account, _msgSender());
739         }
740     }
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
744 
745 
746 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Required interface of an ERC721 compliant contract.
753  */
754 interface IERC721 is IERC165 {
755     /**
756      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
757      */
758     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
759 
760     /**
761      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
762      */
763     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
767      */
768     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
769 
770     /**
771      * @dev Returns the number of tokens in ``owner``'s account.
772      */
773     function balanceOf(address owner) external view returns (uint256 balance);
774 
775     /**
776      * @dev Returns the owner of the `tokenId` token.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function ownerOf(uint256 tokenId) external view returns (address owner);
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes calldata data
802     ) external;
803 
804     /**
805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) external;
823 
824     /**
825      * @dev Transfers `tokenId` token from `from` to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must be owned by `from`.
834      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
835      *
836      * Emits a {Transfer} event.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) external;
843 
844     /**
845      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
846      * The approval is cleared when the token is transferred.
847      *
848      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
849      *
850      * Requirements:
851      *
852      * - The caller must own the token or be an approved operator.
853      * - `tokenId` must exist.
854      *
855      * Emits an {Approval} event.
856      */
857     function approve(address to, uint256 tokenId) external;
858 
859     /**
860      * @dev Approve or remove `operator` as an operator for the caller.
861      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
862      *
863      * Requirements:
864      *
865      * - The `operator` cannot be the caller.
866      *
867      * Emits an {ApprovalForAll} event.
868      */
869     function setApprovalForAll(address operator, bool _approved) external;
870 
871     /**
872      * @dev Returns the account approved for `tokenId` token.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      */
878     function getApproved(uint256 tokenId) external view returns (address operator);
879 
880     /**
881      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
882      *
883      * See {setApprovalForAll}
884      */
885     function isApprovedForAll(address owner, address operator) external view returns (bool);
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
889 
890 
891 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 interface IERC721Enumerable is IERC721 {
901     /**
902      * @dev Returns the total amount of tokens stored by the contract.
903      */
904     function totalSupply() external view returns (uint256);
905 
906     /**
907      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
908      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
909      */
910     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
911 
912     /**
913      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
914      * Use along with {totalSupply} to enumerate all tokens.
915      */
916     function tokenByIndex(uint256 index) external view returns (uint256);
917 }
918 
919 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
929  * @dev See https://eips.ethereum.org/EIPS/eip-721
930  */
931 interface IERC721Metadata is IERC721 {
932     /**
933      * @dev Returns the token collection name.
934      */
935     function name() external view returns (string memory);
936 
937     /**
938      * @dev Returns the token collection symbol.
939      */
940     function symbol() external view returns (string memory);
941 
942     /**
943      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
944      */
945     function tokenURI(uint256 tokenId) external view returns (string memory);
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
949 
950 
951 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 
956 
957 
958 
959 
960 
961 
962 /**
963  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
964  * the Metadata extension, but not including the Enumerable extension, which is available separately as
965  * {ERC721Enumerable}.
966  */
967 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
968     using Address for address;
969     using Strings for uint256;
970 
971     // Token name
972     string private _name;
973 
974     // Token symbol
975     string private _symbol;
976 
977     // Mapping from token ID to owner address
978     mapping(uint256 => address) private _owners;
979 
980     // Mapping owner address to token count
981     mapping(address => uint256) private _balances;
982 
983     // Mapping from token ID to approved address
984     mapping(uint256 => address) private _tokenApprovals;
985 
986     // Mapping from owner to operator approvals
987     mapping(address => mapping(address => bool)) private _operatorApprovals;
988 
989     /**
990      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
991      */
992     constructor(string memory name_, string memory symbol_) {
993         _name = name_;
994         _symbol = symbol_;
995     }
996 
997     /**
998      * @dev See {IERC165-supportsInterface}.
999      */
1000     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1001         return
1002             interfaceId == type(IERC721).interfaceId ||
1003             interfaceId == type(IERC721Metadata).interfaceId ||
1004             super.supportsInterface(interfaceId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-balanceOf}.
1009      */
1010     function balanceOf(address owner) public view virtual override returns (uint256) {
1011         require(owner != address(0), "ERC721: balance query for the zero address");
1012         return _balances[owner];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-ownerOf}.
1017      */
1018     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1019         address owner = _owners[tokenId];
1020         require(owner != address(0), "ERC721: owner query for nonexistent token");
1021         return owner;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-name}.
1026      */
1027     function name() public view virtual override returns (string memory) {
1028         return _name;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-symbol}.
1033      */
1034     function symbol() public view virtual override returns (string memory) {
1035         return _symbol;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-tokenURI}.
1040      */
1041     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1042         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1043 
1044         string memory baseURI = _baseURI();
1045         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1046     }
1047 
1048     /**
1049      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1050      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1051      * by default, can be overridden in child contracts.
1052      */
1053     function _baseURI() internal view virtual returns (string memory) {
1054         return "";
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-approve}.
1059      */
1060     function approve(address to, uint256 tokenId) public virtual override {
1061         address owner = ERC721.ownerOf(tokenId);
1062         require(to != owner, "ERC721: approval to current owner");
1063 
1064         require(
1065             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1066             "ERC721: approve caller is not owner nor approved for all"
1067         );
1068 
1069         _approve(to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-getApproved}.
1074      */
1075     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1076         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1077 
1078         return _tokenApprovals[tokenId];
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-setApprovalForAll}.
1083      */
1084     function setApprovalForAll(address operator, bool approved) public virtual override {
1085         _setApprovalForAll(_msgSender(), operator, approved);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-isApprovedForAll}.
1090      */
1091     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1092         return _operatorApprovals[owner][operator];
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-transferFrom}.
1097      */
1098     function transferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) public virtual override {
1103         //solhint-disable-next-line max-line-length
1104         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1105 
1106         _transfer(from, to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-safeTransferFrom}.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) public virtual override {
1117         safeTransferFrom(from, to, tokenId, "");
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-safeTransferFrom}.
1122      */
1123     function safeTransferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId,
1127         bytes memory _data
1128     ) public virtual override {
1129         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1130         _safeTransfer(from, to, tokenId, _data);
1131     }
1132 
1133     /**
1134      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1135      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1136      *
1137      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1138      *
1139      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1140      * implement alternative mechanisms to perform token transfer, such as signature-based.
1141      *
1142      * Requirements:
1143      *
1144      * - `from` cannot be the zero address.
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must exist and be owned by `from`.
1147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _safeTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) internal virtual {
1157         _transfer(from, to, tokenId);
1158         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1159     }
1160 
1161     /**
1162      * @dev Returns whether `tokenId` exists.
1163      *
1164      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1165      *
1166      * Tokens start existing when they are minted (`_mint`),
1167      * and stop existing when they are burned (`_burn`).
1168      */
1169     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1170         return _owners[tokenId] != address(0);
1171     }
1172 
1173     /**
1174      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      */
1180     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1181         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1182         address owner = ERC721.ownerOf(tokenId);
1183         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1184     }
1185 
1186     /**
1187      * @dev Safely mints `tokenId` and transfers it to `to`.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must not exist.
1192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _safeMint(address to, uint256 tokenId) internal virtual {
1197         _safeMint(to, tokenId, "");
1198     }
1199 
1200     /**
1201      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1202      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1203      */
1204     function _safeMint(
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) internal virtual {
1209         _mint(to, tokenId);
1210         require(
1211             _checkOnERC721Received(address(0), to, tokenId, _data),
1212             "ERC721: transfer to non ERC721Receiver implementer"
1213         );
1214     }
1215 
1216     /**
1217      * @dev Mints `tokenId` and transfers it to `to`.
1218      *
1219      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must not exist.
1224      * - `to` cannot be the zero address.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _mint(address to, uint256 tokenId) internal virtual {
1229         require(to != address(0), "ERC721: mint to the zero address");
1230         require(!_exists(tokenId), "ERC721: token already minted");
1231 
1232         _beforeTokenTransfer(address(0), to, tokenId);
1233 
1234         _balances[to] += 1;
1235         _owners[tokenId] = to;
1236 
1237         emit Transfer(address(0), to, tokenId);
1238 
1239         _afterTokenTransfer(address(0), to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId) internal virtual {
1253         address owner = ERC721.ownerOf(tokenId);
1254 
1255         _beforeTokenTransfer(owner, address(0), tokenId);
1256 
1257         // Clear approvals
1258         _approve(address(0), tokenId);
1259 
1260         _balances[owner] -= 1;
1261         delete _owners[tokenId];
1262 
1263         emit Transfer(owner, address(0), tokenId);
1264 
1265         _afterTokenTransfer(owner, address(0), tokenId);
1266     }
1267 
1268     /**
1269      * @dev Transfers `tokenId` from `from` to `to`.
1270      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `tokenId` token must be owned by `from`.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _transfer(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) internal virtual {
1284         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1285         require(to != address(0), "ERC721: transfer to the zero address");
1286 
1287         _beforeTokenTransfer(from, to, tokenId);
1288 
1289         // Clear approvals from the previous owner
1290         _approve(address(0), tokenId);
1291 
1292         _balances[from] -= 1;
1293         _balances[to] += 1;
1294         _owners[tokenId] = to;
1295 
1296         emit Transfer(from, to, tokenId);
1297 
1298         _afterTokenTransfer(from, to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev Approve `to` to operate on `tokenId`
1303      *
1304      * Emits a {Approval} event.
1305      */
1306     function _approve(address to, uint256 tokenId) internal virtual {
1307         _tokenApprovals[tokenId] = to;
1308         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1309     }
1310 
1311     /**
1312      * @dev Approve `operator` to operate on all of `owner` tokens
1313      *
1314      * Emits a {ApprovalForAll} event.
1315      */
1316     function _setApprovalForAll(
1317         address owner,
1318         address operator,
1319         bool approved
1320     ) internal virtual {
1321         require(owner != operator, "ERC721: approve to caller");
1322         _operatorApprovals[owner][operator] = approved;
1323         emit ApprovalForAll(owner, operator, approved);
1324     }
1325 
1326     /**
1327      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1328      * The call is not executed if the target address is not a contract.
1329      *
1330      * @param from address representing the previous owner of the given token ID
1331      * @param to target address that will receive the tokens
1332      * @param tokenId uint256 ID of the token to be transferred
1333      * @param _data bytes optional data to send along with the call
1334      * @return bool whether the call correctly returned the expected magic value
1335      */
1336     function _checkOnERC721Received(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory _data
1341     ) private returns (bool) {
1342         if (to.isContract()) {
1343             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1344                 return retval == IERC721Receiver.onERC721Received.selector;
1345             } catch (bytes memory reason) {
1346                 if (reason.length == 0) {
1347                     revert("ERC721: transfer to non ERC721Receiver implementer");
1348                 } else {
1349                     assembly {
1350                         revert(add(32, reason), mload(reason))
1351                     }
1352                 }
1353             }
1354         } else {
1355             return true;
1356         }
1357     }
1358 
1359     /**
1360      * @dev Hook that is called before any token transfer. This includes minting
1361      * and burning.
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` will be minted for `to`.
1368      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1369      * - `from` and `to` are never both zero.
1370      *
1371      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1372      */
1373     function _beforeTokenTransfer(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) internal virtual {}
1378 
1379     /**
1380      * @dev Hook that is called after any transfer of tokens. This includes
1381      * minting and burning.
1382      *
1383      * Calling conditions:
1384      *
1385      * - when `from` and `to` are both non-zero.
1386      * - `from` and `to` are never both zero.
1387      *
1388      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1389      */
1390     function _afterTokenTransfer(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) internal virtual {}
1395 }
1396 
1397 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1398 
1399 
1400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1401 
1402 pragma solidity ^0.8.0;
1403 
1404 
1405 
1406 /**
1407  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1408  * enumerability of all the token ids in the contract as well as all token ids owned by each
1409  * account.
1410  */
1411 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1412     // Mapping from owner to list of owned token IDs
1413     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1414 
1415     // Mapping from token ID to index of the owner tokens list
1416     mapping(uint256 => uint256) private _ownedTokensIndex;
1417 
1418     // Array with all token ids, used for enumeration
1419     uint256[] private _allTokens;
1420 
1421     // Mapping from token id to position in the allTokens array
1422     mapping(uint256 => uint256) private _allTokensIndex;
1423 
1424     /**
1425      * @dev See {IERC165-supportsInterface}.
1426      */
1427     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1428         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1433      */
1434     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1435         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1436         return _ownedTokens[owner][index];
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-totalSupply}.
1441      */
1442     function totalSupply() public view virtual override returns (uint256) {
1443         return _allTokens.length;
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Enumerable-tokenByIndex}.
1448      */
1449     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1450         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1451         return _allTokens[index];
1452     }
1453 
1454     /**
1455      * @dev Hook that is called before any token transfer. This includes minting
1456      * and burning.
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` will be minted for `to`.
1463      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1464      * - `from` cannot be the zero address.
1465      * - `to` cannot be the zero address.
1466      *
1467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1468      */
1469     function _beforeTokenTransfer(
1470         address from,
1471         address to,
1472         uint256 tokenId
1473     ) internal virtual override {
1474         super._beforeTokenTransfer(from, to, tokenId);
1475 
1476         if (from == address(0)) {
1477             _addTokenToAllTokensEnumeration(tokenId);
1478         } else if (from != to) {
1479             _removeTokenFromOwnerEnumeration(from, tokenId);
1480         }
1481         if (to == address(0)) {
1482             _removeTokenFromAllTokensEnumeration(tokenId);
1483         } else if (to != from) {
1484             _addTokenToOwnerEnumeration(to, tokenId);
1485         }
1486     }
1487 
1488     /**
1489      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1490      * @param to address representing the new owner of the given token ID
1491      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1492      */
1493     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1494         uint256 length = ERC721.balanceOf(to);
1495         _ownedTokens[to][length] = tokenId;
1496         _ownedTokensIndex[tokenId] = length;
1497     }
1498 
1499     /**
1500      * @dev Private function to add a token to this extension's token tracking data structures.
1501      * @param tokenId uint256 ID of the token to be added to the tokens list
1502      */
1503     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1504         _allTokensIndex[tokenId] = _allTokens.length;
1505         _allTokens.push(tokenId);
1506     }
1507 
1508     /**
1509      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1510      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1511      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1512      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1513      * @param from address representing the previous owner of the given token ID
1514      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1515      */
1516     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1517         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1518         // then delete the last slot (swap and pop).
1519 
1520         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1521         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1522 
1523         // When the token to delete is the last token, the swap operation is unnecessary
1524         if (tokenIndex != lastTokenIndex) {
1525             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1526 
1527             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1528             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1529         }
1530 
1531         // This also deletes the contents at the last position of the array
1532         delete _ownedTokensIndex[tokenId];
1533         delete _ownedTokens[from][lastTokenIndex];
1534     }
1535 
1536     /**
1537      * @dev Private function to remove a token from this extension's token tracking data structures.
1538      * This has O(1) time complexity, but alters the order of the _allTokens array.
1539      * @param tokenId uint256 ID of the token to be removed from the tokens list
1540      */
1541     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1542         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1543         // then delete the last slot (swap and pop).
1544 
1545         uint256 lastTokenIndex = _allTokens.length - 1;
1546         uint256 tokenIndex = _allTokensIndex[tokenId];
1547 
1548         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1549         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1550         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1551         uint256 lastTokenId = _allTokens[lastTokenIndex];
1552 
1553         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1554         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1555 
1556         // This also deletes the contents at the last position of the array
1557         delete _allTokensIndex[tokenId];
1558         _allTokens.pop();
1559     }
1560 }
1561 
1562 // File: contracts/Tiger.sol
1563 
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 
1568 
1569 
1570 
1571 contract Tiger is ERC721, ERC721Enumerable, AccessControl {
1572     using Strings for uint256;
1573     string public baseTokenURI;
1574     bytes32 public constant MINT_TOKEN_ROLE = keccak256("MINT_TOKEN_ROLE");    // Role that can mint tiger item
1575     bytes32 public constant SET_TOKEN_ROLE = keccak256("SET_TOKEN_ROLE");    // Role that can mint tiger item
1576     bytes32 public constant BURN_TOKEN_ROLE = keccak256("BURN_TOKEN_ROLE");    // Role that can mint tiger item
1577     constructor()
1578     ERC721("TigerVC DAO", "Tiger")
1579     {
1580         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1581         _setupRole(SET_TOKEN_ROLE, msg.sender);
1582         _setupRole(MINT_TOKEN_ROLE, msg.sender);
1583     }
1584     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1585         super._beforeTokenTransfer(from, to, tokenId);
1586     }
1587 
1588     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
1589         return super.supportsInterface(interfaceId);
1590     }
1591 
1592     function tokenURI(uint256 tokenId) public override view returns (string memory) {
1593         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1594         string memory baseURI = _baseURI();
1595         string memory uriSuffix = Strings.toString(tokenId);
1596         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, uriSuffix)) : '';
1597     }
1598 
1599     function _baseURI() internal view virtual override returns (string memory) {
1600         return baseTokenURI;
1601     }
1602 
1603     function setBaseURI(string memory _baseTokenURI) public onlyRole(SET_TOKEN_ROLE) {
1604         baseTokenURI = _baseTokenURI;
1605     }
1606 
1607     function mintToken(uint256 _tokenId, address to) public onlyRole(MINT_TOKEN_ROLE) {
1608         require(!_exists(_tokenId), 'The token URI should be unique');
1609         _safeMint(to, _tokenId);
1610     }
1611 
1612     function burnToken(uint256 _tokenId) public onlyRole(BURN_TOKEN_ROLE) {
1613         _burn(_tokenId);
1614     }
1615 }