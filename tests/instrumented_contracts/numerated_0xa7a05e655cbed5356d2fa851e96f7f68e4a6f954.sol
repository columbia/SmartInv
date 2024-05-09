1 // Sources flattened with hardhat v2.0.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.2 <0.8.0;
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
31         // This method relies on extcodesize, which returns 0 for contracts in
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
94         return functionCallWithValue(target, data, 0, errorMessage);
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
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
152         if (success) {
153             return returndata;
154         } else {
155             // Look for revert reason and bubble it up if present
156             if (returndata.length > 0) {
157                 // The easiest way to bubble the revert reason is using memory via assembly
158 
159                 // solhint-disable-next-line no-inline-assembly
160                 assembly {
161                     let returndata_size := mload(returndata)
162                     revert(add(32, returndata), returndata_size)
163                 }
164             } else {
165                 revert(errorMessage);
166             }
167         }
168     }
169 }
170 
171 
172 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721.sol@v7.1.0
173 
174 pragma solidity 0.6.8;
175 
176 /**
177  * @title ERC721 Non-Fungible Token Standard, basic interface
178  * @dev See https://eips.ethereum.org/EIPS/eip-721
179  * Note: The ERC-165 identifier for this interface is 0x80ac58cd.
180  */
181 interface IERC721 {
182     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
183 
184     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
185 
186     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
187 
188     /**
189      * Gets the balance of the specified address
190      * @param owner address to query the balance of
191      * @return balance uint256 representing the amount owned by the passed address
192      */
193     function balanceOf(address owner) external view returns (uint256 balance);
194 
195     /**
196      * Gets the owner of the specified ID
197      * @param tokenId uint256 ID to query the owner of
198      * @return owner address currently marked as the owner of the given ID
199      */
200     function ownerOf(uint256 tokenId) external view returns (address owner);
201 
202     /**
203      * Approves another address to transfer the given token ID
204      * @dev The zero address indicates there is no approved address.
205      * @dev There can only be one approved address per token at a given time.
206      * @dev Can only be called by the token owner or an approved operator.
207      * @param to address to be approved for the given token ID
208      * @param tokenId uint256 ID of the token to be approved
209      */
210     function approve(address to, uint256 tokenId) external;
211 
212     /**
213      * Gets the approved address for a token ID, or zero if no address set
214      * @dev Reverts if the token ID does not exist.
215      * @param tokenId uint256 ID of the token to query the approval of
216      * @return operator address currently approved for the given token ID
217      */
218     function getApproved(uint256 tokenId) external view returns (address operator);
219 
220     /**
221      * Sets or unsets the approval of a given operator
222      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
223      * @param operator operator address to set the approval
224      * @param approved representing the status of the approval to be set
225      */
226     function setApprovalForAll(address operator, bool approved) external;
227 
228     /**
229      * Tells whether an operator is approved by a given owner
230      * @param owner owner address which you want to query the approval of
231      * @param operator operator address which you want to query the approval of
232      * @return bool whether the given operator is approved by the given owner
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 
236     /**
237      * Transfers the ownership of a given token ID to another address
238      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
239      * @dev Requires the msg sender to be the owner, approved, or operator
240      * @param from current owner of the token
241      * @param to address to receive the ownership of the given token ID
242      * @param tokenId uint256 ID of the token to be transferred
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * Safely transfers the ownership of a given token ID to another address
252      *
253      * If the target address is a contract, it must implement `onERC721Received`,
254      * which is called upon a safe transfer, and return the magic value
255      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
256      * the transfer is reverted.
257      *
258      * @dev Requires the msg sender to be the owner, approved, or operator
259      * @param from current owner of the token
260      * @param to address to receive the ownership of the given token ID
261      * @param tokenId uint256 ID of the token to be transferred
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId
267     ) external;
268 
269     /**
270      * Safely transfers the ownership of a given token ID to another address
271      *
272      * If the target address is a contract, it must implement `onERC721Received`,
273      * which is called upon a safe transfer, and return the magic value
274      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
275      * the transfer is reverted.
276      *
277      * @dev Requires the msg sender to be the owner, approved, or operator
278      * @param from current owner of the token
279      * @param to address to receive the ownership of the given token ID
280      * @param tokenId uint256 ID of the token to be transferred
281      * @param data bytes data to send along with a safe transfer check
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId,
287         bytes calldata data
288     ) external;
289 }
290 
291 
292 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Metadata.sol@v7.1.0
293 
294 pragma solidity 0.6.8;
295 
296 /**
297  * @title ERC721 Non-Fungible Token Standard, optional metadata extension
298  * @dev See https://eips.ethereum.org/EIPS/eip-721
299  * Note: The ERC-165 identifier for this interface is 0x5b5e139f.
300  */
301 interface IERC721Metadata {
302     /**
303      * @dev Gets the token name
304      * @return string representing the token name
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Gets the token symbol
310      * @return string representing the token symbol
311      */
312     function symbol() external view returns (string memory);
313 
314     /**
315      * @dev Returns an URI for a given token ID
316      * Throws if the token ID does not exist. May return an empty string.
317      * @param tokenId uint256 ID of the token to query
318      * @return string URI of given token ID
319      */
320     function tokenURI(uint256 tokenId) external view returns (string memory);
321 }
322 
323 
324 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721BatchTransfer.sol@v7.1.0
325 
326 pragma solidity 0.6.8;
327 
328 /**
329  * @title ERC721 Non-Fungible Token Standard, optional unsafe batchTransfer interface
330  * @dev See https://eips.ethereum.org/EIPS/eip-721
331  * Note: The ERC-165 identifier for this interface is.
332  */
333 interface IERC721BatchTransfer {
334     /**
335      * Unsafely transfers a batch of tokens.
336      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
337      * @dev Reverts if `to` is the zero address.
338      * @dev Reverts if the sender is not approved.
339      * @dev Reverts if one of `tokenIds` is not owned by `from`.
340      * @dev Resets the token approval for each of `tokenIds`.
341      * @dev Emits an {IERC721-Transfer} event for each of `tokenIds`.
342      * @param from Current tokens owner.
343      * @param to Address of the new token owner.
344      * @param tokenIds Identifiers of the tokens to transfer.
345      */
346     function batchTransferFrom(
347         address from,
348         address to,
349         uint256[] calldata tokenIds
350     ) external;
351 }
352 
353 
354 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Receiver.sol@v7.1.0
355 
356 pragma solidity 0.6.8;
357 
358 /**
359     @title ERC721 Non-Fungible Token Standard, token receiver
360     @dev See https://eips.ethereum.org/EIPS/eip-721
361     Interface for any contract that wants to support safeTransfers from ERC721 asset contracts.
362     Note: The ERC-165 identifier for this interface is 0x150b7a02.
363  */
364 interface IERC721Receiver {
365     /**
366         @notice Handle the receipt of an NFT
367         @dev The ERC721 smart contract calls this function on the recipient
368         after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
369         otherwise the caller will revert the transaction. The selector to be
370         returned can be obtained as `this.onERC721Received.selector`. This
371         function MAY throw to revert and reject the transfer.
372         Note: the ERC721 contract address is always the message sender.
373         @param operator The address which called `safeTransferFrom` function
374         @param from The address which previously owned the token
375         @param tokenId The NFT identifier which is being transferred
376         @param data Additional data with no specified format
377         @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
378      */
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 
388 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
389 
390 pragma solidity >=0.6.0 <0.8.0;
391 
392 /*
393  * @dev Provides information about the current execution context, including the
394  * sender of the transaction and its data. While these are generally available
395  * via msg.sender and msg.data, they should not be accessed in such a direct
396  * manner, since when dealing with GSN meta-transactions the account sending and
397  * paying for execution may not be the actual sender (as far as an application
398  * is concerned).
399  *
400  * This contract is only required for intermediate, library-like contracts.
401  */
402 abstract contract Context {
403     function _msgSender() internal view virtual returns (address payable) {
404         return msg.sender;
405     }
406 
407     function _msgData() internal view virtual returns (bytes memory) {
408         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
409         return msg.data;
410     }
411 }
412 
413 
414 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.3.0
415 
416 pragma solidity >=0.6.0 <0.8.0;
417 
418 /**
419  * @dev Interface of the ERC165 standard, as defined in the
420  * https://eips.ethereum.org/EIPS/eip-165[EIP].
421  *
422  * Implementers can declare support of contract interfaces, which can then be
423  * queried by others ({ERC165Checker}).
424  *
425  * For an implementation, see {ERC165}.
426  */
427 interface IERC165 {
428     /**
429      * @dev Returns true if this contract implements the interface defined by
430      * `interfaceId`. See the corresponding
431      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
432      * to learn more about how these ids are created.
433      *
434      * This function call must use less than 30 000 gas.
435      */
436     function supportsInterface(bytes4 interfaceId) external view returns (bool);
437 }
438 
439 
440 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155.sol@v7.1.0
441 
442 pragma solidity 0.6.8;
443 
444 /**
445  * @title ERC-1155 Multi Token Standard, basic interface
446  * @dev See https://eips.ethereum.org/EIPS/eip-1155
447  * Note: The ERC-165 identifier for this interface is 0xd9b67a26.
448  */
449 interface IERC1155 {
450     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
451 
452     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
453 
454     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
455 
456     event URI(string _value, uint256 indexed _id);
457 
458     /**
459      * Safely transfers some token.
460      * @dev Reverts if `to` is the zero address.
461      * @dev Reverts if the sender is not approved.
462      * @dev Reverts if `from` has an insufficient balance.
463      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
464      * @dev Emits a `TransferSingle` event.
465      * @param from Current token owner.
466      * @param to Address of the new token owner.
467      * @param id Identifier of the token to transfer.
468      * @param value Amount of token to transfer.
469      * @param data Optional data to send along to a receiver contract.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 id,
475         uint256 value,
476         bytes calldata data
477     ) external;
478 
479     /**
480      * Safely transfers a batch of tokens.
481      * @dev Reverts if `to` is the zero address.
482      * @dev Reverts if `ids` and `values` have different lengths.
483      * @dev Reverts if the sender is not approved.
484      * @dev Reverts if `from` has an insufficient balance for any of `ids`.
485      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
486      * @dev Emits a `TransferBatch` event.
487      * @param from Current token owner.
488      * @param to Address of the new token owner.
489      * @param ids Identifiers of the tokens to transfer.
490      * @param values Amounts of tokens to transfer.
491      * @param data Optional data to send along to a receiver contract.
492      */
493     function safeBatchTransferFrom(
494         address from,
495         address to,
496         uint256[] calldata ids,
497         uint256[] calldata values,
498         bytes calldata data
499     ) external;
500 
501     /**
502      * Retrieves the balance of `id` owned by account `owner`.
503      * @param owner The account to retrieve the balance of.
504      * @param id The identifier to retrieve the balance of.
505      * @return The balance of `id` owned by account `owner`.
506      */
507     function balanceOf(address owner, uint256 id) external view returns (uint256);
508 
509     /**
510      * Retrieves the balances of `ids` owned by accounts `owners`. For each pair:
511      * @dev Reverts if `owners` and `ids` have different lengths.
512      * @param owners The addresses of the token holders
513      * @param ids The identifiers to retrieve the balance of.
514      * @return The balances of `ids` owned by accounts `owners`.
515      */
516     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);
517 
518     /**
519      * Enables or disables an operator's approval.
520      * @dev Emits an `ApprovalForAll` event.
521      * @param operator Address of the operator.
522      * @param approved True to approve the operator, false to revoke an approval.
523      */
524     function setApprovalForAll(address operator, bool approved) external;
525 
526     /**
527      * Retrieves the approval status of an operator for a given owner.
528      * @param owner Address of the authorisation giver.
529      * @param operator Address of the operator.
530      * @return True if the operator is approved, false if not.
531      */
532     function isApprovedForAll(address owner, address operator) external view returns (bool);
533 }
534 
535 
536 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155MetadataURI.sol@v7.1.0
537 
538 pragma solidity 0.6.8;
539 
540 /**
541  * @title ERC-1155 Multi Token Standard, optional metadata URI extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-1155
543  * Note: The ERC-165 identifier for this interface is 0x0e89341c.
544  */
545 interface IERC1155MetadataURI {
546     /**
547      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
548      * @dev URIs are defined in RFC 3986.
549      * @dev The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
550      * @dev The uri function SHOULD be used to retrieve values if no event was emitted.
551      * @dev The uri function MUST return the same value as the latest event for an _id if it was emitted.
552      * @dev The uri function MUST NOT be used to check for the existence of a token as it is possible for
553      *  an implementation to return a valid string even if the token does not exist.
554      * @return URI string
555      */
556     function uri(uint256 id) external view returns (string memory);
557 }
558 
559 
560 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155Inventory.sol@v7.1.0
561 
562 pragma solidity 0.6.8;
563 
564 /**
565  * @title ERC-1155 Multi Token Standard, optional Inventory extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
567  * Interface for fungible/non-fungible tokens management on a 1155-compliant contract.
568  *
569  * This interface rationalizes the co-existence of fungible and non-fungible tokens
570  * within the same contract. As several kinds of fungible tokens can be managed under
571  * the Multi-Token standard, we consider that non-fungible tokens can be classified
572  * under their own specific type. We introduce the concept of non-fungible collection
573  * and consider the usage of 3 types of identifiers:
574  * (a) Fungible Token identifiers, each representing a set of Fungible Tokens,
575  * (b) Non-Fungible Collection identifiers, each representing a set of Non-Fungible Tokens (this is not a token),
576  * (c) Non-Fungible Token identifiers. 
577 
578  * Identifiers nature
579  * |       Type                | isFungible  | isCollection | isToken |
580  * |  Fungible Token           |   true      |     true     |  true   |
581  * |  Non-Fungible Collection  |   false     |     true     |  false  |
582  * |  Non-Fungible Token       |   false     |     false    |  true   |
583  *
584  * Identifiers compatibilities
585  * |       Type                |  transfer  |   balance    |   supply    |  owner  |
586  * |  Fungible Token           |    OK      |     OK       |     OK      |   NOK   |
587  * |  Non-Fungible Collection  |    NOK     |     OK       |     OK      |   NOK   |
588  * |  Non-Fungible Token       |    OK      |   0 or 1     |   0 or 1    |   OK    |
589  *
590  * Note: The ERC-165 identifier for this interface is 0x469bd23f.
591  */
592 interface IERC1155Inventory {
593     /**
594      * Optional event emitted when a collection (Fungible Token or Non-Fungible Collection) is created.
595      *  This event can be used by a client application to determine which identifiers are meaningful
596      *  to track through the functions `balanceOf`, `balanceOfBatch` and `totalSupply`.
597      * @dev This event MUST NOT be emitted twice for the same `collectionId`.
598      */
599     event CollectionCreated(uint256 indexed collectionId, bool indexed fungible);
600 
601     /**
602      * Retrieves the owner of a non-fungible token (ERC721-compatible).
603      * @dev Reverts if `nftId` is owned by the zero address.
604      * @param nftId Identifier of the token to query.
605      * @return Address of the current owner of the token.
606      */
607     function ownerOf(uint256 nftId) external view returns (address);
608 
609     /**
610      * Introspects whether or not `id` represents a fungible token.
611      *  This function MUST return true even for a fungible token which is not-yet created.
612      * @param id The identifier to query.
613      * @return bool True if `id` represents afungible token, false otherwise.
614      */
615     function isFungible(uint256 id) external pure returns (bool);
616 
617     /**
618      * Introspects the non-fungible collection to which `nftId` belongs.
619      * @dev This function MUST return a value representing a non-fungible collection.
620      * @dev This function MUST return a value for a non-existing token, and SHOULD NOT be used to check the existence of a non-fungible token.
621      * @dev Reverts if `nftId` does not represent a non-fungible token.
622      * @param nftId The token identifier to query the collection of.
623      * @return The non-fungible collection identifier to which `nftId` belongs.
624      */
625     function collectionOf(uint256 nftId) external pure returns (uint256);
626 
627     /**
628      * Retrieves the total supply of `id`.
629      * @param id The identifier for which to retrieve the supply of.
630      * @return
631      *  If `id` represents a collection (fungible token or non-fungible collection), the total supply for this collection.
632      *  If `id` represents a non-fungible token, 1 if the token exists, else 0.
633      */
634     function totalSupply(uint256 id) external view returns (uint256);
635 
636     /**
637      * @notice this documentation overrides {IERC1155-balanceOf(address,uint256)}.
638      * Retrieves the balance of `id` owned by account `owner`.
639      * @param owner The account to retrieve the balance of.
640      * @param id The identifier to retrieve the balance of.
641      * @return
642      *  If `id` represents a collection (fungible token or non-fungible collection), the balance for this collection.
643      *  If `id` represents a non-fungible token, 1 if the token is owned by `owner`, else 0.
644      */
645     // function balanceOf(address owner, uint256 id) external view returns (uint256);
646 
647     /**
648      * @notice this documentation overrides {IERC1155-balanceOfBatch(address[],uint256[])}.
649      * Retrieves the balances of `ids` owned by accounts `owners`.
650      * @dev Reverts if `owners` and `ids` have different lengths.
651      * @param owners The accounts to retrieve the balances of.
652      * @param ids The identifiers to retrieve the balances of.
653      * @return An array of elements such as for each pair `id`/`owner`:
654      *  If `id` represents a collection (fungible token or non-fungible collection), the balance for this collection.
655      *  If `id` represents a non-fungible token, 1 if the token is owned by `owner`, else 0.
656      */
657     // function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);
658 
659     /**
660      * @notice this documentation overrides its {IERC1155-safeTransferFrom(address,address,uint256,uint256,bytes)}.
661      * Safely transfers some token.
662      * @dev Reverts if `to` is the zero address.
663      * @dev Reverts if the sender is not approved.
664      * @dev Reverts if `id` does not represent a token.
665      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
666      * @dev Reverts if `id` represents a non-fungible token and is not owned by `from`.
667      * @dev Reverts if `id` represents a fungible token and `value` is 0.
668      * @dev Reverts if `id` represents a fungible token and `from` has an insufficient balance.
669      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
670      * @dev Emits an {IERC1155-TransferSingle} event.
671      * @param from Current token owner.
672      * @param to Address of the new token owner.
673      * @param id Identifier of the token to transfer.
674      * @param value Amount of token to transfer.
675      * @param data Optional data to pass to the receiver contract.
676      */
677     // function safeTransferFrom(
678     //     address from,
679     //     address to,
680     //     uint256 id,
681     //     uint256 value,
682     //     bytes calldata data
683     // ) external;
684 
685     /**
686      * @notice this documentation overrides its {IERC1155-safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)}.
687      * Safely transfers a batch of tokens.
688      * @dev Reverts if `to` is the zero address.
689      * @dev Reverts if the sender is not approved.
690      * @dev Reverts if one of `ids` does not represent a token.
691      * @dev Reverts if one of `ids` represents a non-fungible token and `value` is not 1.
692      * @dev Reverts if one of `ids` represents a non-fungible token and is not owned by `from`.
693      * @dev Reverts if one of `ids` represents a fungible token and `value` is 0.
694      * @dev Reverts if one of `ids` represents a fungible token and `from` has an insufficient balance.
695      * @dev Reverts if one of `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
696      * @dev Emits an {IERC1155-TransferBatch} event.
697      * @param from Current tokens owner.
698      * @param to Address of the new tokens owner.
699      * @param ids Identifiers of the tokens to transfer.
700      * @param values Amounts of tokens to transfer.
701      * @param data Optional data to pass to the receiver contract.
702      */
703     // function safeBatchTransferFrom(
704     //     address from,
705     //     address to,
706     //     uint256[] calldata ids,
707     //     uint256[] calldata values,
708     //     bytes calldata data
709     // ) external;
710 }
711 
712 
713 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v7.1.0
714 
715 pragma solidity 0.6.8;
716 
717 /**
718  * @title ERC-1155 Multi Token Standard, token receiver
719  * @dev See https://eips.ethereum.org/EIPS/eip-1155
720  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
721  * Note: The ERC-165 identifier for this interface is 0x4e2312e0.
722  */
723 interface IERC1155TokenReceiver {
724     /**
725      * @notice Handle the receipt of a single ERC1155 token type.
726      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeTransferFrom` after the balance update.
727      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
728      *  (i.e. 0xf23a6e61) to accept the transfer.
729      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
730      * @param operator  The address which initiated the transfer (i.e. msg.sender)
731      * @param from      The address which previously owned the token
732      * @param id        The ID of the token being transferred
733      * @param value     The amount of tokens being transferred
734      * @param data      Additional data with no specified format
735      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
736      */
737     function onERC1155Received(
738         address operator,
739         address from,
740         uint256 id,
741         uint256 value,
742         bytes calldata data
743     ) external returns (bytes4);
744 
745     /**
746      * @notice Handle the receipt of multiple ERC1155 token types.
747      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeBatchTransferFrom` after the balance updates.
748      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
749      *  (i.e. 0xbc197c81) if to accept the transfer(s).
750      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
751      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
752      * @param from      The address which previously owned the token
753      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
754      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
755      * @param data      Additional data with no specified format
756      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
757      */
758     function onERC1155BatchReceived(
759         address operator,
760         address from,
761         uint256[] calldata ids,
762         uint256[] calldata values,
763         bytes calldata data
764     ) external returns (bytes4);
765 }
766 
767 
768 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155InventoryBase.sol@v7.1.0
769 
770 pragma solidity 0.6.8;
771 
772 
773 
774 
775 
776 
777 /**
778  * @title ERC1155InventoryIdentifiersLib, a library to introspect inventory identifiers.
779  * @dev With N=32, representing the Non-Fungible Collection mask length, identifiers are represented as follow:
780  * (a) a Fungible Token:
781  *     - most significant bit == 0
782  * (b) a Non-Fungible Collection:
783  *     - most significant bit == 1
784  *     - (256-N) least significant bits == 0
785  * (c) a Non-Fungible Token:
786  *     - most significant bit == 1
787  *     - (256-N) least significant bits != 0
788  */
789 library ERC1155InventoryIdentifiersLib {
790     // Non-fungible bit. If an id has this bit set, it is a non-fungible (either collection or token)
791     uint256 internal constant _NF_BIT = 1 << 255;
792 
793     // Mask for non-fungible collection (including the nf bit)
794     uint256 internal constant _NF_COLLECTION_MASK = uint256(type(uint32).max) << 224;
795     uint256 internal constant _NF_TOKEN_MASK = ~_NF_COLLECTION_MASK;
796 
797     function isFungibleToken(uint256 id) internal pure returns (bool) {
798         return id & _NF_BIT == 0;
799     }
800 
801     function isNonFungibleToken(uint256 id) internal pure returns (bool) {
802         return id & _NF_BIT != 0 && id & _NF_TOKEN_MASK != 0;
803     }
804 
805     function getNonFungibleCollection(uint256 nftId) internal pure returns (uint256) {
806         return nftId & _NF_COLLECTION_MASK;
807     }
808 }
809 
810 abstract contract ERC1155InventoryBase is IERC1155, IERC1155MetadataURI, IERC1155Inventory, IERC165, Context {
811     using ERC1155InventoryIdentifiersLib for uint256;
812 
813     bytes4 private constant _ERC165_INTERFACE_ID = type(IERC165).interfaceId;
814     bytes4 private constant _ERC1155_INTERFACE_ID = type(IERC1155).interfaceId;
815     bytes4 private constant _ERC1155_METADATA_URI_INTERFACE_ID = type(IERC1155MetadataURI).interfaceId;
816     bytes4 private constant _ERC1155_INVENTORY_INTERFACE_ID = type(IERC1155Inventory).interfaceId;
817 
818     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
819     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
820 
821     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
822     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
823 
824     // Burnt non-fungible token owner's magic value
825     uint256 internal constant _BURNT_NFT_OWNER = 0xdead000000000000000000000000000000000000000000000000000000000000;
826 
827     /* owner => operator => approved */
828     mapping(address => mapping(address => bool)) internal _operators;
829 
830     /* collection ID => owner => balance */
831     mapping(uint256 => mapping(address => uint256)) internal _balances;
832 
833     /* collection ID => supply */
834     mapping(uint256 => uint256) internal _supplies;
835 
836     /* NFT ID => owner */
837     mapping(uint256 => uint256) internal _owners;
838 
839     /* collection ID => creator */
840     mapping(uint256 => address) internal _creators;
841 
842     /// @dev See {IERC165-supportsInterface}.
843     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
844         return
845             interfaceId == _ERC165_INTERFACE_ID ||
846             interfaceId == _ERC1155_INTERFACE_ID ||
847             interfaceId == _ERC1155_METADATA_URI_INTERFACE_ID ||
848             interfaceId == _ERC1155_INVENTORY_INTERFACE_ID;
849     }
850 
851     //================================== ERC1155 =======================================/
852 
853     /// @dev See {IERC1155-balanceOf(address,uint256)}.
854     function balanceOf(address owner, uint256 id) public view virtual override returns (uint256) {
855         require(owner != address(0), "Inventory: zero address");
856 
857         if (id.isNonFungibleToken()) {
858             return address(_owners[id]) == owner ? 1 : 0;
859         }
860 
861         return _balances[id][owner];
862     }
863 
864     /// @dev See {IERC1155-balanceOfBatch(address[],uint256[])}.
865     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view virtual override returns (uint256[] memory) {
866         require(owners.length == ids.length, "Inventory: inconsistent arrays");
867 
868         uint256[] memory balances = new uint256[](owners.length);
869 
870         for (uint256 i = 0; i != owners.length; ++i) {
871             balances[i] = balanceOf(owners[i], ids[i]);
872         }
873 
874         return balances;
875     }
876 
877     /// @dev See {IERC1155-setApprovalForAll(address,bool)}.
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         address sender = _msgSender();
880         require(operator != sender, "Inventory: self-approval");
881         _operators[sender][operator] = approved;
882         emit ApprovalForAll(sender, operator, approved);
883     }
884 
885     /// @dev See {IERC1155-isApprovedForAll(address,address)}.
886     function isApprovedForAll(address tokenOwner, address operator) public view virtual override returns (bool) {
887         return _operators[tokenOwner][operator];
888     }
889 
890     //================================== ERC1155Inventory =======================================/
891 
892     /// @dev See {IERC1155Inventory-isFungible(uint256)}.
893     function isFungible(uint256 id) external pure virtual override returns (bool) {
894         return id.isFungibleToken();
895     }
896 
897     /// @dev See {IERC1155Inventory-collectionOf(uint256)}.
898     function collectionOf(uint256 nftId) external pure virtual override returns (uint256) {
899         require(nftId.isNonFungibleToken(), "Inventory: not an NFT");
900         return nftId.getNonFungibleCollection();
901     }
902 
903     /// @dev See {IERC1155Inventory-ownerOf(uint256)}.
904     function ownerOf(uint256 nftId) public view virtual override returns (address) {
905         address owner = address(_owners[nftId]);
906         require(owner != address(0), "Inventory: non-existing NFT");
907         return owner;
908     }
909 
910     /// @dev See {IERC1155Inventory-totalSupply(uint256)}.
911     function totalSupply(uint256 id) external view virtual override returns (uint256) {
912         if (id.isNonFungibleToken()) {
913             return address(_owners[id]) == address(0) ? 0 : 1;
914         } else {
915             return _supplies[id];
916         }
917     }
918 
919     //================================== ABI-level Internal Functions =======================================/
920 
921     /**
922      * Creates a collection (optional).
923      * @dev Reverts if `collectionId` does not represent a collection.
924      * @dev Reverts if `collectionId` has already been created.
925      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
926      * @param collectionId Identifier of the collection.
927      */
928     function _createCollection(uint256 collectionId) internal virtual {
929         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
930         require(_creators[collectionId] == address(0), "Inventory: existing collection");
931         _creators[collectionId] = _msgSender();
932         emit CollectionCreated(collectionId, collectionId.isFungibleToken());
933     }
934 
935     /// @dev See {IERC1155InventoryCreator-creator(uint256)}.
936     function _creator(uint256 collectionId) internal view virtual returns (address) {
937         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
938         return _creators[collectionId];
939     }
940 
941     //================================== Internal Helper Functions =======================================/
942 
943     /**
944      * Returns whether `sender` is authorised to make a transfer on behalf of `from`.
945      * @param from The address to check operatibility upon.
946      * @param sender The sender address.
947      * @return True if sender is `from` or an operator for `from`, false otherwise.
948      */
949     function _isOperatable(address from, address sender) internal view virtual returns (bool) {
950         return (from == sender) || _operators[from][sender];
951     }
952 
953     /**
954      * Calls {IERC1155TokenReceiver-onERC1155Received} on a target contract.
955      * @dev Reverts if `to` is not a contract.
956      * @dev Reverts if the call to the target fails or is refused.
957      * @param from Previous token owner.
958      * @param to New token owner.
959      * @param id Identifier of the token transferred.
960      * @param value Amount of token transferred.
961      * @param data Optional data to send along with the receiver contract call.
962      */
963     function _callOnERC1155Received(
964         address from,
965         address to,
966         uint256 id,
967         uint256 value,
968         bytes memory data
969     ) internal {
970         require(IERC1155TokenReceiver(to).onERC1155Received(_msgSender(), from, id, value, data) == _ERC1155_RECEIVED, "Inventory: transfer refused");
971     }
972 
973     /**
974      * Calls {IERC1155TokenReceiver-onERC1155batchReceived} on a target contract.
975      * @dev Reverts if `to` is not a contract.
976      * @dev Reverts if the call to the target fails or is refused.
977      * @param from Previous tokens owner.
978      * @param to New tokens owner.
979      * @param ids Identifiers of the tokens to transfer.
980      * @param values Amounts of tokens to transfer.
981      * @param data Optional data to send along with the receiver contract call.
982      */
983     function _callOnERC1155BatchReceived(
984         address from,
985         address to,
986         uint256[] memory ids,
987         uint256[] memory values,
988         bytes memory data
989     ) internal {
990         require(
991             IERC1155TokenReceiver(to).onERC1155BatchReceived(_msgSender(), from, ids, values, data) == _ERC1155_BATCH_RECEIVED,
992             "Inventory: transfer refused"
993         );
994     }
995 }
996 
997 
998 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/ERC1155721Inventory.sol@v7.1.0
999 
1000 pragma solidity 0.6.8;
1001 
1002 
1003 
1004 
1005 
1006 
1007 /**
1008  * @title ERC1155721Inventory, an ERC1155Inventory with additional support for ERC721.
1009  */
1010 abstract contract ERC1155721Inventory is IERC721, IERC721Metadata, IERC721BatchTransfer, ERC1155InventoryBase {
1011     using Address for address;
1012 
1013     bytes4 private constant _ERC165_INTERFACE_ID = type(IERC165).interfaceId;
1014     bytes4 private constant _ERC1155_TOKEN_RECEIVER_INTERFACE_ID = type(IERC1155TokenReceiver).interfaceId;
1015     bytes4 private constant _ERC721_INTERFACE_ID = type(IERC721).interfaceId;
1016     bytes4 private constant _ERC721_METADATA_INTERFACE_ID = type(IERC721Metadata).interfaceId;
1017 
1018     bytes4 internal constant _ERC721_RECEIVED = type(IERC721Receiver).interfaceId;
1019 
1020     uint256 internal constant _APPROVAL_BIT_TOKEN_OWNER_ = 1 << 160;
1021 
1022     /* owner => NFT balance */
1023     mapping(address => uint256) internal _nftBalances;
1024 
1025     /* NFT ID => operator */
1026     mapping(uint256 => address) internal _nftApprovals;
1027 
1028     /// @dev See {IERC165-supportsInterface(bytes4)}.
1029     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1030         return super.supportsInterface(interfaceId) || interfaceId == _ERC721_INTERFACE_ID || interfaceId == _ERC721_METADATA_INTERFACE_ID;
1031     }
1032 
1033     //===================================== ERC721 ==========================================/
1034 
1035     /// @dev See {IERC721-balanceOf(address)}.
1036     function balanceOf(address tokenOwner) external view virtual override returns (uint256) {
1037         require(tokenOwner != address(0), "Inventory: zero address");
1038         return _nftBalances[tokenOwner];
1039     }
1040 
1041     /// @dev See {IERC721-ownerOf(uint256)} and {IERC1155Inventory-ownerOf(uint256)}.
1042     function ownerOf(uint256 nftId) public view virtual override(IERC721, ERC1155InventoryBase) returns (address) {
1043         return ERC1155InventoryBase.ownerOf(nftId);
1044     }
1045 
1046     /// @dev See {IERC721-approve(address,uint256)}.
1047     function approve(address to, uint256 nftId) external virtual override {
1048         address tokenOwner = ownerOf(nftId);
1049         require(to != tokenOwner, "Inventory: self-approval");
1050         require(_isOperatable(tokenOwner, _msgSender()), "Inventory: non-approved sender");
1051         _owners[nftId] = uint256(tokenOwner) | _APPROVAL_BIT_TOKEN_OWNER_;
1052         _nftApprovals[nftId] = to;
1053         emit Approval(tokenOwner, to, nftId);
1054     }
1055 
1056     /// @dev See {IERC721-getApproved(uint256)}.
1057     function getApproved(uint256 nftId) external view virtual override returns (address) {
1058         uint256 tokenOwner = _owners[nftId];
1059         require(address(tokenOwner) != address(0), "Inventory: non-existing NFT");
1060         if (tokenOwner & _APPROVAL_BIT_TOKEN_OWNER_ != 0) {
1061             return _nftApprovals[nftId];
1062         } else {
1063             return address(0);
1064         }
1065     }
1066 
1067     /// @dev See {IERC721-isApprovedForAll(address,address)} and {IERC1155-isApprovedForAll(address,address)}
1068     function isApprovedForAll(address tokenOwner, address operator) public view virtual override(IERC721, ERC1155InventoryBase) returns (bool) {
1069         return ERC1155InventoryBase.isApprovedForAll(tokenOwner, operator);
1070     }
1071 
1072     /// @dev See {IERC721-isApprovedForAll(address,address)} and {IERC1155-isApprovedForAll(address,address)}
1073     function setApprovalForAll(address operator, bool approved) public virtual override(IERC721, ERC1155InventoryBase) {
1074         return ERC1155InventoryBase.setApprovalForAll(operator, approved);
1075     }
1076 
1077     /**
1078      * Unsafely transfers a Non-Fungible Token (ERC721-compatible).
1079      * @dev See {IERC1155721Inventory-transferFrom(address,address,uint256)}.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 nftId
1085     ) public virtual override {
1086         _transferFrom(
1087             from,
1088             to,
1089             nftId,
1090             "",
1091             /* safe */
1092             false
1093         );
1094     }
1095 
1096     /**
1097      * Safely transfers a Non-Fungible Token (ERC721-compatible).
1098      * @dev See {IERC1155721Inventory-safeTransferFrom(address,address,uint256)}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 nftId
1104     ) public virtual override {
1105         _transferFrom(
1106             from,
1107             to,
1108             nftId,
1109             "",
1110             /* safe */
1111             true
1112         );
1113     }
1114 
1115     /**
1116      * Safely transfers a Non-Fungible Token (ERC721-compatible).
1117      * @dev See {IERC1155721Inventory-safeTransferFrom(address,address,uint256,bytes)}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 nftId,
1123         bytes memory data
1124     ) public virtual override {
1125         _transferFrom(
1126             from,
1127             to,
1128             nftId,
1129             data,
1130             /* safe */
1131             true
1132         );
1133     }
1134 
1135     /**
1136      * Unsafely transfers a batch of Non-Fungible Tokens (ERC721-compatible).
1137      * @dev See {IERC1155721BatchTransfer-batchTransferFrom(address,address,uint256[])}.
1138      */
1139     function batchTransferFrom(
1140         address from,
1141         address to,
1142         uint256[] memory nftIds
1143     ) public virtual override {
1144         require(to != address(0), "Inventory: transfer to zero");
1145         address sender = _msgSender();
1146         bool operatable = _isOperatable(from, sender);
1147 
1148         uint256 length = nftIds.length;
1149         uint256[] memory values = new uint256[](length);
1150 
1151         uint256 nfCollectionId;
1152         uint256 nfCollectionCount;
1153         for (uint256 i; i != length; ++i) {
1154             uint256 nftId = nftIds[i];
1155             values[i] = 1;
1156             _transferNFT(from, to, nftId, 1, operatable, true);
1157             emit Transfer(from, to, nftId);
1158             uint256 nextCollectionId = nftId.getNonFungibleCollection();
1159             if (nfCollectionId == 0) {
1160                 nfCollectionId = nextCollectionId;
1161                 nfCollectionCount = 1;
1162             } else {
1163                 if (nextCollectionId != nfCollectionId) {
1164                     _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1165                     nfCollectionId = nextCollectionId;
1166                     nfCollectionCount = 1;
1167                 } else {
1168                     ++nfCollectionCount;
1169                 }
1170             }
1171         }
1172 
1173         if (nfCollectionId != 0) {
1174             _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1175             _transferNFTUpdateBalances(from, to, length);
1176         }
1177 
1178         emit TransferBatch(_msgSender(), from, to, nftIds, values);
1179         if (to.isContract() && _isERC1155TokenReceiver(to)) {
1180             _callOnERC1155BatchReceived(from, to, nftIds, values, "");
1181         }
1182     }
1183 
1184     /// @dev See {IERC721Metadata-tokenURI(uint256)}.
1185     function tokenURI(uint256 nftId) external view virtual override returns (string memory) {
1186         require(address(_owners[nftId]) != address(0), "Inventory: non-existing NFT");
1187         return uri(nftId);
1188     }
1189 
1190     //================================== ERC1155 =======================================/
1191 
1192     /**
1193      * Safely transfers some token (ERC1155-compatible).
1194      * @dev See {IERC1155721Inventory-safeTransferFrom(address,address,uint256,uint256,bytes)}.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 id,
1200         uint256 value,
1201         bytes memory data
1202     ) public virtual override {
1203         address sender = _msgSender();
1204         require(to != address(0), "Inventory: transfer to zero");
1205         bool operatable = _isOperatable(from, sender);
1206 
1207         if (id.isFungibleToken()) {
1208             _transferFungible(from, to, id, value, operatable);
1209         } else if (id.isNonFungibleToken()) {
1210             _transferNFT(from, to, id, value, operatable, false);
1211             emit Transfer(from, to, id);
1212         } else {
1213             revert("Inventory: not a token id");
1214         }
1215 
1216         emit TransferSingle(sender, from, to, id, value);
1217         if (to.isContract()) {
1218             _callOnERC1155Received(from, to, id, value, data);
1219         }
1220     }
1221 
1222     /**
1223      * Safely transfers a batch of tokens (ERC1155-compatible).
1224      * @dev See {IERC1155721Inventory-safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)}.
1225      */
1226     function safeBatchTransferFrom(
1227         address from,
1228         address to,
1229         uint256[] memory ids,
1230         uint256[] memory values,
1231         bytes memory data
1232     ) public virtual override {
1233         // internal function to avoid stack too deep error
1234         _safeBatchTransferFrom(from, to, ids, values, data);
1235     }
1236 
1237     //================================== ERC1155MetadataURI =======================================/
1238 
1239     /// @dev See {IERC1155MetadataURI-uri(uint256)}.
1240     function uri(uint256) public view virtual override returns (string memory);
1241 
1242     //================================== ABI-level Internal Functions =======================================/
1243 
1244     /**
1245      * Safely or unsafely transfers some token (ERC721-compatible).
1246      * @dev For `safe` transfer, see {IERC1155721Inventory-transferFrom(address,address,uint256)}.
1247      * @dev For un`safe` transfer, see {IERC1155721Inventory-safeTransferFrom(address,address,uint256,bytes)}.
1248      */
1249     function _transferFrom(
1250         address from,
1251         address to,
1252         uint256 nftId,
1253         bytes memory data,
1254         bool safe
1255     ) internal {
1256         require(to != address(0), "Inventory: transfer to zero");
1257         address sender = _msgSender();
1258         bool operatable = _isOperatable(from, sender);
1259 
1260         _transferNFT(from, to, nftId, 1, operatable, false);
1261 
1262         emit Transfer(from, to, nftId);
1263         emit TransferSingle(sender, from, to, nftId, 1);
1264         if (to.isContract()) {
1265             if (_isERC1155TokenReceiver(to)) {
1266                 _callOnERC1155Received(from, to, nftId, 1, data);
1267             } else if (safe) {
1268                 _callOnERC721Received(from, to, nftId, data);
1269             }
1270         }
1271     }
1272 
1273     /**
1274      * Safely transfers a batch of tokens (ERC1155-compatible).
1275      * @dev See {IERC1155721Inventory-safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)}.
1276      */
1277     function _safeBatchTransferFrom(
1278         address from,
1279         address to,
1280         uint256[] memory ids,
1281         uint256[] memory values,
1282         bytes memory data
1283     ) internal {
1284         require(to != address(0), "Inventory: transfer to zero");
1285         uint256 length = ids.length;
1286         require(length == values.length, "Inventory: inconsistent arrays");
1287         address sender = _msgSender();
1288         bool operatable = _isOperatable(from, sender);
1289 
1290         uint256 nfCollectionId;
1291         uint256 nfCollectionCount;
1292         uint256 nftsCount;
1293         for (uint256 i; i != length; ++i) {
1294             uint256 id = ids[i];
1295             if (id.isFungibleToken()) {
1296                 _transferFungible(from, to, id, values[i], operatable);
1297             } else if (id.isNonFungibleToken()) {
1298                 _transferNFT(from, to, id, values[i], operatable, true);
1299                 emit Transfer(from, to, id);
1300                 uint256 nextCollectionId = id.getNonFungibleCollection();
1301                 if (nfCollectionId == 0) {
1302                     nfCollectionId = nextCollectionId;
1303                     nfCollectionCount = 1;
1304                 } else {
1305                     if (nextCollectionId != nfCollectionId) {
1306                         _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1307                         nfCollectionId = nextCollectionId;
1308                         nftsCount += nfCollectionCount;
1309                         nfCollectionCount = 1;
1310                     } else {
1311                         ++nfCollectionCount;
1312                     }
1313                 }
1314             } else {
1315                 revert("Inventory: not a token id");
1316             }
1317         }
1318 
1319         if (nfCollectionId != 0) {
1320             _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1321             nftsCount += nfCollectionCount;
1322             _transferNFTUpdateBalances(from, to, nftsCount);
1323         }
1324 
1325         emit TransferBatch(_msgSender(), from, to, ids, values);
1326         if (to.isContract()) {
1327             _callOnERC1155BatchReceived(from, to, ids, values, data);
1328         }
1329     }
1330 
1331     /**
1332      * Safely or unsafely mints some token (ERC721-compatible).
1333      * @dev For `safe` mint, see {IERC1155721InventoryMintable-mint(address,uint256)}.
1334      * @dev For un`safe` mint, see {IERC1155721InventoryMintable-safeMint(address,uint256,bytes)}.
1335      */
1336     function _mint(
1337         address to,
1338         uint256 nftId,
1339         bytes memory data,
1340         bool safe
1341     ) internal {
1342         require(to != address(0), "Inventory: transfer to zero");
1343         require(nftId.isNonFungibleToken(), "Inventory: not an NFT");
1344 
1345         _mintNFT(to, nftId, 1, false);
1346 
1347         emit Transfer(address(0), to, nftId);
1348         emit TransferSingle(_msgSender(), address(0), to, nftId, 1);
1349         if (to.isContract()) {
1350             if (_isERC1155TokenReceiver(to)) {
1351                 _callOnERC1155Received(address(0), to, nftId, 1, data);
1352             } else if (safe) {
1353                 _callOnERC721Received(address(0), to, nftId, data);
1354             }
1355         }
1356     }
1357 
1358     /**
1359      * Unsafely mints a batch of Non-Fungible Tokens (ERC721-compatible).
1360      * @dev See {IERC1155721InventoryMintable-batchMint(address,uint256[])}.
1361      */
1362     function _batchMint(address to, uint256[] memory nftIds) internal {
1363         require(to != address(0), "Inventory: transfer to zero");
1364 
1365         uint256 length = nftIds.length;
1366         uint256[] memory values = new uint256[](length);
1367 
1368         uint256 nfCollectionId;
1369         uint256 nfCollectionCount;
1370         for (uint256 i; i != length; ++i) {
1371             uint256 nftId = nftIds[i];
1372             require(nftId.isNonFungibleToken(), "Inventory: not an NFT");
1373             values[i] = 1;
1374             _mintNFT(to, nftId, 1, true);
1375             emit Transfer(address(0), to, nftId);
1376             uint256 nextCollectionId = nftId.getNonFungibleCollection();
1377             if (nfCollectionId == 0) {
1378                 nfCollectionId = nextCollectionId;
1379                 nfCollectionCount = 1;
1380             } else {
1381                 if (nextCollectionId != nfCollectionId) {
1382                     _balances[nfCollectionId][to] += nfCollectionCount;
1383                     _supplies[nfCollectionId] += nfCollectionCount;
1384                     nfCollectionId = nextCollectionId;
1385                     nfCollectionCount = 1;
1386                 } else {
1387                     ++nfCollectionCount;
1388                 }
1389             }
1390         }
1391 
1392         _balances[nfCollectionId][to] += nfCollectionCount;
1393         _supplies[nfCollectionId] += nfCollectionCount;
1394         _nftBalances[to] += length;
1395 
1396         emit TransferBatch(_msgSender(), address(0), to, nftIds, values);
1397         if (to.isContract() && _isERC1155TokenReceiver(to)) {
1398             _callOnERC1155BatchReceived(address(0), to, nftIds, values, "");
1399         }
1400     }
1401 
1402     /**
1403      * Safely mints some token (ERC1155-compatible).
1404      * @dev See {IERC1155721InventoryMintable-safeMint(address,uint256,uint256,bytes)}.
1405      */
1406     function _safeMint(
1407         address to,
1408         uint256 id,
1409         uint256 value,
1410         bytes memory data
1411     ) internal virtual {
1412         require(to != address(0), "Inventory: transfer to zero");
1413         address sender = _msgSender();
1414         if (id.isFungibleToken()) {
1415             _mintFungible(to, id, value);
1416         } else if (id.isNonFungibleToken()) {
1417             _mintNFT(to, id, value, false);
1418             emit Transfer(address(0), to, id);
1419         } else {
1420             revert("Inventory: not a token id");
1421         }
1422 
1423         emit TransferSingle(sender, address(0), to, id, value);
1424         if (to.isContract()) {
1425             _callOnERC1155Received(address(0), to, id, value, data);
1426         }
1427     }
1428 
1429     /**
1430      * Safely mints a batch of tokens (ERC1155-compatible).
1431      * @dev See {IERC1155721InventoryMintable-safeBatchMint(address,uint256[],uint256[],bytes)}.
1432      */
1433     function _safeBatchMint(
1434         address to,
1435         uint256[] memory ids,
1436         uint256[] memory values,
1437         bytes memory data
1438     ) internal virtual {
1439         require(to != address(0), "Inventory: transfer to zero");
1440         uint256 length = ids.length;
1441         require(length == values.length, "Inventory: inconsistent arrays");
1442 
1443         uint256 nfCollectionId;
1444         uint256 nfCollectionCount;
1445         uint256 nftsCount;
1446         for (uint256 i; i != length; ++i) {
1447             uint256 id = ids[i];
1448             uint256 value = values[i];
1449             if (id.isFungibleToken()) {
1450                 _mintFungible(to, id, value);
1451             } else if (id.isNonFungibleToken()) {
1452                 _mintNFT(to, id, value, true);
1453                 emit Transfer(address(0), to, id);
1454                 uint256 nextCollectionId = id.getNonFungibleCollection();
1455                 if (nfCollectionId == 0) {
1456                     nfCollectionId = nextCollectionId;
1457                     nfCollectionCount = 1;
1458                 } else {
1459                     if (nextCollectionId != nfCollectionId) {
1460                         _balances[nfCollectionId][to] += nfCollectionCount;
1461                         _supplies[nfCollectionId] += nfCollectionCount;
1462                         nfCollectionId = nextCollectionId;
1463                         nftsCount += nfCollectionCount;
1464                         nfCollectionCount = 1;
1465                     } else {
1466                         ++nfCollectionCount;
1467                     }
1468                 }
1469             } else {
1470                 revert("Inventory: not a token id");
1471             }
1472         }
1473 
1474         if (nfCollectionId != 0) {
1475             _balances[nfCollectionId][to] += nfCollectionCount;
1476             _supplies[nfCollectionId] += nfCollectionCount;
1477             nftsCount += nfCollectionCount;
1478             _nftBalances[to] += nftsCount;
1479         }
1480 
1481         emit TransferBatch(_msgSender(), address(0), to, ids, values);
1482         if (to.isContract()) {
1483             _callOnERC1155BatchReceived(address(0), to, ids, values, data);
1484         }
1485     }
1486 
1487     //============================== Internal Helper Functions =======================================/
1488 
1489     function _mintFungible(
1490         address to,
1491         uint256 id,
1492         uint256 value
1493     ) internal {
1494         require(value != 0, "Inventory: zero value");
1495         uint256 supply = _supplies[id];
1496         uint256 newSupply = supply + value;
1497         require(newSupply > supply, "Inventory: supply overflow");
1498         _supplies[id] = newSupply;
1499         // cannot overflow as supply cannot overflow
1500         _balances[id][to] += value;
1501     }
1502 
1503     function _mintNFT(
1504         address to,
1505         uint256 id,
1506         uint256 value,
1507         bool isBatch
1508     ) internal {
1509         require(value == 1, "Inventory: wrong NFT value");
1510         require(_owners[id] == 0, "Inventory: existing/burnt NFT");
1511 
1512         _owners[id] = uint256(to);
1513 
1514         if (!isBatch) {
1515             uint256 collectionId = id.getNonFungibleCollection();
1516             // it is virtually impossible that a non-fungible collection supply
1517             // overflows due to the cost of minting individual tokens
1518             ++_supplies[collectionId];
1519             ++_balances[collectionId][to];
1520             ++_nftBalances[to];
1521         }
1522     }
1523 
1524     function _transferFungible(
1525         address from,
1526         address to,
1527         uint256 id,
1528         uint256 value,
1529         bool operatable
1530     ) internal {
1531         require(operatable, "Inventory: non-approved sender");
1532         require(value != 0, "Inventory: zero value");
1533         uint256 balance = _balances[id][from];
1534         require(balance >= value, "Inventory: not enough balance");
1535         if (from != to) {
1536             _balances[id][from] = balance - value;
1537             // cannot overflow as supply cannot overflow
1538             _balances[id][to] += value;
1539         }
1540     }
1541 
1542     function _transferNFT(
1543         address from,
1544         address to,
1545         uint256 id,
1546         uint256 value,
1547         bool operatable,
1548         bool isBatch
1549     ) internal virtual {
1550         require(value == 1, "Inventory: wrong NFT value");
1551         uint256 owner = _owners[id];
1552         require(from == address(owner), "Inventory: non-owned NFT");
1553         if (!operatable) {
1554             require((owner & _APPROVAL_BIT_TOKEN_OWNER_ != 0) && _msgSender() == _nftApprovals[id], "Inventory: non-approved sender");
1555         }
1556         _owners[id] = uint256(to);
1557         if (!isBatch) {
1558             _transferNFTUpdateBalances(from, to, 1);
1559             _transferNFTUpdateCollection(from, to, id.getNonFungibleCollection(), 1);
1560         }
1561     }
1562 
1563     function _transferNFTUpdateBalances(
1564         address from,
1565         address to,
1566         uint256 amount
1567     ) internal virtual {
1568         if (from != to) {
1569             // cannot underflow as balance is verified through ownership
1570             _nftBalances[from] -= amount;
1571             //  cannot overflow as supply cannot overflow
1572             _nftBalances[to] += amount;
1573         }
1574     }
1575 
1576     function _transferNFTUpdateCollection(
1577         address from,
1578         address to,
1579         uint256 collectionId,
1580         uint256 amount
1581     ) internal virtual {
1582         if (from != to) {
1583             // cannot underflow as balance is verified through ownership
1584             _balances[collectionId][from] -= amount;
1585             // cannot overflow as supply cannot overflow
1586             _balances[collectionId][to] += amount;
1587         }
1588     }
1589 
1590     ///////////////////////////////////// Receiver Calls Internal /////////////////////////////////////
1591 
1592     /**
1593      * Queries whether a contract implements ERC1155TokenReceiver.
1594      * @param _contract address of the contract.
1595      * @return wheter the given contract implements ERC1155TokenReceiver.
1596      */
1597     function _isERC1155TokenReceiver(address _contract) internal view returns (bool) {
1598         bool success;
1599         bool result;
1600         bytes memory staticCallData = abi.encodeWithSelector(_ERC165_INTERFACE_ID, _ERC1155_TOKEN_RECEIVER_INTERFACE_ID);
1601         assembly {
1602             let call_ptr := add(0x20, staticCallData)
1603             let call_size := mload(staticCallData)
1604             let output := mload(0x40) // Find empty storage location using "free memory pointer"
1605             mstore(output, 0x0)
1606             success := staticcall(10000, _contract, call_ptr, call_size, output, 0x20) // 32 bytes
1607             result := mload(output)
1608         }
1609         // (10000 / 63) "not enough for supportsInterface(...)" // consume all gas, so caller can potentially know that there was not enough gas
1610         assert(gasleft() > 158);
1611         return success && result;
1612     }
1613 
1614     /**
1615      * Calls {IERC721Receiver-onERC721Received} on a target contract.
1616      * @dev Reverts if `to` is not a contract.
1617      * @dev Reverts if the call to the target fails or is refused.
1618      * @param from Previous token owner.
1619      * @param to New token owner.
1620      * @param nftId Identifier of the token transferred.
1621      * @param data Optional data to send along with the receiver contract call.
1622      */
1623     function _callOnERC721Received(
1624         address from,
1625         address to,
1626         uint256 nftId,
1627         bytes memory data
1628     ) internal {
1629         require(IERC721Receiver(to).onERC721Received(_msgSender(), from, nftId, data) == _ERC721_RECEIVED, "Inventory: transfer refused");
1630     }
1631 }
1632 
1633 
1634 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/IERC1155721InventoryBurnable.sol@v7.1.0
1635 
1636 pragma solidity 0.6.8;
1637 
1638 /**
1639  * @title IERC1155721InventoryBurnable interface.
1640  * The function {IERC721Burnable-burnFrom(address,uint256)} is not provided as
1641  *  {IERC1155Burnable-burnFrom(address,uint256,uint256)} can be used instead.
1642  */
1643 interface IERC1155721InventoryBurnable {
1644     /**
1645      * Burns some token (ERC1155-compatible).
1646      * @dev Reverts if the sender is not approved.
1647      * @dev Reverts if `id` does not represent a token.
1648      * @dev Reverts if `id` represents a fungible token and `value` is 0.
1649      * @dev Reverts if `id` represents a fungible token and `value` is higher than `from`'s balance.
1650      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1651      * @dev Reverts if `id` represents a non-fungible token which is not owned by `from`.
1652      * @dev Emits an {IERC721-Transfer} event to the zero address if `id` represents a non-fungible token.
1653      * @dev Emits an {IERC1155-TransferSingle} event to the zero address.
1654      * @param from Address of the current token owner.
1655      * @param id Identifier of the token to burn.
1656      * @param value Amount of token to burn.
1657      */
1658     function burnFrom(
1659         address from,
1660         uint256 id,
1661         uint256 value
1662     ) external;
1663 
1664     /**
1665      * Burns multiple tokens (ERC1155-compatible).
1666      * @dev Reverts if `ids` and `values` have different lengths.
1667      * @dev Reverts if the sender is not approved.
1668      * @dev Reverts if one of `ids` does not represent a token.
1669      * @dev Reverts if one of `ids` represents a fungible token and `value` is 0.
1670      * @dev Reverts if one of `ids` represents a fungible token and `value` is higher than `from`'s balance.
1671      * @dev Reverts if one of `ids` represents a non-fungible token and `value` is not 1.
1672      * @dev Reverts if one of `ids` represents a non-fungible token which is not owned by `from`.
1673      * @dev Emits an {IERC721-Transfer} event to the zero address for each burnt non-fungible token.
1674      * @dev Emits an {IERC1155-TransferBatch} event to the zero address.
1675      * @param from Address of the current tokens owner.
1676      * @param ids Identifiers of the tokens to burn.
1677      * @param values Amounts of tokens to burn.
1678      */
1679     function batchBurnFrom(
1680         address from,
1681         uint256[] calldata ids,
1682         uint256[] calldata values
1683     ) external;
1684 
1685     /**
1686      * Burns a batch of Non-Fungible Tokens (ERC721-compatible).
1687      * @dev Reverts if the sender is not approved.
1688      * @dev Reverts if one of `nftIds` does not represent a non-fungible token.
1689      * @dev Reverts if one of `nftIds` is not owned by `from`.
1690      * @dev Emits an {IERC721-Transfer} event to the zero address for each of `nftIds`.
1691      * @dev Emits an {IERC1155-TransferBatch} event to the zero address.
1692      * @param from Current token owner.
1693      * @param nftIds Identifiers of the tokens to transfer.
1694      */
1695     function batchBurnFrom(address from, uint256[] calldata nftIds) external;
1696 }
1697 
1698 
1699 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/ERC1155721InventoryBurnable.sol@v7.1.0
1700 
1701 pragma solidity 0.6.8;
1702 
1703 
1704 /**
1705  * @title ERC1155721InventoryBurnable, a burnable ERC1155721Inventory.
1706  */
1707 abstract contract ERC1155721InventoryBurnable is IERC1155721InventoryBurnable, ERC1155721Inventory {
1708     //============================== ERC1155721InventoryBurnable =======================================/
1709 
1710     /**
1711      * Burns some token (ERC1155-compatible).
1712      * @dev See {IERC1155721InventoryBurnable-burnFrom(address,uint256,uint256)}.
1713      */
1714     function burnFrom(
1715         address from,
1716         uint256 id,
1717         uint256 value
1718     ) public virtual override {
1719         address sender = _msgSender();
1720         bool operatable = _isOperatable(from, sender);
1721 
1722         if (id.isFungibleToken()) {
1723             _burnFungible(from, id, value, operatable);
1724         } else if (id.isNonFungibleToken()) {
1725             _burnNFT(from, id, value, operatable, false);
1726             emit Transfer(from, address(0), id);
1727         } else {
1728             revert("Inventory: not a token id");
1729         }
1730 
1731         emit TransferSingle(sender, from, address(0), id, value);
1732     }
1733 
1734     /**
1735      * Burns a batch of token (ERC1155-compatible).
1736      * @dev See {IERC1155721InventoryBurnable-batchBurnFrom(address,uint256[],uint256[])}.
1737      */
1738     function batchBurnFrom(
1739         address from,
1740         uint256[] memory ids,
1741         uint256[] memory values
1742     ) public virtual override {
1743         uint256 length = ids.length;
1744         require(length == values.length, "Inventory: inconsistent arrays");
1745 
1746         address sender = _msgSender();
1747         bool operatable = _isOperatable(from, sender);
1748 
1749         uint256 nfCollectionId;
1750         uint256 nfCollectionCount;
1751         uint256 nftsCount;
1752         for (uint256 i; i != length; ++i) {
1753             uint256 id = ids[i];
1754             if (id.isFungibleToken()) {
1755                 _burnFungible(from, id, values[i], operatable);
1756             } else if (id.isNonFungibleToken()) {
1757                 _burnNFT(from, id, values[i], operatable, true);
1758                 emit Transfer(from, address(0), id);
1759                 uint256 nextCollectionId = id.getNonFungibleCollection();
1760                 if (nfCollectionId == 0) {
1761                     nfCollectionId = nextCollectionId;
1762                     nfCollectionCount = 1;
1763                 } else {
1764                     if (nextCollectionId != nfCollectionId) {
1765                         _burnNFTUpdateCollection(from, nfCollectionId, nfCollectionCount);
1766                         nfCollectionId = nextCollectionId;
1767                         nftsCount += nfCollectionCount;
1768                         nfCollectionCount = 1;
1769                     } else {
1770                         ++nfCollectionCount;
1771                     }
1772                 }
1773             } else {
1774                 revert("Inventory: not a token id");
1775             }
1776         }
1777 
1778         if (nfCollectionId != 0) {
1779             _burnNFTUpdateCollection(from, nfCollectionId, nfCollectionCount);
1780             nftsCount += nfCollectionCount;
1781             // cannot underflow as balance is verified through ownership
1782             _nftBalances[from] -= nftsCount;
1783         }
1784 
1785         emit TransferBatch(sender, from, address(0), ids, values);
1786     }
1787 
1788     /**
1789      * Burns a batch of token (ERC721-compatible).
1790      * @dev See {IERC1155721InventoryBurnable-batchBurnFrom(address,uint256[])}.
1791      */
1792     function batchBurnFrom(address from, uint256[] memory nftIds) public virtual override {
1793         address sender = _msgSender();
1794         bool operatable = _isOperatable(from, sender);
1795 
1796         uint256 length = nftIds.length;
1797         uint256[] memory values = new uint256[](length);
1798 
1799         uint256 nfCollectionId;
1800         uint256 nfCollectionCount;
1801         for (uint256 i; i != length; ++i) {
1802             uint256 nftId = nftIds[i];
1803             values[i] = 1;
1804             _burnNFT(from, nftId, values[i], operatable, true);
1805             emit Transfer(from, address(0), nftId);
1806             uint256 nextCollectionId = nftId.getNonFungibleCollection();
1807             if (nfCollectionId == 0) {
1808                 nfCollectionId = nextCollectionId;
1809                 nfCollectionCount = 1;
1810             } else {
1811                 if (nextCollectionId != nfCollectionId) {
1812                     _burnNFTUpdateCollection(from, nfCollectionId, nfCollectionCount);
1813                     nfCollectionId = nextCollectionId;
1814                     nfCollectionCount = 1;
1815                 } else {
1816                     ++nfCollectionCount;
1817                 }
1818             }
1819         }
1820 
1821         if (nfCollectionId != 0) {
1822             _burnNFTUpdateCollection(from, nfCollectionId, nfCollectionCount);
1823             _nftBalances[from] -= length;
1824         }
1825 
1826         emit TransferBatch(sender, from, address(0), nftIds, values);
1827     }
1828 
1829     //============================== Internal Helper Functions =======================================/
1830 
1831     function _burnFungible(
1832         address from,
1833         uint256 id,
1834         uint256 value,
1835         bool operatable
1836     ) internal {
1837         require(value != 0, "Inventory: zero value");
1838         require(operatable, "Inventory: non-approved sender");
1839         uint256 balance = _balances[id][from];
1840         require(balance >= value, "Inventory: not enough balance");
1841         _balances[id][from] = balance - value;
1842         // Cannot underflow
1843         _supplies[id] -= value;
1844     }
1845 
1846     function _burnNFT(
1847         address from,
1848         uint256 id,
1849         uint256 value,
1850         bool operatable,
1851         bool isBatch
1852     ) internal virtual {
1853         require(value == 1, "Inventory: wrong NFT value");
1854         uint256 owner = _owners[id];
1855         require(from == address(owner), "Inventory: non-owned NFT");
1856         if (!operatable) {
1857             require((owner & _APPROVAL_BIT_TOKEN_OWNER_ != 0) && _msgSender() == _nftApprovals[id], "Inventory: non-approved sender");
1858         }
1859         _owners[id] = _BURNT_NFT_OWNER;
1860 
1861         if (!isBatch) {
1862             _burnNFTUpdateCollection(from, id.getNonFungibleCollection(), 1);
1863 
1864             // cannot underflow as balance is verified through NFT ownership
1865             --_nftBalances[from];
1866         }
1867     }
1868 
1869     function _burnNFTUpdateCollection(
1870         address from,
1871         uint256 collectionId,
1872         uint256 amount
1873     ) internal virtual {
1874         // cannot underflow as balance is verified through NFT ownership
1875         _balances[collectionId][from] -= amount;
1876         _supplies[collectionId] -= amount;
1877     }
1878 }
1879 
1880 
1881 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/IERC1155721InventoryMintable.sol@v7.1.0
1882 
1883 pragma solidity 0.6.8;
1884 
1885 /**
1886  * @title IERC1155721InventoryMintable interface.
1887  * The function {IERC721Mintable-safeMint(address,uint256,bytes)} is not provided as
1888  *  {IERC1155Mintable-safeMint(address,uint256,uint256,bytes)} can be used instead.
1889  */
1890 interface IERC1155721InventoryMintable {
1891     /**
1892      * Safely mints some token (ERC1155-compatible).
1893      * @dev Reverts if `to` is the zero address.
1894      * @dev Reverts if `id` is not a token.
1895      * @dev Reverts if `id` represents a non-fungible token and `value` is not 1.
1896      * @dev Reverts if `id` represents a non-fungible token which has already been minted.
1897      * @dev Reverts if `id` represents a fungible token and `value` is 0.
1898      * @dev Reverts if `id` represents a fungible token and there is an overflow of supply.
1899      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155Received} fails or is refused.
1900      * @dev Emits an {IERC721-Transfer} event from the zero address if `id` represents a non-fungible token.
1901      * @dev Emits an {IERC1155-TransferSingle} event from the zero address.
1902      * @param to Address of the new token owner.
1903      * @param id Identifier of the token to mint.
1904      * @param value Amount of token to mint.
1905      * @param data Optional data to send along to a receiver contract.
1906      */
1907     function safeMint(
1908         address to,
1909         uint256 id,
1910         uint256 value,
1911         bytes calldata data
1912     ) external;
1913 
1914     /**
1915      * Safely mints a batch of tokens (ERC1155-compatible).
1916      * @dev Reverts if `ids` and `values` have different lengths.
1917      * @dev Reverts if `to` is the zero address.
1918      * @dev Reverts if one of `ids` is not a token.
1919      * @dev Reverts if one of `ids` represents a non-fungible token and its paired value is not 1.
1920      * @dev Reverts if one of `ids` represents a non-fungible token which has already been minted.
1921      * @dev Reverts if one of `ids` represents a fungible token and its paired value is 0.
1922      * @dev Reverts if one of `ids` represents a fungible token and there is an overflow of supply.
1923      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
1924      * @dev Emits an {IERC721-Transfer} event from the zero address for each non-fungible token minted.
1925      * @dev Emits an {IERC1155-TransferBatch} event from the zero address.
1926      * @param to Address of the new tokens owner.
1927      * @param ids Identifiers of the tokens to mint.
1928      * @param values Amounts of tokens to mint.
1929      * @param data Optional data to send along to a receiver contract.
1930      */
1931     function safeBatchMint(
1932         address to,
1933         uint256[] calldata ids,
1934         uint256[] calldata values,
1935         bytes calldata data
1936     ) external;
1937 
1938     /**
1939      * Unsafely mints a Non-Fungible Token (ERC721-compatible).
1940      * @dev Reverts if `to` is the zero address.
1941      * @dev Reverts if `nftId` does not represent a non-fungible token.
1942      * @dev Reverts if `nftId` has already been minted.
1943      * @dev Emits an {IERC721-Transfer} event from the zero address.
1944      * @dev Emits an {IERC1155-TransferSingle} event from the zero address.
1945      * @dev If `to` is a contract and supports ERC1155TokenReceiver, calls {IERC1155TokenReceiver-onERC1155Received} with empty data.
1946      * @param to Address of the new token owner.
1947      * @param nftId Identifier of the token to mint.
1948      */
1949     function mint(address to, uint256 nftId) external;
1950 
1951     /**
1952      * Unsafely mints a batch of Non-Fungible Tokens (ERC721-compatible).
1953      * @dev Reverts if `to` is the zero address.
1954      * @dev Reverts if one of `nftIds` does not represent a non-fungible token.
1955      * @dev Reverts if one of `nftIds` has already been minted.
1956      * @dev Emits an {IERC721-Transfer} event from the zero address for each of `nftIds`.
1957      * @dev Emits an {IERC1155-TransferBatch} event from the zero address.
1958      * @dev If `to` is a contract and supports ERC1155TokenReceiver, calls {IERC1155TokenReceiver-onERC1155BatchReceived} with empty data.
1959      * @param to Address of the new token owner.
1960      * @param nftIds Identifiers of the tokens to mint.
1961      */
1962     function batchMint(address to, uint256[] calldata nftIds) external;
1963 
1964     /**
1965      * Safely mints a token (ERC721-compatible).
1966      * @dev Reverts if `to` is the zero address.
1967      * @dev Reverts if `tokenId` has already ben minted.
1968      * @dev Reverts if `to` is a contract which does not implement IERC721Receiver or IERC1155TokenReceiver.
1969      * @dev Reverts if `to` is an IERC1155TokenReceiver or IERC721TokenReceiver contract which refuses the transfer.
1970      * @dev Emits an {IERC721-Transfer} event from the zero address.
1971      * @dev Emits an {IERC1155-TransferSingle} event from the zero address.
1972      * @param to Address of the new token owner.
1973      * @param nftId Identifier of the token to mint.
1974      * @param data Optional data to pass along to the receiver call.
1975      */
1976     function safeMint(
1977         address to,
1978         uint256 nftId,
1979         bytes calldata data
1980     ) external;
1981 }
1982 
1983 
1984 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155InventoryCreator.sol@v7.1.0
1985 
1986 pragma solidity 0.6.8;
1987 
1988 /**
1989  * @title ERC-1155 Inventory, additional creator interface
1990  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1991  */
1992 interface IERC1155InventoryCreator {
1993     /**
1994      * Returns the creator of a collection, or the zero address if the collection has not been created.
1995      * @dev Reverts if `collectionId` does not represent a collection.
1996      * @param collectionId Identifier of the collection.
1997      * @return The creator of a collection, or the zero address if the collection has not been created.
1998      */
1999     function creator(uint256 collectionId) external view returns (address);
2000 }
2001 
2002 
2003 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
2004 
2005 pragma solidity >=0.6.0 <0.8.0;
2006 
2007 /**
2008  * @dev Contract module which provides a basic access control mechanism, where
2009  * there is an account (an owner) that can be granted exclusive access to
2010  * specific functions.
2011  *
2012  * By default, the owner account will be the one that deploys the contract. This
2013  * can later be changed with {transferOwnership}.
2014  *
2015  * This module is used through inheritance. It will make available the modifier
2016  * `onlyOwner`, which can be applied to your functions to restrict their use to
2017  * the owner.
2018  */
2019 abstract contract Ownable is Context {
2020     address private _owner;
2021 
2022     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2023 
2024     /**
2025      * @dev Initializes the contract setting the deployer as the initial owner.
2026      */
2027     constructor () internal {
2028         address msgSender = _msgSender();
2029         _owner = msgSender;
2030         emit OwnershipTransferred(address(0), msgSender);
2031     }
2032 
2033     /**
2034      * @dev Returns the address of the current owner.
2035      */
2036     function owner() public view returns (address) {
2037         return _owner;
2038     }
2039 
2040     /**
2041      * @dev Throws if called by any account other than the owner.
2042      */
2043     modifier onlyOwner() {
2044         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2045         _;
2046     }
2047 
2048     /**
2049      * @dev Leaves the contract without owner. It will not be possible to call
2050      * `onlyOwner` functions anymore. Can only be called by the current owner.
2051      *
2052      * NOTE: Renouncing ownership will leave the contract without an owner,
2053      * thereby removing any functionality that is only available to the owner.
2054      */
2055     function renounceOwnership() public virtual onlyOwner {
2056         emit OwnershipTransferred(_owner, address(0));
2057         _owner = address(0);
2058     }
2059 
2060     /**
2061      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2062      * Can only be called by the current owner.
2063      */
2064     function transferOwnership(address newOwner) public virtual onlyOwner {
2065         require(newOwner != address(0), "Ownable: new owner is the zero address");
2066         emit OwnershipTransferred(_owner, newOwner);
2067         _owner = newOwner;
2068     }
2069 }
2070 
2071 
2072 // File @animoca/ethereum-contracts-core_library/contracts/utils/types/UInt256ToDecimalString.sol@v4.0.2
2073 
2074 pragma solidity 0.6.8;
2075 
2076 library UInt256ToDecimalString {
2077     function toDecimalString(uint256 value) internal pure returns (string memory) {
2078         // Inspired by OpenZeppelin's String.toString() implementation - MIT licence
2079         // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/8b10cb38d8fedf34f2d89b0ed604f2dceb76d6a9/contracts/utils/Strings.sol
2080         if (value == 0) {
2081             return "0";
2082         }
2083         uint256 temp = value;
2084         uint256 digits;
2085         while (temp != 0) {
2086             digits++;
2087             temp /= 10;
2088         }
2089         bytes memory buffer = new bytes(digits);
2090         uint256 index = digits - 1;
2091         temp = value;
2092         while (temp != 0) {
2093             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
2094             temp /= 10;
2095         }
2096         return string(buffer);
2097     }
2098 }
2099 
2100 
2101 // File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/BaseMetadataURI.sol@v7.1.0
2102 
2103 pragma solidity 0.6.8;
2104 
2105 
2106 contract BaseMetadataURI is Ownable {
2107     using UInt256ToDecimalString for uint256;
2108 
2109     event BaseMetadataURISet(string baseMetadataURI);
2110 
2111     string public baseMetadataURI;
2112 
2113     function setBaseMetadataURI(string calldata baseMetadataURI_) external onlyOwner {
2114         baseMetadataURI = baseMetadataURI_;
2115         emit BaseMetadataURISet(baseMetadataURI_);
2116     }
2117 
2118     function _uri(uint256 id) internal view virtual returns (string memory) {
2119         return string(abi.encodePacked(baseMetadataURI, id.toDecimalString()));
2120     }
2121 }
2122 
2123 
2124 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.3.0
2125 
2126 pragma solidity >=0.6.0 <0.8.0;
2127 
2128 /**
2129  * @dev Library for managing
2130  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2131  * types.
2132  *
2133  * Sets have the following properties:
2134  *
2135  * - Elements are added, removed, and checked for existence in constant time
2136  * (O(1)).
2137  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2138  *
2139  * ```
2140  * contract Example {
2141  *     // Add the library methods
2142  *     using EnumerableSet for EnumerableSet.AddressSet;
2143  *
2144  *     // Declare a set state variable
2145  *     EnumerableSet.AddressSet private mySet;
2146  * }
2147  * ```
2148  *
2149  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2150  * and `uint256` (`UintSet`) are supported.
2151  */
2152 library EnumerableSet {
2153     // To implement this library for multiple types with as little code
2154     // repetition as possible, we write it in terms of a generic Set type with
2155     // bytes32 values.
2156     // The Set implementation uses private functions, and user-facing
2157     // implementations (such as AddressSet) are just wrappers around the
2158     // underlying Set.
2159     // This means that we can only create new EnumerableSets for types that fit
2160     // in bytes32.
2161 
2162     struct Set {
2163         // Storage of set values
2164         bytes32[] _values;
2165 
2166         // Position of the value in the `values` array, plus 1 because index 0
2167         // means a value is not in the set.
2168         mapping (bytes32 => uint256) _indexes;
2169     }
2170 
2171     /**
2172      * @dev Add a value to a set. O(1).
2173      *
2174      * Returns true if the value was added to the set, that is if it was not
2175      * already present.
2176      */
2177     function _add(Set storage set, bytes32 value) private returns (bool) {
2178         if (!_contains(set, value)) {
2179             set._values.push(value);
2180             // The value is stored at length-1, but we add 1 to all indexes
2181             // and use 0 as a sentinel value
2182             set._indexes[value] = set._values.length;
2183             return true;
2184         } else {
2185             return false;
2186         }
2187     }
2188 
2189     /**
2190      * @dev Removes a value from a set. O(1).
2191      *
2192      * Returns true if the value was removed from the set, that is if it was
2193      * present.
2194      */
2195     function _remove(Set storage set, bytes32 value) private returns (bool) {
2196         // We read and store the value's index to prevent multiple reads from the same storage slot
2197         uint256 valueIndex = set._indexes[value];
2198 
2199         if (valueIndex != 0) { // Equivalent to contains(set, value)
2200             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2201             // the array, and then remove the last element (sometimes called as 'swap and pop').
2202             // This modifies the order of the array, as noted in {at}.
2203 
2204             uint256 toDeleteIndex = valueIndex - 1;
2205             uint256 lastIndex = set._values.length - 1;
2206 
2207             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
2208             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
2209 
2210             bytes32 lastvalue = set._values[lastIndex];
2211 
2212             // Move the last value to the index where the value to delete is
2213             set._values[toDeleteIndex] = lastvalue;
2214             // Update the index for the moved value
2215             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
2216 
2217             // Delete the slot where the moved value was stored
2218             set._values.pop();
2219 
2220             // Delete the index for the deleted slot
2221             delete set._indexes[value];
2222 
2223             return true;
2224         } else {
2225             return false;
2226         }
2227     }
2228 
2229     /**
2230      * @dev Returns true if the value is in the set. O(1).
2231      */
2232     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2233         return set._indexes[value] != 0;
2234     }
2235 
2236     /**
2237      * @dev Returns the number of values on the set. O(1).
2238      */
2239     function _length(Set storage set) private view returns (uint256) {
2240         return set._values.length;
2241     }
2242 
2243    /**
2244     * @dev Returns the value stored at position `index` in the set. O(1).
2245     *
2246     * Note that there are no guarantees on the ordering of values inside the
2247     * array, and it may change when more values are added or removed.
2248     *
2249     * Requirements:
2250     *
2251     * - `index` must be strictly less than {length}.
2252     */
2253     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2254         require(set._values.length > index, "EnumerableSet: index out of bounds");
2255         return set._values[index];
2256     }
2257 
2258     // Bytes32Set
2259 
2260     struct Bytes32Set {
2261         Set _inner;
2262     }
2263 
2264     /**
2265      * @dev Add a value to a set. O(1).
2266      *
2267      * Returns true if the value was added to the set, that is if it was not
2268      * already present.
2269      */
2270     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2271         return _add(set._inner, value);
2272     }
2273 
2274     /**
2275      * @dev Removes a value from a set. O(1).
2276      *
2277      * Returns true if the value was removed from the set, that is if it was
2278      * present.
2279      */
2280     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2281         return _remove(set._inner, value);
2282     }
2283 
2284     /**
2285      * @dev Returns true if the value is in the set. O(1).
2286      */
2287     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2288         return _contains(set._inner, value);
2289     }
2290 
2291     /**
2292      * @dev Returns the number of values in the set. O(1).
2293      */
2294     function length(Bytes32Set storage set) internal view returns (uint256) {
2295         return _length(set._inner);
2296     }
2297 
2298    /**
2299     * @dev Returns the value stored at position `index` in the set. O(1).
2300     *
2301     * Note that there are no guarantees on the ordering of values inside the
2302     * array, and it may change when more values are added or removed.
2303     *
2304     * Requirements:
2305     *
2306     * - `index` must be strictly less than {length}.
2307     */
2308     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2309         return _at(set._inner, index);
2310     }
2311 
2312     // AddressSet
2313 
2314     struct AddressSet {
2315         Set _inner;
2316     }
2317 
2318     /**
2319      * @dev Add a value to a set. O(1).
2320      *
2321      * Returns true if the value was added to the set, that is if it was not
2322      * already present.
2323      */
2324     function add(AddressSet storage set, address value) internal returns (bool) {
2325         return _add(set._inner, bytes32(uint256(value)));
2326     }
2327 
2328     /**
2329      * @dev Removes a value from a set. O(1).
2330      *
2331      * Returns true if the value was removed from the set, that is if it was
2332      * present.
2333      */
2334     function remove(AddressSet storage set, address value) internal returns (bool) {
2335         return _remove(set._inner, bytes32(uint256(value)));
2336     }
2337 
2338     /**
2339      * @dev Returns true if the value is in the set. O(1).
2340      */
2341     function contains(AddressSet storage set, address value) internal view returns (bool) {
2342         return _contains(set._inner, bytes32(uint256(value)));
2343     }
2344 
2345     /**
2346      * @dev Returns the number of values in the set. O(1).
2347      */
2348     function length(AddressSet storage set) internal view returns (uint256) {
2349         return _length(set._inner);
2350     }
2351 
2352    /**
2353     * @dev Returns the value stored at position `index` in the set. O(1).
2354     *
2355     * Note that there are no guarantees on the ordering of values inside the
2356     * array, and it may change when more values are added or removed.
2357     *
2358     * Requirements:
2359     *
2360     * - `index` must be strictly less than {length}.
2361     */
2362     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2363         return address(uint256(_at(set._inner, index)));
2364     }
2365 
2366 
2367     // UintSet
2368 
2369     struct UintSet {
2370         Set _inner;
2371     }
2372 
2373     /**
2374      * @dev Add a value to a set. O(1).
2375      *
2376      * Returns true if the value was added to the set, that is if it was not
2377      * already present.
2378      */
2379     function add(UintSet storage set, uint256 value) internal returns (bool) {
2380         return _add(set._inner, bytes32(value));
2381     }
2382 
2383     /**
2384      * @dev Removes a value from a set. O(1).
2385      *
2386      * Returns true if the value was removed from the set, that is if it was
2387      * present.
2388      */
2389     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2390         return _remove(set._inner, bytes32(value));
2391     }
2392 
2393     /**
2394      * @dev Returns true if the value is in the set. O(1).
2395      */
2396     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2397         return _contains(set._inner, bytes32(value));
2398     }
2399 
2400     /**
2401      * @dev Returns the number of values on the set. O(1).
2402      */
2403     function length(UintSet storage set) internal view returns (uint256) {
2404         return _length(set._inner);
2405     }
2406 
2407    /**
2408     * @dev Returns the value stored at position `index` in the set. O(1).
2409     *
2410     * Note that there are no guarantees on the ordering of values inside the
2411     * array, and it may change when more values are added or removed.
2412     *
2413     * Requirements:
2414     *
2415     * - `index` must be strictly less than {length}.
2416     */
2417     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2418         return uint256(_at(set._inner, index));
2419     }
2420 }
2421 
2422 
2423 // File @openzeppelin/contracts/access/AccessControl.sol@v3.3.0
2424 
2425 pragma solidity >=0.6.0 <0.8.0;
2426 
2427 
2428 
2429 /**
2430  * @dev Contract module that allows children to implement role-based access
2431  * control mechanisms.
2432  *
2433  * Roles are referred to by their `bytes32` identifier. These should be exposed
2434  * in the external API and be unique. The best way to achieve this is by
2435  * using `public constant` hash digests:
2436  *
2437  * ```
2438  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2439  * ```
2440  *
2441  * Roles can be used to represent a set of permissions. To restrict access to a
2442  * function call, use {hasRole}:
2443  *
2444  * ```
2445  * function foo() public {
2446  *     require(hasRole(MY_ROLE, msg.sender));
2447  *     ...
2448  * }
2449  * ```
2450  *
2451  * Roles can be granted and revoked dynamically via the {grantRole} and
2452  * {revokeRole} functions. Each role has an associated admin role, and only
2453  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2454  *
2455  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2456  * that only accounts with this role will be able to grant or revoke other
2457  * roles. More complex role relationships can be created by using
2458  * {_setRoleAdmin}.
2459  *
2460  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2461  * grant and revoke this role. Extra precautions should be taken to secure
2462  * accounts that have been granted it.
2463  */
2464 abstract contract AccessControl is Context {
2465     using EnumerableSet for EnumerableSet.AddressSet;
2466     using Address for address;
2467 
2468     struct RoleData {
2469         EnumerableSet.AddressSet members;
2470         bytes32 adminRole;
2471     }
2472 
2473     mapping (bytes32 => RoleData) private _roles;
2474 
2475     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2476 
2477     /**
2478      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2479      *
2480      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2481      * {RoleAdminChanged} not being emitted signaling this.
2482      *
2483      * _Available since v3.1._
2484      */
2485     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2486 
2487     /**
2488      * @dev Emitted when `account` is granted `role`.
2489      *
2490      * `sender` is the account that originated the contract call, an admin role
2491      * bearer except when using {_setupRole}.
2492      */
2493     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2494 
2495     /**
2496      * @dev Emitted when `account` is revoked `role`.
2497      *
2498      * `sender` is the account that originated the contract call:
2499      *   - if using `revokeRole`, it is the admin role bearer
2500      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2501      */
2502     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2503 
2504     /**
2505      * @dev Returns `true` if `account` has been granted `role`.
2506      */
2507     function hasRole(bytes32 role, address account) public view returns (bool) {
2508         return _roles[role].members.contains(account);
2509     }
2510 
2511     /**
2512      * @dev Returns the number of accounts that have `role`. Can be used
2513      * together with {getRoleMember} to enumerate all bearers of a role.
2514      */
2515     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
2516         return _roles[role].members.length();
2517     }
2518 
2519     /**
2520      * @dev Returns one of the accounts that have `role`. `index` must be a
2521      * value between 0 and {getRoleMemberCount}, non-inclusive.
2522      *
2523      * Role bearers are not sorted in any particular way, and their ordering may
2524      * change at any point.
2525      *
2526      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2527      * you perform all queries on the same block. See the following
2528      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2529      * for more information.
2530      */
2531     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
2532         return _roles[role].members.at(index);
2533     }
2534 
2535     /**
2536      * @dev Returns the admin role that controls `role`. See {grantRole} and
2537      * {revokeRole}.
2538      *
2539      * To change a role's admin, use {_setRoleAdmin}.
2540      */
2541     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
2542         return _roles[role].adminRole;
2543     }
2544 
2545     /**
2546      * @dev Grants `role` to `account`.
2547      *
2548      * If `account` had not been already granted `role`, emits a {RoleGranted}
2549      * event.
2550      *
2551      * Requirements:
2552      *
2553      * - the caller must have ``role``'s admin role.
2554      */
2555     function grantRole(bytes32 role, address account) public virtual {
2556         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
2557 
2558         _grantRole(role, account);
2559     }
2560 
2561     /**
2562      * @dev Revokes `role` from `account`.
2563      *
2564      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2565      *
2566      * Requirements:
2567      *
2568      * - the caller must have ``role``'s admin role.
2569      */
2570     function revokeRole(bytes32 role, address account) public virtual {
2571         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
2572 
2573         _revokeRole(role, account);
2574     }
2575 
2576     /**
2577      * @dev Revokes `role` from the calling account.
2578      *
2579      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2580      * purpose is to provide a mechanism for accounts to lose their privileges
2581      * if they are compromised (such as when a trusted device is misplaced).
2582      *
2583      * If the calling account had been granted `role`, emits a {RoleRevoked}
2584      * event.
2585      *
2586      * Requirements:
2587      *
2588      * - the caller must be `account`.
2589      */
2590     function renounceRole(bytes32 role, address account) public virtual {
2591         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2592 
2593         _revokeRole(role, account);
2594     }
2595 
2596     /**
2597      * @dev Grants `role` to `account`.
2598      *
2599      * If `account` had not been already granted `role`, emits a {RoleGranted}
2600      * event. Note that unlike {grantRole}, this function doesn't perform any
2601      * checks on the calling account.
2602      *
2603      * [WARNING]
2604      * ====
2605      * This function should only be called from the constructor when setting
2606      * up the initial roles for the system.
2607      *
2608      * Using this function in any other way is effectively circumventing the admin
2609      * system imposed by {AccessControl}.
2610      * ====
2611      */
2612     function _setupRole(bytes32 role, address account) internal virtual {
2613         _grantRole(role, account);
2614     }
2615 
2616     /**
2617      * @dev Sets `adminRole` as ``role``'s admin role.
2618      *
2619      * Emits a {RoleAdminChanged} event.
2620      */
2621     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2622         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
2623         _roles[role].adminRole = adminRole;
2624     }
2625 
2626     function _grantRole(bytes32 role, address account) private {
2627         if (_roles[role].members.add(account)) {
2628             emit RoleGranted(role, account, _msgSender());
2629         }
2630     }
2631 
2632     function _revokeRole(bytes32 role, address account) private {
2633         if (_roles[role].members.remove(account)) {
2634             emit RoleRevoked(role, account, _msgSender());
2635         }
2636     }
2637 }
2638 
2639 
2640 // File @animoca/ethereum-contracts-core_library/contracts/access/MinterRole.sol@v4.0.2
2641 
2642 pragma solidity 0.6.8;
2643 
2644 /**
2645  * Contract module which allows derived contracts access control over token
2646  * minting operations.
2647  *
2648  * This module is used through inheritance. It will make available the modifier
2649  * `onlyMinter`, which can be applied to the minting functions of your contract.
2650  * Those functions will only be accessible to accounts with the minter role
2651  * once the modifer is put in place.
2652  */
2653 contract MinterRole is AccessControl {
2654     event MinterAdded(address indexed account);
2655     event MinterRemoved(address indexed account);
2656 
2657     /**
2658      * Modifier to make a function callable only by accounts with the minter role.
2659      */
2660     modifier onlyMinter() {
2661         require(isMinter(_msgSender()), "MinterRole: not a Minter");
2662         _;
2663     }
2664 
2665     /**
2666      * Constructor.
2667      */
2668     constructor() internal {
2669         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2670         emit MinterAdded(_msgSender());
2671     }
2672 
2673     /**
2674      * Validates whether or not the given account has been granted the minter role.
2675      * @param account The account to validate.
2676      * @return True if the account has been granted the minter role, false otherwise.
2677      */
2678     function isMinter(address account) public view returns (bool) {
2679         return hasRole(DEFAULT_ADMIN_ROLE, account);
2680     }
2681 
2682     /**
2683      * Grants the minter role to a non-minter.
2684      * @param account The account to grant the minter role to.
2685      */
2686     function addMinter(address account) public onlyMinter {
2687         require(!isMinter(account), "MinterRole: already Minter");
2688         grantRole(DEFAULT_ADMIN_ROLE, account);
2689         emit MinterAdded(account);
2690     }
2691 
2692     /**
2693      * Renounces the granted minter role.
2694      */
2695     function renounceMinter() public onlyMinter {
2696         renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
2697         emit MinterRemoved(_msgSender());
2698     }
2699 }
2700 
2701 
2702 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
2703 
2704 pragma solidity >=0.6.0 <0.8.0;
2705 
2706 /**
2707  * @dev Contract module which allows children to implement an emergency stop
2708  * mechanism that can be triggered by an authorized account.
2709  *
2710  * This module is used through inheritance. It will make available the
2711  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2712  * the functions of your contract. Note that they will not be pausable by
2713  * simply including this module, only once the modifiers are put in place.
2714  */
2715 abstract contract Pausable is Context {
2716     /**
2717      * @dev Emitted when the pause is triggered by `account`.
2718      */
2719     event Paused(address account);
2720 
2721     /**
2722      * @dev Emitted when the pause is lifted by `account`.
2723      */
2724     event Unpaused(address account);
2725 
2726     bool private _paused;
2727 
2728     /**
2729      * @dev Initializes the contract in unpaused state.
2730      */
2731     constructor () internal {
2732         _paused = false;
2733     }
2734 
2735     /**
2736      * @dev Returns true if the contract is paused, and false otherwise.
2737      */
2738     function paused() public view returns (bool) {
2739         return _paused;
2740     }
2741 
2742     /**
2743      * @dev Modifier to make a function callable only when the contract is not paused.
2744      *
2745      * Requirements:
2746      *
2747      * - The contract must not be paused.
2748      */
2749     modifier whenNotPaused() {
2750         require(!_paused, "Pausable: paused");
2751         _;
2752     }
2753 
2754     /**
2755      * @dev Modifier to make a function callable only when the contract is paused.
2756      *
2757      * Requirements:
2758      *
2759      * - The contract must be paused.
2760      */
2761     modifier whenPaused() {
2762         require(_paused, "Pausable: not paused");
2763         _;
2764     }
2765 
2766     /**
2767      * @dev Triggers stopped state.
2768      *
2769      * Requirements:
2770      *
2771      * - The contract must not be paused.
2772      */
2773     function _pause() internal virtual whenNotPaused {
2774         _paused = true;
2775         emit Paused(_msgSender());
2776     }
2777 
2778     /**
2779      * @dev Returns to normal state.
2780      *
2781      * Requirements:
2782      *
2783      * - The contract must be paused.
2784      */
2785     function _unpause() internal virtual whenPaused {
2786         _paused = false;
2787         emit Unpaused(_msgSender());
2788     }
2789 }
2790 
2791 
2792 // File contracts/solc-0.6/token/ERC1155721/REVVInventory.sol
2793 
2794 pragma solidity ^0.6.8;
2795 
2796 
2797 
2798 
2799 
2800 
2801 
2802 contract REVVInventory is
2803     Ownable,
2804     Pausable,
2805     ERC1155721InventoryBurnable,
2806     IERC1155721InventoryMintable,
2807     IERC1155InventoryCreator,
2808     BaseMetadataURI,
2809     MinterRole
2810 {
2811     // solhint-disable-next-line const-name-snakecase
2812     string public constant override name = "REVV Inventory";
2813     // solhint-disable-next-line const-name-snakecase
2814     string public constant override symbol = "REVV-I";
2815 
2816     //================================== ERC1155MetadataURI =======================================/
2817 
2818     /// @dev See {IERC1155MetadataURI-uri(uint256)}.
2819     function uri(uint256 id) public view virtual override returns (string memory) {
2820         return _uri(id);
2821     }
2822 
2823     //================================== ERC1155InventoryCreator =======================================/
2824 
2825     /// @dev See {IERC1155InventoryCreator-creator(uint256)}.
2826     function creator(uint256 collectionId) external view override returns (address) {
2827         return _creator(collectionId);
2828     }
2829 
2830     // ===================================================================================================
2831     //                               Admin Public Functions
2832     // ===================================================================================================
2833 
2834     //================================== Pausable =======================================/
2835 
2836     function pause() external virtual {
2837         require(owner() == _msgSender(), "Inventory: not the owner");
2838         _pause();
2839     }
2840 
2841     function unpause() external virtual {
2842         require(owner() == _msgSender(), "Inventory: not the owner");
2843         _unpause();
2844     }
2845 
2846     //================================== ERC1155Inventory =======================================/
2847 
2848     /**
2849      * Creates a collection.
2850      * @dev Reverts if `collectionId` does not represent a collection.
2851      * @dev Reverts if `collectionId` has already been created.
2852      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
2853      * @param collectionId Identifier of the collection.
2854      */
2855     function createCollection(uint256 collectionId) external onlyOwner {
2856         _createCollection(collectionId);
2857     }
2858 
2859     //================================== ERC1155721InventoryMintable =======================================/
2860 
2861     /**
2862      * Unsafely mints a Non-Fungible Token (ERC721-compatible).
2863      * @dev See {IERC1155721InventoryMintable-batchMint(address,uint256)}.
2864      */
2865     function mint(address to, uint256 nftId) public virtual override {
2866         require(isMinter(_msgSender()), "Inventory: not a minter");
2867         _mint(to, nftId, "", false);
2868     }
2869 
2870     /**
2871      * Unsafely mints a batch of Non-Fungible Tokens (ERC721-compatible).
2872      * @dev See {IERC1155721InventoryMintable-batchMint(address,uint256[])}.
2873      */
2874     function batchMint(address to, uint256[] memory nftIds) public virtual override {
2875         require(isMinter(_msgSender()), "Inventory: not a minter");
2876         _batchMint(to, nftIds);
2877     }
2878 
2879     /**
2880      * Safely mints a Non-Fungible Token (ERC721-compatible).
2881      * @dev See {IERC1155721InventoryMintable-safeMint(address,uint256,bytes)}.
2882      */
2883     function safeMint(
2884         address to,
2885         uint256 nftId,
2886         bytes memory data
2887     ) public virtual override {
2888         require(isMinter(_msgSender()), "Inventory: not a minter");
2889         _mint(to, nftId, data, true);
2890     }
2891 
2892     /**
2893      * Safely mints some token (ERC1155-compatible).
2894      * @dev See {IERC1155721InventoryMintable-safeMint(address,uint256,uint256,bytes)}.
2895      */
2896     function safeMint(
2897         address to,
2898         uint256 id,
2899         uint256 value,
2900         bytes memory data
2901     ) public virtual override {
2902         require(isMinter(_msgSender()), "Inventory: not a minter");
2903         _safeMint(to, id, value, data);
2904     }
2905 
2906     /**
2907      * Safely mints a batch of tokens (ERC1155-compatible).
2908      * @dev See {IERC1155721InventoryMintable-safeBatchMint(address,uint256[],uint256[],bytes)}.
2909      */
2910     function safeBatchMint(
2911         address to,
2912         uint256[] memory ids,
2913         uint256[] memory values,
2914         bytes memory data
2915     ) public virtual override {
2916         require(isMinter(_msgSender()), "Inventory: not a minter");
2917         _safeBatchMint(to, ids, values, data);
2918     }
2919 
2920     //================================== ERC721 =======================================/
2921 
2922     function transferFrom(
2923         address from,
2924         address to,
2925         uint256 nftId
2926     ) public virtual override {
2927         require(!paused(), "Inventory: paused");
2928         super.transferFrom(from, to, nftId);
2929     }
2930 
2931     function batchTransferFrom(
2932         address from,
2933         address to,
2934         uint256[] memory nftIds
2935     ) public virtual override {
2936         require(!paused(), "Inventory: paused");
2937         super.batchTransferFrom(from, to, nftIds);
2938     }
2939 
2940     function safeTransferFrom(
2941         address from,
2942         address to,
2943         uint256 nftId
2944     ) public virtual override {
2945         require(!paused(), "Inventory: paused");
2946         super.safeTransferFrom(from, to, nftId);
2947     }
2948 
2949     function safeTransferFrom(
2950         address from,
2951         address to,
2952         uint256 nftId,
2953         bytes memory data
2954     ) public virtual override {
2955         require(!paused(), "Inventory: paused");
2956         super.safeTransferFrom(from, to, nftId, data);
2957     }
2958 
2959     function batchBurnFrom(address from, uint256[] memory nftIds) public virtual override {
2960         require(!paused(), "Inventory: paused");
2961         super.batchBurnFrom(from, nftIds);
2962     }
2963 
2964     //================================== ERC1155 =======================================/
2965 
2966     function safeTransferFrom(
2967         address from,
2968         address to,
2969         uint256 id,
2970         uint256 value,
2971         bytes memory data
2972     ) public virtual override {
2973         require(!paused(), "Inventory: paused");
2974         super.safeTransferFrom(from, to, id, value, data);
2975     }
2976 
2977     function safeBatchTransferFrom(
2978         address from,
2979         address to,
2980         uint256[] memory ids,
2981         uint256[] memory values,
2982         bytes memory data
2983     ) public virtual override {
2984         require(!paused(), "Inventory: paused");
2985         super.safeBatchTransferFrom(from, to, ids, values, data);
2986     }
2987 
2988     function burnFrom(
2989         address from,
2990         uint256 id,
2991         uint256 value
2992     ) public virtual override {
2993         require(!paused(), "Inventory: paused");
2994         super.burnFrom(from, id, value);
2995     }
2996 
2997     function batchBurnFrom(
2998         address from,
2999         uint256[] memory ids,
3000         uint256[] memory values
3001     ) public virtual override {
3002         require(!paused(), "Inventory: paused");
3003         super.batchBurnFrom(from, ids, values);
3004     }
3005 }