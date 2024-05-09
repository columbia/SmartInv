1 // File: contracts/ownable.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 contract Ownable {
8     address public owner;
9 
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     constructor() {
18         owner = msg.sender;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /*
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 // File: @openzeppelin/contracts/utils/Counters.sol
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @title Counters
49  * @author Matt Condon (@shrugs)
50  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
51  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
52  *
53  * Include with `using Counters for Counters.Counter;`
54  */
55 library Counters {
56     struct Counter {
57         // This variable should never be directly accessed by users of the library: interactions must be restricted to
58         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
59         // this feature: see https://github.com/ethereum/solidity/issues/4637
60         uint256 _value; // default: 0
61     }
62 
63     function current(Counter storage counter) internal view returns (uint256) {
64         return counter._value;
65     }
66 
67     function increment(Counter storage counter) internal {
68         unchecked {
69             counter._value += 1;
70         }
71     }
72 
73     function decrement(Counter storage counter) internal {
74         uint256 value = counter._value;
75         require(value > 0, "Counter: decrement overflow");
76         unchecked {
77             counter._value = value - 1;
78         }
79     }
80 
81     function reset(Counter storage counter) internal {
82         counter._value = 0;
83     }
84 }
85 
86 // File: @openzeppelin/contracts/access/IAccessControl.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev External interface of AccessControl declared to support ERC165 detection.
95  */
96 interface IAccessControl {
97     /**
98      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
99      *
100      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
101      * {RoleAdminChanged} not being emitted signaling this.
102      *
103      * _Available since v3.1._
104      */
105     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
106 
107     /**
108      * @dev Emitted when `account` is granted `role`.
109      *
110      * `sender` is the account that originated the contract call, an admin role
111      * bearer except when using {AccessControl-_setupRole}.
112      */
113     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
114 
115     /**
116      * @dev Emitted when `account` is revoked `role`.
117      *
118      * `sender` is the account that originated the contract call:
119      *   - if using `revokeRole`, it is the admin role bearer
120      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
121      */
122     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
123 
124     /**
125      * @dev Returns `true` if `account` has been granted `role`.
126      */
127     function hasRole(bytes32 role, address account) external view returns (bool);
128 
129     /**
130      * @dev Returns the admin role that controls `role`. See {grantRole} and
131      * {revokeRole}.
132      *
133      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
134      */
135     function getRoleAdmin(bytes32 role) external view returns (bytes32);
136 
137     /**
138      * @dev Grants `role` to `account`.
139      *
140      * If `account` had not been already granted `role`, emits a {RoleGranted}
141      * event.
142      *
143      * Requirements:
144      *
145      * - the caller must have ``role``'s admin role.
146      */
147     function grantRole(bytes32 role, address account) external;
148 
149     /**
150      * @dev Revokes `role` from `account`.
151      *
152      * If `account` had been granted `role`, emits a {RoleRevoked} event.
153      *
154      * Requirements:
155      *
156      * - the caller must have ``role``'s admin role.
157      */
158     function revokeRole(bytes32 role, address account) external;
159 
160     /**
161      * @dev Revokes `role` from the calling account.
162      *
163      * Roles are often managed via {grantRole} and {revokeRole}: this function's
164      * purpose is to provide a mechanism for accounts to lose their privileges
165      * if they are compromised (such as when a trusted device is misplaced).
166      *
167      * If the calling account had been granted `role`, emits a {RoleRevoked}
168      * event.
169      *
170      * Requirements:
171      *
172      * - the caller must be `account`.
173      */
174     function renounceRole(bytes32 role, address account) external;
175 }
176 
177 // File: @openzeppelin/contracts/utils/Strings.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev String operations.
186  */
187 library Strings {
188     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
192      */
193     function toString(uint256 value) internal pure returns (string memory) {
194         // Inspired by OraclizeAPI's implementation - MIT licence
195         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
196 
197         if (value == 0) {
198             return "0";
199         }
200         uint256 temp = value;
201         uint256 digits;
202         while (temp != 0) {
203             digits++;
204             temp /= 10;
205         }
206         bytes memory buffer = new bytes(digits);
207         while (value != 0) {
208             digits -= 1;
209             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
210             value /= 10;
211         }
212         return string(buffer);
213     }
214 
215     /**
216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
217      */
218     function toHexString(uint256 value) internal pure returns (string memory) {
219         if (value == 0) {
220             return "0x00";
221         }
222         uint256 temp = value;
223         uint256 length = 0;
224         while (temp != 0) {
225             length++;
226             temp >>= 8;
227         }
228         return toHexString(value, length);
229     }
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
233      */
234     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
235         bytes memory buffer = new bytes(2 * length + 2);
236         buffer[0] = "0";
237         buffer[1] = "x";
238         for (uint256 i = 2 * length + 1; i > 1; --i) {
239             buffer[i] = _HEX_SYMBOLS[value & 0xf];
240             value >>= 4;
241         }
242         require(value == 0, "Strings: hex length insufficient");
243         return string(buffer);
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Context.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Provides information about the current execution context, including the
256  * sender of the transaction and its data. While these are generally available
257  * via msg.sender and msg.data, they should not be accessed in such a direct
258  * manner, since when dealing with meta-transactions the account sending and
259  * paying for execution may not be the actual sender (as far as an application
260  * is concerned).
261  *
262  * This contract is only required for intermediate, library-like contracts.
263  */
264 abstract contract Context {
265     function _msgSender() internal view virtual returns (address) {
266         return msg.sender;
267     }
268 
269     function _msgData() internal view virtual returns (bytes calldata) {
270         return msg.data;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/security/Pausable.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 
282 /**
283  * @dev Contract module which allows children to implement an emergency stop
284  * mechanism that can be triggered by an authorized account.
285  *
286  * This module is used through inheritance. It will make available the
287  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
288  * the functions of your contract. Note that they will not be pausable by
289  * simply including this module, only once the modifiers are put in place.
290  */
291 abstract contract Pausable is Context {
292     /**
293      * @dev Emitted when the pause is triggered by `account`.
294      */
295     event Paused(address account);
296 
297     /**
298      * @dev Emitted when the pause is lifted by `account`.
299      */
300     event Unpaused(address account);
301 
302     bool private _paused;
303 
304     /**
305      * @dev Initializes the contract in unpaused state.
306      */
307     constructor() {
308         _paused = false;
309     }
310 
311     /**
312      * @dev Returns true if the contract is paused, and false otherwise.
313      */
314     function paused() public view virtual returns (bool) {
315         return _paused;
316     }
317 
318     /**
319      * @dev Modifier to make a function callable only when the contract is not paused.
320      *
321      * Requirements:
322      *
323      * - The contract must not be paused.
324      */
325     modifier whenNotPaused() {
326         require(!paused(), "Pausable: paused");
327         _;
328     }
329 
330     /**
331      * @dev Modifier to make a function callable only when the contract is paused.
332      *
333      * Requirements:
334      *
335      * - The contract must be paused.
336      */
337     modifier whenPaused() {
338         require(paused(), "Pausable: not paused");
339         _;
340     }
341 
342     /**
343      * @dev Triggers stopped state.
344      *
345      * Requirements:
346      *
347      * - The contract must not be paused.
348      */
349     function _pause() internal virtual whenNotPaused {
350         _paused = true;
351         emit Paused(_msgSender());
352     }
353 
354     /**
355      * @dev Returns to normal state.
356      *
357      * Requirements:
358      *
359      * - The contract must be paused.
360      */
361     function _unpause() internal virtual whenPaused {
362         _paused = false;
363         emit Unpaused(_msgSender());
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Address.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      */
395     function isContract(address account) internal view returns (bool) {
396         // This method relies on extcodesize, which returns 0 for contracts in
397         // construction, since the code is only stored at the end of the
398         // constructor execution.
399 
400         uint256 size;
401         assembly {
402             size := extcodesize(account)
403         }
404         return size > 0;
405     }
406 
407     /**
408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
409      * `recipient`, forwarding all available gas and reverting on errors.
410      *
411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
413      * imposed by `transfer`, making them unable to receive funds via
414      * `transfer`. {sendValue} removes this limitation.
415      *
416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
417      *
418      * IMPORTANT: because control is transferred to `recipient`, care must be
419      * taken to not create reentrancy vulnerabilities. Consider using
420      * {ReentrancyGuard} or the
421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
422      */
423     function sendValue(address payable recipient, uint256 amount) internal {
424         require(address(this).balance >= amount, "Address: insufficient balance");
425 
426         (bool success, ) = recipient.call{value: amount}("");
427         require(success, "Address: unable to send value, recipient may have reverted");
428     }
429 
430     /**
431      * @dev Performs a Solidity function call using a low level `call`. A
432      * plain `call` is an unsafe replacement for a function call: use this
433      * function instead.
434      *
435      * If `target` reverts with a revert reason, it is bubbled up by this
436      * function (like regular Solidity function calls).
437      *
438      * Returns the raw returned data. To convert to the expected return value,
439      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
440      *
441      * Requirements:
442      *
443      * - `target` must be a contract.
444      * - calling `target` with `data` must not revert.
445      *
446      * _Available since v3.1._
447      */
448     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionCall(target, data, "Address: low-level call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
454      * `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         return functionCallWithValue(target, data, 0, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but also transferring `value` wei to `target`.
469      *
470      * Requirements:
471      *
472      * - the calling contract must have an ETH balance of at least `value`.
473      * - the called Solidity function must be `payable`.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value
481     ) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
487      * with `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(address(this).balance >= value, "Address: insufficient balance for call");
498         require(isContract(target), "Address: call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.call{value: value}(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but performing a static call.
507      *
508      * _Available since v3.3._
509      */
510     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
511         return functionStaticCall(target, data, "Address: low-level static call failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal view returns (bytes memory) {
525         require(isContract(target), "Address: static call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.staticcall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a delegate call.
534      *
535      * _Available since v3.4._
536      */
537     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
538         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(isContract(target), "Address: delegate call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.delegatecall(data);
555         return verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
560      * revert reason using the provided one.
561      *
562      * _Available since v4.3._
563      */
564     function verifyCallResult(
565         bool success,
566         bytes memory returndata,
567         string memory errorMessage
568     ) internal pure returns (bytes memory) {
569         if (success) {
570             return returndata;
571         } else {
572             // Look for revert reason and bubble it up if present
573             if (returndata.length > 0) {
574                 // The easiest way to bubble the revert reason is using memory via assembly
575 
576                 assembly {
577                     let returndata_size := mload(returndata)
578                     revert(add(32, returndata), returndata_size)
579                 }
580             } else {
581                 revert(errorMessage);
582             }
583         }
584     }
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @title ERC721 token receiver interface
596  * @dev Interface for any contract that wants to support safeTransfers
597  * from ERC721 asset contracts.
598  */
599 interface IERC721Receiver {
600     /**
601      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
602      * by `operator` from `from`, this function is called.
603      *
604      * It must return its Solidity selector to confirm the token transfer.
605      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
606      *
607      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
608      */
609     function onERC721Received(
610         address operator,
611         address from,
612         uint256 tokenId,
613         bytes calldata data
614     ) external returns (bytes4);
615 }
616 
617 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Interface of the ERC165 standard, as defined in the
626  * https://eips.ethereum.org/EIPS/eip-165[EIP].
627  *
628  * Implementers can declare support of contract interfaces, which can then be
629  * queried by others ({ERC165Checker}).
630  *
631  * For an implementation, see {ERC165}.
632  */
633 interface IERC165 {
634     /**
635      * @dev Returns true if this contract implements the interface defined by
636      * `interfaceId`. See the corresponding
637      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
638      * to learn more about how these ids are created.
639      *
640      * This function call must use less than 30 000 gas.
641      */
642     function supportsInterface(bytes4 interfaceId) external view returns (bool);
643 }
644 
645 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 
653 /**
654  * @dev Implementation of the {IERC165} interface.
655  *
656  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
657  * for the additional interface id that will be supported. For example:
658  *
659  * ```solidity
660  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
662  * }
663  * ```
664  *
665  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
666  */
667 abstract contract ERC165 is IERC165 {
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
672         return interfaceId == type(IERC165).interfaceId;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/access/AccessControl.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 
685 
686 
687 /**
688  * @dev Contract module that allows children to implement role-based access
689  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
690  * members except through off-chain means by accessing the contract event logs. Some
691  * applications may benefit from on-chain enumerability, for those cases see
692  * {AccessControlEnumerable}.
693  *
694  * Roles are referred to by their `bytes32` identifier. These should be exposed
695  * in the external API and be unique. The best way to achieve this is by
696  * using `public constant` hash digests:
697  *
698  * ```
699  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
700  * ```
701  *
702  * Roles can be used to represent a set of permissions. To restrict access to a
703  * function call, use {hasRole}:
704  *
705  * ```
706  * function foo() public {
707  *     require(hasRole(MY_ROLE, msg.sender));
708  *     ...
709  * }
710  * ```
711  *
712  * Roles can be granted and revoked dynamically via the {grantRole} and
713  * {revokeRole} functions. Each role has an associated admin role, and only
714  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
715  *
716  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
717  * that only accounts with this role will be able to grant or revoke other
718  * roles. More complex role relationships can be created by using
719  * {_setRoleAdmin}.
720  *
721  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
722  * grant and revoke this role. Extra precautions should be taken to secure
723  * accounts that have been granted it.
724  */
725 abstract contract AccessControl is Context, IAccessControl, ERC165 {
726     struct RoleData {
727         mapping(address => bool) members;
728         bytes32 adminRole;
729     }
730 
731     mapping(bytes32 => RoleData) private _roles;
732 
733     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
734 
735     /**
736      * @dev Modifier that checks that an account has a specific role. Reverts
737      * with a standardized message including the required role.
738      *
739      * The format of the revert reason is given by the following regular expression:
740      *
741      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
742      *
743      * _Available since v4.1._
744      */
745     modifier onlyRole(bytes32 role) {
746         _checkRole(role, _msgSender());
747         _;
748     }
749 
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
755     }
756 
757     /**
758      * @dev Returns `true` if `account` has been granted `role`.
759      */
760     function hasRole(bytes32 role, address account) public view override returns (bool) {
761         return _roles[role].members[account];
762     }
763 
764     /**
765      * @dev Revert with a standard message if `account` is missing `role`.
766      *
767      * The format of the revert reason is given by the following regular expression:
768      *
769      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
770      */
771     function _checkRole(bytes32 role, address account) internal view {
772         if (!hasRole(role, account)) {
773             revert(
774                 string(
775                     abi.encodePacked(
776                         "AccessControl: account ",
777                         Strings.toHexString(uint160(account), 20),
778                         " is missing role ",
779                         Strings.toHexString(uint256(role), 32)
780                     )
781                 )
782             );
783         }
784     }
785 
786     /**
787      * @dev Returns the admin role that controls `role`. See {grantRole} and
788      * {revokeRole}.
789      *
790      * To change a role's admin, use {_setRoleAdmin}.
791      */
792     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
793         return _roles[role].adminRole;
794     }
795 
796     /**
797      * @dev Grants `role` to `account`.
798      *
799      * If `account` had not been already granted `role`, emits a {RoleGranted}
800      * event.
801      *
802      * Requirements:
803      *
804      * - the caller must have ``role``'s admin role.
805      */
806     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
807         _grantRole(role, account);
808     }
809 
810     /**
811      * @dev Revokes `role` from `account`.
812      *
813      * If `account` had been granted `role`, emits a {RoleRevoked} event.
814      *
815      * Requirements:
816      *
817      * - the caller must have ``role``'s admin role.
818      */
819     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
820         _revokeRole(role, account);
821     }
822 
823     /**
824      * @dev Revokes `role` from the calling account.
825      *
826      * Roles are often managed via {grantRole} and {revokeRole}: this function's
827      * purpose is to provide a mechanism for accounts to lose their privileges
828      * if they are compromised (such as when a trusted device is misplaced).
829      *
830      * If the calling account had been revoked `role`, emits a {RoleRevoked}
831      * event.
832      *
833      * Requirements:
834      *
835      * - the caller must be `account`.
836      */
837     function renounceRole(bytes32 role, address account) public virtual override {
838         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
839 
840         _revokeRole(role, account);
841     }
842 
843     /**
844      * @dev Grants `role` to `account`.
845      *
846      * If `account` had not been already granted `role`, emits a {RoleGranted}
847      * event. Note that unlike {grantRole}, this function doesn't perform any
848      * checks on the calling account.
849      *
850      * [WARNING]
851      * ====
852      * This function should only be called from the constructor when setting
853      * up the initial roles for the system.
854      *
855      * Using this function in any other way is effectively circumventing the admin
856      * system imposed by {AccessControl}.
857      * ====
858      *
859      * NOTE: This function is deprecated in favor of {_grantRole}.
860      */
861     function _setupRole(bytes32 role, address account) internal virtual {
862         _grantRole(role, account);
863     }
864 
865     /**
866      * @dev Sets `adminRole` as ``role``'s admin role.
867      *
868      * Emits a {RoleAdminChanged} event.
869      */
870     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
871         bytes32 previousAdminRole = getRoleAdmin(role);
872         _roles[role].adminRole = adminRole;
873         emit RoleAdminChanged(role, previousAdminRole, adminRole);
874     }
875 
876     /**
877      * @dev Grants `role` to `account`.
878      *
879      * Internal function without access restriction.
880      */
881     function _grantRole(bytes32 role, address account) internal virtual {
882         if (!hasRole(role, account)) {
883             _roles[role].members[account] = true;
884             emit RoleGranted(role, account, _msgSender());
885         }
886     }
887 
888     /**
889      * @dev Revokes `role` from `account`.
890      *
891      * Internal function without access restriction.
892      */
893     function _revokeRole(bytes32 role, address account) internal virtual {
894         if (hasRole(role, account)) {
895             _roles[role].members[account] = false;
896             emit RoleRevoked(role, account, _msgSender());
897         }
898     }
899 }
900 
901 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @dev Required interface of an ERC721 compliant contract.
911  */
912 interface IERC721 is IERC165 {
913     /**
914      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
915      */
916     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
917 
918     /**
919      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
920      */
921     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
922 
923     /**
924      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
925      */
926     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
927 
928     /**
929      * @dev Returns the number of tokens in ``owner``'s account.
930      */
931     function balanceOf(address owner) external view returns (uint256 balance);
932 
933     /**
934      * @dev Returns the owner of the `tokenId` token.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function ownerOf(uint256 tokenId) external view returns (address owner);
941 
942     /**
943      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
944      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) external;
961 
962     /**
963      * @dev Transfers `tokenId` token from `from` to `to`.
964      *
965      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must be owned by `from`.
972      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
973      *
974      * Emits a {Transfer} event.
975      */
976     function transferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) external;
981 
982     /**
983      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
984      * The approval is cleared when the token is transferred.
985      *
986      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
987      *
988      * Requirements:
989      *
990      * - The caller must own the token or be an approved operator.
991      * - `tokenId` must exist.
992      *
993      * Emits an {Approval} event.
994      */
995     function approve(address to, uint256 tokenId) external;
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) external view returns (address operator);
1005 
1006     /**
1007      * @dev Approve or remove `operator` as an operator for the caller.
1008      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1009      *
1010      * Requirements:
1011      *
1012      * - The `operator` cannot be the caller.
1013      *
1014      * Emits an {ApprovalForAll} event.
1015      */
1016     function setApprovalForAll(address operator, bool _approved) external;
1017 
1018     /**
1019      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1020      *
1021      * See {setApprovalForAll}
1022      */
1023     function isApprovedForAll(address owner, address operator) external view returns (bool);
1024 
1025     /**
1026      * @dev Safely transfers `tokenId` token from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must exist and be owned by `from`.
1033      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1034      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes calldata data
1043     ) external;
1044 }
1045 
1046 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1047 
1048 
1049 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 
1054 /**
1055  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1056  * @dev See https://eips.ethereum.org/EIPS/eip-721
1057  */
1058 interface IERC721Metadata is IERC721 {
1059     /**
1060      * @dev Returns the token collection name.
1061      */
1062     function name() external view returns (string memory);
1063 
1064     /**
1065      * @dev Returns the token collection symbol.
1066      */
1067     function symbol() external view returns (string memory);
1068 
1069     /**
1070      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1071      */
1072     function tokenURI(uint256 tokenId) external view returns (string memory);
1073 }
1074 
1075 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1076 
1077 
1078 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1079 
1080 pragma solidity ^0.8.0;
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 /**
1090  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1091  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1092  * {ERC721Enumerable}.
1093  */
1094 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1095     using Address for address;
1096     using Strings for uint256;
1097 
1098     // Token name
1099     string private _name;
1100 
1101     // Token symbol
1102     string private _symbol;
1103 
1104     // Mapping from token ID to owner address
1105     mapping(uint256 => address) private _owners;
1106 
1107     // Mapping owner address to token count
1108     mapping(address => uint256) private _balances;
1109 
1110     // Mapping from token ID to approved address
1111     mapping(uint256 => address) private _tokenApprovals;
1112 
1113     // Mapping from owner to operator approvals
1114     mapping(address => mapping(address => bool)) private _operatorApprovals;
1115 
1116     /**
1117      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1118      */
1119     constructor(string memory name_, string memory symbol_) {
1120         _name = name_;
1121         _symbol = symbol_;
1122     }
1123 
1124     /**
1125      * @dev See {IERC165-supportsInterface}.
1126      */
1127     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1128         return
1129             interfaceId == type(IERC721).interfaceId ||
1130             interfaceId == type(IERC721Metadata).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-balanceOf}.
1136      */
1137     function balanceOf(address owner) public view virtual override returns (uint256) {
1138         require(owner != address(0), "ERC721: balance query for the zero address");
1139         return _balances[owner];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-ownerOf}.
1144      */
1145     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1146         address owner = _owners[tokenId];
1147         require(owner != address(0), "ERC721: owner query for nonexistent token");
1148         return owner;
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Metadata-name}.
1153      */
1154     function name() public view virtual override returns (string memory) {
1155         return _name;
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Metadata-symbol}.
1160      */
1161     function symbol() public view virtual override returns (string memory) {
1162         return _symbol;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-tokenURI}.
1167      */
1168     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1169         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1170 
1171         string memory baseURI = _baseURI();
1172         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1173     }
1174 
1175     /**
1176      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1177      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1178      * by default, can be overriden in child contracts.
1179      */
1180     function _baseURI() internal view virtual returns (string memory) {
1181         return "";
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-approve}.
1186      */
1187     function approve(address to, uint256 tokenId) public virtual override {
1188         address owner = ERC721.ownerOf(tokenId);
1189         require(to != owner, "ERC721: approval to current owner");
1190 
1191         require(
1192             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1193             "ERC721: approve caller is not owner nor approved for all"
1194         );
1195 
1196         _approve(to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-getApproved}.
1201      */
1202     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1203         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1204 
1205         return _tokenApprovals[tokenId];
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-setApprovalForAll}.
1210      */
1211     function setApprovalForAll(address operator, bool approved) public virtual override {
1212         _setApprovalForAll(_msgSender(), operator, approved);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-isApprovedForAll}.
1217      */
1218     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1219         return _operatorApprovals[owner][operator];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-transferFrom}.
1224      */
1225     function transferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public virtual override {
1230         //solhint-disable-next-line max-line-length
1231         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1232 
1233         _transfer(from, to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-safeTransferFrom}.
1238      */
1239     function safeTransferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) public virtual override {
1244         safeTransferFrom(from, to, tokenId, "");
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-safeTransferFrom}.
1249      */
1250     function safeTransferFrom(
1251         address from,
1252         address to,
1253         uint256 tokenId,
1254         bytes memory _data
1255     ) public virtual override {
1256         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1257         _safeTransfer(from, to, tokenId, _data);
1258     }
1259 
1260     /**
1261      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1262      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1263      *
1264      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1265      *
1266      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1267      * implement alternative mechanisms to perform token transfer, such as signature-based.
1268      *
1269      * Requirements:
1270      *
1271      * - `from` cannot be the zero address.
1272      * - `to` cannot be the zero address.
1273      * - `tokenId` token must exist and be owned by `from`.
1274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _safeTransfer(
1279         address from,
1280         address to,
1281         uint256 tokenId,
1282         bytes memory _data
1283     ) internal virtual {
1284         _transfer(from, to, tokenId);
1285         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1286     }
1287 
1288     /**
1289      * @dev Returns whether `tokenId` exists.
1290      *
1291      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1292      *
1293      * Tokens start existing when they are minted (`_mint`),
1294      * and stop existing when they are burned (`_burn`).
1295      */
1296     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1297         return _owners[tokenId] != address(0);
1298     }
1299 
1300     /**
1301      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must exist.
1306      */
1307     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1308         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1309         address owner = ERC721.ownerOf(tokenId);
1310         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1311     }
1312 
1313     /**
1314      * @dev Safely mints `tokenId` and transfers it to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - `tokenId` must not exist.
1319      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _safeMint(address to, uint256 tokenId) internal virtual {
1324         _safeMint(to, tokenId, "");
1325     }
1326 
1327     /**
1328      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1329      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1330      */
1331     function _safeMint(
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) internal virtual {
1336         _mint(to, tokenId);
1337         require(
1338             _checkOnERC721Received(address(0), to, tokenId, _data),
1339             "ERC721: transfer to non ERC721Receiver implementer"
1340         );
1341     }
1342 
1343     /**
1344      * @dev Mints `tokenId` and transfers it to `to`.
1345      *
1346      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must not exist.
1351      * - `to` cannot be the zero address.
1352      *
1353      * Emits a {Transfer} event.
1354      */
1355     function _mint(address to, uint256 tokenId) internal virtual {
1356         require(to != address(0), "ERC721: mint to the zero address");
1357         require(!_exists(tokenId), "ERC721: token already minted");
1358 
1359         _beforeTokenTransfer(address(0), to, tokenId);
1360 
1361         _balances[to] += 1;
1362         _owners[tokenId] = to;
1363 
1364         emit Transfer(address(0), to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev Destroys `tokenId`.
1369      * The approval is cleared when the token is burned.
1370      *
1371      * Requirements:
1372      *
1373      * - `tokenId` must exist.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function _burn(uint256 tokenId) internal virtual {
1378         address owner = ERC721.ownerOf(tokenId);
1379 
1380         _beforeTokenTransfer(owner, address(0), tokenId);
1381 
1382         // Clear approvals
1383         _approve(address(0), tokenId);
1384 
1385         _balances[owner] -= 1;
1386         delete _owners[tokenId];
1387 
1388         emit Transfer(owner, address(0), tokenId);
1389     }
1390 
1391     /**
1392      * @dev Transfers `tokenId` from `from` to `to`.
1393      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1394      *
1395      * Requirements:
1396      *
1397      * - `to` cannot be the zero address.
1398      * - `tokenId` token must be owned by `from`.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function _transfer(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) internal virtual {
1407         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1408         require(to != address(0), "ERC721: transfer to the zero address");
1409 
1410         _beforeTokenTransfer(from, to, tokenId);
1411 
1412         // Clear approvals from the previous owner
1413         _approve(address(0), tokenId);
1414 
1415         _balances[from] -= 1;
1416         _balances[to] += 1;
1417         _owners[tokenId] = to;
1418 
1419         emit Transfer(from, to, tokenId);
1420     }
1421 
1422     /**
1423      * @dev Approve `to` to operate on `tokenId`
1424      *
1425      * Emits a {Approval} event.
1426      */
1427     function _approve(address to, uint256 tokenId) internal virtual {
1428         _tokenApprovals[tokenId] = to;
1429         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1430     }
1431 
1432     /**
1433      * @dev Approve `operator` to operate on all of `owner` tokens
1434      *
1435      * Emits a {ApprovalForAll} event.
1436      */
1437     function _setApprovalForAll(
1438         address owner,
1439         address operator,
1440         bool approved
1441     ) internal virtual {
1442         require(owner != operator, "ERC721: approve to caller");
1443         _operatorApprovals[owner][operator] = approved;
1444         emit ApprovalForAll(owner, operator, approved);
1445     }
1446 
1447     /**
1448      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1449      * The call is not executed if the target address is not a contract.
1450      *
1451      * @param from address representing the previous owner of the given token ID
1452      * @param to target address that will receive the tokens
1453      * @param tokenId uint256 ID of the token to be transferred
1454      * @param _data bytes optional data to send along with the call
1455      * @return bool whether the call correctly returned the expected magic value
1456      */
1457     function _checkOnERC721Received(
1458         address from,
1459         address to,
1460         uint256 tokenId,
1461         bytes memory _data
1462     ) private returns (bool) {
1463         if (to.isContract()) {
1464             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1465                 return retval == IERC721Receiver.onERC721Received.selector;
1466             } catch (bytes memory reason) {
1467                 if (reason.length == 0) {
1468                     revert("ERC721: transfer to non ERC721Receiver implementer");
1469                 } else {
1470                     assembly {
1471                         revert(add(32, reason), mload(reason))
1472                     }
1473                 }
1474             }
1475         } else {
1476             return true;
1477         }
1478     }
1479 
1480     /**
1481      * @dev Hook that is called before any token transfer. This includes minting
1482      * and burning.
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` will be minted for `to`.
1489      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1490      * - `from` and `to` are never both zero.
1491      *
1492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1493      */
1494     function _beforeTokenTransfer(
1495         address from,
1496         address to,
1497         uint256 tokenId
1498     ) internal virtual {}
1499 }
1500 
1501 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1502 
1503 
1504 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1505 
1506 pragma solidity ^0.8.0;
1507 
1508 
1509 /**
1510  * @dev ERC721 token with storage based token URI management.
1511  */
1512 abstract contract ERC721URIStorage is ERC721 {
1513     using Strings for uint256;
1514 
1515     // Optional mapping for token URIs
1516     mapping(uint256 => string) private _tokenURIs;
1517 
1518     /**
1519      * @dev See {IERC721Metadata-tokenURI}.
1520      */
1521     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1522         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1523 
1524         string memory _tokenURI = _tokenURIs[tokenId];
1525         string memory base = _baseURI();
1526 
1527         // If there is no base URI, return the token URI.
1528         if (bytes(base).length == 0) {
1529             return _tokenURI;
1530         }
1531         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1532         if (bytes(_tokenURI).length > 0) {
1533             return string(abi.encodePacked(base, _tokenURI));
1534         }
1535 
1536         return super.tokenURI(tokenId);
1537     }
1538 
1539     /**
1540      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1541      *
1542      * Requirements:
1543      *
1544      * - `tokenId` must exist.
1545      */
1546     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1547         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1548         _tokenURIs[tokenId] = _tokenURI;
1549     }
1550 
1551     /**
1552      * @dev Destroys `tokenId`.
1553      * The approval is cleared when the token is burned.
1554      *
1555      * Requirements:
1556      *
1557      * - `tokenId` must exist.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _burn(uint256 tokenId) internal virtual override {
1562         super._burn(tokenId);
1563 
1564         if (bytes(_tokenURIs[tokenId]).length != 0) {
1565             delete _tokenURIs[tokenId];
1566         }
1567     }
1568 }
1569 
1570 // File: contracts/Inferno.sol
1571 
1572 
1573 pragma solidity ^0.8.0;
1574 
1575 
1576 
1577 
1578 
1579 
1580 
1581 contract Inferno is ERC721, ERC721URIStorage, Pausable, AccessControl, Ownable {
1582     using Counters for Counters.Counter;
1583 
1584     struct Supply {
1585         uint256 aqu;
1586         uint256 ari;
1587         uint256 can;
1588         uint256 cap;
1589         uint256 gem;
1590         uint256 leo;
1591         uint256 lib;
1592         uint256 pis;
1593         uint256 sag;
1594         uint256 sco;
1595         uint256 tau;
1596         uint256 vir;
1597     }
1598 
1599     struct ZodiacSign {
1600         string uri;
1601         Counters.Counter counter;
1602         bool exists;
1603     }
1604 
1605     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1606     string private currentPhase = "six";
1607     Counters.Counter private _tokenCounter;
1608 
1609     mapping(string => ZodiacSign) private zodiacSigns;
1610     mapping(uint256 => string) private _tokenZodiac;
1611 
1612     mapping(address => bool) private _sixes_minted;
1613     mapping(address => bool) private _sevens_minted;
1614 
1615     uint256 private _public_price = 150000000000000000; // 0.15 Ether
1616     uint256 private _wl_price = 100000000000000000;     // 0.10 Ether  
1617     uint256 private _maxSupply = 12000;
1618     uint256 private _maxZodiacSupply = 1000;
1619 
1620     uint256 private _phaseMaxSupply = 666;
1621     uint256 private _initialPhaseCount = 0;
1622 
1623     bool private _isSalePublic = false;
1624 
1625     string private base_uri = "";
1626     string curi = "";
1627 
1628     bool initialized = false;
1629     address dantes_castodial = 0x4d87EbD494E3f266Edd17f5e88E374473FB19DCF;
1630 
1631     constructor() ERC721("Inferno Genesis Keys", "INFERNO") {
1632         _pause();
1633 
1634         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1635         _grantRole(PAUSER_ROLE, msg.sender);
1636 
1637         zodiacSigns["aqu"] = ZodiacSign("Aquarius",   Counters.Counter(0), true);
1638         zodiacSigns["ari"] = ZodiacSign("Aries",      Counters.Counter(0), true);
1639         zodiacSigns["can"] = ZodiacSign("Cancer",     Counters.Counter(0), true);
1640         zodiacSigns["cap"] = ZodiacSign("Capricorn",  Counters.Counter(0), true);
1641         zodiacSigns["gem"] = ZodiacSign("Gemini",     Counters.Counter(0), true);
1642         zodiacSigns["leo"] = ZodiacSign("Leo",        Counters.Counter(0), true);
1643         zodiacSigns["lib"] = ZodiacSign("Libra",      Counters.Counter(0), true);
1644         zodiacSigns["pis"] = ZodiacSign("Pisces",     Counters.Counter(0), true);
1645         zodiacSigns["sag"] = ZodiacSign("Sagittarius", Counters.Counter(0), true);
1646         zodiacSigns["sco"] = ZodiacSign("Scorpio",    Counters.Counter(0), true);
1647         zodiacSigns["tau"] = ZodiacSign("Taurus",     Counters.Counter(0), true);
1648         zodiacSigns["vir"] = ZodiacSign("Virgo",      Counters.Counter(0), true);
1649 
1650         initializeMint();
1651     }
1652 
1653     function mintKeyWhitelist(address to, string calldata sign, string calldata phase, uint8 _v, bytes32 _r, bytes32 _s) public payable onlyValidAccess( phase, _v, _r, _s) {
1654         if(paused()) {
1655             revert(
1656                 string(
1657                     abi.encodePacked(
1658                         "Sales not active"
1659                     )
1660                 )
1661             );
1662         }
1663 
1664         if(_tokenCounter.current() + 1 > _initialPhaseCount + _phaseMaxSupply) {
1665             revert(
1666                 string(
1667                     abi.encodePacked(
1668                         "Current phase has minted out."
1669                     )
1670                 )
1671             );
1672         }
1673 
1674         if(_wl_price != msg.value) {
1675             revert(
1676                 string(
1677                     abi.encodePacked(
1678                         "Invalid Quantity"
1679                     )
1680                 )
1681             );
1682         }
1683 
1684         if(keccak256(abi.encodePacked(currentPhase)) != keccak256(abi.encodePacked(phase))) {
1685             revert(
1686                 string(
1687                     abi.encodePacked(
1688                         "Invalid Phase"
1689                     )
1690                 )
1691             );
1692         }
1693 
1694         if(keccak256(abi.encodePacked(currentPhase)) == keccak256(abi.encodePacked("six"))) {
1695             if(_sixes_minted[msg.sender]) {
1696                 revert(
1697                     string(
1698                         abi.encodePacked(
1699                             "Mint limit reached"
1700                         )
1701                     )
1702                 );
1703             } else {
1704                 _sixes_minted[msg.sender] = true;
1705             }
1706         }
1707 
1708         if(keccak256(abi.encodePacked(currentPhase)) == keccak256(abi.encodePacked("seven"))) {
1709             if(_sevens_minted[msg.sender]) {
1710                 revert(
1711                     string(
1712                         abi.encodePacked(
1713                             "Mint limit reached"
1714                         )
1715                     )
1716                 );
1717             } else {
1718                 _sevens_minted[msg.sender] = true;
1719             }
1720         }
1721 
1722         mintKey(to, sign);
1723     }
1724 
1725     function mintKeyPublic(address to, string calldata sign) public payable {
1726         if(paused()) {
1727             revert(
1728                 string(
1729                     abi.encodePacked(
1730                         "Sales not active"
1731                     )
1732                 )
1733             );
1734         }
1735 
1736         if(_phaseMaxSupply > 0 && _tokenCounter.current() + 1 > _initialPhaseCount + _phaseMaxSupply) {
1737             revert(
1738                 string(
1739                     abi.encodePacked(
1740                         "Current phase has minted out."
1741                     )
1742                 )
1743             );
1744         }
1745 
1746         if(!_isSalePublic) {
1747             revert(
1748                 string(
1749                     abi.encodePacked(
1750                         "Public sale not active"
1751                     )
1752                 )
1753             );
1754         }
1755 
1756         if(_public_price != msg.value) {
1757             revert(
1758                 string(
1759                     abi.encodePacked(
1760                         "Invalid Quantity"
1761                     )
1762                 )
1763             );
1764         }
1765 
1766         mintKey(to, sign);
1767     }
1768 
1769     function mintKey(address to, string calldata sign) internal {
1770         uint256 tokenId = _tokenCounter.current() + 1;
1771 
1772         if(tokenId >= _maxSupply) {
1773             revert(
1774                 string(
1775                     abi.encodePacked(
1776                         "No more tokens"
1777                     )
1778                 )
1779             );
1780         }
1781         _tokenCounter.increment();
1782         
1783         // if(_minted[msg.sender]) {
1784         //     revert(
1785         //         string(
1786         //             abi.encodePacked(
1787         //                 "Mint limit reached"
1788         //             )
1789         //         )
1790         //     );
1791         // } else {
1792         //     _minted[msg.sender] = true;
1793         // }
1794 
1795         string memory uri;
1796 
1797         if(zodiacSigns[sign].exists) {
1798             if(zodiacSigns[sign].counter.current() >= _maxZodiacSupply) {
1799                 revert(
1800                     string(
1801                         abi.encodePacked(
1802                             "No more ",
1803                             zodiacSigns[sign].uri,
1804                             " tokens"
1805                         )
1806                     )
1807                 );
1808             }
1809             uri = string(
1810                 abi.encodePacked(
1811                     zodiacSigns[sign].uri,
1812                     "/",
1813                     Strings.toString(tokenId)
1814                 )
1815             );
1816             zodiacSigns[sign].counter.increment();
1817             _tokenZodiac[tokenId] = zodiacSigns[sign].uri;
1818         } else {
1819             revert(
1820                 string(
1821                     abi.encodePacked(
1822                         "Invalid Zodiac Sign"
1823                     )
1824                 )
1825             );
1826         }
1827         
1828         // mint current + 1 e.g 0 + 1
1829         _safeMint(to, tokenId);
1830         _setTokenURI(tokenId, uri);
1831     }
1832 
1833     function _baseURI() internal view override returns (string memory) {
1834         return base_uri;
1835     }
1836 
1837     function setBaseUri(string calldata uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
1838         base_uri = uri;
1839     }
1840 
1841     function pause() public onlyRole(PAUSER_ROLE) {
1842         _pause();
1843     }
1844 
1845     function unpause() public onlyRole(PAUSER_ROLE) {
1846         _unpause();
1847     }
1848     
1849     function enablePublic() public onlyRole(PAUSER_ROLE) {
1850         _isSalePublic = true;
1851     }
1852     
1853     function disablePublic() public onlyRole(PAUSER_ROLE) {
1854         _isSalePublic = false;
1855     }
1856 
1857     function setPrice(uint256 wl_price, uint256 public_price) public onlyRole(PAUSER_ROLE) {
1858         _public_price = public_price;
1859         _wl_price = wl_price;
1860     }
1861 
1862     // phase: 'six', 'seven', or 'general'
1863     // updateSupply: true for first use of setPhase when switching to phase 'six' or 'seven' part 1. On part 2 of phases 'six' or 'seven' updateSupply = false
1864     function setPhase(bool updateSupply, uint256 phaseSupply, string memory phase) public onlyRole(PAUSER_ROLE) {
1865         currentPhase = phase;
1866 
1867         if(updateSupply) {
1868             _phaseMaxSupply = phaseSupply; // Takes current minted count and adds new phase's supply giving max index # of current phase.
1869             _initialPhaseCount = _tokenCounter.current();
1870             if(phaseSupply == 0) {
1871                 _isSalePublic = true;
1872             } else {
1873                 _isSalePublic = false;
1874             }
1875         }
1876     }
1877 
1878     // whenNotPaused
1879     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1880         internal
1881         override
1882     {
1883         if(initialized) require(!paused(), "ERC721Pausable: token transfer while paused");
1884         super._beforeTokenTransfer(from, to, tokenId);
1885     }
1886 
1887     function getCurrentPhase() public view returns(string memory) {
1888         return currentPhase;
1889     }
1890 
1891     function isSalePublic() public view returns(bool) {
1892         return _isSalePublic;
1893     }
1894     
1895     function price() public view returns(uint256) {
1896         if(_isSalePublic) {
1897             return _public_price;
1898         } else {
1899             return _wl_price;
1900         }
1901     }
1902 
1903     function maxSupply() public view returns(uint256) {
1904         return _maxSupply;
1905     }
1906 
1907     function maxPhaseSupply() public view returns(uint256) {
1908         return _phaseMaxSupply;
1909     }
1910 
1911     function maxZodiacSupply() public view returns(uint256) {
1912         return _maxZodiacSupply;
1913     }
1914 
1915     function totalSupply() public view returns(uint256) {
1916         return _tokenCounter.current();
1917     }
1918 
1919     function totalPhaseSupply() public view returns(uint256) {
1920         return _tokenCounter.current() - _initialPhaseCount;
1921     }
1922 
1923     function totalZodiacSupply() public view returns(Supply memory) {
1924         return Supply (
1925             zodiacSigns["aqu"].counter.current(),
1926             zodiacSigns["ari"].counter.current(),
1927             zodiacSigns["can"].counter.current(),
1928             zodiacSigns["cap"].counter.current(),
1929             zodiacSigns["gem"].counter.current(),
1930             zodiacSigns["leo"].counter.current(),
1931             zodiacSigns["lib"].counter.current(),
1932             zodiacSigns["pis"].counter.current(),
1933             zodiacSigns["sag"].counter.current(),
1934             zodiacSigns["sco"].counter.current(),
1935             zodiacSigns["tau"].counter.current(),
1936             zodiacSigns["vir"].counter.current()
1937         );
1938     }
1939     // The following functions are overrides required by Solidity.
1940 
1941     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1942         super._burn(tokenId);
1943     }
1944 
1945     // function baseURI() view returns (string memory) {
1946     //     return base_uri;
1947     // }
1948 
1949     function tokenZodiac(uint256 tokenId) public view returns(string memory) {
1950         return _tokenZodiac[tokenId];
1951     }
1952 
1953     function tokenURI(uint256 tokenId)
1954         public
1955         view
1956         override(ERC721, ERC721URIStorage)
1957         returns (string memory)
1958     {
1959         return super.tokenURI(tokenId);
1960         // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1961 
1962         // string memory baseURI = _baseURI();
1963         // return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
1964     }
1965 
1966     function initializeMint() internal onlyOwner {
1967         require(!initialized, "Already initialized");
1968         preMint(owner, "aqu");
1969         preMint(owner, "ari");
1970         preMint(owner, "can");
1971         preMint(owner, "cap");
1972         preMint(owner, "gem");
1973         preMint(owner, "leo");
1974         preMint(owner, "lib");
1975         preMint(owner, "pis");
1976         preMint(owner, "sag");
1977         preMint(owner, "sco");
1978         preMint(owner, "tau");
1979         preMint(owner, "vir");
1980         _initialPhaseCount = 12;
1981         initialized = true;
1982     }
1983 
1984     function preMint(address to, string memory sign) internal {
1985         uint256 tokenId = _tokenCounter.current() + 1;
1986         string memory uri;
1987 
1988         if(zodiacSigns[sign].exists) {
1989             uri = string(
1990                 abi.encodePacked(
1991                     "Honorary_",
1992                     zodiacSigns[sign].uri,
1993                     "/",
1994                     Strings.toString(tokenId)
1995                 )
1996             );
1997             zodiacSigns[sign].counter.increment();
1998             _tokenZodiac[tokenId] = zodiacSigns[sign].uri;
1999         } else {
2000             revert(
2001                 string(
2002                     abi.encodePacked(
2003                         "Invalid Zodiac Sign"
2004                     )
2005                 )
2006             );
2007         }
2008         _tokenCounter.increment();
2009         _mint(to, tokenId);
2010         _setTokenURI(tokenId, uri);
2011     }
2012 
2013     function supportsInterface(bytes4 interfaceId)
2014         public
2015         view
2016         override(ERC721, AccessControl)
2017         returns (bool)
2018     {
2019         return super.supportsInterface(interfaceId);
2020     }
2021 
2022     modifier onlyValidAccess(string calldata phase, uint8 _v, bytes32 _r, bytes32 _s) 
2023     {
2024         require( isValidAccessMessage(msg.sender, phase, _v, _r, _s), "Not whitelisted");
2025         _;
2026     }
2027 
2028     function isValidAccessMessage(
2029         address _add,
2030         string calldata _pha,
2031         uint8 _v,
2032         bytes32 _r,
2033         bytes32 _s)
2034         view public returns (bool)
2035     {
2036         bytes32 hash = keccak256(
2037             abi.encodePacked(
2038                 this, 
2039                 _add,
2040                 keccak256(abi.encodePacked(_pha))
2041             )
2042         );
2043 
2044         address recoverd = ecrecover(
2045             keccak256(
2046                 abi.encodePacked(
2047                     "\x19Ethereum Signed Message:\n32",
2048                     hash
2049                 )
2050             ),
2051             _v,
2052             _r,
2053             _s
2054         );
2055         return owner == recoverd;
2056     }
2057 
2058     function withdrawAll() public onlyOwner {
2059         (bool success,) = dantes_castodial.call{value: address(this).balance}("");
2060         require (success, "Transfer failed.");
2061     }
2062 
2063     function setContractURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
2064         curi = newuri;
2065     }
2066 
2067     function contractURI() public view returns (string memory) {
2068         return curi;
2069     }
2070 }