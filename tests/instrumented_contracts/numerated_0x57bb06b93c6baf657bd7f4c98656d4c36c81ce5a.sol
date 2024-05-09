1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Implementation of the {IERC165} interface.
105  *
106  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
107  * for the additional interface id that will be supported. For example:
108  *
109  * ```solidity
110  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
111  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
112  * }
113  * ```
114  *
115  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
116  */
117 abstract contract ERC165 is IERC165 {
118     /**
119      * @dev See {IERC165-supportsInterface}.
120      */
121     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
122         return interfaceId == type(IERC165).interfaceId;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Strings.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev String operations.
135  */
136 library Strings {
137     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
141      */
142     function toString(uint256 value) internal pure returns (string memory) {
143         // Inspired by OraclizeAPI's implementation - MIT licence
144         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
145 
146         if (value == 0) {
147             return "0";
148         }
149         uint256 temp = value;
150         uint256 digits;
151         while (temp != 0) {
152             digits++;
153             temp /= 10;
154         }
155         bytes memory buffer = new bytes(digits);
156         while (value != 0) {
157             digits -= 1;
158             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
159             value /= 10;
160         }
161         return string(buffer);
162     }
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
166      */
167     function toHexString(uint256 value) internal pure returns (string memory) {
168         if (value == 0) {
169             return "0x00";
170         }
171         uint256 temp = value;
172         uint256 length = 0;
173         while (temp != 0) {
174             length++;
175             temp >>= 8;
176         }
177         return toHexString(value, length);
178     }
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
182      */
183     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
184         bytes memory buffer = new bytes(2 * length + 2);
185         buffer[0] = "0";
186         buffer[1] = "x";
187         for (uint256 i = 2 * length + 1; i > 1; --i) {
188             buffer[i] = _HEX_SYMBOLS[value & 0xf];
189             value >>= 4;
190         }
191         require(value == 0, "Strings: hex length insufficient");
192         return string(buffer);
193     }
194 }
195 
196 // File: @openzeppelin/contracts/access/IAccessControl.sol
197 
198 
199 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev External interface of AccessControl declared to support ERC165 detection.
205  */
206 interface IAccessControl {
207     /**
208      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
209      *
210      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
211      * {RoleAdminChanged} not being emitted signaling this.
212      *
213      * _Available since v3.1._
214      */
215     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
216 
217     /**
218      * @dev Emitted when `account` is granted `role`.
219      *
220      * `sender` is the account that originated the contract call, an admin role
221      * bearer except when using {AccessControl-_setupRole}.
222      */
223     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
224 
225     /**
226      * @dev Emitted when `account` is revoked `role`.
227      *
228      * `sender` is the account that originated the contract call:
229      *   - if using `revokeRole`, it is the admin role bearer
230      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
231      */
232     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
233 
234     /**
235      * @dev Returns `true` if `account` has been granted `role`.
236      */
237     function hasRole(bytes32 role, address account) external view returns (bool);
238 
239     /**
240      * @dev Returns the admin role that controls `role`. See {grantRole} and
241      * {revokeRole}.
242      *
243      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
244      */
245     function getRoleAdmin(bytes32 role) external view returns (bytes32);
246 
247     /**
248      * @dev Grants `role` to `account`.
249      *
250      * If `account` had not been already granted `role`, emits a {RoleGranted}
251      * event.
252      *
253      * Requirements:
254      *
255      * - the caller must have ``role``'s admin role.
256      */
257     function grantRole(bytes32 role, address account) external;
258 
259     /**
260      * @dev Revokes `role` from `account`.
261      *
262      * If `account` had been granted `role`, emits a {RoleRevoked} event.
263      *
264      * Requirements:
265      *
266      * - the caller must have ``role``'s admin role.
267      */
268     function revokeRole(bytes32 role, address account) external;
269 
270     /**
271      * @dev Revokes `role` from the calling account.
272      *
273      * Roles are often managed via {grantRole} and {revokeRole}: this function's
274      * purpose is to provide a mechanism for accounts to lose their privileges
275      * if they are compromised (such as when a trusted device is misplaced).
276      *
277      * If the calling account had been granted `role`, emits a {RoleRevoked}
278      * event.
279      *
280      * Requirements:
281      *
282      * - the caller must be `account`.
283      */
284     function renounceRole(bytes32 role, address account) external;
285 }
286 
287 // File: @openzeppelin/contracts/utils/Address.sol
288 
289 
290 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
291 
292 pragma solidity ^0.8.1;
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      *
315      * [IMPORTANT]
316      * ====
317      * You shouldn't rely on `isContract` to protect against flash loan attacks!
318      *
319      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
320      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
321      * constructor.
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // This method relies on extcodesize/address.code.length, which returns 0
326         // for contracts in construction, since the code is only stored at the end
327         // of the constructor execution.
328 
329         return account.code.length > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         (bool success, ) = recipient.call{value: amount}("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain `call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal view returns (bytes memory) {
450         require(isContract(target), "Address: static call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.staticcall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
485      * revert reason using the provided one.
486      *
487      * _Available since v4.3._
488      */
489     function verifyCallResult(
490         bool success,
491         bytes memory returndata,
492         string memory errorMessage
493     ) internal pure returns (bytes memory) {
494         if (success) {
495             return returndata;
496         } else {
497             // Look for revert reason and bubble it up if present
498             if (returndata.length > 0) {
499                 // The easiest way to bubble the revert reason is using memory via assembly
500 
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Context.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Provides information about the current execution context, including the
521  * sender of the transaction and its data. While these are generally available
522  * via msg.sender and msg.data, they should not be accessed in such a direct
523  * manner, since when dealing with meta-transactions the account sending and
524  * paying for execution may not be the actual sender (as far as an application
525  * is concerned).
526  *
527  * This contract is only required for intermediate, library-like contracts.
528  */
529 abstract contract Context {
530     function _msgSender() internal view virtual returns (address) {
531         return msg.sender;
532     }
533 
534     function _msgData() internal view virtual returns (bytes calldata) {
535         return msg.data;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/access/AccessControl.sol
540 
541 
542 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 
548 
549 
550 /**
551  * @dev Contract module that allows children to implement role-based access
552  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
553  * members except through off-chain means by accessing the contract event logs. Some
554  * applications may benefit from on-chain enumerability, for those cases see
555  * {AccessControlEnumerable}.
556  *
557  * Roles are referred to by their `bytes32` identifier. These should be exposed
558  * in the external API and be unique. The best way to achieve this is by
559  * using `public constant` hash digests:
560  *
561  * ```
562  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
563  * ```
564  *
565  * Roles can be used to represent a set of permissions. To restrict access to a
566  * function call, use {hasRole}:
567  *
568  * ```
569  * function foo() public {
570  *     require(hasRole(MY_ROLE, msg.sender));
571  *     ...
572  * }
573  * ```
574  *
575  * Roles can be granted and revoked dynamically via the {grantRole} and
576  * {revokeRole} functions. Each role has an associated admin role, and only
577  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
578  *
579  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
580  * that only accounts with this role will be able to grant or revoke other
581  * roles. More complex role relationships can be created by using
582  * {_setRoleAdmin}.
583  *
584  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
585  * grant and revoke this role. Extra precautions should be taken to secure
586  * accounts that have been granted it.
587  */
588 abstract contract AccessControl is Context, IAccessControl, ERC165 {
589     struct RoleData {
590         mapping(address => bool) members;
591         bytes32 adminRole;
592     }
593 
594     mapping(bytes32 => RoleData) private _roles;
595 
596     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
597 
598     /**
599      * @dev Modifier that checks that an account has a specific role. Reverts
600      * with a standardized message including the required role.
601      *
602      * The format of the revert reason is given by the following regular expression:
603      *
604      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
605      *
606      * _Available since v4.1._
607      */
608     modifier onlyRole(bytes32 role) {
609         _checkRole(role);
610         _;
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
618     }
619 
620     /**
621      * @dev Returns `true` if `account` has been granted `role`.
622      */
623     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
624         return _roles[role].members[account];
625     }
626 
627     /**
628      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
629      * Overriding this function changes the behavior of the {onlyRole} modifier.
630      *
631      * Format of the revert message is described in {_checkRole}.
632      *
633      * _Available since v4.6._
634      */
635     function _checkRole(bytes32 role) internal view virtual {
636         _checkRole(role, _msgSender());
637     }
638 
639     /**
640      * @dev Revert with a standard message if `account` is missing `role`.
641      *
642      * The format of the revert reason is given by the following regular expression:
643      *
644      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
645      */
646     function _checkRole(bytes32 role, address account) internal view virtual {
647         if (!hasRole(role, account)) {
648             revert(
649                 string(
650                     abi.encodePacked(
651                         "AccessControl: account ",
652                         Strings.toHexString(uint160(account), 20),
653                         " is missing role ",
654                         Strings.toHexString(uint256(role), 32)
655                     )
656                 )
657             );
658         }
659     }
660 
661     /**
662      * @dev Returns the admin role that controls `role`. See {grantRole} and
663      * {revokeRole}.
664      *
665      * To change a role's admin, use {_setRoleAdmin}.
666      */
667     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
668         return _roles[role].adminRole;
669     }
670 
671     /**
672      * @dev Grants `role` to `account`.
673      *
674      * If `account` had not been already granted `role`, emits a {RoleGranted}
675      * event.
676      *
677      * Requirements:
678      *
679      * - the caller must have ``role``'s admin role.
680      */
681     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
682         _grantRole(role, account);
683     }
684 
685     /**
686      * @dev Revokes `role` from `account`.
687      *
688      * If `account` had been granted `role`, emits a {RoleRevoked} event.
689      *
690      * Requirements:
691      *
692      * - the caller must have ``role``'s admin role.
693      */
694     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
695         _revokeRole(role, account);
696     }
697 
698     /**
699      * @dev Revokes `role` from the calling account.
700      *
701      * Roles are often managed via {grantRole} and {revokeRole}: this function's
702      * purpose is to provide a mechanism for accounts to lose their privileges
703      * if they are compromised (such as when a trusted device is misplaced).
704      *
705      * If the calling account had been revoked `role`, emits a {RoleRevoked}
706      * event.
707      *
708      * Requirements:
709      *
710      * - the caller must be `account`.
711      */
712     function renounceRole(bytes32 role, address account) public virtual override {
713         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
714 
715         _revokeRole(role, account);
716     }
717 
718     /**
719      * @dev Grants `role` to `account`.
720      *
721      * If `account` had not been already granted `role`, emits a {RoleGranted}
722      * event. Note that unlike {grantRole}, this function doesn't perform any
723      * checks on the calling account.
724      *
725      * [WARNING]
726      * ====
727      * This function should only be called from the constructor when setting
728      * up the initial roles for the system.
729      *
730      * Using this function in any other way is effectively circumventing the admin
731      * system imposed by {AccessControl}.
732      * ====
733      *
734      * NOTE: This function is deprecated in favor of {_grantRole}.
735      */
736     function _setupRole(bytes32 role, address account) internal virtual {
737         _grantRole(role, account);
738     }
739 
740     /**
741      * @dev Sets `adminRole` as ``role``'s admin role.
742      *
743      * Emits a {RoleAdminChanged} event.
744      */
745     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
746         bytes32 previousAdminRole = getRoleAdmin(role);
747         _roles[role].adminRole = adminRole;
748         emit RoleAdminChanged(role, previousAdminRole, adminRole);
749     }
750 
751     /**
752      * @dev Grants `role` to `account`.
753      *
754      * Internal function without access restriction.
755      */
756     function _grantRole(bytes32 role, address account) internal virtual {
757         if (!hasRole(role, account)) {
758             _roles[role].members[account] = true;
759             emit RoleGranted(role, account, _msgSender());
760         }
761     }
762 
763     /**
764      * @dev Revokes `role` from `account`.
765      *
766      * Internal function without access restriction.
767      */
768     function _revokeRole(bytes32 role, address account) internal virtual {
769         if (hasRole(role, account)) {
770             _roles[role].members[account] = false;
771             emit RoleRevoked(role, account, _msgSender());
772         }
773     }
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
777 
778 
779 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 /**
784  * @dev Interface of the ERC20 standard as defined in the EIP.
785  */
786 interface IERC20 {
787     /**
788      * @dev Emitted when `value` tokens are moved from one account (`from`) to
789      * another (`to`).
790      *
791      * Note that `value` may be zero.
792      */
793     event Transfer(address indexed from, address indexed to, uint256 value);
794 
795     /**
796      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
797      * a call to {approve}. `value` is the new allowance.
798      */
799     event Approval(address indexed owner, address indexed spender, uint256 value);
800 
801     /**
802      * @dev Returns the amount of tokens in existence.
803      */
804     function totalSupply() external view returns (uint256);
805 
806     /**
807      * @dev Returns the amount of tokens owned by `account`.
808      */
809     function balanceOf(address account) external view returns (uint256);
810 
811     /**
812      * @dev Moves `amount` tokens from the caller's account to `to`.
813      *
814      * Returns a boolean value indicating whether the operation succeeded.
815      *
816      * Emits a {Transfer} event.
817      */
818     function transfer(address to, uint256 amount) external returns (bool);
819 
820     /**
821      * @dev Returns the remaining number of tokens that `spender` will be
822      * allowed to spend on behalf of `owner` through {transferFrom}. This is
823      * zero by default.
824      *
825      * This value changes when {approve} or {transferFrom} are called.
826      */
827     function allowance(address owner, address spender) external view returns (uint256);
828 
829     /**
830      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
831      *
832      * Returns a boolean value indicating whether the operation succeeded.
833      *
834      * IMPORTANT: Beware that changing an allowance with this method brings the risk
835      * that someone may use both the old and the new allowance by unfortunate
836      * transaction ordering. One possible solution to mitigate this race
837      * condition is to first reduce the spender's allowance to 0 and set the
838      * desired value afterwards:
839      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address spender, uint256 amount) external returns (bool);
844 
845     /**
846      * @dev Moves `amount` tokens from `from` to `to` using the
847      * allowance mechanism. `amount` is then deducted from the caller's
848      * allowance.
849      *
850      * Returns a boolean value indicating whether the operation succeeded.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 amount
858     ) external returns (bool);
859 }
860 
861 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 
869 
870 /**
871  * @title SafeERC20
872  * @dev Wrappers around ERC20 operations that throw on failure (when the token
873  * contract returns false). Tokens that return no value (and instead revert or
874  * throw on failure) are also supported, non-reverting calls are assumed to be
875  * successful.
876  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
877  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
878  */
879 library SafeERC20 {
880     using Address for address;
881 
882     function safeTransfer(
883         IERC20 token,
884         address to,
885         uint256 value
886     ) internal {
887         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
888     }
889 
890     function safeTransferFrom(
891         IERC20 token,
892         address from,
893         address to,
894         uint256 value
895     ) internal {
896         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
897     }
898 
899     /**
900      * @dev Deprecated. This function has issues similar to the ones found in
901      * {IERC20-approve}, and its usage is discouraged.
902      *
903      * Whenever possible, use {safeIncreaseAllowance} and
904      * {safeDecreaseAllowance} instead.
905      */
906     function safeApprove(
907         IERC20 token,
908         address spender,
909         uint256 value
910     ) internal {
911         // safeApprove should only be called when setting an initial allowance,
912         // or when resetting it to zero. To increase and decrease it, use
913         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
914         require(
915             (value == 0) || (token.allowance(address(this), spender) == 0),
916             "SafeERC20: approve from non-zero to non-zero allowance"
917         );
918         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
919     }
920 
921     function safeIncreaseAllowance(
922         IERC20 token,
923         address spender,
924         uint256 value
925     ) internal {
926         uint256 newAllowance = token.allowance(address(this), spender) + value;
927         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
928     }
929 
930     function safeDecreaseAllowance(
931         IERC20 token,
932         address spender,
933         uint256 value
934     ) internal {
935         unchecked {
936             uint256 oldAllowance = token.allowance(address(this), spender);
937             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
938             uint256 newAllowance = oldAllowance - value;
939             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
940         }
941     }
942 
943     /**
944      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
945      * on the return value: the return value is optional (but if data is returned, it must not be false).
946      * @param token The token targeted by the call.
947      * @param data The call data (encoded using abi.encode or one of its variants).
948      */
949     function _callOptionalReturn(IERC20 token, bytes memory data) private {
950         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
951         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
952         // the target address contains contract code and also asserts for success in the low-level call.
953 
954         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
955         if (returndata.length > 0) {
956             // Return data is optional
957             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
958         }
959     }
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @dev Interface for the optional metadata functions from the ERC20 standard.
972  *
973  * _Available since v4.1._
974  */
975 interface IERC20Metadata is IERC20 {
976     /**
977      * @dev Returns the name of the token.
978      */
979     function name() external view returns (string memory);
980 
981     /**
982      * @dev Returns the symbol of the token.
983      */
984     function symbol() external view returns (string memory);
985 
986     /**
987      * @dev Returns the decimals places of the token.
988      */
989     function decimals() external view returns (uint8);
990 }
991 
992 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
993 
994 
995 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 
1001 
1002 /**
1003  * @dev Implementation of the {IERC20} interface.
1004  *
1005  * This implementation is agnostic to the way tokens are created. This means
1006  * that a supply mechanism has to be added in a derived contract using {_mint}.
1007  * For a generic mechanism see {ERC20PresetMinterPauser}.
1008  *
1009  * TIP: For a detailed writeup see our guide
1010  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1011  * to implement supply mechanisms].
1012  *
1013  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1014  * instead returning `false` on failure. This behavior is nonetheless
1015  * conventional and does not conflict with the expectations of ERC20
1016  * applications.
1017  *
1018  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1019  * This allows applications to reconstruct the allowance for all accounts just
1020  * by listening to said events. Other implementations of the EIP may not emit
1021  * these events, as it isn't required by the specification.
1022  *
1023  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1024  * functions have been added to mitigate the well-known issues around setting
1025  * allowances. See {IERC20-approve}.
1026  */
1027 contract ERC20 is Context, IERC20, IERC20Metadata {
1028     mapping(address => uint256) private _balances;
1029 
1030     mapping(address => mapping(address => uint256)) private _allowances;
1031 
1032     uint256 private _totalSupply;
1033 
1034     string private _name;
1035     string private _symbol;
1036 
1037     /**
1038      * @dev Sets the values for {name} and {symbol}.
1039      *
1040      * The default value of {decimals} is 18. To select a different value for
1041      * {decimals} you should overload it.
1042      *
1043      * All two of these values are immutable: they can only be set once during
1044      * construction.
1045      */
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049     }
1050 
1051     /**
1052      * @dev Returns the name of the token.
1053      */
1054     function name() public view virtual override returns (string memory) {
1055         return _name;
1056     }
1057 
1058     /**
1059      * @dev Returns the symbol of the token, usually a shorter version of the
1060      * name.
1061      */
1062     function symbol() public view virtual override returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     /**
1067      * @dev Returns the number of decimals used to get its user representation.
1068      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1069      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1070      *
1071      * Tokens usually opt for a value of 18, imitating the relationship between
1072      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1073      * overridden;
1074      *
1075      * NOTE: This information is only used for _display_ purposes: it in
1076      * no way affects any of the arithmetic of the contract, including
1077      * {IERC20-balanceOf} and {IERC20-transfer}.
1078      */
1079     function decimals() public view virtual override returns (uint8) {
1080         return 18;
1081     }
1082 
1083     /**
1084      * @dev See {IERC20-totalSupply}.
1085      */
1086     function totalSupply() public view virtual override returns (uint256) {
1087         return _totalSupply;
1088     }
1089 
1090     /**
1091      * @dev See {IERC20-balanceOf}.
1092      */
1093     function balanceOf(address account) public view virtual override returns (uint256) {
1094         return _balances[account];
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-transfer}.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - the caller must have a balance of at least `amount`.
1104      */
1105     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1106         address owner = _msgSender();
1107         _transfer(owner, to, amount);
1108         return true;
1109     }
1110 
1111     /**
1112      * @dev See {IERC20-allowance}.
1113      */
1114     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1115         return _allowances[owner][spender];
1116     }
1117 
1118     /**
1119      * @dev See {IERC20-approve}.
1120      *
1121      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1122      * `transferFrom`. This is semantically equivalent to an infinite approval.
1123      *
1124      * Requirements:
1125      *
1126      * - `spender` cannot be the zero address.
1127      */
1128     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1129         address owner = _msgSender();
1130         _approve(owner, spender, amount);
1131         return true;
1132     }
1133 
1134     /**
1135      * @dev See {IERC20-transferFrom}.
1136      *
1137      * Emits an {Approval} event indicating the updated allowance. This is not
1138      * required by the EIP. See the note at the beginning of {ERC20}.
1139      *
1140      * NOTE: Does not update the allowance if the current allowance
1141      * is the maximum `uint256`.
1142      *
1143      * Requirements:
1144      *
1145      * - `from` and `to` cannot be the zero address.
1146      * - `from` must have a balance of at least `amount`.
1147      * - the caller must have allowance for ``from``'s tokens of at least
1148      * `amount`.
1149      */
1150     function transferFrom(
1151         address from,
1152         address to,
1153         uint256 amount
1154     ) public virtual override returns (bool) {
1155         address spender = _msgSender();
1156         _spendAllowance(from, spender, amount);
1157         _transfer(from, to, amount);
1158         return true;
1159     }
1160 
1161     /**
1162      * @dev Atomically increases the allowance granted to `spender` by the caller.
1163      *
1164      * This is an alternative to {approve} that can be used as a mitigation for
1165      * problems described in {IERC20-approve}.
1166      *
1167      * Emits an {Approval} event indicating the updated allowance.
1168      *
1169      * Requirements:
1170      *
1171      * - `spender` cannot be the zero address.
1172      */
1173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1174         address owner = _msgSender();
1175         _approve(owner, spender, allowance(owner, spender) + addedValue);
1176         return true;
1177     }
1178 
1179     /**
1180      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1181      *
1182      * This is an alternative to {approve} that can be used as a mitigation for
1183      * problems described in {IERC20-approve}.
1184      *
1185      * Emits an {Approval} event indicating the updated allowance.
1186      *
1187      * Requirements:
1188      *
1189      * - `spender` cannot be the zero address.
1190      * - `spender` must have allowance for the caller of at least
1191      * `subtractedValue`.
1192      */
1193     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1194         address owner = _msgSender();
1195         uint256 currentAllowance = allowance(owner, spender);
1196         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1197         unchecked {
1198             _approve(owner, spender, currentAllowance - subtractedValue);
1199         }
1200 
1201         return true;
1202     }
1203 
1204     /**
1205      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1206      *
1207      * This internal function is equivalent to {transfer}, and can be used to
1208      * e.g. implement automatic token fees, slashing mechanisms, etc.
1209      *
1210      * Emits a {Transfer} event.
1211      *
1212      * Requirements:
1213      *
1214      * - `from` cannot be the zero address.
1215      * - `to` cannot be the zero address.
1216      * - `from` must have a balance of at least `amount`.
1217      */
1218     function _transfer(
1219         address from,
1220         address to,
1221         uint256 amount
1222     ) internal virtual {
1223         require(from != address(0), "ERC20: transfer from the zero address");
1224         require(to != address(0), "ERC20: transfer to the zero address");
1225 
1226         _beforeTokenTransfer(from, to, amount);
1227 
1228         uint256 fromBalance = _balances[from];
1229         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1230         unchecked {
1231             _balances[from] = fromBalance - amount;
1232         }
1233         _balances[to] += amount;
1234 
1235         emit Transfer(from, to, amount);
1236 
1237         _afterTokenTransfer(from, to, amount);
1238     }
1239 
1240     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1241      * the total supply.
1242      *
1243      * Emits a {Transfer} event with `from` set to the zero address.
1244      *
1245      * Requirements:
1246      *
1247      * - `account` cannot be the zero address.
1248      */
1249     function _mint(address account, uint256 amount) internal virtual {
1250         require(account != address(0), "ERC20: mint to the zero address");
1251 
1252         _beforeTokenTransfer(address(0), account, amount);
1253 
1254         _totalSupply += amount;
1255         _balances[account] += amount;
1256         emit Transfer(address(0), account, amount);
1257 
1258         _afterTokenTransfer(address(0), account, amount);
1259     }
1260 
1261     /**
1262      * @dev Destroys `amount` tokens from `account`, reducing the
1263      * total supply.
1264      *
1265      * Emits a {Transfer} event with `to` set to the zero address.
1266      *
1267      * Requirements:
1268      *
1269      * - `account` cannot be the zero address.
1270      * - `account` must have at least `amount` tokens.
1271      */
1272     function _burn(address account, uint256 amount) internal virtual {
1273         require(account != address(0), "ERC20: burn from the zero address");
1274 
1275         _beforeTokenTransfer(account, address(0), amount);
1276 
1277         uint256 accountBalance = _balances[account];
1278         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1279         unchecked {
1280             _balances[account] = accountBalance - amount;
1281         }
1282         _totalSupply -= amount;
1283 
1284         emit Transfer(account, address(0), amount);
1285 
1286         _afterTokenTransfer(account, address(0), amount);
1287     }
1288 
1289     /**
1290      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1291      *
1292      * This internal function is equivalent to `approve`, and can be used to
1293      * e.g. set automatic allowances for certain subsystems, etc.
1294      *
1295      * Emits an {Approval} event.
1296      *
1297      * Requirements:
1298      *
1299      * - `owner` cannot be the zero address.
1300      * - `spender` cannot be the zero address.
1301      */
1302     function _approve(
1303         address owner,
1304         address spender,
1305         uint256 amount
1306     ) internal virtual {
1307         require(owner != address(0), "ERC20: approve from the zero address");
1308         require(spender != address(0), "ERC20: approve to the zero address");
1309 
1310         _allowances[owner][spender] = amount;
1311         emit Approval(owner, spender, amount);
1312     }
1313 
1314     /**
1315      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1316      *
1317      * Does not update the allowance amount in case of infinite allowance.
1318      * Revert if not enough allowance is available.
1319      *
1320      * Might emit an {Approval} event.
1321      */
1322     function _spendAllowance(
1323         address owner,
1324         address spender,
1325         uint256 amount
1326     ) internal virtual {
1327         uint256 currentAllowance = allowance(owner, spender);
1328         if (currentAllowance != type(uint256).max) {
1329             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1330             unchecked {
1331                 _approve(owner, spender, currentAllowance - amount);
1332             }
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before any transfer of tokens. This includes
1338      * minting and burning.
1339      *
1340      * Calling conditions:
1341      *
1342      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1343      * will be transferred to `to`.
1344      * - when `from` is zero, `amount` tokens will be minted for `to`.
1345      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1346      * - `from` and `to` are never both zero.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 amount
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after any transfer of tokens. This includes
1358      * minting and burning.
1359      *
1360      * Calling conditions:
1361      *
1362      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1363      * has been transferred to `to`.
1364      * - when `from` is zero, `amount` tokens have been minted for `to`.
1365      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1366      * - `from` and `to` are never both zero.
1367      *
1368      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1369      */
1370     function _afterTokenTransfer(
1371         address from,
1372         address to,
1373         uint256 amount
1374     ) internal virtual {}
1375 }
1376 
1377 // File: TigerVC.sol
1378 
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 
1383 
1384 
1385 
1386 interface ITiger {
1387     function mintToken(uint256 _tokenId, address to) external;
1388 }
1389 
1390 contract TigerVC is AccessControl, ReentrancyGuard {
1391     using Strings for uint256;
1392     using SafeERC20 for IERC20;
1393 
1394     ITiger tiger;
1395     uint public offerCount;                     // Index of the current buyable NFT in that type. offCount=0 means no NFT is left in that type
1396     uint public preSaleCount;                   // Index of the presale
1397     uint public maxOfferCount;                  // Index of the current buyable NFT in that type. offCount=0 means no NFT is left in that type
1398     address public paymentToken;                // Contract address of the payment token
1399     uint public unitPrice;                      // Unit price(Wei)
1400     uint public minPurchase = 1;                // Minimum NFT to buy per purchase
1401     uint public maxPurchase = 50;                // Minimum NFT to buy per purchase
1402     bool public paused = true;                  // Pause status
1403     bool public preSalePaused = true;           //Presale Pause status
1404     bool public requireWhitelist = true;        // If require whitelist
1405     mapping(address => uint) public whitelist;  //whitelist users Address-to-claimable-amount mapping
1406     mapping(address => uint) public userPreSaleInfo;  // user presale num mapping
1407     address [] private preSaleUserList;         //user joined presale
1408     address public manager;
1409     address public preSaleFundAddress;
1410     bytes32 public constant PRESALE_ROLE = keccak256("PRESALE_ROLE");    // Role that can mint tiger item
1411     bytes32 public constant OFFICIAL_ROLE = keccak256("OFFICIAL_ROLE");    // Role that can mint tiger item
1412     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");    // Role that can mint tiger item
1413 
1414     event UnitPriceSet(uint unitPrice);
1415     event Mint(uint tokenId);
1416     event Paused();
1417     event UnPaused();
1418     event SetRequireWhitelist();
1419     event SetManager();
1420     event OfferFilled(uint amount, uint totalPrice, address indexed filler, string _referralCode);
1421     event UserFundClaimed(address user, uint fund);
1422     event PreSale(address user, uint amont);
1423 
1424     constructor(){
1425         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1426         _setupRole(OFFICIAL_ROLE, msg.sender);
1427         _setupRole(PRESALE_ROLE, msg.sender);
1428         _setupRole(MANAGER_ROLE, msg.sender);
1429     }
1430     modifier inPause() {
1431         require(paused, "Claims in progress");
1432         _;
1433     }
1434     modifier inProgress() {
1435         require(!paused, "Claims paused");
1436         _;
1437     }
1438     modifier preSaleInPause() {
1439         require(preSalePaused, "preSale in progress");
1440         _;
1441     }
1442     modifier preSaleInProgress() {
1443         require(!preSalePaused, "preSale paused");
1444         _;
1445     }
1446     function setTiger(address _tiger) public onlyRole(MANAGER_ROLE) inPause() {
1447         tiger = ITiger(_tiger);
1448     }
1449 
1450     function setUnitPrice(uint _unitPrice) public onlyRole(MANAGER_ROLE) inPause() {
1451         unitPrice = _unitPrice;
1452         emit UnitPriceSet(_unitPrice);
1453     }
1454 
1455     function pause() public onlyRole(OFFICIAL_ROLE) inProgress() {
1456         paused = true;
1457         emit Paused();
1458     }
1459 
1460     function unpause() public onlyRole(OFFICIAL_ROLE) inPause() {
1461         require(unitPrice > 0, "Unit price is not set");
1462         paused = false;
1463         emit UnPaused();
1464     }
1465 
1466     function preSalePause() public onlyRole(PRESALE_ROLE) preSaleInProgress() {
1467         preSalePaused = true;
1468     }
1469 
1470     function preSaleUnpause() public onlyRole(PRESALE_ROLE) preSaleInPause() {
1471         require(unitPrice > 0, "Unit price is not set");
1472         preSalePaused = false;
1473     }
1474 
1475     function setManager(address _manager) public onlyRole(MANAGER_ROLE) {
1476         manager = _manager;
1477         emit SetManager();
1478     }
1479 
1480     function setPreSaleFundAddress(address _preSaleFundAddress) public onlyRole(MANAGER_ROLE) {
1481         preSaleFundAddress = _preSaleFundAddress;
1482     }
1483 
1484     function setRequireWhitelist(bool _requireWhitelist) public onlyRole(MANAGER_ROLE) {
1485         requireWhitelist = _requireWhitelist;
1486         emit SetRequireWhitelist();
1487     }
1488 
1489     function setWhitelist(address _whitelisted, uint _claimable) public onlyRole(MANAGER_ROLE) {
1490         whitelist[_whitelisted] = _claimable;
1491     }
1492 
1493     function setWhitelistBatch(address[] calldata _whitelisted, uint[] calldata _claimable) public onlyRole(MANAGER_ROLE) inPause() {
1494         require(_whitelisted.length == _claimable.length, "_whitelisted and _claimable should have the same length");
1495         for (uint i = 0; i < _whitelisted.length; i++) {
1496             whitelist[_whitelisted[i]] = _claimable[i];
1497         }
1498     }
1499 
1500     function fillOffersWithReferral(uint _amount, string memory _referralCode) public inProgress() nonReentrant {
1501         require(_amount >= minPurchase, "Amount must >= minPurchase");
1502         require(_amount <= maxPurchase, "Amount must <= maxPurchase");
1503         require(_amount + offerCount <= maxOfferCount, "offer count must <= maxOfferCount");
1504         uint preSaleAmount = userPreSaleInfo[msg.sender];
1505         uint totalPrice = 0;
1506         if (preSaleAmount >= _amount) {
1507             userPreSaleInfo[msg.sender] = userPreSaleInfo[msg.sender] - _amount;
1508         }
1509         if (preSaleAmount < _amount) {
1510             uint needPayAmount = _amount - preSaleAmount;
1511             require((requireWhitelist && whitelist[msg.sender] >= needPayAmount) || !requireWhitelist, "whitelisting for external users is disabled");
1512             delete userPreSaleInfo[msg.sender];
1513             whitelist[msg.sender] = whitelist[msg.sender] - needPayAmount;
1514             totalPrice = unitPrice * needPayAmount;
1515             IERC20(paymentToken).safeTransferFrom(msg.sender, manager, totalPrice);
1516         }
1517 
1518         for (uint i = 1; i <= _amount; i ++) {
1519             _safeMint();
1520         }
1521         emit OfferFilled(_amount, totalPrice, msg.sender, _referralCode);
1522     }
1523 
1524     function quotePrice(address _owner, uint _amount) public view returns (uint price) {
1525         require(_amount >= minPurchase, "Amount must >= minPurchase");
1526         require(_amount <= maxPurchase, "Amount must <= maxPurchase");
1527         require(_amount + offerCount <= maxOfferCount, "offer count must <= maxOfferCount");
1528         uint preSaleAmount = userPreSaleInfo[_owner];
1529         if (preSaleAmount >= _amount) {
1530             return 0;
1531         } else {
1532             uint needPayAmount = _amount - preSaleAmount;
1533             return unitPrice * needPayAmount;
1534         }
1535     }
1536 
1537     function preSale(uint _amount) public preSaleInProgress() nonReentrant {
1538         require(_amount >= minPurchase, "Amount must >= minPurchase");
1539         require(_amount <= maxPurchase, "Amount must <= maxPurchase");
1540         require((requireWhitelist && whitelist[msg.sender] >= _amount) || !requireWhitelist, "whitelisting for external users is disabled");
1541         require(preSaleFundAddress != address(0), "preSaleFundAddress is a zero address");
1542         require(_amount + preSaleCount <= maxOfferCount, "presale count must <= maxOfferCount");
1543 
1544         preSaleCount = preSaleCount + _amount;
1545         uint totalPrice = unitPrice * _amount;
1546         whitelist[msg.sender] = whitelist[msg.sender] - _amount;
1547         IERC20(paymentToken).safeTransferFrom(msg.sender, preSaleFundAddress, totalPrice);
1548         userPreSaleInfo[msg.sender] = userPreSaleInfo[msg.sender] + _amount;
1549         preSaleUserList.push(msg.sender);
1550         emit PreSale(msg.sender, _amount);
1551     }
1552 
1553     function claimFund() public preSaleInProgress() nonReentrant {
1554         require(userPreSaleInfo[msg.sender] >= 1, "No fund to claim");
1555         require(preSaleFundAddress != address(0), "preSaleFundAddress is a zero address");
1556         uint totalPrice = unitPrice * userPreSaleInfo[msg.sender];
1557         whitelist[msg.sender] = whitelist[msg.sender] + userPreSaleInfo[msg.sender];
1558         preSaleCount = preSaleCount - userPreSaleInfo[msg.sender];
1559         delete userPreSaleInfo[msg.sender];
1560         IERC20(paymentToken).safeTransferFrom(preSaleFundAddress, msg.sender, totalPrice);
1561         emit UserFundClaimed(msg.sender, totalPrice);
1562     }
1563 
1564     function clearUserPreSaleInfo() public preSaleInPause() inPause() onlyRole(MANAGER_ROLE) {
1565         for(uint i = 0; i < preSaleUserList.length; i++) {
1566             delete userPreSaleInfo[preSaleUserList[i]];
1567         }
1568         delete preSaleUserList;
1569     }
1570 
1571     function _safeMint() internal {
1572         offerCount ++;
1573         tiger.mintToken(offerCount, msg.sender);
1574         emit Mint(offerCount);
1575     }
1576 
1577     function setOfferCount(uint256 _offerCount) public onlyRole(MANAGER_ROLE) inPause() {
1578         offerCount = _offerCount;
1579     }
1580 
1581     function setMaxOfferCount(uint256 _maxOfferCount) public onlyRole(MANAGER_ROLE) inPause() {
1582         maxOfferCount = _maxOfferCount;
1583     }
1584 
1585     function setPaymentToken(address _paymentToken) public onlyRole(MANAGER_ROLE) inPause() {
1586         paymentToken = _paymentToken;
1587     }
1588 
1589     // Fallback: reverts if Ether is sent to this smart-contract by mistake
1590     fallback() external {
1591         revert();
1592     }
1593 }