1 // File: contracts/IDelegationRegistry.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 /**
7  * @title An immutable registry contract to be deployed as a standalone primitive
8  * @dev See EIP-5639, new project launches can read previous cold wallet -> hot wallet delegations
9  * from here and integrate those permissions into their flow
10  */
11 interface IDelegationRegistry {
12     /// @notice Delegation type
13     enum DelegationType {
14         NONE,
15         ALL,
16         CONTRACT,
17         TOKEN
18     }
19 
20     /// @notice Info about a single delegation, used for onchain enumeration
21     struct DelegationInfo {
22         DelegationType type_;
23         address vault;
24         address delegate;
25         address contract_;
26         uint256 tokenId;
27     }
28 
29     /// @notice Info about a single contract-level delegation
30     struct ContractDelegation {
31         address contract_;
32         address delegate;
33     }
34 
35     /// @notice Info about a single token-level delegation
36     struct TokenDelegation {
37         address contract_;
38         uint256 tokenId;
39         address delegate;
40     }
41 
42     /// @notice Emitted when a user delegates their entire wallet
43     event DelegateForAll(address vault, address delegate, bool value);
44 
45     /// @notice Emitted when a user delegates a specific contract
46     event DelegateForContract(address vault, address delegate, address contract_, bool value);
47 
48     /// @notice Emitted when a user delegates a specific token
49     event DelegateForToken(address vault, address delegate, address contract_, uint256 tokenId, bool value);
50 
51     /// @notice Emitted when a user revokes all delegations
52     event RevokeAllDelegates(address vault);
53 
54     /// @notice Emitted when a user revoes all delegations for a given delegate
55     event RevokeDelegate(address vault, address delegate);
56 
57     /**
58      * -----------  WRITE -----------
59      */
60 
61     /**
62      * @notice Allow the delegate to act on your behalf for all contracts
63      * @param delegate The hotwallet to act on your behalf
64      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
65      */
66     function delegateForAll(address delegate, bool value) external;
67 
68     /**
69      * @notice Allow the delegate to act on your behalf for a specific contract
70      * @param delegate The hotwallet to act on your behalf
71      * @param contract_ The address for the contract you're delegating
72      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
73      */
74     function delegateForContract(address delegate, address contract_, bool value) external;
75 
76     /**
77      * @notice Allow the delegate to act on your behalf for a specific token
78      * @param delegate The hotwallet to act on your behalf
79      * @param contract_ The address for the contract you're delegating
80      * @param tokenId The token id for the token you're delegating
81      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
82      */
83     function delegateForToken(address delegate, address contract_, uint256 tokenId, bool value) external;
84 
85     /**
86      * @notice Revoke all delegates
87      */
88     function revokeAllDelegates() external;
89 
90     /**
91      * @notice Revoke a specific delegate for all their permissions
92      * @param delegate The hotwallet to revoke
93      */
94     function revokeDelegate(address delegate) external;
95 
96     /**
97      * @notice Remove yourself as a delegate for a specific vault
98      * @param vault The vault which delegated to the msg.sender, and should be removed
99      */
100     function revokeSelf(address vault) external;
101 
102     /**
103      * -----------  READ -----------
104      */
105 
106     /**
107      * @notice Returns all active delegations a given delegate is able to claim on behalf of
108      * @param delegate The delegate that you would like to retrieve delegations for
109      * @return info Array of DelegationInfo structs
110      */
111     function getDelegationsByDelegate(address delegate) external view returns (DelegationInfo[] memory);
112 
113     /**
114      * @notice Returns an array of wallet-level delegates for a given vault
115      * @param vault The cold wallet who issued the delegation
116      * @return addresses Array of wallet-level delegates for a given vault
117      */
118     function getDelegatesForAll(address vault) external view returns (address[] memory);
119 
120     /**
121      * @notice Returns an array of contract-level delegates for a given vault and contract
122      * @param vault The cold wallet who issued the delegation
123      * @param contract_ The address for the contract you're delegating
124      * @return addresses Array of contract-level delegates for a given vault and contract
125      */
126     function getDelegatesForContract(address vault, address contract_) external view returns (address[] memory);
127 
128     /**
129      * @notice Returns an array of contract-level delegates for a given vault's token
130      * @param vault The cold wallet who issued the delegation
131      * @param contract_ The address for the contract holding the token
132      * @param tokenId The token id for the token you're delegating
133      * @return addresses Array of contract-level delegates for a given vault's token
134      */
135     function getDelegatesForToken(address vault, address contract_, uint256 tokenId)
136         external
137         view
138         returns (address[] memory);
139 
140     /**
141      * @notice Returns all contract-level delegations for a given vault
142      * @param vault The cold wallet who issued the delegations
143      * @return delegations Array of ContractDelegation structs
144      */
145     function getContractLevelDelegations(address vault)
146         external
147         view
148         returns (ContractDelegation[] memory delegations);
149 
150     /**
151      * @notice Returns all token-level delegations for a given vault
152      * @param vault The cold wallet who issued the delegations
153      * @return delegations Array of TokenDelegation structs
154      */
155     function getTokenLevelDelegations(address vault) external view returns (TokenDelegation[] memory delegations);
156 
157     /**
158      * @notice Returns true if the address is delegated to act on the entire vault
159      * @param delegate The hotwallet to act on your behalf
160      * @param vault The cold wallet who issued the delegation
161      */
162     function checkDelegateForAll(address delegate, address vault) external view returns (bool);
163 
164     /**
165      * @notice Returns true if the address is delegated to act on your behalf for a token contract or an entire vault
166      * @param delegate The hotwallet to act on your behalf
167      * @param contract_ The address for the contract you're delegating
168      * @param vault The cold wallet who issued the delegation
169      */
170     function checkDelegateForContract(address delegate, address vault, address contract_)
171         external
172         view
173         returns (bool);
174 
175     /**
176      * @notice Returns true if the address is delegated to act on your behalf for a specific token, the token's contract or an entire vault
177      * @param delegate The hotwallet to act on your behalf
178      * @param contract_ The address for the contract you're delegating
179      * @param tokenId The token id for the token you're delegating
180      * @param vault The cold wallet who issued the delegation
181      */
182     function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
183         external
184         view
185         returns (bool);
186 }
187 
188 // File: contracts/filter/IOperatorFilterRegistry.sol
189 
190 
191 pragma solidity ^0.8.13;
192 
193 interface IOperatorFilterRegistry {
194     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
195     function register(address registrant) external;
196     function registerAndSubscribe(address registrant, address subscription) external;
197     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
198     function unregister(address addr) external;
199     function updateOperator(address registrant, address operator, bool filtered) external;
200     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
201     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
202     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
203     function subscribe(address registrant, address registrantToSubscribe) external;
204     function unsubscribe(address registrant, bool copyExistingEntries) external;
205     function subscriptionOf(address addr) external returns (address registrant);
206     function subscribers(address registrant) external returns (address[] memory);
207     function subscriberAt(address registrant, uint256 index) external returns (address);
208     function copyEntriesOf(address registrant, address registrantToCopy) external;
209     function isOperatorFiltered(address registrant, address operator) external returns (bool);
210     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
211     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
212     function filteredOperators(address addr) external returns (address[] memory);
213     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
214     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
215     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
216     function isRegistered(address addr) external returns (bool);
217     function codeHashOf(address addr) external returns (bytes32);
218 }
219 // File: contracts/filter/OperatorFilterer.sol
220 
221 
222 pragma solidity ^0.8.13;
223 
224 
225 /**
226  * @title  OperatorFilterer
227  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
228  *         registrant's entries in the OperatorFilterRegistry.
229  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
230  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
231  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
232  */
233 abstract contract OperatorFilterer {
234     error OperatorNotAllowed(address operator);
235 
236     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
237         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
238 
239     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
240         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
241         // will not revert, but the contract will need to be registered with the registry once it is deployed in
242         // order for the modifier to filter addresses.
243         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
244             if (subscribe) {
245                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
246             } else {
247                 if (subscriptionOrRegistrantToCopy != address(0)) {
248                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
249                 } else {
250                     OPERATOR_FILTER_REGISTRY.register(address(this));
251                 }
252             }
253         }
254     }
255 
256     modifier onlyAllowedOperator(address from) virtual {
257         // Allow spending tokens from addresses with balance
258         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
259         // from an EOA.
260         if (from != msg.sender) {
261             _checkFilterOperator(msg.sender);
262         }
263         _;
264     }
265 
266     modifier onlyAllowedOperatorApproval(address operator) virtual {
267         _checkFilterOperator(operator);
268         _;
269     }
270 
271     function _checkFilterOperator(address operator) internal view virtual {
272         // Check registry code length to facilitate testing in environments without a deployed registry.
273         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
274             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
275                 revert OperatorNotAllowed(operator);
276             }
277         }
278     }
279 }
280 // File: contracts/filter/DefaultOperatorFilterer.sol
281 
282 
283 pragma solidity ^0.8.13;
284 
285 
286 /**
287  * @title  DefaultOperatorFilterer
288  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
289  */
290 abstract contract DefaultOperatorFilterer is OperatorFilterer {
291     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
292 
293     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
294 }
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
299 
300 pragma solidity ^0.8.1;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      *
323      * [IMPORTANT]
324      * ====
325      * You shouldn't rely on `isContract` to protect against flash loan attacks!
326      *
327      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
328      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
329      * constructor.
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize/address.code.length, which returns 0
334         // for contracts in construction, since the code is only stored at the end
335         // of the constructor execution.
336 
337         return account.code.length > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508                 /// @solidity memory-safe-assembly
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC165 standard, as defined in the
529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
530  *
531  * Implementers can declare support of contract interfaces, which can then be
532  * queried by others ({ERC165Checker}).
533  *
534  * For an implementation, see {ERC165}.
535  */
536 interface IERC165 {
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30 000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev _Available since v3.1._
589  */
590 interface IERC1155Receiver is IERC165 {
591     /**
592      * @dev Handles the receipt of a single ERC1155 token type. This function is
593      * called at the end of a `safeTransferFrom` after the balance has been updated.
594      *
595      * NOTE: To accept the transfer, this must return
596      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
597      * (i.e. 0xf23a6e61, or its own function selector).
598      *
599      * @param operator The address which initiated the transfer (i.e. msg.sender)
600      * @param from The address which previously owned the token
601      * @param id The ID of the token being transferred
602      * @param value The amount of tokens being transferred
603      * @param data Additional data with no specified format
604      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
605      */
606     function onERC1155Received(
607         address operator,
608         address from,
609         uint256 id,
610         uint256 value,
611         bytes calldata data
612     ) external returns (bytes4);
613 
614     /**
615      * @dev Handles the receipt of a multiple ERC1155 token types. This function
616      * is called at the end of a `safeBatchTransferFrom` after the balances have
617      * been updated.
618      *
619      * NOTE: To accept the transfer(s), this must return
620      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
621      * (i.e. 0xbc197c81, or its own function selector).
622      *
623      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
624      * @param from The address which previously owned the token
625      * @param ids An array containing ids of each token being transferred (order and length must match values array)
626      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
627      * @param data Additional data with no specified format
628      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
629      */
630     function onERC1155BatchReceived(
631         address operator,
632         address from,
633         uint256[] calldata ids,
634         uint256[] calldata values,
635         bytes calldata data
636     ) external returns (bytes4);
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @dev Required interface of an ERC1155 compliant contract, as defined in the
649  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
650  *
651  * _Available since v3.1._
652  */
653 interface IERC1155 is IERC165 {
654     /**
655      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
656      */
657     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
658 
659     /**
660      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
661      * transfers.
662      */
663     event TransferBatch(
664         address indexed operator,
665         address indexed from,
666         address indexed to,
667         uint256[] ids,
668         uint256[] values
669     );
670 
671     /**
672      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
673      * `approved`.
674      */
675     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
676 
677     /**
678      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
679      *
680      * If an {URI} event was emitted for `id`, the standard
681      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
682      * returned by {IERC1155MetadataURI-uri}.
683      */
684     event URI(string value, uint256 indexed id);
685 
686     /**
687      * @dev Returns the amount of tokens of token type `id` owned by `account`.
688      *
689      * Requirements:
690      *
691      * - `account` cannot be the zero address.
692      */
693     function balanceOf(address account, uint256 id) external view returns (uint256);
694 
695     /**
696      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
697      *
698      * Requirements:
699      *
700      * - `accounts` and `ids` must have the same length.
701      */
702     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
703         external
704         view
705         returns (uint256[] memory);
706 
707     /**
708      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
709      *
710      * Emits an {ApprovalForAll} event.
711      *
712      * Requirements:
713      *
714      * - `operator` cannot be the caller.
715      */
716     function setApprovalForAll(address operator, bool approved) external;
717 
718     /**
719      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
720      *
721      * See {setApprovalForAll}.
722      */
723     function isApprovedForAll(address account, address operator) external view returns (bool);
724 
725     /**
726      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
727      *
728      * Emits a {TransferSingle} event.
729      *
730      * Requirements:
731      *
732      * - `to` cannot be the zero address.
733      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
734      * - `from` must have a balance of tokens of type `id` of at least `amount`.
735      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
736      * acceptance magic value.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 id,
742         uint256 amount,
743         bytes calldata data
744     ) external;
745 
746     /**
747      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
748      *
749      * Emits a {TransferBatch} event.
750      *
751      * Requirements:
752      *
753      * - `ids` and `amounts` must have the same length.
754      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
755      * acceptance magic value.
756      */
757     function safeBatchTransferFrom(
758         address from,
759         address to,
760         uint256[] calldata ids,
761         uint256[] calldata amounts,
762         bytes calldata data
763     ) external;
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
776  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
777  *
778  * _Available since v3.1._
779  */
780 interface IERC1155MetadataURI is IERC1155 {
781     /**
782      * @dev Returns the URI for token type `id`.
783      *
784      * If the `\{id\}` substring is present in the URI, it must be replaced by
785      * clients with the actual token type ID.
786      */
787     function uri(uint256 id) external view returns (string memory);
788 }
789 
790 // File: @openzeppelin/contracts/utils/Context.sol
791 
792 
793 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 /**
798  * @dev Provides information about the current execution context, including the
799  * sender of the transaction and its data. While these are generally available
800  * via msg.sender and msg.data, they should not be accessed in such a direct
801  * manner, since when dealing with meta-transactions the account sending and
802  * paying for execution may not be the actual sender (as far as an application
803  * is concerned).
804  *
805  * This contract is only required for intermediate, library-like contracts.
806  */
807 abstract contract Context {
808     function _msgSender() internal view virtual returns (address) {
809         return msg.sender;
810     }
811 
812     function _msgData() internal view virtual returns (bytes calldata) {
813         return msg.data;
814     }
815 }
816 
817 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
818 
819 
820 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 
826 
827 
828 
829 
830 /**
831  * @dev Implementation of the basic standard multi-token.
832  * See https://eips.ethereum.org/EIPS/eip-1155
833  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
834  *
835  * _Available since v3.1._
836  */
837 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
838     using Address for address;
839 
840     // Mapping from token ID to account balances
841     mapping(uint256 => mapping(address => uint256)) private _balances;
842 
843     // Mapping from account to operator approvals
844     mapping(address => mapping(address => bool)) private _operatorApprovals;
845 
846     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
847     string private _uri;
848 
849     /**
850      * @dev See {_setURI}.
851      */
852     constructor(string memory uri_) {
853         _setURI(uri_);
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC1155).interfaceId ||
862             interfaceId == type(IERC1155MetadataURI).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC1155MetadataURI-uri}.
868      *
869      * This implementation returns the same URI for *all* token types. It relies
870      * on the token type ID substitution mechanism
871      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
872      *
873      * Clients calling this function must replace the `\{id\}` substring with the
874      * actual token type ID.
875      */
876     function uri(uint256) public view virtual override returns (string memory) {
877         return _uri;
878     }
879 
880     /**
881      * @dev See {IERC1155-balanceOf}.
882      *
883      * Requirements:
884      *
885      * - `account` cannot be the zero address.
886      */
887     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
888         require(account != address(0), "ERC1155: address zero is not a valid owner");
889         return _balances[id][account];
890     }
891 
892     /**
893      * @dev See {IERC1155-balanceOfBatch}.
894      *
895      * Requirements:
896      *
897      * - `accounts` and `ids` must have the same length.
898      */
899     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
900         public
901         view
902         virtual
903         override
904         returns (uint256[] memory)
905     {
906         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
907 
908         uint256[] memory batchBalances = new uint256[](accounts.length);
909 
910         for (uint256 i = 0; i < accounts.length; ++i) {
911             batchBalances[i] = balanceOf(accounts[i], ids[i]);
912         }
913 
914         return batchBalances;
915     }
916 
917     /**
918      * @dev See {IERC1155-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public virtual override {
921         _setApprovalForAll(_msgSender(), operator, approved);
922     }
923 
924     /**
925      * @dev See {IERC1155-isApprovedForAll}.
926      */
927     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
928         return _operatorApprovals[account][operator];
929     }
930 
931     /**
932      * @dev See {IERC1155-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 id,
938         uint256 amount,
939         bytes memory data
940     ) public virtual override {
941         require(
942             from == _msgSender() || isApprovedForAll(from, _msgSender()),
943             "ERC1155: caller is not token owner nor approved"
944         );
945         _safeTransferFrom(from, to, id, amount, data);
946     }
947 
948     /**
949      * @dev See {IERC1155-safeBatchTransferFrom}.
950      */
951     function safeBatchTransferFrom(
952         address from,
953         address to,
954         uint256[] memory ids,
955         uint256[] memory amounts,
956         bytes memory data
957     ) public virtual override {
958         require(
959             from == _msgSender() || isApprovedForAll(from, _msgSender()),
960             "ERC1155: caller is not token owner nor approved"
961         );
962         _safeBatchTransferFrom(from, to, ids, amounts, data);
963     }
964 
965     /**
966      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
967      *
968      * Emits a {TransferSingle} event.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `from` must have a balance of tokens of type `id` of at least `amount`.
974      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
975      * acceptance magic value.
976      */
977     function _safeTransferFrom(
978         address from,
979         address to,
980         uint256 id,
981         uint256 amount,
982         bytes memory data
983     ) internal virtual {
984         require(to != address(0), "ERC1155: transfer to the zero address");
985 
986         address operator = _msgSender();
987         uint256[] memory ids = _asSingletonArray(id);
988         uint256[] memory amounts = _asSingletonArray(amount);
989 
990         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
991 
992         uint256 fromBalance = _balances[id][from];
993         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
994         unchecked {
995             _balances[id][from] = fromBalance - amount;
996         }
997         _balances[id][to] += amount;
998 
999         emit TransferSingle(operator, from, to, id, amount);
1000 
1001         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1002 
1003         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1004     }
1005 
1006     /**
1007      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1008      *
1009      * Emits a {TransferBatch} event.
1010      *
1011      * Requirements:
1012      *
1013      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1014      * acceptance magic value.
1015      */
1016     function _safeBatchTransferFrom(
1017         address from,
1018         address to,
1019         uint256[] memory ids,
1020         uint256[] memory amounts,
1021         bytes memory data
1022     ) internal virtual {
1023         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1024         require(to != address(0), "ERC1155: transfer to the zero address");
1025 
1026         address operator = _msgSender();
1027 
1028         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1029 
1030         for (uint256 i = 0; i < ids.length; ++i) {
1031             uint256 id = ids[i];
1032             uint256 amount = amounts[i];
1033 
1034             uint256 fromBalance = _balances[id][from];
1035             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1036             unchecked {
1037                 _balances[id][from] = fromBalance - amount;
1038             }
1039             _balances[id][to] += amount;
1040         }
1041 
1042         emit TransferBatch(operator, from, to, ids, amounts);
1043 
1044         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1045 
1046         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1047     }
1048 
1049     /**
1050      * @dev Sets a new URI for all token types, by relying on the token type ID
1051      * substitution mechanism
1052      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1053      *
1054      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1055      * URI or any of the amounts in the JSON file at said URI will be replaced by
1056      * clients with the token type ID.
1057      *
1058      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1059      * interpreted by clients as
1060      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1061      * for token type ID 0x4cce0.
1062      *
1063      * See {uri}.
1064      *
1065      * Because these URIs cannot be meaningfully represented by the {URI} event,
1066      * this function emits no events.
1067      */
1068     function _setURI(string memory newuri) internal virtual {
1069         _uri = newuri;
1070     }
1071 
1072     /**
1073      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1074      *
1075      * Emits a {TransferSingle} event.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1081      * acceptance magic value.
1082      */
1083     function _mint(
1084         address to,
1085         uint256 id,
1086         uint256 amount,
1087         bytes memory data
1088     ) internal virtual {
1089         require(to != address(0), "ERC1155: mint to the zero address");
1090 
1091         address operator = _msgSender();
1092         uint256[] memory ids = _asSingletonArray(id);
1093         uint256[] memory amounts = _asSingletonArray(amount);
1094 
1095         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1096 
1097         _balances[id][to] += amount;
1098         emit TransferSingle(operator, address(0), to, id, amount);
1099 
1100         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1101 
1102         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1103     }
1104 
1105     /**
1106      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1107      *
1108      * Emits a {TransferBatch} event.
1109      *
1110      * Requirements:
1111      *
1112      * - `ids` and `amounts` must have the same length.
1113      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1114      * acceptance magic value.
1115      */
1116     function _mintBatch(
1117         address to,
1118         uint256[] memory ids,
1119         uint256[] memory amounts,
1120         bytes memory data
1121     ) internal virtual {
1122         require(to != address(0), "ERC1155: mint to the zero address");
1123         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1124 
1125         address operator = _msgSender();
1126 
1127         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1128 
1129         for (uint256 i = 0; i < ids.length; i++) {
1130             _balances[ids[i]][to] += amounts[i];
1131         }
1132 
1133         emit TransferBatch(operator, address(0), to, ids, amounts);
1134 
1135         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1136 
1137         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1138     }
1139 
1140     /**
1141      * @dev Destroys `amount` tokens of token type `id` from `from`
1142      *
1143      * Emits a {TransferSingle} event.
1144      *
1145      * Requirements:
1146      *
1147      * - `from` cannot be the zero address.
1148      * - `from` must have at least `amount` tokens of token type `id`.
1149      */
1150     function _burn(
1151         address from,
1152         uint256 id,
1153         uint256 amount
1154     ) internal virtual {
1155         require(from != address(0), "ERC1155: burn from the zero address");
1156 
1157         address operator = _msgSender();
1158         uint256[] memory ids = _asSingletonArray(id);
1159         uint256[] memory amounts = _asSingletonArray(amount);
1160 
1161         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1162 
1163         uint256 fromBalance = _balances[id][from];
1164         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1165         unchecked {
1166             _balances[id][from] = fromBalance - amount;
1167         }
1168 
1169         emit TransferSingle(operator, from, address(0), id, amount);
1170 
1171         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1172     }
1173 
1174     /**
1175      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1176      *
1177      * Emits a {TransferBatch} event.
1178      *
1179      * Requirements:
1180      *
1181      * - `ids` and `amounts` must have the same length.
1182      */
1183     function _burnBatch(
1184         address from,
1185         uint256[] memory ids,
1186         uint256[] memory amounts
1187     ) internal virtual {
1188         require(from != address(0), "ERC1155: burn from the zero address");
1189         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1190 
1191         address operator = _msgSender();
1192 
1193         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1194 
1195         for (uint256 i = 0; i < ids.length; i++) {
1196             uint256 id = ids[i];
1197             uint256 amount = amounts[i];
1198 
1199             uint256 fromBalance = _balances[id][from];
1200             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1201             unchecked {
1202                 _balances[id][from] = fromBalance - amount;
1203             }
1204         }
1205 
1206         emit TransferBatch(operator, from, address(0), ids, amounts);
1207 
1208         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1209     }
1210 
1211     /**
1212      * @dev Approve `operator` to operate on all of `owner` tokens
1213      *
1214      * Emits an {ApprovalForAll} event.
1215      */
1216     function _setApprovalForAll(
1217         address owner,
1218         address operator,
1219         bool approved
1220     ) internal virtual {
1221         require(owner != operator, "ERC1155: setting approval status for self");
1222         _operatorApprovals[owner][operator] = approved;
1223         emit ApprovalForAll(owner, operator, approved);
1224     }
1225 
1226     /**
1227      * @dev Hook that is called before any token transfer. This includes minting
1228      * and burning, as well as batched variants.
1229      *
1230      * The same hook is called on both single and batched variants. For single
1231      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1232      *
1233      * Calling conditions (for each `id` and `amount` pair):
1234      *
1235      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1236      * of token type `id` will be  transferred to `to`.
1237      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1238      * for `to`.
1239      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1240      * will be burned.
1241      * - `from` and `to` are never both zero.
1242      * - `ids` and `amounts` have the same, non-zero length.
1243      *
1244      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1245      */
1246     function _beforeTokenTransfer(
1247         address operator,
1248         address from,
1249         address to,
1250         uint256[] memory ids,
1251         uint256[] memory amounts,
1252         bytes memory data
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after any token transfer. This includes minting
1257      * and burning, as well as batched variants.
1258      *
1259      * The same hook is called on both single and batched variants. For single
1260      * transfers, the length of the `id` and `amount` arrays will be 1.
1261      *
1262      * Calling conditions (for each `id` and `amount` pair):
1263      *
1264      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1265      * of token type `id` will be  transferred to `to`.
1266      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1267      * for `to`.
1268      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1269      * will be burned.
1270      * - `from` and `to` are never both zero.
1271      * - `ids` and `amounts` have the same, non-zero length.
1272      *
1273      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1274      */
1275     function _afterTokenTransfer(
1276         address operator,
1277         address from,
1278         address to,
1279         uint256[] memory ids,
1280         uint256[] memory amounts,
1281         bytes memory data
1282     ) internal virtual {}
1283 
1284     function _doSafeTransferAcceptanceCheck(
1285         address operator,
1286         address from,
1287         address to,
1288         uint256 id,
1289         uint256 amount,
1290         bytes memory data
1291     ) private {
1292         if (to.isContract()) {
1293             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1294                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1295                     revert("ERC1155: ERC1155Receiver rejected tokens");
1296                 }
1297             } catch Error(string memory reason) {
1298                 revert(reason);
1299             } catch {
1300                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1301             }
1302         }
1303     }
1304 
1305     function _doSafeBatchTransferAcceptanceCheck(
1306         address operator,
1307         address from,
1308         address to,
1309         uint256[] memory ids,
1310         uint256[] memory amounts,
1311         bytes memory data
1312     ) private {
1313         if (to.isContract()) {
1314             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1315                 bytes4 response
1316             ) {
1317                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1318                     revert("ERC1155: ERC1155Receiver rejected tokens");
1319                 }
1320             } catch Error(string memory reason) {
1321                 revert(reason);
1322             } catch {
1323                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1324             }
1325         }
1326     }
1327 
1328     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1329         uint256[] memory array = new uint256[](1);
1330         array[0] = element;
1331 
1332         return array;
1333     }
1334 }
1335 
1336 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1337 
1338 
1339 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 
1344 /**
1345  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1346  * own tokens and those that they have been approved to use.
1347  *
1348  * _Available since v3.1._
1349  */
1350 abstract contract ERC1155Burnable is ERC1155 {
1351     function burn(
1352         address account,
1353         uint256 id,
1354         uint256 value
1355     ) public virtual {
1356         require(
1357             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1358             "ERC1155: caller is not token owner nor approved"
1359         );
1360 
1361         _burn(account, id, value);
1362     }
1363 
1364     function burnBatch(
1365         address account,
1366         uint256[] memory ids,
1367         uint256[] memory values
1368     ) public virtual {
1369         require(
1370             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1371             "ERC1155: caller is not token owner nor approved"
1372         );
1373 
1374         _burnBatch(account, ids, values);
1375     }
1376 }
1377 
1378 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1379 
1380 
1381 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 
1386 /**
1387  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1388  *
1389  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1390  * clearly identified. Note: While a totalSupply of 1 might mean the
1391  * corresponding is an NFT, there is no guarantees that no other token with the
1392  * same id are not going to be minted.
1393  */
1394 abstract contract ERC1155Supply is ERC1155 {
1395     mapping(uint256 => uint256) private _totalSupply;
1396 
1397     /**
1398      * @dev Total amount of tokens in with a given id.
1399      */
1400     function totalSupply(uint256 id) public view virtual returns (uint256) {
1401         return _totalSupply[id];
1402     }
1403 
1404     /**
1405      * @dev Indicates whether any token exist with a given id, or not.
1406      */
1407     function exists(uint256 id) public view virtual returns (bool) {
1408         return ERC1155Supply.totalSupply(id) > 0;
1409     }
1410 
1411     /**
1412      * @dev See {ERC1155-_beforeTokenTransfer}.
1413      */
1414     function _beforeTokenTransfer(
1415         address operator,
1416         address from,
1417         address to,
1418         uint256[] memory ids,
1419         uint256[] memory amounts,
1420         bytes memory data
1421     ) internal virtual override {
1422         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1423 
1424         if (from == address(0)) {
1425             for (uint256 i = 0; i < ids.length; ++i) {
1426                 _totalSupply[ids[i]] += amounts[i];
1427             }
1428         }
1429 
1430         if (to == address(0)) {
1431             for (uint256 i = 0; i < ids.length; ++i) {
1432                 uint256 id = ids[i];
1433                 uint256 amount = amounts[i];
1434                 uint256 supply = _totalSupply[id];
1435                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1436                 unchecked {
1437                     _totalSupply[id] = supply - amount;
1438                 }
1439             }
1440         }
1441     }
1442 }
1443 
1444 // File: @openzeppelin/contracts/access/Ownable.sol
1445 
1446 
1447 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 
1452 /**
1453  * @dev Contract module which provides a basic access control mechanism, where
1454  * there is an account (an owner) that can be granted exclusive access to
1455  * specific functions.
1456  *
1457  * By default, the owner account will be the one that deploys the contract. This
1458  * can later be changed with {transferOwnership}.
1459  *
1460  * This module is used through inheritance. It will make available the modifier
1461  * `onlyOwner`, which can be applied to your functions to restrict their use to
1462  * the owner.
1463  */
1464 abstract contract Ownable is Context {
1465     address private _owner;
1466 
1467     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1468 
1469     /**
1470      * @dev Initializes the contract setting the deployer as the initial owner.
1471      */
1472     constructor() {
1473         _transferOwnership(_msgSender());
1474     }
1475 
1476     /**
1477      * @dev Throws if called by any account other than the owner.
1478      */
1479     modifier onlyOwner() {
1480         _checkOwner();
1481         _;
1482     }
1483 
1484     /**
1485      * @dev Returns the address of the current owner.
1486      */
1487     function owner() public view virtual returns (address) {
1488         return _owner;
1489     }
1490 
1491     /**
1492      * @dev Throws if the sender is not the owner.
1493      */
1494     function _checkOwner() internal view virtual {
1495         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1496     }
1497 
1498     /**
1499      * @dev Leaves the contract without owner. It will not be possible to call
1500      * `onlyOwner` functions anymore. Can only be called by the current owner.
1501      *
1502      * NOTE: Renouncing ownership will leave the contract without an owner,
1503      * thereby removing any functionality that is only available to the owner.
1504      */
1505     function renounceOwnership() public virtual onlyOwner {
1506         _transferOwnership(address(0));
1507     }
1508 
1509     /**
1510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1511      * Can only be called by the current owner.
1512      */
1513     function transferOwnership(address newOwner) public virtual onlyOwner {
1514         require(newOwner != address(0), "Ownable: new owner is the zero address");
1515         _transferOwnership(newOwner);
1516     }
1517 
1518     /**
1519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1520      * Internal function without access restriction.
1521      */
1522     function _transferOwnership(address newOwner) internal virtual {
1523         address oldOwner = _owner;
1524         _owner = newOwner;
1525         emit OwnershipTransferred(oldOwner, newOwner);
1526     }
1527 }
1528 
1529 // File: contracts/LastCall.sol
1530 
1531 
1532 pragma solidity ^0.8.17;
1533 
1534 
1535 
1536 
1537 
1538 
1539 interface IFinsBeachBar {
1540     function balanceOf(address _address, uint256 tokenID) external returns (uint256);
1541     function supportsInterface(bytes4 interfaceId) external returns (bool);
1542 }
1543 
1544 interface IDoodlesOG {
1545     function balanceOf(address _address) external returns (uint256);
1546     function supportsInterface(bytes4 interfaceId) external returns (bool);
1547 }
1548 
1549 contract LastCall is DefaultOperatorFilterer, ERC1155, ERC1155Supply, ERC1155Burnable, Ownable {
1550     
1551     string public name = "Last Call";
1552     string public symbol = "FINS";
1553     uint256 public constant MAX_FINS_BEACH_BAR_TOKEN = 26; /// The highest eligible token from the OG contract we'll check for
1554     uint256 public constant FINS_BEACH_BAR_VIP_TOKEN_ID = 10; /// VIP Fin's Token ID
1555     uint256 public constant FINS_BEACH_BAR_HOLOCAT_TOKEN_ID = 69; /// ooooh, shiny! 
1556     uint256 public constant DOODLE_DRINK = 16; /// Put it on Poopie's Tab
1557     uint256 public constant IYKYK = 17; /// IYKYK
1558     uint256 public constant REDEEMABLE_DRINK_ID = 19; // burn 15 unique tokens to have this token id
1559     uint256 public constant GENEROUS_TIPPER_ODDS = 20; /// a 1 in 20 chance to roll a random token if tipping generously
1560     uint256 public constant FINS_VIP_ODDS = 40; /// a 1 in 40 chance to roll on every VIP mint
1561     uint256 public constant DOODLE_HOLDER_ODDS = 16; /// a 1 in 16 chance to roll a rare prize - doodle holders only
1562     uint256 public constant DRINK_18_PRICE = 69 ether; /// the game's only 1:1
1563 
1564     /// Fin's Beach Bar contract so we can interface with it
1565     address public finsContractAddress;
1566 
1567     /// Doodles contract address so we can interface with it
1568     address public doodlesContractAddress;
1569     
1570     /// delegate.cash registry
1571     address public delegationContractAddress;
1572 
1573     /// is the bar open? 
1574     bool public barIsOpen;
1575 
1576     /// Require VIP membership to call a function
1577     bool public onlyVIP; 
1578 
1579     /// Require membership to call a function
1580     bool public onlyFins;
1581 
1582     /// See if token 18 has been minted
1583     bool public drink18Minted;
1584 
1585     /// Keep track of the last block a token was minted
1586     uint256 public lastMintBlock = block.number;
1587 
1588     /// We will set the timer to 75 blocks (15 minutes in block time) 
1589     uint256 public DURATION = 74; 
1590 
1591     uint256 public gameStartBlock = 0;
1592 
1593     uint256 public generousTip = 0.05 ether;
1594 
1595     uint256 private nonce;
1596 
1597     /**
1598     * The _duration param specifies the number of blocks until the timer counts down to zero
1599     */
1600     constructor(string memory _uri) ERC1155(_uri) {
1601         _setURI(_uri);
1602 
1603         /// mint an initial set of tokens to the contract creator
1604         for (uint256 i = 1; i <= 17; ++i) {
1605             _mint(msg.sender, i, 1, "");
1606         }
1607         _mint(msg.sender, 19, 1, "");
1608     }
1609 
1610     /// @dev set the URI to your base URI here, don't forget the {id} param.
1611     function setURI(string memory newuri) external onlyOwner {
1612         _setURI(newuri);
1613     }
1614 
1615     /// @dev update the amount of ether we consider a "generous tip" 
1616     function setGenerousTip(uint256 _amount) external onlyOwner {
1617         generousTip = _amount;
1618     }
1619 
1620     function setFinsBeachBarContract(address _address) external onlyOwner {
1621         /// Validate that the candidate contract is 1155
1622         require(
1623             IFinsBeachBar(_address).supportsInterface(0xd9b67a26),
1624             "Does not support IERC1155 interface."
1625         );
1626 
1627         // Set the new contract address
1628         finsContractAddress = _address;
1629     }
1630 
1631     function setDoodlesContract(address _address) external onlyOwner {
1632 
1633         require(
1634             IDoodlesOG(_address).supportsInterface(0x780e9d63),
1635             "Does not support IERC721 interface"
1636         );
1637 
1638         // Set the new contract address
1639         doodlesContractAddress = _address;
1640     }
1641 
1642     function setDelegationContract(address _address) external onlyOwner {
1643 
1644         // Set the new contract address
1645         delegationContractAddress = _address;
1646     }
1647 
1648     function setVIPRequirement(bool _require) external onlyOwner {
1649         onlyVIP = _require;
1650     }
1651 
1652     function setOnlyFinsRequirement(bool _require) external onlyOwner {
1653         onlyFins = _require;
1654     }
1655 
1656     function setBarStatus(bool _isOpen, bool _isPublic) external onlyOwner {
1657         /// once the bar is opened to the public, it can't be opened again
1658         require(gameStartBlock == 0, "The bar cannot be opened again");
1659         
1660         barIsOpen = _isOpen;
1661 
1662         if (_isPublic) {
1663             gameStartBlock = block.number;
1664         }
1665 
1666         if (_isOpen) {
1667             _resetTimer();
1668         }
1669     }
1670 
1671     function _resetTimer() internal {
1672         lastMintBlock = block.number;
1673     }
1674 
1675     /// check to see if the address is a Fin's member
1676     function isFinsMember(address _vault) public returns (bool) {
1677         address mintAddress = msg.sender;
1678 
1679         if (_vault != address(0)) { 
1680             bool isDelegateValid = IDelegationRegistry(delegationContractAddress).checkDelegateForContract(msg.sender, _vault, finsContractAddress);
1681             require(isDelegateValid, "invalid delegate-vault pairing");
1682             mintAddress = _vault;
1683         }
1684 
1685         if (IFinsBeachBar(finsContractAddress).balanceOf(mintAddress, FINS_BEACH_BAR_HOLOCAT_TOKEN_ID) > 0) { 
1686             return true;
1687         }
1688 
1689         for (uint256 i; i <= MAX_FINS_BEACH_BAR_TOKEN; ++i) {
1690             if (IFinsBeachBar(finsContractAddress).balanceOf(mintAddress, i) > 0) {
1691                 return true;
1692             }
1693         }
1694         return false;
1695     }
1696 
1697     /// check to see if the address is a Fin's VIP
1698     function isFinsVIP(address _vault) public returns (bool) {
1699         
1700         address mintAddress = msg.sender;
1701 
1702         if (_vault != address(0)) { 
1703             bool isDelegateValid = IDelegationRegistry(delegationContractAddress).checkDelegateForContract(msg.sender, _vault, finsContractAddress);
1704             require(isDelegateValid, "invalid delegate-vault pairing");
1705             mintAddress = _vault;
1706         }
1707 
1708         return IFinsBeachBar(finsContractAddress).balanceOf(mintAddress, FINS_BEACH_BAR_VIP_TOKEN_ID) > 0;
1709     }
1710 
1711     /// check to see if the address has an OG Doodle
1712     function ownsADoodle(address _vault) public returns (bool) {
1713 
1714         address mintAddress = msg.sender;
1715 
1716         if (_vault != address(0)) { 
1717             bool isDelegateValid = IDelegationRegistry(delegationContractAddress).checkDelegateForContract(msg.sender, _vault, doodlesContractAddress);
1718             require(isDelegateValid, "invalid delegate-vault pairing");
1719             mintAddress = _vault;
1720         }
1721 
1722         return IDoodlesOG(doodlesContractAddress).balanceOf(mintAddress) > 0;
1723     }
1724 
1725     /**
1726     * @notice it's free to buy a round of drinks at the bar. 
1727     * The closer a drink is minted to the timer going to zero, the rarer it will be
1728     * Split into three function calls to skip unnecessary gas spend on most mints for non-holders
1729     */
1730     function _kindaRandom(uint256 _max) internal returns (uint256) {
1731         uint256 kindaRandomnumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % _max;
1732         nonce++;
1733         return kindaRandomnumber;
1734     }
1735 
1736     function tendBar(address _toAddress) public onlyOwner {
1737         _mintDrink(_toAddress, IYKYK);
1738     }
1739 
1740     function mintDrink18() external payable {
1741         require(msg.value >= DRINK_18_PRICE, "Must send at least 69 ETH");
1742         require(!drink18Minted, "No Remaining Supply");
1743 
1744         /// mark the drink as minted... this can only be done once 
1745         drink18Minted = true;
1746 
1747         /// serve the only 1:1 in the collection
1748         _mintDrink(msg.sender, 18);
1749     }
1750 
1751  
1752     function mintAsVIP(address _vault) external payable {
1753         /// add a required min to deter spam
1754         require(msg.value >= 0.0001 ether, "Must send at least 0.0001 eth");
1755 
1756         require(isFinsVIP(_vault), "Not a VIP");
1757 
1758         uint256 idToMint = _idToMint();
1759         
1760         /// for Fin's VIPs, there's a 1 in 40 chance of minting a random token
1761         if (_kindaRandom(FINS_VIP_ODDS) == 20){
1762             idToMint  = _kindaRandom(15) + 1;
1763         }
1764 
1765         _mintDrink(msg.sender, idToMint);
1766     }
1767 
1768     function mintAsDoodle(address _vault) external payable {
1769         /// add a required min to deter spam
1770         require(msg.value >= 0.0001 ether, "Must send at least 0.0001 eth");
1771 
1772         if (onlyFins){
1773             require(isFinsMember(_vault), "Not a Fin's Holder");
1774         }
1775         
1776         if (onlyVIP){
1777             require(isFinsVIP(_vault), "Not a VIP");
1778         }
1779 
1780         uint256 idToMint = _idToMint();
1781 
1782         if (ownsADoodle(_vault)){
1783             if (_kindaRandom(DOODLE_HOLDER_ODDS) == 5){
1784                 idToMint = DOODLE_DRINK;
1785             }
1786         }
1787 
1788         _mintDrink(msg.sender, idToMint);
1789     }
1790 
1791     function mint(address _vault) external payable {
1792         /// add a required min to deter spam
1793         require(msg.value >= 0.0001 ether, "Must send at least 0.0001 eth");
1794 
1795         if (onlyFins){
1796             require(isFinsMember(_vault), "Not a Fin's Holder");
1797         }
1798 
1799         if (onlyVIP){
1800             require(isFinsVIP(_vault), "Not a VIP");
1801         }
1802 
1803         _mintDrink(msg.sender, _idToMint());
1804     }
1805 
1806     function _mintDrink(address _toAddress, uint256 _id) internal {
1807         /// ensure the game is active
1808         require(barIsOpen, "Fin's Beach Bar is Closed");
1809 
1810         /// reset the timer
1811         _resetTimer();
1812 
1813         /// mint the token
1814         _mint(_toAddress, _id, 1, "");
1815     }
1816 
1817     function _idToMint() internal returns (uint256) {
1818         uint256 id = 15 - (currentRound()/5);
1819 
1820         /// for paid mints, there's a 1 in 20 chance of minting a random token
1821         if (msg.value >= generousTip && _kindaRandom(GENEROUS_TIPPER_ODDS) == 10){
1822             id = _kindaRandom(15) + 1;
1823         }
1824 
1825         return id;
1826     }
1827 
1828     function currentRound() public view returns (uint256) {
1829         /// calculate how much time has passed since the last mint
1830         uint256 elapsed = block.number - lastMintBlock;
1831 
1832         require(DURATION > elapsed, "The timer has expired");
1833 
1834         return DURATION - elapsed;
1835     }
1836 
1837     function burnToRedeem(uint256[] calldata ids) external {
1838         /// ensure that exactly the required number of items (15) are submitted to burn
1839         require(ids.length == 15, "Wrong number of tokens submitted");
1840 
1841         /// keep track of which tokens were submitted to prevent dupes
1842         /// all tokens are eligible but only 15 are needed
1843         uint256[] memory tokens = new uint256[](19);
1844         uint256[] memory values = new uint256[](15);
1845 
1846         /// loop over each of the 15 ids submitted to burn
1847         for (uint256 i; i <= 14; ++i) {
1848 
1849             /// ensure the token id is between 1 and 17
1850             require(ids[i] >= 1 && ids[i] <= 18, "Token not eligible");
1851 
1852             /// ensure that the token is not already in the list
1853             require(tokens[ids[i]] == 0, "Each token must be unique");
1854 
1855             /// mark the token as "used" so we prevent duplicates from being used
1856             tokens[ids[i]] = 1;
1857 
1858             /// tell the burn function to burn 1 of this specific id
1859             values[i] = 1;
1860         }
1861 
1862         /// burn the set of tokens and exchange them for a new one
1863         _burnBatch(msg.sender, ids, values);
1864         _mint(msg.sender, REDEEMABLE_DRINK_ID, 1, "");
1865     }
1866 
1867     /// @dev allows the owner to withdraw the funds in this contract
1868     function withdrawBalance(address payable _address) external onlyOwner {
1869         (bool success, ) = _address.call{value: address(this).balance}("");
1870         require(success, "Withdraw failed");
1871     }
1872 
1873     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1874         super.setApprovalForAll(operator, approved);
1875     }
1876 
1877     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
1878         public
1879         override
1880         onlyAllowedOperator(from)
1881     {
1882         super.safeTransferFrom(from, to, tokenId, amount, data);
1883     }
1884 
1885     function safeBatchTransferFrom(
1886         address from,
1887         address to,
1888         uint256[] memory ids,
1889         uint256[] memory amounts,
1890         bytes memory data
1891     ) public virtual override onlyAllowedOperator(from) {
1892         super.safeBatchTransferFrom(from, to, ids, amounts, data);
1893     }
1894 
1895     function _beforeTokenTransfer(
1896         address operator,
1897         address from,
1898         address to,
1899         uint256[] memory ids,
1900         uint256[] memory amounts,
1901         bytes memory data
1902     ) internal override(ERC1155, ERC1155Supply) {
1903         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1904     }
1905 }