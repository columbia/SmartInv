1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // This method relies on extcodesize, which returns 0 for contracts in
50         // construction, since the code is only stored at the end of the
51         // constructor execution.
52 
53         uint256 size;
54         assembly {
55             size := extcodesize(account)
56         }
57         return size > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62      * `recipient`, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by `transfer`, making them unable to receive funds via
67      * `transfer`. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to `recipient`, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level `call`. A
85      * plain `call` is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If `target` reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
93      *
94      * Requirements:
95      *
96      * - `target` must be a contract.
97      * - calling `target` with `data` must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
107      * `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 
241 
242 /**
243  * @dev Provides information about the current execution context, including the
244  * sender of the transaction and its data. While these are generally available
245  * via msg.sender and msg.data, they should not be accessed in such a direct
246  * manner, since when dealing with meta-transactions the account sending and
247  * paying for execution may not be the actual sender (as far as an application
248  * is concerned).
249  *
250  * This contract is only required for intermediate, library-like contracts.
251  */
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes calldata) {
258         return msg.data;
259     }
260 }
261 
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
271      */
272     function toString(uint256 value) internal pure returns (string memory) {
273         // Inspired by OraclizeAPI's implementation - MIT licence
274         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
275 
276         if (value == 0) {
277             return "0";
278         }
279         uint256 temp = value;
280         uint256 digits;
281         while (temp != 0) {
282             digits++;
283             temp /= 10;
284         }
285         bytes memory buffer = new bytes(digits);
286         while (value != 0) {
287             digits -= 1;
288             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
289             value /= 10;
290         }
291         return string(buffer);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
296      */
297     function toHexString(uint256 value) internal pure returns (string memory) {
298         if (value == 0) {
299             return "0x00";
300         }
301         uint256 temp = value;
302         uint256 length = 0;
303         while (temp != 0) {
304             length++;
305             temp >>= 8;
306         }
307         return toHexString(value, length);
308     }
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
312      */
313     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
314         bytes memory buffer = new bytes(2 * length + 2);
315         buffer[0] = "0";
316         buffer[1] = "x";
317         for (uint256 i = 2 * length + 1; i > 1; --i) {
318             buffer[i] = _HEX_SYMBOLS[value & 0xf];
319             value >>= 4;
320         }
321         require(value == 0, "Strings: hex length insufficient");
322         return string(buffer);
323     }
324 }
325 
326 
327 
328 
329 /**
330  * @dev Implementation of the {IERC165} interface.
331  *
332  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
333  * for the additional interface id that will be supported. For example:
334  *
335  * ```solidity
336  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
337  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
338  * }
339  * ```
340  *
341  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
342  */
343 abstract contract ERC165 is IERC165 {
344     /**
345      * @dev See {IERC165-supportsInterface}.
346      */
347     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
348         return interfaceId == type(IERC165).interfaceId;
349     }
350 }
351 
352 
353 
354 
355 /**
356  * @title Counters
357  * @author Matt Condon (@shrugs)
358  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
359  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
360  *
361  * Include with `using Counters for Counters.Counter;`
362  */
363 library Counters {
364     struct Counter {
365         // This variable should never be directly accessed by users of the library: interactions must be restricted to
366         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
367         // this feature: see https://github.com/ethereum/solidity/issues/4637
368         uint256 _value; // default: 0
369     }
370 
371     function current(Counter storage counter) internal view returns (uint256) {
372         return counter._value;
373     }
374 
375     function increment(Counter storage counter) internal {
376         //unchecked {
377             counter._value += 1;
378         //}
379     }
380 
381     function decrement(Counter storage counter) internal {
382         uint256 value = counter._value;
383         require(value > 0, "Counter: decrement overflow");
384         //unchecked {
385             counter._value = value - 1;
386         //}
387     }
388 
389     function reset(Counter storage counter) internal {
390         counter._value = 0;
391     }
392 }
393 
394 
395 /**
396  * @dev External interface of AccessControl declared to support ERC165 detection.
397  */
398 interface IAccessControl {
399     /**
400      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
401      *
402      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
403      * {RoleAdminChanged} not being emitted signaling this.
404      *
405      * _Available since v3.1._
406      */
407     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
408 
409     /**
410      * @dev Emitted when `account` is granted `role`.
411      *
412      * `sender` is the account that originated the contract call, an admin role
413      * bearer except when using {AccessControl-_setupRole}.
414      */
415     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
416 
417     /**
418      * @dev Emitted when `account` is revoked `role`.
419      *
420      * `sender` is the account that originated the contract call:
421      *   - if using `revokeRole`, it is the admin role bearer
422      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
423      */
424     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
425 
426     /**
427      * @dev Returns `true` if `account` has been granted `role`.
428      */
429     function hasRole(bytes32 role, address account) external view returns (bool);
430 
431     /**
432      * @dev Returns the admin role that controls `role`. See {grantRole} and
433      * {revokeRole}.
434      *
435      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
436      */
437     function getRoleAdmin(bytes32 role) external view returns (bytes32);
438 
439     /**
440      * @dev Grants `role` to `account`.
441      *
442      * If `account` had not been already granted `role`, emits a {RoleGranted}
443      * event.
444      *
445      * Requirements:
446      *
447      * - the caller must have ``role``'s admin role.
448      */
449     function grantRole(bytes32 role, address account) external;
450 
451     /**
452      * @dev Revokes `role` from `account`.
453      *
454      * If `account` had been granted `role`, emits a {RoleRevoked} event.
455      *
456      * Requirements:
457      *
458      * - the caller must have ``role``'s admin role.
459      */
460     function revokeRole(bytes32 role, address account) external;
461 
462     /**
463      * @dev Revokes `role` from the calling account.
464      *
465      * Roles are often managed via {grantRole} and {revokeRole}: this function's
466      * purpose is to provide a mechanism for accounts to lose their privileges
467      * if they are compromised (such as when a trusted device is misplaced).
468      *
469      * If the calling account had been granted `role`, emits a {RoleRevoked}
470      * event.
471      *
472      * Requirements:
473      *
474      * - the caller must be `account`.
475      */
476     function renounceRole(bytes32 role, address account) external;
477 }
478 
479 
480 
481 
482 
483 /**
484  * @dev Contract module that allows children to implement role-based access
485  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
486  * members except through off-chain means by accessing the contract event logs. Some
487  * applications may benefit from on-chain enumerability, for those cases see
488  * {AccessControlEnumerable}.
489  *
490  * Roles are referred to by their `bytes32` identifier. These should be exposed
491  * in the external API and be unique. The best way to achieve this is by
492  * using `public constant` hash digests:
493  *
494  * ```
495  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
496  * ```
497  *
498  * Roles can be used to represent a set of permissions. To restrict access to a
499  * function call, use {hasRole}:
500  *
501  * ```
502  * function foo() public {
503  *     require(hasRole(MY_ROLE, msg.sender));
504  *     ...
505  * }
506  * ```
507  *
508  * Roles can be granted and revoked dynamically via the {grantRole} and
509  * {revokeRole} functions. Each role has an associated admin role, and only
510  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
511  *
512  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
513  * that only accounts with this role will be able to grant or revoke other
514  * roles. More complex role relationships can be created by using
515  * {_setRoleAdmin}.
516  *
517  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
518  * grant and revoke this role. Extra precautions should be taken to secure
519  * accounts that have been granted it.
520  */
521 abstract contract AccessControl is Context, IAccessControl, ERC165 {
522     struct RoleData {
523         mapping(address => bool) members;
524         bytes32 adminRole;
525     }
526 
527     mapping(bytes32 => RoleData) private _roles;
528 
529     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
530 
531     /**
532      * @dev Modifier that checks that an account has a specific role. Reverts
533      * with a standardized message including the required role.
534      *
535      * The format of the revert reason is given by the following regular expression:
536      *
537      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
538      *
539      * _Available since v4.1._
540      */
541     modifier onlyRole(bytes32 role) {
542         _checkRole(role, _msgSender());
543         _;
544     }
545 
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
551     }
552 
553     /**
554      * @dev Returns `true` if `account` has been granted `role`.
555      */
556     function hasRole(bytes32 role, address account) public view override returns (bool) {
557         return _roles[role].members[account];
558     }
559 
560     /**
561      * @dev Revert with a standard message if `account` is missing `role`.
562      *
563      * The format of the revert reason is given by the following regular expression:
564      *
565      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
566      */
567     function _checkRole(bytes32 role, address account) internal view {
568         if (!hasRole(role, account)) {
569             revert(
570                 string(
571                     abi.encodePacked(
572                         "AccessControl: account ",
573                         Strings.toHexString(uint160(account), 20),
574                         " is missing role ",
575                         Strings.toHexString(uint256(role), 32)
576                     )
577                 )
578             );
579         }
580     }
581 
582     /**
583      * @dev Returns the admin role that controls `role`. See {grantRole} and
584      * {revokeRole}.
585      *
586      * To change a role's admin, use {_setRoleAdmin}.
587      */
588     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
589         return _roles[role].adminRole;
590     }
591 
592     /**
593      * @dev Grants `role` to `account`.
594      *
595      * If `account` had not been already granted `role`, emits a {RoleGranted}
596      * event.
597      *
598      * Requirements:
599      *
600      * - the caller must have ``role``'s admin role.
601      */
602     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
603         _grantRole(role, account);
604     }
605 
606     /**
607      * @dev Revokes `role` from `account`.
608      *
609      * If `account` had been granted `role`, emits a {RoleRevoked} event.
610      *
611      * Requirements:
612      *
613      * - the caller must have ``role``'s admin role.
614      */
615     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
616         _revokeRole(role, account);
617     }
618 
619     /**
620      * @dev Revokes `role` from the calling account.
621      *
622      * Roles are often managed via {grantRole} and {revokeRole}: this function's
623      * purpose is to provide a mechanism for accounts to lose their privileges
624      * if they are compromised (such as when a trusted device is misplaced).
625      *
626      * If the calling account had been granted `role`, emits a {RoleRevoked}
627      * event.
628      *
629      * Requirements:
630      *
631      * - the caller must be `account`.
632      */
633     function renounceRole(bytes32 role, address account) public virtual override {
634         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
635 
636         _revokeRole(role, account);
637     }
638 
639     /**
640      * @dev Grants `role` to `account`.
641      *
642      * If `account` had not been already granted `role`, emits a {RoleGranted}
643      * event. Note that unlike {grantRole}, this function doesn't perform any
644      * checks on the calling account.
645      *
646      * [WARNING]
647      * ====
648      * This function should only be called from the constructor when setting
649      * up the initial roles for the system.
650      *
651      * Using this function in any other way is effectively circumventing the admin
652      * system imposed by {AccessControl}.
653      * ====
654      */
655     function _setupRole(bytes32 role, address account) internal virtual {
656         _grantRole(role, account);
657     }
658 
659     /**
660      * @dev Sets `adminRole` as ``role``'s admin role.
661      *
662      * Emits a {RoleAdminChanged} event.
663      */
664     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
665         bytes32 previousAdminRole = getRoleAdmin(role);
666         _roles[role].adminRole = adminRole;
667         emit RoleAdminChanged(role, previousAdminRole, adminRole);
668     }
669 
670     function _grantRole(bytes32 role, address account) private {
671         if (!hasRole(role, account)) {
672             _roles[role].members[account] = true;
673             emit RoleGranted(role, account, _msgSender());
674         }
675     }
676 
677     function _revokeRole(bytes32 role, address account) private {
678         if (hasRole(role, account)) {
679             _roles[role].members[account] = false;
680             emit RoleRevoked(role, account, _msgSender());
681         }
682     }
683 }
684 
685 interface PlutoI {
686     function mint(address _mintTo, string memory _tokenURI ) external returns (uint256);
687     function getCurrentTokenId() external view returns (uint256);    
688 }
689 
690 interface ERC20Token {
691     function balanceOf(address account) external view returns (uint256);
692 }
693 
694 contract PlutoDistributor is AccessControl {
695     
696     PlutoI plutoToken;
697 
698     ERC20Token cggToken;
699     ERC20Token bittToken;
700     
701     bytes32 public constant TOGGLE_MINTING_ROLE = keccak256("TOGGLE_MINTING_ROLE");
702 
703     uint256 tokenPrice = uint256(9 * 10**16); // = 0.09 eth
704     string defaultTokenURI = "https://bitverse.chainguardians.io/api/opensea/";
705     address withdrawWallet;
706     bool onlyMintingByTokenHoldersAllowed;
707 
708     constructor(
709         PlutoI _plutoToken,
710         ERC20Token _cggToken,
711         ERC20Token _bittToken
712     ) {
713         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
714         _setupRole(TOGGLE_MINTING_ROLE, msg.sender);
715 
716         plutoToken = _plutoToken;
717         withdrawWallet = msg.sender;
718         onlyMintingByTokenHoldersAllowed = true;
719 
720         cggToken = _cggToken;
721         bittToken = _bittToken;
722 
723     }
724 
725     function mint(uint256 num) public payable returns (uint256) {
726 
727         require(num <= 20, "You can mint a maximum of 20");
728         require(msg.value >= tokenPrice * num, "Insufficient amount provided");
729 
730         uint256 cggBalance = cggToken.balanceOf(msg.sender);
731         uint256 bittBalance = bittToken.balanceOf(msg.sender);
732         require(
733             !onlyMintingByTokenHoldersAllowed ||
734                 (onlyMintingByTokenHoldersAllowed &&
735                     ((cggBalance >= 100000000000000000000) ||
736                         (bittBalance >= 1000000000000000000000))),
737             "Insufficient CGG or BITT balance"
738         );
739 
740         uint256 tokenId = plutoToken.getCurrentTokenId();
741         require(tokenId + num <= 10000, "Maximum cap of 10000 mints reached");
742 
743         uint256 lastTokenMinted = 0;
744         for(uint256 i; i < num; i++){
745              lastTokenMinted = plutoToken.mint(
746                 msg.sender,
747                 string(abi.encodePacked(defaultTokenURI, uint2str(tokenId + i +1)))
748             );
749         }
750 
751         return lastTokenMinted;
752 
753     }
754 
755     fallback() external payable {}
756     receive() external payable {}
757 
758 
759     // admin functions
760     function withdrawAll() public {
761         uint256 _each = address(this).balance;
762         require(payable(withdrawWallet).send(_each));
763     }
764 
765     function updateWithdrawWallet(address _newWallet) public {
766         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
767 
768         withdrawWallet = _newWallet;
769     }
770 
771     function updateDefaultTokenUri(string memory _newDefaultTokenUri) public {
772         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
773 
774         defaultTokenURI = _newDefaultTokenUri;
775     }
776 
777     function updatePrice(uint256 _newPrice) public {
778         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
779 
780         tokenPrice = _newPrice;
781     }
782 
783     function toggleOnlyMintingByTokenHolders(bool _isRestricted) public {
784         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(TOGGLE_MINTING_ROLE, msg.sender), "Caller is not toggler or admin");
785 
786         onlyMintingByTokenHoldersAllowed = _isRestricted;
787     }
788 
789 
790 
791     //helpers
792     function uint2str(uint256 _i) internal pure returns (string memory str) {
793         if (_i == 0) {
794             return "0";
795         }
796         uint256 j = _i;
797         uint256 length;
798         while (j != 0) {
799             length++;
800             j /= 10;
801         }
802         bytes memory bstr = new bytes(length);
803         uint256 k = length;
804         j = _i;
805         while (j != 0) {
806             bstr[--k] = bytes1(uint8(48 + (j % 10)));
807             j /= 10;
808         }
809         str = string(bstr);
810     }
811 
812     function getSettings()
813         public
814         view
815         returns (
816             string memory _defaultTokenUri,
817             uint256 _price,
818             address _withdrawWallet
819         )
820     {
821         return (defaultTokenURI, tokenPrice, withdrawWallet);
822     }
823 
824 }