1 // Sources flattened with hardhat v2.0.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.2;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies in extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 
148 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
149 
150 pragma solidity ^0.6.0;
151 
152 /*
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with GSN meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address payable) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes memory) {
168         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
169         return msg.data;
170     }
171 }
172 
173 
174 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.2.0
175 
176 pragma solidity ^0.6.0;
177 
178 /**
179  * @dev Interface of the ERC165 standard, as defined in the
180  * https://eips.ethereum.org/EIPS/eip-165[EIP].
181  *
182  * Implementers can declare support of contract interfaces, which can then be
183  * queried by others ({ERC165Checker}).
184  *
185  * For an implementation, see {ERC165}.
186  */
187 interface IERC165 {
188     /**
189      * @dev Returns true if this contract implements the interface defined by
190      * `interfaceId`. See the corresponding
191      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
192      * to learn more about how these ids are created.
193      *
194      * This function call must use less than 30 000 gas.
195      */
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 }
198 
199 
200 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.2.0
201 
202 pragma solidity ^0.6.0;
203 
204 /**
205  * @dev Implementation of the {IERC165} interface.
206  *
207  * Contracts may inherit from this and call {_registerInterface} to declare
208  * their support of an interface.
209  */
210 contract ERC165 is IERC165 {
211     /*
212      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
213      */
214     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
215 
216     /**
217      * @dev Mapping of interface ids to whether or not it's supported.
218      */
219     mapping(bytes4 => bool) private _supportedInterfaces;
220 
221     constructor () internal {
222         // Derived contracts need only register support for their own interfaces,
223         // we register support for ERC165 itself here
224         _registerInterface(_INTERFACE_ID_ERC165);
225     }
226 
227     /**
228      * @dev See {IERC165-supportsInterface}.
229      *
230      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
231      */
232     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
233         return _supportedInterfaces[interfaceId];
234     }
235 
236     /**
237      * @dev Registers the contract as an implementer of the interface defined by
238      * `interfaceId`. Support of the actual ERC165 interface is automatic and
239      * registering its interface id is not required.
240      *
241      * See {IERC165-supportsInterface}.
242      *
243      * Requirements:
244      *
245      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
246      */
247     function _registerInterface(bytes4 interfaceId) internal virtual {
248         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
249         _supportedInterfaces[interfaceId] = true;
250     }
251 }
252 
253 
254 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155.sol@v6.0.0
255 
256 pragma solidity 0.6.8;
257 
258 /**
259  * @title ERC-1155 Multi Token Standard, basic interface
260  * @dev See https://eips.ethereum.org/EIPS/eip-1155
261  * Note: The ERC-165 identifier for this interface is 0xd9b67a26.
262  */
263 interface IERC1155 {
264 
265     event TransferSingle(
266         address indexed _operator,
267         address indexed _from,
268         address indexed _to,
269         uint256 _id,
270         uint256 _value
271     );
272 
273     event TransferBatch(
274         address indexed _operator,
275         address indexed _from,
276         address indexed _to,
277         uint256[] _ids,
278         uint256[] _values
279     );
280 
281     event ApprovalForAll(
282         address indexed _owner,
283         address indexed _operator,
284         bool _approved
285     );
286 
287     event URI(
288         string _value,
289         uint256 indexed _id
290     );
291 
292     /**
293      * @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).
294      * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
295      * @dev MUST revert if `to` is the zero address.
296      * @dev MUST revert if balance of holder for token `id` is lower than the `value` sent.
297      * @dev MUST revert on any other error.
298      * @dev MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
299      * @dev After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
300      * @param from    Source address
301      * @param to      Target address
302      * @param id      ID of the token type
303      * @param value   Transfer amount
304      * @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
305     */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 id,
310         uint256 value,
311         bytes calldata data
312     ) external;
313 
314     /**
315      * @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).
316      * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
317      * @dev MUST revert if `to` is the zero address.
318      * @dev MUST revert if length of `ids` is not the same as length of `values`.
319      * @dev MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.
320      * @dev MUST revert on any other error.
321      * @dev MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
322      * @dev Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
323      * @dev After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
324      * @param from    Source address
325      * @param to      Target address
326      * @param ids     IDs of each token type (order and length must match _values array)
327      * @param values  Transfer amounts per token type (order and length must match _ids array)
328      * @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`
329     */
330     function safeBatchTransferFrom(
331         address from,
332         address to,
333         uint256[] calldata ids,
334         uint256[] calldata values,
335         bytes calldata data
336     ) external;
337 
338     /**
339      * @notice Get the balance of an account's tokens.
340      * @param owner  The address of the token holder
341      * @param id     ID of the token
342      * @return       The _owner's balance of the token type requested
343      */
344     function balanceOf(address owner, uint256 id) external view returns (uint256);
345 
346     /**
347      * @notice Get the balance of multiple account/token pairs
348      * @param owners The addresses of the token holders
349      * @param ids    ID of the tokens
350      * @return       The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
351      */
352     function balanceOfBatch(
353         address[] calldata owners,
354         uint256[] calldata ids
355     ) external view returns (uint256[] memory);
356 
357     /**
358      * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
359      * @dev MUST emit the ApprovalForAll event on success.
360      * @param operator Address to add to the set of authorized operators
361      * @param approved True if the operator is approved, false to revoke approval
362     */
363     function setApprovalForAll(address operator, bool approved) external;
364 
365     /**
366      * @notice Queries the approval status of an operator for a given owner.
367      * @param owner     The owner of the tokens
368      * @param operator  Address of authorized operator
369      * @return          True if the operator is approved, false if not
370     */
371     function isApprovedForAll(address owner, address operator) external view returns (bool);
372 }
373 
374 
375 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155MetadataURI.sol@v6.0.0
376 
377 pragma solidity 0.6.8;
378 
379 /**
380  * @title ERC-1155 Multi Token Standard, optional metadata URI extension
381  * @dev See https://eips.ethereum.org/EIPS/eip-1155
382  * Note: The ERC-165 identifier for this interface is 0x0e89341c.
383  */
384 interface IERC1155MetadataURI {
385     /**
386      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
387      * @dev URIs are defined in RFC 3986.
388      * @dev The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
389      * @dev The uri function SHOULD be used to retrieve values if no event was emitted.
390      * @dev The uri function MUST return the same value as the latest event for an _id if it was emitted.
391      * @dev The uri function MUST NOT be used to check for the existence of a token as it is possible for an implementation to return a valid string even if the token does not exist.
392      * @return URI string
393      */
394     function uri(uint256 id) external view returns (string memory);
395 }
396 
397 
398 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155Inventory.sol@v6.0.0
399 
400 pragma solidity 0.6.8;
401 
402 
403 /**
404  * @title ERC-1155 Multi Token Standard, optional Inventory extension
405  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
406  * Interface for fungible/non-fungible tokens management on a 1155-compliant contract.
407  *
408  * This interface rationalizes the co-existence of fungible and non-fungible tokens
409  * within the same contract. As several kinds of fungible tokens can be managed under
410  * the Multi-Token standard, we consider that non-fungible tokens can be classified
411  * under their own specific type. We introduce the concept of non-fungible collection
412  * and consider the usage of 3 types of identifiers:
413  * (a) Fungible Token identifiers, each representing a set of Fungible Tokens,
414  * (b) Non-Fungible Collection identifiers, each representing a set of Non-Fungible Tokens (this is not a token),
415  * (c) Non-Fungible Token identifiers. 
416 
417  * Identifiers nature
418  * |       Type                | isFungible  | isCollection | isToken |
419  * |  Fungible Token           |   true      |     true     |  true   |
420  * |  Non-Fungible Collection  |   false     |     true     |  false  |
421  * |  Non-Fungible Token       |   false     |     false    |  true   |
422  *
423  * Identifiers compatibilities
424  * |       Type                |  transfer  |   balance    |   supply    |  owner  |
425  * |  Fungible Token           |    OK      |     OK       |     OK      |   NOK   |
426  * |  Non-Fungible Collection  |    NOK     |     OK       |     OK      |   NOK   |
427  * |  Non-Fungible Token       |    OK      |   0 or 1     |   0 or 1    |   OK    |
428  *
429  * Note: The ERC-165 identifier for this interface is 0x469bd23f.
430  */
431 interface IERC1155Inventory {
432 
433     /**
434      * Optional event emitted when a collection is created.
435      *  This event SHOULD NOT be emitted twice for the same `collectionId`.
436      * 
437      *  The parameters in the functions `collectionOf` and `ownerOf` are required to be
438      *  non-fungible token identifiers, so they should not be called with any collection
439      *  identifiers, else they will revert.
440      * 
441      *  On the contrary, the functions `balanceOf`, `balanceOfBatch` and `totalSupply` are
442      *  best used with collection identifiers, which will return meaningful information for
443      *  the owner.
444      */
445     event CollectionCreated (uint256 indexed collectionId, bool indexed fungible);
446 
447     /**
448      * Retrieves the owner of a non-fungible token.
449      * @dev Reverts if `nftId` is owned by the zero address. // ERC721 compatibility
450      * @dev Reverts if `nftId` does not represent a non-fungible token.
451      * @param nftId The token identifier to query.
452      * @return Address of the current owner of the token.
453      */
454     function ownerOf(uint256 nftId) external view returns (address);
455 
456     /**
457      * Retrieves the total supply of `id`.
458      *  If `id` represents a fungible or non-fungible collection, returns the supply of tokens for this collection.
459      *  If `id` represents a non-fungible token, returns 1 if the token exists, else 0.
460      * @param id The identifier for which to retrieve the supply of.
461      * @return The supplies for each identifier in `ids`.
462      */
463     function totalSupply(uint256 id) external view returns (uint256);
464 
465     /**
466      * Introspects whether or not `id` represents afungible token.
467      *  This function MUST return true even for afungible tokens which is not-yet created.
468      * @param id The identifier to query.
469      * @return bool True if `id` represents afungible token, false otherwise.
470      */
471     function isFungible(uint256 id) external pure returns (bool);
472 
473     /**
474      * Introspects the non-fungible collection to which `nftId` belongs.
475      *  This function MUST return a value representing a non-fungible collection.
476      *  This function MUST return a value for a non-existing token, and SHOULD NOT be used to check the existence of a non-fungible token.
477      * @dev Reverts if `nftId` does not represent a non-fungible token.
478      * @param nftId The token identifier to query the collection of.
479      * @return uint256 the non-fungible collection identifier to which `nftId` belongs.
480      */
481     function collectionOf(uint256 nftId) external pure returns (uint256);
482 
483     /**
484      * @notice this definition replaces the original {ERC1155-balanceOf}.
485      * Retrieves the balance of `id` owned by account `owner`.
486      *  If `id` represents a fungible or non-fungible collection, returns the balance of tokens for this collection.
487      *  If `id` represents a non-fungible token, returns 1 if the token is owned by `owner`, else 0.
488      * @param owner The account to retrieve the balance of.
489      * @param id The identifier to retrieve the balance of.
490      * @return The balance of `id` owned by account `owner`.
491      */
492     // function balanceOf(address owner, uint256 id) external view returns (uint256);
493 
494     /**
495      * @notice this definition replaces the original {ERC1155-balanceOfBatch}.
496      * Retrieves the balances of `ids` owned by accounts `owners`. For each pair:
497      *  if `id` represents a fungible or non-fungible collection, returns the balance of tokens for this collection,
498      *  if `id` represents a non-fungible token, returns 1 if the token is owned by `owner`, else 0.
499      * @param owners The addresses of the token holders
500      * @param ids The identifiers to retrieve the balance of.
501      * @return The balances of `ids` owned by accounts `owners`.
502      */
503     // function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);
504 }
505 
506 
507 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v6.0.0
508 
509 pragma solidity 0.6.8;
510 
511 /**
512  * @title ERC-1155 Multi Token Standard, token receiver
513  * @dev See https://eips.ethereum.org/EIPS/eip-1155
514  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
515  * Note: The ERC-165 identifier for this interface is 0x4e2312e0.
516  */
517 interface IERC1155TokenReceiver {
518 
519     /**
520      * @notice Handle the receipt of a single ERC1155 token type.
521      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
522      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
523      * This function MUST revert if it rejects the transfer.
524      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
525      * @param operator  The address which initiated the transfer (i.e. msg.sender)
526      * @param from      The address which previously owned the token
527      * @param id        The ID of the token being transferred
528      * @param value     The amount of tokens being transferred
529      * @param data      Additional data with no specified format
530      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
531     */
532     function onERC1155Received(
533         address operator,
534         address from,
535         uint256 id,
536         uint256 value,
537         bytes calldata data
538     ) external returns (bytes4);
539 
540     /**
541      * @notice Handle the receipt of multiple ERC1155 token types.
542      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
543      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
544      * This function MUST revert if it rejects the transfer(s).
545      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
546      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
547      * @param from      The address which previously owned the token
548      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
549      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
550      * @param data      Additional data with no specified format
551      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
552     */
553     function onERC1155BatchReceived(
554         address operator,
555         address from,
556         uint256[] calldata ids,
557         uint256[] calldata values,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 
563 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155InventoryBase.sol@v6.0.0
564 
565 pragma solidity 0.6.8;
566 
567 
568 
569 
570 
571 
572 abstract contract ERC1155InventoryBase is IERC1155, IERC1155MetadataURI, IERC1155Inventory, ERC165, Context {
573     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
574     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
575 
576     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
577     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
578 
579     // Burnt non-fungible token owner's magic value
580     uint256 internal constant _BURNT_NFT_OWNER = 0xdead000000000000000000000000000000000000000000000000000000000000;
581 
582     // Non-fungible bit. If an id has this bit set, it is a non-fungible (either collection or token)
583     uint256 internal constant _NF_BIT = 1 << 255;
584 
585     // Mask for non-fungible collection (including the nf bit)
586     uint256 internal constant _NF_COLLECTION_MASK = uint256(type(uint32).max) << 224;
587     uint256 internal constant _NF_TOKEN_MASK = ~_NF_COLLECTION_MASK;
588 
589     /* owner => operator => approved */
590     mapping(address => mapping(address => bool)) internal _operators;
591 
592     /* collection ID => owner => balance */
593     mapping(uint256 => mapping(address => uint256)) internal _balances;
594 
595     /* collection ID => supply */
596     mapping(uint256 => uint256) internal _supplies;
597 
598     /* NFT ID => owner */
599     mapping(uint256 => uint256) internal _owners;
600 
601     /* collection ID => creator */
602     mapping(uint256 => address) internal _creators;
603 
604     /**
605      * @dev Constructor function
606      */
607     constructor() internal {
608         _registerInterface(type(IERC1155).interfaceId);
609         _registerInterface(type(IERC1155MetadataURI).interfaceId);
610         _registerInterface(type(IERC1155Inventory).interfaceId);
611     }
612 
613     //================================== ERC1155 =======================================/
614 
615     /**
616      * @dev See {IERC1155-balanceOf}.
617      */
618     function balanceOf(address owner, uint256 id) public virtual override view returns (uint256) {
619         require(owner != address(0), "Inventory: zero address");
620 
621         if (isNFT(id)) {
622             return _owners[id] == uint256(owner) ? 1 : 0;
623         }
624 
625         return _balances[id][owner];
626     }
627 
628     /**
629      * @dev See {IERC1155-balanceOfBatch}.
630      */
631     function balanceOfBatch(address[] memory owners, uint256[] memory ids)
632         public
633         virtual
634         override
635         view
636         returns (uint256[] memory)
637     {
638         require(owners.length == ids.length, "Inventory: inconsistent arrays");
639 
640         uint256[] memory balances = new uint256[](owners.length);
641 
642         for (uint256 i = 0; i != owners.length; ++i) {
643             balances[i] = balanceOf(owners[i], ids[i]);
644         }
645 
646         return balances;
647     }
648 
649     /**
650      * @dev See {IERC1155-setApprovalForAll}.
651      */
652     function setApprovalForAll(address operator, bool approved) public virtual override {
653         address sender = _msgSender();
654         require(operator != sender, "Inventory: self-approval");
655         _operators[sender][operator] = approved;
656         emit ApprovalForAll(sender, operator, approved);
657     }
658 
659     /**
660      * @dev See {IERC1155-isApprovedForAll}.
661      */
662     function isApprovedForAll(address tokenOwner, address operator) public virtual override view returns (bool) {
663         return _operators[tokenOwner][operator];
664     }
665 
666     //================================== ERC1155MetadataURI =======================================/
667 
668     /**
669      * @dev See {IERC1155MetadataURI-uri}.
670      */
671     function uri(uint256 id) external virtual override view returns (string memory) {
672         return _uri(id);
673     }
674 
675     //================================== ERC1155Inventory =======================================/
676 
677     /**
678      * @dev See {IERC1155Inventory-isFungible}.
679      */
680     function isFungible(uint256 id) public virtual override pure returns (bool) {
681         return id & _NF_BIT == 0;
682     }
683 
684     /**
685      * @dev See {IERC1155Inventory-collectionOf}.
686      */
687     function collectionOf(uint256 nftId) public virtual override pure returns (uint256) {
688         require(isNFT(nftId), "Inventory: not an NFT");
689         return nftId & _NF_COLLECTION_MASK;
690     }
691 
692     /**
693      * @dev See {IERC1155Inventory-ownerOf}.
694      */
695     function ownerOf(uint256 nftId) public virtual override view returns (address) {
696         address owner = address(_owners[nftId]);
697         require(owner != address(0), "Inventory: non-existing NFT");
698         return owner;
699     }
700 
701     /**
702      * @dev See {IERC1155Inventory-totalSupply}.
703      */
704     function totalSupply(uint256 id) public virtual override view returns (uint256) {
705         if (isNFT(id)) {
706             return address(_owners[id]) == address(0) ? 0 : 1;
707         } else {
708             return _supplies[id];
709         }
710     }
711 
712     //================================== ERC1155Inventory Non-standard helpers =======================================/
713 
714     /**
715      * @dev Introspects whether an identifier represents an non-fungible token.
716      * @param id Identifier to query.
717      * @return True if `id` represents an non-fungible token.
718      */
719     function isNFT(uint256 id) public virtual pure returns (bool) {
720         return (id & _NF_BIT) != 0 && (id & _NF_TOKEN_MASK != 0);
721     }
722 
723     //================================== Inventory Internal Functions =======================================/
724 
725     /**
726      * Creates a collection (optional).
727      * @dev Reverts if `collectionId` does not represent a collection.
728      * @dev Reverts if `collectionId` has already been created.
729      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
730      * @param collectionId Identifier of the collection.
731      */
732     function _createCollection(uint256 collectionId) internal virtual {
733         require(!isNFT(collectionId), "Inventory: not a collection");
734         require(_creators[collectionId] == address(0), "Inventory: existing collection");
735         _creators[collectionId] = _msgSender();
736         emit CollectionCreated(collectionId, isFungible(collectionId));
737     }
738 
739     /**
740      * @dev (abstract) Returns an URI for a given identifier.
741      * @param id Identifier to query the URI of.
742      * @return The metadata URI for `id`.
743      */
744     function _uri(uint256 id) internal virtual view returns (string memory);
745 
746     /**
747      * Returns whether `sender` is authorised to make a transfer on behalf of `from`.
748      * @param from The address to check operatibility upon.
749      * @param sender The sender address.
750      * @return True if sender is `from` or an operator for `from`, false otherwise.
751      */
752     function _isOperatable(address from, address sender) internal virtual view returns (bool) {
753         return (from == sender) || _operators[from][sender];
754     }
755 
756     //================================== Token Receiver Calls Internal =======================================/
757 
758     /**
759      * Calls {IERC1155TokenReceiver-onERC1155Received} on a target contract.
760      * @dev Reverts if `to` is not a contract.
761      * @dev Reverts if the call to the target fails or is refused.
762      * @param from Previous token owner.
763      * @param to New token owner.
764      * @param id Identifier of the token transferred.
765      * @param value Amount of token transferred.
766      * @param data Optional data to send along with the receiver contract call.
767      */
768     function _callOnERC1155Received(
769         address from,
770         address to,
771         uint256 id,
772         uint256 value,
773         bytes memory data
774     ) internal {
775         require(
776             IERC1155TokenReceiver(to).onERC1155Received(_msgSender(), from, id, value, data) == _ERC1155_RECEIVED,
777             "Inventory: transfer refused"
778         );
779     }
780 
781     /**
782      * Calls {IERC1155TokenReceiver-onERC1155batchReceived} on a target contract.
783      * @dev Reverts if `to` is not a contract.
784      * @dev Reverts if the call to the target fails or is refused.
785      * @param from Previous tokens owner.
786      * @param to New tokens owner.
787      * @param ids Identifiers of the tokens to transfer.
788      * @param values Amounts of tokens to transfer.
789      * @param data Optional data to send along with the receiver contract call.
790      */
791     function _callOnERC1155BatchReceived(
792         address from,
793         address to,
794         uint256[] memory ids,
795         uint256[] memory values,
796         bytes memory data
797     ) internal {
798         require(
799             IERC1155TokenReceiver(to).onERC1155BatchReceived(_msgSender(), from, ids, values, data) ==
800                 _ERC1155_BATCH_RECEIVED,
801             "Inventory: transfer refused"
802         );
803     }
804 }
805 
806 
807 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155Inventory.sol@v6.0.0
808 
809 pragma solidity 0.6.8;
810 
811 
812 /**
813  * @title ERC1155Inventory, a contract which manages up to multiple Collections of Fungible and Non-Fungible Tokens
814  * @dev In this implementation, with N representing the Non-Fungible Collection mask length, identifiers can represent either:
815  * (a) a Fungible Token:
816  *     - most significant bit == 0
817  * (b) a Non-Fungible Collection:
818  *     - most significant bit == 1
819  *     - (256-N) least significant bits == 0
820  * (c) a Non-Fungible Token:
821  *     - most significant bit == 1
822  *     - (256-N) least significant bits != 0
823  * with N = 32.
824  *
825  */
826 abstract contract ERC1155Inventory is ERC1155InventoryBase {
827     using Address for address;
828 
829     //================================== ERC1155 =======================================/
830 
831     /**
832      * @dev See {IERC1155-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 id,
838         uint256 value,
839         bytes memory data
840     ) public virtual override {
841         _safeTransferFrom(from, to, id, value, data);
842     }
843 
844     /**
845      * @dev See {IERC1155-safeBatchTransferFrom}.
846      */
847     function safeBatchTransferFrom(
848         address from,
849         address to,
850         uint256[] memory ids,
851         uint256[] memory values,
852         bytes memory data
853     ) public virtual override {
854         _safeBatchTransferFrom(from, to, ids, values, data);
855     }
856 
857     //============================== Minting Core Internal Helpers =================================/
858 
859     function _mintFungible(
860         address to,
861         uint256 id,
862         uint256 value
863     ) internal {
864         require(value != 0, "Inventory: zero value");
865         uint256 supply = _supplies[id];
866         uint256 newSupply = supply + value;
867         require(newSupply > supply, "Inventory: supply overflow");
868         _supplies[id] = newSupply;
869         // cannot overflow as any balance is bounded up by the supply which cannot overflow
870         _balances[id][to] += value;
871     }
872 
873     function _mintNFT(
874         address to,
875         uint256 id,
876         uint256 value,
877         bool isBatch
878     ) internal {
879         require(value == 1, "Inventory: wrong NFT value");
880         require(_owners[id] == 0, "Inventory: existing/burnt NFT");
881 
882         _owners[id] = uint256(to);
883 
884         if (!isBatch) {
885             uint256 collectionId = id & _NF_COLLECTION_MASK;
886             // it is virtually impossible that a non-fungible collection supply
887             // overflows due to the cost of minting individual tokens
888             ++_supplies[collectionId];
889             // cannot overflow as supply cannot overflow
890             ++_balances[collectionId][to];
891         }
892     }
893 
894     //============================== Minting Internal Functions ====================================/
895 
896     /**
897      * Mints some token.
898      * @dev Reverts if `isBatch` is false and `to` is the zero address.
899      * @dev Reverts if `id` represents a non-fungible collection.
900      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
901      * @dev Reverts if `id` represents a non-fungible token which is owned by a non-zero address.
902      * @dev Reverts if `id` represents afungible token and `value` is 0.
903      * @dev Reverts if `id` represents afungible token and there is an overflow of supply.
904      * @dev Reverts if `isBatch` is false, `safe` is true and the call to the receiver contract fails or is refused.
905      * @dev Emits an {IERC1155-TransferSingle} event if `isBatch` is false.
906      * @param to Address of the new token owner.
907      * @param id Identifier of the token to mint.
908      * @param value Amount of token to mint.
909      * @param data Optional data to send along to a receiver contract.
910      */
911     function _safeMint(
912         address to,
913         uint256 id,
914         uint256 value,
915         bytes memory data
916     ) internal {
917         require(to != address(0), "Inventory: transfer to zero");
918 
919         if (isFungible(id)) {
920             _mintFungible(to, id, value);
921         } else if (id & _NF_TOKEN_MASK != 0) {
922             _mintNFT(to, id, value, false);
923         } else {
924             revert("Inventory: not a token id");
925         }
926 
927         emit TransferSingle(_msgSender(), address(0), to, id, value);
928         if (to.isContract()) {
929             _callOnERC1155Received(address(0), to, id, value, data);
930         }
931     }
932 
933     /**
934      * Mints a batch of tokens.
935      * @dev Reverts if `ids` and `values` have different lengths.
936      * @dev Reverts if `to` is the zero address.
937      * @dev Reverts if one of `ids` represents a non-fungible collection.
938      * @dev Reverts if one of `ids` represents a non-fungible token and its paired value is not 1.
939      * @dev Reverts if one of `ids` represents a non-fungible token which is owned by a non-zero address.
940      * @dev Reverts if one of `ids` represents afungible token and its paired value is 0.
941      * @dev Reverts if one of `ids` represents afungible token and there is an overflow of supply.
942      * @dev Reverts if `safe` is true and the call to the receiver contract fails or is refused.
943      * @dev Emits an {IERC1155-TransferBatch} event.
944      * @param to Address of the new tokens owner.
945      * @param ids Identifiers of the tokens to mint.
946      * @param values Amounts of tokens to mint.
947      * @param data Optional data to send along to a receiver contract.
948      */
949     function _safeBatchMint(
950         address to,
951         uint256[] memory ids,
952         uint256[] memory values,
953         bytes memory data
954     ) internal virtual {
955         require(to != address(0), "Inventory: transfer to zero");
956         uint256 length = ids.length;
957         require(length == values.length, "Inventory: inconsistent arrays");
958 
959         uint256 nfCollectionId;
960         uint256 nfCollectionCount;
961         for (uint256 i; i < length; i++) {
962             uint256 id = ids[i];
963             uint256 value = values[i];
964             if (isFungible(id)) {
965                 _mintFungible(to, id, value); 
966             } else if (id & _NF_TOKEN_MASK != 0) {
967                 _mintNFT(to, id, value, true);
968                 uint256 nextCollectionId = id & _NF_COLLECTION_MASK;
969                 if (nfCollectionId == 0) {
970                     nfCollectionId = nextCollectionId;
971                     nfCollectionCount = 1;
972                 } else {
973                     if (nextCollectionId != nfCollectionId) {
974                         _balances[nfCollectionId][to] += nfCollectionCount;
975                         _supplies[nfCollectionId] += nfCollectionCount;
976                         nfCollectionId = nextCollectionId;
977                         nfCollectionCount = 1;
978                     } else {
979                         nfCollectionCount++;
980                     }
981                 }
982             } else {
983                 revert("Inventory: not a token id");
984             }
985         }
986 
987         if (nfCollectionId != 0) {
988             _balances[nfCollectionId][to] += nfCollectionCount;
989             _supplies[nfCollectionId] += nfCollectionCount;
990         }
991 
992         emit TransferBatch(_msgSender(), address(0), to, ids, values);
993         if (to.isContract()) {
994             _callOnERC1155BatchReceived(address(0), to, ids, values, data);
995         }
996     }
997 
998     //============================== Transfer Core Internal Helpers =================================/
999 
1000     function _transferFungible(
1001         address from,
1002         address to,
1003         uint256 id,
1004         uint256 value
1005     ) internal {
1006         require(value != 0, "Inventory: zero value");
1007         uint256 balance = _balances[id][from];
1008         require(balance >= value, "Inventory: not enough balance");
1009         _balances[id][from] = balance - value;
1010         // cannot overflow as supply cannot overflow
1011         _balances[id][to] += value;
1012     }
1013 
1014     function _transferNFT(
1015         address from,
1016         address to,
1017         uint256 id,
1018         uint256 value,
1019         bool isBatch
1020     ) internal {
1021         require(value == 1, "Inventory: wrong NFT value");
1022         require(from == address(_owners[id]), "Inventory: non-owned NFT");
1023         _owners[id] = uint256(to);
1024         if (!isBatch) {
1025             uint256 collectionId = id & _NF_COLLECTION_MASK;
1026             // cannot underflow as balance is verified through ownership
1027             _balances[collectionId][from] -= 1;
1028             // cannot overflow as supply cannot overflow
1029             _balances[collectionId][to] += 1;
1030         }
1031     }
1032 
1033     //============================== Transfer Internal Functions =======================================/
1034 
1035     /**
1036      * Transfers tokens to another address.
1037      * @dev Reverts if `isBatch` is false and `to` is the zero address.
1038      * @dev Reverts if `isBatch` is false the sender is not approved.
1039      * @dev Reverts if `id` represents a non-fungible collection.
1040      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1041      * @dev Reverts if `id` represents a non-fungible token and is not owned by `from`.
1042      * @dev Reverts if `id` represents afungible token and `value` is 0.
1043      * @dev Reverts if `id` represents afungible token and `from` doesn't have enough balance.
1044      * @dev Emits an {IERC1155-TransferSingle} event.
1045      * @param from Current token owner.
1046      * @param to Address of the new token owner.
1047      * @param id Identifier of the token to transfer.
1048      * @param value Amount of token to transfer.
1049      * @param data Optional data to pass to the receiver contract.
1050      */
1051     function _safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 id,
1055         uint256 value,
1056         bytes memory data
1057     ) internal {
1058         address sender = _msgSender();
1059         require(to != address(0), "Inventory: transfer to zero");
1060         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1061 
1062         if (isFungible(id)) {
1063             _transferFungible(from, to, id, value);
1064         } else if (id & _NF_TOKEN_MASK != 0) {
1065             _transferNFT(from, to, id, value, false);
1066         } else {
1067             revert("Inventory: not a token id");
1068         }
1069 
1070         emit TransferSingle(sender, from, to, id, value);
1071         if (to.isContract()) {
1072             _callOnERC1155Received(from, to, id, value, data);
1073         }
1074     }
1075 
1076     /**
1077      * Transfers multiple tokens to another address
1078      * @dev Reverts if `ids` and `values` have inconsistent lengths.
1079      * @dev Reverts if `to` is the zero address.
1080      * @dev Reverts if the sender is not approved.
1081      * @dev Reverts if one of `ids` does not represent a token.
1082      * @dev Reverts if one of `ids` represents a non-fungible token and `value` is not 1.
1083      * @dev Reverts if one of `ids` represents a non-fungible token and is not owned by `from`.
1084      * @dev Reverts if one of `ids` represents afungible token and `value` is 0.
1085      * @dev Reverts if one of `ids` represents afungible token and `from` doesn't have enough balance.
1086      * @dev Emits an {IERC1155-TransferBatch} event.
1087      * @param from Current token owner.
1088      * @param to Address of the new token owner.
1089      * @param ids Identifiers of the tokens to transfer.
1090      * @param values Amounts of tokens to transfer.
1091      * @param data Optional data to pass to the receiver contract.
1092      */
1093     function _safeBatchTransferFrom(
1094         address from,
1095         address to,
1096         uint256[] memory ids,
1097         uint256[] memory values,
1098         bytes memory data
1099     ) internal virtual {
1100         require(to != address(0), "Inventory: transfer to zero");
1101         uint256 length = ids.length;
1102         require(length == values.length, "Inventory: inconsistent arrays");
1103         address sender = _msgSender();
1104         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1105 
1106         uint256 nfCollectionId;
1107         uint256 nfCollectionCount;
1108         for (uint256 i; i < length; i++) {
1109             uint256 id = ids[i];
1110             uint256 value = values[i];
1111             if (isFungible(id)) {
1112                 _transferFungible(from, to, id, value); 
1113             } else if (id & _NF_TOKEN_MASK != 0) {
1114                 _transferNFT(from, to, id, value, true);
1115                 uint256 nextCollectionId = id & _NF_COLLECTION_MASK;
1116                 if (nfCollectionId == 0) {
1117                     nfCollectionId = nextCollectionId;
1118                     nfCollectionCount = 1;
1119                 } else {
1120                     if (nextCollectionId != nfCollectionId) {
1121                         _balances[nfCollectionId][from] -= nfCollectionCount;
1122                         _balances[nfCollectionId][to] += nfCollectionCount;
1123                         nfCollectionId = nextCollectionId;
1124                         nfCollectionCount = 1;
1125                     } else {
1126                         nfCollectionCount++;
1127                     }
1128                 }
1129             } else {
1130                 revert("Inventory: not a token id");
1131             }
1132         }
1133 
1134         if (nfCollectionId != 0) {
1135             _balances[nfCollectionId][from] -= nfCollectionCount;
1136             _balances[nfCollectionId][to] += nfCollectionCount;
1137         }
1138 
1139         emit TransferBatch(sender, from, to, ids, values);
1140         if (to.isContract()) {
1141             _callOnERC1155BatchReceived(from, to, ids, values, data);
1142         }
1143     }
1144 
1145     //============================== Burning Core Internal Helpers =================================/
1146 
1147     function _burnFungible(
1148         address from,
1149         uint256 id,
1150         uint256 value
1151     ) internal {
1152         require(value != 0, "Inventory: zero value");
1153         uint256 balance = _balances[id][from];
1154         require(balance >= value, "Inventory: not enough balance");
1155         _balances[id][from] = balance - value;
1156         // Cannot underflow
1157         _supplies[id] -= value;
1158     }
1159 
1160     function _burnNFT(
1161         address from,
1162         uint256 id,
1163         uint256 value,
1164         bool isBatch
1165     ) internal {
1166         require(value == 1, "Inventory: wrong NFT value");
1167         require(from == address(_owners[id]), "Inventory: non-owned NFT");
1168         _owners[id] = _BURNT_NFT_OWNER;
1169 
1170         if (!isBatch) {
1171             uint256 collectionId = id & _NF_COLLECTION_MASK;
1172             // cannot underflow as balance is confirmed through ownership
1173             --_balances[collectionId][from];
1174             // Cannot underflow
1175             --_supplies[collectionId];
1176         }
1177     }
1178 
1179     //================================ Burning Internal Functions ======================================/
1180 
1181     /**
1182      * Burns some token.
1183      * @dev Reverts if `isBatch` is false and the sender is not approved.
1184      * @dev Reverts if `id` represents a non-fungible collection.
1185      * @dev Reverts if `id` represents afungible token and `value` is 0.
1186      * @dev Reverts if `id` represents afungible token and `value` is higher than `from`'s balance.
1187      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1188      * @dev Reverts if `id` represents a non-fungible token which is not owned by `from`.
1189      * @dev Emits an {IERC1155-TransferSingle} event if `isBatch` is false.
1190      * @param from Address of the current token owner.
1191      * @param id Identifier of the token to burn.
1192      * @param value Amount of token to burn.
1193      */
1194     function _burnFrom(
1195         address from,
1196         uint256 id,
1197         uint256 value
1198     ) internal {
1199         address sender = _msgSender();
1200         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1201 
1202         if (isFungible(id)) {
1203             _burnFungible(from, id, value);
1204         } else if (id & _NF_TOKEN_MASK != 0) {
1205             _burnNFT(from, id, value, false);
1206         } else {
1207             revert("Inventory: not a token id");
1208         }
1209 
1210         emit TransferSingle(sender, from, address(0), id, value);
1211     }
1212 
1213     /**
1214      * Burns multiple tokens.
1215      * @dev Reverts if `ids` and `values` have different lengths.
1216      * @dev Reverts if the sender is not approved.
1217      * @dev Reverts if one of `ids` represents a non-fungible collection.
1218      * @dev Reverts if one of `ids` represents afungible token and `value` is 0.
1219      * @dev Reverts if one of `ids` represents afungible token and `value` is higher than `from`'s balance.
1220      * @dev Reverts if one of `ids` represents a non-fungible token and `value` is not 1.
1221      * @dev Reverts if one of `ids` represents a non-fungible token which is not owned by `from`.
1222      * @dev Emits an {IERC1155-TransferBatch} event.
1223      * @param from Address of the current tokens owner.
1224      * @param ids Identifiers of the tokens to burn.
1225      * @param values Amounts of tokens to burn.
1226      */
1227     function _batchBurnFrom(
1228         address from,
1229         uint256[] memory ids,
1230         uint256[] memory values
1231     ) internal virtual {
1232         uint256 length = ids.length;
1233         require(length == values.length, "Inventory: inconsistent arrays");
1234 
1235         address sender = _msgSender();
1236         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1237 
1238         uint256 nfCollectionId;
1239         uint256 nfCollectionCount;
1240         for (uint256 i; i < length; i++) {
1241             uint256 id = ids[i];
1242             uint256 value = values[i];
1243             if (isFungible(id)) {
1244                 _burnFungible(from, id, value); 
1245             } else if (id & _NF_TOKEN_MASK != 0) {
1246                 _burnNFT(from, id, value, true);
1247                 uint256 nextCollectionId = id & _NF_COLLECTION_MASK;
1248                 if (nfCollectionId == 0) {
1249                     nfCollectionId = nextCollectionId;
1250                     nfCollectionCount = 1;
1251                 } else {
1252                     if (nextCollectionId != nfCollectionId) {
1253                         _balances[nfCollectionId][from] -= nfCollectionCount;
1254                         _supplies[nfCollectionId] -= nfCollectionCount;
1255                         nfCollectionId = nextCollectionId;
1256                         nfCollectionCount = 1;
1257                     } else {
1258                         nfCollectionCount++;
1259                     }
1260                 }
1261             } else {
1262                 revert("Inventory: not a token id");
1263             }
1264         }
1265 
1266         if (nfCollectionId != 0) {
1267             _balances[nfCollectionId][from] -= nfCollectionCount;
1268             _supplies[nfCollectionId] -= nfCollectionCount;
1269         }
1270 
1271         emit TransferBatch(sender, from, address(0), ids, values);
1272     }
1273 }
1274 
1275 
1276 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155InventoryMintable.sol@v6.0.0
1277 
1278 pragma solidity 0.6.8;
1279 
1280 /**
1281  * @title ERC-1155 Inventory, additional minting interface
1282  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1283  */
1284 interface IERC1155InventoryMintable {
1285     /**
1286      * Safely mints some token.
1287      * @dev Reverts if `to` is the zero address.
1288      * @dev Reverts if `id` is not a token.
1289      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1290      * @dev Reverts if `id` represents a non-fungible token which has already been minted.
1291      * @dev Reverts if `id` represents a fungible token and `value` is 0.
1292      * @dev Reverts if `id` represents a fungible token and there is an overflow of supply.
1293      * @dev Reverts if `id` represents a fungible token and there is an overflow of supply.
1294      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155Received} fails or is refused.
1295      * @dev Emits an {IERC1155-TransferSingle} event.
1296      * @param to Address of the new token owner.
1297      * @param id Identifier of the token to mint.
1298      * @param value Amount of token to mint.
1299      * @param data Optional data to send along to a receiver contract.
1300      */
1301     function safeMint(address to, uint256 id, uint256 value, bytes calldata data) external;
1302 
1303     /**
1304      * Safely mints a batch of tokens.
1305      * @dev Reverts if `ids` and `values` have different lengths.
1306      * @dev Reverts if `to` is the zero address.
1307      * @dev Reverts if one of `ids` is not a token.
1308      * @dev Reverts if one of `ids` represents a non-fungible token and its paired value is not 1.
1309      * @dev Reverts if one of `ids` represents a non-fungible token which has already been minted.
1310      * @dev Reverts if one of `ids` represents a fungible token and its paired value is 0.
1311      * @dev Reverts if one of `ids` represents a fungible token and there is an overflow of supply.
1312      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
1313      * @dev Emits an {IERC1155-TransferBatch} event.
1314      * @param to Address of the new tokens owner.
1315      * @param ids Identifiers of the tokens to mint.
1316      * @param values Amounts of tokens to mint.
1317      * @param data Optional data to send along to a receiver contract.
1318      */
1319     function safeBatchMint(address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external;
1320 }
1321 
1322 
1323 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155InventoryBurnable.sol@v6.0.0
1324 
1325 pragma solidity 0.6.8;
1326 
1327 /**
1328  * @title ERC-1155 Inventory additional burning interface
1329  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1330  */
1331 interface IERC1155InventoryBurnable {
1332     /**
1333      * Burns some token.
1334      * @dev Reverts if the sender is not approved.
1335      * @dev Reverts if `id` does not represent a token.
1336      * @dev Reverts if `id` represents a fungible token and `value` is 0.
1337      * @dev Reverts if `id` represents a fungible token and `value` is higher than `from`'s balance.
1338      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1339      * @dev Reverts if `id` represents a non-fungible token which is not owned by `from`.
1340      * @dev Emits an {IERC1155-TransferSingle} event.
1341      * @param from Address of the current token owner.
1342      * @param id Identifier of the token to burn.
1343      * @param value Amount of token to burn.
1344      */
1345     function burnFrom(address from, uint256 id, uint256 value) external;
1346 
1347     /**
1348      * Burns multiple tokens.
1349      * @dev Reverts if `ids` and `values` have different lengths.
1350      * @dev Reverts if the sender is not approved.
1351      * @dev Reverts if one of `ids` does not represent a token.
1352      * @dev Reverts if one of `ids` represents a fungible token and `value` is 0.
1353      * @dev Reverts if one of `ids` represents a fungible token and `value` is higher than `from`'s balance.
1354      * @dev Reverts if one of `ids` represents a non-fungible token and `value` is not 1.
1355      * @dev Reverts if one of `ids` represents a non-fungible token which is not owned by `from`.
1356      * @dev Emits an {IERC1155-TransferBatch} event.
1357      * @param from Address of the current tokens owner.
1358      * @param ids Identifiers of the tokens to burn.
1359      * @param values Amounts of tokens to burn.
1360      */
1361     function batchBurnFrom(address from, uint256[] calldata ids, uint256[] calldata values) external;
1362 }
1363 
1364 
1365 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155InventoryCreator.sol@v6.0.0
1366 
1367 pragma solidity 0.6.8;
1368 
1369 /**
1370  * @title ERC-1155 Inventory, additional creator interface
1371  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1372  */
1373 interface IERC1155InventoryCreator {
1374     /**
1375      * Returns the creator of a collection, or the zero address if the collection has not been created.
1376      * @dev Reverts if `collectionId` does not represent a collection.
1377      * @param collectionId Identifier of the collection.
1378      * @return The creator of a collection, or the zero address if the collection has not been created.
1379      */
1380     function creator(uint256 collectionId) external view returns (address);
1381 }
1382 
1383 
1384 // File @openzeppelin/contracts/access/Ownable.sol@v3.2.0
1385 
1386 pragma solidity ^0.6.0;
1387 
1388 /**
1389  * @dev Contract module which provides a basic access control mechanism, where
1390  * there is an account (an owner) that can be granted exclusive access to
1391  * specific functions.
1392  *
1393  * By default, the owner account will be the one that deploys the contract. This
1394  * can later be changed with {transferOwnership}.
1395  *
1396  * This module is used through inheritance. It will make available the modifier
1397  * `onlyOwner`, which can be applied to your functions to restrict their use to
1398  * the owner.
1399  */
1400 contract Ownable is Context {
1401     address private _owner;
1402 
1403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1404 
1405     /**
1406      * @dev Initializes the contract setting the deployer as the initial owner.
1407      */
1408     constructor () internal {
1409         address msgSender = _msgSender();
1410         _owner = msgSender;
1411         emit OwnershipTransferred(address(0), msgSender);
1412     }
1413 
1414     /**
1415      * @dev Returns the address of the current owner.
1416      */
1417     function owner() public view returns (address) {
1418         return _owner;
1419     }
1420 
1421     /**
1422      * @dev Throws if called by any account other than the owner.
1423      */
1424     modifier onlyOwner() {
1425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1426         _;
1427     }
1428 
1429     /**
1430      * @dev Leaves the contract without owner. It will not be possible to call
1431      * `onlyOwner` functions anymore. Can only be called by the current owner.
1432      *
1433      * NOTE: Renouncing ownership will leave the contract without an owner,
1434      * thereby removing any functionality that is only available to the owner.
1435      */
1436     function renounceOwnership() public virtual onlyOwner {
1437         emit OwnershipTransferred(_owner, address(0));
1438         _owner = address(0);
1439     }
1440 
1441     /**
1442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1443      * Can only be called by the current owner.
1444      */
1445     function transferOwnership(address newOwner) public virtual onlyOwner {
1446         require(newOwner != address(0), "Ownable: new owner is the zero address");
1447         emit OwnershipTransferred(_owner, newOwner);
1448         _owner = newOwner;
1449     }
1450 }
1451 
1452 
1453 // File @animoca/ethereum-contracts-core_library/contracts/utils/types/UInt256ToDecimalString.sol@v3.1.1
1454 
1455 pragma solidity 0.6.8;
1456 
1457 library UInt256ToDecimalString {
1458 
1459     function toDecimalString(uint256 value) internal pure returns (string memory) {
1460         // Inspired by OpenZeppelin's String.toString() implementation - MIT licence
1461         // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/8b10cb38d8fedf34f2d89b0ed604f2dceb76d6a9/contracts/utils/Strings.sol
1462         if (value == 0) {
1463             return "0";
1464         }
1465         uint256 temp = value;
1466         uint256 digits;
1467         while (temp != 0) {
1468             digits++;
1469             temp /= 10;
1470         }
1471         bytes memory buffer = new bytes(digits);
1472         uint256 index = digits - 1;
1473         temp = value;
1474         while (temp != 0) {
1475             buffer[index--] = byte(uint8(48 + temp % 10));
1476             temp /= 10;
1477         }
1478         return string(buffer);
1479     }
1480 }
1481 
1482 
1483 // File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/BaseMetadataURI.sol@v6.0.0
1484 
1485 pragma solidity 0.6.8;
1486 
1487 
1488 contract BaseMetadataURI is Ownable {
1489     using UInt256ToDecimalString for uint256;
1490 
1491     event BaseMetadataURISet(string baseMetadataURI);
1492 
1493     string public baseMetadataURI;
1494 
1495     function setBaseMetadataURI(string calldata baseMetadataURI_) external onlyOwner {
1496         baseMetadataURI = baseMetadataURI_;
1497         emit BaseMetadataURISet(baseMetadataURI_);
1498     }
1499 
1500     function _uri(uint256 id) internal view virtual returns (string memory) {
1501         return string(abi.encodePacked(baseMetadataURI, id.toDecimalString()));
1502     }
1503 }
1504 
1505 
1506 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.2.0
1507 
1508 pragma solidity ^0.6.0;
1509 
1510 /**
1511  * @dev Library for managing
1512  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1513  * types.
1514  *
1515  * Sets have the following properties:
1516  *
1517  * - Elements are added, removed, and checked for existence in constant time
1518  * (O(1)).
1519  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1520  *
1521  * ```
1522  * contract Example {
1523  *     // Add the library methods
1524  *     using EnumerableSet for EnumerableSet.AddressSet;
1525  *
1526  *     // Declare a set state variable
1527  *     EnumerableSet.AddressSet private mySet;
1528  * }
1529  * ```
1530  *
1531  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1532  * (`UintSet`) are supported.
1533  */
1534 library EnumerableSet {
1535     // To implement this library for multiple types with as little code
1536     // repetition as possible, we write it in terms of a generic Set type with
1537     // bytes32 values.
1538     // The Set implementation uses private functions, and user-facing
1539     // implementations (such as AddressSet) are just wrappers around the
1540     // underlying Set.
1541     // This means that we can only create new EnumerableSets for types that fit
1542     // in bytes32.
1543 
1544     struct Set {
1545         // Storage of set values
1546         bytes32[] _values;
1547 
1548         // Position of the value in the `values` array, plus 1 because index 0
1549         // means a value is not in the set.
1550         mapping (bytes32 => uint256) _indexes;
1551     }
1552 
1553     /**
1554      * @dev Add a value to a set. O(1).
1555      *
1556      * Returns true if the value was added to the set, that is if it was not
1557      * already present.
1558      */
1559     function _add(Set storage set, bytes32 value) private returns (bool) {
1560         if (!_contains(set, value)) {
1561             set._values.push(value);
1562             // The value is stored at length-1, but we add 1 to all indexes
1563             // and use 0 as a sentinel value
1564             set._indexes[value] = set._values.length;
1565             return true;
1566         } else {
1567             return false;
1568         }
1569     }
1570 
1571     /**
1572      * @dev Removes a value from a set. O(1).
1573      *
1574      * Returns true if the value was removed from the set, that is if it was
1575      * present.
1576      */
1577     function _remove(Set storage set, bytes32 value) private returns (bool) {
1578         // We read and store the value's index to prevent multiple reads from the same storage slot
1579         uint256 valueIndex = set._indexes[value];
1580 
1581         if (valueIndex != 0) { // Equivalent to contains(set, value)
1582             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1583             // the array, and then remove the last element (sometimes called as 'swap and pop').
1584             // This modifies the order of the array, as noted in {at}.
1585 
1586             uint256 toDeleteIndex = valueIndex - 1;
1587             uint256 lastIndex = set._values.length - 1;
1588 
1589             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1590             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1591 
1592             bytes32 lastvalue = set._values[lastIndex];
1593 
1594             // Move the last value to the index where the value to delete is
1595             set._values[toDeleteIndex] = lastvalue;
1596             // Update the index for the moved value
1597             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1598 
1599             // Delete the slot where the moved value was stored
1600             set._values.pop();
1601 
1602             // Delete the index for the deleted slot
1603             delete set._indexes[value];
1604 
1605             return true;
1606         } else {
1607             return false;
1608         }
1609     }
1610 
1611     /**
1612      * @dev Returns true if the value is in the set. O(1).
1613      */
1614     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1615         return set._indexes[value] != 0;
1616     }
1617 
1618     /**
1619      * @dev Returns the number of values on the set. O(1).
1620      */
1621     function _length(Set storage set) private view returns (uint256) {
1622         return set._values.length;
1623     }
1624 
1625    /**
1626     * @dev Returns the value stored at position `index` in the set. O(1).
1627     *
1628     * Note that there are no guarantees on the ordering of values inside the
1629     * array, and it may change when more values are added or removed.
1630     *
1631     * Requirements:
1632     *
1633     * - `index` must be strictly less than {length}.
1634     */
1635     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1636         require(set._values.length > index, "EnumerableSet: index out of bounds");
1637         return set._values[index];
1638     }
1639 
1640     // AddressSet
1641 
1642     struct AddressSet {
1643         Set _inner;
1644     }
1645 
1646     /**
1647      * @dev Add a value to a set. O(1).
1648      *
1649      * Returns true if the value was added to the set, that is if it was not
1650      * already present.
1651      */
1652     function add(AddressSet storage set, address value) internal returns (bool) {
1653         return _add(set._inner, bytes32(uint256(value)));
1654     }
1655 
1656     /**
1657      * @dev Removes a value from a set. O(1).
1658      *
1659      * Returns true if the value was removed from the set, that is if it was
1660      * present.
1661      */
1662     function remove(AddressSet storage set, address value) internal returns (bool) {
1663         return _remove(set._inner, bytes32(uint256(value)));
1664     }
1665 
1666     /**
1667      * @dev Returns true if the value is in the set. O(1).
1668      */
1669     function contains(AddressSet storage set, address value) internal view returns (bool) {
1670         return _contains(set._inner, bytes32(uint256(value)));
1671     }
1672 
1673     /**
1674      * @dev Returns the number of values in the set. O(1).
1675      */
1676     function length(AddressSet storage set) internal view returns (uint256) {
1677         return _length(set._inner);
1678     }
1679 
1680    /**
1681     * @dev Returns the value stored at position `index` in the set. O(1).
1682     *
1683     * Note that there are no guarantees on the ordering of values inside the
1684     * array, and it may change when more values are added or removed.
1685     *
1686     * Requirements:
1687     *
1688     * - `index` must be strictly less than {length}.
1689     */
1690     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1691         return address(uint256(_at(set._inner, index)));
1692     }
1693 
1694 
1695     // UintSet
1696 
1697     struct UintSet {
1698         Set _inner;
1699     }
1700 
1701     /**
1702      * @dev Add a value to a set. O(1).
1703      *
1704      * Returns true if the value was added to the set, that is if it was not
1705      * already present.
1706      */
1707     function add(UintSet storage set, uint256 value) internal returns (bool) {
1708         return _add(set._inner, bytes32(value));
1709     }
1710 
1711     /**
1712      * @dev Removes a value from a set. O(1).
1713      *
1714      * Returns true if the value was removed from the set, that is if it was
1715      * present.
1716      */
1717     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1718         return _remove(set._inner, bytes32(value));
1719     }
1720 
1721     /**
1722      * @dev Returns true if the value is in the set. O(1).
1723      */
1724     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1725         return _contains(set._inner, bytes32(value));
1726     }
1727 
1728     /**
1729      * @dev Returns the number of values on the set. O(1).
1730      */
1731     function length(UintSet storage set) internal view returns (uint256) {
1732         return _length(set._inner);
1733     }
1734 
1735    /**
1736     * @dev Returns the value stored at position `index` in the set. O(1).
1737     *
1738     * Note that there are no guarantees on the ordering of values inside the
1739     * array, and it may change when more values are added or removed.
1740     *
1741     * Requirements:
1742     *
1743     * - `index` must be strictly less than {length}.
1744     */
1745     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1746         return uint256(_at(set._inner, index));
1747     }
1748 }
1749 
1750 
1751 // File @openzeppelin/contracts/access/AccessControl.sol@v3.2.0
1752 
1753 pragma solidity ^0.6.0;
1754 
1755 
1756 
1757 /**
1758  * @dev Contract module that allows children to implement role-based access
1759  * control mechanisms.
1760  *
1761  * Roles are referred to by their `bytes32` identifier. These should be exposed
1762  * in the external API and be unique. The best way to achieve this is by
1763  * using `public constant` hash digests:
1764  *
1765  * ```
1766  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1767  * ```
1768  *
1769  * Roles can be used to represent a set of permissions. To restrict access to a
1770  * function call, use {hasRole}:
1771  *
1772  * ```
1773  * function foo() public {
1774  *     require(hasRole(MY_ROLE, msg.sender));
1775  *     ...
1776  * }
1777  * ```
1778  *
1779  * Roles can be granted and revoked dynamically via the {grantRole} and
1780  * {revokeRole} functions. Each role has an associated admin role, and only
1781  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1782  *
1783  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1784  * that only accounts with this role will be able to grant or revoke other
1785  * roles. More complex role relationships can be created by using
1786  * {_setRoleAdmin}.
1787  *
1788  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1789  * grant and revoke this role. Extra precautions should be taken to secure
1790  * accounts that have been granted it.
1791  */
1792 abstract contract AccessControl is Context {
1793     using EnumerableSet for EnumerableSet.AddressSet;
1794     using Address for address;
1795 
1796     struct RoleData {
1797         EnumerableSet.AddressSet members;
1798         bytes32 adminRole;
1799     }
1800 
1801     mapping (bytes32 => RoleData) private _roles;
1802 
1803     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1804 
1805     /**
1806      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1807      *
1808      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1809      * {RoleAdminChanged} not being emitted signaling this.
1810      *
1811      * _Available since v3.1._
1812      */
1813     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1814 
1815     /**
1816      * @dev Emitted when `account` is granted `role`.
1817      *
1818      * `sender` is the account that originated the contract call, an admin role
1819      * bearer except when using {_setupRole}.
1820      */
1821     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1822 
1823     /**
1824      * @dev Emitted when `account` is revoked `role`.
1825      *
1826      * `sender` is the account that originated the contract call:
1827      *   - if using `revokeRole`, it is the admin role bearer
1828      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1829      */
1830     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1831 
1832     /**
1833      * @dev Returns `true` if `account` has been granted `role`.
1834      */
1835     function hasRole(bytes32 role, address account) public view returns (bool) {
1836         return _roles[role].members.contains(account);
1837     }
1838 
1839     /**
1840      * @dev Returns the number of accounts that have `role`. Can be used
1841      * together with {getRoleMember} to enumerate all bearers of a role.
1842      */
1843     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1844         return _roles[role].members.length();
1845     }
1846 
1847     /**
1848      * @dev Returns one of the accounts that have `role`. `index` must be a
1849      * value between 0 and {getRoleMemberCount}, non-inclusive.
1850      *
1851      * Role bearers are not sorted in any particular way, and their ordering may
1852      * change at any point.
1853      *
1854      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1855      * you perform all queries on the same block. See the following
1856      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1857      * for more information.
1858      */
1859     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1860         return _roles[role].members.at(index);
1861     }
1862 
1863     /**
1864      * @dev Returns the admin role that controls `role`. See {grantRole} and
1865      * {revokeRole}.
1866      *
1867      * To change a role's admin, use {_setRoleAdmin}.
1868      */
1869     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1870         return _roles[role].adminRole;
1871     }
1872 
1873     /**
1874      * @dev Grants `role` to `account`.
1875      *
1876      * If `account` had not been already granted `role`, emits a {RoleGranted}
1877      * event.
1878      *
1879      * Requirements:
1880      *
1881      * - the caller must have ``role``'s admin role.
1882      */
1883     function grantRole(bytes32 role, address account) public virtual {
1884         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1885 
1886         _grantRole(role, account);
1887     }
1888 
1889     /**
1890      * @dev Revokes `role` from `account`.
1891      *
1892      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1893      *
1894      * Requirements:
1895      *
1896      * - the caller must have ``role``'s admin role.
1897      */
1898     function revokeRole(bytes32 role, address account) public virtual {
1899         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1900 
1901         _revokeRole(role, account);
1902     }
1903 
1904     /**
1905      * @dev Revokes `role` from the calling account.
1906      *
1907      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1908      * purpose is to provide a mechanism for accounts to lose their privileges
1909      * if they are compromised (such as when a trusted device is misplaced).
1910      *
1911      * If the calling account had been granted `role`, emits a {RoleRevoked}
1912      * event.
1913      *
1914      * Requirements:
1915      *
1916      * - the caller must be `account`.
1917      */
1918     function renounceRole(bytes32 role, address account) public virtual {
1919         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1920 
1921         _revokeRole(role, account);
1922     }
1923 
1924     /**
1925      * @dev Grants `role` to `account`.
1926      *
1927      * If `account` had not been already granted `role`, emits a {RoleGranted}
1928      * event. Note that unlike {grantRole}, this function doesn't perform any
1929      * checks on the calling account.
1930      *
1931      * [WARNING]
1932      * ====
1933      * This function should only be called from the constructor when setting
1934      * up the initial roles for the system.
1935      *
1936      * Using this function in any other way is effectively circumventing the admin
1937      * system imposed by {AccessControl}.
1938      * ====
1939      */
1940     function _setupRole(bytes32 role, address account) internal virtual {
1941         _grantRole(role, account);
1942     }
1943 
1944     /**
1945      * @dev Sets `adminRole` as ``role``'s admin role.
1946      *
1947      * Emits a {RoleAdminChanged} event.
1948      */
1949     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1950         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1951         _roles[role].adminRole = adminRole;
1952     }
1953 
1954     function _grantRole(bytes32 role, address account) private {
1955         if (_roles[role].members.add(account)) {
1956             emit RoleGranted(role, account, _msgSender());
1957         }
1958     }
1959 
1960     function _revokeRole(bytes32 role, address account) private {
1961         if (_roles[role].members.remove(account)) {
1962             emit RoleRevoked(role, account, _msgSender());
1963         }
1964     }
1965 }
1966 
1967 
1968 // File @animoca/ethereum-contracts-core_library/contracts/access/MinterRole.sol@v3.1.1
1969 
1970 pragma solidity 0.6.8;
1971 
1972 /**
1973  * Contract module which allows derived contracts access control over token
1974  * minting operations.
1975  *
1976  * This module is used through inheritance. It will make available the modifier
1977  * `onlyMinter`, which can be applied to the minting functions of your contract.
1978  * Those functions will only be accessible to accounts with the minter role
1979  * once the modifer is put in place.
1980  */
1981 contract MinterRole is AccessControl {
1982 
1983     event MinterAdded(address indexed account);
1984     event MinterRemoved(address indexed account);
1985 
1986     /**
1987      * Modifier to make a function callable only by accounts with the minter role.
1988      */
1989     modifier onlyMinter() {
1990         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1991         _;
1992     }
1993 
1994     /**
1995      * Constructor.
1996      */
1997     constructor () internal {
1998         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1999         emit MinterAdded(_msgSender());
2000     }
2001 
2002     /**
2003      * Validates whether or not the given account has been granted the minter role.
2004      * @param account The account to validate.
2005      * @return True if the account has been granted the minter role, false otherwise.
2006      */
2007     function isMinter(address account) public view returns (bool) {
2008         require(account != address(0), "MinterRole: address zero cannot be minter");
2009         return hasRole(DEFAULT_ADMIN_ROLE, account);
2010     }
2011 
2012     /**
2013      * Grants the minter role to a non-minter.
2014      * @param account The account to grant the minter role to.
2015      */
2016     function addMinter(address account) public onlyMinter {
2017         require(!isMinter(account), "MinterRole: add an account already minter");
2018         grantRole(DEFAULT_ADMIN_ROLE, account);
2019         emit MinterAdded(account);
2020     }
2021 
2022     /**
2023      * Renounces the granted minter role.
2024      */
2025     function renounceMinter() public onlyMinter {
2026         renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
2027         emit MinterRemoved(_msgSender());
2028     }
2029 
2030 }
2031 
2032 
2033 // File contracts/solc-0.6/token/ERC1155/GameeVouchers.sol
2034 
2035 pragma solidity ^0.6.8;
2036 
2037 
2038 
2039 
2040 
2041 
2042 contract GameeVouchers is ERC1155Inventory, IERC1155InventoryMintable, IERC1155InventoryBurnable, IERC1155InventoryCreator, BaseMetadataURI, MinterRole {
2043     // solhint-disable-next-line const-name-snakecase
2044     string public constant name = "GameeVouchers";
2045     // solhint-disable-next-line const-name-snakecase
2046     string public constant symbol = "GameeVouchers";
2047 
2048     // ===================================================================================================
2049     //                               Admin Public Functions
2050     // ===================================================================================================
2051 
2052     /**
2053      * Creates a collection.
2054      * @dev Reverts if `collectionId` does not represent a collection.
2055      * @dev Reverts if `collectionId` has already been created.
2056      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
2057      * @param collectionId Identifier of the collection.
2058      */
2059     function createCollection(uint256 collectionId) external onlyOwner {
2060         require(isFungible(collectionId), "GameeVouchers: only fungibles");
2061         _createCollection(collectionId);
2062     }
2063 
2064     /**
2065      * @dev See {IERC1155InventoryMintable-safeMint(address,uint256,uint256,bytes)}.
2066      */
2067     function safeMint(
2068         address to,
2069         uint256 id,
2070         uint256 value,
2071         bytes calldata data
2072     ) external override onlyMinter {
2073         require(isFungible(id), "GameeVouchers: only fungibles");
2074         _safeMint(to, id, value, data);
2075     }
2076 
2077     /**
2078      * @dev See {IERC1155721InventoryMintable-safeBatchMint(address,uint256[],uint256[],bytes)}.
2079      */
2080     function safeBatchMint(
2081         address to,
2082         uint256[] calldata ids,
2083         uint256[] calldata values,
2084         bytes calldata data
2085     ) external override onlyMinter {
2086         _safeBatchMint(to, ids, values, data);
2087         for (uint256 i; i!= ids.length; ++i) {
2088             require(isFungible(ids[i]), "GameeVouchers: only fungibles");
2089         }
2090     }
2091 
2092     // ===================================================================================================
2093     //                                 User Public Functions
2094     // ===================================================================================================
2095 
2096     /**
2097      * @dev See {IERC1155InventoryCreator-creator(uint256)}.
2098      */
2099     function creator(uint256 collectionId) external override view returns(address) {
2100         require(!isNFT(collectionId), "Inventory: not a collection");
2101         return _creators[collectionId];
2102     }
2103 
2104     /**
2105      * @dev See {IERC1155InventoryBurnable-burnFrom(address,uint256,uint256)}.
2106      */
2107     function burnFrom(
2108         address from,
2109         uint256 id,
2110         uint256 value
2111     ) external override {
2112         _burnFrom(from, id, value);
2113     }
2114 
2115     /**
2116      * @dev See {IERC1155InventoryBurnable-batchBurnFrom(address,uint256[],uint256[])}.
2117      */
2118     function batchBurnFrom(
2119         address from,
2120         uint256[] calldata ids,
2121         uint256[] calldata values
2122     ) external override {
2123         _batchBurnFrom(from, ids, values);
2124     }
2125 
2126     // ===================================================================================================
2127     //                                  ERC1155 Internal Functions
2128     // ===================================================================================================
2129 
2130     function _uri(uint256 id) internal override(ERC1155InventoryBase, BaseMetadataURI) view returns (string memory) {
2131         return BaseMetadataURI._uri(id);
2132     }
2133 }