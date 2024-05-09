1 // SPDX-License-Identifier: MIT
2 /*
3             _____           __  .__    .__
4            /     \ ___.__._/  |_|  |__ |__| ____
5           /  \ /  <   |  |\   __\  |  \|  |/ ___\
6          /    Y    \___  | |  | |   Y  \  \  \___
7          \____|__  / ____| |__| |___|  /__|\___  >
8                  \/\/                \/        \/
9       ____.
10      |    | ____  __ _________  ____   ____ ___.__. ______
11      |    |/  _ \|  |  \_  __ \/    \_/ __ <   |  |/  ___/
12  /\__|    (  <_> )  |  /|  | \/   |  \  ___/\___  |\___ \
13  \________|\____/|____/ |__|  |___|  /\___  > ____/____  >
14                                    \/     \/\/         \/
15 
16  Mythic Gateways contract for ApeLiquid.io | December 2022
17 
18   Massive on-chain web3 turn-based Role-playing Game (RPG)
19 
20           THE MYTHIC JOURNEY EVENT GENERATOR
21 
22        Written by https://twitter.com/aleph0ne
23 
24 */
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
30 */
31 interface ERC1155TokenReceiver {
32     /**
33         @notice Handle the receipt of a single ERC1155 token type.
34         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
35         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
36         This function MUST revert if it rejects the transfer.
37         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
38         @param _operator  The address which initiated the transfer (i.e. msg.sender)
39         @param _from      The address which previously owned the token
40         @param _id        The ID of the token being transferred
41         @param _value     The amount of tokens being transferred
42         @param _data      Additional data with no specified format
43         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
44     */
45     function onERC1155Received(
46         address _operator,
47         address _from,
48         uint256 _id,
49         uint256 _value,
50         bytes calldata _data
51     ) external returns (bytes4);
52 
53     /**
54         @notice Handle the receipt of multiple ERC1155 token types.
55         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
56         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
57         This function MUST revert if it rejects the transfer(s).
58         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
59         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
60         @param _from      The address which previously owned the token
61         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
62         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
63         @param _data      Additional data with no specified format
64         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
65     */
66     function onERC1155BatchReceived(
67         address _operator,
68         address _from,
69         uint256[] calldata _ids,
70         uint256[] calldata _values,
71         bytes calldata _data
72     ) external returns (bytes4);
73 }
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78     @title ERC-1155 Multi Token Standard
79     @dev See https://eips.ethereum.org/EIPS/eip-1155
80     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
81  */
82 /* is ERC165 */
83 interface ERC1155 {
84     /**
85         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
86         The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
87         The `_from` argument MUST be the address of the holder whose balance is decreased.
88         The `_to` argument MUST be the address of the recipient whose balance is increased.
89         The `_id` argument MUST be the token type being transferred.
90         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
91         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
92         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
93     */
94     event TransferSingle(
95         address indexed _operator,
96         address indexed _from,
97         address indexed _to,
98         uint256 _id,
99         uint256 _value
100     );
101 
102     /**
103         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
104         The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
105         The `_from` argument MUST be the address of the holder whose balance is decreased.
106         The `_to` argument MUST be the address of the recipient whose balance is increased.
107         The `_ids` argument MUST be the list of tokens being transferred.
108         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
109         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
110         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
111     */
112     event TransferBatch(
113         address indexed _operator,
114         address indexed _from,
115         address indexed _to,
116         uint256[] _ids,
117         uint256[] _values
118     );
119 
120     /**
121         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).
122     */
123     event ApprovalForAll(
124         address indexed _owner,
125         address indexed _operator,
126         bool _approved
127     );
128 
129     /**
130         @dev MUST emit when the URI is updated for a token ID.
131         URIs are defined in RFC 3986.
132         The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
133     */
134     event URI(string _value, uint256 indexed _id);
135 
136     /**
137         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
138         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
139         MUST revert if `_to` is the zero address.
140         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
141         MUST revert on any other error.
142         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
143         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
144         @param _from    Source address
145         @param _to      Target address
146         @param _id      ID of the token type
147         @param _value   Transfer amount
148         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
149     */
150     function safeTransferFrom(
151         address _from,
152         address _to,
153         uint256 _id,
154         uint256 _value,
155         bytes calldata _data
156     ) external;
157 
158     /**
159         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
160         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
161         MUST revert if `_to` is the zero address.
162         MUST revert if length of `_ids` is not the same as length of `_values`.
163         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
164         MUST revert on any other error.
165         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
166         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
167         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
168         @param _from    Source address
169         @param _to      Target address
170         @param _ids     IDs of each token type (order and length must match _values array)
171         @param _values  Transfer amounts per token type (order and length must match _ids array)
172         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
173     */
174     function safeBatchTransferFrom(
175         address _from,
176         address _to,
177         uint256[] calldata _ids,
178         uint256[] calldata _values,
179         bytes calldata _data
180     ) external;
181 
182     /**
183         @notice Get the balance of an account's tokens.
184         @param _owner  The address of the token holder
185         @param _id     ID of the token
186         @return        The _owner's balance of the token type requested
187      */
188     function balanceOf(address _owner, uint256 _id)
189         external
190         view
191         returns (uint256);
192 
193     /**
194         @notice Get the balance of multiple account/token pairs
195         @param _owners The addresses of the token holders
196         @param _ids    ID of the tokens
197         @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
198      */
199     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
200         external
201         view
202         returns (uint256[] memory);
203 
204     /**
205         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
206         @dev MUST emit the ApprovalForAll event on success.
207         @param _operator  Address to add to the set of authorized operators
208         @param _approved  True if the operator is approved, false to revoke approval
209     */
210     function setApprovalForAll(address _operator, bool _approved) external;
211 
212     /**
213         @notice Queries the approval status of an operator for a given owner.
214         @param _owner     The owner of the tokens
215         @param _operator  Address of authorized operator
216         @return           True if the operator is approved, false if not
217     */
218     function isApprovedForAll(address _owner, address _operator)
219         external
220         view
221         returns (bool);
222 }
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface of the ERC165 standard, as defined in the
228  * https://eips.ethereum.org/EIPS/eip-165[EIP].
229  *
230  * Implementers can declare support of contract interfaces, which can then be
231  * queried by others ({ERC165Checker}).
232  *
233  * For an implementation, see {ERC165}.
234  */
235 interface IERC165 {
236     /**
237      * @dev Returns true if this contract implements the interface defined by
238      * `interfaceId`. See the corresponding
239      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
240      * to learn more about how these ids are created.
241      *
242      * This function call must use less than 30 000 gas.
243      */
244     function supportsInterface(bytes4 interfaceId) external view returns (bool);
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Implementation of the {IERC165} interface.
251  *
252  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
253  * for the additional interface id that will be supported. For example:
254  *
255  * ```solidity
256  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
257  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
258  * }
259  * ```
260  *
261  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
262  */
263 abstract contract ERC165 is IERC165 {
264     /**
265      * @dev See {IERC165-supportsInterface}.
266      */
267     function supportsInterface(bytes4 interfaceId)
268         public
269         view
270         virtual
271         override
272         returns (bool)
273     {
274         return interfaceId == type(IERC165).interfaceId;
275     }
276 }
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev String operations.
282  */
283 library Strings {
284     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
288      */
289     function toString(uint256 value) internal pure returns (string memory) {
290         // Inspired by OraclizeAPI's implementation - MIT licence
291         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
292 
293         if (value == 0) {
294             return "0";
295         }
296         uint256 temp = value;
297         uint256 digits;
298         while (temp != 0) {
299             digits++;
300             temp /= 10;
301         }
302         bytes memory buffer = new bytes(digits);
303         while (value != 0) {
304             digits -= 1;
305             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
306             value /= 10;
307         }
308         return string(buffer);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
313      */
314     function toHexString(uint256 value) internal pure returns (string memory) {
315         if (value == 0) {
316             return "0x00";
317         }
318         uint256 temp = value;
319         uint256 length = 0;
320         while (temp != 0) {
321             length++;
322             temp >>= 8;
323         }
324         return toHexString(value, length);
325     }
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
329      */
330     function toHexString(uint256 value, uint256 length)
331         internal
332         pure
333         returns (string memory)
334     {
335         bytes memory buffer = new bytes(2 * length + 2);
336         buffer[0] = "0";
337         buffer[1] = "x";
338         for (uint256 i = 2 * length + 1; i > 1; --i) {
339             buffer[i] = _HEX_SYMBOLS[value & 0xf];
340             value >>= 4;
341         }
342         require(value == 0, "Strings: hex length insufficient");
343         return string(buffer);
344     }
345 }
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @dev Provides information about the current execution context, including the
351  * sender of the transaction and its data. While these are generally available
352  * via msg.sender and msg.data, they should not be accessed in such a direct
353  * manner, since when dealing with meta-transactions the account sending and
354  * paying for execution may not be the actual sender (as far as an application
355  * is concerned).
356  *
357  * This contract is only required for intermediate, library-like contracts.
358  */
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes calldata) {
365         return msg.data;
366     }
367 }
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Collection of functions related to the address type
373  */
374 library Address {
375     /**
376      * @dev Returns true if `account` is a contract.
377      *
378      * [IMPORTANT]
379      * ====
380      * It is unsafe to assume that an address for which this function returns
381      * false is an externally-owned account (EOA) and not a contract.
382      *
383      * Among others, `isContract` will return false for the following
384      * types of addresses:
385      *
386      *  - an externally-owned account
387      *  - a contract in construction
388      *  - an address where a contract will be created
389      *  - an address where a contract lived, but was destroyed
390      * ====
391      */
392     function isContract(address account) internal view returns (bool) {
393         // This method relies on extcodesize, which returns 0 for contracts in
394         // construction, since the code is only stored at the end of the
395         // constructor execution.
396 
397         uint256 size;
398         assembly {
399             size := extcodesize(account)
400         }
401         return size > 0;
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(
422             address(this).balance >= amount,
423             "Address: insufficient balance"
424         );
425 
426         (bool success, ) = recipient.call{value: amount}("");
427         require(
428             success,
429             "Address: unable to send value, recipient may have reverted"
430         );
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data)
452         internal
453         returns (bytes memory)
454     {
455         return functionCall(target, data, "Address: low-level call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
460      * `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value
487     ) internal returns (bytes memory) {
488         return
489             functionCallWithValue(
490                 target,
491                 data,
492                 value,
493                 "Address: low-level call with value failed"
494             );
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
499      * with `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(
510             address(this).balance >= value,
511             "Address: insufficient balance for call"
512         );
513         require(isContract(target), "Address: call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.call{value: value}(
516             data
517         );
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data)
528         internal
529         view
530         returns (bytes memory)
531     {
532         return
533             functionStaticCall(
534                 target,
535                 data,
536                 "Address: low-level static call failed"
537             );
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data)
564         internal
565         returns (bytes memory)
566     {
567         return
568             functionDelegateCall(
569                 target,
570                 data,
571                 "Address: low-level delegate call failed"
572             );
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @title ERC721 token receiver interface
625  * @dev Interface for any contract that wants to support safeTransfers
626  * from ERC721 asset contracts.
627  */
628 interface IERC721Receiver {
629     /**
630      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
631      * by `operator` from `from`, this function is called.
632      *
633      * It must return its Solidity selector to confirm the token transfer.
634      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
635      *
636      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
637      */
638     function onERC721Received(
639         address operator,
640         address from,
641         uint256 tokenId,
642         bytes calldata data
643     ) external returns (bytes4);
644 }
645 
646 pragma solidity ^0.8.0;
647 
648 /**
649  * @dev Required interface of an ERC721 compliant contract.
650  */
651 interface IERC721 is IERC165 {
652     /**
653      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
654      */
655     event Transfer(
656         address indexed from,
657         address indexed to,
658         uint256 indexed tokenId
659     );
660 
661     /**
662      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
663      */
664     event Approval(
665         address indexed owner,
666         address indexed approved,
667         uint256 indexed tokenId
668     );
669 
670     /**
671      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
672      */
673     event ApprovalForAll(
674         address indexed owner,
675         address indexed operator,
676         bool approved
677     );
678 
679     /**
680      * @dev Returns the number of tokens in ``owner``'s account.
681      */
682     function balanceOf(address owner) external view returns (uint256 balance);
683 
684     /**
685      * @dev Returns the owner of the `tokenId` token.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function ownerOf(uint256 tokenId) external view returns (address owner);
692 
693     /**
694      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
695      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) external;
712 
713     /**
714      * @dev Transfers `tokenId` token from `from` to `to`.
715      *
716      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must be owned by `from`.
723      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
724      *
725      * Emits a {Transfer} event.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) external;
732 
733     /**
734      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
735      * The approval is cleared when the token is transferred.
736      *
737      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
738      *
739      * Requirements:
740      *
741      * - The caller must own the token or be an approved operator.
742      * - `tokenId` must exist.
743      *
744      * Emits an {Approval} event.
745      */
746     function approve(address to, uint256 tokenId) external;
747 
748     /**
749      * @dev Returns the account approved for `tokenId` token.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must exist.
754      */
755     function getApproved(uint256 tokenId)
756         external
757         view
758         returns (address operator);
759 
760     /**
761      * @dev Approve or remove `operator` as an operator for the caller.
762      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
763      *
764      * Requirements:
765      *
766      * - The `operator` cannot be the caller.
767      *
768      * Emits an {ApprovalForAll} event.
769      */
770     function setApprovalForAll(address operator, bool _approved) external;
771 
772     /**
773      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
774      *
775      * See {setApprovalForAll}
776      */
777     function isApprovedForAll(address owner, address operator)
778         external
779         view
780         returns (bool);
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes calldata data
800     ) external;
801 }
802 
803 /**
804  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
805  * @dev See https://eips.ethereum.org/EIPS/eip-721
806  */
807 interface IERC721Enumerable is IERC721 {
808     /**
809      * @dev Returns the total amount of tokens stored by the contract.
810      */
811     function totalSupply() external view returns (uint256);
812 
813     /**
814      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
815      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
816      */
817     function tokenOfOwnerByIndex(address owner, uint256 index)
818         external
819         view
820         returns (uint256 tokenId);
821 
822     /**
823      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
824      * Use along with {totalSupply} to enumerate all tokens.
825      */
826     function tokenByIndex(uint256 index) external view returns (uint256);
827 }
828 
829 pragma solidity ^0.8.0;
830 
831 /**
832  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
833  * @dev See https://eips.ethereum.org/EIPS/eip-721
834  */
835 interface IERC721Metadata is IERC721 {
836     /**
837      * @dev Returns the token collection name.
838      */
839     function name() external view returns (string memory);
840 
841     /**
842      * @dev Returns the token collection symbol.
843      */
844     function symbol() external view returns (string memory);
845 
846     /**
847      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
848      */
849     function tokenURI(uint256 tokenId) external view returns (string memory);
850 }
851 
852 pragma solidity ^0.8.0;
853 
854 /**
855  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
856  * the Metadata extension, but not including the Enumerable extension, which is available separately as
857  * {ERC721Enumerable}.
858  */
859 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
860     using Address for address;
861     using Strings for uint256;
862 
863     // Token name
864     string private _name;
865 
866     // Token symbol
867     string private _symbol;
868 
869     // Mapping from token ID to owner address
870     mapping(uint256 => address) private _owners;
871 
872     // Mapping owner address to token count
873     mapping(address => uint256) private _balances;
874 
875     // Mapping from token ID to approved address
876     mapping(uint256 => address) private _tokenApprovals;
877 
878     // Mapping from owner to operator approvals
879     mapping(address => mapping(address => bool)) private _operatorApprovals;
880 
881     /**
882      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
883      */
884     constructor(string memory name_, string memory symbol_) {
885         _name = name_;
886         _symbol = symbol_;
887     }
888 
889     /**
890      * @dev See {IERC165-supportsInterface}.
891      */
892     function supportsInterface(bytes4 interfaceId)
893         public
894         view
895         virtual
896         override(ERC165, IERC165)
897         returns (bool)
898     {
899         return
900             interfaceId == type(IERC721).interfaceId ||
901             interfaceId == type(IERC721Metadata).interfaceId ||
902             super.supportsInterface(interfaceId);
903     }
904 
905     /**
906      * @dev See {IERC721-balanceOf}.
907      */
908     function balanceOf(address owner)
909         public
910         view
911         virtual
912         override
913         returns (uint256)
914     {
915         require(
916             owner != address(0),
917             "ERC721: balance query for the zero address"
918         );
919         return _balances[owner];
920     }
921 
922     /**
923      * @dev See {IERC721-ownerOf}.
924      */
925     function ownerOf(uint256 tokenId)
926         public
927         view
928         virtual
929         override
930         returns (address)
931     {
932         address owner = _owners[tokenId];
933         require(
934             owner != address(0),
935             "ERC721: owner query for nonexistent token"
936         );
937         return owner;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId)
958         public
959         view
960         virtual
961         override
962         returns (string memory)
963     {
964         require(
965             _exists(tokenId),
966             "ERC721Metadata: URI query for nonexistent token"
967         );
968 
969         string memory baseURI = _baseURI();
970         return
971             bytes(baseURI).length > 0
972                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
973                 : "";
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, can be overriden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return "";
983     }
984 
985     /**
986      * @dev See {IERC721-approve}.
987      */
988     function approve(address to, uint256 tokenId) public virtual override {
989         address owner = ERC721.ownerOf(tokenId);
990         require(to != owner, "ERC721: approval to current owner");
991 
992         require(
993             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
994             "ERC721: approve caller is not owner nor approved for all"
995         );
996 
997         _approve(to, tokenId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-getApproved}.
1002      */
1003     function getApproved(uint256 tokenId)
1004         public
1005         view
1006         virtual
1007         override
1008         returns (address)
1009     {
1010         require(
1011             _exists(tokenId),
1012             "ERC721: approved query for nonexistent token"
1013         );
1014 
1015         return _tokenApprovals[tokenId];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-setApprovalForAll}.
1020      */
1021     function setApprovalForAll(address operator, bool approved)
1022         public
1023         virtual
1024         override
1025     {
1026         _setApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator)
1033         public
1034         view
1035         virtual
1036         override
1037         returns (bool)
1038     {
1039         return _operatorApprovals[owner][operator];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-transferFrom}.
1044      */
1045     function transferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         //solhint-disable-next-line max-line-length
1051         require(
1052             _isApprovedOrOwner(_msgSender(), tokenId),
1053             "ERC721: transfer caller is not owner nor approved"
1054         );
1055 
1056         _transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public virtual override {
1067         safeTransferFrom(from, to, tokenId, "");
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) public virtual override {
1079         require(
1080             _isApprovedOrOwner(_msgSender(), tokenId),
1081             "ERC721: transfer caller is not owner nor approved"
1082         );
1083         _safeTransfer(from, to, tokenId, _data);
1084     }
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1088      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1089      *
1090      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1091      *
1092      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1093      * implement alternative mechanisms to perform token transfer, such as signature-based.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must exist and be owned by `from`.
1100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _safeTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) internal virtual {
1110         _transfer(from, to, tokenId);
1111         require(
1112             _checkOnERC721Received(from, to, tokenId, _data),
1113             "ERC721: transfer to non ERC721Receiver implementer"
1114         );
1115     }
1116 
1117     /**
1118      * @dev Returns whether `tokenId` exists.
1119      *
1120      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1121      *
1122      * Tokens start existing when they are minted (`_mint`),
1123      * and stop existing when they are burned (`_burn`).
1124      */
1125     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1126         return _owners[tokenId] != address(0);
1127     }
1128 
1129     /**
1130      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must exist.
1135      */
1136     function _isApprovedOrOwner(address spender, uint256 tokenId)
1137         internal
1138         view
1139         virtual
1140         returns (bool)
1141     {
1142         require(
1143             _exists(tokenId),
1144             "ERC721: operator query for nonexistent token"
1145         );
1146         address owner = ERC721.ownerOf(tokenId);
1147         return (spender == owner ||
1148             getApproved(tokenId) == spender ||
1149             isApprovedForAll(owner, spender));
1150     }
1151 
1152     /**
1153      * @dev Safely mints `tokenId` and transfers it to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must not exist.
1158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _safeMint(address to, uint256 tokenId) internal virtual {
1163         _safeMint(to, tokenId, "");
1164     }
1165 
1166     /**
1167      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1168      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1169      */
1170     function _safeMint(
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) internal virtual {
1175         _mint(to, tokenId);
1176         require(
1177             _checkOnERC721Received(address(0), to, tokenId, _data),
1178             "ERC721: transfer to non ERC721Receiver implementer"
1179         );
1180     }
1181 
1182     /**
1183      * @dev Mints `tokenId` and transfers it to `to`.
1184      *
1185      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must not exist.
1190      * - `to` cannot be the zero address.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _mint(address to, uint256 tokenId) internal virtual {
1195         require(to != address(0), "ERC721: mint to the zero address");
1196         require(!_exists(tokenId), "ERC721: token already minted");
1197 
1198         _beforeTokenTransfer(address(0), to, tokenId);
1199 
1200         _balances[to] += 1;
1201         _owners[tokenId] = to;
1202 
1203         emit Transfer(address(0), to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId) internal virtual {
1217         address owner = ERC721.ownerOf(tokenId);
1218 
1219         _beforeTokenTransfer(owner, address(0), tokenId);
1220 
1221         // Clear approvals
1222         _approve(address(0), tokenId);
1223 
1224         _balances[owner] -= 1;
1225         delete _owners[tokenId];
1226 
1227         emit Transfer(owner, address(0), tokenId);
1228     }
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1233      *
1234      * Requirements:
1235      *
1236      * - `to` cannot be the zero address.
1237      * - `tokenId` token must be owned by `from`.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _transfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {
1246         require(
1247             ERC721.ownerOf(tokenId) == from,
1248             "ERC721: transfer of token that is not own"
1249         );
1250         require(to != address(0), "ERC721: transfer to the zero address");
1251 
1252         _beforeTokenTransfer(from, to, tokenId);
1253 
1254         // Clear approvals from the previous owner
1255         _approve(address(0), tokenId);
1256 
1257         _balances[from] -= 1;
1258         _balances[to] += 1;
1259         _owners[tokenId] = to;
1260 
1261         emit Transfer(from, to, tokenId);
1262     }
1263 
1264     /**
1265      * @dev Approve `to` to operate on `tokenId`
1266      *
1267      * Emits a {Approval} event.
1268      */
1269     function _approve(address to, uint256 tokenId) internal virtual {
1270         _tokenApprovals[tokenId] = to;
1271         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1272     }
1273 
1274     /**
1275      * @dev Approve `operator` to operate on all of `owner` tokens
1276      *
1277      * Emits a {ApprovalForAll} event.
1278      */
1279     function _setApprovalForAll(
1280         address owner,
1281         address operator,
1282         bool approved
1283     ) internal virtual {
1284         require(owner != operator, "ERC721: approve to caller");
1285         _operatorApprovals[owner][operator] = approved;
1286         emit ApprovalForAll(owner, operator, approved);
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1291      * The call is not executed if the target address is not a contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         if (to.isContract()) {
1306             try
1307                 IERC721Receiver(to).onERC721Received(
1308                     _msgSender(),
1309                     from,
1310                     tokenId,
1311                     _data
1312                 )
1313             returns (bytes4 retval) {
1314                 return retval == IERC721Receiver.onERC721Received.selector;
1315             } catch (bytes memory reason) {
1316                 if (reason.length == 0) {
1317                     revert(
1318                         "ERC721: transfer to non ERC721Receiver implementer"
1319                     );
1320                 } else {
1321                     assembly {
1322                         revert(add(32, reason), mload(reason))
1323                     }
1324                 }
1325             }
1326         } else {
1327             return true;
1328         }
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before any token transfer. This includes minting
1333      * and burning.
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1341      * - `from` and `to` are never both zero.
1342      *
1343      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1344      */
1345     function _beforeTokenTransfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) internal virtual {}
1350 }
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 /**
1355  * @dev Contract module which allows children to implement an emergency stop
1356  * mechanism that can be triggered by an authorized account.
1357  *
1358  * This module is used through inheritance. It will make available the
1359  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1360  * the functions of your contract. Note that they will not be pausable by
1361  * simply including this module, only once the modifiers are put in place.
1362  */
1363 abstract contract Pausable is Context {
1364     /**
1365      * @dev Emitted when the pause is triggered by `account`.
1366      */
1367     event Paused(address account);
1368 
1369     /**
1370      * @dev Emitted when the pause is lifted by `account`.
1371      */
1372     event Unpaused(address account);
1373 
1374     bool private _paused;
1375 
1376     /**
1377      * @dev Initializes the contract in unpaused state.
1378      */
1379     constructor() {
1380         _paused = false;
1381     }
1382 
1383     /**
1384      * @dev Returns true if the contract is paused, and false otherwise.
1385      */
1386     function paused() public view virtual returns (bool) {
1387         return _paused;
1388     }
1389 
1390     /**
1391      * @dev Modifier to make a function callable only when the contract is not paused.
1392      *
1393      * Requirements:
1394      *
1395      * - The contract must not be paused.
1396      */
1397     modifier whenNotPaused() {
1398         require(!paused(), "Pausable: paused");
1399         _;
1400     }
1401 
1402     /**
1403      * @dev Modifier to make a function callable only when the contract is paused.
1404      *
1405      * Requirements:
1406      *
1407      * - The contract must be paused.
1408      */
1409     modifier whenPaused() {
1410         require(paused(), "Pausable: not paused");
1411         _;
1412     }
1413 
1414     /**
1415      * @dev Triggers stopped state.
1416      *
1417      * Requirements:
1418      *
1419      * - The contract must not be paused.
1420      */
1421     function _pause() internal virtual whenNotPaused {
1422         _paused = true;
1423         emit Paused(_msgSender());
1424     }
1425 
1426     /**
1427      * @dev Returns to normal state.
1428      *
1429      * Requirements:
1430      *
1431      * - The contract must be paused.
1432      */
1433     function _unpause() internal virtual whenPaused {
1434         _paused = false;
1435         emit Unpaused(_msgSender());
1436     }
1437 }
1438 
1439 pragma solidity ^0.8.0;
1440 
1441 /**
1442  * @dev Contract module which provides a basic access control mechanism, where
1443  * there is an account (an owner) that can be granted exclusive access to
1444  * specific functions.
1445  *
1446  * By default, the owner account will be the one that deploys the contract. This
1447  * can later be changed with {transferOwnership}.
1448  *
1449  * This module is used through inheritance. It will make available the modifier
1450  * `onlyOwner`, which can be applied to your functions to restrict their use to
1451  * the owner.
1452  */
1453 abstract contract Ownable is Context {
1454     address private _owner;
1455 
1456     event OwnershipTransferred(
1457         address indexed previousOwner,
1458         address indexed newOwner
1459     );
1460 
1461     /**
1462      * @dev Initializes the contract setting the deployer as the initial owner.
1463      */
1464     constructor() {
1465         _transferOwnership(_msgSender());
1466     }
1467 
1468     /**
1469      * @dev Returns the address of the current owner.
1470      */
1471     function owner() public view virtual returns (address) {
1472         return _owner;
1473     }
1474 
1475     /**
1476      * @dev Throws if called by any account other than the owner.
1477      */
1478     modifier onlyOwner() {
1479         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1480         _;
1481     }
1482 
1483     /**
1484      * @dev Leaves the contract without owner. It will not be possible to call
1485      * `onlyOwner` functions anymore. Can only be called by the current owner.
1486      *
1487      * NOTE: Renouncing ownership will leave the contract without an owner,
1488      * thereby removing any functionality that is only available to the owner.
1489      */
1490     function renounceOwnership() public virtual onlyOwner {
1491         _transferOwnership(address(0));
1492     }
1493 
1494     /**
1495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1496      * Can only be called by the current owner.
1497      */
1498     function transferOwnership(address newOwner) public virtual onlyOwner {
1499         require(
1500             newOwner != address(0),
1501             "Ownable: new owner is the zero address"
1502         );
1503         _transferOwnership(newOwner);
1504     }
1505 
1506     /**
1507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1508      * Internal function without access restriction.
1509      */
1510     function _transferOwnership(address newOwner) internal virtual {
1511         address oldOwner = _owner;
1512         _owner = newOwner;
1513         emit OwnershipTransferred(oldOwner, newOwner);
1514     }
1515 }
1516 
1517 pragma solidity ^0.8.0;
1518 
1519 /**
1520  * @dev Contract module that helps prevent reentrant calls to a function.
1521  *
1522  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1523  * available, which can be applied to functions to make sure there are no nested
1524  * (reentrant) calls to them.
1525  *
1526  * Note that because there is a single `nonReentrant` guard, functions marked as
1527  * `nonReentrant` may not call one another. This can be worked around by making
1528  * those functions `private`, and then adding `external` `nonReentrant` entry
1529  * points to them.
1530  *
1531  * TIP: If you would like to learn more about reentrancy and alternative ways
1532  * to protect against it, check out our blog post
1533  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1534  */
1535 abstract contract ReentrancyGuard {
1536     // Booleans are more expensive than uint256 or any type that takes up a full
1537     // word because each write operation emits an extra SLOAD to first read the
1538     // slot's contents, replace the bits taken up by the boolean, and then write
1539     // back. This is the compiler's defense against contract upgrades and
1540     // pointer aliasing, and it cannot be disabled.
1541 
1542     // The values being non-zero value makes deployment a bit more expensive,
1543     // but in exchange the refund on every call to nonReentrant will be lower in
1544     // amount. Since refunds are capped to a percentage of the total
1545     // transaction's gas, it is best to keep them low in cases like this one, to
1546     // increase the likelihood of the full refund coming into effect.
1547     uint256 private constant _NOT_ENTERED = 1;
1548     uint256 private constant _ENTERED = 2;
1549 
1550     uint256 private _status;
1551 
1552     constructor() {
1553         _status = _NOT_ENTERED;
1554     }
1555 
1556     /**
1557      * @dev Prevents a contract from calling itself, directly or indirectly.
1558      * Calling a `nonReentrant` function from another `nonReentrant`
1559      * function is not supported. It is possible to prevent this from happening
1560      * by making the `nonReentrant` function external, and make it call a
1561      * `private` function that does the actual work.
1562      */
1563     modifier nonReentrant() {
1564         // On the first call to nonReentrant, _notEntered will be true
1565         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1566 
1567         // Any calls to nonReentrant after this point will fail
1568         _status = _ENTERED;
1569 
1570         _;
1571 
1572         // By storing the original value once again, a refund is triggered (see
1573         // https://eips.ethereum.org/EIPS/eip-2200)
1574         _status = _NOT_ENTERED;
1575     }
1576 }
1577 
1578 pragma solidity ^0.8.0;
1579 
1580 /**
1581  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1582  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1583  *
1584  * _Available since v3.1._
1585  */
1586 interface IERC1155 is IERC165 {
1587     /**
1588      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1589      */
1590     event TransferSingle(
1591         address indexed operator,
1592         address indexed from,
1593         address indexed to,
1594         uint256 id,
1595         uint256 value
1596     );
1597 
1598     /**
1599      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1600      * transfers.
1601      */
1602     event TransferBatch(
1603         address indexed operator,
1604         address indexed from,
1605         address indexed to,
1606         uint256[] ids,
1607         uint256[] values
1608     );
1609 
1610     /**
1611      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1612      * `approved`.
1613      */
1614     event ApprovalForAll(
1615         address indexed account,
1616         address indexed operator,
1617         bool approved
1618     );
1619 
1620     /**
1621      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1622      *
1623      * If an {URI} event was emitted for `id`, the standard
1624      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1625      * returned by {IERC1155MetadataURI-uri}.
1626      */
1627     event URI(string value, uint256 indexed id);
1628 
1629     /**
1630      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1631      *
1632      * Requirements:
1633      *
1634      * - `account` cannot be the zero address.
1635      */
1636     function balanceOf(address account, uint256 id)
1637         external
1638         view
1639         returns (uint256);
1640 
1641     /**
1642      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1643      *
1644      * Requirements:
1645      *
1646      * - `accounts` and `ids` must have the same length.
1647      */
1648     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1649         external
1650         view
1651         returns (uint256[] memory);
1652 
1653     /**
1654      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1655      *
1656      * Emits an {ApprovalForAll} event.
1657      *
1658      * Requirements:
1659      *
1660      * - `operator` cannot be the caller.
1661      */
1662     function setApprovalForAll(address operator, bool approved) external;
1663 
1664     /**
1665      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1666      *
1667      * See {setApprovalForAll}.
1668      */
1669     function isApprovedForAll(address account, address operator)
1670         external
1671         view
1672         returns (bool);
1673 
1674     /**
1675      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1676      *
1677      * Emits a {TransferSingle} event.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1683      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1684      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1685      * acceptance magic value.
1686      */
1687     function safeTransferFrom(
1688         address from,
1689         address to,
1690         uint256 id,
1691         uint256 amount,
1692         bytes calldata data
1693     ) external;
1694 
1695     /**
1696      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1697      *
1698      * Emits a {TransferBatch} event.
1699      *
1700      * Requirements:
1701      *
1702      * - `ids` and `amounts` must have the same length.
1703      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1704      * acceptance magic value.
1705      */
1706     function safeBatchTransferFrom(
1707         address from,
1708         address to,
1709         uint256[] calldata ids,
1710         uint256[] calldata amounts,
1711         bytes calldata data
1712     ) external;
1713 }
1714 
1715 pragma solidity ^0.8.16;
1716 
1717 contract JourneyEventTrigger is
1718     Ownable,
1719     ReentrancyGuard,
1720     Pausable,
1721     ERC1155TokenReceiver,
1722     IERC721Receiver
1723 {
1724     using Strings for uint256;
1725 
1726     // Setup the contracts for the pieces in the Journey
1727     address public Tigers = 0xf4744Ec5D846F7f1a0c5d389F590Cc1344eD3fCf;
1728     address public Cubs = 0x98d3cd2F29a4F5464266f925Fe177018e6c2F9E6;
1729 
1730     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
1731     address public LiquidKeys = 0x753412F4FB7245BCF1c0714fDf59ba89110f39b8;
1732     address public Artifacts = 0xDde7505f40a61032Ed076452f85C0F54DFA208Bd;
1733 
1734     struct Events {
1735         uint256 keyTokenId;
1736         address owner;
1737         uint256 artifactId;
1738         string mythicWorld;
1739         uint256 eventTime;
1740         uint256 randomEvent;
1741     }
1742 
1743     mapping(uint256 => Events) public AllEvents; // All Events
1744     uint256[] public EventTimestamps; // All EventTimestamps
1745 
1746     IERC1155 ArtifactsContract = IERC1155(address(Artifacts));
1747 
1748     /**
1749      * @notice setLiquidDeployer set a new deployer contract (fail-safe)
1750      * @param deployerAddress address of the deployer contract
1751      */
1752     function setLiquidDeployer(address deployerAddress) external onlyOwner {
1753         LiquidDeployer = deployerAddress;
1754     }
1755 
1756     // -------------------------------------------------------------------------
1757     // Functions to add a new activeJourney and manage some of the open Journeys
1758     // -------------------------------------------------------------------------
1759 
1760     // Return allEvents as a convenience function
1761     function getAllEvents() public view returns (Events[] memory) {
1762         Events[] memory events = new Events[](EventTimestamps.length);
1763         for (uint256 i = 0; i < EventTimestamps.length; i++) {
1764             events[i] = AllEvents[EventTimestamps[i]];
1765         }
1766 
1767         return events;
1768     }
1769 
1770     function newEventTrigger(
1771         address owner,
1772         uint256 liquidKeyTokenId,
1773         uint256 artifactTokenId,
1774         string memory mythicWorld
1775     ) public whenNotPaused {
1776         require(
1777             msg.sender == owner || msg.sender == LiquidDeployer,
1778             "You are not the owner or the contract"
1779         );
1780 
1781         // You can only burn an artifact 1-18 or 42
1782         require(
1783             (artifactTokenId > 0 && artifactTokenId <= 18) ||
1784                 artifactTokenId == 42,
1785             "Not a valid Artifact"
1786         );
1787 
1788         require(bytes(mythicWorld).length > 5, "Mythic World not possible");
1789 
1790         // Burn the necessary artifact
1791         burnMyArtifacts(artifactTokenId, 1);
1792 
1793         uint256 timestamp = block.timestamp;
1794 
1795         // Add the new Journey to the ActiveJourneys mapping
1796         AllEvents[timestamp] = Events(
1797             liquidKeyTokenId,
1798             owner,
1799             artifactTokenId,
1800             mythicWorld,
1801             timestamp,
1802             RandomNumber(1000)
1803         );
1804 
1805         EventTimestamps.push(timestamp);
1806     }
1807 
1808     // ------------------------------------------------------------------
1809     // Random Number generation, calculations, and other helper functions
1810     // ------------------------------------------------------------------
1811 
1812     // @notice Generate random number based on totalnumbers
1813     // @param totalnumbers The Maximum number to return (i.e. 100 returns 0-99)
1814     function RandomNumber(uint256 totalnumbers) public view returns (uint256) {
1815         totalnumbers = totalnumbers + 1; // add one, because starting at 0 sux
1816         // Create a new seed using a combination of the current block's properties
1817         uint256 seed = uint256(
1818             keccak256(
1819                 abi.encodePacked(
1820                     block.timestamp,
1821                     block.difficulty,
1822                     uint256(keccak256(abi.encodePacked(block.coinbase))) /
1823                         block.timestamp,
1824                     block.gaslimit,
1825                     uint256(keccak256(abi.encodePacked(msg.sender))) /
1826                         block.timestamp,
1827                     block.number
1828                 )
1829             )
1830         );
1831 
1832         // Return the result of the modulo operation between the seed and
1833         // the total number of possible numbers
1834         return seed % totalnumbers;
1835     }
1836 
1837     // ---------------------------------------------------------------
1838     // Private functions to make life so much easier for this contract
1839     // ---------------------------------------------------------------
1840 
1841     event ArtifactBurned(
1842         address indexed _sender,
1843         uint256 _artifactTokenId,
1844         uint256 _totalToBurn
1845     );
1846 
1847     // @notice burnMyArtifacts call the Mythic Artifacts contract function
1848     // @params artifactTokenId the token id to "burn"
1849     // @params totalToBurn the total artifacts to burn for the token id given
1850     //
1851     function burnMyArtifacts(uint256 artifactTokenId, uint256 totalToBurn)
1852         private
1853     {
1854         // We must own at least totalToBurn of token
1855         require(
1856             ArtifactsContract.balanceOf(msg.sender, artifactTokenId) >=
1857                 totalToBurn,
1858             "You do not have enough of this Artifact to burn"
1859         );
1860 
1861         ArtifactsContract.safeTransferFrom(
1862             msg.sender,
1863             address(this),
1864             artifactTokenId,
1865             totalToBurn,
1866             "Artifact transfer failed."
1867         );
1868 
1869         // log the artifact burn event
1870         emit ArtifactBurned(msg.sender, artifactTokenId, totalToBurn);
1871     }
1872 
1873     // -----------------------------------------------------------------------
1874     // Final Functions which are basically native to this contract & ownerOnly
1875     // -----------------------------------------------------------------------
1876 
1877     function onERC1155Received(
1878         address,
1879         address,
1880         uint256,
1881         uint256,
1882         bytes memory
1883     ) public virtual returns (bytes4) {
1884         return this.onERC1155Received.selector;
1885     }
1886 
1887     function onERC1155BatchReceived(
1888         address,
1889         address,
1890         uint256[] memory,
1891         uint256[] memory,
1892         bytes memory
1893     ) public virtual returns (bytes4) {
1894         return this.onERC1155BatchReceived.selector;
1895     }
1896 
1897     // Pause and unpause the contract, just in case
1898     function pause() public onlyOwner {
1899         _pause();
1900     }
1901 
1902     function unpause() public onlyOwner {
1903         _unpause();
1904     }
1905 
1906     // ERC721 token receiver for transferred NFT to this contract
1907     function onERC721Received(
1908         address,
1909         address,
1910         uint256,
1911         bytes calldata
1912     ) external pure returns (bytes4) {
1913         return IERC721Receiver.onERC721Received.selector;
1914     }
1915 
1916     // return all artifacts
1917     function returnArtifacts() external onlyOwner {
1918         for (uint256 i = 1; i <= 18; i++) {
1919             uint256 t = ArtifactsContract.balanceOf(msg.sender, i);
1920             if (t > 0) {
1921                 IERC1155(Artifacts).safeTransferFrom(
1922                     msg.sender,
1923                     LiquidDeployer,
1924                     i,
1925                     t,
1926                     "Artifact transfer failed."
1927                 );
1928             }
1929         }
1930 
1931         uint256 n = ArtifactsContract.balanceOf(msg.sender, 42);
1932         if (n > 0) {
1933             IERC1155(Artifacts).safeTransferFrom(
1934                 msg.sender,
1935                 LiquidDeployer,
1936                 42,
1937                 n,
1938                 "Artifact transfer failed."
1939             );
1940         }
1941     }
1942 
1943     // destroy the contract
1944     function SelfDestruct() external onlyOwner {
1945         // Walk through all the keys and return them to the contract
1946         address payable os = payable(address(LiquidDeployer));
1947         selfdestruct(os);
1948     }
1949 }