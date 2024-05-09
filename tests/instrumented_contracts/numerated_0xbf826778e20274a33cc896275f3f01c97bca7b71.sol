1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
5 ░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░
6 ░░░░░░░░░░░░░░░░░░░░░░      ░░░░░░░░░░░░░░░░░░░░░░░
7 ░░░░░░░░░░░░░░░░░░░░░        ░░░░░░░░░░░░░░░░░░░░░░
8 ░░░░░░░░░░░░░░░░░░░            ░░░░░░░░░░░░░░░░░░░░
9 ░░░░░░░░░░░░░░░░░░              ░░░░░░░░░░░░░░░░░░░
10 ░░░░░░░░░░░░░░░░░                ░░░░░░░░░░░░░░░░░░
11 ░░░░░░░░░░░░░░░░░░░░░        ░░░░░░░░░░░░░░░░░░░░░░
12 ░░░░░░░░░░░░░        ░░░░░░░░        ░░░░░░░░░░░░░░
13 ░░░░░░░░░░░░            ░░            ░░░░░░░░░░░░░
14 ░░░░░░░░░░░             ░░              ░░░░░░░░░░░
15 ░░░░░░░░░░              ░░               ░░░░░░░░░░
16 ░░░░░░░░░              ░░░░               ░░░░░░░░░
17 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
18 ░░░░░░█▀▀░░░░░░█▀█░░░░░░▀█▀░░░░░░█▀▀░░░░░░█▀▀░░░░░░
19 ░░░░░░█▀▀░░░░░░█▀█░░░░░░░█░░░░░░░█▀▀░░░░░░▀▀█░░░░░░
20 ░░░░░░▀░░░░░░░░▀░▀░░░░░░░▀░░░░░░░▀▀▀░░░░░░▀▀▀░░░░░░
21 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
22 ░░░░░░░             Asset v1.0.6            ░░░░░░░
23 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
24 */
25 
26 // File: contracts/IERC2981Royalties.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /// @title IERC2981Royalties
31 /// @dev Interface for the ERC2981 - Token Royalty standard
32 interface IERC2981Royalties {
33     /// @notice Called with the sale price to determine how much royalty
34     //          is owed and to whom.
35     /// @param _tokenId - the NFT asset queried for royalty information
36     /// @param _value - the sale price of the NFT asset specified by _tokenId
37     /// @return _receiver - address of who should be sent the royalty payment
38     /// @return _royaltyAmount - the royalty payment amount for value sale price
39     function royaltyInfo(uint256 _tokenId, uint256 _value)
40         external
41         view
42         returns (address _receiver, uint256 _royaltyAmount);
43 }
44 // File: contracts/IOperatorFilterRegistry.sol
45 
46 pragma solidity ^0.8.13;
47 
48 interface IOperatorFilterRegistry {
49     function isOperatorAllowed(address registrant, address operator)
50         external
51         view
52         returns (bool);
53 
54     function register(address registrant) external;
55 
56     function registerAndSubscribe(address registrant, address subscription)
57         external;
58 
59     function registerAndCopyEntries(
60         address registrant,
61         address registrantToCopy
62     ) external;
63 
64     function unregister(address addr) external;
65 
66     function updateOperator(
67         address registrant,
68         address operator,
69         bool filtered
70     ) external;
71 
72     function updateOperators(
73         address registrant,
74         address[] calldata operators,
75         bool filtered
76     ) external;
77 
78     function updateCodeHash(
79         address registrant,
80         bytes32 codehash,
81         bool filtered
82     ) external;
83 
84     function updateCodeHashes(
85         address registrant,
86         bytes32[] calldata codeHashes,
87         bool filtered
88     ) external;
89 
90     function subscribe(address registrant, address registrantToSubscribe)
91         external;
92 
93     function unsubscribe(address registrant, bool copyExistingEntries) external;
94 
95     function subscriptionOf(address addr) external returns (address registrant);
96 
97     function subscribers(address registrant)
98         external
99         returns (address[] memory);
100 
101     function subscriberAt(address registrant, uint256 index)
102         external
103         returns (address);
104 
105     function copyEntriesOf(address registrant, address registrantToCopy)
106         external;
107 
108     function isOperatorFiltered(address registrant, address operator)
109         external
110         returns (bool);
111 
112     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
113         external
114         returns (bool);
115 
116     function isCodeHashFiltered(address registrant, bytes32 codeHash)
117         external
118         returns (bool);
119 
120     function filteredOperators(address addr)
121         external
122         returns (address[] memory);
123 
124     function filteredCodeHashes(address addr)
125         external
126         returns (bytes32[] memory);
127 
128     function filteredOperatorAt(address registrant, uint256 index)
129         external
130         returns (address);
131 
132     function filteredCodeHashAt(address registrant, uint256 index)
133         external
134         returns (bytes32);
135 
136     function isRegistered(address addr) external returns (bool);
137 
138     function codeHashOf(address addr) external returns (bytes32);
139 }
140 
141 // File: contracts/OperatorFilterer.sol
142 
143 pragma solidity ^0.8.13;
144 
145 /**
146  * @title  OperatorFilterer
147  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
148  *         registrant's entries in the OperatorFilterRegistry.
149  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
150  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
151  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
152  */
153 abstract contract OperatorFilterer {
154     error OperatorNotAllowed(address operator);
155 
156     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
157         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
158 
159     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
160         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
161         // will not revert, but the contract will need to be registered with the registry once it is deployed in
162         // order for the modifier to filter addresses.
163         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
164             if (subscribe) {
165                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
166                     address(this),
167                     subscriptionOrRegistrantToCopy
168                 );
169             } else {
170                 if (subscriptionOrRegistrantToCopy != address(0)) {
171                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
172                         address(this),
173                         subscriptionOrRegistrantToCopy
174                     );
175                 } else {
176                     OPERATOR_FILTER_REGISTRY.register(address(this));
177                 }
178             }
179         }
180     }
181 
182     modifier onlyAllowedOperator(address from) virtual {
183         // Check registry code length to facilitate testing in environments without a deployed registry.
184         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
185             // Allow spending tokens from addresses with balance
186             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
187             // from an EOA.
188             if (from == msg.sender) {
189                 _;
190                 return;
191             }
192             if (
193                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
194                     address(this),
195                     msg.sender
196                 )
197             ) {
198                 revert OperatorNotAllowed(msg.sender);
199             }
200         }
201         _;
202     }
203 
204     modifier onlyAllowedOperatorApproval(address operator) virtual {
205         // Check registry code length to facilitate testing in environments without a deployed registry.
206         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
207             if (
208                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
209                     address(this),
210                     operator
211                 )
212             ) {
213                 revert OperatorNotAllowed(operator);
214             }
215         }
216         _;
217     }
218 }
219 // File: contracts/RevokableOperatorFilterer.sol
220 
221 pragma solidity ^0.8.13;
222 
223 /**
224  * @title  RevokableOperatorFilterer
225  * @notice This contract is meant to allow contracts to permanently opt out of the OperatorFilterRegistry. The Registry
226  *         itself has an "unregister" function, but if the contract is ownable, the owner can re-register at any point.
227  *         As implemented, this abstract contract allows the contract owner to toggle the
228  *         isOperatorFilterRegistryRevoked flag in order to permanently bypass the OperatorFilterRegistry checks.
229  */
230 abstract contract RevokableOperatorFilterer is OperatorFilterer {
231     error OnlyOwner();
232     error AlreadyRevoked();
233 
234     bool private _isOperatorFilterRegistryRevoked;
235 
236     modifier onlyAllowedOperator(address from) override {
237         // Check registry code length to facilitate testing in environments without a deployed registry.
238         if (
239             !_isOperatorFilterRegistryRevoked &&
240             address(OPERATOR_FILTER_REGISTRY).code.length > 0
241         ) {
242             // Allow spending tokens from addresses with balance
243             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
244             // from an EOA.
245             if (from == msg.sender) {
246                 _;
247                 return;
248             }
249             if (
250                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
251                     address(this),
252                     msg.sender
253                 )
254             ) {
255                 revert OperatorNotAllowed(msg.sender);
256             }
257         }
258         _;
259     }
260 
261     modifier onlyAllowedOperatorApproval(address operator) override {
262         // Check registry code length to facilitate testing in environments without a deployed registry.
263         if (
264             !_isOperatorFilterRegistryRevoked &&
265             address(OPERATOR_FILTER_REGISTRY).code.length > 0
266         ) {
267             if (
268                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
269                     address(this),
270                     operator
271                 )
272             ) {
273                 revert OperatorNotAllowed(operator);
274             }
275         }
276         _;
277     }
278 
279     /**
280      * @notice Disable the isOperatorFilterRegistryRevoked flag. OnlyOwner.
281      */
282     function revokeOperatorFilterRegistry() external {
283         if (msg.sender != owner()) {
284             revert OnlyOwner();
285         }
286         if (_isOperatorFilterRegistryRevoked) {
287             revert AlreadyRevoked();
288         }
289         _isOperatorFilterRegistryRevoked = true;
290     }
291 
292     function isOperatorFilterRegistryRevoked() public view returns (bool) {
293         return _isOperatorFilterRegistryRevoked;
294     }
295 
296     /**
297      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
298      */
299     function owner() public view virtual returns (address);
300 }
301 // File: contracts/RevokableDefaultOperatorFilterer.sol
302 
303 pragma solidity ^0.8.13;
304 
305 /**
306  * @title  RevokableDefaultOperatorFilterer
307  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
308  */
309 abstract contract RevokableDefaultOperatorFilterer is
310     RevokableOperatorFilterer
311 {
312     address constant DEFAULT_SUBSCRIPTION =
313         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
314 
315     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
316 }
317 // File: @openzeppelin/contracts/utils/Strings.sol
318 
319 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev String operations.
325  */
326 library Strings {
327     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
328     uint8 private constant _ADDRESS_LENGTH = 20;
329 
330     /**
331      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
332      */
333     function toString(uint256 value) internal pure returns (string memory) {
334         // Inspired by OraclizeAPI's implementation - MIT licence
335         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
336 
337         if (value == 0) {
338             return "0";
339         }
340         uint256 temp = value;
341         uint256 digits;
342         while (temp != 0) {
343             digits++;
344             temp /= 10;
345         }
346         bytes memory buffer = new bytes(digits);
347         while (value != 0) {
348             digits -= 1;
349             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
350             value /= 10;
351         }
352         return string(buffer);
353     }
354 
355     /**
356      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
357      */
358     function toHexString(uint256 value) internal pure returns (string memory) {
359         if (value == 0) {
360             return "0x00";
361         }
362         uint256 temp = value;
363         uint256 length = 0;
364         while (temp != 0) {
365             length++;
366             temp >>= 8;
367         }
368         return toHexString(value, length);
369     }
370 
371     /**
372      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
373      */
374     function toHexString(uint256 value, uint256 length)
375         internal
376         pure
377         returns (string memory)
378     {
379         bytes memory buffer = new bytes(2 * length + 2);
380         buffer[0] = "0";
381         buffer[1] = "x";
382         for (uint256 i = 2 * length + 1; i > 1; --i) {
383             buffer[i] = _HEX_SYMBOLS[value & 0xf];
384             value >>= 4;
385         }
386         require(value == 0, "Strings: hex length insufficient");
387         return string(buffer);
388     }
389 
390     /**
391      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
392      */
393     function toHexString(address addr) internal pure returns (string memory) {
394         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
395     }
396 }
397 
398 // File: @openzeppelin/contracts/access/IAccessControl.sol
399 
400 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev External interface of AccessControl declared to support ERC165 detection.
406  */
407 interface IAccessControl {
408     /**
409      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
410      *
411      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
412      * {RoleAdminChanged} not being emitted signaling this.
413      *
414      * _Available since v3.1._
415      */
416     event RoleAdminChanged(
417         bytes32 indexed role,
418         bytes32 indexed previousAdminRole,
419         bytes32 indexed newAdminRole
420     );
421 
422     /**
423      * @dev Emitted when `account` is granted `role`.
424      *
425      * `sender` is the account that originated the contract call, an admin role
426      * bearer except when using {AccessControl-_setupRole}.
427      */
428     event RoleGranted(
429         bytes32 indexed role,
430         address indexed account,
431         address indexed sender
432     );
433 
434     /**
435      * @dev Emitted when `account` is revoked `role`.
436      *
437      * `sender` is the account that originated the contract call:
438      *   - if using `revokeRole`, it is the admin role bearer
439      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
440      */
441     event RoleRevoked(
442         bytes32 indexed role,
443         address indexed account,
444         address indexed sender
445     );
446 
447     /**
448      * @dev Returns `true` if `account` has been granted `role`.
449      */
450     function hasRole(bytes32 role, address account)
451         external
452         view
453         returns (bool);
454 
455     /**
456      * @dev Returns the admin role that controls `role`. See {grantRole} and
457      * {revokeRole}.
458      *
459      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
460      */
461     function getRoleAdmin(bytes32 role) external view returns (bytes32);
462 
463     /**
464      * @dev Grants `role` to `account`.
465      *
466      * If `account` had not been already granted `role`, emits a {RoleGranted}
467      * event.
468      *
469      * Requirements:
470      *
471      * - the caller must have ``role``'s admin role.
472      */
473     function grantRole(bytes32 role, address account) external;
474 
475     /**
476      * @dev Revokes `role` from `account`.
477      *
478      * If `account` had been granted `role`, emits a {RoleRevoked} event.
479      *
480      * Requirements:
481      *
482      * - the caller must have ``role``'s admin role.
483      */
484     function revokeRole(bytes32 role, address account) external;
485 
486     /**
487      * @dev Revokes `role` from the calling account.
488      *
489      * Roles are often managed via {grantRole} and {revokeRole}: this function's
490      * purpose is to provide a mechanism for accounts to lose their privileges
491      * if they are compromised (such as when a trusted device is misplaced).
492      *
493      * If the calling account had been granted `role`, emits a {RoleRevoked}
494      * event.
495      *
496      * Requirements:
497      *
498      * - the caller must be `account`.
499      */
500     function renounceRole(bytes32 role, address account) external;
501 }
502 
503 // File: @openzeppelin/contracts/utils/Context.sol
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Provides information about the current execution context, including the
511  * sender of the transaction and its data. While these are generally available
512  * via msg.sender and msg.data, they should not be accessed in such a direct
513  * manner, since when dealing with meta-transactions the account sending and
514  * paying for execution may not be the actual sender (as far as an application
515  * is concerned).
516  *
517  * This contract is only required for intermediate, library-like contracts.
518  */
519 abstract contract Context {
520     function _msgSender() internal view virtual returns (address) {
521         return msg.sender;
522     }
523 
524     function _msgData() internal view virtual returns (bytes calldata) {
525         return msg.data;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/access/Ownable.sol
530 
531 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Contract module which provides a basic access control mechanism, where
537  * there is an account (an owner) that can be granted exclusive access to
538  * specific functions.
539  *
540  * By default, the owner account will be the one that deploys the contract. This
541  * can later be changed with {transferOwnership}.
542  *
543  * This module is used through inheritance. It will make available the modifier
544  * `onlyOwner`, which can be applied to your functions to restrict their use to
545  * the owner.
546  */
547 abstract contract Ownable is Context {
548     address private _owner;
549 
550     event OwnershipTransferred(
551         address indexed previousOwner,
552         address indexed newOwner
553     );
554 
555     /**
556      * @dev Initializes the contract setting the deployer as the initial owner.
557      */
558     constructor() {
559         _transferOwnership(_msgSender());
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         _checkOwner();
567         _;
568     }
569 
570     /**
571      * @dev Returns the address of the current owner.
572      */
573     function owner() public view virtual returns (address) {
574         return _owner;
575     }
576 
577     /**
578      * @dev Throws if the sender is not the owner.
579      */
580     function _checkOwner() internal view virtual {
581         require(owner() == _msgSender(), "Ownable: caller is not the owner");
582     }
583 
584     /**
585      * @dev Leaves the contract without owner. It will not be possible to call
586      * `onlyOwner` functions anymore. Can only be called by the current owner.
587      *
588      * NOTE: Renouncing ownership will leave the contract without an owner,
589      * thereby removing any functionality that is only available to the owner.
590      */
591     function renounceOwnership() public virtual onlyOwner {
592         _transferOwnership(address(0));
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Can only be called by the current owner.
598      */
599     function transferOwnership(address newOwner) public virtual onlyOwner {
600         require(
601             newOwner != address(0),
602             "Ownable: new owner is the zero address"
603         );
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 // File: @openzeppelin/contracts/utils/Address.sol
619 
620 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
621 
622 pragma solidity ^0.8.1;
623 
624 /**
625  * @dev Collection of functions related to the address type
626  */
627 library Address {
628     /**
629      * @dev Returns true if `account` is a contract.
630      *
631      * [IMPORTANT]
632      * ====
633      * It is unsafe to assume that an address for which this function returns
634      * false is an externally-owned account (EOA) and not a contract.
635      *
636      * Among others, `isContract` will return false for the following
637      * types of addresses:
638      *
639      *  - an externally-owned account
640      *  - a contract in construction
641      *  - an address where a contract will be created
642      *  - an address where a contract lived, but was destroyed
643      * ====
644      *
645      * [IMPORTANT]
646      * ====
647      * You shouldn't rely on `isContract` to protect against flash loan attacks!
648      *
649      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
650      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
651      * constructor.
652      * ====
653      */
654     function isContract(address account) internal view returns (bool) {
655         // This method relies on extcodesize/address.code.length, which returns 0
656         // for contracts in construction, since the code is only stored at the end
657         // of the constructor execution.
658 
659         return account.code.length > 0;
660     }
661 
662     /**
663      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
664      * `recipient`, forwarding all available gas and reverting on errors.
665      *
666      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
667      * of certain opcodes, possibly making contracts go over the 2300 gas limit
668      * imposed by `transfer`, making them unable to receive funds via
669      * `transfer`. {sendValue} removes this limitation.
670      *
671      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
672      *
673      * IMPORTANT: because control is transferred to `recipient`, care must be
674      * taken to not create reentrancy vulnerabilities. Consider using
675      * {ReentrancyGuard} or the
676      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
677      */
678     function sendValue(address payable recipient, uint256 amount) internal {
679         require(
680             address(this).balance >= amount,
681             "Address: insufficient balance"
682         );
683 
684         (bool success, ) = recipient.call{value: amount}("");
685         require(
686             success,
687             "Address: unable to send value, recipient may have reverted"
688         );
689     }
690 
691     /**
692      * @dev Performs a Solidity function call using a low level `call`. A
693      * plain `call` is an unsafe replacement for a function call: use this
694      * function instead.
695      *
696      * If `target` reverts with a revert reason, it is bubbled up by this
697      * function (like regular Solidity function calls).
698      *
699      * Returns the raw returned data. To convert to the expected return value,
700      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
701      *
702      * Requirements:
703      *
704      * - `target` must be a contract.
705      * - calling `target` with `data` must not revert.
706      *
707      * _Available since v3.1._
708      */
709     function functionCall(address target, bytes memory data)
710         internal
711         returns (bytes memory)
712     {
713         return functionCall(target, data, "Address: low-level call failed");
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
718      * `errorMessage` as a fallback revert reason when `target` reverts.
719      *
720      * _Available since v3.1._
721      */
722     function functionCall(
723         address target,
724         bytes memory data,
725         string memory errorMessage
726     ) internal returns (bytes memory) {
727         return functionCallWithValue(target, data, 0, errorMessage);
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
732      * but also transferring `value` wei to `target`.
733      *
734      * Requirements:
735      *
736      * - the calling contract must have an ETH balance of at least `value`.
737      * - the called Solidity function must be `payable`.
738      *
739      * _Available since v3.1._
740      */
741     function functionCallWithValue(
742         address target,
743         bytes memory data,
744         uint256 value
745     ) internal returns (bytes memory) {
746         return
747             functionCallWithValue(
748                 target,
749                 data,
750                 value,
751                 "Address: low-level call with value failed"
752             );
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
757      * with `errorMessage` as a fallback revert reason when `target` reverts.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(
762         address target,
763         bytes memory data,
764         uint256 value,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         require(
768             address(this).balance >= value,
769             "Address: insufficient balance for call"
770         );
771         require(isContract(target), "Address: call to non-contract");
772 
773         (bool success, bytes memory returndata) = target.call{value: value}(
774             data
775         );
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data)
786         internal
787         view
788         returns (bytes memory)
789     {
790         return
791             functionStaticCall(
792                 target,
793                 data,
794                 "Address: low-level static call failed"
795             );
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
800      * but performing a static call.
801      *
802      * _Available since v3.3._
803      */
804     function functionStaticCall(
805         address target,
806         bytes memory data,
807         string memory errorMessage
808     ) internal view returns (bytes memory) {
809         require(isContract(target), "Address: static call to non-contract");
810 
811         (bool success, bytes memory returndata) = target.staticcall(data);
812         return verifyCallResult(success, returndata, errorMessage);
813     }
814 
815     /**
816      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
817      * but performing a delegate call.
818      *
819      * _Available since v3.4._
820      */
821     function functionDelegateCall(address target, bytes memory data)
822         internal
823         returns (bytes memory)
824     {
825         return
826             functionDelegateCall(
827                 target,
828                 data,
829                 "Address: low-level delegate call failed"
830             );
831     }
832 
833     /**
834      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
835      * but performing a delegate call.
836      *
837      * _Available since v3.4._
838      */
839     function functionDelegateCall(
840         address target,
841         bytes memory data,
842         string memory errorMessage
843     ) internal returns (bytes memory) {
844         require(isContract(target), "Address: delegate call to non-contract");
845 
846         (bool success, bytes memory returndata) = target.delegatecall(data);
847         return verifyCallResult(success, returndata, errorMessage);
848     }
849 
850     /**
851      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
852      * revert reason using the provided one.
853      *
854      * _Available since v4.3._
855      */
856     function verifyCallResult(
857         bool success,
858         bytes memory returndata,
859         string memory errorMessage
860     ) internal pure returns (bytes memory) {
861         if (success) {
862             return returndata;
863         } else {
864             // Look for revert reason and bubble it up if present
865             if (returndata.length > 0) {
866                 // The easiest way to bubble the revert reason is using memory via assembly
867                 /// @solidity memory-safe-assembly
868                 assembly {
869                     let returndata_size := mload(returndata)
870                     revert(add(32, returndata), returndata_size)
871                 }
872             } else {
873                 revert(errorMessage);
874             }
875         }
876     }
877 }
878 
879 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
880 
881 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Interface of the ERC165 standard, as defined in the
887  * https://eips.ethereum.org/EIPS/eip-165[EIP].
888  *
889  * Implementers can declare support of contract interfaces, which can then be
890  * queried by others ({ERC165Checker}).
891  *
892  * For an implementation, see {ERC165}.
893  */
894 interface IERC165 {
895     /**
896      * @dev Returns true if this contract implements the interface defined by
897      * `interfaceId`. See the corresponding
898      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
899      * to learn more about how these ids are created.
900      *
901      * This function call must use less than 30 000 gas.
902      */
903     function supportsInterface(bytes4 interfaceId) external view returns (bool);
904 }
905 
906 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
907 
908 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @dev Implementation of the {IERC165} interface.
914  *
915  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
916  * for the additional interface id that will be supported. For example:
917  *
918  * ```solidity
919  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
920  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
921  * }
922  * ```
923  *
924  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
925  */
926 abstract contract ERC165 is IERC165 {
927     /**
928      * @dev See {IERC165-supportsInterface}.
929      */
930     function supportsInterface(bytes4 interfaceId)
931         public
932         view
933         virtual
934         override
935         returns (bool)
936     {
937         return interfaceId == type(IERC165).interfaceId;
938     }
939 }
940 
941 // File: contracts/ERC2981Base.sol
942 
943 pragma solidity ^0.8.0;
944 
945 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
946 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
947     struct RoyaltyInfo {
948         address recipient;
949         uint24 amount;
950     }
951 
952     /// @inheritdoc	ERC165
953     function supportsInterface(bytes4 interfaceId)
954         public
955         view
956         virtual
957         override
958         returns (bool)
959     {
960         return
961             interfaceId == type(IERC2981Royalties).interfaceId ||
962             super.supportsInterface(interfaceId);
963     }
964 }
965 // File: contracts/ERC2981ContractWideRoyalties.sol
966 
967 pragma solidity ^0.8.0;
968 
969 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
970 /// @dev This implementation has the same royalties for each and every tokens
971 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
972     RoyaltyInfo private _royalties;
973 
974     /// @dev Sets token royalties
975     /// @param recipient recipient of the royalties
976     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
977     function _setRoyalties(address recipient, uint256 value) internal {
978         require(value <= 10000, "ERC2981Royalties: Too high");
979         _royalties = RoyaltyInfo(recipient, uint24(value));
980     }
981 
982     /// @inheritdoc	IERC2981Royalties
983     function royaltyInfo(uint256, uint256 value)
984         external
985         view
986         override
987         returns (address receiver, uint256 royaltyAmount)
988     {
989         RoyaltyInfo memory royalties = _royalties;
990         receiver = royalties.recipient;
991         royaltyAmount = (value * royalties.amount) / 10000;
992     }
993 }
994 // File: @openzeppelin/contracts/access/AccessControl.sol
995 
996 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @dev Contract module that allows children to implement role-based access
1002  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1003  * members except through off-chain means by accessing the contract event logs. Some
1004  * applications may benefit from on-chain enumerability, for those cases see
1005  * {AccessControlEnumerable}.
1006  *
1007  * Roles are referred to by their `bytes32` identifier. These should be exposed
1008  * in the external API and be unique. The best way to achieve this is by
1009  * using `public constant` hash digests:
1010  *
1011  * ```
1012  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1013  * ```
1014  *
1015  * Roles can be used to represent a set of permissions. To restrict access to a
1016  * function call, use {hasRole}:
1017  *
1018  * ```
1019  * function foo() public {
1020  *     require(hasRole(MY_ROLE, msg.sender));
1021  *     ...
1022  * }
1023  * ```
1024  *
1025  * Roles can be granted and revoked dynamically via the {grantRole} and
1026  * {revokeRole} functions. Each role has an associated admin role, and only
1027  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1028  *
1029  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1030  * that only accounts with this role will be able to grant or revoke other
1031  * roles. More complex role relationships can be created by using
1032  * {_setRoleAdmin}.
1033  *
1034  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1035  * grant and revoke this role. Extra precautions should be taken to secure
1036  * accounts that have been granted it.
1037  */
1038 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1039     struct RoleData {
1040         mapping(address => bool) members;
1041         bytes32 adminRole;
1042     }
1043 
1044     mapping(bytes32 => RoleData) private _roles;
1045 
1046     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1047 
1048     /**
1049      * @dev Modifier that checks that an account has a specific role. Reverts
1050      * with a standardized message including the required role.
1051      *
1052      * The format of the revert reason is given by the following regular expression:
1053      *
1054      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1055      *
1056      * _Available since v4.1._
1057      */
1058     modifier onlyRole(bytes32 role) {
1059         _checkRole(role);
1060         _;
1061     }
1062 
1063     /**
1064      * @dev See {IERC165-supportsInterface}.
1065      */
1066     function supportsInterface(bytes4 interfaceId)
1067         public
1068         view
1069         virtual
1070         override
1071         returns (bool)
1072     {
1073         return
1074             interfaceId == type(IAccessControl).interfaceId ||
1075             super.supportsInterface(interfaceId);
1076     }
1077 
1078     /**
1079      * @dev Returns `true` if `account` has been granted `role`.
1080      */
1081     function hasRole(bytes32 role, address account)
1082         public
1083         view
1084         virtual
1085         override
1086         returns (bool)
1087     {
1088         return _roles[role].members[account];
1089     }
1090 
1091     /**
1092      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1093      * Overriding this function changes the behavior of the {onlyRole} modifier.
1094      *
1095      * Format of the revert message is described in {_checkRole}.
1096      *
1097      * _Available since v4.6._
1098      */
1099     function _checkRole(bytes32 role) internal view virtual {
1100         _checkRole(role, _msgSender());
1101     }
1102 
1103     /**
1104      * @dev Revert with a standard message if `account` is missing `role`.
1105      *
1106      * The format of the revert reason is given by the following regular expression:
1107      *
1108      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1109      */
1110     function _checkRole(bytes32 role, address account) internal view virtual {
1111         if (!hasRole(role, account)) {
1112             revert(
1113                 string(
1114                     abi.encodePacked(
1115                         "AccessControl: account ",
1116                         Strings.toHexString(uint160(account), 20),
1117                         " is missing role ",
1118                         Strings.toHexString(uint256(role), 32)
1119                     )
1120                 )
1121             );
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the admin role that controls `role`. See {grantRole} and
1127      * {revokeRole}.
1128      *
1129      * To change a role's admin, use {_setRoleAdmin}.
1130      */
1131     function getRoleAdmin(bytes32 role)
1132         public
1133         view
1134         virtual
1135         override
1136         returns (bytes32)
1137     {
1138         return _roles[role].adminRole;
1139     }
1140 
1141     /**
1142      * @dev Grants `role` to `account`.
1143      *
1144      * If `account` had not been already granted `role`, emits a {RoleGranted}
1145      * event.
1146      *
1147      * Requirements:
1148      *
1149      * - the caller must have ``role``'s admin role.
1150      *
1151      * May emit a {RoleGranted} event.
1152      */
1153     function grantRole(bytes32 role, address account)
1154         public
1155         virtual
1156         override
1157         onlyRole(getRoleAdmin(role))
1158     {
1159         _grantRole(role, account);
1160     }
1161 
1162     /**
1163      * @dev Revokes `role` from `account`.
1164      *
1165      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1166      *
1167      * Requirements:
1168      *
1169      * - the caller must have ``role``'s admin role.
1170      *
1171      * May emit a {RoleRevoked} event.
1172      */
1173     function revokeRole(bytes32 role, address account)
1174         public
1175         virtual
1176         override
1177         onlyRole(getRoleAdmin(role))
1178     {
1179         _revokeRole(role, account);
1180     }
1181 
1182     /**
1183      * @dev Revokes `role` from the calling account.
1184      *
1185      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1186      * purpose is to provide a mechanism for accounts to lose their privileges
1187      * if they are compromised (such as when a trusted device is misplaced).
1188      *
1189      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1190      * event.
1191      *
1192      * Requirements:
1193      *
1194      * - the caller must be `account`.
1195      *
1196      * May emit a {RoleRevoked} event.
1197      */
1198     function renounceRole(bytes32 role, address account)
1199         public
1200         virtual
1201         override
1202     {
1203         require(
1204             account == _msgSender(),
1205             "AccessControl: can only renounce roles for self"
1206         );
1207 
1208         _revokeRole(role, account);
1209     }
1210 
1211     /**
1212      * @dev Grants `role` to `account`.
1213      *
1214      * If `account` had not been already granted `role`, emits a {RoleGranted}
1215      * event. Note that unlike {grantRole}, this function doesn't perform any
1216      * checks on the calling account.
1217      *
1218      * May emit a {RoleGranted} event.
1219      *
1220      * [WARNING]
1221      * ====
1222      * This function should only be called from the constructor when setting
1223      * up the initial roles for the system.
1224      *
1225      * Using this function in any other way is effectively circumventing the admin
1226      * system imposed by {AccessControl}.
1227      * ====
1228      *
1229      * NOTE: This function is deprecated in favor of {_grantRole}.
1230      */
1231     function _setupRole(bytes32 role, address account) internal virtual {
1232         _grantRole(role, account);
1233     }
1234 
1235     /**
1236      * @dev Sets `adminRole` as ``role``'s admin role.
1237      *
1238      * Emits a {RoleAdminChanged} event.
1239      */
1240     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1241         bytes32 previousAdminRole = getRoleAdmin(role);
1242         _roles[role].adminRole = adminRole;
1243         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1244     }
1245 
1246     /**
1247      * @dev Grants `role` to `account`.
1248      *
1249      * Internal function without access restriction.
1250      *
1251      * May emit a {RoleGranted} event.
1252      */
1253     function _grantRole(bytes32 role, address account) internal virtual {
1254         if (!hasRole(role, account)) {
1255             _roles[role].members[account] = true;
1256             emit RoleGranted(role, account, _msgSender());
1257         }
1258     }
1259 
1260     /**
1261      * @dev Revokes `role` from `account`.
1262      *
1263      * Internal function without access restriction.
1264      *
1265      * May emit a {RoleRevoked} event.
1266      */
1267     function _revokeRole(bytes32 role, address account) internal virtual {
1268         if (hasRole(role, account)) {
1269             _roles[role].members[account] = false;
1270             emit RoleRevoked(role, account, _msgSender());
1271         }
1272     }
1273 }
1274 
1275 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1276 
1277 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 /**
1282  * @dev _Available since v3.1._
1283  */
1284 interface IERC1155Receiver is IERC165 {
1285     /**
1286      * @dev Handles the receipt of a single ERC1155 token type. This function is
1287      * called at the end of a `safeTransferFrom` after the balance has been updated.
1288      *
1289      * NOTE: To accept the transfer, this must return
1290      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1291      * (i.e. 0xf23a6e61, or its own function selector).
1292      *
1293      * @param operator The address which initiated the transfer (i.e. msg.sender)
1294      * @param from The address which previously owned the token
1295      * @param id The ID of the token being transferred
1296      * @param value The amount of tokens being transferred
1297      * @param data Additional data with no specified format
1298      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1299      */
1300     function onERC1155Received(
1301         address operator,
1302         address from,
1303         uint256 id,
1304         uint256 value,
1305         bytes calldata data
1306     ) external returns (bytes4);
1307 
1308     /**
1309      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1310      * is called at the end of a `safeBatchTransferFrom` after the balances have
1311      * been updated.
1312      *
1313      * NOTE: To accept the transfer(s), this must return
1314      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1315      * (i.e. 0xbc197c81, or its own function selector).
1316      *
1317      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1318      * @param from The address which previously owned the token
1319      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1320      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1321      * @param data Additional data with no specified format
1322      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1323      */
1324     function onERC1155BatchReceived(
1325         address operator,
1326         address from,
1327         uint256[] calldata ids,
1328         uint256[] calldata values,
1329         bytes calldata data
1330     ) external returns (bytes4);
1331 }
1332 
1333 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1334 
1335 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 /**
1340  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1341  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1342  *
1343  * _Available since v3.1._
1344  */
1345 interface IERC1155 is IERC165 {
1346     /**
1347      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1348      */
1349     event TransferSingle(
1350         address indexed operator,
1351         address indexed from,
1352         address indexed to,
1353         uint256 id,
1354         uint256 value
1355     );
1356 
1357     /**
1358      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1359      * transfers.
1360      */
1361     event TransferBatch(
1362         address indexed operator,
1363         address indexed from,
1364         address indexed to,
1365         uint256[] ids,
1366         uint256[] values
1367     );
1368 
1369     /**
1370      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1371      * `approved`.
1372      */
1373     event ApprovalForAll(
1374         address indexed account,
1375         address indexed operator,
1376         bool approved
1377     );
1378 
1379     /**
1380      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1381      *
1382      * If an {URI} event was emitted for `id`, the standard
1383      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1384      * returned by {IERC1155MetadataURI-uri}.
1385      */
1386     event URI(string value, uint256 indexed id);
1387 
1388     /**
1389      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1390      *
1391      * Requirements:
1392      *
1393      * - `account` cannot be the zero address.
1394      */
1395     function balanceOf(address account, uint256 id)
1396         external
1397         view
1398         returns (uint256);
1399 
1400     /**
1401      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1402      *
1403      * Requirements:
1404      *
1405      * - `accounts` and `ids` must have the same length.
1406      */
1407     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1408         external
1409         view
1410         returns (uint256[] memory);
1411 
1412     /**
1413      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1414      *
1415      * Emits an {ApprovalForAll} event.
1416      *
1417      * Requirements:
1418      *
1419      * - `operator` cannot be the caller.
1420      */
1421     function setApprovalForAll(address operator, bool approved) external;
1422 
1423     /**
1424      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1425      *
1426      * See {setApprovalForAll}.
1427      */
1428     function isApprovedForAll(address account, address operator)
1429         external
1430         view
1431         returns (bool);
1432 
1433     /**
1434      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1435      *
1436      * Emits a {TransferSingle} event.
1437      *
1438      * Requirements:
1439      *
1440      * - `to` cannot be the zero address.
1441      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1442      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1443      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1444      * acceptance magic value.
1445      */
1446     function safeTransferFrom(
1447         address from,
1448         address to,
1449         uint256 id,
1450         uint256 amount,
1451         bytes calldata data
1452     ) external;
1453 
1454     /**
1455      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1456      *
1457      * Emits a {TransferBatch} event.
1458      *
1459      * Requirements:
1460      *
1461      * - `ids` and `amounts` must have the same length.
1462      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1463      * acceptance magic value.
1464      */
1465     function safeBatchTransferFrom(
1466         address from,
1467         address to,
1468         uint256[] calldata ids,
1469         uint256[] calldata amounts,
1470         bytes calldata data
1471     ) external;
1472 }
1473 
1474 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1475 
1476 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 /**
1481  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1482  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1483  *
1484  * _Available since v3.1._
1485  */
1486 interface IERC1155MetadataURI is IERC1155 {
1487     /**
1488      * @dev Returns the URI for token type `id`.
1489      *
1490      * If the `\{id\}` substring is present in the URI, it must be replaced by
1491      * clients with the actual token type ID.
1492      */
1493     function uri(uint256 id) external view returns (string memory);
1494 }
1495 
1496 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1497 
1498 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 /**
1503  * @dev Implementation of the basic standard multi-token.
1504  * See https://eips.ethereum.org/EIPS/eip-1155
1505  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1506  *
1507  * _Available since v3.1._
1508  */
1509 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1510     using Address for address;
1511 
1512     // Mapping from token ID to account balances
1513     mapping(uint256 => mapping(address => uint256)) private _balances;
1514 
1515     // Mapping from account to operator approvals
1516     mapping(address => mapping(address => bool)) private _operatorApprovals;
1517 
1518     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1519     string private _uri;
1520 
1521     /**
1522      * @dev See {_setURI}.
1523      */
1524     constructor(string memory uri_) {
1525         _setURI(uri_);
1526     }
1527 
1528     /**
1529      * @dev See {IERC165-supportsInterface}.
1530      */
1531     function supportsInterface(bytes4 interfaceId)
1532         public
1533         view
1534         virtual
1535         override(ERC165, IERC165)
1536         returns (bool)
1537     {
1538         return
1539             interfaceId == type(IERC1155).interfaceId ||
1540             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1541             super.supportsInterface(interfaceId);
1542     }
1543 
1544     /**
1545      * @dev See {IERC1155MetadataURI-uri}.
1546      *
1547      * This implementation returns the same URI for *all* token types. It relies
1548      * on the token type ID substitution mechanism
1549      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1550      *
1551      * Clients calling this function must replace the `\{id\}` substring with the
1552      * actual token type ID.
1553      */
1554     function uri(uint256) public view virtual override returns (string memory) {
1555         return _uri;
1556     }
1557 
1558     /**
1559      * @dev See {IERC1155-balanceOf}.
1560      *
1561      * Requirements:
1562      *
1563      * - `account` cannot be the zero address.
1564      */
1565     function balanceOf(address account, uint256 id)
1566         public
1567         view
1568         virtual
1569         override
1570         returns (uint256)
1571     {
1572         require(
1573             account != address(0),
1574             "ERC1155: address zero is not a valid owner"
1575         );
1576         return _balances[id][account];
1577     }
1578 
1579     /**
1580      * @dev See {IERC1155-balanceOfBatch}.
1581      *
1582      * Requirements:
1583      *
1584      * - `accounts` and `ids` must have the same length.
1585      */
1586     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1587         public
1588         view
1589         virtual
1590         override
1591         returns (uint256[] memory)
1592     {
1593         require(
1594             accounts.length == ids.length,
1595             "ERC1155: accounts and ids length mismatch"
1596         );
1597 
1598         uint256[] memory batchBalances = new uint256[](accounts.length);
1599 
1600         for (uint256 i = 0; i < accounts.length; ++i) {
1601             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1602         }
1603 
1604         return batchBalances;
1605     }
1606 
1607     /**
1608      * @dev See {IERC1155-setApprovalForAll}.
1609      */
1610     function setApprovalForAll(address operator, bool approved)
1611         public
1612         virtual
1613         override
1614     {
1615         _setApprovalForAll(_msgSender(), operator, approved);
1616     }
1617 
1618     /**
1619      * @dev See {IERC1155-isApprovedForAll}.
1620      */
1621     function isApprovedForAll(address account, address operator)
1622         public
1623         view
1624         virtual
1625         override
1626         returns (bool)
1627     {
1628         return _operatorApprovals[account][operator];
1629     }
1630 
1631     /**
1632      * @dev See {IERC1155-safeTransferFrom}.
1633      */
1634     function safeTransferFrom(
1635         address from,
1636         address to,
1637         uint256 id,
1638         uint256 amount,
1639         bytes memory data
1640     ) public virtual override {
1641         require(
1642             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1643             "ERC1155: caller is not token owner nor approved"
1644         );
1645         _safeTransferFrom(from, to, id, amount, data);
1646     }
1647 
1648     /**
1649      * @dev See {IERC1155-safeBatchTransferFrom}.
1650      */
1651     function safeBatchTransferFrom(
1652         address from,
1653         address to,
1654         uint256[] memory ids,
1655         uint256[] memory amounts,
1656         bytes memory data
1657     ) public virtual override {
1658         require(
1659             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1660             "ERC1155: caller is not token owner nor approved"
1661         );
1662         _safeBatchTransferFrom(from, to, ids, amounts, data);
1663     }
1664 
1665     /**
1666      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1667      *
1668      * Emits a {TransferSingle} event.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1674      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1675      * acceptance magic value.
1676      */
1677     function _safeTransferFrom(
1678         address from,
1679         address to,
1680         uint256 id,
1681         uint256 amount,
1682         bytes memory data
1683     ) internal virtual {
1684         require(to != address(0), "ERC1155: transfer to the zero address");
1685 
1686         address operator = _msgSender();
1687         uint256[] memory ids = _asSingletonArray(id);
1688         uint256[] memory amounts = _asSingletonArray(amount);
1689 
1690         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1691 
1692         uint256 fromBalance = _balances[id][from];
1693         require(
1694             fromBalance >= amount,
1695             "ERC1155: insufficient balance for transfer"
1696         );
1697         unchecked {
1698             _balances[id][from] = fromBalance - amount;
1699         }
1700         _balances[id][to] += amount;
1701 
1702         emit TransferSingle(operator, from, to, id, amount);
1703 
1704         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1705 
1706         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1707     }
1708 
1709     /**
1710      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1711      *
1712      * Emits a {TransferBatch} event.
1713      *
1714      * Requirements:
1715      *
1716      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1717      * acceptance magic value.
1718      */
1719     function _safeBatchTransferFrom(
1720         address from,
1721         address to,
1722         uint256[] memory ids,
1723         uint256[] memory amounts,
1724         bytes memory data
1725     ) internal virtual {
1726         require(
1727             ids.length == amounts.length,
1728             "ERC1155: ids and amounts length mismatch"
1729         );
1730         require(to != address(0), "ERC1155: transfer to the zero address");
1731 
1732         address operator = _msgSender();
1733 
1734         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1735 
1736         for (uint256 i = 0; i < ids.length; ++i) {
1737             uint256 id = ids[i];
1738             uint256 amount = amounts[i];
1739 
1740             uint256 fromBalance = _balances[id][from];
1741             require(
1742                 fromBalance >= amount,
1743                 "ERC1155: insufficient balance for transfer"
1744             );
1745             unchecked {
1746                 _balances[id][from] = fromBalance - amount;
1747             }
1748             _balances[id][to] += amount;
1749         }
1750 
1751         emit TransferBatch(operator, from, to, ids, amounts);
1752 
1753         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1754 
1755         _doSafeBatchTransferAcceptanceCheck(
1756             operator,
1757             from,
1758             to,
1759             ids,
1760             amounts,
1761             data
1762         );
1763     }
1764 
1765     /**
1766      * @dev Sets a new URI for all token types, by relying on the token type ID
1767      * substitution mechanism
1768      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1769      *
1770      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1771      * URI or any of the amounts in the JSON file at said URI will be replaced by
1772      * clients with the token type ID.
1773      *
1774      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1775      * interpreted by clients as
1776      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1777      * for token type ID 0x4cce0.
1778      *
1779      * See {uri}.
1780      *
1781      * Because these URIs cannot be meaningfully represented by the {URI} event,
1782      * this function emits no events.
1783      */
1784     function _setURI(string memory newuri) internal virtual {
1785         _uri = newuri;
1786     }
1787 
1788     /**
1789      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1790      *
1791      * Emits a {TransferSingle} event.
1792      *
1793      * Requirements:
1794      *
1795      * - `to` cannot be the zero address.
1796      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1797      * acceptance magic value.
1798      */
1799     function _mint(
1800         address to,
1801         uint256 id,
1802         uint256 amount,
1803         bytes memory data
1804     ) internal virtual {
1805         require(to != address(0), "ERC1155: mint to the zero address");
1806 
1807         address operator = _msgSender();
1808         uint256[] memory ids = _asSingletonArray(id);
1809         uint256[] memory amounts = _asSingletonArray(amount);
1810 
1811         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1812 
1813         _balances[id][to] += amount;
1814         emit TransferSingle(operator, address(0), to, id, amount);
1815 
1816         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1817 
1818         _doSafeTransferAcceptanceCheck(
1819             operator,
1820             address(0),
1821             to,
1822             id,
1823             amount,
1824             data
1825         );
1826     }
1827 
1828     /**
1829      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1830      *
1831      * Emits a {TransferBatch} event.
1832      *
1833      * Requirements:
1834      *
1835      * - `ids` and `amounts` must have the same length.
1836      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1837      * acceptance magic value.
1838      */
1839     function _mintBatch(
1840         address to,
1841         uint256[] memory ids,
1842         uint256[] memory amounts,
1843         bytes memory data
1844     ) internal virtual {
1845         require(to != address(0), "ERC1155: mint to the zero address");
1846         require(
1847             ids.length == amounts.length,
1848             "ERC1155: ids and amounts length mismatch"
1849         );
1850 
1851         address operator = _msgSender();
1852 
1853         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1854 
1855         for (uint256 i = 0; i < ids.length; i++) {
1856             _balances[ids[i]][to] += amounts[i];
1857         }
1858 
1859         emit TransferBatch(operator, address(0), to, ids, amounts);
1860 
1861         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1862 
1863         _doSafeBatchTransferAcceptanceCheck(
1864             operator,
1865             address(0),
1866             to,
1867             ids,
1868             amounts,
1869             data
1870         );
1871     }
1872 
1873     /**
1874      * @dev Destroys `amount` tokens of token type `id` from `from`
1875      *
1876      * Emits a {TransferSingle} event.
1877      *
1878      * Requirements:
1879      *
1880      * - `from` cannot be the zero address.
1881      * - `from` must have at least `amount` tokens of token type `id`.
1882      */
1883     function _burn(
1884         address from,
1885         uint256 id,
1886         uint256 amount
1887     ) internal virtual {
1888         require(from != address(0), "ERC1155: burn from the zero address");
1889 
1890         address operator = _msgSender();
1891         uint256[] memory ids = _asSingletonArray(id);
1892         uint256[] memory amounts = _asSingletonArray(amount);
1893 
1894         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1895 
1896         uint256 fromBalance = _balances[id][from];
1897         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1898         unchecked {
1899             _balances[id][from] = fromBalance - amount;
1900         }
1901 
1902         emit TransferSingle(operator, from, address(0), id, amount);
1903 
1904         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1905     }
1906 
1907     /**
1908      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1909      *
1910      * Emits a {TransferBatch} event.
1911      *
1912      * Requirements:
1913      *
1914      * - `ids` and `amounts` must have the same length.
1915      */
1916     function _burnBatch(
1917         address from,
1918         uint256[] memory ids,
1919         uint256[] memory amounts
1920     ) internal virtual {
1921         require(from != address(0), "ERC1155: burn from the zero address");
1922         require(
1923             ids.length == amounts.length,
1924             "ERC1155: ids and amounts length mismatch"
1925         );
1926 
1927         address operator = _msgSender();
1928 
1929         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1930 
1931         for (uint256 i = 0; i < ids.length; i++) {
1932             uint256 id = ids[i];
1933             uint256 amount = amounts[i];
1934 
1935             uint256 fromBalance = _balances[id][from];
1936             require(
1937                 fromBalance >= amount,
1938                 "ERC1155: burn amount exceeds balance"
1939             );
1940             unchecked {
1941                 _balances[id][from] = fromBalance - amount;
1942             }
1943         }
1944 
1945         emit TransferBatch(operator, from, address(0), ids, amounts);
1946 
1947         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1948     }
1949 
1950     /**
1951      * @dev Approve `operator` to operate on all of `owner` tokens
1952      *
1953      * Emits an {ApprovalForAll} event.
1954      */
1955     function _setApprovalForAll(
1956         address owner,
1957         address operator,
1958         bool approved
1959     ) internal virtual {
1960         require(owner != operator, "ERC1155: setting approval status for self");
1961         _operatorApprovals[owner][operator] = approved;
1962         emit ApprovalForAll(owner, operator, approved);
1963     }
1964 
1965     /**
1966      * @dev Hook that is called before any token transfer. This includes minting
1967      * and burning, as well as batched variants.
1968      *
1969      * The same hook is called on both single and batched variants. For single
1970      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1971      *
1972      * Calling conditions (for each `id` and `amount` pair):
1973      *
1974      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1975      * of token type `id` will be  transferred to `to`.
1976      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1977      * for `to`.
1978      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1979      * will be burned.
1980      * - `from` and `to` are never both zero.
1981      * - `ids` and `amounts` have the same, non-zero length.
1982      *
1983      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1984      */
1985     function _beforeTokenTransfer(
1986         address operator,
1987         address from,
1988         address to,
1989         uint256[] memory ids,
1990         uint256[] memory amounts,
1991         bytes memory data
1992     ) internal virtual {}
1993 
1994     /**
1995      * @dev Hook that is called after any token transfer. This includes minting
1996      * and burning, as well as batched variants.
1997      *
1998      * The same hook is called on both single and batched variants. For single
1999      * transfers, the length of the `id` and `amount` arrays will be 1.
2000      *
2001      * Calling conditions (for each `id` and `amount` pair):
2002      *
2003      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2004      * of token type `id` will be  transferred to `to`.
2005      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2006      * for `to`.
2007      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2008      * will be burned.
2009      * - `from` and `to` are never both zero.
2010      * - `ids` and `amounts` have the same, non-zero length.
2011      *
2012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2013      */
2014     function _afterTokenTransfer(
2015         address operator,
2016         address from,
2017         address to,
2018         uint256[] memory ids,
2019         uint256[] memory amounts,
2020         bytes memory data
2021     ) internal virtual {}
2022 
2023     function _doSafeTransferAcceptanceCheck(
2024         address operator,
2025         address from,
2026         address to,
2027         uint256 id,
2028         uint256 amount,
2029         bytes memory data
2030     ) private {
2031         if (to.isContract()) {
2032             try
2033                 IERC1155Receiver(to).onERC1155Received(
2034                     operator,
2035                     from,
2036                     id,
2037                     amount,
2038                     data
2039                 )
2040             returns (bytes4 response) {
2041                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2042                     revert("ERC1155: ERC1155Receiver rejected tokens");
2043                 }
2044             } catch Error(string memory reason) {
2045                 revert(reason);
2046             } catch {
2047                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2048             }
2049         }
2050     }
2051 
2052     function _doSafeBatchTransferAcceptanceCheck(
2053         address operator,
2054         address from,
2055         address to,
2056         uint256[] memory ids,
2057         uint256[] memory amounts,
2058         bytes memory data
2059     ) private {
2060         if (to.isContract()) {
2061             try
2062                 IERC1155Receiver(to).onERC1155BatchReceived(
2063                     operator,
2064                     from,
2065                     ids,
2066                     amounts,
2067                     data
2068                 )
2069             returns (bytes4 response) {
2070                 if (
2071                     response != IERC1155Receiver.onERC1155BatchReceived.selector
2072                 ) {
2073                     revert("ERC1155: ERC1155Receiver rejected tokens");
2074                 }
2075             } catch Error(string memory reason) {
2076                 revert(reason);
2077             } catch {
2078                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2079             }
2080         }
2081     }
2082 
2083     function _asSingletonArray(uint256 element)
2084         private
2085         pure
2086         returns (uint256[] memory)
2087     {
2088         uint256[] memory array = new uint256[](1);
2089         array[0] = element;
2090 
2091         return array;
2092     }
2093 }
2094 
2095 // File: contracts/Asset.sol
2096 
2097 pragma solidity ^0.8.16;
2098 
2099 contract Asset is
2100     ERC1155,
2101     AccessControl,
2102     Ownable,
2103     RevokableDefaultOperatorFilterer,
2104     ERC2981ContractWideRoyalties
2105 {
2106     string public name; // Token name.
2107     string public symbol; // Shorthand identifer.
2108     string public contractURI_; // Link to contract-level metadata.
2109     uint256 public royalty; // Royalty % 10000 = 100%.
2110     address private podContract; // Pod contract address.
2111     bool public paused = false; // Revert calls to critical funcs.
2112 
2113     // Efficient method to prevent >1 token per pilot.
2114     mapping(address => bool) public pilotAddr;
2115 
2116     // Tokens requiring unique IDs.
2117     mapping(uint256 => bool) public uid;
2118 
2119     constructor(
2120         address root_,
2121         string memory name_,
2122         string memory symbol_,
2123         string memory cURI_,
2124         string memory uri_,
2125         uint256 royalty_
2126     ) ERC1155(uri_) {
2127         _setupRole(DEFAULT_ADMIN_ROLE, root_);
2128         name = name_;
2129         symbol = symbol_;
2130         contractURI_ = cURI_;
2131         royalty = royalty_;
2132     }
2133 
2134     /*
2135      * @dev
2136      *      Write pod contract address for modifer allocation.
2137      * @params
2138      *      _podContract - Address of pod contract.
2139      */
2140     function setPodContract(address _podContract) external onlyAdmin {
2141         podContract = _podContract;
2142     }
2143 
2144     /*
2145      * @dev
2146      *      Modifier restricts func calls to addresses under admin role only.
2147      */
2148     modifier onlyAdmin() {
2149         require(
2150             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
2151             "Restricted to admins."
2152         );
2153         _;
2154     }
2155 
2156     /*
2157      * @dev
2158      *      Modifier restricts func calls to pod contract.
2159      */
2160     modifier onlyPodContract() {
2161         require(msg.sender == podContract);
2162         _;
2163     }
2164 
2165     /*
2166      * @dev
2167      *      Write contract activity switch.
2168      */
2169     function setPaused(bool _paused) external onlyAdmin {
2170         paused = _paused;
2171     }
2172 
2173     /*
2174      * @dev
2175      *      Read collection-level metadata.
2176      */
2177     function contractURI() public view returns (string memory) {
2178         return contractURI_;
2179     }
2180 
2181     /*
2182      * @dev
2183      *      Write collection-level metadata.
2184      * @params
2185      *      _contracturi - Link to contract-level JSON metadata.
2186      */
2187     function setContractURI(string memory _contracturi) external onlyAdmin {
2188         contractURI_ = _contracturi;
2189     }
2190 
2191     /*
2192      * @dev
2193      *      Read royalty fee set.
2194      */
2195     function getRoyaltyFee() public view returns (uint256) {
2196         return royalty;
2197     }
2198 
2199     /*
2200      * @dev
2201      *      Write royalty fee.
2202      * @params
2203      *      _recipient - Target address to receive the royalty fee.
2204      *      _value - Basis point royalty %.
2205      */
2206     function setRoyalties(address _recipient, uint256 _value)
2207         external
2208         onlyAdmin
2209     {
2210         _setRoyalties(_recipient, _value);
2211     }
2212 
2213     /*
2214      * @dev
2215      *       Write URI across tokens ({id} substition recommended).
2216 
2217      *       Note that no event emitted (as per ERC1155 standard)
2218      *       because these URIs cannot be meaningfully represented
2219      *       by a uri event in this function.
2220 
2221      * @params
2222      *      _uri - New URI to set across all tokens.
2223     
2224      */
2225     function setURI(string memory _uri) external onlyAdmin {
2226         _setURI(_uri);
2227     }
2228 
2229     /*
2230      * @dev
2231      *      Automatic transfer of assets by Pod assigned pilots.
2232 
2233      * @params
2234      *      _id - Ids of assets to be allocated.
2235      *      _pilot - Address of pilot to allocate to.
2236      
2237      * @mods
2238      *      onlyPodContract - Only the Pod contract can call successfully.
2239 
2240      */
2241     function fatesAssetTransfer(uint256 _id, address _pilot)
2242         external
2243         onlyPodContract
2244     {
2245         require(!paused, "Exodus is on hold.");
2246 
2247         // Pod must be non-fungible.
2248         require(uid[_id] == false, "Asset already claimed.");
2249 
2250         // New pilot check; not allocated asset previously.
2251         require(pilotAddr[_pilot] == false, "Address already owns the asset.");
2252 
2253         // New pilot now becomes registered as to not be able to again.
2254         pilotAddr[_pilot] = true;
2255 
2256         // Asset ID claimed.
2257         uid[_id] = true;
2258 
2259         // Pilot allocated asset by ID specificed in allowlist, and subsequently Pod contract call to distribute.
2260         _mint(_pilot, _id, 1, bytes(""));
2261     }
2262 
2263     /*
2264      * @dev
2265      *      Ensure marketplaces don't bypass creator royalty.
2266      */
2267     function setApprovalForAll(address operator, bool approved)
2268         public
2269         override
2270         onlyAllowedOperatorApproval(operator)
2271     {
2272         super.setApprovalForAll(operator, approved);
2273     }
2274 
2275     function safeTransferFrom(
2276         address from,
2277         address to,
2278         uint256 tokenId,
2279         uint256 amount,
2280         bytes memory data
2281     ) public override onlyAllowedOperator(from) {
2282         super.safeTransferFrom(from, to, tokenId, amount, data);
2283     }
2284 
2285     function safeBatchTransferFrom(
2286         address from,
2287         address to,
2288         uint256[] memory ids,
2289         uint256[] memory amounts,
2290         bytes memory data
2291     ) public virtual override onlyAllowedOperator(from) {
2292         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2293     }
2294 
2295     function owner()
2296         public
2297         view
2298         virtual
2299         override(Ownable, RevokableOperatorFilterer)
2300         returns (address)
2301     {
2302         return Ownable.owner();
2303     }
2304 
2305     function supportsInterface(bytes4 interfaceId)
2306         public
2307         view
2308         virtual
2309         override(ERC1155, AccessControl, ERC2981Base)
2310         returns (bool)
2311     {
2312         return super.supportsInterface(interfaceId);
2313     }
2314 }