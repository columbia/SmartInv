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
22 ░░░░░░░             Pod v1.0.6              ░░░░░░░
23 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
24 */
25 
26 // File: contracts/IERC2981Royalties.sol
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /// @title IERC2981Royalties
32 /// @dev Interface for the ERC2981 - Token Royalty standard
33 interface IERC2981Royalties {
34     /// @notice Called with the sale price to determine how much royalty
35     //          is owed and to whom.
36     /// @param _tokenId - the NFT asset queried for royalty information
37     /// @param _value - the sale price of the NFT asset specified by _tokenId
38     /// @return _receiver - address of who should be sent the royalty payment
39     /// @return _royaltyAmount - the royalty payment amount for value sale price
40     function royaltyInfo(uint256 _tokenId, uint256 _value)
41         external
42         view
43         returns (address _receiver, uint256 _royaltyAmount);
44 }
45 // File: contracts/IOperatorFilterRegistry.sol
46 
47 
48 pragma solidity ^0.8.13;
49 
50 interface IOperatorFilterRegistry {
51     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
52     function register(address registrant) external;
53     function registerAndSubscribe(address registrant, address subscription) external;
54     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
55     function unregister(address addr) external;
56     function updateOperator(address registrant, address operator, bool filtered) external;
57     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
58     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
59     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
60     function subscribe(address registrant, address registrantToSubscribe) external;
61     function unsubscribe(address registrant, bool copyExistingEntries) external;
62     function subscriptionOf(address addr) external returns (address registrant);
63     function subscribers(address registrant) external returns (address[] memory);
64     function subscriberAt(address registrant, uint256 index) external returns (address);
65     function copyEntriesOf(address registrant, address registrantToCopy) external;
66     function isOperatorFiltered(address registrant, address operator) external returns (bool);
67     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
68     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
69     function filteredOperators(address addr) external returns (address[] memory);
70     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
71     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
72     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
73     function isRegistered(address addr) external returns (bool);
74     function codeHashOf(address addr) external returns (bytes32);
75 }
76 
77 // File: contracts/OperatorFilterer.sol
78 
79 
80 pragma solidity ^0.8.13;
81 
82 
83 /**
84  * @title  OperatorFilterer
85  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
86  *         registrant's entries in the OperatorFilterRegistry.
87  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
88  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
89  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
90  */
91 abstract contract OperatorFilterer {
92     error OperatorNotAllowed(address operator);
93 
94     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
95         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
96 
97     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
98         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
99         // will not revert, but the contract will need to be registered with the registry once it is deployed in
100         // order for the modifier to filter addresses.
101         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
102             if (subscribe) {
103                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
104             } else {
105                 if (subscriptionOrRegistrantToCopy != address(0)) {
106                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
107                 } else {
108                     OPERATOR_FILTER_REGISTRY.register(address(this));
109                 }
110             }
111         }
112     }
113 
114     modifier onlyAllowedOperator(address from) virtual {
115         // Check registry code length to facilitate testing in environments without a deployed registry.
116         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
117             // Allow spending tokens from addresses with balance
118             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
119             // from an EOA.
120             if (from == msg.sender) {
121                 _;
122                 return;
123             }
124             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
125                 revert OperatorNotAllowed(msg.sender);
126             }
127         }
128         _;
129     }
130 
131     modifier onlyAllowedOperatorApproval(address operator) virtual {
132         // Check registry code length to facilitate testing in environments without a deployed registry.
133         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
134             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
135                 revert OperatorNotAllowed(operator);
136             }
137         }
138         _;
139     }
140 }
141 // File: contracts/RevokableOperatorFilterer.sol
142 
143 
144 pragma solidity ^0.8.13;
145 
146 
147 /**
148  * @title  RevokableOperatorFilterer
149  * @notice This contract is meant to allow contracts to permanently opt out of the OperatorFilterRegistry. The Registry
150  *         itself has an "unregister" function, but if the contract is ownable, the owner can re-register at any point.
151  *         As implemented, this abstract contract allows the contract owner to toggle the
152  *         isOperatorFilterRegistryRevoked flag in order to permanently bypass the OperatorFilterRegistry checks.
153  */
154 abstract contract RevokableOperatorFilterer is OperatorFilterer {
155     error OnlyOwner();
156     error AlreadyRevoked();
157 
158     bool private _isOperatorFilterRegistryRevoked;
159 
160     modifier onlyAllowedOperator(address from) override {
161         // Check registry code length to facilitate testing in environments without a deployed registry.
162         if (!_isOperatorFilterRegistryRevoked && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
163             // Allow spending tokens from addresses with balance
164             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
165             // from an EOA.
166             if (from == msg.sender) {
167                 _;
168                 return;
169             }
170             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
171                 revert OperatorNotAllowed(msg.sender);
172             }
173         }
174         _;
175     }
176 
177     modifier onlyAllowedOperatorApproval(address operator) override {
178         // Check registry code length to facilitate testing in environments without a deployed registry.
179         if (!_isOperatorFilterRegistryRevoked && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
180             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
181                 revert OperatorNotAllowed(operator);
182             }
183         }
184         _;
185     }
186 
187     /**
188      * @notice Disable the isOperatorFilterRegistryRevoked flag. OnlyOwner.
189      */
190     function revokeOperatorFilterRegistry() external {
191         if (msg.sender != owner()) {
192             revert OnlyOwner();
193         }
194         if (_isOperatorFilterRegistryRevoked) {
195             revert AlreadyRevoked();
196         }
197         _isOperatorFilterRegistryRevoked = true;
198     }
199 
200     function isOperatorFilterRegistryRevoked() public view returns (bool) {
201         return _isOperatorFilterRegistryRevoked;
202     }
203 
204     /**
205      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
206      */
207     function owner() public view virtual returns (address);
208 }
209 // File: contracts/RevokableDefaultOperatorFilterer.sol
210 
211 
212 pragma solidity ^0.8.13;
213 
214 
215 
216 /**
217  * @title  RevokableDefaultOperatorFilterer
218  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
219  */
220 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
221     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
222 
223     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
224 }
225 // File: @openzeppelin/contracts/utils/Strings.sol
226 
227 
228 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev String operations.
234  */
235 library Strings {
236     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
237     uint8 private constant _ADDRESS_LENGTH = 20;
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
241      */
242     function toString(uint256 value) internal pure returns (string memory) {
243         // Inspired by OraclizeAPI's implementation - MIT licence
244         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
245 
246         if (value == 0) {
247             return "0";
248         }
249         uint256 temp = value;
250         uint256 digits;
251         while (temp != 0) {
252             digits++;
253             temp /= 10;
254         }
255         bytes memory buffer = new bytes(digits);
256         while (value != 0) {
257             digits -= 1;
258             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
259             value /= 10;
260         }
261         return string(buffer);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
266      */
267     function toHexString(uint256 value) internal pure returns (string memory) {
268         if (value == 0) {
269             return "0x00";
270         }
271         uint256 temp = value;
272         uint256 length = 0;
273         while (temp != 0) {
274             length++;
275             temp >>= 8;
276         }
277         return toHexString(value, length);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
282      */
283     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
284         bytes memory buffer = new bytes(2 * length + 2);
285         buffer[0] = "0";
286         buffer[1] = "x";
287         for (uint256 i = 2 * length + 1; i > 1; --i) {
288             buffer[i] = _HEX_SYMBOLS[value & 0xf];
289             value >>= 4;
290         }
291         require(value == 0, "Strings: hex length insufficient");
292         return string(buffer);
293     }
294 
295     /**
296      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
297      */
298     function toHexString(address addr) internal pure returns (string memory) {
299         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/access/IAccessControl.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev External interface of AccessControl declared to support ERC165 detection.
312  */
313 interface IAccessControl {
314     /**
315      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
316      *
317      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
318      * {RoleAdminChanged} not being emitted signaling this.
319      *
320      * _Available since v3.1._
321      */
322     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
323 
324     /**
325      * @dev Emitted when `account` is granted `role`.
326      *
327      * `sender` is the account that originated the contract call, an admin role
328      * bearer except when using {AccessControl-_setupRole}.
329      */
330     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
331 
332     /**
333      * @dev Emitted when `account` is revoked `role`.
334      *
335      * `sender` is the account that originated the contract call:
336      *   - if using `revokeRole`, it is the admin role bearer
337      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
338      */
339     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
340 
341     /**
342      * @dev Returns `true` if `account` has been granted `role`.
343      */
344     function hasRole(bytes32 role, address account) external view returns (bool);
345 
346     /**
347      * @dev Returns the admin role that controls `role`. See {grantRole} and
348      * {revokeRole}.
349      *
350      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
351      */
352     function getRoleAdmin(bytes32 role) external view returns (bytes32);
353 
354     /**
355      * @dev Grants `role` to `account`.
356      *
357      * If `account` had not been already granted `role`, emits a {RoleGranted}
358      * event.
359      *
360      * Requirements:
361      *
362      * - the caller must have ``role``'s admin role.
363      */
364     function grantRole(bytes32 role, address account) external;
365 
366     /**
367      * @dev Revokes `role` from `account`.
368      *
369      * If `account` had been granted `role`, emits a {RoleRevoked} event.
370      *
371      * Requirements:
372      *
373      * - the caller must have ``role``'s admin role.
374      */
375     function revokeRole(bytes32 role, address account) external;
376 
377     /**
378      * @dev Revokes `role` from the calling account.
379      *
380      * Roles are often managed via {grantRole} and {revokeRole}: this function's
381      * purpose is to provide a mechanism for accounts to lose their privileges
382      * if they are compromised (such as when a trusted device is misplaced).
383      *
384      * If the calling account had been granted `role`, emits a {RoleRevoked}
385      * event.
386      *
387      * Requirements:
388      *
389      * - the caller must be `account`.
390      */
391     function renounceRole(bytes32 role, address account) external;
392 }
393 
394 // File: @openzeppelin/contracts/utils/Context.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Provides information about the current execution context, including the
403  * sender of the transaction and its data. While these are generally available
404  * via msg.sender and msg.data, they should not be accessed in such a direct
405  * manner, since when dealing with meta-transactions the account sending and
406  * paying for execution may not be the actual sender (as far as an application
407  * is concerned).
408  *
409  * This contract is only required for intermediate, library-like contracts.
410  */
411 abstract contract Context {
412     function _msgSender() internal view virtual returns (address) {
413         return msg.sender;
414     }
415 
416     function _msgData() internal view virtual returns (bytes calldata) {
417         return msg.data;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/access/Ownable.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Contract module which provides a basic access control mechanism, where
431  * there is an account (an owner) that can be granted exclusive access to
432  * specific functions.
433  *
434  * By default, the owner account will be the one that deploys the contract. This
435  * can later be changed with {transferOwnership}.
436  *
437  * This module is used through inheritance. It will make available the modifier
438  * `onlyOwner`, which can be applied to your functions to restrict their use to
439  * the owner.
440  */
441 abstract contract Ownable is Context {
442     address private _owner;
443 
444     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
445 
446     /**
447      * @dev Initializes the contract setting the deployer as the initial owner.
448      */
449     constructor() {
450         _transferOwnership(_msgSender());
451     }
452 
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         _checkOwner();
458         _;
459     }
460 
461     /**
462      * @dev Returns the address of the current owner.
463      */
464     function owner() public view virtual returns (address) {
465         return _owner;
466     }
467 
468     /**
469      * @dev Throws if the sender is not the owner.
470      */
471     function _checkOwner() internal view virtual {
472         require(owner() == _msgSender(), "Ownable: caller is not the owner");
473     }
474 
475     /**
476      * @dev Leaves the contract without owner. It will not be possible to call
477      * `onlyOwner` functions anymore. Can only be called by the current owner.
478      *
479      * NOTE: Renouncing ownership will leave the contract without an owner,
480      * thereby removing any functionality that is only available to the owner.
481      */
482     function renounceOwnership() public virtual onlyOwner {
483         _transferOwnership(address(0));
484     }
485 
486     /**
487      * @dev Transfers ownership of the contract to a new account (`newOwner`).
488      * Can only be called by the current owner.
489      */
490     function transferOwnership(address newOwner) public virtual onlyOwner {
491         require(newOwner != address(0), "Ownable: new owner is the zero address");
492         _transferOwnership(newOwner);
493     }
494 
495     /**
496      * @dev Transfers ownership of the contract to a new account (`newOwner`).
497      * Internal function without access restriction.
498      */
499     function _transferOwnership(address newOwner) internal virtual {
500         address oldOwner = _owner;
501         _owner = newOwner;
502         emit OwnershipTransferred(oldOwner, newOwner);
503     }
504 }
505 
506 // File: @openzeppelin/contracts/utils/Address.sol
507 
508 
509 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
510 
511 pragma solidity ^0.8.1;
512 
513 /**
514  * @dev Collection of functions related to the address type
515  */
516 library Address {
517     /**
518      * @dev Returns true if `account` is a contract.
519      *
520      * [IMPORTANT]
521      * ====
522      * It is unsafe to assume that an address for which this function returns
523      * false is an externally-owned account (EOA) and not a contract.
524      *
525      * Among others, `isContract` will return false for the following
526      * types of addresses:
527      *
528      *  - an externally-owned account
529      *  - a contract in construction
530      *  - an address where a contract will be created
531      *  - an address where a contract lived, but was destroyed
532      * ====
533      *
534      * [IMPORTANT]
535      * ====
536      * You shouldn't rely on `isContract` to protect against flash loan attacks!
537      *
538      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
539      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
540      * constructor.
541      * ====
542      */
543     function isContract(address account) internal view returns (bool) {
544         // This method relies on extcodesize/address.code.length, which returns 0
545         // for contracts in construction, since the code is only stored at the end
546         // of the constructor execution.
547 
548         return account.code.length > 0;
549     }
550 
551     /**
552      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
553      * `recipient`, forwarding all available gas and reverting on errors.
554      *
555      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
556      * of certain opcodes, possibly making contracts go over the 2300 gas limit
557      * imposed by `transfer`, making them unable to receive funds via
558      * `transfer`. {sendValue} removes this limitation.
559      *
560      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
561      *
562      * IMPORTANT: because control is transferred to `recipient`, care must be
563      * taken to not create reentrancy vulnerabilities. Consider using
564      * {ReentrancyGuard} or the
565      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
566      */
567     function sendValue(address payable recipient, uint256 amount) internal {
568         require(address(this).balance >= amount, "Address: insufficient balance");
569 
570         (bool success, ) = recipient.call{value: amount}("");
571         require(success, "Address: unable to send value, recipient may have reverted");
572     }
573 
574     /**
575      * @dev Performs a Solidity function call using a low level `call`. A
576      * plain `call` is an unsafe replacement for a function call: use this
577      * function instead.
578      *
579      * If `target` reverts with a revert reason, it is bubbled up by this
580      * function (like regular Solidity function calls).
581      *
582      * Returns the raw returned data. To convert to the expected return value,
583      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
584      *
585      * Requirements:
586      *
587      * - `target` must be a contract.
588      * - calling `target` with `data` must not revert.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
593         return functionCall(target, data, "Address: low-level call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
598      * `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         return functionCallWithValue(target, data, 0, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but also transferring `value` wei to `target`.
613      *
614      * Requirements:
615      *
616      * - the calling contract must have an ETH balance of at least `value`.
617      * - the called Solidity function must be `payable`.
618      *
619      * _Available since v3.1._
620      */
621     function functionCallWithValue(
622         address target,
623         bytes memory data,
624         uint256 value
625     ) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
631      * with `errorMessage` as a fallback revert reason when `target` reverts.
632      *
633      * _Available since v3.1._
634      */
635     function functionCallWithValue(
636         address target,
637         bytes memory data,
638         uint256 value,
639         string memory errorMessage
640     ) internal returns (bytes memory) {
641         require(address(this).balance >= value, "Address: insufficient balance for call");
642         require(isContract(target), "Address: call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.call{value: value}(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
655         return functionStaticCall(target, data, "Address: low-level static call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
660      * but performing a static call.
661      *
662      * _Available since v3.3._
663      */
664     function functionStaticCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal view returns (bytes memory) {
669         require(isContract(target), "Address: static call to non-contract");
670 
671         (bool success, bytes memory returndata) = target.staticcall(data);
672         return verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
682         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
687      * but performing a delegate call.
688      *
689      * _Available since v3.4._
690      */
691     function functionDelegateCall(
692         address target,
693         bytes memory data,
694         string memory errorMessage
695     ) internal returns (bytes memory) {
696         require(isContract(target), "Address: delegate call to non-contract");
697 
698         (bool success, bytes memory returndata) = target.delegatecall(data);
699         return verifyCallResult(success, returndata, errorMessage);
700     }
701 
702     /**
703      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
704      * revert reason using the provided one.
705      *
706      * _Available since v4.3._
707      */
708     function verifyCallResult(
709         bool success,
710         bytes memory returndata,
711         string memory errorMessage
712     ) internal pure returns (bytes memory) {
713         if (success) {
714             return returndata;
715         } else {
716             // Look for revert reason and bubble it up if present
717             if (returndata.length > 0) {
718                 // The easiest way to bubble the revert reason is using memory via assembly
719                 /// @solidity memory-safe-assembly
720                 assembly {
721                     let returndata_size := mload(returndata)
722                     revert(add(32, returndata), returndata_size)
723                 }
724             } else {
725                 revert(errorMessage);
726             }
727         }
728     }
729 }
730 
731 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Interface of the ERC165 standard, as defined in the
740  * https://eips.ethereum.org/EIPS/eip-165[EIP].
741  *
742  * Implementers can declare support of contract interfaces, which can then be
743  * queried by others ({ERC165Checker}).
744  *
745  * For an implementation, see {ERC165}.
746  */
747 interface IERC165 {
748     /**
749      * @dev Returns true if this contract implements the interface defined by
750      * `interfaceId`. See the corresponding
751      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
752      * to learn more about how these ids are created.
753      *
754      * This function call must use less than 30 000 gas.
755      */
756     function supportsInterface(bytes4 interfaceId) external view returns (bool);
757 }
758 
759 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @dev Implementation of the {IERC165} interface.
769  *
770  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
771  * for the additional interface id that will be supported. For example:
772  *
773  * ```solidity
774  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
775  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
776  * }
777  * ```
778  *
779  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
780  */
781 abstract contract ERC165 is IERC165 {
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
786         return interfaceId == type(IERC165).interfaceId;
787     }
788 }
789 
790 // File: contracts/ERC2981Base.sol
791 
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
798 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
799     struct RoyaltyInfo {
800         address recipient;
801         uint24 amount;
802     }
803 
804     /// @inheritdoc	ERC165
805     function supportsInterface(bytes4 interfaceId)
806         public
807         view
808         virtual
809         override
810         returns (bool)
811     {
812         return
813             interfaceId == type(IERC2981Royalties).interfaceId ||
814             super.supportsInterface(interfaceId);
815     }
816 }
817 // File: contracts/ERC2981ContractWideRoyalties.sol
818 
819 
820 pragma solidity ^0.8.0;
821 
822 
823 
824 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
825 /// @dev This implementation has the same royalties for each and every tokens
826 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
827     RoyaltyInfo private _royalties;
828 
829     /// @dev Sets token royalties
830     /// @param recipient recipient of the royalties
831     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
832     function _setRoyalties(address recipient, uint256 value) internal {
833         require(value <= 10000, "ERC2981Royalties: Too high");
834         _royalties = RoyaltyInfo(recipient, uint24(value));
835     }
836 
837     /// @inheritdoc	IERC2981Royalties
838     function royaltyInfo(uint256, uint256 value)
839         external
840         view
841         override
842         returns (address receiver, uint256 royaltyAmount)
843     {
844         RoyaltyInfo memory royalties = _royalties;
845         receiver = royalties.recipient;
846         royaltyAmount = (value * royalties.amount) / 10000;
847     }
848 }
849 // File: @openzeppelin/contracts/access/AccessControl.sol
850 
851 
852 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 
857 
858 
859 
860 /**
861  * @dev Contract module that allows children to implement role-based access
862  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
863  * members except through off-chain means by accessing the contract event logs. Some
864  * applications may benefit from on-chain enumerability, for those cases see
865  * {AccessControlEnumerable}.
866  *
867  * Roles are referred to by their `bytes32` identifier. These should be exposed
868  * in the external API and be unique. The best way to achieve this is by
869  * using `public constant` hash digests:
870  *
871  * ```
872  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
873  * ```
874  *
875  * Roles can be used to represent a set of permissions. To restrict access to a
876  * function call, use {hasRole}:
877  *
878  * ```
879  * function foo() public {
880  *     require(hasRole(MY_ROLE, msg.sender));
881  *     ...
882  * }
883  * ```
884  *
885  * Roles can be granted and revoked dynamically via the {grantRole} and
886  * {revokeRole} functions. Each role has an associated admin role, and only
887  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
888  *
889  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
890  * that only accounts with this role will be able to grant or revoke other
891  * roles. More complex role relationships can be created by using
892  * {_setRoleAdmin}.
893  *
894  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
895  * grant and revoke this role. Extra precautions should be taken to secure
896  * accounts that have been granted it.
897  */
898 abstract contract AccessControl is Context, IAccessControl, ERC165 {
899     struct RoleData {
900         mapping(address => bool) members;
901         bytes32 adminRole;
902     }
903 
904     mapping(bytes32 => RoleData) private _roles;
905 
906     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
907 
908     /**
909      * @dev Modifier that checks that an account has a specific role. Reverts
910      * with a standardized message including the required role.
911      *
912      * The format of the revert reason is given by the following regular expression:
913      *
914      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
915      *
916      * _Available since v4.1._
917      */
918     modifier onlyRole(bytes32 role) {
919         _checkRole(role);
920         _;
921     }
922 
923     /**
924      * @dev See {IERC165-supportsInterface}.
925      */
926     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
927         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev Returns `true` if `account` has been granted `role`.
932      */
933     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
934         return _roles[role].members[account];
935     }
936 
937     /**
938      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
939      * Overriding this function changes the behavior of the {onlyRole} modifier.
940      *
941      * Format of the revert message is described in {_checkRole}.
942      *
943      * _Available since v4.6._
944      */
945     function _checkRole(bytes32 role) internal view virtual {
946         _checkRole(role, _msgSender());
947     }
948 
949     /**
950      * @dev Revert with a standard message if `account` is missing `role`.
951      *
952      * The format of the revert reason is given by the following regular expression:
953      *
954      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
955      */
956     function _checkRole(bytes32 role, address account) internal view virtual {
957         if (!hasRole(role, account)) {
958             revert(
959                 string(
960                     abi.encodePacked(
961                         "AccessControl: account ",
962                         Strings.toHexString(uint160(account), 20),
963                         " is missing role ",
964                         Strings.toHexString(uint256(role), 32)
965                     )
966                 )
967             );
968         }
969     }
970 
971     /**
972      * @dev Returns the admin role that controls `role`. See {grantRole} and
973      * {revokeRole}.
974      *
975      * To change a role's admin, use {_setRoleAdmin}.
976      */
977     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
978         return _roles[role].adminRole;
979     }
980 
981     /**
982      * @dev Grants `role` to `account`.
983      *
984      * If `account` had not been already granted `role`, emits a {RoleGranted}
985      * event.
986      *
987      * Requirements:
988      *
989      * - the caller must have ``role``'s admin role.
990      *
991      * May emit a {RoleGranted} event.
992      */
993     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
994         _grantRole(role, account);
995     }
996 
997     /**
998      * @dev Revokes `role` from `account`.
999      *
1000      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1001      *
1002      * Requirements:
1003      *
1004      * - the caller must have ``role``'s admin role.
1005      *
1006      * May emit a {RoleRevoked} event.
1007      */
1008     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1009         _revokeRole(role, account);
1010     }
1011 
1012     /**
1013      * @dev Revokes `role` from the calling account.
1014      *
1015      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1016      * purpose is to provide a mechanism for accounts to lose their privileges
1017      * if they are compromised (such as when a trusted device is misplaced).
1018      *
1019      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1020      * event.
1021      *
1022      * Requirements:
1023      *
1024      * - the caller must be `account`.
1025      *
1026      * May emit a {RoleRevoked} event.
1027      */
1028     function renounceRole(bytes32 role, address account) public virtual override {
1029         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1030 
1031         _revokeRole(role, account);
1032     }
1033 
1034     /**
1035      * @dev Grants `role` to `account`.
1036      *
1037      * If `account` had not been already granted `role`, emits a {RoleGranted}
1038      * event. Note that unlike {grantRole}, this function doesn't perform any
1039      * checks on the calling account.
1040      *
1041      * May emit a {RoleGranted} event.
1042      *
1043      * [WARNING]
1044      * ====
1045      * This function should only be called from the constructor when setting
1046      * up the initial roles for the system.
1047      *
1048      * Using this function in any other way is effectively circumventing the admin
1049      * system imposed by {AccessControl}.
1050      * ====
1051      *
1052      * NOTE: This function is deprecated in favor of {_grantRole}.
1053      */
1054     function _setupRole(bytes32 role, address account) internal virtual {
1055         _grantRole(role, account);
1056     }
1057 
1058     /**
1059      * @dev Sets `adminRole` as ``role``'s admin role.
1060      *
1061      * Emits a {RoleAdminChanged} event.
1062      */
1063     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1064         bytes32 previousAdminRole = getRoleAdmin(role);
1065         _roles[role].adminRole = adminRole;
1066         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1067     }
1068 
1069     /**
1070      * @dev Grants `role` to `account`.
1071      *
1072      * Internal function without access restriction.
1073      *
1074      * May emit a {RoleGranted} event.
1075      */
1076     function _grantRole(bytes32 role, address account) internal virtual {
1077         if (!hasRole(role, account)) {
1078             _roles[role].members[account] = true;
1079             emit RoleGranted(role, account, _msgSender());
1080         }
1081     }
1082 
1083     /**
1084      * @dev Revokes `role` from `account`.
1085      *
1086      * Internal function without access restriction.
1087      *
1088      * May emit a {RoleRevoked} event.
1089      */
1090     function _revokeRole(bytes32 role, address account) internal virtual {
1091         if (hasRole(role, account)) {
1092             _roles[role].members[account] = false;
1093             emit RoleRevoked(role, account, _msgSender());
1094         }
1095     }
1096 }
1097 
1098 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1099 
1100 
1101 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @dev _Available since v3.1._
1108  */
1109 interface IERC1155Receiver is IERC165 {
1110     /**
1111      * @dev Handles the receipt of a single ERC1155 token type. This function is
1112      * called at the end of a `safeTransferFrom` after the balance has been updated.
1113      *
1114      * NOTE: To accept the transfer, this must return
1115      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1116      * (i.e. 0xf23a6e61, or its own function selector).
1117      *
1118      * @param operator The address which initiated the transfer (i.e. msg.sender)
1119      * @param from The address which previously owned the token
1120      * @param id The ID of the token being transferred
1121      * @param value The amount of tokens being transferred
1122      * @param data Additional data with no specified format
1123      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1124      */
1125     function onERC1155Received(
1126         address operator,
1127         address from,
1128         uint256 id,
1129         uint256 value,
1130         bytes calldata data
1131     ) external returns (bytes4);
1132 
1133     /**
1134      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1135      * is called at the end of a `safeBatchTransferFrom` after the balances have
1136      * been updated.
1137      *
1138      * NOTE: To accept the transfer(s), this must return
1139      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1140      * (i.e. 0xbc197c81, or its own function selector).
1141      *
1142      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1143      * @param from The address which previously owned the token
1144      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1145      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1146      * @param data Additional data with no specified format
1147      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1148      */
1149     function onERC1155BatchReceived(
1150         address operator,
1151         address from,
1152         uint256[] calldata ids,
1153         uint256[] calldata values,
1154         bytes calldata data
1155     ) external returns (bytes4);
1156 }
1157 
1158 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1159 
1160 
1161 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 
1166 /**
1167  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1168  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1169  *
1170  * _Available since v3.1._
1171  */
1172 interface IERC1155 is IERC165 {
1173     /**
1174      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1175      */
1176     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1177 
1178     /**
1179      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1180      * transfers.
1181      */
1182     event TransferBatch(
1183         address indexed operator,
1184         address indexed from,
1185         address indexed to,
1186         uint256[] ids,
1187         uint256[] values
1188     );
1189 
1190     /**
1191      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1192      * `approved`.
1193      */
1194     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1195 
1196     /**
1197      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1198      *
1199      * If an {URI} event was emitted for `id`, the standard
1200      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1201      * returned by {IERC1155MetadataURI-uri}.
1202      */
1203     event URI(string value, uint256 indexed id);
1204 
1205     /**
1206      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1207      *
1208      * Requirements:
1209      *
1210      * - `account` cannot be the zero address.
1211      */
1212     function balanceOf(address account, uint256 id) external view returns (uint256);
1213 
1214     /**
1215      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1216      *
1217      * Requirements:
1218      *
1219      * - `accounts` and `ids` must have the same length.
1220      */
1221     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1222         external
1223         view
1224         returns (uint256[] memory);
1225 
1226     /**
1227      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1228      *
1229      * Emits an {ApprovalForAll} event.
1230      *
1231      * Requirements:
1232      *
1233      * - `operator` cannot be the caller.
1234      */
1235     function setApprovalForAll(address operator, bool approved) external;
1236 
1237     /**
1238      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1239      *
1240      * See {setApprovalForAll}.
1241      */
1242     function isApprovedForAll(address account, address operator) external view returns (bool);
1243 
1244     /**
1245      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1246      *
1247      * Emits a {TransferSingle} event.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1253      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1254      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1255      * acceptance magic value.
1256      */
1257     function safeTransferFrom(
1258         address from,
1259         address to,
1260         uint256 id,
1261         uint256 amount,
1262         bytes calldata data
1263     ) external;
1264 
1265     /**
1266      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1267      *
1268      * Emits a {TransferBatch} event.
1269      *
1270      * Requirements:
1271      *
1272      * - `ids` and `amounts` must have the same length.
1273      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1274      * acceptance magic value.
1275      */
1276     function safeBatchTransferFrom(
1277         address from,
1278         address to,
1279         uint256[] calldata ids,
1280         uint256[] calldata amounts,
1281         bytes calldata data
1282     ) external;
1283 }
1284 
1285 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1286 
1287 
1288 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 /**
1294  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1295  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1296  *
1297  * _Available since v3.1._
1298  */
1299 interface IERC1155MetadataURI is IERC1155 {
1300     /**
1301      * @dev Returns the URI for token type `id`.
1302      *
1303      * If the `\{id\}` substring is present in the URI, it must be replaced by
1304      * clients with the actual token type ID.
1305      */
1306     function uri(uint256 id) external view returns (string memory);
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1310 
1311 
1312 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 /**
1323  * @dev Implementation of the basic standard multi-token.
1324  * See https://eips.ethereum.org/EIPS/eip-1155
1325  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1326  *
1327  * _Available since v3.1._
1328  */
1329 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1330     using Address for address;
1331 
1332     // Mapping from token ID to account balances
1333     mapping(uint256 => mapping(address => uint256)) private _balances;
1334 
1335     // Mapping from account to operator approvals
1336     mapping(address => mapping(address => bool)) private _operatorApprovals;
1337 
1338     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1339     string private _uri;
1340 
1341     /**
1342      * @dev See {_setURI}.
1343      */
1344     constructor(string memory uri_) {
1345         _setURI(uri_);
1346     }
1347 
1348     /**
1349      * @dev See {IERC165-supportsInterface}.
1350      */
1351     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1352         return
1353             interfaceId == type(IERC1155).interfaceId ||
1354             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1355             super.supportsInterface(interfaceId);
1356     }
1357 
1358     /**
1359      * @dev See {IERC1155MetadataURI-uri}.
1360      *
1361      * This implementation returns the same URI for *all* token types. It relies
1362      * on the token type ID substitution mechanism
1363      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1364      *
1365      * Clients calling this function must replace the `\{id\}` substring with the
1366      * actual token type ID.
1367      */
1368     function uri(uint256) public view virtual override returns (string memory) {
1369         return _uri;
1370     }
1371 
1372     /**
1373      * @dev See {IERC1155-balanceOf}.
1374      *
1375      * Requirements:
1376      *
1377      * - `account` cannot be the zero address.
1378      */
1379     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1380         require(account != address(0), "ERC1155: address zero is not a valid owner");
1381         return _balances[id][account];
1382     }
1383 
1384     /**
1385      * @dev See {IERC1155-balanceOfBatch}.
1386      *
1387      * Requirements:
1388      *
1389      * - `accounts` and `ids` must have the same length.
1390      */
1391     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1392         public
1393         view
1394         virtual
1395         override
1396         returns (uint256[] memory)
1397     {
1398         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1399 
1400         uint256[] memory batchBalances = new uint256[](accounts.length);
1401 
1402         for (uint256 i = 0; i < accounts.length; ++i) {
1403             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1404         }
1405 
1406         return batchBalances;
1407     }
1408 
1409     /**
1410      * @dev See {IERC1155-setApprovalForAll}.
1411      */
1412     function setApprovalForAll(address operator, bool approved) public virtual override {
1413         _setApprovalForAll(_msgSender(), operator, approved);
1414     }
1415 
1416     /**
1417      * @dev See {IERC1155-isApprovedForAll}.
1418      */
1419     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1420         return _operatorApprovals[account][operator];
1421     }
1422 
1423     /**
1424      * @dev See {IERC1155-safeTransferFrom}.
1425      */
1426     function safeTransferFrom(
1427         address from,
1428         address to,
1429         uint256 id,
1430         uint256 amount,
1431         bytes memory data
1432     ) public virtual override {
1433         require(
1434             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1435             "ERC1155: caller is not token owner nor approved"
1436         );
1437         _safeTransferFrom(from, to, id, amount, data);
1438     }
1439 
1440     /**
1441      * @dev See {IERC1155-safeBatchTransferFrom}.
1442      */
1443     function safeBatchTransferFrom(
1444         address from,
1445         address to,
1446         uint256[] memory ids,
1447         uint256[] memory amounts,
1448         bytes memory data
1449     ) public virtual override {
1450         require(
1451             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1452             "ERC1155: caller is not token owner nor approved"
1453         );
1454         _safeBatchTransferFrom(from, to, ids, amounts, data);
1455     }
1456 
1457     /**
1458      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1459      *
1460      * Emits a {TransferSingle} event.
1461      *
1462      * Requirements:
1463      *
1464      * - `to` cannot be the zero address.
1465      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1466      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1467      * acceptance magic value.
1468      */
1469     function _safeTransferFrom(
1470         address from,
1471         address to,
1472         uint256 id,
1473         uint256 amount,
1474         bytes memory data
1475     ) internal virtual {
1476         require(to != address(0), "ERC1155: transfer to the zero address");
1477 
1478         address operator = _msgSender();
1479         uint256[] memory ids = _asSingletonArray(id);
1480         uint256[] memory amounts = _asSingletonArray(amount);
1481 
1482         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1483 
1484         uint256 fromBalance = _balances[id][from];
1485         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1486         unchecked {
1487             _balances[id][from] = fromBalance - amount;
1488         }
1489         _balances[id][to] += amount;
1490 
1491         emit TransferSingle(operator, from, to, id, amount);
1492 
1493         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1494 
1495         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1496     }
1497 
1498     /**
1499      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1500      *
1501      * Emits a {TransferBatch} event.
1502      *
1503      * Requirements:
1504      *
1505      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1506      * acceptance magic value.
1507      */
1508     function _safeBatchTransferFrom(
1509         address from,
1510         address to,
1511         uint256[] memory ids,
1512         uint256[] memory amounts,
1513         bytes memory data
1514     ) internal virtual {
1515         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1516         require(to != address(0), "ERC1155: transfer to the zero address");
1517 
1518         address operator = _msgSender();
1519 
1520         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1521 
1522         for (uint256 i = 0; i < ids.length; ++i) {
1523             uint256 id = ids[i];
1524             uint256 amount = amounts[i];
1525 
1526             uint256 fromBalance = _balances[id][from];
1527             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1528             unchecked {
1529                 _balances[id][from] = fromBalance - amount;
1530             }
1531             _balances[id][to] += amount;
1532         }
1533 
1534         emit TransferBatch(operator, from, to, ids, amounts);
1535 
1536         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1537 
1538         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1539     }
1540 
1541     /**
1542      * @dev Sets a new URI for all token types, by relying on the token type ID
1543      * substitution mechanism
1544      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1545      *
1546      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1547      * URI or any of the amounts in the JSON file at said URI will be replaced by
1548      * clients with the token type ID.
1549      *
1550      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1551      * interpreted by clients as
1552      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1553      * for token type ID 0x4cce0.
1554      *
1555      * See {uri}.
1556      *
1557      * Because these URIs cannot be meaningfully represented by the {URI} event,
1558      * this function emits no events.
1559      */
1560     function _setURI(string memory newuri) internal virtual {
1561         _uri = newuri;
1562     }
1563 
1564     /**
1565      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1566      *
1567      * Emits a {TransferSingle} event.
1568      *
1569      * Requirements:
1570      *
1571      * - `to` cannot be the zero address.
1572      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1573      * acceptance magic value.
1574      */
1575     function _mint(
1576         address to,
1577         uint256 id,
1578         uint256 amount,
1579         bytes memory data
1580     ) internal virtual {
1581         require(to != address(0), "ERC1155: mint to the zero address");
1582 
1583         address operator = _msgSender();
1584         uint256[] memory ids = _asSingletonArray(id);
1585         uint256[] memory amounts = _asSingletonArray(amount);
1586 
1587         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1588 
1589         _balances[id][to] += amount;
1590         emit TransferSingle(operator, address(0), to, id, amount);
1591 
1592         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1593 
1594         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1595     }
1596 
1597     /**
1598      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1599      *
1600      * Emits a {TransferBatch} event.
1601      *
1602      * Requirements:
1603      *
1604      * - `ids` and `amounts` must have the same length.
1605      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1606      * acceptance magic value.
1607      */
1608     function _mintBatch(
1609         address to,
1610         uint256[] memory ids,
1611         uint256[] memory amounts,
1612         bytes memory data
1613     ) internal virtual {
1614         require(to != address(0), "ERC1155: mint to the zero address");
1615         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1616 
1617         address operator = _msgSender();
1618 
1619         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1620 
1621         for (uint256 i = 0; i < ids.length; i++) {
1622             _balances[ids[i]][to] += amounts[i];
1623         }
1624 
1625         emit TransferBatch(operator, address(0), to, ids, amounts);
1626 
1627         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1628 
1629         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1630     }
1631 
1632     /**
1633      * @dev Destroys `amount` tokens of token type `id` from `from`
1634      *
1635      * Emits a {TransferSingle} event.
1636      *
1637      * Requirements:
1638      *
1639      * - `from` cannot be the zero address.
1640      * - `from` must have at least `amount` tokens of token type `id`.
1641      */
1642     function _burn(
1643         address from,
1644         uint256 id,
1645         uint256 amount
1646     ) internal virtual {
1647         require(from != address(0), "ERC1155: burn from the zero address");
1648 
1649         address operator = _msgSender();
1650         uint256[] memory ids = _asSingletonArray(id);
1651         uint256[] memory amounts = _asSingletonArray(amount);
1652 
1653         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1654 
1655         uint256 fromBalance = _balances[id][from];
1656         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1657         unchecked {
1658             _balances[id][from] = fromBalance - amount;
1659         }
1660 
1661         emit TransferSingle(operator, from, address(0), id, amount);
1662 
1663         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1664     }
1665 
1666     /**
1667      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1668      *
1669      * Emits a {TransferBatch} event.
1670      *
1671      * Requirements:
1672      *
1673      * - `ids` and `amounts` must have the same length.
1674      */
1675     function _burnBatch(
1676         address from,
1677         uint256[] memory ids,
1678         uint256[] memory amounts
1679     ) internal virtual {
1680         require(from != address(0), "ERC1155: burn from the zero address");
1681         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1682 
1683         address operator = _msgSender();
1684 
1685         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1686 
1687         for (uint256 i = 0; i < ids.length; i++) {
1688             uint256 id = ids[i];
1689             uint256 amount = amounts[i];
1690 
1691             uint256 fromBalance = _balances[id][from];
1692             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1693             unchecked {
1694                 _balances[id][from] = fromBalance - amount;
1695             }
1696         }
1697 
1698         emit TransferBatch(operator, from, address(0), ids, amounts);
1699 
1700         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1701     }
1702 
1703     /**
1704      * @dev Approve `operator` to operate on all of `owner` tokens
1705      *
1706      * Emits an {ApprovalForAll} event.
1707      */
1708     function _setApprovalForAll(
1709         address owner,
1710         address operator,
1711         bool approved
1712     ) internal virtual {
1713         require(owner != operator, "ERC1155: setting approval status for self");
1714         _operatorApprovals[owner][operator] = approved;
1715         emit ApprovalForAll(owner, operator, approved);
1716     }
1717 
1718     /**
1719      * @dev Hook that is called before any token transfer. This includes minting
1720      * and burning, as well as batched variants.
1721      *
1722      * The same hook is called on both single and batched variants. For single
1723      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1724      *
1725      * Calling conditions (for each `id` and `amount` pair):
1726      *
1727      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1728      * of token type `id` will be  transferred to `to`.
1729      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1730      * for `to`.
1731      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1732      * will be burned.
1733      * - `from` and `to` are never both zero.
1734      * - `ids` and `amounts` have the same, non-zero length.
1735      *
1736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1737      */
1738     function _beforeTokenTransfer(
1739         address operator,
1740         address from,
1741         address to,
1742         uint256[] memory ids,
1743         uint256[] memory amounts,
1744         bytes memory data
1745     ) internal virtual {}
1746 
1747     /**
1748      * @dev Hook that is called after any token transfer. This includes minting
1749      * and burning, as well as batched variants.
1750      *
1751      * The same hook is called on both single and batched variants. For single
1752      * transfers, the length of the `id` and `amount` arrays will be 1.
1753      *
1754      * Calling conditions (for each `id` and `amount` pair):
1755      *
1756      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1757      * of token type `id` will be  transferred to `to`.
1758      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1759      * for `to`.
1760      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1761      * will be burned.
1762      * - `from` and `to` are never both zero.
1763      * - `ids` and `amounts` have the same, non-zero length.
1764      *
1765      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1766      */
1767     function _afterTokenTransfer(
1768         address operator,
1769         address from,
1770         address to,
1771         uint256[] memory ids,
1772         uint256[] memory amounts,
1773         bytes memory data
1774     ) internal virtual {}
1775 
1776     function _doSafeTransferAcceptanceCheck(
1777         address operator,
1778         address from,
1779         address to,
1780         uint256 id,
1781         uint256 amount,
1782         bytes memory data
1783     ) private {
1784         if (to.isContract()) {
1785             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1786                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1787                     revert("ERC1155: ERC1155Receiver rejected tokens");
1788                 }
1789             } catch Error(string memory reason) {
1790                 revert(reason);
1791             } catch {
1792                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1793             }
1794         }
1795     }
1796 
1797     function _doSafeBatchTransferAcceptanceCheck(
1798         address operator,
1799         address from,
1800         address to,
1801         uint256[] memory ids,
1802         uint256[] memory amounts,
1803         bytes memory data
1804     ) private {
1805         if (to.isContract()) {
1806             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1807                 bytes4 response
1808             ) {
1809                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1810                     revert("ERC1155: ERC1155Receiver rejected tokens");
1811                 }
1812             } catch Error(string memory reason) {
1813                 revert(reason);
1814             } catch {
1815                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1816             }
1817         }
1818     }
1819 
1820     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1821         uint256[] memory array = new uint256[](1);
1822         array[0] = element;
1823 
1824         return array;
1825     }
1826 }
1827 
1828 // File: contracts/Pod.sol
1829 
1830 
1831 pragma solidity ^0.8.16;
1832 
1833 contract Asset {
1834     function fatesAssetTransfer(uint256 _id, address _to) public {}
1835 }
1836 
1837 contract Pod is
1838     ERC1155,
1839     AccessControl,
1840     Ownable,
1841     RevokableDefaultOperatorFilterer,
1842     ERC2981ContractWideRoyalties
1843 {
1844     string public name; // Token name.
1845     string public symbol; // Shorthand identifer.
1846     string public contractURI_; // Link to contract-level metadata.
1847     string public baseURI; // Base domain.
1848     string public launchedURI; // Launched token's metadata.
1849     string public unlaunchedURI; // Unlaunched token's metadata.
1850     uint256 public royalty; // Royalty % 10000 = 100%.
1851     uint256 public expiry = 3600;
1852     bool public paused = false; // Revert calls to critical funcs.
1853     bool internal locked; // Switch to prevent reentrancy attack.
1854 
1855     struct TokenIds {
1856         uint256 aId;
1857         uint256 cId;
1858         uint256 expiresAt;
1859         bool listed;
1860     }
1861 
1862     // Stop >1 of same address per allowlist slot
1863     mapping(address => bool) public allowlistValve;
1864     // Tokens requiring unique IDs.
1865     mapping(uint256 => bool) public uid;
1866     // Mapping pod IDs to corresponding pilot addresses.
1867     mapping(uint256 => address) public allowList;
1868     // Prevent >1 token per pilot.
1869     mapping(address => bool) public launchClearance;
1870     // Mapping pod assigned pilots to exodus assets.
1871     mapping(address => TokenIds) launchList;
1872     // pod state tracker.
1873     mapping(uint256 => bool) private launchStatus;
1874 
1875     // Contracts pod will interact with.
1876     Asset private astrContract;
1877     Asset private charContract;
1878 
1879     // Distributor role.
1880     bytes32 public constant DISTRIBUTOR = keccak256("DISTRIBUTOR");
1881 
1882     constructor(
1883         address _root,
1884         address _distributor,
1885         address _astrContract,
1886         address _charContract,
1887         string memory _name,
1888         string memory _symbol,
1889         string memory _contractURI,
1890         string memory _baseURI,
1891         string memory _launchedURI,
1892         string memory _unlaunchedURI,
1893         uint256 _royalty
1894     ) ERC1155(baseURI) {
1895         _setupRole(DEFAULT_ADMIN_ROLE, _root);
1896         _setupRole(DISTRIBUTOR, _distributor);
1897         name = _name;
1898         symbol = _symbol;
1899         contractURI_ = _contractURI;
1900         baseURI = _baseURI;
1901         launchedURI = _launchedURI;
1902         unlaunchedURI = _unlaunchedURI;
1903         royalty = _royalty;
1904         astrContract = Asset(_astrContract);
1905         charContract = Asset(_charContract);
1906     }
1907 
1908     /*
1909      * @dev
1910      *      Modifier restricts func calls to addresses under admin role only.
1911      */
1912     modifier onlyAdmin() {
1913         require(
1914             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
1915             "Restricted to admins."
1916         );
1917         _;
1918     }
1919 
1920     /*
1921      * @dev
1922      *      Modifier used to lock external functions until fully executed.
1923      */
1924     modifier noReentrant() {
1925         require(!locked, "No recursive calls.");
1926         locked = true;
1927         _;
1928         locked = false;
1929     }
1930 
1931     /*
1932      * @dev
1933      *      Write contract activity switch.
1934      * @params
1935      *      _paused - Boolean state change.
1936      */
1937     function setPaused(bool _paused) external onlyAdmin {
1938         paused = _paused;
1939     }
1940 
1941     /*
1942      * @dev
1943      *      Read collection-level metadata.
1944      */
1945     function contractURI() public view returns (string memory) {
1946         return contractURI_;
1947     }
1948 
1949     /*
1950      * @dev
1951      *      Write collection-level metadata.
1952      * @params
1953      *      _contracturi - Link to contract-level JSON metadata.
1954      */
1955     function setContractURI(string memory _contracturi) external onlyAdmin {
1956         contractURI_ = _contracturi;
1957     }
1958 
1959     /*
1960      * @dev
1961      *      Set expiry time for buying a token.
1962      * @params
1963      *      _expiry - In seconds, 3600 default.
1964      */
1965     function setExpiry(uint256 _expiry) external onlyAdmin {
1966         expiry = _expiry;
1967     }
1968 
1969     /*
1970      * @dev
1971      *      Read royalty fee set.
1972      */
1973     function getRoyaltyFee() public view returns (uint256) {
1974         return royalty;
1975     }
1976 
1977     /*
1978      * @dev
1979      *      Write royalty fee.
1980      * @params
1981      *      _recipient - Target address to receive the royalty fee.
1982      *      _value - Basis point royalty %.
1983      */
1984     function setRoyalties(address _recipient, uint256 _value)
1985         external
1986         onlyAdmin
1987     {
1988         _setRoyalties(_recipient, _value);
1989     }
1990 
1991     /*
1992      * @dev
1993      *      Add pilot address to the allowList against token ID.
1994      * @params
1995      *      _id - ID of tokens to be minted.
1996      *      _pilot - Pilot to allow listed.
1997      */
1998     function addToAllowList(uint256 _id, address _pilot)
1999         external
2000         onlyRole(DISTRIBUTOR)
2001     {
2002         // Pod must not already have been claimed.
2003         require(uid[_id] == false, "Pod already claimed.");
2004         // Pilot must not have already been allocated a Pod.
2005         require(allowlistValve[_pilot] == false, "Address already listed.");
2006         // No more than once whilst on allow list at any one time.
2007         allowlistValve[_pilot] = true;
2008         // Add to allow list.
2009         allowList[_id] = _pilot;
2010     }
2011 
2012     /*
2013      * @dev
2014      *      Remove pilot address from the allow list against token ID.
2015      *      Also resets the pilot to be able to engage in the evac process again.
2016      * @params
2017      *      _id - ID of token to remove.
2018      *      _pilot - Pilot address to remove.
2019      */
2020     function removeFromAllowList(uint256 _id, address _pilot)
2021         external
2022         onlyRole(DISTRIBUTOR)
2023     {
2024         require(allowlistValve[_pilot] == true, "Address not allocated a pod.");
2025         allowlistValve[_pilot] = false;
2026         delete allowList[_id];
2027     }
2028 
2029     /*
2030      * @dev
2031      *      Check an account is on the allowList.
2032      * @params
2033      *      _id - ID of token to check as listed.
2034      *      _pilot - Pilot address to check as listed.
2035      */
2036     function isAllowListed(uint256 _id, address _pilot)
2037         public
2038         view
2039         returns (bool)
2040     {
2041         bool pilotIsAllowListed = false;
2042         if (allowList[_id] == _pilot) {
2043             pilotIsAllowListed = true;
2044         }
2045         return pilotIsAllowListed;
2046     }
2047 
2048     /*
2049      * @dev
2050      *      Claim evac pod.
2051      * @params
2052      *      _id - ID of tokens to be minted.
2053      */
2054     function evacPodClaim(uint256 _id) external noReentrant {
2055         // Required on public funcs that alter state.
2056         require(!paused, "Exodus is on hold.");
2057 
2058         // Pod must be non-fungible.
2059         require(uid[_id] == false, "Pod already claimed.");
2060 
2061         address pilot = msg.sender;
2062         // Pilot must be on allowListed for token id.
2063         require(allowList[_id] == pilot, "Address is not listed for this pod.");
2064         // Ensure pilot address has not launched.
2065         require(launchClearance[pilot] == false, "Address already owns a pod.");
2066 
2067         // Pilot now cleared for launch.
2068         launchClearance[pilot] = true;
2069 
2070         // Pod ID claimed.
2071         uid[_id] = true;
2072 
2073         // Allocate to pilot.
2074         _mint(pilot, _id, 1, bytes(""));
2075     }
2076 
2077     /*
2078      * @dev
2079      *      Add pilot to launch list.
2080      * @params
2081      *      _podId - Id of pod to launch.
2082      *      _charId - Id of character to allocate.
2083      *      _astrId - Id of asteroid to allocate.
2084      */
2085     function addToLaunchList(
2086         address _pilot,
2087         uint256 _charId,
2088         uint256 _astrId
2089     ) external onlyRole(DISTRIBUTOR) {
2090         // Ensure pilot address has not launched.
2091         require(launchClearance[_pilot] == true, "Address doesn't own a pod.");
2092 
2093         // Ensures the same pilot cannot be allocated twice.
2094         require(
2095             launchList[_pilot].listed == false,
2096             "Address doesn't own a pod."
2097         );
2098 
2099         launchList[_pilot] = TokenIds(
2100             _astrId,
2101             _charId,
2102             block.timestamp + expiry,
2103             true
2104         );
2105     }
2106 
2107     /*
2108      * @dev
2109      *      Remove pilot addresses from the allowList against token IDs.
2110      * @params
2111      *      _pilot - Pilot address to remove from launchList.
2112      */
2113     function removeFromLaunchList(address _pilot)
2114         external
2115         onlyRole(DISTRIBUTOR)
2116     {
2117         delete launchList[_pilot];
2118     }
2119 
2120     /*
2121      * @dev
2122      *      Check an account is on the launchList.
2123      * @params
2124      *      _pilot - Pilot address to check against launchList.
2125      */
2126     function isLaunchListed(address _pilot) public view returns (bool) {
2127         bool pilotLaunchListed = false;
2128 
2129         if (
2130             launchList[_pilot].listed == true &&
2131             block.timestamp <= launchList[_pilot].expiresAt
2132         ) {
2133             pilotLaunchListed = true;
2134         }
2135         return pilotLaunchListed;
2136     }
2137 
2138     /*
2139      * @dev
2140      *       Set pilot's launch clearance.
2141      * @params
2142      *      _pilot - Pilot address to clear.
2143      *      _clearance - Cleared to launch or not.
2144      */
2145     function setLaunchClearance(address _pilot, bool _clearance)
2146         external
2147         onlyRole(DISTRIBUTOR)
2148     {
2149         launchClearance[_pilot] = _clearance;
2150     }
2151 
2152     /*
2153      * @dev
2154      *      Launch pod.
2155      * @params
2156      *      _id - Ids of pod to launch.
2157      */
2158     function _launchPod(uint256 _id) private {
2159         require(!launchStatus[_id]);
2160         launchStatus[_id] = true;
2161     }
2162 
2163     /*
2164      * @dev
2165      *      Launch pod, simultaneously allocating correspoinding assets.
2166      * @params
2167      *      _podId - Id of pod to launch.
2168      *      _charId - Id of character to allocate.
2169      *      _astrId - Id of asteroid to allocate.
2170      */
2171     function evacPodLaunch(
2172         uint256 _podId,
2173         uint256 _charId,
2174         uint256 _astrId
2175     ) external noReentrant {
2176         // Required on public funcs that alter state.
2177         require(!paused, "Exodus is on hold.");
2178 
2179         // Set pilot.
2180         address pilot = msg.sender;
2181 
2182         // launchList IDs must match pilots assigned _astrId and _charId.
2183         require(
2184             launchList[pilot].aId == _astrId,
2185             "Asteroid not assigned to pilot."
2186         );
2187         require(
2188             launchList[pilot].cId == _charId,
2189             "Character not assigned to pilot."
2190         );
2191         // launchList entry must not have expired.
2192         require(
2193             block.timestamp <= launchList[pilot].expiresAt,
2194             "List entry expired."
2195         );
2196 
2197         // Check Pilot is cleared for launch.
2198         require(
2199             launchClearance[pilot] == true,
2200             "Pod is not cleared for launch."
2201         );
2202         require(launchStatus[_podId] == false, "Failure to launch.");
2203 
2204         // Launch pod.
2205         _launchPod(_podId);
2206         // Distribute assets to pilot.
2207         astrContract.fatesAssetTransfer(_astrId, pilot);
2208         charContract.fatesAssetTransfer(_charId, pilot);
2209     }
2210 
2211     /*
2212      * @dev
2213      *      Check a pod's launch status.
2214      * @params
2215      *      _id - Id of pod.
2216      */
2217     function hasLaunched(uint256 _id) public view returns (bool) {
2218         return launchStatus[_id];
2219     }
2220 
2221     /*
2222      * @dev
2223      *      Read the URI to a pod's metadata.
2224      * @params
2225      *      _id - Id of pod.
2226      */
2227     function uri(uint256 _id) public view override returns (string memory) {
2228         if (launchStatus[_id] == true) {
2229             return string(abi.encodePacked(baseURI, launchedURI));
2230         }
2231         return string(abi.encodePacked(baseURI, unlaunchedURI));
2232     }
2233 
2234     /*
2235      * @dev
2236      *      Write the base URI to a pod's metadata.
2237      * @params
2238      *      _uri - Base domain (w/o trailing slash).
2239      */
2240     function setBaseURI(string memory _baseuri) external onlyAdmin {
2241         baseURI = _baseuri;
2242     }
2243 
2244     /*
2245      * @dev
2246      *      Write the launched URI to a pod's metadata.
2247      *      Note: Can use the ERC1155 {id}, per-token substitution.
2248      * @params
2249      *      _suffix - Suffix link to launched state metadata JSON file (with trailing slash).
2250      */
2251     function setLaunchedURI(string memory _suffix) external onlyAdmin {
2252         launchedURI = _suffix;
2253     }
2254 
2255     /*
2256      * @dev
2257      *      Write the launched URI to a pod's metadata.
2258      *      Note: Can use the ERC1155 {id}, per-token substitution.
2259      * @params
2260      *      _suffix - Suffix link to unlaunched state metadata JSON file (with trailing slash).
2261      */
2262     function setUnLaunchedURI(string memory _suffix) external onlyAdmin {
2263         unlaunchedURI = _suffix;
2264     }
2265 
2266     /*
2267      * @dev
2268      *      Ensure marketplaces don't bypass creator royalty.
2269      */
2270     function setApprovalForAll(address operator, bool approved)
2271         public
2272         override
2273         onlyAllowedOperatorApproval(operator)
2274     {
2275         super.setApprovalForAll(operator, approved);
2276     }
2277 
2278     function safeTransferFrom(
2279         address from,
2280         address to,
2281         uint256 tokenId,
2282         uint256 amount,
2283         bytes memory data
2284     ) public override onlyAllowedOperator(from) {
2285         super.safeTransferFrom(from, to, tokenId, amount, data);
2286     }
2287 
2288     function safeBatchTransferFrom(
2289         address from,
2290         address to,
2291         uint256[] memory ids,
2292         uint256[] memory amounts,
2293         bytes memory data
2294     ) public virtual override onlyAllowedOperator(from) {
2295         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2296     }
2297 
2298     function owner()
2299         public
2300         view
2301         virtual
2302         override(Ownable, RevokableOperatorFilterer)
2303         returns (address)
2304     {
2305         return Ownable.owner();
2306     }
2307 
2308     function supportsInterface(bytes4 interfaceId)
2309         public
2310         view
2311         virtual
2312         override(ERC1155, AccessControl, ERC2981Base)
2313         returns (bool)
2314     {
2315         return super.supportsInterface(interfaceId);
2316     }
2317 }