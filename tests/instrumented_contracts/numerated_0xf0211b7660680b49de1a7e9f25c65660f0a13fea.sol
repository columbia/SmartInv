1 // SPDX-License-Identifier: MIT AND GPL-3.0
2 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/access/IAccessControl.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev External interface of AccessControl declared to support ERC165 detection.
9  */
10 interface IAccessControl {
11     /**
12      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
13      *
14      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
15      * {RoleAdminChanged} not being emitted signaling this.
16      *
17      * _Available since v3.1._
18      */
19     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
20 
21     /**
22      * @dev Emitted when `account` is granted `role`.
23      *
24      * `sender` is the account that originated the contract call, an admin role
25      * bearer except when using {AccessControl-_setupRole}.
26      */
27     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
28 
29     /**
30      * @dev Emitted when `account` is revoked `role`.
31      *
32      * `sender` is the account that originated the contract call:
33      *   - if using `revokeRole`, it is the admin role bearer
34      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
35      */
36     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
37 
38     /**
39      * @dev Returns `true` if `account` has been granted `role`.
40      */
41     function hasRole(bytes32 role, address account) external view returns (bool);
42 
43     /**
44      * @dev Returns the admin role that controls `role`. See {grantRole} and
45      * {revokeRole}.
46      *
47      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
48      */
49     function getRoleAdmin(bytes32 role) external view returns (bytes32);
50 
51     /**
52      * @dev Grants `role` to `account`.
53      *
54      * If `account` had not been already granted `role`, emits a {RoleGranted}
55      * event.
56      *
57      * Requirements:
58      *
59      * - the caller must have ``role``'s admin role.
60      */
61     function grantRole(bytes32 role, address account) external;
62 
63     /**
64      * @dev Revokes `role` from `account`.
65      *
66      * If `account` had been granted `role`, emits a {RoleRevoked} event.
67      *
68      * Requirements:
69      *
70      * - the caller must have ``role``'s admin role.
71      */
72     function revokeRole(bytes32 role, address account) external;
73 
74     /**
75      * @dev Revokes `role` from the calling account.
76      *
77      * Roles are often managed via {grantRole} and {revokeRole}: this function's
78      * purpose is to provide a mechanism for accounts to lose their privileges
79      * if they are compromised (such as when a trusted device is misplaced).
80      *
81      * If the calling account had been granted `role`, emits a {RoleRevoked}
82      * event.
83      *
84      * Requirements:
85      *
86      * - the caller must be `account`.
87      */
88     function renounceRole(bytes32 role, address account) external;
89 }
90 
91 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/utils/Context.sol
92 
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/utils/Strings.sol
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/utils/introspection/IERC165.sol
185 
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Interface of the ERC165 standard, as defined in the
191  * https://eips.ethereum.org/EIPS/eip-165[EIP].
192  *
193  * Implementers can declare support of contract interfaces, which can then be
194  * queried by others ({ERC165Checker}).
195  *
196  * For an implementation, see {ERC165}.
197  */
198 interface IERC165 {
199     /**
200      * @dev Returns true if this contract implements the interface defined by
201      * `interfaceId`. See the corresponding
202      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
203      * to learn more about how these ids are created.
204      *
205      * This function call must use less than 30 000 gas.
206      */
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 }
209 
210 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/utils/introspection/ERC165.sol
211 
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Implementation of the {IERC165} interface.
218  *
219  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
220  * for the additional interface id that will be supported. For example:
221  *
222  * ```solidity
223  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
224  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
225  * }
226  * ```
227  *
228  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
229  */
230 abstract contract ERC165 is IERC165 {
231     /**
232      * @dev See {IERC165-supportsInterface}.
233      */
234     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
235         return interfaceId == type(IERC165).interfaceId;
236     }
237 }
238 
239 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/access/AccessControl.sol
240 
241 
242 pragma solidity ^0.8.0;
243 
244 
245 
246 
247 
248 /**
249  * @dev Contract module that allows children to implement role-based access
250  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
251  * members except through off-chain means by accessing the contract event logs. Some
252  * applications may benefit from on-chain enumerability, for those cases see
253  * {AccessControlEnumerable}.
254  *
255  * Roles are referred to by their `bytes32` identifier. These should be exposed
256  * in the external API and be unique. The best way to achieve this is by
257  * using `public constant` hash digests:
258  *
259  * ```
260  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
261  * ```
262  *
263  * Roles can be used to represent a set of permissions. To restrict access to a
264  * function call, use {hasRole}:
265  *
266  * ```
267  * function foo() public {
268  *     require(hasRole(MY_ROLE, msg.sender));
269  *     ...
270  * }
271  * ```
272  *
273  * Roles can be granted and revoked dynamically via the {grantRole} and
274  * {revokeRole} functions. Each role has an associated admin role, and only
275  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
276  *
277  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
278  * that only accounts with this role will be able to grant or revoke other
279  * roles. More complex role relationships can be created by using
280  * {_setRoleAdmin}.
281  *
282  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
283  * grant and revoke this role. Extra precautions should be taken to secure
284  * accounts that have been granted it.
285  */
286 abstract contract AccessControl is Context, IAccessControl, ERC165 {
287     struct RoleData {
288         mapping(address => bool) members;
289         bytes32 adminRole;
290     }
291 
292     mapping(bytes32 => RoleData) private _roles;
293 
294     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
295 
296     /**
297      * @dev Modifier that checks that an account has a specific role. Reverts
298      * with a standardized message including the required role.
299      *
300      * The format of the revert reason is given by the following regular expression:
301      *
302      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
303      *
304      * _Available since v4.1._
305      */
306     modifier onlyRole(bytes32 role) {
307         _checkRole(role, _msgSender());
308         _;
309     }
310 
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
316     }
317 
318     /**
319      * @dev Returns `true` if `account` has been granted `role`.
320      */
321     function hasRole(bytes32 role, address account) public view override returns (bool) {
322         return _roles[role].members[account];
323     }
324 
325     /**
326      * @dev Revert with a standard message if `account` is missing `role`.
327      *
328      * The format of the revert reason is given by the following regular expression:
329      *
330      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
331      */
332     function _checkRole(bytes32 role, address account) internal view {
333         if (!hasRole(role, account)) {
334             revert(
335                 string(
336                     abi.encodePacked(
337                         "AccessControl: account ",
338                         Strings.toHexString(uint160(account), 20),
339                         " is missing role ",
340                         Strings.toHexString(uint256(role), 32)
341                     )
342                 )
343             );
344         }
345     }
346 
347     /**
348      * @dev Returns the admin role that controls `role`. See {grantRole} and
349      * {revokeRole}.
350      *
351      * To change a role's admin, use {_setRoleAdmin}.
352      */
353     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
354         return _roles[role].adminRole;
355     }
356 
357     /**
358      * @dev Grants `role` to `account`.
359      *
360      * If `account` had not been already granted `role`, emits a {RoleGranted}
361      * event.
362      *
363      * Requirements:
364      *
365      * - the caller must have ``role``'s admin role.
366      */
367     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
368         _grantRole(role, account);
369     }
370 
371     /**
372      * @dev Revokes `role` from `account`.
373      *
374      * If `account` had been granted `role`, emits a {RoleRevoked} event.
375      *
376      * Requirements:
377      *
378      * - the caller must have ``role``'s admin role.
379      */
380     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
381         _revokeRole(role, account);
382     }
383 
384     /**
385      * @dev Revokes `role` from the calling account.
386      *
387      * Roles are often managed via {grantRole} and {revokeRole}: this function's
388      * purpose is to provide a mechanism for accounts to lose their privileges
389      * if they are compromised (such as when a trusted device is misplaced).
390      *
391      * If the calling account had been granted `role`, emits a {RoleRevoked}
392      * event.
393      *
394      * Requirements:
395      *
396      * - the caller must be `account`.
397      */
398     function renounceRole(bytes32 role, address account) public virtual override {
399         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
400 
401         _revokeRole(role, account);
402     }
403 
404     /**
405      * @dev Grants `role` to `account`.
406      *
407      * If `account` had not been already granted `role`, emits a {RoleGranted}
408      * event. Note that unlike {grantRole}, this function doesn't perform any
409      * checks on the calling account.
410      *
411      * [WARNING]
412      * ====
413      * This function should only be called from the constructor when setting
414      * up the initial roles for the system.
415      *
416      * Using this function in any other way is effectively circumventing the admin
417      * system imposed by {AccessControl}.
418      * ====
419      */
420     function _setupRole(bytes32 role, address account) internal virtual {
421         _grantRole(role, account);
422     }
423 
424     /**
425      * @dev Sets `adminRole` as ``role``'s admin role.
426      *
427      * Emits a {RoleAdminChanged} event.
428      */
429     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
430         bytes32 previousAdminRole = getRoleAdmin(role);
431         _roles[role].adminRole = adminRole;
432         emit RoleAdminChanged(role, previousAdminRole, adminRole);
433     }
434 
435     function _grantRole(bytes32 role, address account) private {
436         if (!hasRole(role, account)) {
437             _roles[role].members[account] = true;
438             emit RoleGranted(role, account, _msgSender());
439         }
440     }
441 
442     function _revokeRole(bytes32 role, address account) private {
443         if (hasRole(role, account)) {
444             _roles[role].members[account] = false;
445             emit RoleRevoked(role, account, _msgSender());
446         }
447     }
448 }
449 
450 // File: contracts/MotionSettings.sol
451 
452 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
453 
454 pragma solidity ^0.8.4;
455 
456 
457 /// @author psirex
458 /// @notice Provides methods to update motion duration, objections threshold, and limit of active motions of Easy Track
459 contract MotionSettings is AccessControl {
460     // -------------
461     // EVENTS
462     // -------------
463     event MotionDurationChanged(uint256 _motionDuration);
464     event MotionsCountLimitChanged(uint256 _newMotionsCountLimit);
465     event ObjectionsThresholdChanged(uint256 _newThreshold);
466 
467     // -------------
468     // ERRORS
469     // -------------
470 
471     string private constant ERROR_VALUE_TOO_SMALL = "VALUE_TOO_SMALL";
472     string private constant ERROR_VALUE_TOO_LARGE = "VALUE_TOO_LARGE";
473 
474     // ------------
475     // CONSTANTS
476     // ------------
477     /// @notice Upper bound for motionsCountLimit variable.
478     uint256 public constant MAX_MOTIONS_LIMIT = 24;
479 
480     /// @notice Upper bound for objectionsThreshold variable.
481     /// @dev Stored in basis points (1% = 100)
482     uint256 public constant MAX_OBJECTIONS_THRESHOLD = 500;
483 
484     /// @notice Lower bound for motionDuration variable
485     uint256 public constant MIN_MOTION_DURATION = 48 hours;
486 
487     /// ------------------
488     /// STORAGE VARIABLES
489     /// ------------------
490 
491     /// @notice Percent from total supply of governance tokens required to reject motion.
492     /// @dev Value stored in basis points: 1% == 100.
493     uint256 public objectionsThreshold;
494 
495     /// @notice Max count of active motions
496     uint256 public motionsCountLimit;
497 
498     /// @notice Minimal time required to pass before enacting of motion
499     uint256 public motionDuration;
500 
501     // ------------
502     // CONSTRUCTOR
503     // ------------
504     constructor(
505         address _admin,
506         uint256 _motionDuration,
507         uint256 _motionsCountLimit,
508         uint256 _objectionsThreshold
509     ) {
510         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
511         _setMotionDuration(_motionDuration);
512         _setMotionsCountLimit(_motionsCountLimit);
513         _setObjectionsThreshold(_objectionsThreshold);
514     }
515 
516     // ------------------
517     // EXTERNAL METHODS
518     // ------------------
519 
520     /// @notice Sets the minimal time required to pass before enacting of motion
521     function setMotionDuration(uint256 _motionDuration) external onlyRole(DEFAULT_ADMIN_ROLE) {
522         _setMotionDuration(_motionDuration);
523     }
524 
525     /// @notice Sets percent from total supply of governance tokens required to reject motion
526     function setObjectionsThreshold(uint256 _objectionsThreshold)
527         external
528         onlyRole(DEFAULT_ADMIN_ROLE)
529     {
530         _setObjectionsThreshold(_objectionsThreshold);
531     }
532 
533     /// @notice Sets max count of active motions.
534     function setMotionsCountLimit(uint256 _motionsCountLimit)
535         external
536         onlyRole(DEFAULT_ADMIN_ROLE)
537     {
538         _setMotionsCountLimit(_motionsCountLimit);
539     }
540 
541     function _setMotionDuration(uint256 _motionDuration) internal {
542         require(_motionDuration >= MIN_MOTION_DURATION, ERROR_VALUE_TOO_SMALL);
543         motionDuration = _motionDuration;
544         emit MotionDurationChanged(_motionDuration);
545     }
546 
547     function _setObjectionsThreshold(uint256 _objectionsThreshold) internal {
548         require(_objectionsThreshold <= MAX_OBJECTIONS_THRESHOLD, ERROR_VALUE_TOO_LARGE);
549         objectionsThreshold = _objectionsThreshold;
550         emit ObjectionsThresholdChanged(_objectionsThreshold);
551     }
552 
553     function _setMotionsCountLimit(uint256 _motionsCountLimit) internal {
554         require(_motionsCountLimit <= MAX_MOTIONS_LIMIT, ERROR_VALUE_TOO_LARGE);
555         motionsCountLimit = _motionsCountLimit;
556         emit MotionsCountLimitChanged(_motionsCountLimit);
557     }
558 }
559 
560 // File: contracts/interfaces/IEVMScriptFactory.sol
561 
562 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
563 
564 pragma solidity ^0.8.4;
565 
566 /// @author psirex
567 /// @notice Interface which every EVMScript factory used in EasyTrack contract has to implement
568 interface IEVMScriptFactory {
569     function createEVMScript(address _creator, bytes memory _evmScriptCallData)
570         external
571         returns (bytes memory);
572 }
573 
574 // File: contracts/libraries/BytesUtils.sol
575 
576 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
577 
578 pragma solidity ^0.8.4;
579 
580 /// @author psirex
581 /// @notice Contains methods to extract primitive types from bytes
582 library BytesUtils {
583     function bytes24At(bytes memory data, uint256 location) internal pure returns (bytes24 result) {
584         uint256 word = uint256At(data, location);
585         assembly {
586             result := word
587         }
588     }
589 
590     function addressAt(bytes memory data, uint256 location) internal pure returns (address result) {
591         uint256 word = uint256At(data, location);
592         assembly {
593             result := shr(
594                 96,
595                 and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000)
596             )
597         }
598     }
599 
600     function uint32At(bytes memory _data, uint256 _location) internal pure returns (uint32 result) {
601         uint256 word = uint256At(_data, _location);
602 
603         assembly {
604             result := shr(
605                 224,
606                 and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000)
607             )
608         }
609     }
610 
611     function uint256At(bytes memory data, uint256 location) internal pure returns (uint256 result) {
612         assembly {
613             result := mload(add(data, add(0x20, location)))
614         }
615     }
616 }
617 
618 // File: contracts/libraries/EVMScriptPermissions.sol
619 
620 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
621 
622 pragma solidity ^0.8.4;
623 
624 
625 /// @author psirex
626 /// @notice Provides methods to convinient work with permissions bytes
627 /// @dev Permissions - is a list of tuples (address, bytes4) encoded into a bytes representation.
628 /// Each tuple (address, bytes4) describes a method allowed to be called by EVMScript
629 library EVMScriptPermissions {
630     using BytesUtils for bytes;
631 
632     // -------------
633     // CONSTANTS
634     // -------------
635 
636     /// Bytes size of SPEC_ID in EVMScript
637     uint256 private constant SPEC_ID_SIZE = 4;
638 
639     /// Size of the address type in bytes
640     uint256 private constant ADDRESS_SIZE = 20;
641 
642     /// Bytes size of calldata length in EVMScript
643     uint256 private constant CALLDATA_LENGTH_SIZE = 4;
644 
645     /// Bytes size of method selector
646     uint256 private constant METHOD_SELECTOR_SIZE = 4;
647 
648     /// Bytes size of one item in permissions
649     uint256 private constant PERMISSION_SIZE = ADDRESS_SIZE + METHOD_SELECTOR_SIZE;
650 
651     // ------------------
652     // INTERNAL METHODS
653     // ------------------
654 
655     /// @notice Validates that passed EVMScript calls only methods allowed in permissions.
656     /// @dev Returns false if provided permissions are invalid (has a wrong length or empty)
657     function canExecuteEVMScript(bytes memory _permissions, bytes memory _evmScript)
658         internal
659         pure
660         returns (bool)
661     {
662         uint256 location = SPEC_ID_SIZE; // first 4 bytes reserved for SPEC_ID
663         if (!isValidPermissions(_permissions) || _evmScript.length <= location) {
664             return false;
665         }
666 
667         while (location < _evmScript.length) {
668             (bytes24 methodToCall, uint32 callDataLength) = _getNextMethodId(_evmScript, location);
669             if (!_hasPermission(_permissions, methodToCall)) {
670                 return false;
671             }
672             location += ADDRESS_SIZE + CALLDATA_LENGTH_SIZE + callDataLength;
673         }
674         return true;
675     }
676 
677     /// @notice Validates that bytes with permissions not empty and has correct length
678     function isValidPermissions(bytes memory _permissions) internal pure returns (bool) {
679         return _permissions.length > 0 && _permissions.length % PERMISSION_SIZE == 0;
680     }
681 
682     // Retrieves bytes24 which describes tuple (address, bytes4)
683     // from EVMScript starting from _location position
684     function _getNextMethodId(bytes memory _evmScript, uint256 _location)
685         private
686         pure
687         returns (bytes24, uint32)
688     {
689         address recipient = _evmScript.addressAt(_location);
690         uint32 callDataLength = _evmScript.uint32At(_location + ADDRESS_SIZE);
691         uint32 functionSelector =
692             _evmScript.uint32At(_location + ADDRESS_SIZE + CALLDATA_LENGTH_SIZE);
693         return (bytes24(uint192(functionSelector)) | bytes20(recipient), callDataLength);
694     }
695 
696     // Validates that passed _methodToCall contained in permissions
697     function _hasPermission(bytes memory _permissions, bytes24 _methodToCall)
698         private
699         pure
700         returns (bool)
701     {
702         uint256 location = 0;
703         while (location < _permissions.length) {
704             bytes24 permission = _permissions.bytes24At(location);
705             if (permission == _methodToCall) {
706                 return true;
707             }
708             location += PERMISSION_SIZE;
709         }
710         return false;
711     }
712 }
713 
714 // File: contracts/EVMScriptFactoriesRegistry.sol
715 
716 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
717 
718 pragma solidity ^0.8.4;
719 
720 
721 
722 
723 /// @author psirex
724 /// @notice Provides methods to add/remove EVMScript factories
725 /// and contains an internal method for the convenient creation of EVMScripts
726 contract EVMScriptFactoriesRegistry is AccessControl {
727     using EVMScriptPermissions for bytes;
728 
729     // -------------
730     // EVENTS
731     // -------------
732 
733     event EVMScriptFactoryAdded(address indexed _evmScriptFactory, bytes _permissions);
734     event EVMScriptFactoryRemoved(address indexed _evmScriptFactory);
735 
736     // ------------
737     // STORAGE VARIABLES
738     // ------------
739 
740     /// @notice List of allowed EVMScript factories
741     address[] public evmScriptFactories;
742 
743     // Position of the EVMScript factory in the `evmScriptFactories` array,
744     // plus 1 because index 0 means a value is not in the set.
745     mapping(address => uint256) internal evmScriptFactoryIndices;
746 
747     /// @notice Permissions of current list of allowed EVMScript factories.
748     mapping(address => bytes) public evmScriptFactoryPermissions;
749 
750     // ------------
751     // CONSTRUCTOR
752     // ------------
753     constructor(address _admin) {
754         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
755     }
756 
757     // ------------------
758     // EXTERNAL METHODS
759     // ------------------
760 
761     /// @notice Adds new EVMScript Factory to the list of allowed EVMScript factories with given permissions.
762     /// Be careful about factories and their permissions added via this method. Only reviewed and tested
763     /// factories must be added via this method.
764     function addEVMScriptFactory(address _evmScriptFactory, bytes memory _permissions)
765         external
766         onlyRole(DEFAULT_ADMIN_ROLE)
767     {
768         require(_permissions.isValidPermissions(), "INVALID_PERMISSIONS");
769         require(!_isEVMScriptFactory(_evmScriptFactory), "EVM_SCRIPT_FACTORY_ALREADY_ADDED");
770         evmScriptFactories.push(_evmScriptFactory);
771         evmScriptFactoryIndices[_evmScriptFactory] = evmScriptFactories.length;
772         evmScriptFactoryPermissions[_evmScriptFactory] = _permissions;
773         emit EVMScriptFactoryAdded(_evmScriptFactory, _permissions);
774     }
775 
776     /// @notice Removes EVMScript factory from the list of allowed EVMScript factories
777     /// @dev To delete a EVMScript factory from the rewardPrograms array in O(1),
778     /// we swap the element to delete with the last one in the array, and then remove
779     /// the last element (sometimes called as 'swap and pop').
780     function removeEVMScriptFactory(address _evmScriptFactory)
781         external
782         onlyRole(DEFAULT_ADMIN_ROLE)
783     {
784         uint256 index = _getEVMScriptFactoryIndex(_evmScriptFactory);
785         uint256 lastIndex = evmScriptFactories.length - 1;
786 
787         if (index != lastIndex) {
788             address lastEVMScriptFactory = evmScriptFactories[lastIndex];
789             evmScriptFactories[index] = lastEVMScriptFactory;
790             evmScriptFactoryIndices[lastEVMScriptFactory] = index + 1;
791         }
792 
793         evmScriptFactories.pop();
794         delete evmScriptFactoryIndices[_evmScriptFactory];
795         delete evmScriptFactoryPermissions[_evmScriptFactory];
796         emit EVMScriptFactoryRemoved(_evmScriptFactory);
797     }
798 
799     /// @notice Returns current list of EVMScript factories
800     function getEVMScriptFactories() external view returns (address[] memory) {
801         return evmScriptFactories;
802     }
803 
804     /// @notice Returns if passed address are listed as EVMScript factory in the registry
805     function isEVMScriptFactory(address _maybeEVMScriptFactory) external view returns (bool) {
806         return _isEVMScriptFactory(_maybeEVMScriptFactory);
807     }
808 
809     // ------------------
810     // INTERNAL METHODS
811     // ------------------
812 
813     /// @notice Creates EVMScript using given EVMScript factory
814     /// @dev Checks permissions of resulting EVMScript and reverts with error
815     /// if script tries to call methods not listed in permissions
816     function _createEVMScript(
817         address _evmScriptFactory,
818         address _creator,
819         bytes memory _evmScriptCallData
820     ) internal returns (bytes memory _evmScript) {
821         require(_isEVMScriptFactory(_evmScriptFactory), "EVM_SCRIPT_FACTORY_NOT_FOUND");
822         _evmScript = IEVMScriptFactory(_evmScriptFactory).createEVMScript(
823             _creator,
824             _evmScriptCallData
825         );
826         bytes memory permissions = evmScriptFactoryPermissions[_evmScriptFactory];
827         require(permissions.canExecuteEVMScript(_evmScript), "HAS_NO_PERMISSIONS");
828     }
829 
830     // ------------------
831     // PRIVATE METHODS
832     // ------------------
833 
834     function _getEVMScriptFactoryIndex(address _evmScriptFactory)
835         private
836         view
837         returns (uint256 _index)
838     {
839         _index = evmScriptFactoryIndices[_evmScriptFactory];
840         require(_index > 0, "EVM_SCRIPT_FACTORY_NOT_FOUND");
841         _index -= 1;
842     }
843 
844     function _isEVMScriptFactory(address _maybeEVMScriptFactory) private view returns (bool) {
845         return evmScriptFactoryIndices[_maybeEVMScriptFactory] > 0;
846     }
847 }
848 
849 // File: contracts/interfaces/IEVMScriptExecutor.sol
850 
851 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
852 
853 pragma solidity ^0.8.4;
854 
855 /// @notice Interface of EVMScript executor used by EasyTrack
856 interface IEVMScriptExecutor {
857     function executeEVMScript(bytes memory _evmScript) external returns (bytes memory);
858 }
859 
860 // File: OpenZeppelin/openzeppelin-contracts@4.3.2/contracts/security/Pausable.sol
861 
862 
863 pragma solidity ^0.8.0;
864 
865 
866 /**
867  * @dev Contract module which allows children to implement an emergency stop
868  * mechanism that can be triggered by an authorized account.
869  *
870  * This module is used through inheritance. It will make available the
871  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
872  * the functions of your contract. Note that they will not be pausable by
873  * simply including this module, only once the modifiers are put in place.
874  */
875 abstract contract Pausable is Context {
876     /**
877      * @dev Emitted when the pause is triggered by `account`.
878      */
879     event Paused(address account);
880 
881     /**
882      * @dev Emitted when the pause is lifted by `account`.
883      */
884     event Unpaused(address account);
885 
886     bool private _paused;
887 
888     /**
889      * @dev Initializes the contract in unpaused state.
890      */
891     constructor() {
892         _paused = false;
893     }
894 
895     /**
896      * @dev Returns true if the contract is paused, and false otherwise.
897      */
898     function paused() public view virtual returns (bool) {
899         return _paused;
900     }
901 
902     /**
903      * @dev Modifier to make a function callable only when the contract is not paused.
904      *
905      * Requirements:
906      *
907      * - The contract must not be paused.
908      */
909     modifier whenNotPaused() {
910         require(!paused(), "Pausable: paused");
911         _;
912     }
913 
914     /**
915      * @dev Modifier to make a function callable only when the contract is paused.
916      *
917      * Requirements:
918      *
919      * - The contract must be paused.
920      */
921     modifier whenPaused() {
922         require(paused(), "Pausable: not paused");
923         _;
924     }
925 
926     /**
927      * @dev Triggers stopped state.
928      *
929      * Requirements:
930      *
931      * - The contract must not be paused.
932      */
933     function _pause() internal virtual whenNotPaused {
934         _paused = true;
935         emit Paused(_msgSender());
936     }
937 
938     /**
939      * @dev Returns to normal state.
940      *
941      * Requirements:
942      *
943      * - The contract must be paused.
944      */
945     function _unpause() internal virtual whenPaused {
946         _paused = false;
947         emit Unpaused(_msgSender());
948     }
949 }
950 
951 // File: contracts/EasyTrack.sol
952 
953 // SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
954 
955 pragma solidity ^0.8.4;
956 
957 
958 
959 
960 
961 
962 interface IMiniMeToken {
963     function balanceOfAt(address _owner, uint256 _blockNumber) external pure returns (uint256);
964 
965     function totalSupplyAt(uint256 _blockNumber) external view returns (uint256);
966 }
967 
968 /// @author psirex
969 /// @notice Contains main logic of Easy Track
970 contract EasyTrack is Pausable, AccessControl, MotionSettings, EVMScriptFactoriesRegistry {
971     struct Motion {
972         uint256 id;
973         address evmScriptFactory;
974         address creator;
975         uint256 duration;
976         uint256 startDate;
977         uint256 snapshotBlock;
978         uint256 objectionsThreshold;
979         uint256 objectionsAmount;
980         bytes32 evmScriptHash;
981     }
982 
983     // -------------
984     // EVENTS
985     // -------------
986     event MotionCreated(
987         uint256 indexed _motionId,
988         address _creator,
989         address indexed _evmScriptFactory,
990         bytes _evmScriptCallData,
991         bytes _evmScript
992     );
993     event MotionObjected(
994         uint256 indexed _motionId,
995         address indexed _objector,
996         uint256 _weight,
997         uint256 _newObjectionsAmount,
998         uint256 _newObjectionsAmountPct
999     );
1000     event MotionRejected(uint256 indexed _motionId);
1001     event MotionCanceled(uint256 indexed _motionId);
1002     event MotionEnacted(uint256 indexed _motionId);
1003     event EVMScriptExecutorChanged(address indexed _evmScriptExecutor);
1004 
1005     // -------------
1006     // ERRORS
1007     // -------------
1008     string private constant ERROR_ALREADY_OBJECTED = "ALREADY_OBJECTED";
1009     string private constant ERROR_NOT_ENOUGH_BALANCE = "NOT_ENOUGH_BALANCE";
1010     string private constant ERROR_NOT_CREATOR = "NOT_CREATOR";
1011     string private constant ERROR_MOTION_NOT_PASSED = "MOTION_NOT_PASSED";
1012     string private constant ERROR_UNEXPECTED_EVM_SCRIPT = "UNEXPECTED_EVM_SCRIPT";
1013     string private constant ERROR_MOTION_NOT_FOUND = "MOTION_NOT_FOUND";
1014     string private constant ERROR_MOTIONS_LIMIT_REACHED = "MOTIONS_LIMIT_REACHED";
1015 
1016     // -------------
1017     // ROLES
1018     // -------------
1019     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");
1020     bytes32 public constant UNPAUSE_ROLE = keccak256("UNPAUSE_ROLE");
1021     bytes32 public constant CANCEL_ROLE = keccak256("CANCEL_ROLE");
1022 
1023     // -------------
1024     // CONSTANTS
1025     // -------------
1026 
1027     // Stores 100% in basis points
1028     uint256 internal constant HUNDRED_PERCENT = 10000;
1029 
1030     // ------------
1031     // STORAGE VARIABLES
1032     // ------------
1033 
1034     /// @notice List of active motions
1035     Motion[] public motions;
1036 
1037     // Id of the lastly created motion
1038     uint256 internal lastMotionId;
1039 
1040     /// @notice Address of governanceToken which implements IMiniMeToken interface
1041     IMiniMeToken public governanceToken;
1042 
1043     /// @notice Address of current EVMScriptExecutor
1044     IEVMScriptExecutor public evmScriptExecutor;
1045 
1046     // Position of the motion in the `motions` array, plus 1
1047     // because index 0 means a value is not in the set.
1048     mapping(uint256 => uint256) internal motionIndicesByMotionId;
1049 
1050     /// @notice Stores if motion with given id has been objected from given address.
1051     mapping(uint256 => mapping(address => bool)) public objections;
1052 
1053     // ------------
1054     // CONSTRUCTOR
1055     // ------------
1056     constructor(
1057         address _governanceToken,
1058         address _admin,
1059         uint256 _motionDuration,
1060         uint256 _motionsCountLimit,
1061         uint256 _objectionsThreshold
1062     )
1063         EVMScriptFactoriesRegistry(_admin)
1064         MotionSettings(_admin, _motionDuration, _motionsCountLimit, _objectionsThreshold)
1065     {
1066         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
1067         _setupRole(PAUSE_ROLE, _admin);
1068         _setupRole(UNPAUSE_ROLE, _admin);
1069         _setupRole(CANCEL_ROLE, _admin);
1070 
1071         governanceToken = IMiniMeToken(_governanceToken);
1072     }
1073 
1074     // ------------------
1075     // EXTERNAL METHODS
1076     // ------------------
1077 
1078     /// @notice Creates new motion
1079     /// @param _evmScriptFactory Address of EVMScript factory registered in Easy Track
1080     /// @param _evmScriptCallData Encoded call data of EVMScript factory
1081     /// @return _newMotionId Id of created motion
1082     function createMotion(address _evmScriptFactory, bytes memory _evmScriptCallData)
1083         external
1084         whenNotPaused
1085         returns (uint256 _newMotionId)
1086     {
1087         require(motions.length < motionsCountLimit, ERROR_MOTIONS_LIMIT_REACHED);
1088 
1089         Motion storage newMotion = motions.push();
1090         _newMotionId = ++lastMotionId;
1091 
1092         newMotion.id = _newMotionId;
1093         newMotion.creator = msg.sender;
1094         newMotion.startDate = block.timestamp;
1095         newMotion.snapshotBlock = block.number;
1096         newMotion.duration = motionDuration;
1097         newMotion.objectionsThreshold = objectionsThreshold;
1098         newMotion.evmScriptFactory = _evmScriptFactory;
1099         motionIndicesByMotionId[_newMotionId] = motions.length;
1100 
1101         bytes memory evmScript =
1102             _createEVMScript(_evmScriptFactory, msg.sender, _evmScriptCallData);
1103         newMotion.evmScriptHash = keccak256(evmScript);
1104 
1105         emit MotionCreated(
1106             _newMotionId,
1107             msg.sender,
1108             _evmScriptFactory,
1109             _evmScriptCallData,
1110             evmScript
1111         );
1112     }
1113 
1114     /// @notice Enacts motion with given id
1115     /// @param _motionId Id of motion to enact
1116     /// @param _evmScriptCallData Encoded call data of EVMScript factory. Same as passed on the creation
1117     /// of motion with the given motion id. Transaction reverts if EVMScript factory call data differs
1118     function enactMotion(uint256 _motionId, bytes memory _evmScriptCallData)
1119         external
1120         whenNotPaused
1121     {
1122         Motion storage motion = _getMotion(_motionId);
1123         require(motion.startDate + motion.duration <= block.timestamp, ERROR_MOTION_NOT_PASSED);
1124 
1125         address creator = motion.creator;
1126         bytes32 evmScriptHash = motion.evmScriptHash;
1127         address evmScriptFactory = motion.evmScriptFactory;
1128 
1129         _deleteMotion(_motionId);
1130         emit MotionEnacted(_motionId);
1131 
1132         bytes memory evmScript = _createEVMScript(evmScriptFactory, creator, _evmScriptCallData);
1133         require(evmScriptHash == keccak256(evmScript), ERROR_UNEXPECTED_EVM_SCRIPT);
1134 
1135         evmScriptExecutor.executeEVMScript(evmScript);
1136     }
1137 
1138     /// @notice Submits an objection from `governanceToken` holder.
1139     /// @param _motionId Id of motion to object
1140     function objectToMotion(uint256 _motionId) external {
1141         Motion storage motion = _getMotion(_motionId);
1142         require(!objections[_motionId][msg.sender], ERROR_ALREADY_OBJECTED);
1143         objections[_motionId][msg.sender] = true;
1144 
1145         uint256 snapshotBlock = motion.snapshotBlock;
1146         uint256 objectorBalance = governanceToken.balanceOfAt(msg.sender, snapshotBlock);
1147         require(objectorBalance > 0, ERROR_NOT_ENOUGH_BALANCE);
1148 
1149         uint256 totalSupply = governanceToken.totalSupplyAt(snapshotBlock);
1150         uint256 newObjectionsAmount = motion.objectionsAmount + objectorBalance;
1151         uint256 newObjectionsAmountPct = (HUNDRED_PERCENT * newObjectionsAmount) / totalSupply;
1152 
1153         emit MotionObjected(
1154             _motionId,
1155             msg.sender,
1156             objectorBalance,
1157             newObjectionsAmount,
1158             newObjectionsAmountPct
1159         );
1160 
1161         if (newObjectionsAmountPct < motion.objectionsThreshold) {
1162             motion.objectionsAmount = newObjectionsAmount;
1163         } else {
1164             _deleteMotion(_motionId);
1165             emit MotionRejected(_motionId);
1166         }
1167     }
1168 
1169     /// @notice Cancels motion with given id
1170     /// @param _motionId Id of motion to cancel
1171     /// @dev Method reverts if it is called with not existed _motionId
1172     function cancelMotion(uint256 _motionId) external {
1173         Motion storage motion = _getMotion(_motionId);
1174         require(motion.creator == msg.sender, ERROR_NOT_CREATOR);
1175         _deleteMotion(_motionId);
1176         emit MotionCanceled(_motionId);
1177     }
1178 
1179     /// @notice Cancels all motions with given ids
1180     /// @param _motionIds Ids of motions to cancel
1181     function cancelMotions(uint256[] memory _motionIds) external onlyRole(CANCEL_ROLE) {
1182         for (uint256 i = 0; i < _motionIds.length; ++i) {
1183             if (motionIndicesByMotionId[_motionIds[i]] > 0) {
1184                 _deleteMotion(_motionIds[i]);
1185                 emit MotionCanceled(_motionIds[i]);
1186             }
1187         }
1188     }
1189 
1190     /// @notice Cancels all active motions
1191     function cancelAllMotions() external onlyRole(CANCEL_ROLE) {
1192         uint256 motionsCount = motions.length;
1193         while (motionsCount > 0) {
1194             motionsCount -= 1;
1195             uint256 motionId = motions[motionsCount].id;
1196             _deleteMotion(motionId);
1197             emit MotionCanceled(motionId);
1198         }
1199     }
1200 
1201     /// @notice Sets new EVMScriptExecutor
1202     /// @param _evmScriptExecutor Address of new EVMScriptExecutor
1203     function setEVMScriptExecutor(address _evmScriptExecutor)
1204         external
1205         onlyRole(DEFAULT_ADMIN_ROLE)
1206     {
1207         evmScriptExecutor = IEVMScriptExecutor(_evmScriptExecutor);
1208         emit EVMScriptExecutorChanged(_evmScriptExecutor);
1209     }
1210 
1211     /// @notice Pauses Easy Track if it isn't paused.
1212     /// Paused Easy Track can't create and enact motions
1213     function pause() external whenNotPaused onlyRole(PAUSE_ROLE) {
1214         _pause();
1215     }
1216 
1217     /// @notice Unpauses Easy Track if it is paused
1218     function unpause() external whenPaused onlyRole(UNPAUSE_ROLE) {
1219         _unpause();
1220     }
1221 
1222     /// @notice Returns if an _objector can submit an objection to motion with id equals to _motionId or not
1223     /// @param _motionId Id of motion to check opportunity to object
1224     /// @param _objector Address of objector
1225     function canObjectToMotion(uint256 _motionId, address _objector) external view returns (bool) {
1226         Motion storage motion = _getMotion(_motionId);
1227         uint256 balance = governanceToken.balanceOfAt(_objector, motion.snapshotBlock);
1228         return balance > 0 && !objections[_motionId][_objector];
1229     }
1230 
1231     /// @notice Returns list of active motions
1232     function getMotions() external view returns (Motion[] memory) {
1233         return motions;
1234     }
1235 
1236     /// @notice Returns motion with the given id
1237     /// @param _motionId Id of motion to retrieve
1238     function getMotion(uint256 _motionId) external view returns (Motion memory) {
1239         return _getMotion(_motionId);
1240     }
1241 
1242     // -------
1243     // PRIVATE METHODS
1244     // -------
1245 
1246     // Removes motion from list of active moitons
1247     // To delete a motion from the moitons array in O(1), we swap the element to delete with the last one in
1248     // the array, and then remove the last element (sometimes called as 'swap and pop').
1249     function _deleteMotion(uint256 _motionId) private {
1250         uint256 index = motionIndicesByMotionId[_motionId] - 1;
1251         uint256 lastIndex = motions.length - 1;
1252 
1253         if (index != lastIndex) {
1254             Motion storage lastMotion = motions[lastIndex];
1255             motions[index] = lastMotion;
1256             motionIndicesByMotionId[lastMotion.id] = index + 1;
1257         }
1258 
1259         motions.pop();
1260         delete motionIndicesByMotionId[_motionId];
1261     }
1262 
1263     // Returns motion with given id if it exists
1264     function _getMotion(uint256 _motionId) private view returns (Motion storage) {
1265         uint256 _motionIndex = motionIndicesByMotionId[_motionId];
1266         require(_motionIndex > 0, ERROR_MOTION_NOT_FOUND);
1267         return motions[_motionIndex - 1];
1268     }
1269 }