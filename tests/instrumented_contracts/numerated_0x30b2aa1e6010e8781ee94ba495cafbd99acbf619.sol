1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/access/IAccessControl.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev External interface of AccessControl declared to support ERC165 detection.
56  */
57 interface IAccessControl {
58     /**
59      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
60      *
61      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
62      * {RoleAdminChanged} not being emitted signaling this.
63      *
64      * _Available since v3.1._
65      */
66     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
67 
68     /**
69      * @dev Emitted when `account` is granted `role`.
70      *
71      * `sender` is the account that originated the contract call, an admin role
72      * bearer except when using {AccessControl-_setupRole}.
73      */
74     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
75 
76     /**
77      * @dev Emitted when `account` is revoked `role`.
78      *
79      * `sender` is the account that originated the contract call:
80      *   - if using `revokeRole`, it is the admin role bearer
81      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
82      */
83     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
84 
85     /**
86      * @dev Returns `true` if `account` has been granted `role`.
87      */
88     function hasRole(bytes32 role, address account) external view returns (bool);
89 
90     /**
91      * @dev Returns the admin role that controls `role`. See {grantRole} and
92      * {revokeRole}.
93      *
94      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
95      */
96     function getRoleAdmin(bytes32 role) external view returns (bytes32);
97 
98     /**
99      * @dev Grants `role` to `account`.
100      *
101      * If `account` had not been already granted `role`, emits a {RoleGranted}
102      * event.
103      *
104      * Requirements:
105      *
106      * - the caller must have ``role``'s admin role.
107      */
108     function grantRole(bytes32 role, address account) external;
109 
110     /**
111      * @dev Revokes `role` from `account`.
112      *
113      * If `account` had been granted `role`, emits a {RoleRevoked} event.
114      *
115      * Requirements:
116      *
117      * - the caller must have ``role``'s admin role.
118      */
119     function revokeRole(bytes32 role, address account) external;
120 
121     /**
122      * @dev Revokes `role` from the calling account.
123      *
124      * Roles are often managed via {grantRole} and {revokeRole}: this function's
125      * purpose is to provide a mechanism for accounts to lose their privileges
126      * if they are compromised (such as when a trusted device is misplaced).
127      *
128      * If the calling account had been granted `role`, emits a {RoleRevoked}
129      * event.
130      *
131      * Requirements:
132      *
133      * - the caller must be `account`.
134      */
135     function renounceRole(bytes32 role, address account) external;
136 }
137 
138 // File: @openzeppelin/contracts/utils/Strings.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev String operations.
147  */
148 library Strings {
149     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
153      */
154     function toString(uint256 value) internal pure returns (string memory) {
155         // Inspired by OraclizeAPI's implementation - MIT licence
156         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
157 
158         if (value == 0) {
159             return "0";
160         }
161         uint256 temp = value;
162         uint256 digits;
163         while (temp != 0) {
164             digits++;
165             temp /= 10;
166         }
167         bytes memory buffer = new bytes(digits);
168         while (value != 0) {
169             digits -= 1;
170             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
171             value /= 10;
172         }
173         return string(buffer);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
178      */
179     function toHexString(uint256 value) internal pure returns (string memory) {
180         if (value == 0) {
181             return "0x00";
182         }
183         uint256 temp = value;
184         uint256 length = 0;
185         while (temp != 0) {
186             length++;
187             temp >>= 8;
188         }
189         return toHexString(value, length);
190     }
191 
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
194      */
195     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
196         bytes memory buffer = new bytes(2 * length + 2);
197         buffer[0] = "0";
198         buffer[1] = "x";
199         for (uint256 i = 2 * length + 1; i > 1; --i) {
200             buffer[i] = _HEX_SYMBOLS[value & 0xf];
201             value >>= 4;
202         }
203         require(value == 0, "Strings: hex length insufficient");
204         return string(buffer);
205     }
206 }
207 
208 // File: @openzeppelin/contracts/utils/Context.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Provides information about the current execution context, including the
217  * sender of the transaction and its data. While these are generally available
218  * via msg.sender and msg.data, they should not be accessed in such a direct
219  * manner, since when dealing with meta-transactions the account sending and
220  * paying for execution may not be the actual sender (as far as an application
221  * is concerned).
222  *
223  * This contract is only required for intermediate, library-like contracts.
224  */
225 abstract contract Context {
226     function _msgSender() internal view virtual returns (address) {
227         return msg.sender;
228     }
229 
230     function _msgData() internal view virtual returns (bytes calldata) {
231         return msg.data;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/security/Pausable.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 
243 /**
244  * @dev Contract module which allows children to implement an emergency stop
245  * mechanism that can be triggered by an authorized account.
246  *
247  * This module is used through inheritance. It will make available the
248  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
249  * the functions of your contract. Note that they will not be pausable by
250  * simply including this module, only once the modifiers are put in place.
251  */
252 abstract contract Pausable is Context {
253     /**
254      * @dev Emitted when the pause is triggered by `account`.
255      */
256     event Paused(address account);
257 
258     /**
259      * @dev Emitted when the pause is lifted by `account`.
260      */
261     event Unpaused(address account);
262 
263     bool private _paused;
264 
265     /**
266      * @dev Initializes the contract in unpaused state.
267      */
268     constructor() {
269         _paused = false;
270     }
271 
272     /**
273      * @dev Returns true if the contract is paused, and false otherwise.
274      */
275     function paused() public view virtual returns (bool) {
276         return _paused;
277     }
278 
279     /**
280      * @dev Modifier to make a function callable only when the contract is not paused.
281      *
282      * Requirements:
283      *
284      * - The contract must not be paused.
285      */
286     modifier whenNotPaused() {
287         require(!paused(), "Pausable: paused");
288         _;
289     }
290 
291     /**
292      * @dev Modifier to make a function callable only when the contract is paused.
293      *
294      * Requirements:
295      *
296      * - The contract must be paused.
297      */
298     modifier whenPaused() {
299         require(paused(), "Pausable: not paused");
300         _;
301     }
302 
303     /**
304      * @dev Triggers stopped state.
305      *
306      * Requirements:
307      *
308      * - The contract must not be paused.
309      */
310     function _pause() internal virtual whenNotPaused {
311         _paused = true;
312         emit Paused(_msgSender());
313     }
314 
315     /**
316      * @dev Returns to normal state.
317      *
318      * Requirements:
319      *
320      * - The contract must be paused.
321      */
322     function _unpause() internal virtual whenPaused {
323         _paused = false;
324         emit Unpaused(_msgSender());
325     }
326 }
327 
328 // File: @openzeppelin/contracts/utils/Address.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
332 
333 pragma solidity ^0.8.1;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      *
356      * [IMPORTANT]
357      * ====
358      * You shouldn't rely on `isContract` to protect against flash loan attacks!
359      *
360      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
361      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
362      * constructor.
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // This method relies on extcodesize/address.code.length, which returns 0
367         // for contracts in construction, since the code is only stored at the end
368         // of the constructor execution.
369 
370         return account.code.length > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         (bool success, ) = recipient.call{value: amount}("");
393         require(success, "Address: unable to send value, recipient may have reverted");
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain `call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionCall(target, data, "Address: low-level call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
420      * `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, 0, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but also transferring `value` wei to `target`.
435      *
436      * Requirements:
437      *
438      * - the calling contract must have an ETH balance of at least `value`.
439      * - the called Solidity function must be `payable`.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 value
447     ) internal returns (bytes memory) {
448         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
453      * with `errorMessage` as a fallback revert reason when `target` reverts.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(address(this).balance >= value, "Address: insufficient balance for call");
464         require(isContract(target), "Address: call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.call{value: value}(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
477         return functionStaticCall(target, data, "Address: low-level static call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal view returns (bytes memory) {
491         require(isContract(target), "Address: static call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.staticcall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but performing a delegate call.
500      *
501      * _Available since v3.4._
502      */
503     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(isContract(target), "Address: delegate call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
526      * revert reason using the provided one.
527      *
528      * _Available since v4.3._
529      */
530     function verifyCallResult(
531         bool success,
532         bytes memory returndata,
533         string memory errorMessage
534     ) internal pure returns (bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @title ERC721 token receiver interface
562  * @dev Interface for any contract that wants to support safeTransfers
563  * from ERC721 asset contracts.
564  */
565 interface IERC721Receiver {
566     /**
567      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
568      * by `operator` from `from`, this function is called.
569      *
570      * It must return its Solidity selector to confirm the token transfer.
571      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
572      *
573      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
574      */
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Interface of the ERC165 standard, as defined in the
592  * https://eips.ethereum.org/EIPS/eip-165[EIP].
593  *
594  * Implementers can declare support of contract interfaces, which can then be
595  * queried by others ({ERC165Checker}).
596  *
597  * For an implementation, see {ERC165}.
598  */
599 interface IERC165 {
600     /**
601      * @dev Returns true if this contract implements the interface defined by
602      * `interfaceId`. See the corresponding
603      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
604      * to learn more about how these ids are created.
605      *
606      * This function call must use less than 30 000 gas.
607      */
608     function supportsInterface(bytes4 interfaceId) external view returns (bool);
609 }
610 
611 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @dev Implementation of the {IERC165} interface.
621  *
622  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
623  * for the additional interface id that will be supported. For example:
624  *
625  * ```solidity
626  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
628  * }
629  * ```
630  *
631  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
632  */
633 abstract contract ERC165 is IERC165 {
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
638         return interfaceId == type(IERC165).interfaceId;
639     }
640 }
641 
642 // File: @openzeppelin/contracts/access/AccessControl.sol
643 
644 
645 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 
651 
652 
653 /**
654  * @dev Contract module that allows children to implement role-based access
655  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
656  * members except through off-chain means by accessing the contract event logs. Some
657  * applications may benefit from on-chain enumerability, for those cases see
658  * {AccessControlEnumerable}.
659  *
660  * Roles are referred to by their `bytes32` identifier. These should be exposed
661  * in the external API and be unique. The best way to achieve this is by
662  * using `public constant` hash digests:
663  *
664  * ```
665  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
666  * ```
667  *
668  * Roles can be used to represent a set of permissions. To restrict access to a
669  * function call, use {hasRole}:
670  *
671  * ```
672  * function foo() public {
673  *     require(hasRole(MY_ROLE, msg.sender));
674  *     ...
675  * }
676  * ```
677  *
678  * Roles can be granted and revoked dynamically via the {grantRole} and
679  * {revokeRole} functions. Each role has an associated admin role, and only
680  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
681  *
682  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
683  * that only accounts with this role will be able to grant or revoke other
684  * roles. More complex role relationships can be created by using
685  * {_setRoleAdmin}.
686  *
687  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
688  * grant and revoke this role. Extra precautions should be taken to secure
689  * accounts that have been granted it.
690  */
691 abstract contract AccessControl is Context, IAccessControl, ERC165 {
692     struct RoleData {
693         mapping(address => bool) members;
694         bytes32 adminRole;
695     }
696 
697     mapping(bytes32 => RoleData) private _roles;
698 
699     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
700 
701     /**
702      * @dev Modifier that checks that an account has a specific role. Reverts
703      * with a standardized message including the required role.
704      *
705      * The format of the revert reason is given by the following regular expression:
706      *
707      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
708      *
709      * _Available since v4.1._
710      */
711     modifier onlyRole(bytes32 role) {
712         _checkRole(role);
713         _;
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev Returns `true` if `account` has been granted `role`.
725      */
726     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
727         return _roles[role].members[account];
728     }
729 
730     /**
731      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
732      * Overriding this function changes the behavior of the {onlyRole} modifier.
733      *
734      * Format of the revert message is described in {_checkRole}.
735      *
736      * _Available since v4.6._
737      */
738     function _checkRole(bytes32 role) internal view virtual {
739         _checkRole(role, _msgSender());
740     }
741 
742     /**
743      * @dev Revert with a standard message if `account` is missing `role`.
744      *
745      * The format of the revert reason is given by the following regular expression:
746      *
747      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
748      */
749     function _checkRole(bytes32 role, address account) internal view virtual {
750         if (!hasRole(role, account)) {
751             revert(
752                 string(
753                     abi.encodePacked(
754                         "AccessControl: account ",
755                         Strings.toHexString(uint160(account), 20),
756                         " is missing role ",
757                         Strings.toHexString(uint256(role), 32)
758                     )
759                 )
760             );
761         }
762     }
763 
764     /**
765      * @dev Returns the admin role that controls `role`. See {grantRole} and
766      * {revokeRole}.
767      *
768      * To change a role's admin, use {_setRoleAdmin}.
769      */
770     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
771         return _roles[role].adminRole;
772     }
773 
774     /**
775      * @dev Grants `role` to `account`.
776      *
777      * If `account` had not been already granted `role`, emits a {RoleGranted}
778      * event.
779      *
780      * Requirements:
781      *
782      * - the caller must have ``role``'s admin role.
783      */
784     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
785         _grantRole(role, account);
786     }
787 
788     /**
789      * @dev Revokes `role` from `account`.
790      *
791      * If `account` had been granted `role`, emits a {RoleRevoked} event.
792      *
793      * Requirements:
794      *
795      * - the caller must have ``role``'s admin role.
796      */
797     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
798         _revokeRole(role, account);
799     }
800 
801     /**
802      * @dev Revokes `role` from the calling account.
803      *
804      * Roles are often managed via {grantRole} and {revokeRole}: this function's
805      * purpose is to provide a mechanism for accounts to lose their privileges
806      * if they are compromised (such as when a trusted device is misplaced).
807      *
808      * If the calling account had been revoked `role`, emits a {RoleRevoked}
809      * event.
810      *
811      * Requirements:
812      *
813      * - the caller must be `account`.
814      */
815     function renounceRole(bytes32 role, address account) public virtual override {
816         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
817 
818         _revokeRole(role, account);
819     }
820 
821     /**
822      * @dev Grants `role` to `account`.
823      *
824      * If `account` had not been already granted `role`, emits a {RoleGranted}
825      * event. Note that unlike {grantRole}, this function doesn't perform any
826      * checks on the calling account.
827      *
828      * [WARNING]
829      * ====
830      * This function should only be called from the constructor when setting
831      * up the initial roles for the system.
832      *
833      * Using this function in any other way is effectively circumventing the admin
834      * system imposed by {AccessControl}.
835      * ====
836      *
837      * NOTE: This function is deprecated in favor of {_grantRole}.
838      */
839     function _setupRole(bytes32 role, address account) internal virtual {
840         _grantRole(role, account);
841     }
842 
843     /**
844      * @dev Sets `adminRole` as ``role``'s admin role.
845      *
846      * Emits a {RoleAdminChanged} event.
847      */
848     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
849         bytes32 previousAdminRole = getRoleAdmin(role);
850         _roles[role].adminRole = adminRole;
851         emit RoleAdminChanged(role, previousAdminRole, adminRole);
852     }
853 
854     /**
855      * @dev Grants `role` to `account`.
856      *
857      * Internal function without access restriction.
858      */
859     function _grantRole(bytes32 role, address account) internal virtual {
860         if (!hasRole(role, account)) {
861             _roles[role].members[account] = true;
862             emit RoleGranted(role, account, _msgSender());
863         }
864     }
865 
866     /**
867      * @dev Revokes `role` from `account`.
868      *
869      * Internal function without access restriction.
870      */
871     function _revokeRole(bytes32 role, address account) internal virtual {
872         if (hasRole(role, account)) {
873             _roles[role].members[account] = false;
874             emit RoleRevoked(role, account, _msgSender());
875         }
876     }
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 /**
888  * @dev Required interface of an ERC721 compliant contract.
889  */
890 interface IERC721 is IERC165 {
891     /**
892      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
893      */
894     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
895 
896     /**
897      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
898      */
899     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
900 
901     /**
902      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
903      */
904     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
905 
906     /**
907      * @dev Returns the number of tokens in ``owner``'s account.
908      */
909     function balanceOf(address owner) external view returns (uint256 balance);
910 
911     /**
912      * @dev Returns the owner of the `tokenId` token.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      */
918     function ownerOf(uint256 tokenId) external view returns (address owner);
919 
920     /**
921      * @dev Safely transfers `tokenId` token from `from` to `to`.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must exist and be owned by `from`.
928      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes calldata data
938     ) external;
939 
940     /**
941      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
942      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
943      *
944      * Requirements:
945      *
946      * - `from` cannot be the zero address.
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must exist and be owned by `from`.
949      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
951      *
952      * Emits a {Transfer} event.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) external;
959 
960     /**
961      * @dev Transfers `tokenId` token from `from` to `to`.
962      *
963      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
964      *
965      * Requirements:
966      *
967      * - `from` cannot be the zero address.
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must be owned by `from`.
970      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
971      *
972      * Emits a {Transfer} event.
973      */
974     function transferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) external;
979 
980     /**
981      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
982      * The approval is cleared when the token is transferred.
983      *
984      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
985      *
986      * Requirements:
987      *
988      * - The caller must own the token or be an approved operator.
989      * - `tokenId` must exist.
990      *
991      * Emits an {Approval} event.
992      */
993     function approve(address to, uint256 tokenId) external;
994 
995     /**
996      * @dev Approve or remove `operator` as an operator for the caller.
997      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
998      *
999      * Requirements:
1000      *
1001      * - The `operator` cannot be the caller.
1002      *
1003      * Emits an {ApprovalForAll} event.
1004      */
1005     function setApprovalForAll(address operator, bool _approved) external;
1006 
1007     /**
1008      * @dev Returns the account approved for `tokenId` token.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      */
1014     function getApproved(uint256 tokenId) external view returns (address operator);
1015 
1016     /**
1017      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1018      *
1019      * See {setApprovalForAll}
1020      */
1021     function isApprovedForAll(address owner, address operator) external view returns (bool);
1022 }
1023 
1024 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1025 
1026 
1027 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1034  * @dev See https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 interface IERC721Metadata is IERC721 {
1037     /**
1038      * @dev Returns the token collection name.
1039      */
1040     function name() external view returns (string memory);
1041 
1042     /**
1043      * @dev Returns the token collection symbol.
1044      */
1045     function symbol() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1049      */
1050     function tokenURI(uint256 tokenId) external view returns (string memory);
1051 }
1052 
1053 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 
1067 /**
1068  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1069  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1070  * {ERC721Enumerable}.
1071  */
1072 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1073     using Address for address;
1074     using Strings for uint256;
1075 
1076     // Token name
1077     string private _name;
1078 
1079     // Token symbol
1080     string private _symbol;
1081 
1082     // Mapping from token ID to owner address
1083     mapping(uint256 => address) private _owners;
1084 
1085     // Mapping owner address to token count
1086     mapping(address => uint256) private _balances;
1087 
1088     // Mapping from token ID to approved address
1089     mapping(uint256 => address) private _tokenApprovals;
1090 
1091     // Mapping from owner to operator approvals
1092     mapping(address => mapping(address => bool)) private _operatorApprovals;
1093 
1094     /**
1095      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1096      */
1097     constructor(string memory name_, string memory symbol_) {
1098         _name = name_;
1099         _symbol = symbol_;
1100     }
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1106         return
1107             interfaceId == type(IERC721).interfaceId ||
1108             interfaceId == type(IERC721Metadata).interfaceId ||
1109             super.supportsInterface(interfaceId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-balanceOf}.
1114      */
1115     function balanceOf(address owner) public view virtual override returns (uint256) {
1116         require(owner != address(0), "ERC721: balance query for the zero address");
1117         return _balances[owner];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-ownerOf}.
1122      */
1123     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1124         address owner = _owners[tokenId];
1125         require(owner != address(0), "ERC721: owner query for nonexistent token");
1126         return owner;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-name}.
1131      */
1132     function name() public view virtual override returns (string memory) {
1133         return _name;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-symbol}.
1138      */
1139     function symbol() public view virtual override returns (string memory) {
1140         return _symbol;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-tokenURI}.
1145      */
1146     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1147         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1148 
1149         string memory baseURI = _baseURI();
1150         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1151     }
1152 
1153     /**
1154      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1155      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1156      * by default, can be overridden in child contracts.
1157      */
1158     function _baseURI() internal view virtual returns (string memory) {
1159         return "";
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-approve}.
1164      */
1165     function approve(address to, uint256 tokenId) public virtual override {
1166         address owner = ERC721.ownerOf(tokenId);
1167         require(to != owner, "ERC721: approval to current owner");
1168 
1169         require(
1170             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1171             "ERC721: approve caller is not owner nor approved for all"
1172         );
1173 
1174         _approve(to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-getApproved}.
1179      */
1180     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1181         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1182 
1183         return _tokenApprovals[tokenId];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-setApprovalForAll}.
1188      */
1189     function setApprovalForAll(address operator, bool approved) public virtual override {
1190         _setApprovalForAll(_msgSender(), operator, approved);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-isApprovedForAll}.
1195      */
1196     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1197         return _operatorApprovals[owner][operator];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-transferFrom}.
1202      */
1203     function transferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) public virtual override {
1208         //solhint-disable-next-line max-line-length
1209         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1210 
1211         _transfer(from, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         safeTransferFrom(from, to, tokenId, "");
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-safeTransferFrom}.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) public virtual override {
1234         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1235         _safeTransfer(from, to, tokenId, _data);
1236     }
1237 
1238     /**
1239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1241      *
1242      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1243      *
1244      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1245      * implement alternative mechanisms to perform token transfer, such as signature-based.
1246      *
1247      * Requirements:
1248      *
1249      * - `from` cannot be the zero address.
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must exist and be owned by `from`.
1252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _safeTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory _data
1261     ) internal virtual {
1262         _transfer(from, to, tokenId);
1263         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1264     }
1265 
1266     /**
1267      * @dev Returns whether `tokenId` exists.
1268      *
1269      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1270      *
1271      * Tokens start existing when they are minted (`_mint`),
1272      * and stop existing when they are burned (`_burn`).
1273      */
1274     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1275         return _owners[tokenId] != address(0);
1276     }
1277 
1278     /**
1279      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1280      *
1281      * Requirements:
1282      *
1283      * - `tokenId` must exist.
1284      */
1285     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1286         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1287         address owner = ERC721.ownerOf(tokenId);
1288         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1289     }
1290 
1291     /**
1292      * @dev Safely mints `tokenId` and transfers it to `to`.
1293      *
1294      * Requirements:
1295      *
1296      * - `tokenId` must not exist.
1297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _safeMint(address to, uint256 tokenId) internal virtual {
1302         _safeMint(to, tokenId, "");
1303     }
1304 
1305     /**
1306      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1307      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1308      */
1309     function _safeMint(
1310         address to,
1311         uint256 tokenId,
1312         bytes memory _data
1313     ) internal virtual {
1314         _mint(to, tokenId);
1315         require(
1316             _checkOnERC721Received(address(0), to, tokenId, _data),
1317             "ERC721: transfer to non ERC721Receiver implementer"
1318         );
1319     }
1320 
1321     /**
1322      * @dev Mints `tokenId` and transfers it to `to`.
1323      *
1324      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1325      *
1326      * Requirements:
1327      *
1328      * - `tokenId` must not exist.
1329      * - `to` cannot be the zero address.
1330      *
1331      * Emits a {Transfer} event.
1332      */
1333     function _mint(address to, uint256 tokenId) internal virtual {
1334         require(to != address(0), "ERC721: mint to the zero address");
1335         require(!_exists(tokenId), "ERC721: token already minted");
1336 
1337         _beforeTokenTransfer(address(0), to, tokenId);
1338 
1339         _balances[to] += 1;
1340         _owners[tokenId] = to;
1341 
1342         emit Transfer(address(0), to, tokenId);
1343 
1344         _afterTokenTransfer(address(0), to, tokenId);
1345     }
1346 
1347     /**
1348      * @dev Destroys `tokenId`.
1349      * The approval is cleared when the token is burned.
1350      *
1351      * Requirements:
1352      *
1353      * - `tokenId` must exist.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function _burn(uint256 tokenId) internal virtual {
1358         address owner = ERC721.ownerOf(tokenId);
1359 
1360         _beforeTokenTransfer(owner, address(0), tokenId);
1361 
1362         // Clear approvals
1363         _approve(address(0), tokenId);
1364 
1365         _balances[owner] -= 1;
1366         delete _owners[tokenId];
1367 
1368         emit Transfer(owner, address(0), tokenId);
1369 
1370         _afterTokenTransfer(owner, address(0), tokenId);
1371     }
1372 
1373     /**
1374      * @dev Transfers `tokenId` from `from` to `to`.
1375      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - `tokenId` token must be owned by `from`.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _transfer(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) internal virtual {
1389         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1390         require(to != address(0), "ERC721: transfer to the zero address");
1391 
1392         _beforeTokenTransfer(from, to, tokenId);
1393 
1394         // Clear approvals from the previous owner
1395         _approve(address(0), tokenId);
1396 
1397         _balances[from] -= 1;
1398         _balances[to] += 1;
1399         _owners[tokenId] = to;
1400 
1401         emit Transfer(from, to, tokenId);
1402 
1403         _afterTokenTransfer(from, to, tokenId);
1404     }
1405 
1406     /**
1407      * @dev Approve `to` to operate on `tokenId`
1408      *
1409      * Emits a {Approval} event.
1410      */
1411     function _approve(address to, uint256 tokenId) internal virtual {
1412         _tokenApprovals[tokenId] = to;
1413         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1414     }
1415 
1416     /**
1417      * @dev Approve `operator` to operate on all of `owner` tokens
1418      *
1419      * Emits a {ApprovalForAll} event.
1420      */
1421     function _setApprovalForAll(
1422         address owner,
1423         address operator,
1424         bool approved
1425     ) internal virtual {
1426         require(owner != operator, "ERC721: approve to caller");
1427         _operatorApprovals[owner][operator] = approved;
1428         emit ApprovalForAll(owner, operator, approved);
1429     }
1430 
1431     /**
1432      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1433      * The call is not executed if the target address is not a contract.
1434      *
1435      * @param from address representing the previous owner of the given token ID
1436      * @param to target address that will receive the tokens
1437      * @param tokenId uint256 ID of the token to be transferred
1438      * @param _data bytes optional data to send along with the call
1439      * @return bool whether the call correctly returned the expected magic value
1440      */
1441     function _checkOnERC721Received(
1442         address from,
1443         address to,
1444         uint256 tokenId,
1445         bytes memory _data
1446     ) private returns (bool) {
1447         if (to.isContract()) {
1448             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1449                 return retval == IERC721Receiver.onERC721Received.selector;
1450             } catch (bytes memory reason) {
1451                 if (reason.length == 0) {
1452                     revert("ERC721: transfer to non ERC721Receiver implementer");
1453                 } else {
1454                     assembly {
1455                         revert(add(32, reason), mload(reason))
1456                     }
1457                 }
1458             }
1459         } else {
1460             return true;
1461         }
1462     }
1463 
1464     /**
1465      * @dev Hook that is called before any token transfer. This includes minting
1466      * and burning.
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` will be minted for `to`.
1473      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1474      * - `from` and `to` are never both zero.
1475      *
1476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1477      */
1478     function _beforeTokenTransfer(
1479         address from,
1480         address to,
1481         uint256 tokenId
1482     ) internal virtual {}
1483 
1484     /**
1485      * @dev Hook that is called after any transfer of tokens. This includes
1486      * minting and burning.
1487      *
1488      * Calling conditions:
1489      *
1490      * - when `from` and `to` are both non-zero.
1491      * - `from` and `to` are never both zero.
1492      *
1493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1494      */
1495     function _afterTokenTransfer(
1496         address from,
1497         address to,
1498         uint256 tokenId
1499     ) internal virtual {}
1500 }
1501 
1502 // File: contracts/RRIC.sol
1503 
1504 
1505 pragma solidity ^0.8.4;
1506 
1507 
1508 
1509 
1510 
1511 /// @custom:security-contact admin@rinkraticeclub.com
1512 contract RinkRatIceClub is ERC721, Pausable, AccessControl {
1513     using Counters for Counters.Counter;
1514 
1515     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1516     bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
1517     bytes32 public constant GIVEAWAY_ROLE = keccak256("GIVEAWAY_ROLE");
1518     bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
1519     mapping(address => uint256) private _whitelistMintCount;
1520     uint public whitelistSaleTimestamp = 1655818200;
1521     uint public publicSaleTimestamp = 1655991000;
1522     uint public mintPrice = 0.12 ether;
1523     uint public maxItems = 7777;
1524     uint public maxItemsPerWhitelistWallet = 1000;
1525     uint public maxItemsPerPublicMint = 200;
1526     bool public mintPaused = false;
1527     string public baseTokenURI = "";
1528     Counters.Counter private _tokenIdCounter;
1529 
1530     event Mint(address indexed owner, uint indexed tokenId);
1531 
1532     constructor() ERC721("Rink Rat Ice Club", "RRIC") {
1533         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1534         _grantRole(PAUSER_ROLE, msg.sender);
1535         _grantRole(GIVEAWAY_ROLE, msg.sender);
1536         _grantRole(WITHDRAW_ROLE, msg.sender);
1537     }
1538 
1539     receive() external payable {}
1540 
1541     function pause() public onlyRole(PAUSER_ROLE) {
1542         _pause();
1543     }
1544 
1545     function unpause() public onlyRole(PAUSER_ROLE) {
1546         _unpause();
1547     }
1548 
1549     function publicMintTo(address to) external payable {
1550         _publicMint(to);
1551     }
1552 
1553     function publicMint() external payable {
1554         _publicMint(msg.sender);
1555     }
1556 
1557     function _publicMint(address to) internal {
1558         require(!mintPaused, "publicMint: Paused");
1559         require(block.timestamp >= publicSaleTimestamp, "publicMint: Not open yet");
1560         uint remainder = msg.value % mintPrice;
1561         uint amount = msg.value / mintPrice;
1562         require(remainder == 0, "publicMint: Send a divisible amount of eth");
1563         require(amount <= maxItemsPerPublicMint, "publicMint: Surpasses maxItemsPerPublicMint");
1564         _mintWithoutValidation(to, amount);
1565     }
1566 
1567     function givewayMint(address to, uint amount) external onlyRole(GIVEAWAY_ROLE) {
1568         _mintWithoutValidation(to, amount);
1569     }
1570 
1571     function isWhitelisted(address account) public view returns (bool) {
1572         return hasRole(WHITELIST_ROLE, account);
1573     }
1574 
1575     function totalSupply() public view returns (uint) {
1576         return _tokenIdCounter.current();
1577     }
1578 
1579     function whitelistMintTo(address to) external payable onlyRole(WHITELIST_ROLE) {
1580         _whitelistMint(to);
1581     }
1582 
1583     function whitelistMint() external payable onlyRole(WHITELIST_ROLE) {
1584         _whitelistMint(msg.sender);
1585     }
1586 
1587     function _whitelistMint(address to) internal {
1588         require(!mintPaused, "whitelistMint: Paused");
1589         require(block.timestamp >= whitelistSaleTimestamp, "whitelistMint: Not open yet");
1590         uint remainder = msg.value % mintPrice;
1591         uint amount = msg.value / mintPrice;
1592         require(remainder == 0, "whitelistMint: Send a divisible amount of eth");
1593         require(amount + _whitelistMintCount[to] <= maxItemsPerWhitelistWallet, "whitelistMint: Max whitelist mints from this address reached");
1594         _whitelistMintCount[to] += amount;
1595         _mintWithoutValidation(to, amount);
1596     }
1597 
1598     function _mintWithoutValidation(address to, uint amount) internal whenNotPaused {
1599         require(_tokenIdCounter.current() + amount <= maxItems, "mintWithoutValidation: Sold out");
1600         for (uint i = 0; i < amount; i++) {
1601             uint256 tokenId = _tokenIdCounter.current();
1602             _tokenIdCounter.increment();
1603             _mint(to, tokenId);
1604             emit Mint(to, tokenId);
1605         }
1606     }
1607 
1608     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1609         internal
1610         whenNotPaused
1611         override(ERC721)
1612     {
1613         super._beforeTokenTransfer(from, to, tokenId);
1614     }
1615 
1616     // The following functions are overrides required by Solidity.
1617 
1618     function supportsInterface(bytes4 interfaceId)
1619         public
1620         view
1621         override(ERC721, AccessControl)
1622         returns (bool)
1623     {
1624         return super.supportsInterface(interfaceId);
1625     }
1626 
1627     // Admin functions
1628 
1629     function setMaxItemsPerPublicMint(uint _maxItemsPerPublicMint) external onlyRole(DEFAULT_ADMIN_ROLE) {
1630         maxItemsPerPublicMint = _maxItemsPerPublicMint;
1631     }
1632 
1633     function setMaxItemsPerWhitelistWallet(uint _maxItemsPerWhitelistWallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
1634         maxItemsPerWhitelistWallet = _maxItemsPerWhitelistWallet;
1635     }
1636 
1637     function setMintPrice(uint _mintPrice) external onlyRole(DEFAULT_ADMIN_ROLE) {
1638         mintPrice = _mintPrice;
1639     }
1640 
1641     function toggleMintPaused() external onlyRole(DEFAULT_ADMIN_ROLE) {
1642         mintPaused = !mintPaused;
1643     }
1644 
1645     function setWhitelistSaleTimestamp(uint _whitelistSaleTimestamp) external onlyRole(DEFAULT_ADMIN_ROLE) {
1646         whitelistSaleTimestamp = _whitelistSaleTimestamp;
1647     }
1648 
1649     function setPublicSaleTimestamp(uint _publicSaleTimestamp) external onlyRole(DEFAULT_ADMIN_ROLE) {
1650         publicSaleTimestamp = _publicSaleTimestamp;
1651     }
1652 
1653     function bulkAssignWhitelistRoles(address[] memory accounts) external onlyRole(DEFAULT_ADMIN_ROLE) {
1654         for (uint i = 0; i < accounts.length; i++) {
1655             grantRole(WHITELIST_ROLE, accounts[i]);
1656         }
1657     }
1658 
1659     function setBaseTokenURI(string memory _baseTokenURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
1660         baseTokenURI = _baseTokenURI;
1661     }
1662 
1663     function _baseURI() internal view virtual override returns (string memory) {
1664         return baseTokenURI;
1665     }
1666 
1667     function withdraw(address to) external onlyRole(WITHDRAW_ROLE) {
1668         sendEth(to, address(this).balance);
1669     }
1670 
1671     function sendEth(address to, uint amount) internal {
1672         (bool success,) = to.call{value: amount}("");
1673         require(success, "Failed to send ether");
1674     }
1675 }