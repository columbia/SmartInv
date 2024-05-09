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
20        Written by https://twitter.com/aleph0ne
21 
22 */
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
28 */
29 interface ERC1155TokenReceiver {
30     /**
31         @notice Handle the receipt of a single ERC1155 token type.
32         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
33         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
34         This function MUST revert if it rejects the transfer.
35         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
36         @param _operator  The address which initiated the transfer (i.e. msg.sender)
37         @param _from      The address which previously owned the token
38         @param _id        The ID of the token being transferred
39         @param _value     The amount of tokens being transferred
40         @param _data      Additional data with no specified format
41         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
42     */
43     function onERC1155Received(
44         address _operator,
45         address _from,
46         uint256 _id,
47         uint256 _value,
48         bytes calldata _data
49     ) external returns (bytes4);
50 
51     /**
52         @notice Handle the receipt of multiple ERC1155 token types.
53         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
54         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
55         This function MUST revert if it rejects the transfer(s).
56         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
57         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
58         @param _from      The address which previously owned the token
59         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
60         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
61         @param _data      Additional data with no specified format
62         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
63     */
64     function onERC1155BatchReceived(
65         address _operator,
66         address _from,
67         uint256[] calldata _ids,
68         uint256[] calldata _values,
69         bytes calldata _data
70     ) external returns (bytes4);
71 }
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76     @title ERC-1155 Multi Token Standard
77     @dev See https://eips.ethereum.org/EIPS/eip-1155
78     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
79  */
80 /* is ERC165 */
81 interface ERC1155 {
82     /**
83         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
84         The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
85         The `_from` argument MUST be the address of the holder whose balance is decreased.
86         The `_to` argument MUST be the address of the recipient whose balance is increased.
87         The `_id` argument MUST be the token type being transferred.
88         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
89         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
90         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
91     */
92     event TransferSingle(
93         address indexed _operator,
94         address indexed _from,
95         address indexed _to,
96         uint256 _id,
97         uint256 _value
98     );
99 
100     /**
101         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
102         The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
103         The `_from` argument MUST be the address of the holder whose balance is decreased.
104         The `_to` argument MUST be the address of the recipient whose balance is increased.
105         The `_ids` argument MUST be the list of tokens being transferred.
106         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
107         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
108         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
109     */
110     event TransferBatch(
111         address indexed _operator,
112         address indexed _from,
113         address indexed _to,
114         uint256[] _ids,
115         uint256[] _values
116     );
117 
118     /**
119         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).
120     */
121     event ApprovalForAll(
122         address indexed _owner,
123         address indexed _operator,
124         bool _approved
125     );
126 
127     /**
128         @dev MUST emit when the URI is updated for a token ID.
129         URIs are defined in RFC 3986.
130         The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
131     */
132     event URI(string _value, uint256 indexed _id);
133 
134     /**
135         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
136         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
137         MUST revert if `_to` is the zero address.
138         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
139         MUST revert on any other error.
140         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
141         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
142         @param _from    Source address
143         @param _to      Target address
144         @param _id      ID of the token type
145         @param _value   Transfer amount
146         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
147     */
148     function safeTransferFrom(
149         address _from,
150         address _to,
151         uint256 _id,
152         uint256 _value,
153         bytes calldata _data
154     ) external;
155 
156     /**
157         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
158         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
159         MUST revert if `_to` is the zero address.
160         MUST revert if length of `_ids` is not the same as length of `_values`.
161         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
162         MUST revert on any other error.
163         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
164         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
165         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
166         @param _from    Source address
167         @param _to      Target address
168         @param _ids     IDs of each token type (order and length must match _values array)
169         @param _values  Transfer amounts per token type (order and length must match _ids array)
170         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
171     */
172     function safeBatchTransferFrom(
173         address _from,
174         address _to,
175         uint256[] calldata _ids,
176         uint256[] calldata _values,
177         bytes calldata _data
178     ) external;
179 
180     /**
181         @notice Get the balance of an account's tokens.
182         @param _owner  The address of the token holder
183         @param _id     ID of the token
184         @return        The _owner's balance of the token type requested
185      */
186     function balanceOf(address _owner, uint256 _id)
187         external
188         view
189         returns (uint256);
190 
191     /**
192         @notice Get the balance of multiple account/token pairs
193         @param _owners The addresses of the token holders
194         @param _ids    ID of the tokens
195         @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
196      */
197     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
198         external
199         view
200         returns (uint256[] memory);
201 
202     /**
203         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
204         @dev MUST emit the ApprovalForAll event on success.
205         @param _operator  Address to add to the set of authorized operators
206         @param _approved  True if the operator is approved, false to revoke approval
207     */
208     function setApprovalForAll(address _operator, bool _approved) external;
209 
210     /**
211         @notice Queries the approval status of an operator for a given owner.
212         @param _owner     The owner of the tokens
213         @param _operator  Address of authorized operator
214         @return           True if the operator is approved, false if not
215     */
216     function isApprovedForAll(address _owner, address _operator)
217         external
218         view
219         returns (bool);
220 }
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Interface of the ERC165 standard, as defined in the
226  * https://eips.ethereum.org/EIPS/eip-165[EIP].
227  *
228  * Implementers can declare support of contract interfaces, which can then be
229  * queried by others ({ERC165Checker}).
230  *
231  * For an implementation, see {ERC165}.
232  */
233 interface IERC165 {
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30 000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 }
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Implementation of the {IERC165} interface.
249  *
250  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
251  * for the additional interface id that will be supported. For example:
252  *
253  * ```solidity
254  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
256  * }
257  * ```
258  *
259  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
260  */
261 abstract contract ERC165 is IERC165 {
262     /**
263      * @dev See {IERC165-supportsInterface}.
264      */
265     function supportsInterface(bytes4 interfaceId)
266         public
267         view
268         virtual
269         override
270         returns (bool)
271     {
272         return interfaceId == type(IERC165).interfaceId;
273     }
274 }
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev String operations.
280  */
281 library Strings {
282     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
286      */
287     function toString(uint256 value) internal pure returns (string memory) {
288         // Inspired by OraclizeAPI's implementation - MIT licence
289         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
290 
291         if (value == 0) {
292             return "0";
293         }
294         uint256 temp = value;
295         uint256 digits;
296         while (temp != 0) {
297             digits++;
298             temp /= 10;
299         }
300         bytes memory buffer = new bytes(digits);
301         while (value != 0) {
302             digits -= 1;
303             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
304             value /= 10;
305         }
306         return string(buffer);
307     }
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
311      */
312     function toHexString(uint256 value) internal pure returns (string memory) {
313         if (value == 0) {
314             return "0x00";
315         }
316         uint256 temp = value;
317         uint256 length = 0;
318         while (temp != 0) {
319             length++;
320             temp >>= 8;
321         }
322         return toHexString(value, length);
323     }
324 
325     /**
326      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
327      */
328     function toHexString(uint256 value, uint256 length)
329         internal
330         pure
331         returns (string memory)
332     {
333         bytes memory buffer = new bytes(2 * length + 2);
334         buffer[0] = "0";
335         buffer[1] = "x";
336         for (uint256 i = 2 * length + 1; i > 1; --i) {
337             buffer[i] = _HEX_SYMBOLS[value & 0xf];
338             value >>= 4;
339         }
340         require(value == 0, "Strings: hex length insufficient");
341         return string(buffer);
342     }
343 }
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Provides information about the current execution context, including the
349  * sender of the transaction and its data. While these are generally available
350  * via msg.sender and msg.data, they should not be accessed in such a direct
351  * manner, since when dealing with meta-transactions the account sending and
352  * paying for execution may not be the actual sender (as far as an application
353  * is concerned).
354  *
355  * This contract is only required for intermediate, library-like contracts.
356  */
357 abstract contract Context {
358     function _msgSender() internal view virtual returns (address) {
359         return msg.sender;
360     }
361 
362     function _msgData() internal view virtual returns (bytes calldata) {
363         return msg.data;
364     }
365 }
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Collection of functions related to the address type
371  */
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize, which returns 0 for contracts in
392         // construction, since the code is only stored at the end of the
393         // constructor execution.
394 
395         uint256 size;
396         assembly {
397             size := extcodesize(account)
398         }
399         return size > 0;
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(
420             address(this).balance >= amount,
421             "Address: insufficient balance"
422         );
423 
424         (bool success, ) = recipient.call{value: amount}("");
425         require(
426             success,
427             "Address: unable to send value, recipient may have reverted"
428         );
429     }
430 
431     /**
432      * @dev Performs a Solidity function call using a low level `call`. A
433      * plain `call` is an unsafe replacement for a function call: use this
434      * function instead.
435      *
436      * If `target` reverts with a revert reason, it is bubbled up by this
437      * function (like regular Solidity function calls).
438      *
439      * Returns the raw returned data. To convert to the expected return value,
440      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
441      *
442      * Requirements:
443      *
444      * - `target` must be a contract.
445      * - calling `target` with `data` must not revert.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data)
450         internal
451         returns (bytes memory)
452     {
453         return functionCall(target, data, "Address: low-level call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
458      * `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, 0, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but also transferring `value` wei to `target`.
473      *
474      * Requirements:
475      *
476      * - the calling contract must have an ETH balance of at least `value`.
477      * - the called Solidity function must be `payable`.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value
485     ) internal returns (bytes memory) {
486         return
487             functionCallWithValue(
488                 target,
489                 data,
490                 value,
491                 "Address: low-level call with value failed"
492             );
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
497      * with `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(
508             address(this).balance >= value,
509             "Address: insufficient balance for call"
510         );
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(
514             data
515         );
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(address target, bytes memory data)
526         internal
527         view
528         returns (bytes memory)
529     {
530         return
531             functionStaticCall(
532                 target,
533                 data,
534                 "Address: low-level static call failed"
535             );
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data)
562         internal
563         returns (bytes memory)
564     {
565         return
566             functionDelegateCall(
567                 target,
568                 data,
569                 "Address: low-level delegate call failed"
570             );
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(isContract(target), "Address: delegate call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.delegatecall(data);
587         return verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
592      * revert reason using the provided one.
593      *
594      * _Available since v4.3._
595      */
596     function verifyCallResult(
597         bool success,
598         bytes memory returndata,
599         string memory errorMessage
600     ) internal pure returns (bytes memory) {
601         if (success) {
602             return returndata;
603         } else {
604             // Look for revert reason and bubble it up if present
605             if (returndata.length > 0) {
606                 // The easiest way to bubble the revert reason is using memory via assembly
607 
608                 assembly {
609                     let returndata_size := mload(returndata)
610                     revert(add(32, returndata), returndata_size)
611                 }
612             } else {
613                 revert(errorMessage);
614             }
615         }
616     }
617 }
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @title ERC721 token receiver interface
623  * @dev Interface for any contract that wants to support safeTransfers
624  * from ERC721 asset contracts.
625  */
626 interface IERC721Receiver {
627     /**
628      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
629      * by `operator` from `from`, this function is called.
630      *
631      * It must return its Solidity selector to confirm the token transfer.
632      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
633      *
634      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
635      */
636     function onERC721Received(
637         address operator,
638         address from,
639         uint256 tokenId,
640         bytes calldata data
641     ) external returns (bytes4);
642 }
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev Required interface of an ERC721 compliant contract.
648  */
649 interface IERC721 is IERC165 {
650     /**
651      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
652      */
653     event Transfer(
654         address indexed from,
655         address indexed to,
656         uint256 indexed tokenId
657     );
658 
659     /**
660      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
661      */
662     event Approval(
663         address indexed owner,
664         address indexed approved,
665         uint256 indexed tokenId
666     );
667 
668     /**
669      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
670      */
671     event ApprovalForAll(
672         address indexed owner,
673         address indexed operator,
674         bool approved
675     );
676 
677     /**
678      * @dev Returns the number of tokens in ``owner``'s account.
679      */
680     function balanceOf(address owner) external view returns (uint256 balance);
681 
682     /**
683      * @dev Returns the owner of the `tokenId` token.
684      *
685      * Requirements:
686      *
687      * - `tokenId` must exist.
688      */
689     function ownerOf(uint256 tokenId) external view returns (address owner);
690 
691     /**
692      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
693      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) external;
710 
711     /**
712      * @dev Transfers `tokenId` token from `from` to `to`.
713      *
714      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must be owned by `from`.
721      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
722      *
723      * Emits a {Transfer} event.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) external;
730 
731     /**
732      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
733      * The approval is cleared when the token is transferred.
734      *
735      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
736      *
737      * Requirements:
738      *
739      * - The caller must own the token or be an approved operator.
740      * - `tokenId` must exist.
741      *
742      * Emits an {Approval} event.
743      */
744     function approve(address to, uint256 tokenId) external;
745 
746     /**
747      * @dev Returns the account approved for `tokenId` token.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function getApproved(uint256 tokenId)
754         external
755         view
756         returns (address operator);
757 
758     /**
759      * @dev Approve or remove `operator` as an operator for the caller.
760      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
761      *
762      * Requirements:
763      *
764      * - The `operator` cannot be the caller.
765      *
766      * Emits an {ApprovalForAll} event.
767      */
768     function setApprovalForAll(address operator, bool _approved) external;
769 
770     /**
771      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
772      *
773      * See {setApprovalForAll}
774      */
775     function isApprovedForAll(address owner, address operator)
776         external
777         view
778         returns (bool);
779 
780     /**
781      * @dev Safely transfers `tokenId` token from `from` to `to`.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes calldata data
798     ) external;
799 }
800 
801 /**
802  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
803  * @dev See https://eips.ethereum.org/EIPS/eip-721
804  */
805 interface IERC721Enumerable is IERC721 {
806     /**
807      * @dev Returns the total amount of tokens stored by the contract.
808      */
809     function totalSupply() external view returns (uint256);
810 
811     /**
812      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
813      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
814      */
815     function tokenOfOwnerByIndex(address owner, uint256 index)
816         external
817         view
818         returns (uint256 tokenId);
819 
820     /**
821      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
822      * Use along with {totalSupply} to enumerate all tokens.
823      */
824     function tokenByIndex(uint256 index) external view returns (uint256);
825 }
826 
827 pragma solidity ^0.8.0;
828 
829 /**
830  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
831  * @dev See https://eips.ethereum.org/EIPS/eip-721
832  */
833 interface IERC721Metadata is IERC721 {
834     /**
835      * @dev Returns the token collection name.
836      */
837     function name() external view returns (string memory);
838 
839     /**
840      * @dev Returns the token collection symbol.
841      */
842     function symbol() external view returns (string memory);
843 
844     /**
845      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
846      */
847     function tokenURI(uint256 tokenId) external view returns (string memory);
848 }
849 
850 pragma solidity ^0.8.0;
851 
852 /**
853  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
854  * the Metadata extension, but not including the Enumerable extension, which is available separately as
855  * {ERC721Enumerable}.
856  */
857 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
858     using Address for address;
859     using Strings for uint256;
860 
861     // Token name
862     string private _name;
863 
864     // Token symbol
865     string private _symbol;
866 
867     // Mapping from token ID to owner address
868     mapping(uint256 => address) private _owners;
869 
870     // Mapping owner address to token count
871     mapping(address => uint256) private _balances;
872 
873     // Mapping from token ID to approved address
874     mapping(uint256 => address) private _tokenApprovals;
875 
876     // Mapping from owner to operator approvals
877     mapping(address => mapping(address => bool)) private _operatorApprovals;
878 
879     /**
880      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
881      */
882     constructor(string memory name_, string memory symbol_) {
883         _name = name_;
884         _symbol = symbol_;
885     }
886 
887     /**
888      * @dev See {IERC165-supportsInterface}.
889      */
890     function supportsInterface(bytes4 interfaceId)
891         public
892         view
893         virtual
894         override(ERC165, IERC165)
895         returns (bool)
896     {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner)
907         public
908         view
909         virtual
910         override
911         returns (uint256)
912     {
913         require(
914             owner != address(0),
915             "ERC721: balance query for the zero address"
916         );
917         return _balances[owner];
918     }
919 
920     /**
921      * @dev See {IERC721-ownerOf}.
922      */
923     function ownerOf(uint256 tokenId)
924         public
925         view
926         virtual
927         override
928         returns (address)
929     {
930         address owner = _owners[tokenId];
931         require(
932             owner != address(0),
933             "ERC721: owner query for nonexistent token"
934         );
935         return owner;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId)
956         public
957         view
958         virtual
959         override
960         returns (string memory)
961     {
962         require(
963             _exists(tokenId),
964             "ERC721Metadata: URI query for nonexistent token"
965         );
966 
967         string memory baseURI = _baseURI();
968         return
969             bytes(baseURI).length > 0
970                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
971                 : "";
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return "";
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public virtual override {
987         address owner = ERC721.ownerOf(tokenId);
988         require(to != owner, "ERC721: approval to current owner");
989 
990         require(
991             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
992             "ERC721: approve caller is not owner nor approved for all"
993         );
994 
995         _approve(to, tokenId);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId)
1002         public
1003         view
1004         virtual
1005         override
1006         returns (address)
1007     {
1008         require(
1009             _exists(tokenId),
1010             "ERC721: approved query for nonexistent token"
1011         );
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved)
1020         public
1021         virtual
1022         override
1023     {
1024         _setApprovalForAll(_msgSender(), operator, approved);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-isApprovedForAll}.
1029      */
1030     function isApprovedForAll(address owner, address operator)
1031         public
1032         view
1033         virtual
1034         override
1035         returns (bool)
1036     {
1037         return _operatorApprovals[owner][operator];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-transferFrom}.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         //solhint-disable-next-line max-line-length
1049         require(
1050             _isApprovedOrOwner(_msgSender(), tokenId),
1051             "ERC721: transfer caller is not owner nor approved"
1052         );
1053 
1054         _transfer(from, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) public virtual override {
1065         safeTransferFrom(from, to, tokenId, "");
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) public virtual override {
1077         require(
1078             _isApprovedOrOwner(_msgSender(), tokenId),
1079             "ERC721: transfer caller is not owner nor approved"
1080         );
1081         _safeTransfer(from, to, tokenId, _data);
1082     }
1083 
1084     /**
1085      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1086      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1087      *
1088      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1089      *
1090      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1091      * implement alternative mechanisms to perform token transfer, such as signature-based.
1092      *
1093      * Requirements:
1094      *
1095      * - `from` cannot be the zero address.
1096      * - `to` cannot be the zero address.
1097      * - `tokenId` token must exist and be owned by `from`.
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _safeTransfer(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) internal virtual {
1108         _transfer(from, to, tokenId);
1109         require(
1110             _checkOnERC721Received(from, to, tokenId, _data),
1111             "ERC721: transfer to non ERC721Receiver implementer"
1112         );
1113     }
1114 
1115     /**
1116      * @dev Returns whether `tokenId` exists.
1117      *
1118      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1119      *
1120      * Tokens start existing when they are minted (`_mint`),
1121      * and stop existing when they are burned (`_burn`).
1122      */
1123     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1124         return _owners[tokenId] != address(0);
1125     }
1126 
1127     /**
1128      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must exist.
1133      */
1134     function _isApprovedOrOwner(address spender, uint256 tokenId)
1135         internal
1136         view
1137         virtual
1138         returns (bool)
1139     {
1140         require(
1141             _exists(tokenId),
1142             "ERC721: operator query for nonexistent token"
1143         );
1144         address owner = ERC721.ownerOf(tokenId);
1145         return (spender == owner ||
1146             getApproved(tokenId) == spender ||
1147             isApprovedForAll(owner, spender));
1148     }
1149 
1150     /**
1151      * @dev Safely mints `tokenId` and transfers it to `to`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must not exist.
1156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _safeMint(address to, uint256 tokenId) internal virtual {
1161         _safeMint(to, tokenId, "");
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1166      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1167      */
1168     function _safeMint(
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) internal virtual {
1173         _mint(to, tokenId);
1174         require(
1175             _checkOnERC721Received(address(0), to, tokenId, _data),
1176             "ERC721: transfer to non ERC721Receiver implementer"
1177         );
1178     }
1179 
1180     /**
1181      * @dev Mints `tokenId` and transfers it to `to`.
1182      *
1183      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must not exist.
1188      * - `to` cannot be the zero address.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _mint(address to, uint256 tokenId) internal virtual {
1193         require(to != address(0), "ERC721: mint to the zero address");
1194         require(!_exists(tokenId), "ERC721: token already minted");
1195 
1196         _beforeTokenTransfer(address(0), to, tokenId);
1197 
1198         _balances[to] += 1;
1199         _owners[tokenId] = to;
1200 
1201         emit Transfer(address(0), to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId) internal virtual {
1215         address owner = ERC721.ownerOf(tokenId);
1216 
1217         _beforeTokenTransfer(owner, address(0), tokenId);
1218 
1219         // Clear approvals
1220         _approve(address(0), tokenId);
1221 
1222         _balances[owner] -= 1;
1223         delete _owners[tokenId];
1224 
1225         emit Transfer(owner, address(0), tokenId);
1226     }
1227 
1228     /**
1229      * @dev Transfers `tokenId` from `from` to `to`.
1230      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must be owned by `from`.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _transfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) internal virtual {
1244         require(
1245             ERC721.ownerOf(tokenId) == from,
1246             "ERC721: transfer of token that is not own"
1247         );
1248         require(to != address(0), "ERC721: transfer to the zero address");
1249 
1250         _beforeTokenTransfer(from, to, tokenId);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId);
1254 
1255         _balances[from] -= 1;
1256         _balances[to] += 1;
1257         _owners[tokenId] = to;
1258 
1259         emit Transfer(from, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev Approve `to` to operate on `tokenId`
1264      *
1265      * Emits a {Approval} event.
1266      */
1267     function _approve(address to, uint256 tokenId) internal virtual {
1268         _tokenApprovals[tokenId] = to;
1269         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev Approve `operator` to operate on all of `owner` tokens
1274      *
1275      * Emits a {ApprovalForAll} event.
1276      */
1277     function _setApprovalForAll(
1278         address owner,
1279         address operator,
1280         bool approved
1281     ) internal virtual {
1282         require(owner != operator, "ERC721: approve to caller");
1283         _operatorApprovals[owner][operator] = approved;
1284         emit ApprovalForAll(owner, operator, approved);
1285     }
1286 
1287     /**
1288      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1289      * The call is not executed if the target address is not a contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         if (to.isContract()) {
1304             try
1305                 IERC721Receiver(to).onERC721Received(
1306                     _msgSender(),
1307                     from,
1308                     tokenId,
1309                     _data
1310                 )
1311             returns (bytes4 retval) {
1312                 return retval == IERC721Receiver.onERC721Received.selector;
1313             } catch (bytes memory reason) {
1314                 if (reason.length == 0) {
1315                     revert(
1316                         "ERC721: transfer to non ERC721Receiver implementer"
1317                     );
1318                 } else {
1319                     assembly {
1320                         revert(add(32, reason), mload(reason))
1321                     }
1322                 }
1323             }
1324         } else {
1325             return true;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Hook that is called before any token transfer. This includes minting
1331      * and burning.
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` will be minted for `to`.
1338      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1339      * - `from` and `to` are never both zero.
1340      *
1341      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1342      */
1343     function _beforeTokenTransfer(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) internal virtual {}
1348 }
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 /**
1353  * @dev Contract module which allows children to implement an emergency stop
1354  * mechanism that can be triggered by an authorized account.
1355  *
1356  * This module is used through inheritance. It will make available the
1357  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1358  * the functions of your contract. Note that they will not be pausable by
1359  * simply including this module, only once the modifiers are put in place.
1360  */
1361 abstract contract Pausable is Context {
1362     /**
1363      * @dev Emitted when the pause is triggered by `account`.
1364      */
1365     event Paused(address account);
1366 
1367     /**
1368      * @dev Emitted when the pause is lifted by `account`.
1369      */
1370     event Unpaused(address account);
1371 
1372     bool private _paused;
1373 
1374     /**
1375      * @dev Initializes the contract in unpaused state.
1376      */
1377     constructor() {
1378         _paused = false;
1379     }
1380 
1381     /**
1382      * @dev Returns true if the contract is paused, and false otherwise.
1383      */
1384     function paused() public view virtual returns (bool) {
1385         return _paused;
1386     }
1387 
1388     /**
1389      * @dev Modifier to make a function callable only when the contract is not paused.
1390      *
1391      * Requirements:
1392      *
1393      * - The contract must not be paused.
1394      */
1395     modifier whenNotPaused() {
1396         require(!paused(), "Pausable: paused");
1397         _;
1398     }
1399 
1400     /**
1401      * @dev Modifier to make a function callable only when the contract is paused.
1402      *
1403      * Requirements:
1404      *
1405      * - The contract must be paused.
1406      */
1407     modifier whenPaused() {
1408         require(paused(), "Pausable: not paused");
1409         _;
1410     }
1411 
1412     /**
1413      * @dev Triggers stopped state.
1414      *
1415      * Requirements:
1416      *
1417      * - The contract must not be paused.
1418      */
1419     function _pause() internal virtual whenNotPaused {
1420         _paused = true;
1421         emit Paused(_msgSender());
1422     }
1423 
1424     /**
1425      * @dev Returns to normal state.
1426      *
1427      * Requirements:
1428      *
1429      * - The contract must be paused.
1430      */
1431     function _unpause() internal virtual whenPaused {
1432         _paused = false;
1433         emit Unpaused(_msgSender());
1434     }
1435 }
1436 
1437 pragma solidity ^0.8.0;
1438 
1439 /**
1440  * @dev Contract module which provides a basic access control mechanism, where
1441  * there is an account (an owner) that can be granted exclusive access to
1442  * specific functions.
1443  *
1444  * By default, the owner account will be the one that deploys the contract. This
1445  * can later be changed with {transferOwnership}.
1446  *
1447  * This module is used through inheritance. It will make available the modifier
1448  * `onlyOwner`, which can be applied to your functions to restrict their use to
1449  * the owner.
1450  */
1451 abstract contract Ownable is Context {
1452     address private _owner;
1453 
1454     event OwnershipTransferred(
1455         address indexed previousOwner,
1456         address indexed newOwner
1457     );
1458 
1459     /**
1460      * @dev Initializes the contract setting the deployer as the initial owner.
1461      */
1462     constructor() {
1463         _transferOwnership(_msgSender());
1464     }
1465 
1466     /**
1467      * @dev Returns the address of the current owner.
1468      */
1469     function owner() public view virtual returns (address) {
1470         return _owner;
1471     }
1472 
1473     /**
1474      * @dev Throws if called by any account other than the owner.
1475      */
1476     modifier onlyOwner() {
1477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1478         _;
1479     }
1480 
1481     /**
1482      * @dev Leaves the contract without owner. It will not be possible to call
1483      * `onlyOwner` functions anymore. Can only be called by the current owner.
1484      *
1485      * NOTE: Renouncing ownership will leave the contract without an owner,
1486      * thereby removing any functionality that is only available to the owner.
1487      */
1488     function renounceOwnership() public virtual onlyOwner {
1489         _transferOwnership(address(0));
1490     }
1491 
1492     /**
1493      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1494      * Can only be called by the current owner.
1495      */
1496     function transferOwnership(address newOwner) public virtual onlyOwner {
1497         require(
1498             newOwner != address(0),
1499             "Ownable: new owner is the zero address"
1500         );
1501         _transferOwnership(newOwner);
1502     }
1503 
1504     /**
1505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1506      * Internal function without access restriction.
1507      */
1508     function _transferOwnership(address newOwner) internal virtual {
1509         address oldOwner = _owner;
1510         _owner = newOwner;
1511         emit OwnershipTransferred(oldOwner, newOwner);
1512     }
1513 }
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 /**
1518  * @dev Contract module that helps prevent reentrant calls to a function.
1519  *
1520  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1521  * available, which can be applied to functions to make sure there are no nested
1522  * (reentrant) calls to them.
1523  *
1524  * Note that because there is a single `nonReentrant` guard, functions marked as
1525  * `nonReentrant` may not call one another. This can be worked around by making
1526  * those functions `private`, and then adding `external` `nonReentrant` entry
1527  * points to them.
1528  *
1529  * TIP: If you would like to learn more about reentrancy and alternative ways
1530  * to protect against it, check out our blog post
1531  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1532  */
1533 abstract contract ReentrancyGuard {
1534     // Booleans are more expensive than uint256 or any type that takes up a full
1535     // word because each write operation emits an extra SLOAD to first read the
1536     // slot's contents, replace the bits taken up by the boolean, and then write
1537     // back. This is the compiler's defense against contract upgrades and
1538     // pointer aliasing, and it cannot be disabled.
1539 
1540     // The values being non-zero value makes deployment a bit more expensive,
1541     // but in exchange the refund on every call to nonReentrant will be lower in
1542     // amount. Since refunds are capped to a percentage of the total
1543     // transaction's gas, it is best to keep them low in cases like this one, to
1544     // increase the likelihood of the full refund coming into effect.
1545     uint256 private constant _NOT_ENTERED = 1;
1546     uint256 private constant _ENTERED = 2;
1547 
1548     uint256 private _status;
1549 
1550     constructor() {
1551         _status = _NOT_ENTERED;
1552     }
1553 
1554     /**
1555      * @dev Prevents a contract from calling itself, directly or indirectly.
1556      * Calling a `nonReentrant` function from another `nonReentrant`
1557      * function is not supported. It is possible to prevent this from happening
1558      * by making the `nonReentrant` function external, and make it call a
1559      * `private` function that does the actual work.
1560      */
1561     modifier nonReentrant() {
1562         // On the first call to nonReentrant, _notEntered will be true
1563         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1564 
1565         // Any calls to nonReentrant after this point will fail
1566         _status = _ENTERED;
1567 
1568         _;
1569 
1570         // By storing the original value once again, a refund is triggered (see
1571         // https://eips.ethereum.org/EIPS/eip-2200)
1572         _status = _NOT_ENTERED;
1573     }
1574 }
1575 
1576 pragma solidity ^0.8.0;
1577 
1578 /**
1579  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1580  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1581  *
1582  * _Available since v3.1._
1583  */
1584 interface IERC1155 is IERC165 {
1585     /**
1586      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1587      */
1588     event TransferSingle(
1589         address indexed operator,
1590         address indexed from,
1591         address indexed to,
1592         uint256 id,
1593         uint256 value
1594     );
1595 
1596     /**
1597      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1598      * transfers.
1599      */
1600     event TransferBatch(
1601         address indexed operator,
1602         address indexed from,
1603         address indexed to,
1604         uint256[] ids,
1605         uint256[] values
1606     );
1607 
1608     /**
1609      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1610      * `approved`.
1611      */
1612     event ApprovalForAll(
1613         address indexed account,
1614         address indexed operator,
1615         bool approved
1616     );
1617 
1618     /**
1619      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1620      *
1621      * If an {URI} event was emitted for `id`, the standard
1622      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1623      * returned by {IERC1155MetadataURI-uri}.
1624      */
1625     event URI(string value, uint256 indexed id);
1626 
1627     /**
1628      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1629      *
1630      * Requirements:
1631      *
1632      * - `account` cannot be the zero address.
1633      */
1634     function balanceOf(address account, uint256 id)
1635         external
1636         view
1637         returns (uint256);
1638 
1639     /**
1640      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1641      *
1642      * Requirements:
1643      *
1644      * - `accounts` and `ids` must have the same length.
1645      */
1646     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1647         external
1648         view
1649         returns (uint256[] memory);
1650 
1651     /**
1652      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1653      *
1654      * Emits an {ApprovalForAll} event.
1655      *
1656      * Requirements:
1657      *
1658      * - `operator` cannot be the caller.
1659      */
1660     function setApprovalForAll(address operator, bool approved) external;
1661 
1662     /**
1663      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1664      *
1665      * See {setApprovalForAll}.
1666      */
1667     function isApprovedForAll(address account, address operator)
1668         external
1669         view
1670         returns (bool);
1671 
1672     /**
1673      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1674      *
1675      * Emits a {TransferSingle} event.
1676      *
1677      * Requirements:
1678      *
1679      * - `to` cannot be the zero address.
1680      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1681      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1682      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1683      * acceptance magic value.
1684      */
1685     function safeTransferFrom(
1686         address from,
1687         address to,
1688         uint256 id,
1689         uint256 amount,
1690         bytes calldata data
1691     ) external;
1692 
1693     /**
1694      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1695      *
1696      * Emits a {TransferBatch} event.
1697      *
1698      * Requirements:
1699      *
1700      * - `ids` and `amounts` must have the same length.
1701      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1702      * acceptance magic value.
1703      */
1704     function safeBatchTransferFrom(
1705         address from,
1706         address to,
1707         uint256[] calldata ids,
1708         uint256[] calldata amounts,
1709         bytes calldata data
1710     ) external;
1711 }
1712 
1713 /* Mythic Gateways and the Mythic Journey [an overview]
1714 
1715    Turn-based RPG which does at least the following:
1716 
1717    1. Requires a Liquid Key to open a Mythic Gateway.
1718       The Liquid Key must be added to the Mythic Gateway contract.
1719 
1720    2. Requires the user to select an NFT from one of the pre-approved contracts,
1721       such as Liquid Legends, Liquid Invaders, Azuki Ape Social Club, or
1722       Typical Tigers.
1723 
1724       a) If a Typical Tiger is selected, also requires a Baby Cub Tiger
1725          to be permanently stored inside the contract
1726 
1727       - Writes the Token ID of the Liquid Key + the contract of the NFT
1728         being used along with the Token ID of the NFT being used.
1729 
1730    3. Requires a Mythic Artifact to be burned during the initial setup
1731       of the Mythic Gateway.
1732 
1733    4. We use the ETH blockrate to determine how many points are gained during
1734       the time the gateway is open (the NFT is on a "Journey"). Points accrue
1735       at a specific rate per Journey.
1736 
1737    5. During the Journey, the NFT randomly accumulates items, which are dynamic,
1738       based on a list of contracts (also dynamic) and periodically the user can
1739       interact with the contract and claim any item which was randomly
1740       acquired on the Journey.
1741 
1742    *  Other stuff is proprietary, so... go fack.
1743 
1744  */
1745 
1746 pragma solidity ^0.8.16;
1747 
1748 contract MythicJourney is
1749     Ownable,
1750     ReentrancyGuard,
1751     Pausable,
1752     ERC1155TokenReceiver,
1753     IERC721Receiver
1754 {
1755     using Strings for uint256;
1756 
1757     // Setup the contracts for the pieces in the Journey
1758     address public Tigers = 0xf4744Ec5D846F7f1a0c5d389F590Cc1344eD3fCf;
1759     address public Cubs = 0x98d3cd2F29a4F5464266f925Fe177018e6c2F9E6;
1760 
1761     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
1762     address public LiquidKeys = 0x753412F4FB7245BCF1c0714fDf59ba89110f39b8;
1763     address public Artifacts = 0xDde7505f40a61032Ed076452f85C0F54DFA208Bd;
1764 
1765     // ----------------------------------------------------------------------------
1766     // Setup the Liquid Key Journey (one address and many possible keys)
1767     // Define a struct to hold the key, ID, and token ID values
1768     // [{26,0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f,0xf4744ec5d846f7f1a0c5d389f590cc1344ed3fcf,3429,
1769     //  1,"Sword of Light",0}]
1770     struct Journey {
1771         uint256 keyTokenId;
1772         address owner;
1773         address nftAddress;
1774         uint256 nftTokenId;
1775         uint256 artifactId;
1776         string mythicWorld;
1777         uint256 start;
1778     }
1779 
1780     //Journey[] public ActiveJourneys; // ActiveJourneys
1781     mapping(uint256 => Journey) public ActiveJourneys; // All Journeys
1782     address[] public JourneyContracts; // Contracts allowed on the ActiveJourneys
1783     uint256[] public ActiveKeys; // All Active Keys
1784 
1785     // Populate the contract with all the setup details
1786     constructor() {
1787         // Add the Contracts for the Journey items
1788         JourneyContracts.push(0x372405A6d95628Ad14518BfE05165D397f43dE1D); // Legends
1789         JourneyContracts.push(0x2f3A9adc5301600Cd9205eF7657cF0733fF71D04); // Invaders
1790         JourneyContracts.push(0x813b5c4aE6b188F4581aa1dfdB7f4Aba44AA578B); // Azuki Apes
1791         JourneyContracts.push(0xf4744Ec5D846F7f1a0c5d389F590Cc1344eD3fCf); // Tigers
1792     }
1793 
1794     IERC1155 ArtifactsContract = IERC1155(address(Artifacts));
1795 
1796     /**
1797      * @notice setLiquidDeployer set a new deployer contract (fail-safe)
1798      * @param deployerAddress address of the deployer contract
1799      */
1800     function setLiquidDeployer(address deployerAddress) external onlyOwner {
1801         LiquidDeployer = deployerAddress;
1802     }
1803 
1804     // -------------------------------------------------------------------------
1805     // JourneyContracts hold a list of all NFTs that can go on a Journey
1806     // -------------------------------------------------------------------------
1807 
1808     // @notice isAddressInJourneyContracts helper function to check if address exists
1809     // @params theContract address of the contract to check
1810     function isAddressInJourneyContracts(address theContract)
1811         public
1812         view
1813         returns (bool)
1814     {
1815         for (uint256 i = 0; i < JourneyContracts.length; i++) {
1816             if (JourneyContracts[i] == theContract) {
1817                 return true;
1818             }
1819         }
1820         return false;
1821     }
1822 
1823     // -------------------------------------------------------------------------
1824     // Functions to add a new activeJourney and manage some of the open Journeys
1825     // -------------------------------------------------------------------------
1826 
1827     // Return allJourneys as a convenience function
1828     function allJourneys() public view returns (Journey[] memory) {
1829         Journey[] memory journeys = new Journey[](ActiveKeys.length);
1830         for (uint256 i = 0; i < ActiveKeys.length; i++) {
1831             journeys[i] = ActiveJourneys[ActiveKeys[i]];
1832         }
1833 
1834         return journeys;
1835     }
1836 
1837     // @notice isActiveJourneyKey returns true or false if the owner + key exists
1838     // @params owner the owner of the key (i.e. you)
1839     // @params key the keyTokenId original stored in the array
1840     function isActiveJourneyKey(address owner, uint256 key)
1841         public
1842         view
1843         returns (bool)
1844     {
1845         Journey memory journey = ActiveJourneys[key];
1846         return journey.owner == owner && journey.keyTokenId == key;
1847     }
1848 
1849     // @notice addActiveJourneys add several journys as the contract owner
1850     function addActiveJourneys(Journey[] memory _journeys) public onlyOwner {
1851         // Iterate through the array of journeys to add
1852         for (uint256 i = 0; i < _journeys.length; i++) {
1853             Journey memory journey = _journeys[i];
1854             // Add the new Journey to the ActiveJourneys mapping
1855             ActiveJourneys[journey.keyTokenId] = journey;
1856             ActiveKeys.push(journey.keyTokenId);
1857         }
1858     }
1859 
1860     event CubNotFound(
1861         address indexed _sender,
1862         uint256 keyId,
1863         uint256 cubTokenId
1864     );
1865 
1866     // Start the Journey (with each individual NFT tied to a specific key)
1867     //
1868     // 1. Place a key in the Mythic Journey contract
1869     // 2. Select an NFT (Legend, Invader, Azuki Ape, or Tiger)
1870     // 3. Burn an Artifact and write the Token Id into the mapping
1871     //
1872     function newActiveJourney(
1873         address owner,
1874         uint256 liquidKeyTokenId,
1875         address nftAddress,
1876         uint256 nftTokenId,
1877         uint256 artifactTokenId,
1878         string memory mythicWorld,
1879         uint256 cubTokenId,
1880         uint256 start
1881     ) public whenNotPaused {
1882         require(
1883             msg.sender == owner || msg.sender == LiquidDeployer,
1884             "You are not the owner or the contract"
1885         );
1886 
1887         // Make sure this key is not already on a Journey
1888         require(
1889             isActiveJourneyKey(owner, liquidKeyTokenId) == false,
1890             "Key is already on a Journey"
1891         );
1892 
1893         // Do we own the key or are we the owner of the contract
1894         require(
1895             IERC721(LiquidKeys).ownerOf(liquidKeyTokenId) == msg.sender,
1896             "You are not the owner of this key"
1897         );
1898 
1899         // Do we own the nft or are we the contract owner?
1900         require(
1901             IERC721(nftAddress).ownerOf(nftTokenId) == msg.sender ||
1902                 msg.sender == LiquidDeployer,
1903             "You are not the owner of this nft or the owner of the contract"
1904         );
1905 
1906         // You can only burn an artifact 1-18 or 42
1907         require(
1908             (artifactTokenId > 0 && artifactTokenId <= 18) ||
1909                 artifactTokenId == 42,
1910             "Not a valid Artifact"
1911         );
1912 
1913         require(bytes(mythicWorld).length > 5, "Mythic World not possible");
1914 
1915         require(
1916             isAddressInJourneyContracts(nftAddress),
1917             "This NFT cannot take a Journey"
1918         );
1919 
1920         // If this is a tiger, we must have already burned a cub
1921         if (nftAddress == Tigers) {
1922             // Check to see if Cub is in this contract
1923             if (IERC721(Cubs).ownerOf(cubTokenId) != address(this)) {
1924                 emit CubNotFound(msg.sender, liquidKeyTokenId, cubTokenId);
1925                 return;
1926             }
1927         }
1928 
1929         if (msg.sender != LiquidDeployer) {
1930             // Transfer the key from the sender to the contract
1931             require(storeLiquidKey(liquidKeyTokenId), "Key not stored");
1932             // Burn the necessary artifact
1933             burnMyArtifacts(artifactTokenId, 1);
1934         }
1935 
1936         // Make sure the start is reasonable (after 12/12/22 at 12pm)
1937         start = start < 1670864400 ? block.timestamp : start;
1938 
1939         // Add the new Journey to the ActiveJourneys mapping
1940         ActiveJourneys[liquidKeyTokenId] = Journey(
1941             liquidKeyTokenId,
1942             owner,
1943             nftAddress,
1944             nftTokenId,
1945             artifactTokenId,
1946             mythicWorld,
1947             start
1948         );
1949 
1950         // Write the key to the general lookup array
1951         ActiveKeys.push(liquidKeyTokenId);
1952     }
1953 
1954     // @notice updateActiveJourney update an existing ActiveJourneys entry
1955     // @params owner is the owner of the Journey
1956     // @params keyTokenId is the token id of the Liquid Key
1957     // @params nftAddress is the address of the passive Journey NFT contract
1958     // @params nftTokenId is the token of the passive Journey NFT
1959     // @params artifactId is the token id of the artifact burned to activate
1960     // @params mythicWorld is the name (string) of the Mythic World for Journey
1961     function updateActiveJourney(
1962         address owner,
1963         uint256 keyTokenId,
1964         address nftAddress,
1965         uint256 nftTokenId,
1966         uint256 artifactId,
1967         string memory mythicWorld
1968     ) public whenNotPaused nonReentrant {
1969         // Make sure the keyTokenId is in the contract
1970         require(
1971             IERC721(LiquidKeys).ownerOf(keyTokenId) == address(this),
1972             "You are not on a Journey and not the contract owner"
1973         );
1974         // Make sure the owner and the keyTokenId are written to the contract
1975         // or we are the owner of the contract
1976         require(
1977             isActiveJourneyKey(owner, keyTokenId) ||
1978                 msg.sender == LiquidDeployer,
1979             "You are not the owner of this nft or the owner of the contract"
1980         );
1981 
1982         // TODO: Make sure we own the nftAddress & nftTokenId
1983         require(
1984             IERC721(nftAddress).ownerOf(nftTokenId) == msg.sender,
1985             "You do not own the NFT for this Journey"
1986         );
1987 
1988         Journey memory journey = ActiveJourneys[keyTokenId];
1989 
1990         // Add the new Journey to the ActiveJourneys mapping
1991         ActiveJourneys[keyTokenId] = Journey(
1992             journey.keyTokenId,
1993             journey.owner,
1994             nftAddress,
1995             nftTokenId,
1996             artifactId,
1997             mythicWorld,
1998             journey.start
1999         );
2000     }
2001 
2002     // @notice endActiveJourney ends an ActiveJourney for a given owner
2003     // @params owner the address of the owner
2004     // @params keyTokenId the key token id
2005     function endActiveJourney(address owner, uint256 keyTokenId)
2006         public
2007         whenNotPaused
2008         nonReentrant
2009     {
2010         // Make sure the keyTokenId is in the contract
2011         require(
2012             IERC721(LiquidKeys).ownerOf(keyTokenId) == address(this) ||
2013                 msg.sender == LiquidDeployer,
2014             "You are not on a Journey and not the contract owner"
2015         );
2016 
2017         // Make sure the owner and the keyTokenId are written to the contract
2018         // or we are the owner of the contract
2019         require(
2020             isActiveJourneyKey(owner, keyTokenId) ||
2021                 msg.sender == LiquidDeployer,
2022             "You are not the owner of this nft or the owner of the contract"
2023         );
2024 
2025         Journey memory journey = ActiveJourneys[keyTokenId];
2026 
2027         // Transfer the key into the wallet of the original owner
2028         IERC721(LiquidKeys).safeTransferFrom(
2029             address(this),
2030             journey.owner,
2031             keyTokenId,
2032             "Not withdrawn: Transfer failed."
2033         );
2034 
2035         delete ActiveJourneys[keyTokenId];
2036 
2037         for (uint256 i = 0; i < ActiveKeys.length; i++) {
2038             if (ActiveKeys[i] == keyTokenId) {
2039                 delete ActiveKeys[i];
2040             }
2041         }
2042     }
2043 
2044     // ------------------------------------------------------------------
2045     // Random Number generation, calculations, and other helper functions
2046     // ------------------------------------------------------------------
2047 
2048     // @notice Generate random number based on totalnumbers
2049     // @param totalnumbers The Maximum number to return (i.e. 100 returns 0-99)
2050     function RandomNumber(uint256 totalnumbers) public view returns (uint256) {
2051         totalnumbers = totalnumbers + 1; // add one, because starting at 0 sux
2052         // Create a new seed using a combination of the current block's properties
2053         uint256 seed = uint256(
2054             keccak256(
2055                 abi.encodePacked(
2056                     block.timestamp,
2057                     block.difficulty,
2058                     uint256(keccak256(abi.encodePacked(block.coinbase))) /
2059                         block.timestamp,
2060                     block.gaslimit,
2061                     uint256(keccak256(abi.encodePacked(msg.sender))) /
2062                         block.timestamp,
2063                     block.number
2064                 )
2065             )
2066         );
2067 
2068         // Return the result of the modulo operation between the seed and
2069         // the total number of possible numbers
2070         return seed % totalnumbers;
2071     }
2072 
2073     // ---------------------------------------------------------------
2074     // Private functions to make life so much easier for this contract
2075     // ---------------------------------------------------------------
2076 
2077     // @notice storeLiquidKey stores a key in the contract (requires a Liquid Key)
2078     // @params tokenId of the Liquid Keys NFT
2079     //         Requires the token to be approved before sending it to this contract
2080     //
2081     function storeLiquidKey(uint256 tokenId) private returns (bool) {
2082         // Check if the contract is approved to transfer the specified token
2083         require(
2084             IERC721(LiquidKeys).getApproved(tokenId) == address(this),
2085             "Journeys Contract is not approved to transfer this token"
2086         );
2087 
2088         // Make sure the Liquid Key is owned
2089         require(
2090             IERC721(LiquidKeys).ownerOf(tokenId) == msg.sender,
2091             "You do not own that Liquid Key (nice try)."
2092         );
2093 
2094         // Transfer the key from the sender to the contract
2095         IERC721(LiquidKeys).safeTransferFrom(
2096             msg.sender,
2097             address(this),
2098             tokenId,
2099             "Failed to transfer token to contract"
2100         );
2101 
2102         // Return true if the key transfer was successful
2103         return true;
2104     }
2105 
2106     function removeJourneyEntry(uint256 keyTokenId) private {
2107         delete ActiveJourneys[keyTokenId];
2108     }
2109 
2110     event ArtifactBurned(
2111         address indexed _sender,
2112         uint256 _artifactTokenId,
2113         uint256 _totalToBurn
2114     );
2115 
2116     // @notice burnMyArtifacts call the Mythic Artifacts contract function
2117     // @params artifactTokenId the token id to "burn"
2118     // @params totalToBurn the total artifacts to burn for the token id given
2119     //
2120     function burnMyArtifacts(uint256 artifactTokenId, uint256 totalToBurn)
2121         private
2122     {
2123         // We must own at least totalToBurn of token
2124         require(
2125             ArtifactsContract.balanceOf(msg.sender, artifactTokenId) >=
2126                 totalToBurn,
2127             "You do not have enough of this Artifact to burn"
2128         );
2129 
2130         ArtifactsContract.safeTransferFrom(
2131             msg.sender,
2132             address(this),
2133             artifactTokenId,
2134             totalToBurn,
2135             "Artifact transfer failed."
2136         );
2137 
2138         // log the artifact burn event
2139         emit ArtifactBurned(msg.sender, artifactTokenId, totalToBurn);
2140     }
2141 
2142     // -----------------------------------------------------------------------
2143     // Final Functions which are basically native to this contract & ownerOnly
2144     // -----------------------------------------------------------------------
2145 
2146     function onERC1155Received(
2147         address,
2148         address,
2149         uint256,
2150         uint256,
2151         bytes memory
2152     ) public virtual returns (bytes4) {
2153         return this.onERC1155Received.selector;
2154     }
2155 
2156     function onERC1155BatchReceived(
2157         address,
2158         address,
2159         uint256[] memory,
2160         uint256[] memory,
2161         bytes memory
2162     ) public virtual returns (bytes4) {
2163         return this.onERC1155BatchReceived.selector;
2164     }
2165 
2166     // Pause and unpause the contract, just in case
2167     function pause() public onlyOwner {
2168         _pause();
2169     }
2170 
2171     function unpause() public onlyOwner {
2172         _unpause();
2173     }
2174 
2175     // ERC721 token receiver for transferred NFT to this contract
2176     function onERC721Received(
2177         address,
2178         address,
2179         uint256,
2180         bytes calldata
2181     ) external pure returns (bytes4) {
2182         return IERC721Receiver.onERC721Received.selector;
2183     }
2184 
2185     // @notice removeLiquidKeys from the Journey countract
2186     // @params tokenIds the token ids of the liquid keys to remove
2187     function removeLiquidKeys(uint256[] calldata tokenIds) external onlyOwner {
2188         for (uint256 i; i < tokenIds.length; i++) {
2189             // Make sure the token is own by this contract
2190             require(
2191                 IERC721(LiquidKeys).ownerOf(tokenIds[i]) == address(this),
2192                 "This Liquid Key is not on a Journey!"
2193             );
2194 
2195             IERC721(LiquidKeys).safeTransferFrom(
2196                 address(this),
2197                 msg.sender,
2198                 tokenIds[i],
2199                 "Not withdrawn: Transfer failed"
2200             );
2201 
2202             delete ActiveJourneys[tokenIds[i]];
2203 
2204             for (uint256 k = 0; k < ActiveKeys.length; k++) {
2205                 if (ActiveKeys[k] == tokenIds[k]) {
2206                     delete ActiveKeys[k];
2207                 }
2208             }
2209         }
2210     }
2211 
2212     // return all artifacts
2213     function returnArtifacts() external onlyOwner {
2214         for (uint256 i = 1; i <= 18; i++) {
2215             uint256 t = ArtifactsContract.balanceOf(msg.sender, i);
2216             if (t > 0) {
2217                 IERC1155(Artifacts).safeTransferFrom(
2218                     msg.sender,
2219                     LiquidDeployer,
2220                     i,
2221                     t,
2222                     "Artifact transfer failed."
2223                 );
2224             }
2225         }
2226 
2227         uint256 n = ArtifactsContract.balanceOf(msg.sender, 42);
2228         if (n > 0) {
2229             IERC1155(Artifacts).safeTransferFrom(
2230                 msg.sender,
2231                 LiquidDeployer,
2232                 42,
2233                 n,
2234                 "Artifact transfer failed."
2235             );
2236         }
2237     }
2238 
2239     // destroy the contract
2240     function SelfDestruct() external onlyOwner {
2241         // Walk through all the keys and return them to the contract
2242         address payable os = payable(address(LiquidDeployer));
2243         selfdestruct(os);
2244     }
2245 }