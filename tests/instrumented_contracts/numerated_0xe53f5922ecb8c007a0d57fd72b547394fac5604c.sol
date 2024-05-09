1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠋⢉⣭⣥⣌⡉⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
10 ⠀⠀⠀⠀⠀⢀⣀⣀⡀⠻⢿⣷⣤⠉⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⢀⣴⣿⣿⣿⡿⢁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀
11 ⠀⠀⠀⢀⣴⣿⣿⣿⣿⣷⣄⠙⢿⣷⣄⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⠇⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀
12 ⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠙⣿⣧⠈⢿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡟⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
13 ⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⢿⣧⠈⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
14 ⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠈⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
15 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⠿⠇⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃
16 ⢸⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀
17 ⠀⠁⠀⣼⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀
18 ⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 */
20 
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity ^0.8.13;
25 
26 interface IOperatorFilterRegistry {
27     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
28     function register(address registrant) external;
29     function registerAndSubscribe(address registrant, address subscription) external;
30     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
31     function unregister(address addr) external;
32     function updateOperator(address registrant, address operator, bool filtered) external;
33     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
34     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
35     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
36     function subscribe(address registrant, address registrantToSubscribe) external;
37     function unsubscribe(address registrant, bool copyExistingEntries) external;
38     function subscriptionOf(address addr) external returns (address registrant);
39     function subscribers(address registrant) external returns (address[] memory);
40     function subscriberAt(address registrant, uint256 index) external returns (address);
41     function copyEntriesOf(address registrant, address registrantToCopy) external;
42     function isOperatorFiltered(address registrant, address operator) external returns (bool);
43     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
44     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
45     function filteredOperators(address addr) external returns (address[] memory);
46     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
47     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
48     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
49     function isRegistered(address addr) external returns (bool);
50     function codeHashOf(address addr) external returns (bytes32);
51 }
52 
53 
54 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
55 
56 pragma solidity ^0.8.13;
57 
58 /**
59  * @title  OperatorFilterer
60  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
61  *         registrant's entries in the OperatorFilterRegistry.
62  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
63  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
64  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
65  */
66 
67 abstract contract OperatorFilterer {
68     error OperatorNotAllowed(address operator);
69 
70     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
71         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
72 
73     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
74         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
75         // will not revert, but the contract will need to be registered with the registry once it is deployed in
76         // order for the modifier to filter addresses.
77         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
78             if (subscribe) {
79                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
80             } else {
81                 if (subscriptionOrRegistrantToCopy != address(0)) {
82                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
83                 } else {
84                     OPERATOR_FILTER_REGISTRY.register(address(this));
85                 }
86             }
87         }
88     }
89 
90     modifier onlyAllowedOperator(address from) virtual {
91         // Check registry code length to facilitate testing in environments without a deployed registry.
92         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
93             // Allow spending tokens from addresses with balance
94             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
95             // from an EOA.
96             if (from == msg.sender) {
97                 _;
98                 return;
99             }
100             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
101                 revert OperatorNotAllowed(msg.sender);
102             }
103         }
104         _;
105     }
106 
107     modifier onlyAllowedOperatorApproval(address operator) virtual {
108         // Check registry code length to facilitate testing in environments without a deployed registry.
109         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
110             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
111                 revert OperatorNotAllowed(operator);
112             }
113         }
114         _;
115     }
116 }
117 
118 
119 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
120 
121 pragma solidity ^0.8.13;
122 
123 /**
124  * @title  DefaultOperatorFilterer
125  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
126  */
127 abstract contract DefaultOperatorFilterer is OperatorFilterer {
128     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
129     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
130 }
131 
132 
133 pragma solidity ^0.8.13;
134 
135 // File: erc721a/contracts/IERC721A.sol
136 
137 // ERC721A Contracts v4.2.3
138 // Creator: Chiru Labs
139 
140 /**
141  * @dev Interface of ERC721A.
142  */
143 interface IERC721A {
144     /**
145      * The caller must own the token or be an approved operator.
146      */
147     error ApprovalCallerNotOwnerNorApproved();
148 
149     /**
150      * The token does not exist.
151      */
152     error ApprovalQueryForNonexistentToken();
153 
154     /**
155      * Cannot query the balance for the zero address.
156      */
157     error BalanceQueryForZeroAddress();
158 
159     /**
160      * Cannot mint to the zero address.
161      */
162     error MintToZeroAddress();
163 
164     /**
165      * The quantity of tokens minted must be more than zero.
166      */
167     error MintZeroQuantity();
168 
169     /**
170      * The token does not exist.
171      */
172     error OwnerQueryForNonexistentToken();
173 
174     /**
175      * The caller must own the token or be an approved operator.
176      */
177     error TransferCallerNotOwnerNorApproved();
178 
179     /**
180      * The token must be owned by `from`.
181      */
182     error TransferFromIncorrectOwner();
183 
184     /**
185      * Cannot safely transfer to a contract that does not implement the
186      * ERC721Receiver interface.
187      */
188     error TransferToNonERC721ReceiverImplementer();
189 
190     /**
191      * Cannot transfer to the zero address.
192      */
193     error TransferToZeroAddress();
194 
195     /**
196      * The token does not exist.
197      */
198     error URIQueryForNonexistentToken();
199 
200     /**
201      * The `quantity` minted with ERC2309 exceeds the safety limit.
202      */
203     error MintERC2309QuantityExceedsLimit();
204 
205     /**
206      * The `extraData` cannot be set on an unintialized ownership slot.
207      */
208     error OwnershipNotInitializedForExtraData();
209 
210     // =============================================================
211     //                            STRUCTS
212     // =============================================================
213 
214     struct TokenOwnership {
215         // The address of the owner.
216         address addr;
217         // Stores the start time of ownership with minimal overhead for tokenomics.
218         uint64 startTimestamp;
219         // Whether the token has been burned.
220         bool burned;
221         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
222         uint24 extraData;
223     }
224 
225     // =============================================================
226     //                         TOKEN COUNTERS
227     // =============================================================
228 
229     /**
230      * @dev Returns the total number of tokens in existence.
231      * Burned tokens will reduce the count.
232      * To get the total number of tokens minted, please see {_totalMinted}.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     // =============================================================
237     //                            IERC165
238     // =============================================================
239 
240     /**
241      * @dev Returns true if this contract implements the interface defined by
242      * `interfaceId`. See the corresponding
243      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
244      * to learn more about how these ids are created.
245      *
246      * This function call must use less than 30000 gas.
247      */
248     function supportsInterface(bytes4 interfaceId) external view returns (bool);
249 
250     // =============================================================
251     //                            IERC721
252     // =============================================================
253 
254     /**
255      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
258 
259     /**
260      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
261      */
262     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
263 
264     /**
265      * @dev Emitted when `owner` enables or disables
266      * (`approved`) `operator` to manage all of its assets.
267      */
268     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
269 
270     /**
271      * @dev Returns the number of tokens in `owner`'s account.
272      */
273     function balanceOf(address owner) external view returns (uint256 balance);
274 
275     /**
276      * @dev Returns the owner of the `tokenId` token.
277      *
278      * Requirements:
279      *
280      * - `tokenId` must exist.
281      */
282     function ownerOf(uint256 tokenId) external view returns (address owner);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`,
286      * checking first that contract recipients are aware of the ERC721 protocol
287      * to prevent tokens from being forever locked.
288      *
289      * Requirements:
290      *
291      * - `from` cannot be the zero address.
292      * - `to` cannot be the zero address.
293      * - `tokenId` token must exist and be owned by `from`.
294      * - If the caller is not `from`, it must be have been allowed to move
295      * this token by either {approve} or {setApprovalForAll}.
296      * - If `to` refers to a smart contract, it must implement
297      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId,
305         bytes calldata data
306     ) external payable;
307 
308     /**
309      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external payable;
316 
317     /**
318      * @dev Transfers `tokenId` from `from` to `to`.
319      *
320      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
321      * whenever possible.
322      *
323      * Requirements:
324      *
325      * - `from` cannot be the zero address.
326      * - `to` cannot be the zero address.
327      * - `tokenId` token must be owned by `from`.
328      * - If the caller is not `from`, it must be approved to move this token
329      * by either {approve} or {setApprovalForAll}.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 tokenId
337     ) external payable;
338 
339     /**
340      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
341      * The approval is cleared when the token is transferred.
342      *
343      * Only a single account can be approved at a time, so approving the
344      * zero address clears previous approvals.
345      *
346      * Requirements:
347      *
348      * - The caller must own the token or be an approved operator.
349      * - `tokenId` must exist.
350      *
351      * Emits an {Approval} event.
352      */
353     function approve(address to, uint256 tokenId) external payable;
354 
355     /**
356      * @dev Approve or remove `operator` as an operator for the caller.
357      * Operators can call {transferFrom} or {safeTransferFrom}
358      * for any token owned by the caller.
359      *
360      * Requirements:
361      *
362      * - The `operator` cannot be the caller.
363      *
364      * Emits an {ApprovalForAll} event.
365      */
366     function setApprovalForAll(address operator, bool _approved) external;
367 
368     /**
369      * @dev Returns the account approved for `tokenId` token.
370      *
371      * Requirements:
372      *
373      * - `tokenId` must exist.
374      */
375     function getApproved(uint256 tokenId) external view returns (address operator);
376 
377     /**
378      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
379      *
380      * See {setApprovalForAll}.
381      */
382     function isApprovedForAll(address owner, address operator) external view returns (bool);
383 
384     // =============================================================
385     //                        IERC721Metadata
386     // =============================================================
387 
388     /**
389      * @dev Returns the token collection name.
390      */
391     function name() external view returns (string memory);
392 
393     /**
394      * @dev Returns the token collection symbol.
395      */
396     function symbol() external view returns (string memory);
397 
398     /**
399      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
400      */
401     function tokenURI(uint256 tokenId) external view returns (string memory);
402 
403     // =============================================================
404     //                           IERC2309
405     // =============================================================
406 
407     /**
408      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
409      * (inclusive) is transferred from `from` to `to`, as defined in the
410      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
411      *
412      * See {_mintERC2309} for more details.
413      */
414     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
415 }
416 
417 
418 // File: erc721a/contracts/ERC721A.sol
419 
420 // ERC721A Contracts v4.2.3
421 // Creator: Chiru Labs
422 
423 pragma solidity ^0.8.4;
424 
425 /**
426  * @dev Interface of ERC721 token receiver.
427  */
428 interface ERC721A__IERC721Receiver {
429     function onERC721Received(
430         address operator,
431         address from,
432         uint256 tokenId,
433         bytes calldata data
434     ) external returns (bytes4);
435 }
436 
437 /**
438  * @title ERC721A
439  *
440  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
441  * Non-Fungible Token Standard, including the Metadata extension.
442  * Optimized for lower gas during batch mints.
443  *
444  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
445  * starting from `_startTokenId()`.
446  *
447  * Assumptions:
448  *
449  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
450  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
451  */
452 contract ERC721A is IERC721A {
453     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
454     struct TokenApprovalRef {
455         address value;
456     }
457 
458     // =============================================================
459     //                           CONSTANTS
460     // =============================================================
461 
462     // Mask of an entry in packed address data.
463     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
464 
465     // The bit position of `numberMinted` in packed address data.
466     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
467 
468     // The bit position of `numberBurned` in packed address data.
469     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
470 
471     // The bit position of `aux` in packed address data.
472     uint256 private constant _BITPOS_AUX = 192;
473 
474     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
475     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
476 
477     // The bit position of `startTimestamp` in packed ownership.
478     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
479 
480     // The bit mask of the `burned` bit in packed ownership.
481     uint256 private constant _BITMASK_BURNED = 1 << 224;
482 
483     // The bit position of the `nextInitialized` bit in packed ownership.
484     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
485 
486     // The bit mask of the `nextInitialized` bit in packed ownership.
487     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
488 
489     // The bit position of `extraData` in packed ownership.
490     uint256 private constant _BITPOS_EXTRA_DATA = 232;
491 
492     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
493     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
494 
495     // The mask of the lower 160 bits for addresses.
496     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
497 
498     // The maximum `quantity` that can be minted with {_mintERC2309}.
499     // This limit is to prevent overflows on the address data entries.
500     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
501     // is required to cause an overflow, which is unrealistic.
502     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
503 
504     // The `Transfer` event signature is given by:
505     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
506     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
507         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
508 
509     // =============================================================
510     //                            STORAGE
511     // =============================================================
512 
513     // The next token ID to be minted.
514     uint256 private _currentIndex;
515 
516     // The number of tokens burned.
517     uint256 private _burnCounter;
518 
519     // Token name
520     string private _name;
521 
522     // Token symbol
523     string private _symbol;
524 
525     // Mapping from token ID to ownership details
526     // An empty struct value does not necessarily mean the token is unowned.
527     // See {_packedOwnershipOf} implementation for details.
528     //
529     // Bits Layout:
530     // - [0..159]   `addr`
531     // - [160..223] `startTimestamp`
532     // - [224]      `burned`
533     // - [225]      `nextInitialized`
534     // - [232..255] `extraData`
535     mapping(uint256 => uint256) private _packedOwnerships;
536 
537     // Mapping owner address to address data.
538     //
539     // Bits Layout:
540     // - [0..63]    `balance`
541     // - [64..127]  `numberMinted`
542     // - [128..191] `numberBurned`
543     // - [192..255] `aux`
544     mapping(address => uint256) private _packedAddressData;
545 
546     // Mapping from token ID to approved address.
547     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
548 
549     // Mapping from owner to operator approvals
550     mapping(address => mapping(address => bool)) private _operatorApprovals;
551 
552     // =============================================================
553     //                          CONSTRUCTOR
554     // =============================================================
555 
556     constructor(string memory name_, string memory symbol_) {
557         _name = name_;
558         _symbol = symbol_;
559         _currentIndex = _startTokenId();
560     }
561 
562     // =============================================================
563     //                   TOKEN COUNTING OPERATIONS
564     // =============================================================
565 
566     /**
567      * @dev Returns the starting token ID.
568      * To change the starting token ID, please override this function.
569      */
570     function _startTokenId() internal view virtual returns (uint256) {
571         return 0;
572     }
573 
574     /**
575      * @dev Returns the next token ID to be minted.
576      */
577     function _nextTokenId() internal view virtual returns (uint256) {
578         return _currentIndex;
579     }
580 
581     /**
582      * @dev Returns the total number of tokens in existence.
583      * Burned tokens will reduce the count.
584      * To get the total number of tokens minted, please see {_totalMinted}.
585      */
586     function totalSupply() public view virtual override returns (uint256) {
587         // Counter underflow is impossible as _burnCounter cannot be incremented
588         // more than `_currentIndex - _startTokenId()` times.
589         unchecked {
590             return _currentIndex - _burnCounter - _startTokenId();
591         }
592     }
593 
594     /**
595      * @dev Returns the total amount of tokens minted in the contract.
596      */
597     function _totalMinted() internal view virtual returns (uint256) {
598         // Counter underflow is impossible as `_currentIndex` does not decrement,
599         // and it is initialized to `_startTokenId()`.
600         unchecked {
601             return _currentIndex - _startTokenId();
602         }
603     }
604 
605     /**
606      * @dev Returns the total number of tokens burned.
607      */
608     function _totalBurned() internal view virtual returns (uint256) {
609         return _burnCounter;
610     }
611 
612     // =============================================================
613     //                    ADDRESS DATA OPERATIONS
614     // =============================================================
615 
616     /**
617      * @dev Returns the number of tokens in `owner`'s account.
618      */
619     function balanceOf(address owner) public view virtual override returns (uint256) {
620         if (owner == address(0)) revert BalanceQueryForZeroAddress();
621         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
622     }
623 
624     /**
625      * Returns the number of tokens minted by `owner`.
626      */
627     function _numberMinted(address owner) internal view returns (uint256) {
628         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
629     }
630 
631     /**
632      * Returns the number of tokens burned by or on behalf of `owner`.
633      */
634     function _numberBurned(address owner) internal view returns (uint256) {
635         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
636     }
637 
638     /**
639      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
640      */
641     function _getAux(address owner) internal view returns (uint64) {
642         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
643     }
644 
645     /**
646      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
647      * If there are multiple variables, please pack them into a uint64.
648      */
649     function _setAux(address owner, uint64 aux) internal virtual {
650         uint256 packed = _packedAddressData[owner];
651         uint256 auxCasted;
652         // Cast `aux` with assembly to avoid redundant masking.
653         assembly {
654             auxCasted := aux
655         }
656         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
657         _packedAddressData[owner] = packed;
658     }
659 
660     // =============================================================
661     //                            IERC165
662     // =============================================================
663 
664     /**
665      * @dev Returns true if this contract implements the interface defined by
666      * `interfaceId`. See the corresponding
667      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
668      * to learn more about how these ids are created.
669      *
670      * This function call must use less than 30000 gas.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
673         // The interface IDs are constants representing the first 4 bytes
674         // of the XOR of all function selectors in the interface.
675         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
676         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
677         return
678             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
679             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
680             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
681     }
682 
683     // =============================================================
684     //                        IERC721Metadata
685     // =============================================================
686 
687     /**
688      * @dev Returns the token collection name.
689      */
690     function name() public view virtual override returns (string memory) {
691         return _name;
692     }
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() public view virtual override returns (string memory) {
698         return _symbol;
699     }
700 
701     /**
702      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
703      */
704     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
705         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
706 
707         string memory baseURI = _baseURI();
708         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
709     }
710 
711     /**
712      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
713      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
714      * by default, it can be overridden in child contracts.
715      */
716     function _baseURI() internal view virtual returns (string memory) {
717         return '';
718     }
719 
720     // =============================================================
721     //                     OWNERSHIPS OPERATIONS
722     // =============================================================
723 
724     /**
725      * @dev Returns the owner of the `tokenId` token.
726      *
727      * Requirements:
728      *
729      * - `tokenId` must exist.
730      */
731     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
732         return address(uint160(_packedOwnershipOf(tokenId)));
733     }
734 
735     /**
736      * @dev Gas spent here starts off proportional to the maximum mint batch size.
737      * It gradually moves to O(1) as tokens get transferred around over time.
738      */
739     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
740         return _unpackedOwnership(_packedOwnershipOf(tokenId));
741     }
742 
743     /**
744      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
745      */
746     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
747         return _unpackedOwnership(_packedOwnerships[index]);
748     }
749 
750     /**
751      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
752      */
753     function _initializeOwnershipAt(uint256 index) internal virtual {
754         if (_packedOwnerships[index] == 0) {
755             _packedOwnerships[index] = _packedOwnershipOf(index);
756         }
757     }
758 
759     /**
760      * Returns the packed ownership data of `tokenId`.
761      */
762     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
763         uint256 curr = tokenId;
764 
765         unchecked {
766             if (_startTokenId() <= curr)
767                 if (curr < _currentIndex) {
768                     uint256 packed = _packedOwnerships[curr];
769                     // If not burned.
770                     if (packed & _BITMASK_BURNED == 0) {
771                         // Invariant:
772                         // There will always be an initialized ownership slot
773                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
774                         // before an unintialized ownership slot
775                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
776                         // Hence, `curr` will not underflow.
777                         //
778                         // We can directly compare the packed value.
779                         // If the address is zero, packed will be zero.
780                         while (packed == 0) {
781                             packed = _packedOwnerships[--curr];
782                         }
783                         return packed;
784                     }
785                 }
786         }
787         revert OwnerQueryForNonexistentToken();
788     }
789 
790     /**
791      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
792      */
793     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
794         ownership.addr = address(uint160(packed));
795         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
796         ownership.burned = packed & _BITMASK_BURNED != 0;
797         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
798     }
799 
800     /**
801      * @dev Packs ownership data into a single uint256.
802      */
803     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
804         assembly {
805             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
806             owner := and(owner, _BITMASK_ADDRESS)
807             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
808             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
809         }
810     }
811 
812     /**
813      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
814      */
815     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
816         // For branchless setting of the `nextInitialized` flag.
817         assembly {
818             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
819             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
820         }
821     }
822 
823     // =============================================================
824     //                      APPROVAL OPERATIONS
825     // =============================================================
826 
827     /**
828      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
829      * The approval is cleared when the token is transferred.
830      *
831      * Only a single account can be approved at a time, so approving the
832      * zero address clears previous approvals.
833      *
834      * Requirements:
835      *
836      * - The caller must own the token or be an approved operator.
837      * - `tokenId` must exist.
838      *
839      * Emits an {Approval} event.
840      */
841     function approve(address to, uint256 tokenId) public payable virtual override {
842         address owner = ownerOf(tokenId);
843 
844         if (_msgSenderERC721A() != owner)
845             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
846                 revert ApprovalCallerNotOwnerNorApproved();
847             }
848 
849         _tokenApprovals[tokenId].value = to;
850         emit Approval(owner, to, tokenId);
851     }
852 
853     /**
854      * @dev Returns the account approved for `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function getApproved(uint256 tokenId) public view virtual override returns (address) {
861         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
862 
863         return _tokenApprovals[tokenId].value;
864     }
865 
866     /**
867      * @dev Approve or remove `operator` as an operator for the caller.
868      * Operators can call {transferFrom} or {safeTransferFrom}
869      * for any token owned by the caller.
870      *
871      * Requirements:
872      *
873      * - The `operator` cannot be the caller.
874      *
875      * Emits an {ApprovalForAll} event.
876      */
877     function setApprovalForAll(address operator, bool approved) public virtual override {
878         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
879         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
880     }
881 
882     /**
883      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
884      *
885      * See {setApprovalForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev Returns whether `tokenId` exists.
893      *
894      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
895      *
896      * Tokens start existing when they are minted. See {_mint}.
897      */
898     function _exists(uint256 tokenId) internal view virtual returns (bool) {
899         return
900             _startTokenId() <= tokenId &&
901             tokenId < _currentIndex && // If within bounds,
902             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
903     }
904 
905     /**
906      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
907      */
908     function _isSenderApprovedOrOwner(
909         address approvedAddress,
910         address owner,
911         address msgSender
912     ) private pure returns (bool result) {
913         assembly {
914             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
915             owner := and(owner, _BITMASK_ADDRESS)
916             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
917             msgSender := and(msgSender, _BITMASK_ADDRESS)
918             // `msgSender == owner || msgSender == approvedAddress`.
919             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
920         }
921     }
922 
923     /**
924      * @dev Returns the storage slot and value for the approved address of `tokenId`.
925      */
926     function _getApprovedSlotAndAddress(uint256 tokenId)
927         private
928         view
929         returns (uint256 approvedAddressSlot, address approvedAddress)
930     {
931         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
932         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
933         assembly {
934             approvedAddressSlot := tokenApproval.slot
935             approvedAddress := sload(approvedAddressSlot)
936         }
937     }
938 
939     // =============================================================
940     //                      TRANSFER OPERATIONS
941     // =============================================================
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      * - If the caller is not `from`, it must be approved to move this token
952      * by either {approve} or {setApprovalForAll}.
953      *
954      * Emits a {Transfer} event.
955      */
956     function transferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public payable virtual override {
961         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
962 
963         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
964 
965         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
966 
967         // The nested ifs save around 20+ gas over a compound boolean condition.
968         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
969             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
970 
971         if (to == address(0)) revert TransferToZeroAddress();
972 
973         _beforeTokenTransfers(from, to, tokenId, 1);
974 
975         // Clear approvals from the previous owner.
976         assembly {
977             if approvedAddress {
978                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
979                 sstore(approvedAddressSlot, 0)
980             }
981         }
982 
983         // Underflow of the sender's balance is impossible because we check for
984         // ownership above and the recipient's balance can't realistically overflow.
985         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
986         unchecked {
987             // We can directly increment and decrement the balances.
988             --_packedAddressData[from]; // Updates: `balance -= 1`.
989             ++_packedAddressData[to]; // Updates: `balance += 1`.
990 
991             // Updates:
992             // - `address` to the next owner.
993             // - `startTimestamp` to the timestamp of transfering.
994             // - `burned` to `false`.
995             // - `nextInitialized` to `true`.
996             _packedOwnerships[tokenId] = _packOwnershipData(
997                 to,
998                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
999             );
1000 
1001             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1002             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1003                 uint256 nextTokenId = tokenId + 1;
1004                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1005                 if (_packedOwnerships[nextTokenId] == 0) {
1006                     // If the next slot is within bounds.
1007                     if (nextTokenId != _currentIndex) {
1008                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1009                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1010                     }
1011                 }
1012             }
1013         }
1014 
1015         emit Transfer(from, to, tokenId);
1016         _afterTokenTransfers(from, to, tokenId, 1);
1017     }
1018 
1019     /**
1020      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public payable virtual override {
1027         safeTransferFrom(from, to, tokenId, '');
1028     }
1029 
1030     /**
1031      * @dev Safely transfers `tokenId` token from `from` to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If the caller is not `from`, it must be approved to move this token
1039      * by either {approve} or {setApprovalForAll}.
1040      * - If `to` refers to a smart contract, it must implement
1041      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) public payable virtual override {
1051         transferFrom(from, to, tokenId);
1052         if (to.code.length != 0)
1053             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1054                 revert TransferToNonERC721ReceiverImplementer();
1055             }
1056     }
1057 
1058     /**
1059      * @dev Hook that is called before a set of serially-ordered token IDs
1060      * are about to be transferred. This includes minting.
1061      * And also called before burning one token.
1062      *
1063      * `startTokenId` - the first token ID to be transferred.
1064      * `quantity` - the amount to be transferred.
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` will be minted for `to`.
1071      * - When `to` is zero, `tokenId` will be burned by `from`.
1072      * - `from` and `to` are never both zero.
1073      */
1074     function _beforeTokenTransfers(
1075         address from,
1076         address to,
1077         uint256 startTokenId,
1078         uint256 quantity
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Hook that is called after a set of serially-ordered token IDs
1083      * have been transferred. This includes minting.
1084      * And also called after one token has been burned.
1085      *
1086      * `startTokenId` - the first token ID to be transferred.
1087      * `quantity` - the amount to be transferred.
1088      *
1089      * Calling conditions:
1090      *
1091      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1092      * transferred to `to`.
1093      * - When `from` is zero, `tokenId` has been minted for `to`.
1094      * - When `to` is zero, `tokenId` has been burned by `from`.
1095      * - `from` and `to` are never both zero.
1096      */
1097     function _afterTokenTransfers(
1098         address from,
1099         address to,
1100         uint256 startTokenId,
1101         uint256 quantity
1102     ) internal virtual {}
1103 
1104     /**
1105      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1106      *
1107      * `from` - Previous owner of the given token ID.
1108      * `to` - Target address that will receive the token.
1109      * `tokenId` - Token ID to be transferred.
1110      * `_data` - Optional data to send along with the call.
1111      *
1112      * Returns whether the call correctly returned the expected magic value.
1113      */
1114     function _checkContractOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1121             bytes4 retval
1122         ) {
1123             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1124         } catch (bytes memory reason) {
1125             if (reason.length == 0) {
1126                 revert TransferToNonERC721ReceiverImplementer();
1127             } else {
1128                 assembly {
1129                     revert(add(32, reason), mload(reason))
1130                 }
1131             }
1132         }
1133     }
1134 
1135     // =============================================================
1136     //                        MINT OPERATIONS
1137     // =============================================================
1138 
1139     /**
1140      * @dev Mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * Emits a {Transfer} event for each mint.
1148      */
1149     function _mint(address to, uint256 quantity) internal virtual {
1150         uint256 startTokenId = _currentIndex;
1151         if (quantity == 0) revert MintZeroQuantity();
1152 
1153         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155         // Overflows are incredibly unrealistic.
1156         // `balance` and `numberMinted` have a maximum limit of 2**64.
1157         // `tokenId` has a maximum limit of 2**256.
1158         unchecked {
1159             // Updates:
1160             // - `balance += quantity`.
1161             // - `numberMinted += quantity`.
1162             //
1163             // We can directly add to the `balance` and `numberMinted`.
1164             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1165 
1166             // Updates:
1167             // - `address` to the owner.
1168             // - `startTimestamp` to the timestamp of minting.
1169             // - `burned` to `false`.
1170             // - `nextInitialized` to `quantity == 1`.
1171             _packedOwnerships[startTokenId] = _packOwnershipData(
1172                 to,
1173                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1174             );
1175 
1176             uint256 toMasked;
1177             uint256 end = startTokenId + quantity;
1178 
1179             // Use assembly to loop and emit the `Transfer` event for gas savings.
1180             // The duplicated `log4` removes an extra check and reduces stack juggling.
1181             // The assembly, together with the surrounding Solidity code, have been
1182             // delicately arranged to nudge the compiler into producing optimized opcodes.
1183             assembly {
1184                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1185                 toMasked := and(to, _BITMASK_ADDRESS)
1186                 // Emit the `Transfer` event.
1187                 log4(
1188                     0, // Start of data (0, since no data).
1189                     0, // End of data (0, since no data).
1190                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1191                     0, // `address(0)`.
1192                     toMasked, // `to`.
1193                     startTokenId // `tokenId`.
1194                 )
1195 
1196                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1197                 // that overflows uint256 will make the loop run out of gas.
1198                 // The compiler will optimize the `iszero` away for performance.
1199                 for {
1200                     let tokenId := add(startTokenId, 1)
1201                 } iszero(eq(tokenId, end)) {
1202                     tokenId := add(tokenId, 1)
1203                 } {
1204                     // Emit the `Transfer` event. Similar to above.
1205                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1206                 }
1207             }
1208             if (toMasked == 0) revert MintToZeroAddress();
1209 
1210             _currentIndex = end;
1211         }
1212         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213     }
1214 
1215     /**
1216      * @dev Mints `quantity` tokens and transfers them to `to`.
1217      *
1218      * This function is intended for efficient minting only during contract creation.
1219      *
1220      * It emits only one {ConsecutiveTransfer} as defined in
1221      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1222      * instead of a sequence of {Transfer} event(s).
1223      *
1224      * Calling this function outside of contract creation WILL make your contract
1225      * non-compliant with the ERC721 standard.
1226      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1227      * {ConsecutiveTransfer} event is only permissible during contract creation.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {ConsecutiveTransfer} event.
1235      */
1236     function _mintERC2309(address to, uint256 quantity) internal virtual {
1237         uint256 startTokenId = _currentIndex;
1238         if (to == address(0)) revert MintToZeroAddress();
1239         if (quantity == 0) revert MintZeroQuantity();
1240         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1241 
1242         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1243 
1244         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1245         unchecked {
1246             // Updates:
1247             // - `balance += quantity`.
1248             // - `numberMinted += quantity`.
1249             //
1250             // We can directly add to the `balance` and `numberMinted`.
1251             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1252 
1253             // Updates:
1254             // - `address` to the owner.
1255             // - `startTimestamp` to the timestamp of minting.
1256             // - `burned` to `false`.
1257             // - `nextInitialized` to `quantity == 1`.
1258             _packedOwnerships[startTokenId] = _packOwnershipData(
1259                 to,
1260                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1261             );
1262 
1263             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1264 
1265             _currentIndex = startTokenId + quantity;
1266         }
1267         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1268     }
1269 
1270     /**
1271      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - If `to` refers to a smart contract, it must implement
1276      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1277      * - `quantity` must be greater than 0.
1278      *
1279      * See {_mint}.
1280      *
1281      * Emits a {Transfer} event for each mint.
1282      */
1283     function _safeMint(
1284         address to,
1285         uint256 quantity,
1286         bytes memory _data
1287     ) internal virtual {
1288         _mint(to, quantity);
1289 
1290         unchecked {
1291             if (to.code.length != 0) {
1292                 uint256 end = _currentIndex;
1293                 uint256 index = end - quantity;
1294                 do {
1295                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1296                         revert TransferToNonERC721ReceiverImplementer();
1297                     }
1298                 } while (index < end);
1299                 // Reentrancy protection.
1300                 if (_currentIndex != end) revert();
1301             }
1302         }
1303     }
1304 
1305     /**
1306      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1307      */
1308     function _safeMint(address to, uint256 quantity) internal virtual {
1309         _safeMint(to, quantity, '');
1310     }
1311 
1312     // =============================================================
1313     //                        BURN OPERATIONS
1314     // =============================================================
1315 
1316     /**
1317      * @dev Equivalent to `_burn(tokenId, false)`.
1318      */
1319     function _burn(uint256 tokenId) internal virtual {
1320         _burn(tokenId, false);
1321     }
1322 
1323     /**
1324      * @dev Destroys `tokenId`.
1325      * The approval is cleared when the token is burned.
1326      *
1327      * Requirements:
1328      *
1329      * - `tokenId` must exist.
1330      *
1331      * Emits a {Transfer} event.
1332      */
1333     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1334         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1335 
1336         address from = address(uint160(prevOwnershipPacked));
1337 
1338         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1339 
1340         if (approvalCheck) {
1341             // The nested ifs save around 20+ gas over a compound boolean condition.
1342             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1343                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1344         }
1345 
1346         _beforeTokenTransfers(from, address(0), tokenId, 1);
1347 
1348         // Clear approvals from the previous owner.
1349         assembly {
1350             if approvedAddress {
1351                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1352                 sstore(approvedAddressSlot, 0)
1353             }
1354         }
1355 
1356         // Underflow of the sender's balance is impossible because we check for
1357         // ownership above and the recipient's balance can't realistically overflow.
1358         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1359         unchecked {
1360             // Updates:
1361             // - `balance -= 1`.
1362             // - `numberBurned += 1`.
1363             //
1364             // We can directly decrement the balance, and increment the number burned.
1365             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1366             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1367 
1368             // Updates:
1369             // - `address` to the last owner.
1370             // - `startTimestamp` to the timestamp of burning.
1371             // - `burned` to `true`.
1372             // - `nextInitialized` to `true`.
1373             _packedOwnerships[tokenId] = _packOwnershipData(
1374                 from,
1375                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1376             );
1377 
1378             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1379             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1380                 uint256 nextTokenId = tokenId + 1;
1381                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1382                 if (_packedOwnerships[nextTokenId] == 0) {
1383                     // If the next slot is within bounds.
1384                     if (nextTokenId != _currentIndex) {
1385                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1386                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1387                     }
1388                 }
1389             }
1390         }
1391 
1392         emit Transfer(from, address(0), tokenId);
1393         _afterTokenTransfers(from, address(0), tokenId, 1);
1394 
1395         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1396         unchecked {
1397             _burnCounter++;
1398         }
1399     }
1400 
1401     // =============================================================
1402     //                     EXTRA DATA OPERATIONS
1403     // =============================================================
1404 
1405     /**
1406      * @dev Directly sets the extra data for the ownership data `index`.
1407      */
1408     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1409         uint256 packed = _packedOwnerships[index];
1410         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1411         uint256 extraDataCasted;
1412         // Cast `extraData` with assembly to avoid redundant masking.
1413         assembly {
1414             extraDataCasted := extraData
1415         }
1416         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1417         _packedOwnerships[index] = packed;
1418     }
1419 
1420     /**
1421      * @dev Called during each token transfer to set the 24bit `extraData` field.
1422      * Intended to be overridden by the cosumer contract.
1423      *
1424      * `previousExtraData` - the value of `extraData` before transfer.
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` will be minted for `to`.
1431      * - When `to` is zero, `tokenId` will be burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _extraData(
1435         address from,
1436         address to,
1437         uint24 previousExtraData
1438     ) internal view virtual returns (uint24) {}
1439 
1440     /**
1441      * @dev Returns the next extra data for the packed ownership data.
1442      * The returned result is shifted into position.
1443      */
1444     function _nextExtraData(
1445         address from,
1446         address to,
1447         uint256 prevOwnershipPacked
1448     ) private view returns (uint256) {
1449         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1450         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1451     }
1452 
1453     // =============================================================
1454     //                       OTHER OPERATIONS
1455     // =============================================================
1456 
1457     /**
1458      * @dev Returns the message sender (defaults to `msg.sender`).
1459      *
1460      * If you are writing GSN compatible contracts, you need to override this function.
1461      */
1462     function _msgSenderERC721A() internal view virtual returns (address) {
1463         return msg.sender;
1464     }
1465 
1466     /**
1467      * @dev Converts a uint256 to its ASCII string decimal representation.
1468      */
1469     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1470         assembly {
1471             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1472             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1473             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1474             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1475             let m := add(mload(0x40), 0xa0)
1476             // Update the free memory pointer to allocate.
1477             mstore(0x40, m)
1478             // Assign the `str` to the end.
1479             str := sub(m, 0x20)
1480             // Zeroize the slot after the string.
1481             mstore(str, 0)
1482 
1483             // Cache the end of the memory to calculate the length later.
1484             let end := str
1485 
1486             // We write the string from rightmost digit to leftmost digit.
1487             // The following is essentially a do-while loop that also handles the zero case.
1488             // prettier-ignore
1489             for { let temp := value } 1 {} {
1490                 str := sub(str, 1)
1491                 // Write the character to the pointer.
1492                 // The ASCII index of the '0' character is 48.
1493                 mstore8(str, add(48, mod(temp, 10)))
1494                 // Keep dividing `temp` until zero.
1495                 temp := div(temp, 10)
1496                 // prettier-ignore
1497                 if iszero(temp) { break }
1498             }
1499 
1500             let length := sub(end, str)
1501             // Move the pointer 32 bytes leftwards to make room for the length.
1502             str := sub(str, 0x20)
1503             // Store the length.
1504             mstore(str, length)
1505         }
1506     }
1507 }
1508 
1509 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1510 
1511 
1512 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1513 
1514 pragma solidity ^0.8.0;
1515 
1516 /**
1517  * @dev Contract module that helps prevent reentrant calls to a function.
1518  *
1519  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1520  * available, which can be applied to functions to make sure there are no nested
1521  * (reentrant) calls to them.
1522  *
1523  * Note that because there is a single `nonReentrant` guard, functions marked as
1524  * `nonReentrant` may not call one another. This can be worked around by making
1525  * those functions `private`, and then adding `external` `nonReentrant` entry
1526  * points to them.
1527  *
1528  * TIP: If you would like to learn more about reentrancy and alternative ways
1529  * to protect against it, check out our blog post
1530  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1531  */
1532 abstract contract ReentrancyGuard {
1533     // Booleans are more expensive than uint256 or any type that takes up a full
1534     // word because each write operation emits an extra SLOAD to first read the
1535     // slot's contents, replace the bits taken up by the boolean, and then write
1536     // back. This is the compiler's defense against contract upgrades and
1537     // pointer aliasing, and it cannot be disabled.
1538 
1539     // The values being non-zero value makes deployment a bit more expensive,
1540     // but in exchange the refund on every call to nonReentrant will be lower in
1541     // amount. Since refunds are capped to a percentage of the total
1542     // transaction's gas, it is best to keep them low in cases like this one, to
1543     // increase the likelihood of the full refund coming into effect.
1544     uint256 private constant _NOT_ENTERED = 1;
1545     uint256 private constant _ENTERED = 2;
1546 
1547     uint256 private _status;
1548 
1549     constructor() {
1550         _status = _NOT_ENTERED;
1551     }
1552 
1553     /**
1554      * @dev Prevents a contract from calling itself, directly or indirectly.
1555      * Calling a `nonReentrant` function from another `nonReentrant`
1556      * function is not supported. It is possible to prevent this from happening
1557      * by making the `nonReentrant` function external, and making it call a
1558      * `private` function that does the actual work.
1559      */
1560     modifier nonReentrant() {
1561         _nonReentrantBefore();
1562         _;
1563         _nonReentrantAfter();
1564     }
1565 
1566     function _nonReentrantBefore() private {
1567         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1568         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1569 
1570         // Any calls to nonReentrant after this point will fail
1571         _status = _ENTERED;
1572     }
1573 
1574     function _nonReentrantAfter() private {
1575         // By storing the original value once again, a refund is triggered (see
1576         // https://eips.ethereum.org/EIPS/eip-2200)
1577         _status = _NOT_ENTERED;
1578     }
1579 }
1580 
1581 // File: @openzeppelin/contracts/utils/Context.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 /**
1589  * @dev Provides information about the current execution context, including the
1590  * sender of the transaction and its data. While these are generally available
1591  * via msg.sender and msg.data, they should not be accessed in such a direct
1592  * manner, since when dealing with meta-transactions the account sending and
1593  * paying for execution may not be the actual sender (as far as an application
1594  * is concerned).
1595  *
1596  * This contract is only required for intermediate, library-like contracts.
1597  */
1598 abstract contract Context {
1599     function _msgSender() internal view virtual returns (address) {
1600         return msg.sender;
1601     }
1602 
1603     function _msgData() internal view virtual returns (bytes calldata) {
1604         return msg.data;
1605     }
1606 }
1607 
1608 // File: @openzeppelin/contracts/access/Ownable.sol
1609 
1610 
1611 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 
1616 /**
1617  * @dev Contract module which provides a basic access control mechanism, where
1618  * there is an account (an owner) that can be granted exclusive access to
1619  * specific functions.
1620  *
1621  * By default, the owner account will be the one that deploys the contract. This
1622  * can later be changed with {transferOwnership}.
1623  *
1624  * This module is used through inheritance. It will make available the modifier
1625  * `onlyOwner`, which can be applied to your functions to restrict their use to
1626  * the owner.
1627  */
1628 abstract contract Ownable is Context {
1629     address private _owner;
1630 
1631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1632 
1633     /**
1634      * @dev Initializes the contract setting the deployer as the initial owner.
1635      */
1636     constructor() {
1637         _transferOwnership(_msgSender());
1638     }
1639 
1640     /**
1641      * @dev Throws if called by any account other than the owner.
1642      */
1643     modifier onlyOwner() {
1644         _checkOwner();
1645         _;
1646     }
1647 
1648     /**
1649      * @dev Returns the address of the current owner.
1650      */
1651     function owner() public view virtual returns (address) {
1652         return _owner;
1653     }
1654 
1655     /**
1656      * @dev Throws if the sender is not the owner.
1657      */
1658     function _checkOwner() internal view virtual {
1659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1660     }
1661 
1662     /**
1663      * @dev Leaves the contract without owner. It will not be possible to call
1664      * `onlyOwner` functions anymore. Can only be called by the current owner.
1665      *
1666      * NOTE: Renouncing ownership will leave the contract without an owner,
1667      * thereby removing any functionality that is only available to the owner.
1668      */
1669     function renounceOwnership() public virtual onlyOwner {
1670         _transferOwnership(address(0));
1671     }
1672 
1673     /**
1674      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1675      * Can only be called by the current owner.
1676      */
1677     function transferOwnership(address newOwner) public virtual onlyOwner {
1678         require(newOwner != address(0), "Ownable: new owner is the zero address");
1679         _transferOwnership(newOwner);
1680     }
1681 
1682     /**
1683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1684      * Internal function without access restriction.
1685      */
1686     function _transferOwnership(address newOwner) internal virtual {
1687         address oldOwner = _owner;
1688         _owner = newOwner;
1689         emit OwnershipTransferred(oldOwner, newOwner);
1690     }
1691 }
1692 
1693 
1694 pragma solidity ^0.8.15;
1695 
1696 contract dickpix is ERC721A, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
1697 
1698     /////////////////////////////
1699     // PARAMS & VALUES
1700     /////////////////////////////
1701     
1702     uint256 public maxSupply = 3636;
1703     uint256 public maxPerWallet = 69;
1704     uint256 public mintCost = 0.001 ether;
1705     bool public isSalesActive = false;
1706 
1707     string public baseURI = "ipfs://QmaRZ8KHKzhLH1BMn8w2TKmRazTwaGFdzGFK6pbAn8Go9T/";
1708 
1709     mapping(address => uint) addressToMinted;
1710     mapping(address => bool) freeMint;
1711 
1712     function _startTokenId() internal view virtual override returns (uint256) {
1713         return 1;
1714     }
1715 
1716     constructor () ERC721A("dickpix", "DICK") {
1717     }
1718 
1719     /////////////////////////////
1720     // CORE FUNCTIONALITY
1721     /////////////////////////////
1722 
1723     function mintDick(uint256 mintAmount) public payable nonReentrant {
1724         require(isSalesActive, "Sale is not active");
1725         require(addressToMinted[msg.sender] + mintAmount <= maxPerWallet, "Exceeded max allocation");
1726         require(totalSupply() + mintAmount <= maxSupply, "Sold out");
1727 
1728         if(freeMint[msg.sender]) {
1729             require(msg.value >= mintAmount * mintCost, "Not enough funds");
1730         }
1731         else {
1732             require(msg.value >= (mintAmount - 1) * mintCost, "Not enough funds");
1733             freeMint[msg.sender] = true;
1734         }
1735         
1736         addressToMinted[msg.sender] += mintAmount;
1737         _safeMint(msg.sender, mintAmount);
1738     }
1739 
1740     function reserveDick(uint256 _mintAmount) public onlyOwner {
1741         require(totalSupply() + _mintAmount <= maxSupply, "Sold Out!");
1742         
1743         _safeMint(msg.sender, _mintAmount);
1744     }
1745 
1746     /////////////////////////////
1747     // CONTRACT MANAGEMENT 
1748     /////////////////////////////
1749 
1750     function _baseURI() internal view virtual override returns (string memory) {
1751         return baseURI;
1752     }
1753 
1754     function setBaseURI(string memory baseURI_) external onlyOwner {
1755         baseURI = baseURI_;
1756     }
1757 
1758     function toggleSale() external onlyOwner {
1759         isSalesActive = !isSalesActive;
1760     }
1761 
1762     function setCost(uint256 newCost) external onlyOwner {
1763         mintCost = newCost;
1764     }
1765 
1766     function setSupply(uint256 newSupply) external onlyOwner {
1767         maxSupply = newSupply;
1768     }
1769 
1770     function withdraw() public onlyOwner {
1771 		payable(msg.sender).transfer(address(this).balance);
1772 	}
1773     
1774     /////////////////////////////
1775     // OPENSEA FILTER REGISTRY 
1776     /////////////////////////////
1777 
1778     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1779         super.setApprovalForAll(operator, approved);
1780     }
1781 
1782     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1783         super.approve(operator, tokenId);
1784     }
1785 
1786     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1787         super.transferFrom(from, to, tokenId);
1788     }
1789 
1790     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1791         super.safeTransferFrom(from, to, tokenId);
1792     }
1793 
1794     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1795         public
1796         payable
1797         override
1798         onlyAllowedOperator(from)
1799     {
1800         super.safeTransferFrom(from, to, tokenId, data);
1801     }
1802 }