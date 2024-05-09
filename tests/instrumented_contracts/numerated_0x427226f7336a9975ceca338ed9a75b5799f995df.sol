1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/utils/Counters.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @title Counters
101  * @author Matt Condon (@shrugs)
102  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
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
132 
133     function reset(Counter storage counter) internal {
134         counter._value = 0;
135     }
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
331 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
332 
333 pragma solidity ^0.8.0;
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
355      */
356     function isContract(address account) internal view returns (bool) {
357         // This method relies on extcodesize, which returns 0 for contracts in
358         // construction, since the code is only stored at the end of the
359         // constructor execution.
360 
361         uint256 size;
362         assembly {
363             size := extcodesize(account)
364         }
365         return size > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(address(this).balance >= value, "Address: insufficient balance for call");
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @title ERC721 token receiver interface
557  * @dev Interface for any contract that wants to support safeTransfers
558  * from ERC721 asset contracts.
559  */
560 interface IERC721Receiver {
561     /**
562      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
563      * by `operator` from `from`, this function is called.
564      *
565      * It must return its Solidity selector to confirm the token transfer.
566      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
567      *
568      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
569      */
570     function onERC721Received(
571         address operator,
572         address from,
573         uint256 tokenId,
574         bytes calldata data
575     ) external returns (bytes4);
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Interface of the ERC165 standard, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-165[EIP].
588  *
589  * Implementers can declare support of contract interfaces, which can then be
590  * queried by others ({ERC165Checker}).
591  *
592  * For an implementation, see {ERC165}.
593  */
594 interface IERC165 {
595     /**
596      * @dev Returns true if this contract implements the interface defined by
597      * `interfaceId`. See the corresponding
598      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
599      * to learn more about how these ids are created.
600      *
601      * This function call must use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool);
604 }
605 
606 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 
637 // File: @openzeppelin/contracts/access/AccessControl.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 
646 
647 
648 /**
649  * @dev Contract module that allows children to implement role-based access
650  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
651  * members except through off-chain means by accessing the contract event logs. Some
652  * applications may benefit from on-chain enumerability, for those cases see
653  * {AccessControlEnumerable}.
654  *
655  * Roles are referred to by their `bytes32` identifier. These should be exposed
656  * in the external API and be unique. The best way to achieve this is by
657  * using `public constant` hash digests:
658  *
659  * ```
660  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
661  * ```
662  *
663  * Roles can be used to represent a set of permissions. To restrict access to a
664  * function call, use {hasRole}:
665  *
666  * ```
667  * function foo() public {
668  *     require(hasRole(MY_ROLE, msg.sender));
669  *     ...
670  * }
671  * ```
672  *
673  * Roles can be granted and revoked dynamically via the {grantRole} and
674  * {revokeRole} functions. Each role has an associated admin role, and only
675  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
676  *
677  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
678  * that only accounts with this role will be able to grant or revoke other
679  * roles. More complex role relationships can be created by using
680  * {_setRoleAdmin}.
681  *
682  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
683  * grant and revoke this role. Extra precautions should be taken to secure
684  * accounts that have been granted it.
685  */
686 abstract contract AccessControl is Context, IAccessControl, ERC165 {
687     struct RoleData {
688         mapping(address => bool) members;
689         bytes32 adminRole;
690     }
691 
692     mapping(bytes32 => RoleData) private _roles;
693 
694     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
695 
696     /**
697      * @dev Modifier that checks that an account has a specific role. Reverts
698      * with a standardized message including the required role.
699      *
700      * The format of the revert reason is given by the following regular expression:
701      *
702      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
703      *
704      * _Available since v4.1._
705      */
706     modifier onlyRole(bytes32 role) {
707         _checkRole(role, _msgSender());
708         _;
709     }
710 
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev Returns `true` if `account` has been granted `role`.
720      */
721     function hasRole(bytes32 role, address account) public view override returns (bool) {
722         return _roles[role].members[account];
723     }
724 
725     /**
726      * @dev Revert with a standard message if `account` is missing `role`.
727      *
728      * The format of the revert reason is given by the following regular expression:
729      *
730      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
731      */
732     function _checkRole(bytes32 role, address account) internal view {
733         if (!hasRole(role, account)) {
734             revert(
735                 string(
736                     abi.encodePacked(
737                         "AccessControl: account ",
738                         Strings.toHexString(uint160(account), 20),
739                         " is missing role ",
740                         Strings.toHexString(uint256(role), 32)
741                     )
742                 )
743             );
744         }
745     }
746 
747     /**
748      * @dev Returns the admin role that controls `role`. See {grantRole} and
749      * {revokeRole}.
750      *
751      * To change a role's admin, use {_setRoleAdmin}.
752      */
753     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
754         return _roles[role].adminRole;
755     }
756 
757     /**
758      * @dev Grants `role` to `account`.
759      *
760      * If `account` had not been already granted `role`, emits a {RoleGranted}
761      * event.
762      *
763      * Requirements:
764      *
765      * - the caller must have ``role``'s admin role.
766      */
767     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
768         _grantRole(role, account);
769     }
770 
771     /**
772      * @dev Revokes `role` from `account`.
773      *
774      * If `account` had been granted `role`, emits a {RoleRevoked} event.
775      *
776      * Requirements:
777      *
778      * - the caller must have ``role``'s admin role.
779      */
780     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
781         _revokeRole(role, account);
782     }
783 
784     /**
785      * @dev Revokes `role` from the calling account.
786      *
787      * Roles are often managed via {grantRole} and {revokeRole}: this function's
788      * purpose is to provide a mechanism for accounts to lose their privileges
789      * if they are compromised (such as when a trusted device is misplaced).
790      *
791      * If the calling account had been revoked `role`, emits a {RoleRevoked}
792      * event.
793      *
794      * Requirements:
795      *
796      * - the caller must be `account`.
797      */
798     function renounceRole(bytes32 role, address account) public virtual override {
799         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
800 
801         _revokeRole(role, account);
802     }
803 
804     /**
805      * @dev Grants `role` to `account`.
806      *
807      * If `account` had not been already granted `role`, emits a {RoleGranted}
808      * event. Note that unlike {grantRole}, this function doesn't perform any
809      * checks on the calling account.
810      *
811      * [WARNING]
812      * ====
813      * This function should only be called from the constructor when setting
814      * up the initial roles for the system.
815      *
816      * Using this function in any other way is effectively circumventing the admin
817      * system imposed by {AccessControl}.
818      * ====
819      *
820      * NOTE: This function is deprecated in favor of {_grantRole}.
821      */
822     function _setupRole(bytes32 role, address account) internal virtual {
823         _grantRole(role, account);
824     }
825 
826     /**
827      * @dev Sets `adminRole` as ``role``'s admin role.
828      *
829      * Emits a {RoleAdminChanged} event.
830      */
831     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
832         bytes32 previousAdminRole = getRoleAdmin(role);
833         _roles[role].adminRole = adminRole;
834         emit RoleAdminChanged(role, previousAdminRole, adminRole);
835     }
836 
837     /**
838      * @dev Grants `role` to `account`.
839      *
840      * Internal function without access restriction.
841      */
842     function _grantRole(bytes32 role, address account) internal virtual {
843         if (!hasRole(role, account)) {
844             _roles[role].members[account] = true;
845             emit RoleGranted(role, account, _msgSender());
846         }
847     }
848 
849     /**
850      * @dev Revokes `role` from `account`.
851      *
852      * Internal function without access restriction.
853      */
854     function _revokeRole(bytes32 role, address account) internal virtual {
855         if (hasRole(role, account)) {
856             _roles[role].members[account] = false;
857             emit RoleRevoked(role, account, _msgSender());
858         }
859     }
860 }
861 
862 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Required interface of an ERC721 compliant contract.
872  */
873 interface IERC721 is IERC165 {
874     /**
875      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
876      */
877     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
878 
879     /**
880      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
881      */
882     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
883 
884     /**
885      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
886      */
887     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
888 
889     /**
890      * @dev Returns the number of tokens in ``owner``'s account.
891      */
892     function balanceOf(address owner) external view returns (uint256 balance);
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) external view returns (address owner);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) external;
922 
923     /**
924      * @dev Transfers `tokenId` token from `from` to `to`.
925      *
926      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) external;
942 
943     /**
944      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
945      * The approval is cleared when the token is transferred.
946      *
947      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
948      *
949      * Requirements:
950      *
951      * - The caller must own the token or be an approved operator.
952      * - `tokenId` must exist.
953      *
954      * Emits an {Approval} event.
955      */
956     function approve(address to, uint256 tokenId) external;
957 
958     /**
959      * @dev Returns the account approved for `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function getApproved(uint256 tokenId) external view returns (address operator);
966 
967     /**
968      * @dev Approve or remove `operator` as an operator for the caller.
969      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
970      *
971      * Requirements:
972      *
973      * - The `operator` cannot be the caller.
974      *
975      * Emits an {ApprovalForAll} event.
976      */
977     function setApprovalForAll(address operator, bool _approved) external;
978 
979     /**
980      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
981      *
982      * See {setApprovalForAll}
983      */
984     function isApprovedForAll(address owner, address operator) external view returns (bool);
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes calldata data
1004     ) external;
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1017  * @dev See https://eips.ethereum.org/EIPS/eip-721
1018  */
1019 interface IERC721Enumerable is IERC721 {
1020     /**
1021      * @dev Returns the total amount of tokens stored by the contract.
1022      */
1023     function totalSupply() external view returns (uint256);
1024 
1025     /**
1026      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1027      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1028      */
1029     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1030 
1031     /**
1032      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1033      * Use along with {totalSupply} to enumerate all tokens.
1034      */
1035     function tokenByIndex(uint256 index) external view returns (uint256);
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 /**
1047  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1048  * @dev See https://eips.ethereum.org/EIPS/eip-721
1049  */
1050 interface IERC721Metadata is IERC721 {
1051     /**
1052      * @dev Returns the token collection name.
1053      */
1054     function name() external view returns (string memory);
1055 
1056     /**
1057      * @dev Returns the token collection symbol.
1058      */
1059     function symbol() external view returns (string memory);
1060 
1061     /**
1062      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1063      */
1064     function tokenURI(uint256 tokenId) external view returns (string memory);
1065 }
1066 
1067 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 
1075 
1076 
1077 
1078 
1079 
1080 
1081 /**
1082  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1083  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1084  * {ERC721Enumerable}.
1085  */
1086 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1087     using Address for address;
1088     using Strings for uint256;
1089 
1090     // Token name
1091     string private _name;
1092 
1093     // Token symbol
1094     string private _symbol;
1095 
1096     // Mapping from token ID to owner address
1097     mapping(uint256 => address) private _owners;
1098 
1099     // Mapping owner address to token count
1100     mapping(address => uint256) private _balances;
1101 
1102     // Mapping from token ID to approved address
1103     mapping(uint256 => address) private _tokenApprovals;
1104 
1105     // Mapping from owner to operator approvals
1106     mapping(address => mapping(address => bool)) private _operatorApprovals;
1107 
1108     /**
1109      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1110      */
1111     constructor(string memory name_, string memory symbol_) {
1112         _name = name_;
1113         _symbol = symbol_;
1114     }
1115 
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1120         return
1121             interfaceId == type(IERC721).interfaceId ||
1122             interfaceId == type(IERC721Metadata).interfaceId ||
1123             super.supportsInterface(interfaceId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-balanceOf}.
1128      */
1129     function balanceOf(address owner) public view virtual override returns (uint256) {
1130         require(owner != address(0), "ERC721: balance query for the zero address");
1131         return _balances[owner];
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-ownerOf}.
1136      */
1137     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1138         address owner = _owners[tokenId];
1139         require(owner != address(0), "ERC721: owner query for nonexistent token");
1140         return owner;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-name}.
1145      */
1146     function name() public view virtual override returns (string memory) {
1147         return _name;
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Metadata-symbol}.
1152      */
1153     function symbol() public view virtual override returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Metadata-tokenURI}.
1159      */
1160     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1161         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1162 
1163         string memory baseURI = _baseURI();
1164         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1165     }
1166 
1167     /**
1168      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1169      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1170      * by default, can be overriden in child contracts.
1171      */
1172     function _baseURI() internal view virtual returns (string memory) {
1173         return "";
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-approve}.
1178      */
1179     function approve(address to, uint256 tokenId) public virtual override {
1180         address owner = ERC721.ownerOf(tokenId);
1181         require(to != owner, "ERC721: approval to current owner");
1182 
1183         require(
1184             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1185             "ERC721: approve caller is not owner nor approved for all"
1186         );
1187 
1188         _approve(to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-getApproved}.
1193      */
1194     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1195         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1196 
1197         return _tokenApprovals[tokenId];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-setApprovalForAll}.
1202      */
1203     function setApprovalForAll(address operator, bool approved) public virtual override {
1204         _setApprovalForAll(_msgSender(), operator, approved);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-isApprovedForAll}.
1209      */
1210     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1211         return _operatorApprovals[owner][operator];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-transferFrom}.
1216      */
1217     function transferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         //solhint-disable-next-line max-line-length
1223         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1224 
1225         _transfer(from, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-safeTransferFrom}.
1230      */
1231     function safeTransferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public virtual override {
1236         safeTransferFrom(from, to, tokenId, "");
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) public virtual override {
1248         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1249         _safeTransfer(from, to, tokenId, _data);
1250     }
1251 
1252     /**
1253      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1254      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1255      *
1256      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1257      *
1258      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1259      * implement alternative mechanisms to perform token transfer, such as signature-based.
1260      *
1261      * Requirements:
1262      *
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must exist and be owned by `from`.
1266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _safeTransfer(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) internal virtual {
1276         _transfer(from, to, tokenId);
1277         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1278     }
1279 
1280     /**
1281      * @dev Returns whether `tokenId` exists.
1282      *
1283      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1284      *
1285      * Tokens start existing when they are minted (`_mint`),
1286      * and stop existing when they are burned (`_burn`).
1287      */
1288     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1289         return _owners[tokenId] != address(0);
1290     }
1291 
1292     /**
1293      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      */
1299     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1300         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1301         address owner = ERC721.ownerOf(tokenId);
1302         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1303     }
1304 
1305     /**
1306      * @dev Safely mints `tokenId` and transfers it to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must not exist.
1311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _safeMint(address to, uint256 tokenId) internal virtual {
1316         _safeMint(to, tokenId, "");
1317     }
1318 
1319     /**
1320      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1321      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1322      */
1323     function _safeMint(
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) internal virtual {
1328         _mint(to, tokenId);
1329         require(
1330             _checkOnERC721Received(address(0), to, tokenId, _data),
1331             "ERC721: transfer to non ERC721Receiver implementer"
1332         );
1333     }
1334 
1335     /**
1336      * @dev Mints `tokenId` and transfers it to `to`.
1337      *
1338      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must not exist.
1343      * - `to` cannot be the zero address.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _mint(address to, uint256 tokenId) internal virtual {
1348         require(to != address(0), "ERC721: mint to the zero address");
1349         require(!_exists(tokenId), "ERC721: token already minted");
1350 
1351         _beforeTokenTransfer(address(0), to, tokenId);
1352 
1353         _balances[to] += 1;
1354         _owners[tokenId] = to;
1355 
1356         emit Transfer(address(0), to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Destroys `tokenId`.
1361      * The approval is cleared when the token is burned.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _burn(uint256 tokenId) internal virtual {
1370         address owner = ERC721.ownerOf(tokenId);
1371 
1372         _beforeTokenTransfer(owner, address(0), tokenId);
1373 
1374         // Clear approvals
1375         _approve(address(0), tokenId);
1376 
1377         _balances[owner] -= 1;
1378         delete _owners[tokenId];
1379 
1380         emit Transfer(owner, address(0), tokenId);
1381     }
1382 
1383     /**
1384      * @dev Transfers `tokenId` from `from` to `to`.
1385      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1386      *
1387      * Requirements:
1388      *
1389      * - `to` cannot be the zero address.
1390      * - `tokenId` token must be owned by `from`.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _transfer(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) internal virtual {
1399         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1400         require(to != address(0), "ERC721: transfer to the zero address");
1401 
1402         _beforeTokenTransfer(from, to, tokenId);
1403 
1404         // Clear approvals from the previous owner
1405         _approve(address(0), tokenId);
1406 
1407         _balances[from] -= 1;
1408         _balances[to] += 1;
1409         _owners[tokenId] = to;
1410 
1411         emit Transfer(from, to, tokenId);
1412     }
1413 
1414     /**
1415      * @dev Approve `to` to operate on `tokenId`
1416      *
1417      * Emits a {Approval} event.
1418      */
1419     function _approve(address to, uint256 tokenId) internal virtual {
1420         _tokenApprovals[tokenId] = to;
1421         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1422     }
1423 
1424     /**
1425      * @dev Approve `operator` to operate on all of `owner` tokens
1426      *
1427      * Emits a {ApprovalForAll} event.
1428      */
1429     function _setApprovalForAll(
1430         address owner,
1431         address operator,
1432         bool approved
1433     ) internal virtual {
1434         require(owner != operator, "ERC721: approve to caller");
1435         _operatorApprovals[owner][operator] = approved;
1436         emit ApprovalForAll(owner, operator, approved);
1437     }
1438 
1439     /**
1440      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1441      * The call is not executed if the target address is not a contract.
1442      *
1443      * @param from address representing the previous owner of the given token ID
1444      * @param to target address that will receive the tokens
1445      * @param tokenId uint256 ID of the token to be transferred
1446      * @param _data bytes optional data to send along with the call
1447      * @return bool whether the call correctly returned the expected magic value
1448      */
1449     function _checkOnERC721Received(
1450         address from,
1451         address to,
1452         uint256 tokenId,
1453         bytes memory _data
1454     ) private returns (bool) {
1455         if (to.isContract()) {
1456             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1457                 return retval == IERC721Receiver.onERC721Received.selector;
1458             } catch (bytes memory reason) {
1459                 if (reason.length == 0) {
1460                     revert("ERC721: transfer to non ERC721Receiver implementer");
1461                 } else {
1462                     assembly {
1463                         revert(add(32, reason), mload(reason))
1464                     }
1465                 }
1466             }
1467         } else {
1468             return true;
1469         }
1470     }
1471 
1472     /**
1473      * @dev Hook that is called before any token transfer. This includes minting
1474      * and burning.
1475      *
1476      * Calling conditions:
1477      *
1478      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1479      * transferred to `to`.
1480      * - When `from` is zero, `tokenId` will be minted for `to`.
1481      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1482      * - `from` and `to` are never both zero.
1483      *
1484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1485      */
1486     function _beforeTokenTransfer(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) internal virtual {}
1491 }
1492 
1493 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1494 
1495 
1496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 
1501 
1502 /**
1503  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1504  * enumerability of all the token ids in the contract as well as all token ids owned by each
1505  * account.
1506  */
1507 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1508     // Mapping from owner to list of owned token IDs
1509     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1510 
1511     // Mapping from token ID to index of the owner tokens list
1512     mapping(uint256 => uint256) private _ownedTokensIndex;
1513 
1514     // Array with all token ids, used for enumeration
1515     uint256[] private _allTokens;
1516 
1517     // Mapping from token id to position in the allTokens array
1518     mapping(uint256 => uint256) private _allTokensIndex;
1519 
1520     /**
1521      * @dev See {IERC165-supportsInterface}.
1522      */
1523     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1524         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1529      */
1530     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1531         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1532         return _ownedTokens[owner][index];
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Enumerable-totalSupply}.
1537      */
1538     function totalSupply() public view virtual override returns (uint256) {
1539         return _allTokens.length;
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-tokenByIndex}.
1544      */
1545     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1546         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1547         return _allTokens[index];
1548     }
1549 
1550     /**
1551      * @dev Hook that is called before any token transfer. This includes minting
1552      * and burning.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` will be minted for `to`.
1559      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      *
1563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1564      */
1565     function _beforeTokenTransfer(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) internal virtual override {
1570         super._beforeTokenTransfer(from, to, tokenId);
1571 
1572         if (from == address(0)) {
1573             _addTokenToAllTokensEnumeration(tokenId);
1574         } else if (from != to) {
1575             _removeTokenFromOwnerEnumeration(from, tokenId);
1576         }
1577         if (to == address(0)) {
1578             _removeTokenFromAllTokensEnumeration(tokenId);
1579         } else if (to != from) {
1580             _addTokenToOwnerEnumeration(to, tokenId);
1581         }
1582     }
1583 
1584     /**
1585      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1586      * @param to address representing the new owner of the given token ID
1587      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1588      */
1589     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1590         uint256 length = ERC721.balanceOf(to);
1591         _ownedTokens[to][length] = tokenId;
1592         _ownedTokensIndex[tokenId] = length;
1593     }
1594 
1595     /**
1596      * @dev Private function to add a token to this extension's token tracking data structures.
1597      * @param tokenId uint256 ID of the token to be added to the tokens list
1598      */
1599     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1600         _allTokensIndex[tokenId] = _allTokens.length;
1601         _allTokens.push(tokenId);
1602     }
1603 
1604     /**
1605      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1606      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1607      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1608      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1609      * @param from address representing the previous owner of the given token ID
1610      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1611      */
1612     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1613         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1614         // then delete the last slot (swap and pop).
1615 
1616         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1617         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1618 
1619         // When the token to delete is the last token, the swap operation is unnecessary
1620         if (tokenIndex != lastTokenIndex) {
1621             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1622 
1623             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1624             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1625         }
1626 
1627         // This also deletes the contents at the last position of the array
1628         delete _ownedTokensIndex[tokenId];
1629         delete _ownedTokens[from][lastTokenIndex];
1630     }
1631 
1632     /**
1633      * @dev Private function to remove a token from this extension's token tracking data structures.
1634      * This has O(1) time complexity, but alters the order of the _allTokens array.
1635      * @param tokenId uint256 ID of the token to be removed from the tokens list
1636      */
1637     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1638         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1639         // then delete the last slot (swap and pop).
1640 
1641         uint256 lastTokenIndex = _allTokens.length - 1;
1642         uint256 tokenIndex = _allTokensIndex[tokenId];
1643 
1644         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1645         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1646         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1647         uint256 lastTokenId = _allTokens[lastTokenIndex];
1648 
1649         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1650         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1651 
1652         // This also deletes the contents at the last position of the array
1653         delete _allTokensIndex[tokenId];
1654         _allTokens.pop();
1655     }
1656 }
1657 
1658 // File: contracts/Wabipunks.sol
1659 
1660 pragma solidity ^0.8.7;
1661 
1662 
1663 
1664 
1665 
1666 
1667 contract Wabipunks is ERC721Enumerable, Pausable, AccessControl {
1668   using Strings for uint256;
1669   using Counters for Counters.Counter;
1670 
1671   Counters.Counter private _babiesIds;
1672   uint256 public _supply = 10000;
1673   string private _uri;
1674   string private _extension;
1675   mapping(address => bool) private _whitelist;
1676   bytes32 public constant MINTER_ROLE = keccak256("WABIMINTER");
1677   bytes32 public constant BURNER_ROLE = keccak256("WABIBURNER");
1678   address payable private wabiWallet;
1679 
1680   constructor(
1681     string memory uri_,
1682     address payable wabiWallet_
1683   )
1684     ERC721("WabiPunks", "WPKS")
1685   {
1686     _uri = uri_;
1687     _extension = "";
1688     wabiWallet = wabiWallet_;
1689     _setupRole(DEFAULT_ADMIN_ROLE, 0xC3f3dd9c23264607F703edC1638aCc307b66a375);
1690     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1691   }
1692 
1693   function transfer(address to, uint256 tokenId) external {
1694     _transfer(msg.sender, to, tokenId);
1695   }
1696 
1697   /**
1698         @dev Mint new token and maps to receiver
1699     */
1700   function mint(uint256 amount, address to)
1701     external
1702     payable
1703     whenNotPaused
1704     onlyRole(MINTER_ROLE)
1705   {
1706     for (uint256 i = 0; i < amount; i++) {
1707       _babiesIds.increment();
1708       _safeMint(to, _babiesIds.current());
1709     }
1710   }
1711 
1712   function allTokensByOwner(address _owner)
1713     public
1714     view
1715     returns (uint256[] memory)
1716   {
1717     uint256 ownerBalance = balanceOf(_owner);
1718     uint256[] memory tokenIds = new uint256[](ownerBalance);
1719     for (uint256 i; i < ownerBalance; i++) {
1720       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1721     }
1722     return tokenIds;
1723   }
1724 
1725   /**
1726         @dev Base URI getter
1727         @return Base URI
1728     */
1729   function _baseURI() internal view virtual override returns (string memory) {
1730     return _uri;
1731   }
1732 
1733   /**
1734         @dev Get token URI by token ID, adds .json extension
1735         @return URI of the token metadata 
1736     */
1737   function tokenURI(uint256 tokenId)
1738     public
1739     view
1740     virtual
1741     override
1742     returns (string memory)
1743   {
1744     string memory baseURI = _baseURI();
1745     return
1746       bytes(baseURI).length > 0
1747         ? string(abi.encodePacked(baseURI, tokenId.toString(), _extension))
1748         : "";
1749   }
1750 
1751   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControl) returns (bool) {
1752     return super.supportsInterface(interfaceId);
1753   }
1754 
1755   function burn(uint256 tokenId) external onlyRole(BURNER_ROLE) {
1756     require(
1757       _isApprovedOrOwner(_msgSender(), tokenId),
1758       "ERC721Burnable: caller is not owner nor approved"
1759     );
1760     _burn(tokenId);
1761   }
1762 
1763   /**
1764     @dev Change Base URI can be used to reveal NFTs
1765     @param uri_ String of the new uri
1766      */
1767   function changeBaseURI(string memory uri_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1768     _uri = uri_;
1769   }
1770 
1771   function changeExtension(string memory extension_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1772     _extension = extension_;
1773   }
1774 
1775   function changewabiWallet(address payable newWallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
1776     wabiWallet = newWallet;
1777   }
1778   /**
1779     @dev Withdraw ETH balance to the owner
1780      */
1781   function withdraw() external onlyRole(DEFAULT_ADMIN_ROLE) {
1782     wabiWallet.transfer(address(this).balance);
1783   }
1784 
1785   /**
1786     @dev Change supply
1787     @param supply_ New supply
1788      */
1789   function changeSupply(uint256 supply_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1790     require(supply_ >= totalSupply(), "Wabipunks: New Supply is below totalSupply");
1791     _supply = supply_;
1792   }
1793 
1794   function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1795     _pause();
1796   }
1797 
1798   function unPause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1799     _unpause();
1800   }
1801 }