1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/IERC2981Royalties.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /// @title IERC2981Royalties
8 /// @dev Interface for the ERC2981 - Token Royalty standard
9 interface IERC2981Royalties {
10     /// @notice Called with the sale price to determine how much royalty
11     //          is owed and to whom.
12     /// @param _tokenId - the NFT asset queried for royalty information
13     /// @param _value - the sale price of the NFT asset specified by _tokenId
14     /// @return _receiver - address of who should be sent the royalty payment
15     /// @return _royaltyAmount - the royalty payment amount for value sale price
16     function royaltyInfo(uint256 _tokenId, uint256 _value)
17         external
18         view
19         returns (address _receiver, uint256 _royaltyAmount);
20 }
21 // File: contracts/IOperatorFilterRegistry.sol
22 
23 pragma solidity ^0.8.13;
24 
25 interface IOperatorFilterRegistry {
26     function isOperatorAllowed(address registrant, address operator)
27         external
28         view
29         returns (bool);
30 
31     function register(address registrant) external;
32 
33     function registerAndSubscribe(address registrant, address subscription)
34         external;
35 
36     function registerAndCopyEntries(
37         address registrant,
38         address registrantToCopy
39     ) external;
40 
41     function unregister(address addr) external;
42 
43     function updateOperator(
44         address registrant,
45         address operator,
46         bool filtered
47     ) external;
48 
49     function updateOperators(
50         address registrant,
51         address[] calldata operators,
52         bool filtered
53     ) external;
54 
55     function updateCodeHash(
56         address registrant,
57         bytes32 codehash,
58         bool filtered
59     ) external;
60 
61     function updateCodeHashes(
62         address registrant,
63         bytes32[] calldata codeHashes,
64         bool filtered
65     ) external;
66 
67     function subscribe(address registrant, address registrantToSubscribe)
68         external;
69 
70     function unsubscribe(address registrant, bool copyExistingEntries) external;
71 
72     function subscriptionOf(address addr) external returns (address registrant);
73 
74     function subscribers(address registrant)
75         external
76         returns (address[] memory);
77 
78     function subscriberAt(address registrant, uint256 index)
79         external
80         returns (address);
81 
82     function copyEntriesOf(address registrant, address registrantToCopy)
83         external;
84 
85     function isOperatorFiltered(address registrant, address operator)
86         external
87         returns (bool);
88 
89     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
90         external
91         returns (bool);
92 
93     function isCodeHashFiltered(address registrant, bytes32 codeHash)
94         external
95         returns (bool);
96 
97     function filteredOperators(address addr)
98         external
99         returns (address[] memory);
100 
101     function filteredCodeHashes(address addr)
102         external
103         returns (bytes32[] memory);
104 
105     function filteredOperatorAt(address registrant, uint256 index)
106         external
107         returns (address);
108 
109     function filteredCodeHashAt(address registrant, uint256 index)
110         external
111         returns (bytes32);
112 
113     function isRegistered(address addr) external returns (bool);
114 
115     function codeHashOf(address addr) external returns (bytes32);
116 }
117 
118 // File: contracts/OperatorFilterer.sol
119 
120 pragma solidity ^0.8.13;
121 
122 /**
123  * @title  OperatorFilterer
124  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
125  *         registrant's entries in the OperatorFilterRegistry.
126  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
127  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
128  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
129  */
130 abstract contract OperatorFilterer {
131     error OperatorNotAllowed(address operator);
132 
133     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
134         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
135 
136     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
137         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
138         // will not revert, but the contract will need to be registered with the registry once it is deployed in
139         // order for the modifier to filter addresses.
140         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
141             if (subscribe) {
142                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
143                     address(this),
144                     subscriptionOrRegistrantToCopy
145                 );
146             } else {
147                 if (subscriptionOrRegistrantToCopy != address(0)) {
148                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
149                         address(this),
150                         subscriptionOrRegistrantToCopy
151                     );
152                 } else {
153                     OPERATOR_FILTER_REGISTRY.register(address(this));
154                 }
155             }
156         }
157     }
158 
159     modifier onlyAllowedOperator(address from) virtual {
160         // Check registry code length to facilitate testing in environments without a deployed registry.
161         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
162             // Allow spending tokens from addresses with balance
163             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
164             // from an EOA.
165             if (from == msg.sender) {
166                 _;
167                 return;
168             }
169             if (
170                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
171                     address(this),
172                     msg.sender
173                 )
174             ) {
175                 revert OperatorNotAllowed(msg.sender);
176             }
177         }
178         _;
179     }
180 
181     modifier onlyAllowedOperatorApproval(address operator) virtual {
182         // Check registry code length to facilitate testing in environments without a deployed registry.
183         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
184             if (
185                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
186                     address(this),
187                     operator
188                 )
189             ) {
190                 revert OperatorNotAllowed(operator);
191             }
192         }
193         _;
194     }
195 }
196 // File: contracts/RevokableOperatorFilterer.sol
197 
198 pragma solidity ^0.8.13;
199 
200 /**
201  * @title  RevokableOperatorFilterer
202  * @notice This contract is meant to allow contracts to permanently opt out of the OperatorFilterRegistry. The Registry
203  *         itself has an "unregister" function, but if the contract is ownable, the owner can re-register at any point.
204  *         As implemented, this abstract contract allows the contract owner to toggle the
205  *         isOperatorFilterRegistryRevoked flag in order to permanently bypass the OperatorFilterRegistry checks.
206  */
207 abstract contract RevokableOperatorFilterer is OperatorFilterer {
208     error OnlyOwner();
209     error AlreadyRevoked();
210 
211     bool private _isOperatorFilterRegistryRevoked;
212 
213     modifier onlyAllowedOperator(address from) override {
214         // Check registry code length to facilitate testing in environments without a deployed registry.
215         if (
216             !_isOperatorFilterRegistryRevoked &&
217             address(OPERATOR_FILTER_REGISTRY).code.length > 0
218         ) {
219             // Allow spending tokens from addresses with balance
220             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
221             // from an EOA.
222             if (from == msg.sender) {
223                 _;
224                 return;
225             }
226             if (
227                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
228                     address(this),
229                     msg.sender
230                 )
231             ) {
232                 revert OperatorNotAllowed(msg.sender);
233             }
234         }
235         _;
236     }
237 
238     modifier onlyAllowedOperatorApproval(address operator) override {
239         // Check registry code length to facilitate testing in environments without a deployed registry.
240         if (
241             !_isOperatorFilterRegistryRevoked &&
242             address(OPERATOR_FILTER_REGISTRY).code.length > 0
243         ) {
244             if (
245                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
246                     address(this),
247                     operator
248                 )
249             ) {
250                 revert OperatorNotAllowed(operator);
251             }
252         }
253         _;
254     }
255 
256     /**
257      * @notice Disable the isOperatorFilterRegistryRevoked flag. OnlyOwner.
258      */
259     function revokeOperatorFilterRegistry() external {
260         if (msg.sender != owner()) {
261             revert OnlyOwner();
262         }
263         if (_isOperatorFilterRegistryRevoked) {
264             revert AlreadyRevoked();
265         }
266         _isOperatorFilterRegistryRevoked = true;
267     }
268 
269     function isOperatorFilterRegistryRevoked() public view returns (bool) {
270         return _isOperatorFilterRegistryRevoked;
271     }
272 
273     /**
274      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
275      */
276     function owner() public view virtual returns (address);
277 }
278 // File: contracts/RevokableDefaultOperatorFilterer.sol
279 
280 pragma solidity ^0.8.13;
281 
282 /**
283  * @title  RevokableDefaultOperatorFilterer
284  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
285  */
286 abstract contract RevokableDefaultOperatorFilterer is
287     RevokableOperatorFilterer
288 {
289     address constant DEFAULT_SUBSCRIPTION =
290         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
291 
292     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
293 }
294 // File: @openzeppelin/contracts/utils/Strings.sol
295 
296 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev String operations.
302  */
303 library Strings {
304     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
305     uint8 private constant _ADDRESS_LENGTH = 20;
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
309      */
310     function toString(uint256 value) internal pure returns (string memory) {
311         // Inspired by OraclizeAPI's implementation - MIT licence
312         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
313 
314         if (value == 0) {
315             return "0";
316         }
317         uint256 temp = value;
318         uint256 digits;
319         while (temp != 0) {
320             digits++;
321             temp /= 10;
322         }
323         bytes memory buffer = new bytes(digits);
324         while (value != 0) {
325             digits -= 1;
326             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
327             value /= 10;
328         }
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
334      */
335     function toHexString(uint256 value) internal pure returns (string memory) {
336         if (value == 0) {
337             return "0x00";
338         }
339         uint256 temp = value;
340         uint256 length = 0;
341         while (temp != 0) {
342             length++;
343             temp >>= 8;
344         }
345         return toHexString(value, length);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
350      */
351     function toHexString(uint256 value, uint256 length)
352         internal
353         pure
354         returns (string memory)
355     {
356         bytes memory buffer = new bytes(2 * length + 2);
357         buffer[0] = "0";
358         buffer[1] = "x";
359         for (uint256 i = 2 * length + 1; i > 1; --i) {
360             buffer[i] = _HEX_SYMBOLS[value & 0xf];
361             value >>= 4;
362         }
363         require(value == 0, "Strings: hex length insufficient");
364         return string(buffer);
365     }
366 
367     /**
368      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
369      */
370     function toHexString(address addr) internal pure returns (string memory) {
371         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
372     }
373 }
374 
375 // File: @openzeppelin/contracts/access/IAccessControl.sol
376 
377 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev External interface of AccessControl declared to support ERC165 detection.
383  */
384 interface IAccessControl {
385     /**
386      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
387      *
388      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
389      * {RoleAdminChanged} not being emitted signaling this.
390      *
391      * _Available since v3.1._
392      */
393     event RoleAdminChanged(
394         bytes32 indexed role,
395         bytes32 indexed previousAdminRole,
396         bytes32 indexed newAdminRole
397     );
398 
399     /**
400      * @dev Emitted when `account` is granted `role`.
401      *
402      * `sender` is the account that originated the contract call, an admin role
403      * bearer except when using {AccessControl-_setupRole}.
404      */
405     event RoleGranted(
406         bytes32 indexed role,
407         address indexed account,
408         address indexed sender
409     );
410 
411     /**
412      * @dev Emitted when `account` is revoked `role`.
413      *
414      * `sender` is the account that originated the contract call:
415      *   - if using `revokeRole`, it is the admin role bearer
416      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
417      */
418     event RoleRevoked(
419         bytes32 indexed role,
420         address indexed account,
421         address indexed sender
422     );
423 
424     /**
425      * @dev Returns `true` if `account` has been granted `role`.
426      */
427     function hasRole(bytes32 role, address account)
428         external
429         view
430         returns (bool);
431 
432     /**
433      * @dev Returns the admin role that controls `role`. See {grantRole} and
434      * {revokeRole}.
435      *
436      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
437      */
438     function getRoleAdmin(bytes32 role) external view returns (bytes32);
439 
440     /**
441      * @dev Grants `role` to `account`.
442      *
443      * If `account` had not been already granted `role`, emits a {RoleGranted}
444      * event.
445      *
446      * Requirements:
447      *
448      * - the caller must have ``role``'s admin role.
449      */
450     function grantRole(bytes32 role, address account) external;
451 
452     /**
453      * @dev Revokes `role` from `account`.
454      *
455      * If `account` had been granted `role`, emits a {RoleRevoked} event.
456      *
457      * Requirements:
458      *
459      * - the caller must have ``role``'s admin role.
460      */
461     function revokeRole(bytes32 role, address account) external;
462 
463     /**
464      * @dev Revokes `role` from the calling account.
465      *
466      * Roles are often managed via {grantRole} and {revokeRole}: this function's
467      * purpose is to provide a mechanism for accounts to lose their privileges
468      * if they are compromised (such as when a trusted device is misplaced).
469      *
470      * If the calling account had been granted `role`, emits a {RoleRevoked}
471      * event.
472      *
473      * Requirements:
474      *
475      * - the caller must be `account`.
476      */
477     function renounceRole(bytes32 role, address account) external;
478 }
479 
480 // File: @openzeppelin/contracts/utils/Context.sol
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes calldata) {
502         return msg.data;
503     }
504 }
505 
506 // File: @openzeppelin/contracts/access/Ownable.sol
507 
508 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Contract module which provides a basic access control mechanism, where
514  * there is an account (an owner) that can be granted exclusive access to
515  * specific functions.
516  *
517  * By default, the owner account will be the one that deploys the contract. This
518  * can later be changed with {transferOwnership}.
519  *
520  * This module is used through inheritance. It will make available the modifier
521  * `onlyOwner`, which can be applied to your functions to restrict their use to
522  * the owner.
523  */
524 abstract contract Ownable is Context {
525     address private _owner;
526 
527     event OwnershipTransferred(
528         address indexed previousOwner,
529         address indexed newOwner
530     );
531 
532     /**
533      * @dev Initializes the contract setting the deployer as the initial owner.
534      */
535     constructor() {
536         _transferOwnership(_msgSender());
537     }
538 
539     /**
540      * @dev Throws if called by any account other than the owner.
541      */
542     modifier onlyOwner() {
543         _checkOwner();
544         _;
545     }
546 
547     /**
548      * @dev Returns the address of the current owner.
549      */
550     function owner() public view virtual returns (address) {
551         return _owner;
552     }
553 
554     /**
555      * @dev Throws if the sender is not the owner.
556      */
557     function _checkOwner() internal view virtual {
558         require(owner() == _msgSender(), "Ownable: caller is not the owner");
559     }
560 
561     /**
562      * @dev Leaves the contract without owner. It will not be possible to call
563      * `onlyOwner` functions anymore. Can only be called by the current owner.
564      *
565      * NOTE: Renouncing ownership will leave the contract without an owner,
566      * thereby removing any functionality that is only available to the owner.
567      */
568     function renounceOwnership() public virtual onlyOwner {
569         _transferOwnership(address(0));
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public virtual onlyOwner {
577         require(
578             newOwner != address(0),
579             "Ownable: new owner is the zero address"
580         );
581         _transferOwnership(newOwner);
582     }
583 
584     /**
585      * @dev Transfers ownership of the contract to a new account (`newOwner`).
586      * Internal function without access restriction.
587      */
588     function _transferOwnership(address newOwner) internal virtual {
589         address oldOwner = _owner;
590         _owner = newOwner;
591         emit OwnershipTransferred(oldOwner, newOwner);
592     }
593 }
594 
595 // File: @openzeppelin/contracts/utils/Address.sol
596 
597 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
598 
599 pragma solidity ^0.8.1;
600 
601 /**
602  * @dev Collection of functions related to the address type
603  */
604 library Address {
605     /**
606      * @dev Returns true if `account` is a contract.
607      *
608      * [IMPORTANT]
609      * ====
610      * It is unsafe to assume that an address for which this function returns
611      * false is an externally-owned account (EOA) and not a contract.
612      *
613      * Among others, `isContract` will return false for the following
614      * types of addresses:
615      *
616      *  - an externally-owned account
617      *  - a contract in construction
618      *  - an address where a contract will be created
619      *  - an address where a contract lived, but was destroyed
620      * ====
621      *
622      * [IMPORTANT]
623      * ====
624      * You shouldn't rely on `isContract` to protect against flash loan attacks!
625      *
626      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
627      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
628      * constructor.
629      * ====
630      */
631     function isContract(address account) internal view returns (bool) {
632         // This method relies on extcodesize/address.code.length, which returns 0
633         // for contracts in construction, since the code is only stored at the end
634         // of the constructor execution.
635 
636         return account.code.length > 0;
637     }
638 
639     /**
640      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
641      * `recipient`, forwarding all available gas and reverting on errors.
642      *
643      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
644      * of certain opcodes, possibly making contracts go over the 2300 gas limit
645      * imposed by `transfer`, making them unable to receive funds via
646      * `transfer`. {sendValue} removes this limitation.
647      *
648      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
649      *
650      * IMPORTANT: because control is transferred to `recipient`, care must be
651      * taken to not create reentrancy vulnerabilities. Consider using
652      * {ReentrancyGuard} or the
653      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
654      */
655     function sendValue(address payable recipient, uint256 amount) internal {
656         require(
657             address(this).balance >= amount,
658             "Address: insufficient balance"
659         );
660 
661         (bool success, ) = recipient.call{value: amount}("");
662         require(
663             success,
664             "Address: unable to send value, recipient may have reverted"
665         );
666     }
667 
668     /**
669      * @dev Performs a Solidity function call using a low level `call`. A
670      * plain `call` is an unsafe replacement for a function call: use this
671      * function instead.
672      *
673      * If `target` reverts with a revert reason, it is bubbled up by this
674      * function (like regular Solidity function calls).
675      *
676      * Returns the raw returned data. To convert to the expected return value,
677      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
678      *
679      * Requirements:
680      *
681      * - `target` must be a contract.
682      * - calling `target` with `data` must not revert.
683      *
684      * _Available since v3.1._
685      */
686     function functionCall(address target, bytes memory data)
687         internal
688         returns (bytes memory)
689     {
690         return functionCall(target, data, "Address: low-level call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
695      * `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCall(
700         address target,
701         bytes memory data,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         return functionCallWithValue(target, data, 0, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but also transferring `value` wei to `target`.
710      *
711      * Requirements:
712      *
713      * - the calling contract must have an ETH balance of at least `value`.
714      * - the called Solidity function must be `payable`.
715      *
716      * _Available since v3.1._
717      */
718     function functionCallWithValue(
719         address target,
720         bytes memory data,
721         uint256 value
722     ) internal returns (bytes memory) {
723         return
724             functionCallWithValue(
725                 target,
726                 data,
727                 value,
728                 "Address: low-level call with value failed"
729             );
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
734      * with `errorMessage` as a fallback revert reason when `target` reverts.
735      *
736      * _Available since v3.1._
737      */
738     function functionCallWithValue(
739         address target,
740         bytes memory data,
741         uint256 value,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         require(
745             address(this).balance >= value,
746             "Address: insufficient balance for call"
747         );
748         require(isContract(target), "Address: call to non-contract");
749 
750         (bool success, bytes memory returndata) = target.call{value: value}(
751             data
752         );
753         return verifyCallResult(success, returndata, errorMessage);
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
758      * but performing a static call.
759      *
760      * _Available since v3.3._
761      */
762     function functionStaticCall(address target, bytes memory data)
763         internal
764         view
765         returns (bytes memory)
766     {
767         return
768             functionStaticCall(
769                 target,
770                 data,
771                 "Address: low-level static call failed"
772             );
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(
782         address target,
783         bytes memory data,
784         string memory errorMessage
785     ) internal view returns (bytes memory) {
786         require(isContract(target), "Address: static call to non-contract");
787 
788         (bool success, bytes memory returndata) = target.staticcall(data);
789         return verifyCallResult(success, returndata, errorMessage);
790     }
791 
792     /**
793      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
794      * but performing a delegate call.
795      *
796      * _Available since v3.4._
797      */
798     function functionDelegateCall(address target, bytes memory data)
799         internal
800         returns (bytes memory)
801     {
802         return
803             functionDelegateCall(
804                 target,
805                 data,
806                 "Address: low-level delegate call failed"
807             );
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
812      * but performing a delegate call.
813      *
814      * _Available since v3.4._
815      */
816     function functionDelegateCall(
817         address target,
818         bytes memory data,
819         string memory errorMessage
820     ) internal returns (bytes memory) {
821         require(isContract(target), "Address: delegate call to non-contract");
822 
823         (bool success, bytes memory returndata) = target.delegatecall(data);
824         return verifyCallResult(success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
829      * revert reason using the provided one.
830      *
831      * _Available since v4.3._
832      */
833     function verifyCallResult(
834         bool success,
835         bytes memory returndata,
836         string memory errorMessage
837     ) internal pure returns (bytes memory) {
838         if (success) {
839             return returndata;
840         } else {
841             // Look for revert reason and bubble it up if present
842             if (returndata.length > 0) {
843                 // The easiest way to bubble the revert reason is using memory via assembly
844                 /// @solidity memory-safe-assembly
845                 assembly {
846                     let returndata_size := mload(returndata)
847                     revert(add(32, returndata), returndata_size)
848                 }
849             } else {
850                 revert(errorMessage);
851             }
852         }
853     }
854 }
855 
856 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
857 
858 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 /**
863  * @dev Interface of the ERC165 standard, as defined in the
864  * https://eips.ethereum.org/EIPS/eip-165[EIP].
865  *
866  * Implementers can declare support of contract interfaces, which can then be
867  * queried by others ({ERC165Checker}).
868  *
869  * For an implementation, see {ERC165}.
870  */
871 interface IERC165 {
872     /**
873      * @dev Returns true if this contract implements the interface defined by
874      * `interfaceId`. See the corresponding
875      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
876      * to learn more about how these ids are created.
877      *
878      * This function call must use less than 30 000 gas.
879      */
880     function supportsInterface(bytes4 interfaceId) external view returns (bool);
881 }
882 
883 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
884 
885 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 /**
890  * @dev Implementation of the {IERC165} interface.
891  *
892  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
893  * for the additional interface id that will be supported. For example:
894  *
895  * ```solidity
896  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
897  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
898  * }
899  * ```
900  *
901  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
902  */
903 abstract contract ERC165 is IERC165 {
904     /**
905      * @dev See {IERC165-supportsInterface}.
906      */
907     function supportsInterface(bytes4 interfaceId)
908         public
909         view
910         virtual
911         override
912         returns (bool)
913     {
914         return interfaceId == type(IERC165).interfaceId;
915     }
916 }
917 
918 // File: contracts/ERC2981Base.sol
919 
920 pragma solidity ^0.8.0;
921 
922 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
923 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
924     struct RoyaltyInfo {
925         address recipient;
926         uint24 amount;
927     }
928 
929     /// @inheritdoc	ERC165
930     function supportsInterface(bytes4 interfaceId)
931         public
932         view
933         virtual
934         override
935         returns (bool)
936     {
937         return
938             interfaceId == type(IERC2981Royalties).interfaceId ||
939             super.supportsInterface(interfaceId);
940     }
941 }
942 // File: contracts/ERC2981ContractWideRoyalties.sol
943 
944 pragma solidity ^0.8.0;
945 
946 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
947 /// @dev This implementation has the same royalties for each and every tokens
948 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
949     RoyaltyInfo private _royalties;
950 
951     /// @dev Sets token royalties
952     /// @param recipient recipient of the royalties
953     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
954     function _setRoyalties(address recipient, uint256 value) internal {
955         require(value <= 10000, "ERC2981Royalties: Too high");
956         _royalties = RoyaltyInfo(recipient, uint24(value));
957     }
958 
959     /// @inheritdoc	IERC2981Royalties
960     function royaltyInfo(uint256, uint256 value)
961         external
962         view
963         override
964         returns (address receiver, uint256 royaltyAmount)
965     {
966         RoyaltyInfo memory royalties = _royalties;
967         receiver = royalties.recipient;
968         royaltyAmount = (value * royalties.amount) / 10000;
969     }
970 }
971 // File: @openzeppelin/contracts/access/AccessControl.sol
972 
973 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Contract module that allows children to implement role-based access
979  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
980  * members except through off-chain means by accessing the contract event logs. Some
981  * applications may benefit from on-chain enumerability, for those cases see
982  * {AccessControlEnumerable}.
983  *
984  * Roles are referred to by their `bytes32` identifier. These should be exposed
985  * in the external API and be unique. The best way to achieve this is by
986  * using `public constant` hash digests:
987  *
988  * ```
989  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
990  * ```
991  *
992  * Roles can be used to represent a set of permissions. To restrict access to a
993  * function call, use {hasRole}:
994  *
995  * ```
996  * function foo() public {
997  *     require(hasRole(MY_ROLE, msg.sender));
998  *     ...
999  * }
1000  * ```
1001  *
1002  * Roles can be granted and revoked dynamically via the {grantRole} and
1003  * {revokeRole} functions. Each role has an associated admin role, and only
1004  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1005  *
1006  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1007  * that only accounts with this role will be able to grant or revoke other
1008  * roles. More complex role relationships can be created by using
1009  * {_setRoleAdmin}.
1010  *
1011  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1012  * grant and revoke this role. Extra precautions should be taken to secure
1013  * accounts that have been granted it.
1014  */
1015 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1016     struct RoleData {
1017         mapping(address => bool) members;
1018         bytes32 adminRole;
1019     }
1020 
1021     mapping(bytes32 => RoleData) private _roles;
1022 
1023     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1024 
1025     /**
1026      * @dev Modifier that checks that an account has a specific role. Reverts
1027      * with a standardized message including the required role.
1028      *
1029      * The format of the revert reason is given by the following regular expression:
1030      *
1031      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1032      *
1033      * _Available since v4.1._
1034      */
1035     modifier onlyRole(bytes32 role) {
1036         _checkRole(role);
1037         _;
1038     }
1039 
1040     /**
1041      * @dev See {IERC165-supportsInterface}.
1042      */
1043     function supportsInterface(bytes4 interfaceId)
1044         public
1045         view
1046         virtual
1047         override
1048         returns (bool)
1049     {
1050         return
1051             interfaceId == type(IAccessControl).interfaceId ||
1052             super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev Returns `true` if `account` has been granted `role`.
1057      */
1058     function hasRole(bytes32 role, address account)
1059         public
1060         view
1061         virtual
1062         override
1063         returns (bool)
1064     {
1065         return _roles[role].members[account];
1066     }
1067 
1068     /**
1069      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1070      * Overriding this function changes the behavior of the {onlyRole} modifier.
1071      *
1072      * Format of the revert message is described in {_checkRole}.
1073      *
1074      * _Available since v4.6._
1075      */
1076     function _checkRole(bytes32 role) internal view virtual {
1077         _checkRole(role, _msgSender());
1078     }
1079 
1080     /**
1081      * @dev Revert with a standard message if `account` is missing `role`.
1082      *
1083      * The format of the revert reason is given by the following regular expression:
1084      *
1085      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1086      */
1087     function _checkRole(bytes32 role, address account) internal view virtual {
1088         if (!hasRole(role, account)) {
1089             revert(
1090                 string(
1091                     abi.encodePacked(
1092                         "AccessControl: account ",
1093                         Strings.toHexString(uint160(account), 20),
1094                         " is missing role ",
1095                         Strings.toHexString(uint256(role), 32)
1096                     )
1097                 )
1098             );
1099         }
1100     }
1101 
1102     /**
1103      * @dev Returns the admin role that controls `role`. See {grantRole} and
1104      * {revokeRole}.
1105      *
1106      * To change a role's admin, use {_setRoleAdmin}.
1107      */
1108     function getRoleAdmin(bytes32 role)
1109         public
1110         view
1111         virtual
1112         override
1113         returns (bytes32)
1114     {
1115         return _roles[role].adminRole;
1116     }
1117 
1118     /**
1119      * @dev Grants `role` to `account`.
1120      *
1121      * If `account` had not been already granted `role`, emits a {RoleGranted}
1122      * event.
1123      *
1124      * Requirements:
1125      *
1126      * - the caller must have ``role``'s admin role.
1127      *
1128      * May emit a {RoleGranted} event.
1129      */
1130     function grantRole(bytes32 role, address account)
1131         public
1132         virtual
1133         override
1134         onlyRole(getRoleAdmin(role))
1135     {
1136         _grantRole(role, account);
1137     }
1138 
1139     /**
1140      * @dev Revokes `role` from `account`.
1141      *
1142      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1143      *
1144      * Requirements:
1145      *
1146      * - the caller must have ``role``'s admin role.
1147      *
1148      * May emit a {RoleRevoked} event.
1149      */
1150     function revokeRole(bytes32 role, address account)
1151         public
1152         virtual
1153         override
1154         onlyRole(getRoleAdmin(role))
1155     {
1156         _revokeRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Revokes `role` from the calling account.
1161      *
1162      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1163      * purpose is to provide a mechanism for accounts to lose their privileges
1164      * if they are compromised (such as when a trusted device is misplaced).
1165      *
1166      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1167      * event.
1168      *
1169      * Requirements:
1170      *
1171      * - the caller must be `account`.
1172      *
1173      * May emit a {RoleRevoked} event.
1174      */
1175     function renounceRole(bytes32 role, address account)
1176         public
1177         virtual
1178         override
1179     {
1180         require(
1181             account == _msgSender(),
1182             "AccessControl: can only renounce roles for self"
1183         );
1184 
1185         _revokeRole(role, account);
1186     }
1187 
1188     /**
1189      * @dev Grants `role` to `account`.
1190      *
1191      * If `account` had not been already granted `role`, emits a {RoleGranted}
1192      * event. Note that unlike {grantRole}, this function doesn't perform any
1193      * checks on the calling account.
1194      *
1195      * May emit a {RoleGranted} event.
1196      *
1197      * [WARNING]
1198      * ====
1199      * This function should only be called from the constructor when setting
1200      * up the initial roles for the system.
1201      *
1202      * Using this function in any other way is effectively circumventing the admin
1203      * system imposed by {AccessControl}.
1204      * ====
1205      *
1206      * NOTE: This function is deprecated in favor of {_grantRole}.
1207      */
1208     function _setupRole(bytes32 role, address account) internal virtual {
1209         _grantRole(role, account);
1210     }
1211 
1212     /**
1213      * @dev Sets `adminRole` as ``role``'s admin role.
1214      *
1215      * Emits a {RoleAdminChanged} event.
1216      */
1217     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1218         bytes32 previousAdminRole = getRoleAdmin(role);
1219         _roles[role].adminRole = adminRole;
1220         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1221     }
1222 
1223     /**
1224      * @dev Grants `role` to `account`.
1225      *
1226      * Internal function without access restriction.
1227      *
1228      * May emit a {RoleGranted} event.
1229      */
1230     function _grantRole(bytes32 role, address account) internal virtual {
1231         if (!hasRole(role, account)) {
1232             _roles[role].members[account] = true;
1233             emit RoleGranted(role, account, _msgSender());
1234         }
1235     }
1236 
1237     /**
1238      * @dev Revokes `role` from `account`.
1239      *
1240      * Internal function without access restriction.
1241      *
1242      * May emit a {RoleRevoked} event.
1243      */
1244     function _revokeRole(bytes32 role, address account) internal virtual {
1245         if (hasRole(role, account)) {
1246             _roles[role].members[account] = false;
1247             emit RoleRevoked(role, account, _msgSender());
1248         }
1249     }
1250 }
1251 
1252 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1253 
1254 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev _Available since v3.1._
1260  */
1261 interface IERC1155Receiver is IERC165 {
1262     /**
1263      * @dev Handles the receipt of a single ERC1155 token type. This function is
1264      * called at the end of a `safeTransferFrom` after the balance has been updated.
1265      *
1266      * NOTE: To accept the transfer, this must return
1267      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1268      * (i.e. 0xf23a6e61, or its own function selector).
1269      *
1270      * @param operator The address which initiated the transfer (i.e. msg.sender)
1271      * @param from The address which previously owned the token
1272      * @param id The ID of the token being transferred
1273      * @param value The amount of tokens being transferred
1274      * @param data Additional data with no specified format
1275      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1276      */
1277     function onERC1155Received(
1278         address operator,
1279         address from,
1280         uint256 id,
1281         uint256 value,
1282         bytes calldata data
1283     ) external returns (bytes4);
1284 
1285     /**
1286      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1287      * is called at the end of a `safeBatchTransferFrom` after the balances have
1288      * been updated.
1289      *
1290      * NOTE: To accept the transfer(s), this must return
1291      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1292      * (i.e. 0xbc197c81, or its own function selector).
1293      *
1294      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1295      * @param from The address which previously owned the token
1296      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1297      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1298      * @param data Additional data with no specified format
1299      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1300      */
1301     function onERC1155BatchReceived(
1302         address operator,
1303         address from,
1304         uint256[] calldata ids,
1305         uint256[] calldata values,
1306         bytes calldata data
1307     ) external returns (bytes4);
1308 }
1309 
1310 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1311 
1312 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 /**
1317  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1318  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1319  *
1320  * _Available since v3.1._
1321  */
1322 interface IERC1155 is IERC165 {
1323     /**
1324      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1325      */
1326     event TransferSingle(
1327         address indexed operator,
1328         address indexed from,
1329         address indexed to,
1330         uint256 id,
1331         uint256 value
1332     );
1333 
1334     /**
1335      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1336      * transfers.
1337      */
1338     event TransferBatch(
1339         address indexed operator,
1340         address indexed from,
1341         address indexed to,
1342         uint256[] ids,
1343         uint256[] values
1344     );
1345 
1346     /**
1347      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1348      * `approved`.
1349      */
1350     event ApprovalForAll(
1351         address indexed account,
1352         address indexed operator,
1353         bool approved
1354     );
1355 
1356     /**
1357      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1358      *
1359      * If an {URI} event was emitted for `id`, the standard
1360      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1361      * returned by {IERC1155MetadataURI-uri}.
1362      */
1363     event URI(string value, uint256 indexed id);
1364 
1365     /**
1366      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1367      *
1368      * Requirements:
1369      *
1370      * - `account` cannot be the zero address.
1371      */
1372     function balanceOf(address account, uint256 id)
1373         external
1374         view
1375         returns (uint256);
1376 
1377     /**
1378      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1379      *
1380      * Requirements:
1381      *
1382      * - `accounts` and `ids` must have the same length.
1383      */
1384     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1385         external
1386         view
1387         returns (uint256[] memory);
1388 
1389     /**
1390      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1391      *
1392      * Emits an {ApprovalForAll} event.
1393      *
1394      * Requirements:
1395      *
1396      * - `operator` cannot be the caller.
1397      */
1398     function setApprovalForAll(address operator, bool approved) external;
1399 
1400     /**
1401      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1402      *
1403      * See {setApprovalForAll}.
1404      */
1405     function isApprovedForAll(address account, address operator)
1406         external
1407         view
1408         returns (bool);
1409 
1410     /**
1411      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1412      *
1413      * Emits a {TransferSingle} event.
1414      *
1415      * Requirements:
1416      *
1417      * - `to` cannot be the zero address.
1418      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1419      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1420      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1421      * acceptance magic value.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 id,
1427         uint256 amount,
1428         bytes calldata data
1429     ) external;
1430 
1431     /**
1432      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1433      *
1434      * Emits a {TransferBatch} event.
1435      *
1436      * Requirements:
1437      *
1438      * - `ids` and `amounts` must have the same length.
1439      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1440      * acceptance magic value.
1441      */
1442     function safeBatchTransferFrom(
1443         address from,
1444         address to,
1445         uint256[] calldata ids,
1446         uint256[] calldata amounts,
1447         bytes calldata data
1448     ) external;
1449 }
1450 
1451 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1452 
1453 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 /**
1458  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1459  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1460  *
1461  * _Available since v3.1._
1462  */
1463 interface IERC1155MetadataURI is IERC1155 {
1464     /**
1465      * @dev Returns the URI for token type `id`.
1466      *
1467      * If the `\{id\}` substring is present in the URI, it must be replaced by
1468      * clients with the actual token type ID.
1469      */
1470     function uri(uint256 id) external view returns (string memory);
1471 }
1472 
1473 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1474 
1475 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1476 
1477 pragma solidity ^0.8.0;
1478 
1479 /**
1480  * @dev Implementation of the basic standard multi-token.
1481  * See https://eips.ethereum.org/EIPS/eip-1155
1482  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1483  *
1484  * _Available since v3.1._
1485  */
1486 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1487     using Address for address;
1488 
1489     // Mapping from token ID to account balances
1490     mapping(uint256 => mapping(address => uint256)) private _balances;
1491 
1492     // Mapping from account to operator approvals
1493     mapping(address => mapping(address => bool)) private _operatorApprovals;
1494 
1495     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1496     string private _uri;
1497 
1498     /**
1499      * @dev See {_setURI}.
1500      */
1501     constructor(string memory uri_) {
1502         _setURI(uri_);
1503     }
1504 
1505     /**
1506      * @dev See {IERC165-supportsInterface}.
1507      */
1508     function supportsInterface(bytes4 interfaceId)
1509         public
1510         view
1511         virtual
1512         override(ERC165, IERC165)
1513         returns (bool)
1514     {
1515         return
1516             interfaceId == type(IERC1155).interfaceId ||
1517             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1518             super.supportsInterface(interfaceId);
1519     }
1520 
1521     /**
1522      * @dev See {IERC1155MetadataURI-uri}.
1523      *
1524      * This implementation returns the same URI for *all* token types. It relies
1525      * on the token type ID substitution mechanism
1526      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1527      *
1528      * Clients calling this function must replace the `\{id\}` substring with the
1529      * actual token type ID.
1530      */
1531     function uri(uint256) public view virtual override returns (string memory) {
1532         return _uri;
1533     }
1534 
1535     /**
1536      * @dev See {IERC1155-balanceOf}.
1537      *
1538      * Requirements:
1539      *
1540      * - `account` cannot be the zero address.
1541      */
1542     function balanceOf(address account, uint256 id)
1543         public
1544         view
1545         virtual
1546         override
1547         returns (uint256)
1548     {
1549         require(
1550             account != address(0),
1551             "ERC1155: address zero is not a valid owner"
1552         );
1553         return _balances[id][account];
1554     }
1555 
1556     /**
1557      * @dev See {IERC1155-balanceOfBatch}.
1558      *
1559      * Requirements:
1560      *
1561      * - `accounts` and `ids` must have the same length.
1562      */
1563     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1564         public
1565         view
1566         virtual
1567         override
1568         returns (uint256[] memory)
1569     {
1570         require(
1571             accounts.length == ids.length,
1572             "ERC1155: accounts and ids length mismatch"
1573         );
1574 
1575         uint256[] memory batchBalances = new uint256[](accounts.length);
1576 
1577         for (uint256 i = 0; i < accounts.length; ++i) {
1578             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1579         }
1580 
1581         return batchBalances;
1582     }
1583 
1584     /**
1585      * @dev See {IERC1155-setApprovalForAll}.
1586      */
1587     function setApprovalForAll(address operator, bool approved)
1588         public
1589         virtual
1590         override
1591     {
1592         _setApprovalForAll(_msgSender(), operator, approved);
1593     }
1594 
1595     /**
1596      * @dev See {IERC1155-isApprovedForAll}.
1597      */
1598     function isApprovedForAll(address account, address operator)
1599         public
1600         view
1601         virtual
1602         override
1603         returns (bool)
1604     {
1605         return _operatorApprovals[account][operator];
1606     }
1607 
1608     /**
1609      * @dev See {IERC1155-safeTransferFrom}.
1610      */
1611     function safeTransferFrom(
1612         address from,
1613         address to,
1614         uint256 id,
1615         uint256 amount,
1616         bytes memory data
1617     ) public virtual override {
1618         require(
1619             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1620             "ERC1155: caller is not token owner nor approved"
1621         );
1622         _safeTransferFrom(from, to, id, amount, data);
1623     }
1624 
1625     /**
1626      * @dev See {IERC1155-safeBatchTransferFrom}.
1627      */
1628     function safeBatchTransferFrom(
1629         address from,
1630         address to,
1631         uint256[] memory ids,
1632         uint256[] memory amounts,
1633         bytes memory data
1634     ) public virtual override {
1635         require(
1636             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1637             "ERC1155: caller is not token owner nor approved"
1638         );
1639         _safeBatchTransferFrom(from, to, ids, amounts, data);
1640     }
1641 
1642     /**
1643      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1644      *
1645      * Emits a {TransferSingle} event.
1646      *
1647      * Requirements:
1648      *
1649      * - `to` cannot be the zero address.
1650      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1651      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1652      * acceptance magic value.
1653      */
1654     function _safeTransferFrom(
1655         address from,
1656         address to,
1657         uint256 id,
1658         uint256 amount,
1659         bytes memory data
1660     ) internal virtual {
1661         require(to != address(0), "ERC1155: transfer to the zero address");
1662 
1663         address operator = _msgSender();
1664         uint256[] memory ids = _asSingletonArray(id);
1665         uint256[] memory amounts = _asSingletonArray(amount);
1666 
1667         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1668 
1669         uint256 fromBalance = _balances[id][from];
1670         require(
1671             fromBalance >= amount,
1672             "ERC1155: insufficient balance for transfer"
1673         );
1674         unchecked {
1675             _balances[id][from] = fromBalance - amount;
1676         }
1677         _balances[id][to] += amount;
1678 
1679         emit TransferSingle(operator, from, to, id, amount);
1680 
1681         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1682 
1683         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1684     }
1685 
1686     /**
1687      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1688      *
1689      * Emits a {TransferBatch} event.
1690      *
1691      * Requirements:
1692      *
1693      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1694      * acceptance magic value.
1695      */
1696     function _safeBatchTransferFrom(
1697         address from,
1698         address to,
1699         uint256[] memory ids,
1700         uint256[] memory amounts,
1701         bytes memory data
1702     ) internal virtual {
1703         require(
1704             ids.length == amounts.length,
1705             "ERC1155: ids and amounts length mismatch"
1706         );
1707         require(to != address(0), "ERC1155: transfer to the zero address");
1708 
1709         address operator = _msgSender();
1710 
1711         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1712 
1713         for (uint256 i = 0; i < ids.length; ++i) {
1714             uint256 id = ids[i];
1715             uint256 amount = amounts[i];
1716 
1717             uint256 fromBalance = _balances[id][from];
1718             require(
1719                 fromBalance >= amount,
1720                 "ERC1155: insufficient balance for transfer"
1721             );
1722             unchecked {
1723                 _balances[id][from] = fromBalance - amount;
1724             }
1725             _balances[id][to] += amount;
1726         }
1727 
1728         emit TransferBatch(operator, from, to, ids, amounts);
1729 
1730         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1731 
1732         _doSafeBatchTransferAcceptanceCheck(
1733             operator,
1734             from,
1735             to,
1736             ids,
1737             amounts,
1738             data
1739         );
1740     }
1741 
1742     /**
1743      * @dev Sets a new URI for all token types, by relying on the token type ID
1744      * substitution mechanism
1745      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1746      *
1747      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1748      * URI or any of the amounts in the JSON file at said URI will be replaced by
1749      * clients with the token type ID.
1750      *
1751      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1752      * interpreted by clients as
1753      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1754      * for token type ID 0x4cce0.
1755      *
1756      * See {uri}.
1757      *
1758      * Because these URIs cannot be meaningfully represented by the {URI} event,
1759      * this function emits no events.
1760      */
1761     function _setURI(string memory newuri) internal virtual {
1762         _uri = newuri;
1763     }
1764 
1765     /**
1766      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1767      *
1768      * Emits a {TransferSingle} event.
1769      *
1770      * Requirements:
1771      *
1772      * - `to` cannot be the zero address.
1773      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1774      * acceptance magic value.
1775      */
1776     function _mint(
1777         address to,
1778         uint256 id,
1779         uint256 amount,
1780         bytes memory data
1781     ) internal virtual {
1782         require(to != address(0), "ERC1155: mint to the zero address");
1783 
1784         address operator = _msgSender();
1785         uint256[] memory ids = _asSingletonArray(id);
1786         uint256[] memory amounts = _asSingletonArray(amount);
1787 
1788         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1789 
1790         _balances[id][to] += amount;
1791         emit TransferSingle(operator, address(0), to, id, amount);
1792 
1793         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1794 
1795         _doSafeTransferAcceptanceCheck(
1796             operator,
1797             address(0),
1798             to,
1799             id,
1800             amount,
1801             data
1802         );
1803     }
1804 
1805     /**
1806      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1807      *
1808      * Emits a {TransferBatch} event.
1809      *
1810      * Requirements:
1811      *
1812      * - `ids` and `amounts` must have the same length.
1813      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1814      * acceptance magic value.
1815      */
1816     function _mintBatch(
1817         address to,
1818         uint256[] memory ids,
1819         uint256[] memory amounts,
1820         bytes memory data
1821     ) internal virtual {
1822         require(to != address(0), "ERC1155: mint to the zero address");
1823         require(
1824             ids.length == amounts.length,
1825             "ERC1155: ids and amounts length mismatch"
1826         );
1827 
1828         address operator = _msgSender();
1829 
1830         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1831 
1832         for (uint256 i = 0; i < ids.length; i++) {
1833             _balances[ids[i]][to] += amounts[i];
1834         }
1835 
1836         emit TransferBatch(operator, address(0), to, ids, amounts);
1837 
1838         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1839 
1840         _doSafeBatchTransferAcceptanceCheck(
1841             operator,
1842             address(0),
1843             to,
1844             ids,
1845             amounts,
1846             data
1847         );
1848     }
1849 
1850     /**
1851      * @dev Destroys `amount` tokens of token type `id` from `from`
1852      *
1853      * Emits a {TransferSingle} event.
1854      *
1855      * Requirements:
1856      *
1857      * - `from` cannot be the zero address.
1858      * - `from` must have at least `amount` tokens of token type `id`.
1859      */
1860     function _burn(
1861         address from,
1862         uint256 id,
1863         uint256 amount
1864     ) internal virtual {
1865         require(from != address(0), "ERC1155: burn from the zero address");
1866 
1867         address operator = _msgSender();
1868         uint256[] memory ids = _asSingletonArray(id);
1869         uint256[] memory amounts = _asSingletonArray(amount);
1870 
1871         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1872 
1873         uint256 fromBalance = _balances[id][from];
1874         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1875         unchecked {
1876             _balances[id][from] = fromBalance - amount;
1877         }
1878 
1879         emit TransferSingle(operator, from, address(0), id, amount);
1880 
1881         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1882     }
1883 
1884     /**
1885      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1886      *
1887      * Emits a {TransferBatch} event.
1888      *
1889      * Requirements:
1890      *
1891      * - `ids` and `amounts` must have the same length.
1892      */
1893     function _burnBatch(
1894         address from,
1895         uint256[] memory ids,
1896         uint256[] memory amounts
1897     ) internal virtual {
1898         require(from != address(0), "ERC1155: burn from the zero address");
1899         require(
1900             ids.length == amounts.length,
1901             "ERC1155: ids and amounts length mismatch"
1902         );
1903 
1904         address operator = _msgSender();
1905 
1906         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1907 
1908         for (uint256 i = 0; i < ids.length; i++) {
1909             uint256 id = ids[i];
1910             uint256 amount = amounts[i];
1911 
1912             uint256 fromBalance = _balances[id][from];
1913             require(
1914                 fromBalance >= amount,
1915                 "ERC1155: burn amount exceeds balance"
1916             );
1917             unchecked {
1918                 _balances[id][from] = fromBalance - amount;
1919             }
1920         }
1921 
1922         emit TransferBatch(operator, from, address(0), ids, amounts);
1923 
1924         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1925     }
1926 
1927     /**
1928      * @dev Approve `operator` to operate on all of `owner` tokens
1929      *
1930      * Emits an {ApprovalForAll} event.
1931      */
1932     function _setApprovalForAll(
1933         address owner,
1934         address operator,
1935         bool approved
1936     ) internal virtual {
1937         require(owner != operator, "ERC1155: setting approval status for self");
1938         _operatorApprovals[owner][operator] = approved;
1939         emit ApprovalForAll(owner, operator, approved);
1940     }
1941 
1942     /**
1943      * @dev Hook that is called before any token transfer. This includes minting
1944      * and burning, as well as batched variants.
1945      *
1946      * The same hook is called on both single and batched variants. For single
1947      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1948      *
1949      * Calling conditions (for each `id` and `amount` pair):
1950      *
1951      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1952      * of token type `id` will be  transferred to `to`.
1953      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1954      * for `to`.
1955      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1956      * will be burned.
1957      * - `from` and `to` are never both zero.
1958      * - `ids` and `amounts` have the same, non-zero length.
1959      *
1960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1961      */
1962     function _beforeTokenTransfer(
1963         address operator,
1964         address from,
1965         address to,
1966         uint256[] memory ids,
1967         uint256[] memory amounts,
1968         bytes memory data
1969     ) internal virtual {}
1970 
1971     /**
1972      * @dev Hook that is called after any token transfer. This includes minting
1973      * and burning, as well as batched variants.
1974      *
1975      * The same hook is called on both single and batched variants. For single
1976      * transfers, the length of the `id` and `amount` arrays will be 1.
1977      *
1978      * Calling conditions (for each `id` and `amount` pair):
1979      *
1980      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1981      * of token type `id` will be  transferred to `to`.
1982      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1983      * for `to`.
1984      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1985      * will be burned.
1986      * - `from` and `to` are never both zero.
1987      * - `ids` and `amounts` have the same, non-zero length.
1988      *
1989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1990      */
1991     function _afterTokenTransfer(
1992         address operator,
1993         address from,
1994         address to,
1995         uint256[] memory ids,
1996         uint256[] memory amounts,
1997         bytes memory data
1998     ) internal virtual {}
1999 
2000     function _doSafeTransferAcceptanceCheck(
2001         address operator,
2002         address from,
2003         address to,
2004         uint256 id,
2005         uint256 amount,
2006         bytes memory data
2007     ) private {
2008         if (to.isContract()) {
2009             try
2010                 IERC1155Receiver(to).onERC1155Received(
2011                     operator,
2012                     from,
2013                     id,
2014                     amount,
2015                     data
2016                 )
2017             returns (bytes4 response) {
2018                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2019                     revert("ERC1155: ERC1155Receiver rejected tokens");
2020                 }
2021             } catch Error(string memory reason) {
2022                 revert(reason);
2023             } catch {
2024                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2025             }
2026         }
2027     }
2028 
2029     function _doSafeBatchTransferAcceptanceCheck(
2030         address operator,
2031         address from,
2032         address to,
2033         uint256[] memory ids,
2034         uint256[] memory amounts,
2035         bytes memory data
2036     ) private {
2037         if (to.isContract()) {
2038             try
2039                 IERC1155Receiver(to).onERC1155BatchReceived(
2040                     operator,
2041                     from,
2042                     ids,
2043                     amounts,
2044                     data
2045                 )
2046             returns (bytes4 response) {
2047                 if (
2048                     response != IERC1155Receiver.onERC1155BatchReceived.selector
2049                 ) {
2050                     revert("ERC1155: ERC1155Receiver rejected tokens");
2051                 }
2052             } catch Error(string memory reason) {
2053                 revert(reason);
2054             } catch {
2055                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2056             }
2057         }
2058     }
2059 
2060     function _asSingletonArray(uint256 element)
2061         private
2062         pure
2063         returns (uint256[] memory)
2064     {
2065         uint256[] memory array = new uint256[](1);
2066         array[0] = element;
2067 
2068         return array;
2069     }
2070 }
2071 
2072 // File: contracts/Pod.sol
2073 
2074 pragma solidity ^0.8.16;
2075 
2076 contract Asset {
2077     function fatesAssetTransfer(uint256 _id, address _to) public {}
2078 }
2079 
2080 contract Pod is
2081     ERC1155,
2082     AccessControl,
2083     Ownable,
2084     RevokableDefaultOperatorFilterer,
2085     ERC2981ContractWideRoyalties
2086 {
2087     string public name; // Token name.
2088     string public symbol; // Shorthand identifer.
2089     string public contractURI_; // Link to contract-level metadata.
2090     string public baseURI; // Base domain.
2091     string public launchedURI; // Launched token's metadata.
2092     string public unlaunchedURI; // Unlaunched token's metadata.
2093     uint256 public royalty; // Royalty % 10000 = 100%.
2094     uint256 public expiry = 3600;
2095     bool public paused = false; // Revert calls to critical funcs.
2096     bool internal locked; // Switch to prevent reentrancy attack.
2097 
2098     struct TokenIds {
2099         uint256 aId;
2100         uint256 cId;
2101         uint256 expiresAt;
2102         bool listed;
2103     }
2104 
2105     // Stop >1 of same address per allowlist slot
2106     mapping(address => bool) public allowlistValve;
2107     // Tokens requiring unique IDs.
2108     mapping(uint256 => bool) public uid;
2109     // Mapping Pod IDs to corresponding pilot addresses.
2110     mapping(uint256 => address) public allowList;
2111     // Prevent >1 token per pilot.
2112     mapping(address => bool) public launchClearance;
2113     // Mapping Pod assigned pilots to exodus assets.
2114     mapping(address => TokenIds) launchList;
2115     // Pod state tracker.
2116     mapping(uint256 => bool) private launchStatus;
2117 
2118     // Contracts Pod will interact with.
2119     Asset private astrContract;
2120     Asset private charContract;
2121 
2122     // Distributor role.
2123     bytes32 public constant DISTRIBUTOR = keccak256("DISTRIBUTOR");
2124 
2125     constructor(
2126         address _root,
2127         address _distributor,
2128         address _astrContract,
2129         address _charContract,
2130         string memory _name,
2131         string memory _symbol,
2132         string memory _contractURI,
2133         string memory _baseURI,
2134         string memory _launchedURI,
2135         string memory _unlaunchedURI,
2136         uint256 _royalty
2137     ) ERC1155(baseURI) {
2138         _setupRole(DEFAULT_ADMIN_ROLE, _root);
2139         _setupRole(DISTRIBUTOR, _distributor);
2140         name = _name;
2141         symbol = _symbol;
2142         contractURI_ = _contractURI;
2143         baseURI = _baseURI;
2144         launchedURI = _launchedURI;
2145         unlaunchedURI = _unlaunchedURI;
2146         royalty = _royalty;
2147         astrContract = Asset(_astrContract);
2148         charContract = Asset(_charContract);
2149     }
2150 
2151     /*
2152      * @dev
2153      *      Modifier restricts func calls to addresses under admin role only.
2154      */
2155     modifier onlyAdmin() {
2156         require(
2157             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
2158             "Restricted to admins."
2159         );
2160         _;
2161     }
2162 
2163     /*
2164      * @dev
2165      *      Modifier used to lock external functions until fully executed.
2166      */
2167     modifier noReentrant() {
2168         require(!locked, "No recursive calls.");
2169         locked = true;
2170         _;
2171         locked = false;
2172     }
2173 
2174     /*
2175      * @dev
2176      *      Write contract activity switch.
2177      * @params
2178      *      _paused - Boolean state change.
2179      */
2180     function setPaused(bool _paused) external onlyAdmin {
2181         paused = _paused;
2182     }
2183 
2184     /*
2185      * @dev
2186      *      Read collection-level metadata.
2187      */
2188     /*     function getContractURI() public view returns (string memory) {
2189         return contractURI;
2190     } */
2191 
2192     function contractURI() public view returns (string memory) {
2193         return contractURI_;
2194     }
2195 
2196     /*
2197      * @dev
2198      *      Write collection-level metadata.
2199      * @params
2200      *      _uri - Link to contract JSON metadata.
2201      */
2202     function setContractURI(string memory _contracturi) external onlyAdmin {
2203         contractURI_ = _contracturi;
2204     }
2205 
2206     /*
2207      * @dev
2208      *      Set expiry time for buying a token.
2209      */
2210     function setExpiry(uint256 _expiry) external onlyAdmin {
2211         expiry = _expiry;
2212     }
2213 
2214     /*
2215      * @dev
2216      *      Read royalty fee set.
2217      */
2218     function getRoyaltyFee() public view returns (uint256) {
2219         return royalty;
2220     }
2221 
2222     /*
2223      * @dev
2224      *      Write royalty fee.
2225      * @params
2226      *      _recipient - Target address to receive the royalty fee.
2227      *      _value - Basis point royalty %.
2228      */
2229     function setRoyalties(address _recipient, uint256 _value)
2230         external
2231         onlyAdmin
2232     {
2233         _setRoyalties(_recipient, _value);
2234     }
2235 
2236     /*
2237      * @dev
2238      *      Add pilot address to the allowList against token ID.
2239      * @params
2240      *      _id - ID of tokens to be minted.
2241      *      _pilot - Pilot to allow listed.
2242      */
2243     function addToAllowList(uint256 _id, address _pilot)
2244         external
2245         onlyRole(DISTRIBUTOR)
2246     {
2247         // Pod must not already have been claimed.
2248         require(uid[_id] == false, "Pod already claimed.");
2249         // Pilot must not have already been allocated a Pod.
2250         require(
2251             allowlistValve[_pilot] == false,
2252             "Address already allocated a Pod."
2253         );
2254         // No more than once whilst on allow list at any one time.
2255         allowlistValve[_pilot] = true;
2256         // Add to allow list.
2257         allowList[_id] = _pilot;
2258     }
2259 
2260     /*
2261      * @dev
2262      *      Remove pilot address from the allow list against token ID.
2263      *      Also resets the pilot to be able to engage in the evac process again.
2264      * @params
2265      *      _id - ID of tokens to be minted.
2266      *      _pilot - Pilot to allow listed.
2267      */
2268     function removeFromAllowList(uint256 _id, address _pilot)
2269         external
2270         onlyRole(DISTRIBUTOR)
2271     {
2272         require(allowlistValve[_pilot] == true, "Address not allocated a Pod.");
2273         allowlistValve[_pilot] = false;
2274         delete allowList[_id];
2275     }
2276 
2277     /*
2278      * @dev
2279      *      Check an account is on the allowList.
2280      */
2281     function isAllowListed(uint256 _id, address _pilot)
2282         public
2283         view
2284         returns (bool)
2285     {
2286         bool pilotIsAllowListed = false;
2287         if (allowList[_id] == _pilot) {
2288             pilotIsAllowListed = true;
2289         }
2290         return pilotIsAllowListed;
2291     }
2292 
2293     /*
2294      * @dev
2295      *      Distribute token to pilot address.
2296      * @params
2297      *      _id - ID of tokens to be minted.
2298      */
2299 
2300     // Claim Pod.
2301     function evacPodClaim(uint256 _id) external noReentrant {
2302         // Required on public funcs that alter state.
2303         require(!paused, "Exodus is on hold.");
2304 
2305         // Pod must be non-fungible.
2306         require(uid[_id] == false, "Pod already claimed.");
2307 
2308         address pilot = msg.sender;
2309         // Pilot must be on allowListed for token id.
2310         require(allowList[_id] == pilot, "Address is not listed for this Pod.");
2311         // Ensure pilot address has not launched.
2312         require(launchClearance[pilot] == false, "Address already owns a Pod.");
2313 
2314         // Pilot now cleared for launch.
2315         launchClearance[pilot] = true;
2316 
2317         // Pod ID claimed.
2318         uid[_id] = true;
2319 
2320         // Allocate to pilot.
2321         _mint(pilot, _id, 1, bytes(""));
2322     }
2323 
2324     /*
2325      * @dev
2326      *      Add pilot to launch list.
2327      */
2328     function addToLaunchList(
2329         address _pilot,
2330         uint256 _charId,
2331         uint256 _astrId
2332     ) external onlyRole(DISTRIBUTOR) {
2333         // Ensure pilot address has not launched.
2334         require(launchClearance[_pilot] == true, "Address doesn't own a Pod.");
2335 
2336         // Ensures the same pilot cannot be allocated twice.
2337         require(
2338             launchList[_pilot].listed == false,
2339             "Address doesn't own a Pod."
2340         );
2341 
2342         launchList[_pilot] = TokenIds(
2343             _astrId,
2344             _charId,
2345             block.timestamp + expiry,
2346             true
2347         );
2348     }
2349 
2350     /*
2351      * @dev
2352      *      Remove pilot addresses from the allowList against token IDs.
2353      */
2354     function removeFromLaunchList(address _pilot)
2355         external
2356         onlyRole(DISTRIBUTOR)
2357     {
2358         delete launchList[_pilot];
2359     }
2360 
2361     /*
2362      * @dev
2363      *      Check an account is on the allowList.
2364      */
2365     function isLaunchListed(address _pilot) public view returns (bool) {
2366         bool pilotLaunchListed = false;
2367 
2368         if (
2369             launchList[_pilot].listed == true &&
2370             block.timestamp <= launchList[_pilot].expiresAt
2371         ) {
2372             pilotLaunchListed = true;
2373         }
2374         return pilotLaunchListed;
2375     }
2376 
2377     /*
2378      * @dev
2379      *       Set pilot's launch clearance.
2380      * @params
2381      *      _pilot - Pilot to set.
2382      *      _clearance - Cleard to launch or not.
2383      */
2384     function setLaunchClearance(address _pilot, bool _clearance)
2385         external
2386         onlyRole(DISTRIBUTOR)
2387     {
2388         launchClearance[_pilot] = _clearance;
2389     }
2390 
2391     /*
2392      * @dev
2393      *      Launch Pod.
2394      * @params
2395      *      _id - Ids of pod to launch.
2396      */
2397     function _launchPod(uint256 _id) private {
2398         require(!launchStatus[_id]);
2399         launchStatus[_id] = true;
2400     }
2401 
2402     /*
2403      * @dev
2404      *      Launch Pod, simultaneously allocating correspoinding assets.
2405      * @params
2406      *      _podId - Id of pod to launch.
2407      *      _charId - Id of character to allocate.
2408      *      _astrId - Id of asteroid to allocate.
2409      */
2410     function evacPodLaunch(
2411         uint256 _podId,
2412         uint256 _charId,
2413         uint256 _astrId
2414     ) external noReentrant {
2415         // Required on public funcs that alter state.
2416         require(!paused, "Exodus is on hold.");
2417 
2418         address pilot = msg.sender;
2419 
2420         // launchList IDs must match pilots assigned _astrId and _charId.
2421         require(
2422             launchList[pilot].aId == _astrId,
2423             "Asteroid not assigned to pilot."
2424         );
2425         require(
2426             launchList[pilot].cId == _charId,
2427             "Character not assigned to pilot."
2428         );
2429         // launchList entry must not have expired.
2430         require(
2431             block.timestamp <= launchList[pilot].expiresAt,
2432             "List entry expired."
2433         );
2434 
2435         // Check Pilot is cleared for launch.
2436         require(
2437             launchClearance[pilot] == true,
2438             "Pod is not cleared for launch."
2439         );
2440         require(launchStatus[_podId] == false, "Failure to launch.");
2441 
2442         _launchPod(_podId);
2443         astrContract.fatesAssetTransfer(_astrId, pilot);
2444         charContract.fatesAssetTransfer(_charId, pilot);
2445     }
2446 
2447     /*
2448      * @dev
2449      *      Check a Pod's launch status.
2450      * @params
2451      *      _id - Id of pod.
2452      */
2453     function hasLaunched(uint256 _id) public view returns (bool) {
2454         return launchStatus[_id];
2455     }
2456 
2457     /*
2458      * @dev
2459      *      Read the URI to a Pod's metadata.
2460      * @params
2461      *      _id - Id of pod.
2462      */
2463     function uri(uint256 _id) public view override returns (string memory) {
2464         if (launchStatus[_id] == true) {
2465             return string(abi.encodePacked(baseURI, launchedURI));
2466         }
2467         return string(abi.encodePacked(baseURI, unlaunchedURI));
2468     }
2469 
2470     /*
2471      * @dev
2472      *      Write the base URI to a Pod's metadata.
2473      * @params
2474      *      _uri - Base domain (w/o trailing slash).
2475      */
2476     function setBaseURI(string memory _baseuri) external onlyAdmin {
2477         baseURI = _baseuri;
2478     }
2479 
2480     /*
2481      * @dev
2482      *      Write the launched URI to a Pod's metadata.
2483      *      Note: Can use the ERC1155 {id}, per-token substitution.
2484      * @params
2485      *      _suffix - Suffix link to launched state metadata JSON file (with trailing slash).
2486      */
2487     function setLaunchedURI(string memory _suffix) external onlyAdmin {
2488         launchedURI = _suffix;
2489     }
2490 
2491     /*
2492      * @dev
2493      *      Write the launched URI to a Pod's metadata.
2494      *      Note: Can use the ERC1155 {id}, per-token substitution.
2495      * @params
2496      *      _suffix - Suffix link to unlaunched state metadata JSON file (with trailing slash).
2497      */
2498     function setUnLaunchedURI(string memory _suffix) external onlyAdmin {
2499         unlaunchedURI = _suffix;
2500     }
2501 
2502     /*
2503      * @dev
2504      *      Ensure marketplaces don't bypass creator royalty.
2505      */
2506     function setApprovalForAll(address operator, bool approved)
2507         public
2508         override
2509         onlyAllowedOperatorApproval(operator)
2510     {
2511         super.setApprovalForAll(operator, approved);
2512     }
2513 
2514     function safeTransferFrom(
2515         address from,
2516         address to,
2517         uint256 tokenId,
2518         uint256 amount,
2519         bytes memory data
2520     ) public override onlyAllowedOperator(from) {
2521         super.safeTransferFrom(from, to, tokenId, amount, data);
2522     }
2523 
2524     function safeBatchTransferFrom(
2525         address from,
2526         address to,
2527         uint256[] memory ids,
2528         uint256[] memory amounts,
2529         bytes memory data
2530     ) public virtual override onlyAllowedOperator(from) {
2531         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2532     }
2533 
2534     function owner()
2535         public
2536         view
2537         virtual
2538         override(Ownable, RevokableOperatorFilterer)
2539         returns (address)
2540     {
2541         return Ownable.owner();
2542     }
2543 
2544     function supportsInterface(bytes4 interfaceId)
2545         public
2546         view
2547         virtual
2548         override(ERC1155, AccessControl, ERC2981Base)
2549         returns (bool)
2550     {
2551         return super.supportsInterface(interfaceId);
2552     }
2553 }