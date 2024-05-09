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
67 // File: @openzeppelin/contracts/access/IAccessControl.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev External interface of AccessControl declared to support ERC165 detection.
76  */
77 interface IAccessControl {
78     /**
79      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
80      *
81      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
82      * {RoleAdminChanged} not being emitted signaling this.
83      *
84      * _Available since v3.1._
85      */
86     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
87 
88     /**
89      * @dev Emitted when `account` is granted `role`.
90      *
91      * `sender` is the account that originated the contract call, an admin role
92      * bearer except when using {AccessControl-_setupRole}.
93      */
94     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
95 
96     /**
97      * @dev Emitted when `account` is revoked `role`.
98      *
99      * `sender` is the account that originated the contract call:
100      *   - if using `revokeRole`, it is the admin role bearer
101      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
102      */
103     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
104 
105     /**
106      * @dev Returns `true` if `account` has been granted `role`.
107      */
108     function hasRole(bytes32 role, address account) external view returns (bool);
109 
110     /**
111      * @dev Returns the admin role that controls `role`. See {grantRole} and
112      * {revokeRole}.
113      *
114      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
115      */
116     function getRoleAdmin(bytes32 role) external view returns (bytes32);
117 
118     /**
119      * @dev Grants `role` to `account`.
120      *
121      * If `account` had not been already granted `role`, emits a {RoleGranted}
122      * event.
123      *
124      * Requirements:
125      *
126      * - the caller must have ``role``'s admin role.
127      */
128     function grantRole(bytes32 role, address account) external;
129 
130     /**
131      * @dev Revokes `role` from `account`.
132      *
133      * If `account` had been granted `role`, emits a {RoleRevoked} event.
134      *
135      * Requirements:
136      *
137      * - the caller must have ``role``'s admin role.
138      */
139     function revokeRole(bytes32 role, address account) external;
140 
141     /**
142      * @dev Revokes `role` from the calling account.
143      *
144      * Roles are often managed via {grantRole} and {revokeRole}: this function's
145      * purpose is to provide a mechanism for accounts to lose their privileges
146      * if they are compromised (such as when a trusted device is misplaced).
147      *
148      * If the calling account had been granted `role`, emits a {RoleRevoked}
149      * event.
150      *
151      * Requirements:
152      *
153      * - the caller must be `account`.
154      */
155     function renounceRole(bytes32 role, address account) external;
156 }
157 
158 // File: @openzeppelin/contracts/utils/Strings.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Context.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/security/Pausable.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which allows children to implement an emergency stop
265  * mechanism that can be triggered by an authorized account.
266  *
267  * This module is used through inheritance. It will make available the
268  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
269  * the functions of your contract. Note that they will not be pausable by
270  * simply including this module, only once the modifiers are put in place.
271  */
272 abstract contract Pausable is Context {
273     /**
274      * @dev Emitted when the pause is triggered by `account`.
275      */
276     event Paused(address account);
277 
278     /**
279      * @dev Emitted when the pause is lifted by `account`.
280      */
281     event Unpaused(address account);
282 
283     bool private _paused;
284 
285     /**
286      * @dev Initializes the contract in unpaused state.
287      */
288     constructor() {
289         _paused = false;
290     }
291 
292     /**
293      * @dev Returns true if the contract is paused, and false otherwise.
294      */
295     function paused() public view virtual returns (bool) {
296         return _paused;
297     }
298 
299     /**
300      * @dev Modifier to make a function callable only when the contract is not paused.
301      *
302      * Requirements:
303      *
304      * - The contract must not be paused.
305      */
306     modifier whenNotPaused() {
307         require(!paused(), "Pausable: paused");
308         _;
309     }
310 
311     /**
312      * @dev Modifier to make a function callable only when the contract is paused.
313      *
314      * Requirements:
315      *
316      * - The contract must be paused.
317      */
318     modifier whenPaused() {
319         require(paused(), "Pausable: not paused");
320         _;
321     }
322 
323     /**
324      * @dev Triggers stopped state.
325      *
326      * Requirements:
327      *
328      * - The contract must not be paused.
329      */
330     function _pause() internal virtual whenNotPaused {
331         _paused = true;
332         emit Paused(_msgSender());
333     }
334 
335     /**
336      * @dev Returns to normal state.
337      *
338      * Requirements:
339      *
340      * - The contract must be paused.
341      */
342     function _unpause() internal virtual whenPaused {
343         _paused = false;
344         emit Unpaused(_msgSender());
345     }
346 }
347 
348 // File: @openzeppelin/contracts/utils/Address.sol
349 
350 
351 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
352 
353 pragma solidity ^0.8.1;
354 
355 /**
356  * @dev Collection of functions related to the address type
357  */
358 library Address {
359     /**
360      * @dev Returns true if `account` is a contract.
361      *
362      * [IMPORTANT]
363      * ====
364      * It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      *
367      * Among others, `isContract` will return false for the following
368      * types of addresses:
369      *
370      *  - an externally-owned account
371      *  - a contract in construction
372      *  - an address where a contract will be created
373      *  - an address where a contract lived, but was destroyed
374      * ====
375      *
376      * [IMPORTANT]
377      * ====
378      * You shouldn't rely on `isContract` to protect against flash loan attacks!
379      *
380      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
381      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
382      * constructor.
383      * ====
384      */
385     function isContract(address account) internal view returns (bool) {
386         // This method relies on extcodesize/address.code.length, which returns 0
387         // for contracts in construction, since the code is only stored at the end
388         // of the constructor execution.
389 
390         return account.code.length > 0;
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         (bool success, ) = recipient.call{value: amount}("");
413         require(success, "Address: unable to send value, recipient may have reverted");
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain `call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, 0, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but also transferring `value` wei to `target`.
455      *
456      * Requirements:
457      *
458      * - the calling contract must have an ETH balance of at least `value`.
459      * - the called Solidity function must be `payable`.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         require(isContract(target), "Address: call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.call{value: value}(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal view returns (bytes memory) {
511         require(isContract(target), "Address: static call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(isContract(target), "Address: delegate call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @title ERC721 token receiver interface
582  * @dev Interface for any contract that wants to support safeTransfers
583  * from ERC721 asset contracts.
584  */
585 interface IERC721Receiver {
586     /**
587      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
588      * by `operator` from `from`, this function is called.
589      *
590      * It must return its Solidity selector to confirm the token transfer.
591      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
592      *
593      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
594      */
595     function onERC721Received(
596         address operator,
597         address from,
598         uint256 tokenId,
599         bytes calldata data
600     ) external returns (bytes4);
601 }
602 
603 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Interface of the ERC165 standard, as defined in the
612  * https://eips.ethereum.org/EIPS/eip-165[EIP].
613  *
614  * Implementers can declare support of contract interfaces, which can then be
615  * queried by others ({ERC165Checker}).
616  *
617  * For an implementation, see {ERC165}.
618  */
619 interface IERC165 {
620     /**
621      * @dev Returns true if this contract implements the interface defined by
622      * `interfaceId`. See the corresponding
623      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
624      * to learn more about how these ids are created.
625      *
626      * This function call must use less than 30 000 gas.
627      */
628     function supportsInterface(bytes4 interfaceId) external view returns (bool);
629 }
630 
631 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @dev Implementation of the {IERC165} interface.
641  *
642  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
643  * for the additional interface id that will be supported. For example:
644  *
645  * ```solidity
646  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
648  * }
649  * ```
650  *
651  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
652  */
653 abstract contract ERC165 is IERC165 {
654     /**
655      * @dev See {IERC165-supportsInterface}.
656      */
657     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
658         return interfaceId == type(IERC165).interfaceId;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/access/AccessControl.sol
663 
664 
665 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 
671 
672 
673 /**
674  * @dev Contract module that allows children to implement role-based access
675  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
676  * members except through off-chain means by accessing the contract event logs. Some
677  * applications may benefit from on-chain enumerability, for those cases see
678  * {AccessControlEnumerable}.
679  *
680  * Roles are referred to by their `bytes32` identifier. These should be exposed
681  * in the external API and be unique. The best way to achieve this is by
682  * using `public constant` hash digests:
683  *
684  * ```
685  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
686  * ```
687  *
688  * Roles can be used to represent a set of permissions. To restrict access to a
689  * function call, use {hasRole}:
690  *
691  * ```
692  * function foo() public {
693  *     require(hasRole(MY_ROLE, msg.sender));
694  *     ...
695  * }
696  * ```
697  *
698  * Roles can be granted and revoked dynamically via the {grantRole} and
699  * {revokeRole} functions. Each role has an associated admin role, and only
700  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
701  *
702  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
703  * that only accounts with this role will be able to grant or revoke other
704  * roles. More complex role relationships can be created by using
705  * {_setRoleAdmin}.
706  *
707  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
708  * grant and revoke this role. Extra precautions should be taken to secure
709  * accounts that have been granted it.
710  */
711 abstract contract AccessControl is Context, IAccessControl, ERC165 {
712     struct RoleData {
713         mapping(address => bool) members;
714         bytes32 adminRole;
715     }
716 
717     mapping(bytes32 => RoleData) private _roles;
718 
719     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
720 
721     /**
722      * @dev Modifier that checks that an account has a specific role. Reverts
723      * with a standardized message including the required role.
724      *
725      * The format of the revert reason is given by the following regular expression:
726      *
727      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
728      *
729      * _Available since v4.1._
730      */
731     modifier onlyRole(bytes32 role) {
732         _checkRole(role, _msgSender());
733         _;
734     }
735 
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
741     }
742 
743     /**
744      * @dev Returns `true` if `account` has been granted `role`.
745      */
746     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
747         return _roles[role].members[account];
748     }
749 
750     /**
751      * @dev Revert with a standard message if `account` is missing `role`.
752      *
753      * The format of the revert reason is given by the following regular expression:
754      *
755      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
756      */
757     function _checkRole(bytes32 role, address account) internal view virtual {
758         if (!hasRole(role, account)) {
759             revert(
760                 string(
761                     abi.encodePacked(
762                         "AccessControl: account ",
763                         Strings.toHexString(uint160(account), 20),
764                         " is missing role ",
765                         Strings.toHexString(uint256(role), 32)
766                     )
767                 )
768             );
769         }
770     }
771 
772     /**
773      * @dev Returns the admin role that controls `role`. See {grantRole} and
774      * {revokeRole}.
775      *
776      * To change a role's admin, use {_setRoleAdmin}.
777      */
778     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
779         return _roles[role].adminRole;
780     }
781 
782     /**
783      * @dev Grants `role` to `account`.
784      *
785      * If `account` had not been already granted `role`, emits a {RoleGranted}
786      * event.
787      *
788      * Requirements:
789      *
790      * - the caller must have ``role``'s admin role.
791      */
792     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
793         _grantRole(role, account);
794     }
795 
796     /**
797      * @dev Revokes `role` from `account`.
798      *
799      * If `account` had been granted `role`, emits a {RoleRevoked} event.
800      *
801      * Requirements:
802      *
803      * - the caller must have ``role``'s admin role.
804      */
805     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
806         _revokeRole(role, account);
807     }
808 
809     /**
810      * @dev Revokes `role` from the calling account.
811      *
812      * Roles are often managed via {grantRole} and {revokeRole}: this function's
813      * purpose is to provide a mechanism for accounts to lose their privileges
814      * if they are compromised (such as when a trusted device is misplaced).
815      *
816      * If the calling account had been revoked `role`, emits a {RoleRevoked}
817      * event.
818      *
819      * Requirements:
820      *
821      * - the caller must be `account`.
822      */
823     function renounceRole(bytes32 role, address account) public virtual override {
824         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
825 
826         _revokeRole(role, account);
827     }
828 
829     /**
830      * @dev Grants `role` to `account`.
831      *
832      * If `account` had not been already granted `role`, emits a {RoleGranted}
833      * event. Note that unlike {grantRole}, this function doesn't perform any
834      * checks on the calling account.
835      *
836      * [WARNING]
837      * ====
838      * This function should only be called from the constructor when setting
839      * up the initial roles for the system.
840      *
841      * Using this function in any other way is effectively circumventing the admin
842      * system imposed by {AccessControl}.
843      * ====
844      *
845      * NOTE: This function is deprecated in favor of {_grantRole}.
846      */
847     function _setupRole(bytes32 role, address account) internal virtual {
848         _grantRole(role, account);
849     }
850 
851     /**
852      * @dev Sets `adminRole` as ``role``'s admin role.
853      *
854      * Emits a {RoleAdminChanged} event.
855      */
856     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
857         bytes32 previousAdminRole = getRoleAdmin(role);
858         _roles[role].adminRole = adminRole;
859         emit RoleAdminChanged(role, previousAdminRole, adminRole);
860     }
861 
862     /**
863      * @dev Grants `role` to `account`.
864      *
865      * Internal function without access restriction.
866      */
867     function _grantRole(bytes32 role, address account) internal virtual {
868         if (!hasRole(role, account)) {
869             _roles[role].members[account] = true;
870             emit RoleGranted(role, account, _msgSender());
871         }
872     }
873 
874     /**
875      * @dev Revokes `role` from `account`.
876      *
877      * Internal function without access restriction.
878      */
879     function _revokeRole(bytes32 role, address account) internal virtual {
880         if (hasRole(role, account)) {
881             _roles[role].members[account] = false;
882             emit RoleRevoked(role, account, _msgSender());
883         }
884     }
885 }
886 
887 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @dev Required interface of an ERC721 compliant contract.
897  */
898 interface IERC721 is IERC165 {
899     /**
900      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
901      */
902     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
903 
904     /**
905      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
906      */
907     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
908 
909     /**
910      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
911      */
912     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
913 
914     /**
915      * @dev Returns the number of tokens in ``owner``'s account.
916      */
917     function balanceOf(address owner) external view returns (uint256 balance);
918 
919     /**
920      * @dev Returns the owner of the `tokenId` token.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function ownerOf(uint256 tokenId) external view returns (address owner);
927 
928     /**
929      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
930      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must exist and be owned by `from`.
937      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
939      *
940      * Emits a {Transfer} event.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) external;
947 
948     /**
949      * @dev Transfers `tokenId` token from `from` to `to`.
950      *
951      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
959      *
960      * Emits a {Transfer} event.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) external;
967 
968     /**
969      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
970      * The approval is cleared when the token is transferred.
971      *
972      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
973      *
974      * Requirements:
975      *
976      * - The caller must own the token or be an approved operator.
977      * - `tokenId` must exist.
978      *
979      * Emits an {Approval} event.
980      */
981     function approve(address to, uint256 tokenId) external;
982 
983     /**
984      * @dev Returns the account approved for `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function getApproved(uint256 tokenId) external view returns (address operator);
991 
992     /**
993      * @dev Approve or remove `operator` as an operator for the caller.
994      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
995      *
996      * Requirements:
997      *
998      * - The `operator` cannot be the caller.
999      *
1000      * Emits an {ApprovalForAll} event.
1001      */
1002     function setApprovalForAll(address operator, bool _approved) external;
1003 
1004     /**
1005      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1006      *
1007      * See {setApprovalForAll}
1008      */
1009     function isApprovedForAll(address owner, address operator) external view returns (bool);
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must exist and be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes calldata data
1029     ) external;
1030 }
1031 
1032 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1033 
1034 
1035 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1042  * @dev See https://eips.ethereum.org/EIPS/eip-721
1043  */
1044 interface IERC721Enumerable is IERC721 {
1045     /**
1046      * @dev Returns the total amount of tokens stored by the contract.
1047      */
1048     function totalSupply() external view returns (uint256);
1049 
1050     /**
1051      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1052      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1058      * Use along with {totalSupply} to enumerate all tokens.
1059      */
1060     function tokenByIndex(uint256 index) external view returns (uint256);
1061 }
1062 
1063 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1064 
1065 
1066 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 
1071 /**
1072  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1073  * @dev See https://eips.ethereum.org/EIPS/eip-721
1074  */
1075 interface IERC721Metadata is IERC721 {
1076     /**
1077      * @dev Returns the token collection name.
1078      */
1079     function name() external view returns (string memory);
1080 
1081     /**
1082      * @dev Returns the token collection symbol.
1083      */
1084     function symbol() external view returns (string memory);
1085 
1086     /**
1087      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1088      */
1089     function tokenURI(uint256 tokenId) external view returns (string memory);
1090 }
1091 
1092 // File: erc721a/contracts/ERC721A.sol
1093 
1094 
1095 // Creator: Chiru Labs
1096 
1097 pragma solidity ^0.8.4;
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 error ApprovalCallerNotOwnerNorApproved();
1108 error ApprovalQueryForNonexistentToken();
1109 error ApproveToCaller();
1110 error ApprovalToCurrentOwner();
1111 error BalanceQueryForZeroAddress();
1112 error MintedQueryForZeroAddress();
1113 error BurnedQueryForZeroAddress();
1114 error AuxQueryForZeroAddress();
1115 error MintToZeroAddress();
1116 error MintZeroQuantity();
1117 error OwnerIndexOutOfBounds();
1118 error OwnerQueryForNonexistentToken();
1119 error TokenIndexOutOfBounds();
1120 error TransferCallerNotOwnerNorApproved();
1121 error TransferFromIncorrectOwner();
1122 error TransferToNonERC721ReceiverImplementer();
1123 error TransferToZeroAddress();
1124 error URIQueryForNonexistentToken();
1125 
1126 /**
1127  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1128  * the Metadata extension. Built to optimize for lower gas during batch mints.
1129  *
1130  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1131  *
1132  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1133  *
1134  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1135  */
1136 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1137     using Address for address;
1138     using Strings for uint256;
1139 
1140     // Compiler will pack this into a single 256bit word.
1141     struct TokenOwnership {
1142         // The address of the owner.
1143         address addr;
1144         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1145         uint64 startTimestamp;
1146         // Whether the token has been burned.
1147         bool burned;
1148     }
1149 
1150     // Compiler will pack this into a single 256bit word.
1151     struct AddressData {
1152         // Realistically, 2**64-1 is more than enough.
1153         uint64 balance;
1154         // Keeps track of mint count with minimal overhead for tokenomics.
1155         uint64 numberMinted;
1156         // Keeps track of burn count with minimal overhead for tokenomics.
1157         uint64 numberBurned;
1158         // For miscellaneous variable(s) pertaining to the address
1159         // (e.g. number of whitelist mint slots used).
1160         // If there are multiple variables, please pack them into a uint64.
1161         uint64 aux;
1162     }
1163 
1164     // The tokenId of the next token to be minted.
1165     uint256 internal _currentIndex;
1166 
1167     // The number of tokens burned.
1168     uint256 internal _burnCounter;
1169 
1170     // Token name
1171     string private _name;
1172 
1173     // Token symbol
1174     string private _symbol;
1175 
1176     // Mapping from token ID to ownership details
1177     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1178     mapping(uint256 => TokenOwnership) internal _ownerships;
1179 
1180     // Mapping owner address to address data
1181     mapping(address => AddressData) private _addressData;
1182 
1183     // Mapping from token ID to approved address
1184     mapping(uint256 => address) private _tokenApprovals;
1185 
1186     // Mapping from owner to operator approvals
1187     mapping(address => mapping(address => bool)) private _operatorApprovals;
1188 
1189     constructor(string memory name_, string memory symbol_) {
1190         _name = name_;
1191         _symbol = symbol_;
1192         _currentIndex = _startTokenId();
1193     }
1194 
1195     /**
1196      * To change the starting tokenId, please override this function.
1197      */
1198     function _startTokenId() internal view virtual returns (uint256) {
1199         return 0;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-totalSupply}.
1204      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1205      */
1206     function totalSupply() public view returns (uint256) {
1207         // Counter underflow is impossible as _burnCounter cannot be incremented
1208         // more than _currentIndex - _startTokenId() times
1209         unchecked {
1210             return _currentIndex - _burnCounter - _startTokenId();
1211         }
1212     }
1213 
1214     /**
1215      * Returns the total amount of tokens minted in the contract.
1216      */
1217     function _totalMinted() internal view returns (uint256) {
1218         // Counter underflow is impossible as _currentIndex does not decrement,
1219         // and it is initialized to _startTokenId()
1220         unchecked {
1221             return _currentIndex - _startTokenId();
1222         }
1223     }
1224 
1225     /**
1226      * @dev See {IERC165-supportsInterface}.
1227      */
1228     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1229         return
1230             interfaceId == type(IERC721).interfaceId ||
1231             interfaceId == type(IERC721Metadata).interfaceId ||
1232             super.supportsInterface(interfaceId);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-balanceOf}.
1237      */
1238     function balanceOf(address owner) public view override returns (uint256) {
1239         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1240         return uint256(_addressData[owner].balance);
1241     }
1242 
1243     /**
1244      * Returns the number of tokens minted by `owner`.
1245      */
1246     function _numberMinted(address owner) internal view returns (uint256) {
1247         if (owner == address(0)) revert MintedQueryForZeroAddress();
1248         return uint256(_addressData[owner].numberMinted);
1249     }
1250 
1251     /**
1252      * Returns the number of tokens burned by or on behalf of `owner`.
1253      */
1254     function _numberBurned(address owner) internal view returns (uint256) {
1255         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1256         return uint256(_addressData[owner].numberBurned);
1257     }
1258 
1259     /**
1260      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1261      */
1262     function _getAux(address owner) internal view returns (uint64) {
1263         if (owner == address(0)) revert AuxQueryForZeroAddress();
1264         return _addressData[owner].aux;
1265     }
1266 
1267     /**
1268      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1269      * If there are multiple variables, please pack them into a uint64.
1270      */
1271     function _setAux(address owner, uint64 aux) internal {
1272         if (owner == address(0)) revert AuxQueryForZeroAddress();
1273         _addressData[owner].aux = aux;
1274     }
1275 
1276     /**
1277      * Gas spent here starts off proportional to the maximum mint batch size.
1278      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1279      */
1280     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1281         uint256 curr = tokenId;
1282 
1283         unchecked {
1284             if (_startTokenId() <= curr && curr < _currentIndex) {
1285                 TokenOwnership memory ownership = _ownerships[curr];
1286                 if (!ownership.burned) {
1287                     if (ownership.addr != address(0)) {
1288                         return ownership;
1289                     }
1290                     // Invariant:
1291                     // There will always be an ownership that has an address and is not burned
1292                     // before an ownership that does not have an address and is not burned.
1293                     // Hence, curr will not underflow.
1294                     while (true) {
1295                         curr--;
1296                         ownership = _ownerships[curr];
1297                         if (ownership.addr != address(0)) {
1298                             return ownership;
1299                         }
1300                     }
1301                 }
1302             }
1303         }
1304         revert OwnerQueryForNonexistentToken();
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-ownerOf}.
1309      */
1310     function ownerOf(uint256 tokenId) public view override returns (address) {
1311         return ownershipOf(tokenId).addr;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Metadata-name}.
1316      */
1317     function name() public view virtual override returns (string memory) {
1318         return _name;
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Metadata-symbol}.
1323      */
1324     function symbol() public view virtual override returns (string memory) {
1325         return _symbol;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-tokenURI}.
1330      */
1331     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1332         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1333 
1334         string memory baseURI = _baseURI();
1335         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1336     }
1337 
1338     /**
1339      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1340      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1341      * by default, can be overriden in child contracts.
1342      */
1343     function _baseURI() internal view virtual returns (string memory) {
1344         return '';
1345     }
1346 
1347     /**
1348      * @dev See {IERC721-approve}.
1349      */
1350     function approve(address to, uint256 tokenId) public override {
1351         address owner = ERC721A.ownerOf(tokenId);
1352         if (to == owner) revert ApprovalToCurrentOwner();
1353 
1354         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1355             revert ApprovalCallerNotOwnerNorApproved();
1356         }
1357 
1358         _approve(to, tokenId, owner);
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-getApproved}.
1363      */
1364     function getApproved(uint256 tokenId) public view override returns (address) {
1365         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1366 
1367         return _tokenApprovals[tokenId];
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-setApprovalForAll}.
1372      */
1373     function setApprovalForAll(address operator, bool approved) public override {
1374         if (operator == _msgSender()) revert ApproveToCaller();
1375 
1376         _operatorApprovals[_msgSender()][operator] = approved;
1377         emit ApprovalForAll(_msgSender(), operator, approved);
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-isApprovedForAll}.
1382      */
1383     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1384         return _operatorApprovals[owner][operator];
1385     }
1386 
1387     /**
1388      * @dev See {IERC721-transferFrom}.
1389      */
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) public virtual override {
1395         _transfer(from, to, tokenId);
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-safeTransferFrom}.
1400      */
1401     function safeTransferFrom(
1402         address from,
1403         address to,
1404         uint256 tokenId
1405     ) public virtual override {
1406         safeTransferFrom(from, to, tokenId, '');
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-safeTransferFrom}.
1411      */
1412     function safeTransferFrom(
1413         address from,
1414         address to,
1415         uint256 tokenId,
1416         bytes memory _data
1417     ) public virtual override {
1418         _transfer(from, to, tokenId);
1419         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1420             revert TransferToNonERC721ReceiverImplementer();
1421         }
1422     }
1423 
1424     /**
1425      * @dev Returns whether `tokenId` exists.
1426      *
1427      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1428      *
1429      * Tokens start existing when they are minted (`_mint`),
1430      */
1431     function _exists(uint256 tokenId) internal view returns (bool) {
1432         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1433             !_ownerships[tokenId].burned;
1434     }
1435 
1436     function _safeMint(address to, uint256 quantity) internal {
1437         _safeMint(to, quantity, '');
1438     }
1439 
1440     /**
1441      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1442      *
1443      * Requirements:
1444      *
1445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1446      * - `quantity` must be greater than 0.
1447      *
1448      * Emits a {Transfer} event.
1449      */
1450     function _safeMint(
1451         address to,
1452         uint256 quantity,
1453         bytes memory _data
1454     ) internal {
1455         _mint(to, quantity, _data, true);
1456     }
1457 
1458     /**
1459      * @dev Mints `quantity` tokens and transfers them to `to`.
1460      *
1461      * Requirements:
1462      *
1463      * - `to` cannot be the zero address.
1464      * - `quantity` must be greater than 0.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function _mint(
1469         address to,
1470         uint256 quantity,
1471         bytes memory _data,
1472         bool safe
1473     ) internal {
1474         uint256 startTokenId = _currentIndex;
1475         if (to == address(0)) revert MintToZeroAddress();
1476         if (quantity == 0) revert MintZeroQuantity();
1477 
1478         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1479 
1480         // Overflows are incredibly unrealistic.
1481         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1482         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1483         unchecked {
1484             _addressData[to].balance += uint64(quantity);
1485             _addressData[to].numberMinted += uint64(quantity);
1486 
1487             _ownerships[startTokenId].addr = to;
1488             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1489 
1490             uint256 updatedIndex = startTokenId;
1491             uint256 end = updatedIndex + quantity;
1492 
1493             if (safe && to.isContract()) {
1494                 do {
1495                     emit Transfer(address(0), to, updatedIndex);
1496                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1497                         revert TransferToNonERC721ReceiverImplementer();
1498                     }
1499                 } while (updatedIndex != end);
1500                 // Reentrancy protection
1501                 if (_currentIndex != startTokenId) revert();
1502             } else {
1503                 do {
1504                     emit Transfer(address(0), to, updatedIndex++);
1505                 } while (updatedIndex != end);
1506             }
1507             _currentIndex = updatedIndex;
1508         }
1509         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1510     }
1511 
1512     /**
1513      * @dev Transfers `tokenId` from `from` to `to`.
1514      *
1515      * Requirements:
1516      *
1517      * - `to` cannot be the zero address.
1518      * - `tokenId` token must be owned by `from`.
1519      *
1520      * Emits a {Transfer} event.
1521      */
1522     function _transfer(
1523         address from,
1524         address to,
1525         uint256 tokenId
1526     ) private {
1527         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1528 
1529         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1530             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1531             getApproved(tokenId) == _msgSender());
1532 
1533         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1534         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1535         if (to == address(0)) revert TransferToZeroAddress();
1536 
1537         _beforeTokenTransfers(from, to, tokenId, 1);
1538 
1539         // Clear approvals from the previous owner
1540         _approve(address(0), tokenId, prevOwnership.addr);
1541 
1542         // Underflow of the sender's balance is impossible because we check for
1543         // ownership above and the recipient's balance can't realistically overflow.
1544         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1545         unchecked {
1546             _addressData[from].balance -= 1;
1547             _addressData[to].balance += 1;
1548 
1549             _ownerships[tokenId].addr = to;
1550             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1551 
1552             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1553             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1554             uint256 nextTokenId = tokenId + 1;
1555             if (_ownerships[nextTokenId].addr == address(0)) {
1556                 // This will suffice for checking _exists(nextTokenId),
1557                 // as a burned slot cannot contain the zero address.
1558                 if (nextTokenId < _currentIndex) {
1559                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1560                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1561                 }
1562             }
1563         }
1564 
1565         emit Transfer(from, to, tokenId);
1566         _afterTokenTransfers(from, to, tokenId, 1);
1567     }
1568 
1569     /**
1570      * @dev Destroys `tokenId`.
1571      * The approval is cleared when the token is burned.
1572      *
1573      * Requirements:
1574      *
1575      * - `tokenId` must exist.
1576      *
1577      * Emits a {Transfer} event.
1578      */
1579     function _burn(uint256 tokenId) internal virtual {
1580         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1581 
1582         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1583 
1584         // Clear approvals from the previous owner
1585         _approve(address(0), tokenId, prevOwnership.addr);
1586 
1587         // Underflow of the sender's balance is impossible because we check for
1588         // ownership above and the recipient's balance can't realistically overflow.
1589         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1590         unchecked {
1591             _addressData[prevOwnership.addr].balance -= 1;
1592             _addressData[prevOwnership.addr].numberBurned += 1;
1593 
1594             // Keep track of who burned the token, and the timestamp of burning.
1595             _ownerships[tokenId].addr = prevOwnership.addr;
1596             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1597             _ownerships[tokenId].burned = true;
1598 
1599             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1600             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1601             uint256 nextTokenId = tokenId + 1;
1602             if (_ownerships[nextTokenId].addr == address(0)) {
1603                 // This will suffice for checking _exists(nextTokenId),
1604                 // as a burned slot cannot contain the zero address.
1605                 if (nextTokenId < _currentIndex) {
1606                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1607                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1608                 }
1609             }
1610         }
1611 
1612         emit Transfer(prevOwnership.addr, address(0), tokenId);
1613         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1614 
1615         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1616         unchecked {
1617             _burnCounter++;
1618         }
1619     }
1620 
1621     /**
1622      * @dev Approve `to` to operate on `tokenId`
1623      *
1624      * Emits a {Approval} event.
1625      */
1626     function _approve(
1627         address to,
1628         uint256 tokenId,
1629         address owner
1630     ) private {
1631         _tokenApprovals[tokenId] = to;
1632         emit Approval(owner, to, tokenId);
1633     }
1634 
1635     /**
1636      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1637      *
1638      * @param from address representing the previous owner of the given token ID
1639      * @param to target address that will receive the tokens
1640      * @param tokenId uint256 ID of the token to be transferred
1641      * @param _data bytes optional data to send along with the call
1642      * @return bool whether the call correctly returned the expected magic value
1643      */
1644     function _checkContractOnERC721Received(
1645         address from,
1646         address to,
1647         uint256 tokenId,
1648         bytes memory _data
1649     ) private returns (bool) {
1650         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1651             return retval == IERC721Receiver(to).onERC721Received.selector;
1652         } catch (bytes memory reason) {
1653             if (reason.length == 0) {
1654                 revert TransferToNonERC721ReceiverImplementer();
1655             } else {
1656                 assembly {
1657                     revert(add(32, reason), mload(reason))
1658                 }
1659             }
1660         }
1661     }
1662 
1663     /**
1664      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1665      * And also called before burning one token.
1666      *
1667      * startTokenId - the first token id to be transferred
1668      * quantity - the amount to be transferred
1669      *
1670      * Calling conditions:
1671      *
1672      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1673      * transferred to `to`.
1674      * - When `from` is zero, `tokenId` will be minted for `to`.
1675      * - When `to` is zero, `tokenId` will be burned by `from`.
1676      * - `from` and `to` are never both zero.
1677      */
1678     function _beforeTokenTransfers(
1679         address from,
1680         address to,
1681         uint256 startTokenId,
1682         uint256 quantity
1683     ) internal virtual {}
1684 
1685     /**
1686      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1687      * minting.
1688      * And also called after one token has been burned.
1689      *
1690      * startTokenId - the first token id to be transferred
1691      * quantity - the amount to be transferred
1692      *
1693      * Calling conditions:
1694      *
1695      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1696      * transferred to `to`.
1697      * - When `from` is zero, `tokenId` has been minted for `to`.
1698      * - When `to` is zero, `tokenId` has been burned by `from`.
1699      * - `from` and `to` are never both zero.
1700      */
1701     function _afterTokenTransfers(
1702         address from,
1703         address to,
1704         uint256 startTokenId,
1705         uint256 quantity
1706     ) internal virtual {}
1707 }
1708 
1709 // File: contracts/Monolocco.sol
1710 
1711 //SPDX-License-Identifier: UNLICENSED
1712 pragma solidity ^0.8.11;
1713 
1714 
1715 
1716 
1717 
1718 contract MonoLocco is ERC721A, AccessControl, Pausable, ReentrancyGuard {
1719     using Strings for uint256;
1720 
1721     string public baseURI_ = "https://meta.monolocco.xyz/";
1722     string public extensionURI_ = "";
1723     bytes32 public constant MINTER_ROLE = keccak256("LOCCOMINTER");
1724     uint256 public MAX_SUPPLY = 6666;
1725     constructor() ERC721A("MonoLocco", "LOCCO") {
1726         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); 
1727     }
1728 
1729     function mint(address to, uint256 quantity) external onlyRole(MINTER_ROLE) nonReentrant {
1730         require(totalSupply() + quantity <= MAX_SUPPLY, "Monolocco: Max supply exceded");
1731         _safeMint(to, quantity);
1732     }
1733 
1734     function tokenURI(uint256 tokenId)
1735         public
1736         view
1737         virtual
1738         override
1739         returns (string memory)
1740     {
1741         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1742         string memory baseURI = _baseURI();
1743         return
1744             bytes(baseURI).length != 0
1745                 ? string(
1746                     abi.encodePacked(
1747                         baseURI,
1748                         tokenId.toString(),
1749                         _extensionURI()
1750                     )
1751                 )
1752                 : "";
1753     }
1754 
1755     function _baseURI() internal view virtual override returns (string memory) {
1756         return baseURI_;
1757     }
1758 
1759     function _extensionURI() internal view virtual returns (string memory) {
1760         return extensionURI_;
1761     }
1762 
1763     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControl) returns (bool) {
1764         return super.supportsInterface(interfaceId);
1765     }
1766     
1767     /**
1768     @dev Change Base URI can be used to reveal NFTs
1769     @param uri_ String of the new uri
1770      */
1771     function changeBaseURI(string memory uri_)
1772         external
1773         onlyRole(DEFAULT_ADMIN_ROLE)
1774     {
1775         baseURI_ = uri_;
1776     }
1777 
1778     function changeExtension(string memory extension_)
1779         external
1780         onlyRole(DEFAULT_ADMIN_ROLE)
1781     {
1782         extensionURI_ = extension_;
1783     }
1784 
1785     function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1786         _pause();
1787     }
1788 
1789     function unPause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1790         _unpause();
1791     }
1792 }