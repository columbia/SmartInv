1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 /**
5 !!!!!!!!!!~~~~~~~~~~~~^^^^^^^^^^^^:^JYJJJJJJ7^:::::::::::::::::::::::::::::::::::::^^^^^^^^^^^^^^~~~
6 !!!!!!!!!~~~~~~~~~~~^^^^^^^^^^^^^^^?YYYYYYYY!^::::::::::::::::::::::::::::::::::::::^^^^^^^^^^^^^^~~
7 !!!!!!!!~~~~~~~~~~~^^^^^^^^^^^^^~~!?????????^:..............:::::::::::::::::::::::::^^^^^^^^^^^^^^~
8 !!!!!!!~~~~~~~~~~~^^^^^^^^^^^~~~~^~777777777^:.................:::::::::::::::::::::::^^^^^^^^^^^^^^
9 !!!!!!!~~~~~~~~~~^^^^^^^^^^~~^^^^^!77777777!:.....................::::::::::::::::::::^^^^^^^^^^^^^^
10 !!!!!!~~~~~~~~~~^^^^^^^^^~~^^^^^^^!!!!!!!77!:.......................:::::::::::::::::::^^^^^^^^^^^^^
11 !!!!!!~~~~~~~~~~^^^^^^^~~^^::::^^^!!!!!!!!7~.........................:::::::::::::::::::^^^^^^^^^^^^
12 !!!!!~~~~~~~~~~^^^^^^^~~^::::::::^!!!777777^..........................::::::::::::::::::^^^^^^^^^^^^
13 !!!!!~~~~~~~~~~^^^^^^~~^::::::^~!?JJJJJJJJJ!^..........................::::::::::::::^^^^^^^^^^^^^^^
14 !!!!!~~~~~~~~~^^^^^^~~^^:::::!J  Real Mfers  7!:........................::::::::::::::^^^^^^^^^^^^^^
15 !!!!!~~~~~~~~~~^^^^~~~^^^::~Y5Y  Real Mfers  !!7!:......................::::::::::::::^^^^^^^^^^^^^^
16 !!!!!!!!~~~~~~~~~~^~~^^^^:755YJ  Real Mfers  7!!7?:...........:^....:...::::::::::::::^^^^^^^^^^^^^^
17 !!!!!!!!!~~~~~~~~~^!~^^^^~55YJJ  Real Mfers  7777?7..........REAL~MFER~.::::::::::::::^^^^^^^^^^^^^^
18 7!!!!!!!!~~~~~~~~~^!~^^^^?P5YJJ  Real Mfers  7777?J^.........P&##~5&&&!.:::::::::::::^^^^^^^^^^^^^^^
19 7!!!!!!!!~~~~~~~~~^!~^^^^?P5YYJ  Real Mfers  7777?Y^..........^^...~!:.::::::::::::::^^^^^^^^^^^^^^^
20 7!!!!!!!!!~~~~~~~~^!!^^^^!P5YYY  Real Mfers  777?JJ:...................::::::::::::::^^^^^^^^^^^^^^^
21 77!!!!!!!!~~~~~~~~^~!~^^^^JP55Y  Real Mfers  ???YY~..................:::^:::::::::::^^^^^^^^^^^^^^^^
22 !7!!!!!!!!!~~~~~~~~^!!~^^^^?PP5  Real Mfers  JY5Y~:.....:7!..........:::^::::::::::^^^^^^^^^^^^^^^^~
23 777!!!!!!!!~~~~~~~~~~!!~^^^^~J5  Real Mfers  5Y7^......:#&BP!^::::::^^~!^::::::::::^^^^^^^^^^^^^^^~~
24 777!!!!!!!!!~~~~~~~~~~!!~^^^::^!J55PPPPPPP55J!^:.......:!B&&##MFER#&&&@@&^::::::::^^^^^^^^^^^^^^^^~~
25 7777!!!!!!!!!~~~~~~~~~~!!~^^^^^::^^~!!77!~^^:.::::::::::::!5G##&&&&##BP57:::::::^^^^^^^^^^^^~^^^^~~~
26 77777!!!!!!!!!!~~~~~~^^~7J!~^^^^^^:::::::::::::::::::::::::::^^~~~!!^::::::::::^^^^^^^^^^^^~~^^^~~~~
27 777777!!!!!!!!!~~~~~!JG#&&G?!~~^^^^^^^^::::::::::::::::::^^^^^^~~~~^:::::^^^^^^^^^^~^^^^^~~~^^~~~~~~
28 77777777!!!!!!!~~~?G#&&&#&&GY?7!~~^^^^^^^^^^^::::::::::^^^^^~~~~~^:^^^^^^^^^^^^^~~~~~^^~~~~~~~~~~~~~
29 777777777!!!!!!!~~7#&&&&&##GPJ?7!7!!~~~~^^^^^^^^^^^^^^^^~~~!~~^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~
30 7777777777!!!!!!!~~7#&&&&&&BP5J7~~!!777!!!!!~~~~~~!!!7!!~~^^:::^^^^^^^^^^^^^^^^^^77??JJ?Y!!!!MFER??J
31 ?77777777777!!!!!!~~7#&&&&&&GPYJ?!~~~~~~!!!!!!!P&&&&&&?:^:^^^^^^^^^^^^~!77??JJYY555PJ7?YG#B#####&&&&
32 ???77777777777!!!!!~~?&&&&&&&G5YJ?!~~~~~~~~~~~~!G@@&&@P^^^^^^^^^^^~!?5G###&&&&&&&GGPJJ??G#GGP55YYJ??
33 ????777777777777!!!!!~?&&&&&&&G5YJJ!!!!~~~~~~~~~^?&@&#&Y^^^^^^~!?5GB#&&BPP5YYJ??7PY575PY5~^^^^^~~~~~
34 ??????777777777777!!!!~J&&&&&&&G5YYJ!!!!!~~~~~~~~~~G@&##G?~!J5GB#&&#GJ!^^^^^~~~~!!777??REALMFERJJLCL
35 ???????7777777777777!!!~J&@&&&&&G55PY~!!!!!~~~~~~~~^J&@&##B#&#&&&&G5YY55PPGGGGBBB#####&&&&&&###BBGGP
36 ??????????777777777777!!~J&@&&&&&GPPGY~!!!!!~~~~~~~~~~Y#@&#############&&&&&&&&###BGGP5YJ??77!!!!!!!
37 ????????????777777777777!~?&@&&&@&BGGBY!!!!!!~~!!!!~~~~~JB&&&&#&&&&&##BGG5YJ?77!~~~~~~~~!!!!!!!!!777
38 */
39 
40 pragma solidity ^0.8.13;
41 
42 interface IOperatorFilterRegistry {
43     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
44     function register(address registrant) external;
45     function registerAndSubscribe(address registrant, address subscription) external;
46     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
47     function updateOperator(address registrant, address operator, bool filtered) external;
48     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
49     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
50     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
51     function subscribe(address registrant, address registrantToSubscribe) external;
52     function unsubscribe(address registrant, bool copyExistingEntries) external;
53     function subscriptionOf(address addr) external returns (address registrant);
54     function subscribers(address registrant) external returns (address[] memory);
55     function subscriberAt(address registrant, uint256 index) external returns (address);
56     function copyEntriesOf(address registrant, address registrantToCopy) external;
57     function isOperatorFiltered(address registrant, address operator) external returns (bool);
58     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
59     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
60     function filteredOperators(address addr) external returns (address[] memory);
61     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
62     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
63     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
64     function isRegistered(address addr) external returns (bool);
65     function codeHashOf(address addr) external returns (bytes32);
66 }
67 
68 // File: operator-filter-registry/src/OperatorFilterer.sol
69 
70 
71 pragma solidity ^0.8.13;
72 
73 
74 abstract contract OperatorFilterer {
75     error OperatorNotAllowed(address operator);
76 
77     IOperatorFilterRegistry constant operatorFilterRegistry =
78         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
79 
80     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
81         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
82         // will not revert, but the contract will need to be registered with the registry once it is deployed in
83         // order for the modifier to filter addresses.
84         if (address(operatorFilterRegistry).code.length > 0) {
85             if (subscribe) {
86                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
87             } else {
88                 if (subscriptionOrRegistrantToCopy != address(0)) {
89                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
90                 } else {
91                     operatorFilterRegistry.register(address(this));
92                 }
93             }
94         }
95     }
96 
97     modifier onlyAllowedOperator(address from) virtual {
98         // Check registry code length to facilitate testing in environments without a deployed registry.
99         if (address(operatorFilterRegistry).code.length > 0) {
100             // Allow spending tokens from addresses with balance
101             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
102             // from an EOA.
103             if (from == msg.sender) {
104                 _;
105                 return;
106             }
107             if (
108                 !(
109                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
110                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
111                 )
112             ) {
113                 revert OperatorNotAllowed(msg.sender);
114             }
115         }
116         _;
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Strings.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev String operations.
129  */
130 library Strings {
131     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
132     uint8 private constant _ADDRESS_LENGTH = 20;
133 
134     /**
135      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
136      */
137     function toString(uint256 value) internal pure returns (string memory) {
138         // Inspired by OraclizeAPI's implementation - MIT licence
139         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
140 
141         if (value == 0) {
142             return "0";
143         }
144         uint256 temp = value;
145         uint256 digits;
146         while (temp != 0) {
147             digits++;
148             temp /= 10;
149         }
150         bytes memory buffer = new bytes(digits);
151         while (value != 0) {
152             digits -= 1;
153             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
154             value /= 10;
155         }
156         return string(buffer);
157     }
158 
159     /**
160      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
161      */
162     function toHexString(uint256 value) internal pure returns (string memory) {
163         if (value == 0) {
164             return "0x00";
165         }
166         uint256 temp = value;
167         uint256 length = 0;
168         while (temp != 0) {
169             length++;
170             temp >>= 8;
171         }
172         return toHexString(value, length);
173     }
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
177      */
178     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
179         bytes memory buffer = new bytes(2 * length + 2);
180         buffer[0] = "0";
181         buffer[1] = "x";
182         for (uint256 i = 2 * length + 1; i > 1; --i) {
183             buffer[i] = _HEX_SYMBOLS[value & 0xf];
184             value >>= 4;
185         }
186         require(value == 0, "Strings: hex length insufficient");
187         return string(buffer);
188     }
189 
190     /**
191      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
192      */
193     function toHexString(address addr) internal pure returns (string memory) {
194         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Context.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Provides information about the current execution context, including the
207  * sender of the transaction and its data. While these are generally available
208  * via msg.sender and msg.data, they should not be accessed in such a direct
209  * manner, since when dealing with meta-transactions the account sending and
210  * paying for execution may not be the actual sender (as far as an application
211  * is concerned).
212  *
213  * This contract is only required for intermediate, library-like contracts.
214  */
215 abstract contract Context {
216     function _msgSender() internal view virtual returns (address) {
217         return msg.sender;
218     }
219 
220     function _msgData() internal view virtual returns (bytes calldata) {
221         return msg.data;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/access/Ownable.sol
226 
227 
228 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 
233 /**
234  * @dev Contract module which provides a basic access control mechanism, where
235  * there is an account (an owner) that can be granted exclusive access to
236  * specific functions.
237  *
238  * By default, the owner account will be the one that deploys the contract. This
239  * can later be changed with {transferOwnership}.
240  *
241  * This module is used through inheritance. It will make available the modifier
242  * `onlyOwner`, which can be applied to your functions to restrict their use to
243  * the owner.
244  */
245 abstract contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor() {
254         _transferOwnership(_msgSender());
255     }
256 
257     /**
258      * @dev Throws if called by any account other than the owner.
259      */
260     modifier onlyOwner() {
261         _checkOwner();
262         _;
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view virtual returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if the sender is not the owner.
274      */
275     function _checkOwner() internal view virtual {
276         require(owner() == _msgSender(), "Ownable: caller is not the owner");
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         _transferOwnership(address(0));
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: erc721a/contracts/IERC721A.sol
311 
312 
313 // ERC721A Contracts v4.2.3
314 // Creator: Chiru Labs
315 
316 pragma solidity ^0.8.4;
317 
318 /**
319  * @dev Interface of ERC721A.
320  */
321 interface IERC721A {
322     /**
323      * The caller must own the token or be an approved operator.
324      */
325     error ApprovalCallerNotOwnerNorApproved();
326 
327     /**
328      * The token does not exist.
329      */
330     error ApprovalQueryForNonexistentToken();
331 
332     /**
333      * Cannot query the balance for the zero address.
334      */
335     error BalanceQueryForZeroAddress();
336 
337     /**
338      * Cannot mint to the zero address.
339      */
340     error MintToZeroAddress();
341 
342     /**
343      * The quantity of tokens minted must be more than zero.
344      */
345     error MintZeroQuantity();
346 
347     /**
348      * The token does not exist.
349      */
350     error OwnerQueryForNonexistentToken();
351 
352     /**
353      * The caller must own the token or be an approved operator.
354      */
355     error TransferCallerNotOwnerNorApproved();
356 
357     /**
358      * The token must be owned by `from`.
359      */
360     error TransferFromIncorrectOwner();
361 
362     /**
363      * Cannot safely transfer to a contract that does not implement the
364      * ERC721Receiver interface.
365      */
366     error TransferToNonERC721ReceiverImplementer();
367 
368     /**
369      * Cannot transfer to the zero address.
370      */
371     error TransferToZeroAddress();
372 
373     /**
374      * The token does not exist.
375      */
376     error URIQueryForNonexistentToken();
377 
378     /**
379      * The `quantity` minted with ERC2309 exceeds the safety limit.
380      */
381     error MintERC2309QuantityExceedsLimit();
382 
383     /**
384      * The `extraData` cannot be set on an unintialized ownership slot.
385      */
386     error OwnershipNotInitializedForExtraData();
387 
388     // =============================================================
389     //                            STRUCTS
390     // =============================================================
391 
392     struct TokenOwnership {
393         // The address of the owner.
394         address addr;
395         // Stores the start time of ownership with minimal overhead for tokenomics.
396         uint64 startTimestamp;
397         // Whether the token has been burned.
398         bool burned;
399         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
400         uint24 extraData;
401     }
402 
403     // =============================================================
404     //                         TOKEN COUNTERS
405     // =============================================================
406 
407     /**
408      * @dev Returns the total number of tokens in existence.
409      * Burned tokens will reduce the count.
410      * To get the total number of tokens minted, please see {_totalMinted}.
411      */
412     function totalSupply() external view returns (uint256);
413 
414     // =============================================================
415     //                            IERC165
416     // =============================================================
417 
418     /**
419      * @dev Returns true if this contract implements the interface defined by
420      * `interfaceId`. See the corresponding
421      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
422      * to learn more about how these ids are created.
423      *
424      * This function call must use less than 30000 gas.
425      */
426     function supportsInterface(bytes4 interfaceId) external view returns (bool);
427 
428     // =============================================================
429     //                            IERC721
430     // =============================================================
431 
432     /**
433      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
436 
437     /**
438      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
439      */
440     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables or disables
444      * (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in `owner`'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`,
464      * checking first that contract recipients are aware of the ERC721 protocol
465      * to prevent tokens from being forever locked.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must exist and be owned by `from`.
472      * - If the caller is not `from`, it must be have been allowed to move
473      * this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement
475      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
476      *
477      * Emits a {Transfer} event.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId,
483         bytes calldata data
484     ) external payable;
485 
486     /**
487      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external payable;
494 
495     /**
496      * @dev Transfers `tokenId` from `from` to `to`.
497      *
498      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
499      * whenever possible.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token
507      * by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external payable;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the
522      * zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external payable;
532 
533     /**
534      * @dev Approve or remove `operator` as an operator for the caller.
535      * Operators can call {transferFrom} or {safeTransferFrom}
536      * for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns the account approved for `tokenId` token.
548      *
549      * Requirements:
550      *
551      * - `tokenId` must exist.
552      */
553     function getApproved(uint256 tokenId) external view returns (address operator);
554 
555     /**
556      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
557      *
558      * See {setApprovalForAll}.
559      */
560     function isApprovedForAll(address owner, address operator) external view returns (bool);
561 
562     // =============================================================
563     //                        IERC721Metadata
564     // =============================================================
565 
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() external view returns (string memory);
570 
571     /**
572      * @dev Returns the token collection symbol.
573      */
574     function symbol() external view returns (string memory);
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) external view returns (string memory);
580 
581     // =============================================================
582     //                           IERC2309
583     // =============================================================
584 
585     /**
586      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
587      * (inclusive) is transferred from `from` to `to`, as defined in the
588      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
589      *
590      * See {_mintERC2309} for more details.
591      */
592     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
593 }
594 
595 // File: erc721a/contracts/ERC721A.sol
596 
597 
598 // ERC721A Contracts v4.2.3
599 // Creator: Chiru Labs
600 
601 pragma solidity ^0.8.4;
602 
603 
604 /**
605  * @dev Interface of ERC721 token receiver.
606  */
607 interface ERC721A__IERC721Receiver {
608     function onERC721Received(
609         address operator,
610         address from,
611         uint256 tokenId,
612         bytes calldata data
613     ) external returns (bytes4);
614 }
615 
616 /**
617  * @title ERC721A
618  *
619  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
620  * Non-Fungible Token Standard, including the Metadata extension.
621  * Optimized for lower gas during batch mints.
622  *
623  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
624  * starting from `_startTokenId()`.
625  *
626  * Assumptions:
627  *
628  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
629  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
630  */
631 contract ERC721A is IERC721A {
632     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
633     struct TokenApprovalRef {
634         address value;
635     }
636 
637     // =============================================================
638     //                           CONSTANTS
639     // =============================================================
640 
641     // Mask of an entry in packed address data.
642     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
643 
644     // The bit position of `numberMinted` in packed address data.
645     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
646 
647     // The bit position of `numberBurned` in packed address data.
648     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
649 
650     // The bit position of `aux` in packed address data.
651     uint256 private constant _BITPOS_AUX = 192;
652 
653     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
654     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
655 
656     // The bit position of `startTimestamp` in packed ownership.
657     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
658 
659     // The bit mask of the `burned` bit in packed ownership.
660     uint256 private constant _BITMASK_BURNED = 1 << 224;
661 
662     // The bit position of the `nextInitialized` bit in packed ownership.
663     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
664 
665     // The bit mask of the `nextInitialized` bit in packed ownership.
666     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
667 
668     // The bit position of `extraData` in packed ownership.
669     uint256 private constant _BITPOS_EXTRA_DATA = 232;
670 
671     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
672     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
673 
674     // The mask of the lower 160 bits for addresses.
675     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
676 
677     // The maximum `quantity` that can be minted with {_mintERC2309}.
678     // This limit is to prevent overflows on the address data entries.
679     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
680     // is required to cause an overflow, which is unrealistic.
681     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
682 
683     // The `Transfer` event signature is given by:
684     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
685     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
686         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
687 
688     // =============================================================
689     //                            STORAGE
690     // =============================================================
691 
692     // The next token ID to be minted.
693     uint256 private _currentIndex;
694 
695     // The number of tokens burned.
696     uint256 private _burnCounter;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     // Mapping from token ID to ownership details
705     // An empty struct value does not necessarily mean the token is unowned.
706     // See {_packedOwnershipOf} implementation for details.
707     //
708     // Bits Layout:
709     // - [0..159]   `addr`
710     // - [160..223] `startTimestamp`
711     // - [224]      `burned`
712     // - [225]      `nextInitialized`
713     // - [232..255] `extraData`
714     mapping(uint256 => uint256) private _packedOwnerships;
715 
716     // Mapping owner address to address data.
717     //
718     // Bits Layout:
719     // - [0..63]    `balance`
720     // - [64..127]  `numberMinted`
721     // - [128..191] `numberBurned`
722     // - [192..255] `aux`
723     mapping(address => uint256) private _packedAddressData;
724 
725     // Mapping from token ID to approved address.
726     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
727 
728     // Mapping from owner to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     // =============================================================
732     //                          CONSTRUCTOR
733     // =============================================================
734 
735     constructor(string memory name_, string memory symbol_) {
736         _name = name_;
737         _symbol = symbol_;
738         _currentIndex = _startTokenId();
739     }
740 
741     // =============================================================
742     //                   TOKEN COUNTING OPERATIONS
743     // =============================================================
744 
745     /**
746      * @dev Returns the starting token ID.
747      * To change the starting token ID, please override this function.
748      */
749     function _startTokenId() internal view virtual returns (uint256) {
750         return 0;
751     }
752 
753     /**
754      * @dev Returns the next token ID to be minted.
755      */
756     function _nextTokenId() internal view virtual returns (uint256) {
757         return _currentIndex;
758     }
759 
760     /**
761      * @dev Returns the total number of tokens in existence.
762      * Burned tokens will reduce the count.
763      * To get the total number of tokens minted, please see {_totalMinted}.
764      */
765     function totalSupply() public view virtual override returns (uint256) {
766         // Counter underflow is impossible as _burnCounter cannot be incremented
767         // more than `_currentIndex - _startTokenId()` times.
768         unchecked {
769             return _currentIndex - _burnCounter - _startTokenId();
770         }
771     }
772 
773     /**
774      * @dev Returns the total amount of tokens minted in the contract.
775      */
776     function _totalMinted() internal view virtual returns (uint256) {
777         // Counter underflow is impossible as `_currentIndex` does not decrement,
778         // and it is initialized to `_startTokenId()`.
779         unchecked {
780             return _currentIndex - _startTokenId();
781         }
782     }
783 
784     /**
785      * @dev Returns the total number of tokens burned.
786      */
787     function _totalBurned() internal view virtual returns (uint256) {
788         return _burnCounter;
789     }
790 
791     // =============================================================
792     //                    ADDRESS DATA OPERATIONS
793     // =============================================================
794 
795     /**
796      * @dev Returns the number of tokens in `owner`'s account.
797      */
798     function balanceOf(address owner) public view virtual override returns (uint256) {
799         if (owner == address(0)) revert BalanceQueryForZeroAddress();
800         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
801     }
802 
803     /**
804      * Returns the number of tokens minted by `owner`.
805      */
806     function _numberMinted(address owner) internal view returns (uint256) {
807         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
808     }
809 
810     /**
811      * Returns the number of tokens burned by or on behalf of `owner`.
812      */
813     function _numberBurned(address owner) internal view returns (uint256) {
814         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
815     }
816 
817     /**
818      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
819      */
820     function _getAux(address owner) internal view returns (uint64) {
821         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
822     }
823 
824     /**
825      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
826      * If there are multiple variables, please pack them into a uint64.
827      */
828     function _setAux(address owner, uint64 aux) internal virtual {
829         uint256 packed = _packedAddressData[owner];
830         uint256 auxCasted;
831         // Cast `aux` with assembly to avoid redundant masking.
832         assembly {
833             auxCasted := aux
834         }
835         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
836         _packedAddressData[owner] = packed;
837     }
838 
839     // =============================================================
840     //                            IERC165
841     // =============================================================
842 
843     /**
844      * @dev Returns true if this contract implements the interface defined by
845      * `interfaceId`. See the corresponding
846      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
847      * to learn more about how these ids are created.
848      *
849      * This function call must use less than 30000 gas.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
852         // The interface IDs are constants representing the first 4 bytes
853         // of the XOR of all function selectors in the interface.
854         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
855         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
856         return
857             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
858             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
859             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
860     }
861 
862     // =============================================================
863     //                        IERC721Metadata
864     // =============================================================
865 
866     /**
867      * @dev Returns the token collection name.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev Returns the token collection symbol.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, it can be overridden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return '';
897     }
898 
899     // =============================================================
900     //                     OWNERSHIPS OPERATIONS
901     // =============================================================
902 
903     /**
904      * @dev Returns the owner of the `tokenId` token.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      */
910     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
911         return address(uint160(_packedOwnershipOf(tokenId)));
912     }
913 
914     /**
915      * @dev Gas spent here starts off proportional to the maximum mint batch size.
916      * It gradually moves to O(1) as tokens get transferred around over time.
917      */
918     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
919         return _unpackedOwnership(_packedOwnershipOf(tokenId));
920     }
921 
922     /**
923      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
924      */
925     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
926         return _unpackedOwnership(_packedOwnerships[index]);
927     }
928 
929     /**
930      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
931      */
932     function _initializeOwnershipAt(uint256 index) internal virtual {
933         if (_packedOwnerships[index] == 0) {
934             _packedOwnerships[index] = _packedOwnershipOf(index);
935         }
936     }
937 
938     /**
939      * Returns the packed ownership data of `tokenId`.
940      */
941     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
942         uint256 curr = tokenId;
943 
944         unchecked {
945             if (_startTokenId() <= curr)
946                 if (curr < _currentIndex) {
947                     uint256 packed = _packedOwnerships[curr];
948                     // If not burned.
949                     if (packed & _BITMASK_BURNED == 0) {
950                         // Invariant:
951                         // There will always be an initialized ownership slot
952                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
953                         // before an unintialized ownership slot
954                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
955                         // Hence, `curr` will not underflow.
956                         //
957                         // We can directly compare the packed value.
958                         // If the address is zero, packed will be zero.
959                         while (packed == 0) {
960                             packed = _packedOwnerships[--curr];
961                         }
962                         return packed;
963                     }
964                 }
965         }
966         revert OwnerQueryForNonexistentToken();
967     }
968 
969     /**
970      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
971      */
972     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
973         ownership.addr = address(uint160(packed));
974         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
975         ownership.burned = packed & _BITMASK_BURNED != 0;
976         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
977     }
978 
979     /**
980      * @dev Packs ownership data into a single uint256.
981      */
982     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
983         assembly {
984             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
985             owner := and(owner, _BITMASK_ADDRESS)
986             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
987             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
988         }
989     }
990 
991     /**
992      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
993      */
994     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
995         // For branchless setting of the `nextInitialized` flag.
996         assembly {
997             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
998             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
999         }
1000     }
1001 
1002     // =============================================================
1003     //                      APPROVAL OPERATIONS
1004     // =============================================================
1005 
1006     /**
1007      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1008      * The approval is cleared when the token is transferred.
1009      *
1010      * Only a single account can be approved at a time, so approving the
1011      * zero address clears previous approvals.
1012      *
1013      * Requirements:
1014      *
1015      * - The caller must own the token or be an approved operator.
1016      * - `tokenId` must exist.
1017      *
1018      * Emits an {Approval} event.
1019      */
1020     function approve(address to, uint256 tokenId) public payable virtual override {
1021         address owner = ownerOf(tokenId);
1022 
1023         if (_msgSenderERC721A() != owner)
1024             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1025                 revert ApprovalCallerNotOwnerNorApproved();
1026             }
1027 
1028         _tokenApprovals[tokenId].value = to;
1029         emit Approval(owner, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Returns the account approved for `tokenId` token.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1040         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1041 
1042         return _tokenApprovals[tokenId].value;
1043     }
1044 
1045     /**
1046      * @dev Approve or remove `operator` as an operator for the caller.
1047      * Operators can call {transferFrom} or {safeTransferFrom}
1048      * for any token owned by the caller.
1049      *
1050      * Requirements:
1051      *
1052      * - The `operator` cannot be the caller.
1053      *
1054      * Emits an {ApprovalForAll} event.
1055      */
1056     function setApprovalForAll(address operator, bool approved) public virtual override {
1057         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1058         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1059     }
1060 
1061     /**
1062      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1063      *
1064      * See {setApprovalForAll}.
1065      */
1066     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1067         return _operatorApprovals[owner][operator];
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted. See {_mint}.
1076      */
1077     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1078         return
1079             _startTokenId() <= tokenId &&
1080             tokenId < _currentIndex && // If within bounds,
1081             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1082     }
1083 
1084     /**
1085      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1086      */
1087     function _isSenderApprovedOrOwner(
1088         address approvedAddress,
1089         address owner,
1090         address msgSender
1091     ) private pure returns (bool result) {
1092         assembly {
1093             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1094             owner := and(owner, _BITMASK_ADDRESS)
1095             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1096             msgSender := and(msgSender, _BITMASK_ADDRESS)
1097             // `msgSender == owner || msgSender == approvedAddress`.
1098             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1099         }
1100     }
1101 
1102     /**
1103      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1104      */
1105     function _getApprovedSlotAndAddress(uint256 tokenId)
1106         private
1107         view
1108         returns (uint256 approvedAddressSlot, address approvedAddress)
1109     {
1110         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1111         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1112         assembly {
1113             approvedAddressSlot := tokenApproval.slot
1114             approvedAddress := sload(approvedAddressSlot)
1115         }
1116     }
1117 
1118     // =============================================================
1119     //                      TRANSFER OPERATIONS
1120     // =============================================================
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      * - If the caller is not `from`, it must be approved to move this token
1131      * by either {approve} or {setApprovalForAll}.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function transferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public payable virtual override {
1140         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1141 
1142         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1143 
1144         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1145 
1146         // The nested ifs save around 20+ gas over a compound boolean condition.
1147         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1148             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1149 
1150         if (to == address(0)) revert TransferToZeroAddress();
1151 
1152         _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154         // Clear approvals from the previous owner.
1155         assembly {
1156             if approvedAddress {
1157                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1158                 sstore(approvedAddressSlot, 0)
1159             }
1160         }
1161 
1162         // Underflow of the sender's balance is impossible because we check for
1163         // ownership above and the recipient's balance can't realistically overflow.
1164         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1165         unchecked {
1166             // We can directly increment and decrement the balances.
1167             --_packedAddressData[from]; // Updates: `balance -= 1`.
1168             ++_packedAddressData[to]; // Updates: `balance += 1`.
1169 
1170             // Updates:
1171             // - `address` to the next owner.
1172             // - `startTimestamp` to the timestamp of transfering.
1173             // - `burned` to `false`.
1174             // - `nextInitialized` to `true`.
1175             _packedOwnerships[tokenId] = _packOwnershipData(
1176                 to,
1177                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1178             );
1179 
1180             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1181             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1182                 uint256 nextTokenId = tokenId + 1;
1183                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1184                 if (_packedOwnerships[nextTokenId] == 0) {
1185                     // If the next slot is within bounds.
1186                     if (nextTokenId != _currentIndex) {
1187                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1188                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1189                     }
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, to, tokenId);
1195         _afterTokenTransfers(from, to, tokenId, 1);
1196     }
1197 
1198     /**
1199      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public payable virtual override {
1206         safeTransferFrom(from, to, tokenId, '');
1207     }
1208 
1209     /**
1210      * @dev Safely transfers `tokenId` token from `from` to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `from` cannot be the zero address.
1215      * - `to` cannot be the zero address.
1216      * - `tokenId` token must exist and be owned by `from`.
1217      * - If the caller is not `from`, it must be approved to move this token
1218      * by either {approve} or {setApprovalForAll}.
1219      * - If `to` refers to a smart contract, it must implement
1220      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function safeTransferFrom(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) public payable virtual override {
1230         transferFrom(from, to, tokenId);
1231         if (to.code.length != 0)
1232             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1233                 revert TransferToNonERC721ReceiverImplementer();
1234             }
1235     }
1236 
1237     /**
1238      * @dev Hook that is called before a set of serially-ordered token IDs
1239      * are about to be transferred. This includes minting.
1240      * And also called before burning one token.
1241      *
1242      * `startTokenId` - the first token ID to be transferred.
1243      * `quantity` - the amount to be transferred.
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, `tokenId` will be burned by `from`.
1251      * - `from` and `to` are never both zero.
1252      */
1253     function _beforeTokenTransfers(
1254         address from,
1255         address to,
1256         uint256 startTokenId,
1257         uint256 quantity
1258     ) internal virtual {}
1259 
1260     /**
1261      * @dev Hook that is called after a set of serially-ordered token IDs
1262      * have been transferred. This includes minting.
1263      * And also called after one token has been burned.
1264      *
1265      * `startTokenId` - the first token ID to be transferred.
1266      * `quantity` - the amount to be transferred.
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` has been minted for `to`.
1273      * - When `to` is zero, `tokenId` has been burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _afterTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1285      *
1286      * `from` - Previous owner of the given token ID.
1287      * `to` - Target address that will receive the token.
1288      * `tokenId` - Token ID to be transferred.
1289      * `_data` - Optional data to send along with the call.
1290      *
1291      * Returns whether the call correctly returned the expected magic value.
1292      */
1293     function _checkContractOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1300             bytes4 retval
1301         ) {
1302             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1303         } catch (bytes memory reason) {
1304             if (reason.length == 0) {
1305                 revert TransferToNonERC721ReceiverImplementer();
1306             } else {
1307                 assembly {
1308                     revert(add(32, reason), mload(reason))
1309                 }
1310             }
1311         }
1312     }
1313 
1314     // =============================================================
1315     //                        MINT OPERATIONS
1316     // =============================================================
1317 
1318     /**
1319      * @dev Mints `quantity` tokens and transfers them to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `quantity` must be greater than 0.
1325      *
1326      * Emits a {Transfer} event for each mint.
1327      */
1328     function _mint(address to, uint256 quantity) internal virtual {
1329         uint256 startTokenId = _currentIndex;
1330         if (quantity == 0) revert MintZeroQuantity();
1331 
1332         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1333 
1334         // Overflows are incredibly unrealistic.
1335         // `balance` and `numberMinted` have a maximum limit of 2**64.
1336         // `tokenId` has a maximum limit of 2**256.
1337         unchecked {
1338             // Updates:
1339             // - `balance += quantity`.
1340             // - `numberMinted += quantity`.
1341             //
1342             // We can directly add to the `balance` and `numberMinted`.
1343             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1344 
1345             // Updates:
1346             // - `address` to the owner.
1347             // - `startTimestamp` to the timestamp of minting.
1348             // - `burned` to `false`.
1349             // - `nextInitialized` to `quantity == 1`.
1350             _packedOwnerships[startTokenId] = _packOwnershipData(
1351                 to,
1352                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1353             );
1354 
1355             uint256 toMasked;
1356             uint256 end = startTokenId + quantity;
1357 
1358             // Use assembly to loop and emit the `Transfer` event for gas savings.
1359             // The duplicated `log4` removes an extra check and reduces stack juggling.
1360             // The assembly, together with the surrounding Solidity code, have been
1361             // delicately arranged to nudge the compiler into producing optimized opcodes.
1362             assembly {
1363                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1364                 toMasked := and(to, _BITMASK_ADDRESS)
1365                 // Emit the `Transfer` event.
1366                 log4(
1367                     0, // Start of data (0, since no data).
1368                     0, // End of data (0, since no data).
1369                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1370                     0, // `address(0)`.
1371                     toMasked, // `to`.
1372                     startTokenId // `tokenId`.
1373                 )
1374 
1375                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1376                 // that overflows uint256 will make the loop run out of gas.
1377                 // The compiler will optimize the `iszero` away for performance.
1378                 for {
1379                     let tokenId := add(startTokenId, 1)
1380                 } iszero(eq(tokenId, end)) {
1381                     tokenId := add(tokenId, 1)
1382                 } {
1383                     // Emit the `Transfer` event. Similar to above.
1384                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1385                 }
1386             }
1387             if (toMasked == 0) revert MintToZeroAddress();
1388 
1389             _currentIndex = end;
1390         }
1391         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1392     }
1393 
1394     /**
1395      * @dev Mints `quantity` tokens and transfers them to `to`.
1396      *
1397      * This function is intended for efficient minting only during contract creation.
1398      *
1399      * It emits only one {ConsecutiveTransfer} as defined in
1400      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1401      * instead of a sequence of {Transfer} event(s).
1402      *
1403      * Calling this function outside of contract creation WILL make your contract
1404      * non-compliant with the ERC721 standard.
1405      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1406      * {ConsecutiveTransfer} event is only permissible during contract creation.
1407      *
1408      * Requirements:
1409      *
1410      * - `to` cannot be the zero address.
1411      * - `quantity` must be greater than 0.
1412      *
1413      * Emits a {ConsecutiveTransfer} event.
1414      */
1415     function _mintERC2309(address to, uint256 quantity) internal virtual {
1416         uint256 startTokenId = _currentIndex;
1417         if (to == address(0)) revert MintToZeroAddress();
1418         if (quantity == 0) revert MintZeroQuantity();
1419         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1420 
1421         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1422 
1423         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1424         unchecked {
1425             // Updates:
1426             // - `balance += quantity`.
1427             // - `numberMinted += quantity`.
1428             //
1429             // We can directly add to the `balance` and `numberMinted`.
1430             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1431 
1432             // Updates:
1433             // - `address` to the owner.
1434             // - `startTimestamp` to the timestamp of minting.
1435             // - `burned` to `false`.
1436             // - `nextInitialized` to `quantity == 1`.
1437             _packedOwnerships[startTokenId] = _packOwnershipData(
1438                 to,
1439                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1440             );
1441 
1442             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1443 
1444             _currentIndex = startTokenId + quantity;
1445         }
1446         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1447     }
1448 
1449     /**
1450      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1451      *
1452      * Requirements:
1453      *
1454      * - If `to` refers to a smart contract, it must implement
1455      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1456      * - `quantity` must be greater than 0.
1457      *
1458      * See {_mint}.
1459      *
1460      * Emits a {Transfer} event for each mint.
1461      */
1462     function _safeMint(
1463         address to,
1464         uint256 quantity,
1465         bytes memory _data
1466     ) internal virtual {
1467         _mint(to, quantity);
1468 
1469         unchecked {
1470             if (to.code.length != 0) {
1471                 uint256 end = _currentIndex;
1472                 uint256 index = end - quantity;
1473                 do {
1474                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1475                         revert TransferToNonERC721ReceiverImplementer();
1476                     }
1477                 } while (index < end);
1478                 // Reentrancy protection.
1479                 if (_currentIndex != end) revert();
1480             }
1481         }
1482     }
1483 
1484     /**
1485      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1486      */
1487     function _safeMint(address to, uint256 quantity) internal virtual {
1488         _safeMint(to, quantity, '');
1489     }
1490 
1491     // =============================================================
1492     //                        BURN OPERATIONS
1493     // =============================================================
1494 
1495     /**
1496      * @dev Equivalent to `_burn(tokenId, false)`.
1497      */
1498     function _burn(uint256 tokenId) internal virtual {
1499         _burn(tokenId, false);
1500     }
1501 
1502     /**
1503      * @dev Destroys `tokenId`.
1504      * The approval is cleared when the token is burned.
1505      *
1506      * Requirements:
1507      *
1508      * - `tokenId` must exist.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1513         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1514 
1515         address from = address(uint160(prevOwnershipPacked));
1516 
1517         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1518 
1519         if (approvalCheck) {
1520             // The nested ifs save around 20+ gas over a compound boolean condition.
1521             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1522                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1523         }
1524 
1525         _beforeTokenTransfers(from, address(0), tokenId, 1);
1526 
1527         // Clear approvals from the previous owner.
1528         assembly {
1529             if approvedAddress {
1530                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1531                 sstore(approvedAddressSlot, 0)
1532             }
1533         }
1534 
1535         // Underflow of the sender's balance is impossible because we check for
1536         // ownership above and the recipient's balance can't realistically overflow.
1537         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1538         unchecked {
1539             // Updates:
1540             // - `balance -= 1`.
1541             // - `numberBurned += 1`.
1542             //
1543             // We can directly decrement the balance, and increment the number burned.
1544             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1545             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1546 
1547             // Updates:
1548             // - `address` to the last owner.
1549             // - `startTimestamp` to the timestamp of burning.
1550             // - `burned` to `true`.
1551             // - `nextInitialized` to `true`.
1552             _packedOwnerships[tokenId] = _packOwnershipData(
1553                 from,
1554                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1555             );
1556 
1557             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1558             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1559                 uint256 nextTokenId = tokenId + 1;
1560                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1561                 if (_packedOwnerships[nextTokenId] == 0) {
1562                     // If the next slot is within bounds.
1563                     if (nextTokenId != _currentIndex) {
1564                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1565                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1566                     }
1567                 }
1568             }
1569         }
1570 
1571         emit Transfer(from, address(0), tokenId);
1572         _afterTokenTransfers(from, address(0), tokenId, 1);
1573 
1574         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1575         unchecked {
1576             _burnCounter++;
1577         }
1578     }
1579 
1580     // =============================================================
1581     //                     EXTRA DATA OPERATIONS
1582     // =============================================================
1583 
1584     /**
1585      * @dev Directly sets the extra data for the ownership data `index`.
1586      */
1587     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1588         uint256 packed = _packedOwnerships[index];
1589         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1590         uint256 extraDataCasted;
1591         // Cast `extraData` with assembly to avoid redundant masking.
1592         assembly {
1593             extraDataCasted := extraData
1594         }
1595         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1596         _packedOwnerships[index] = packed;
1597     }
1598 
1599     /**
1600      * @dev Called during each token transfer to set the 24bit `extraData` field.
1601      * Intended to be overridden by the cosumer contract.
1602      *
1603      * `previousExtraData` - the value of `extraData` before transfer.
1604      *
1605      * Calling conditions:
1606      *
1607      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1608      * transferred to `to`.
1609      * - When `from` is zero, `tokenId` will be minted for `to`.
1610      * - When `to` is zero, `tokenId` will be burned by `from`.
1611      * - `from` and `to` are never both zero.
1612      */
1613     function _extraData(
1614         address from,
1615         address to,
1616         uint24 previousExtraData
1617     ) internal view virtual returns (uint24) {}
1618 
1619     /**
1620      * @dev Returns the next extra data for the packed ownership data.
1621      * The returned result is shifted into position.
1622      */
1623     function _nextExtraData(
1624         address from,
1625         address to,
1626         uint256 prevOwnershipPacked
1627     ) private view returns (uint256) {
1628         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1629         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1630     }
1631 
1632     // =============================================================
1633     //                       OTHER OPERATIONS
1634     // =============================================================
1635 
1636     /**
1637      * @dev Returns the message sender (defaults to `msg.sender`).
1638      *
1639      * If you are writing GSN compatible contracts, you need to override this function.
1640      */
1641     function _msgSenderERC721A() internal view virtual returns (address) {
1642         return msg.sender;
1643     }
1644 
1645     /**
1646      * @dev Converts a uint256 to its ASCII string decimal representation.
1647      */
1648     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1649         assembly {
1650             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1651             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1652             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1653             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1654             let m := add(mload(0x40), 0xa0)
1655             // Update the free memory pointer to allocate.
1656             mstore(0x40, m)
1657             // Assign the `str` to the end.
1658             str := sub(m, 0x20)
1659             // Zeroize the slot after the string.
1660             mstore(str, 0)
1661 
1662             // Cache the end of the memory to calculate the length later.
1663             let end := str
1664 
1665             // We write the string from rightmost digit to leftmost digit.
1666             // The following is essentially a do-while loop that also handles the zero case.
1667             // prettier-ignore
1668             for { let temp := value } 1 {} {
1669                 str := sub(str, 1)
1670                 // Write the character to the pointer.
1671                 // The ASCII index of the '0' character is 48.
1672                 mstore8(str, add(48, mod(temp, 10)))
1673                 // Keep dividing `temp` until zero.
1674                 temp := div(temp, 10)
1675                 // prettier-ignore
1676                 if iszero(temp) { break }
1677             }
1678 
1679             let length := sub(end, str)
1680             // Move the pointer 32 bytes leftwards to make room for the length.
1681             str := sub(str, 0x20)
1682             // Store the length.
1683             mstore(str, length)
1684         }
1685     }
1686 }
1687 
1688 pragma solidity ^0.8.13;
1689 
1690 contract RealMfers is ERC721A, Ownable, OperatorFilterer {
1691     using Strings for uint256;
1692 
1693     uint256 public maxSupply = 4200;
1694 	 uint256 public Ownermint = 1;
1695       uint256 public MfersPerAddress = 100;
1696 	   uint256 public MfersPerTX = 3;
1697         uint256 public mfingCost = 0.002 ether;
1698          address public constant OSbullsht = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1699 
1700         bool public paused = true;
1701 
1702 	  string public uriPrefix = '';
1703     string public uriSuffix = '.json';
1704 	
1705   constructor(string memory baseURI) ERC721A("Real Mfers", "RLMFERS") OperatorFilterer(address(OSbullsht), false) {
1706       setUriPrefix(baseURI); 
1707       _safeMint(_msgSender(), Ownermint);
1708 
1709   }
1710 
1711   modifier callerIsUser() {
1712         require(tx.origin == msg.sender, "The caller is another contract");
1713         _;
1714     }
1715 
1716   function numberMinted(address owner) public view returns (uint256) {
1717         return _numberMinted(owner);
1718     }
1719 
1720   function mintMfer(uint256 _mintAmount) public payable callerIsUser{
1721         require(!paused, 'The contract is paused!');
1722          require(numberMinted(msg.sender) + _mintAmount <= MfersPerAddress, 'You are a greedy mfer');
1723           require(_mintAmount > 0 && _mintAmount <= MfersPerTX, 'Weird amount of Mfers');
1724            require(totalSupply() + _mintAmount <= (maxSupply), 'No more mfers');
1725            require(msg.value >= mfingCost * _mintAmount, 'Insufficient funds!');
1726 
1727             _safeMint(_msgSender(), _mintAmount);
1728   }
1729 
1730   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1731     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1732       string memory currentBaseURI = _baseURI();
1733        return bytes(currentBaseURI).length > 0
1734           ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1735            : '';
1736   }
1737 
1738   function pauseMfingContract() public onlyOwner {
1739     paused = !paused;
1740   }
1741 
1742   function setMfingCost(uint256 newCost) public onlyOwner {
1743     mfingCost = newCost;
1744   }
1745 
1746   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1747     uriPrefix = _uriPrefix;
1748   }
1749 
1750   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1751     uriSuffix = _uriSuffix;
1752   }
1753 
1754   function withdraw() external onlyOwner{
1755     payable(msg.sender).transfer(address(this).balance);
1756   }
1757 
1758   // Internal ->
1759   function _startTokenId() internal view virtual override returns (uint256) {
1760     return 1;
1761   }
1762 
1763   function _baseURI() internal view virtual override returns (string memory) {
1764     return uriPrefix;
1765   }
1766     //Opensea shit 
1767     function transferFrom(address from, address to, uint256 tokenId)
1768         public
1769         payable
1770         override
1771         onlyAllowedOperator(from)
1772     {
1773         super.transferFrom(from, to, tokenId);
1774     }
1775 
1776     function safeTransferFrom(address from, address to, uint256 tokenId)
1777         public
1778         payable
1779         override
1780         onlyAllowedOperator(from)
1781     {
1782         super.safeTransferFrom(from, to, tokenId);
1783     }
1784 
1785     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1786         public
1787         payable
1788         override
1789         onlyAllowedOperator(from)
1790     {
1791         super.safeTransferFrom(from, to, tokenId, data);
1792     }
1793 }