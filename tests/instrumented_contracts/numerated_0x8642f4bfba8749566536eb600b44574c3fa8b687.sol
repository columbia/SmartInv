1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // dev address is 0xEaC458B2F78b8cb37c9471A9A0723b4Aa6b4c62D
8 
9 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Interface of the ERC165 standard, as defined in the
17  * https://eips.ethereum.org/EIPS/eip-165[EIP].
18  *
19  * Implementers can declare support of contract interfaces, which can then be
20  * queried by others ({ERC165Checker}).
21  *
22  * For an implementation, see {ERC165}.
23  */
24 interface IERC165 {
25     /**
26      * @dev Returns true if this contract implements the interface defined by
27      * `interfaceId`. See the corresponding
28      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
29      * to learn more about how these ids are created.
30      *
31      * This function call must use less than 30 000 gas.
32      */
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
37 
38 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Required interface of an ERC721 compliant contract.
44  */
45 interface IERC721 is IERC165 {
46     /**
47      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
48      */
49     event Transfer(
50         address indexed from,
51         address indexed to,
52         uint256 indexed tokenId
53     );
54 
55     /**
56      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
57      */
58     event Approval(
59         address indexed owner,
60         address indexed approved,
61         uint256 indexed tokenId
62     );
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(
68         address indexed owner,
69         address indexed operator,
70         bool approved
71     );
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId)
150         external
151         view
152         returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator)
172         external
173         view
174         returns (bool);
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId,
193         bytes calldata data
194     ) external;
195 }
196 
197 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
198 
199 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @title ERC721 token receiver interface
205  * @dev Interface for any contract that wants to support safeTransfers
206  * from ERC721 asset contracts.
207  */
208 interface IERC721Receiver {
209     /**
210      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
211      * by `operator` from `from`, this function is called.
212      *
213      * It must return its Solidity selector to confirm the token transfer.
214      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
215      *
216      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
217      */
218     function onERC721Received(
219         address operator,
220         address from,
221         uint256 tokenId,
222         bytes calldata data
223     ) external returns (bytes4);
224 }
225 
226 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
227 
228 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
234  * @dev See https://eips.ethereum.org/EIPS/eip-721
235  */
236 interface IERC721Metadata is IERC721 {
237     /**
238      * @dev Returns the token collection name.
239      */
240     function name() external view returns (string memory);
241 
242     /**
243      * @dev Returns the token collection symbol.
244      */
245     function symbol() external view returns (string memory);
246 
247     /**
248      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
249      */
250     function tokenURI(uint256 tokenId) external view returns (string memory);
251 }
252 
253 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
254 
255 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Enumerable is IERC721 {
264     /**
265      * @dev Returns the total amount of tokens stored by the contract.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
271      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
272      */
273     function tokenOfOwnerByIndex(address owner, uint256 index)
274         external
275         view
276         returns (uint256);
277 
278     /**
279      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
280      * Use along with {totalSupply} to enumerate all tokens.
281      */
282     function tokenByIndex(uint256 index) external view returns (uint256);
283 }
284 
285 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
286 
287 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
288 
289 pragma solidity ^0.8.1;
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      *
312      * [IMPORTANT]
313      * ====
314      * You shouldn't rely on `isContract` to protect against flash loan attacks!
315      *
316      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
317      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
318      * constructor.
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize/address.code.length, which returns 0
323         // for contracts in construction, since the code is only stored at the end
324         // of the constructor execution.
325 
326         return account.code.length > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(
347             address(this).balance >= amount,
348             "Address: insufficient balance"
349         );
350 
351         (bool success, ) = recipient.call{value: amount}("");
352         require(
353             success,
354             "Address: unable to send value, recipient may have reverted"
355         );
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain `call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data)
377         internal
378         returns (bytes memory)
379     {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return
414             functionCallWithValue(
415                 target,
416                 data,
417                 value,
418                 "Address: low-level call with value failed"
419             );
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(
435             address(this).balance >= value,
436             "Address: insufficient balance for call"
437         );
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(
441             data
442         );
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data)
453         internal
454         view
455         returns (bytes memory)
456     {
457         return
458             functionStaticCall(
459                 target,
460                 data,
461                 "Address: low-level static call failed"
462             );
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.staticcall(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(address target, bytes memory data)
489         internal
490         returns (bytes memory)
491     {
492         return
493             functionDelegateCall(
494                 target,
495                 data,
496                 "Address: low-level delegate call failed"
497             );
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
519      * revert reason using the provided one.
520      *
521      * _Available since v4.3._
522      */
523     function verifyCallResult(
524         bool success,
525         bytes memory returndata,
526         string memory errorMessage
527     ) internal pure returns (bytes memory) {
528         if (success) {
529             return returndata;
530         } else {
531             // Look for revert reason and bubble it up if present
532             if (returndata.length > 0) {
533                 // The easiest way to bubble the revert reason is using memory via assembly
534 
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Provides information about the current execution context, including the
554  * sender of the transaction and its data. While these are generally available
555  * via msg.sender and msg.data, they should not be accessed in such a direct
556  * manner, since when dealing with meta-transactions the account sending and
557  * paying for execution may not be the actual sender (as far as an application
558  * is concerned).
559  *
560  * This contract is only required for intermediate, library-like contracts.
561  */
562 abstract contract Context {
563     function _msgSender() internal view virtual returns (address) {
564         return msg.sender;
565     }
566 
567     function _msgData() internal view virtual returns (bytes calldata) {
568         return msg.data;
569     }
570 }
571 
572 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev String operations.
580  */
581 library Strings {
582     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
583 
584     /**
585      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
586      */
587     function toString(uint256 value) internal pure returns (string memory) {
588         // Inspired by OraclizeAPI's implementation - MIT licence
589         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
590 
591         if (value == 0) {
592             return "0";
593         }
594         uint256 temp = value;
595         uint256 digits;
596         while (temp != 0) {
597             digits++;
598             temp /= 10;
599         }
600         bytes memory buffer = new bytes(digits);
601         while (value != 0) {
602             digits -= 1;
603             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
604             value /= 10;
605         }
606         return string(buffer);
607     }
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
611      */
612     function toHexString(uint256 value) internal pure returns (string memory) {
613         if (value == 0) {
614             return "0x00";
615         }
616         uint256 temp = value;
617         uint256 length = 0;
618         while (temp != 0) {
619             length++;
620             temp >>= 8;
621         }
622         return toHexString(value, length);
623     }
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
627      */
628     function toHexString(uint256 value, uint256 length)
629         internal
630         pure
631         returns (string memory)
632     {
633         bytes memory buffer = new bytes(2 * length + 2);
634         buffer[0] = "0";
635         buffer[1] = "x";
636         for (uint256 i = 2 * length + 1; i > 1; --i) {
637             buffer[i] = _HEX_SYMBOLS[value & 0xf];
638             value >>= 4;
639         }
640         require(value == 0, "Strings: hex length insufficient");
641         return string(buffer);
642     }
643 }
644 
645 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
646 
647 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 /**
652  * @dev Implementation of the {IERC165} interface.
653  *
654  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
655  * for the additional interface id that will be supported. For example:
656  *
657  * ```solidity
658  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
660  * }
661  * ```
662  *
663  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
664  */
665 abstract contract ERC165 is IERC165 {
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId)
670         public
671         view
672         virtual
673         override
674         returns (bool)
675     {
676         return interfaceId == type(IERC165).interfaceId;
677     }
678 }
679 
680 // File erc721a/contracts/ERC721A.sol@v3.0.0
681 
682 // Creator: Chiru Labs
683 
684 pragma solidity ^0.8.4;
685 
686 error ApprovalCallerNotOwnerNorApproved();
687 error ApprovalQueryForNonexistentToken();
688 error ApproveToCaller();
689 error ApprovalToCurrentOwner();
690 error BalanceQueryForZeroAddress();
691 error MintedQueryForZeroAddress();
692 error BurnedQueryForZeroAddress();
693 error AuxQueryForZeroAddress();
694 error MintToZeroAddress();
695 error MintZeroQuantity();
696 error OwnerIndexOutOfBounds();
697 error OwnerQueryForNonexistentToken();
698 error TokenIndexOutOfBounds();
699 error TransferCallerNotOwnerNorApproved();
700 error TransferFromIncorrectOwner();
701 error TransferToNonERC721ReceiverImplementer();
702 error TransferToZeroAddress();
703 error URIQueryForNonexistentToken();
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata extension. Built to optimize for lower gas during batch mints.
708  *
709  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
710  *
711  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
712  *
713  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
714  */
715 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
716     using Address for address;
717     using Strings for uint256;
718 
719     // Compiler will pack this into a single 256bit word.
720     struct TokenOwnership {
721         // The address of the owner.
722         address addr;
723         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
724         uint64 startTimestamp;
725         // Whether the token has been burned.
726         bool burned;
727     }
728 
729     // Compiler will pack this into a single 256bit word.
730     struct AddressData {
731         // Realistically, 2**64-1 is more than enough.
732         uint64 balance;
733         // Keeps track of mint count with minimal overhead for tokenomics.
734         uint64 numberMinted;
735         // Keeps track of burn count with minimal overhead for tokenomics.
736         uint64 numberBurned;
737         // For miscellaneous variable(s) pertaining to the address
738         // (e.g. number of whitelist mint slots used).
739         // If there are multiple variables, please pack them into a uint64.
740         uint64 aux;
741     }
742 
743     // The tokenId of the next token to be minted.
744     uint256 internal _currentIndex;
745 
746     // The number of tokens burned.
747     uint256 internal _burnCounter;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to ownership details
756     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
757     mapping(uint256 => TokenOwnership) internal _ownerships;
758 
759     // Mapping owner address to address data
760     mapping(address => AddressData) private _addressData;
761 
762     // Mapping from token ID to approved address
763     mapping(uint256 => address) private _tokenApprovals;
764 
765     // Mapping from owner to operator approvals
766     mapping(address => mapping(address => bool)) private _operatorApprovals;
767 
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771         _currentIndex = _startTokenId();
772     }
773 
774     /**
775      * To change the starting tokenId, please override this function.
776      */
777     function _startTokenId() internal view virtual returns (uint256) {
778         return 0;
779     }
780 
781     /**
782      * @dev See {IERC721Enumerable-totalSupply}.
783      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
784      */
785     function totalSupply() public view returns (uint256) {
786         // Counter underflow is impossible as _burnCounter cannot be incremented
787         // more than _currentIndex - _startTokenId() times
788         unchecked {
789             return _currentIndex - _burnCounter - _startTokenId();
790         }
791     }
792 
793     /**
794      * Returns the total amount of tokens minted in the contract.
795      */
796     function _totalMinted() internal view returns (uint256) {
797         // Counter underflow is impossible as _currentIndex does not decrement,
798         // and it is initialized to _startTokenId()
799         unchecked {
800             return _currentIndex - _startTokenId();
801         }
802     }
803 
804     /**
805      * @dev See {IERC165-supportsInterface}.
806      */
807     function supportsInterface(bytes4 interfaceId)
808         public
809         view
810         virtual
811         override(ERC165, IERC165)
812         returns (bool)
813     {
814         return
815             interfaceId == type(IERC721).interfaceId ||
816             interfaceId == type(IERC721Metadata).interfaceId ||
817             super.supportsInterface(interfaceId);
818     }
819 
820     /**
821      * @dev See {IERC721-balanceOf}.
822      */
823     function balanceOf(address owner) public view override returns (uint256) {
824         if (owner == address(0)) revert BalanceQueryForZeroAddress();
825         return uint256(_addressData[owner].balance);
826     }
827 
828     /**
829      * Returns the number of tokens minted by `owner`.
830      */
831     function _numberMinted(address owner) internal view returns (uint256) {
832         if (owner == address(0)) revert MintedQueryForZeroAddress();
833         return uint256(_addressData[owner].numberMinted);
834     }
835 
836     /**
837      * Returns the number of tokens burned by or on behalf of `owner`.
838      */
839     function _numberBurned(address owner) internal view returns (uint256) {
840         if (owner == address(0)) revert BurnedQueryForZeroAddress();
841         return uint256(_addressData[owner].numberBurned);
842     }
843 
844     /**
845      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
846      */
847     function _getAux(address owner) internal view returns (uint64) {
848         if (owner == address(0)) revert AuxQueryForZeroAddress();
849         return _addressData[owner].aux;
850     }
851 
852     /**
853      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
854      * If there are multiple variables, please pack them into a uint64.
855      */
856     function _setAux(address owner, uint64 aux) internal {
857         if (owner == address(0)) revert AuxQueryForZeroAddress();
858         _addressData[owner].aux = aux;
859     }
860 
861     /**
862      * Gas spent here starts off proportional to the maximum mint batch size.
863      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
864      */
865     function ownershipOf(uint256 tokenId)
866         internal
867         view
868         returns (TokenOwnership memory)
869     {
870         uint256 curr = tokenId;
871 
872         unchecked {
873             if (_startTokenId() <= curr && curr < _currentIndex) {
874                 TokenOwnership memory ownership = _ownerships[curr];
875                 if (!ownership.burned) {
876                     if (ownership.addr != address(0)) {
877                         return ownership;
878                     }
879                     // Invariant:
880                     // There will always be an ownership that has an address and is not burned
881                     // before an ownership that does not have an address and is not burned.
882                     // Hence, curr will not underflow.
883                     while (true) {
884                         curr--;
885                         ownership = _ownerships[curr];
886                         if (ownership.addr != address(0)) {
887                             return ownership;
888                         }
889                     }
890                 }
891             }
892         }
893         revert OwnerQueryForNonexistentToken();
894     }
895 
896     /**
897      * @dev See {IERC721-ownerOf}.
898      */
899     function ownerOf(uint256 tokenId) public view override returns (address) {
900         return ownershipOf(tokenId).addr;
901     }
902 
903     /**
904      * @dev See {IERC721Metadata-name}.
905      */
906     function name() public view virtual override returns (string memory) {
907         return _name;
908     }
909 
910     /**
911      * @dev See {IERC721Metadata-symbol}.
912      */
913     function symbol() public view virtual override returns (string memory) {
914         return _symbol;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-tokenURI}.
919      */
920     function tokenURI(uint256 tokenId)
921         public
922         view
923         virtual
924         override
925         returns (string memory)
926     {
927         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
928 
929         string memory baseURI = _baseURI();
930         return
931             bytes(baseURI).length != 0
932                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
933                 : "";
934     }
935 
936     /**
937      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
938      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
939      * by default, can be overriden in child contracts.
940      */
941     function _baseURI() internal view virtual returns (string memory) {
942         return "";
943     }
944 
945     /**
946      * @dev See {IERC721-approve}.
947      */
948     function approve(address to, uint256 tokenId) public override {
949         address owner = ERC721A.ownerOf(tokenId);
950         if (to == owner) revert ApprovalToCurrentOwner();
951 
952         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
953             revert ApprovalCallerNotOwnerNorApproved();
954         }
955 
956         _approve(to, tokenId, owner);
957     }
958 
959     /**
960      * @dev See {IERC721-getApproved}.
961      */
962     function getApproved(uint256 tokenId)
963         public
964         view
965         override
966         returns (address)
967     {
968         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
969 
970         return _tokenApprovals[tokenId];
971     }
972 
973     /**
974      * @dev See {IERC721-setApprovalForAll}.
975      */
976     function setApprovalForAll(address operator, bool approved)
977         public
978         override
979     {
980         if (operator == _msgSender()) revert ApproveToCaller();
981 
982         _operatorApprovals[_msgSender()][operator] = approved;
983         emit ApprovalForAll(_msgSender(), operator, approved);
984     }
985 
986     /**
987      * @dev See {IERC721-isApprovedForAll}.
988      */
989     function isApprovedForAll(address owner, address operator)
990         public
991         view
992         virtual
993         override
994         returns (bool)
995     {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         _transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         safeTransferFrom(from, to, tokenId, "");
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031         if (
1032             to.isContract() &&
1033             !_checkContractOnERC721Received(from, to, tokenId, _data)
1034         ) {
1035             revert TransferToNonERC721ReceiverImplementer();
1036         }
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      */
1046     function _exists(uint256 tokenId) internal view returns (bool) {
1047         return
1048             _startTokenId() <= tokenId &&
1049             tokenId < _currentIndex &&
1050             !_ownerships[tokenId].burned;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, "");
1055     }
1056 
1057     /**
1058      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         _mint(to, quantity, _data, true);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             if (safe && to.isContract()) {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex);
1113                     if (
1114                         !_checkContractOnERC721Received(
1115                             address(0),
1116                             to,
1117                             updatedIndex++,
1118                             _data
1119                         )
1120                     ) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex != end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex != end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) private {
1151         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1152 
1153         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1154             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1155             getApproved(tokenId) == _msgSender());
1156 
1157         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1158         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1159         if (to == address(0)) revert TransferToZeroAddress();
1160 
1161         _beforeTokenTransfers(from, to, tokenId, 1);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId, prevOwnership.addr);
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             _addressData[from].balance -= 1;
1171             _addressData[to].balance += 1;
1172 
1173             _ownerships[tokenId].addr = to;
1174             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1177             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1178             uint256 nextTokenId = tokenId + 1;
1179             if (_ownerships[nextTokenId].addr == address(0)) {
1180                 // This will suffice for checking _exists(nextTokenId),
1181                 // as a burned slot cannot contain the zero address.
1182                 if (nextTokenId < _currentIndex) {
1183                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1184                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1185                         .startTimestamp;
1186                 }
1187             }
1188         }
1189 
1190         emit Transfer(from, to, tokenId);
1191         _afterTokenTransfers(from, to, tokenId, 1);
1192     }
1193 
1194     /**
1195      * @dev Destroys `tokenId`.
1196      * The approval is cleared when the token is burned.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must exist.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _burn(uint256 tokenId) internal virtual {
1205         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1206 
1207         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1208 
1209         // Clear approvals from the previous owner
1210         _approve(address(0), tokenId, prevOwnership.addr);
1211 
1212         // Underflow of the sender's balance is impossible because we check for
1213         // ownership above and the recipient's balance can't realistically overflow.
1214         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1215         unchecked {
1216             _addressData[prevOwnership.addr].balance -= 1;
1217             _addressData[prevOwnership.addr].numberBurned += 1;
1218 
1219             // Keep track of who burned the token, and the timestamp of burning.
1220             _ownerships[tokenId].addr = prevOwnership.addr;
1221             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1222             _ownerships[tokenId].burned = true;
1223 
1224             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1225             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226             uint256 nextTokenId = tokenId + 1;
1227             if (_ownerships[nextTokenId].addr == address(0)) {
1228                 // This will suffice for checking _exists(nextTokenId),
1229                 // as a burned slot cannot contain the zero address.
1230                 if (nextTokenId < _currentIndex) {
1231                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1232                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1233                         .startTimestamp;
1234                 }
1235             }
1236         }
1237 
1238         emit Transfer(prevOwnership.addr, address(0), tokenId);
1239         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1240 
1241         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1242         unchecked {
1243             _burnCounter++;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Approve `to` to operate on `tokenId`
1249      *
1250      * Emits a {Approval} event.
1251      */
1252     function _approve(
1253         address to,
1254         uint256 tokenId,
1255         address owner
1256     ) private {
1257         _tokenApprovals[tokenId] = to;
1258         emit Approval(owner, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1263      *
1264      * @param from address representing the previous owner of the given token ID
1265      * @param to target address that will receive the tokens
1266      * @param tokenId uint256 ID of the token to be transferred
1267      * @param _data bytes optional data to send along with the call
1268      * @return bool whether the call correctly returned the expected magic value
1269      */
1270     function _checkContractOnERC721Received(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) private returns (bool) {
1276         try
1277             IERC721Receiver(to).onERC721Received(
1278                 _msgSender(),
1279                 from,
1280                 tokenId,
1281                 _data
1282             )
1283         returns (bytes4 retval) {
1284             return retval == IERC721Receiver(to).onERC721Received.selector;
1285         } catch (bytes memory reason) {
1286             if (reason.length == 0) {
1287                 revert TransferToNonERC721ReceiverImplementer();
1288             } else {
1289                 assembly {
1290                     revert(add(32, reason), mload(reason))
1291                 }
1292             }
1293         }
1294     }
1295 
1296     /**
1297      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1298      * And also called before burning one token.
1299      *
1300      * startTokenId - the first token id to be transferred
1301      * quantity - the amount to be transferred
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` will be minted for `to`.
1308      * - When `to` is zero, `tokenId` will be burned by `from`.
1309      * - `from` and `to` are never both zero.
1310      */
1311     function _beforeTokenTransfers(
1312         address from,
1313         address to,
1314         uint256 startTokenId,
1315         uint256 quantity
1316     ) internal virtual {}
1317 
1318     /**
1319      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1320      * minting.
1321      * And also called after one token has been burned.
1322      *
1323      * startTokenId - the first token id to be transferred
1324      * quantity - the amount to be transferred
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` has been minted for `to`.
1331      * - When `to` is zero, `tokenId` has been burned by `from`.
1332      * - `from` and `to` are never both zero.
1333      */
1334     function _afterTokenTransfers(
1335         address from,
1336         address to,
1337         uint256 startTokenId,
1338         uint256 quantity
1339     ) internal virtual {}
1340 }
1341 
1342 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1343 
1344 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 /**
1349  * @dev Contract module which provides a basic access control mechanism, where
1350  * there is an account (an owner) that can be granted exclusive access to
1351  * specific functions.
1352  *
1353  * By default, the owner account will be the one that deploys the contract. This
1354  * can later be changed with {transferOwnership}.
1355  *
1356  * This module is used through inheritance. It will make available the modifier
1357  * `onlyOwner`, which can be applied to your functions to restrict their use to
1358  * the owner.
1359  */
1360 abstract contract Ownable is Context {
1361     address private _owner;
1362 
1363     event OwnershipTransferred(
1364         address indexed previousOwner,
1365         address indexed newOwner
1366     );
1367 
1368     /**
1369      * @dev Initializes the contract setting the deployer as the initial owner.
1370      */
1371     constructor() {
1372         _transferOwnership(_msgSender());
1373     }
1374 
1375     /**
1376      * @dev Returns the address of the current owner.
1377      */
1378     function owner() public view virtual returns (address) {
1379         return _owner;
1380     }
1381 
1382     /**
1383      * @dev Throws if called by any account other than the owner.
1384      */
1385     modifier onlyOwner() {
1386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1387         _;
1388     }
1389 
1390     /**
1391      * @dev Leaves the contract without owner. It will not be possible to call
1392      * `onlyOwner` functions anymore. Can only be called by the current owner.
1393      *
1394      * NOTE: Renouncing ownership will leave the contract without an owner,
1395      * thereby removing any functionality that is only available to the owner.
1396      */
1397     function renounceOwnership() public virtual onlyOwner {
1398         _transferOwnership(address(0));
1399     }
1400 
1401     /**
1402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1403      * Can only be called by the current owner.
1404      */
1405     function transferOwnership(address newOwner) public virtual onlyOwner {
1406         require(
1407             newOwner != address(0),
1408             "Ownable: new owner is the zero address"
1409         );
1410         _transferOwnership(newOwner);
1411     }
1412 
1413     /**
1414      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1415      * Internal function without access restriction.
1416      */
1417     function _transferOwnership(address newOwner) internal virtual {
1418         address oldOwner = _owner;
1419         _owner = newOwner;
1420         emit OwnershipTransferred(oldOwner, newOwner);
1421     }
1422 }
1423 
1424 // File contracts/goblinpets.sol
1425 
1426 pragma solidity ^0.8.4;
1427 
1428 contract Goblinpets is ERC721A, Ownable {
1429     uint256 public constant MAX_ELEMENTS = 5000;
1430     uint256 public constant MAX_PER_WALLET = 5;
1431     uint256 public constant premium = 0.0025 ether;
1432     mapping(address => uint256) public mintCount;
1433 
1434     string public baseTokenURI;
1435 
1436     address public dev = 0xEaC458B2F78b8cb37c9471A9A0723b4Aa6b4c62D;
1437 
1438     constructor(string memory baseURI) ERC721A("Goblinpets", "GP") {
1439         _safeMint(msg.sender, 462);
1440         _safeMint(dev, 38);
1441         setBaseURI(baseURI);
1442     }
1443 
1444     /**
1445      * @dev Mint the _amount of tokens
1446      * @param _amount is the token count
1447      */
1448     function mint(uint256 _amount) external payable {
1449         uint256 supply = totalSupply();
1450         require(supply + _amount <= MAX_ELEMENTS, "Sale ends");
1451         require(msg.value >= price(_amount), "Not enough");
1452         mintCount[msg.sender] += _amount;
1453         require(mintCount[msg.sender] <= MAX_PER_WALLET, "Exceed Max");
1454         _safeMint(msg.sender, _amount);
1455     }
1456 
1457     function _startTokenId() internal pure override returns (uint256) {
1458         return 1;
1459     }
1460 
1461     function burn(uint256 tokenId) public {
1462         _burn(tokenId);
1463     }
1464 
1465     function price(uint256 _amount) public view returns (uint256) {
1466         uint256 total = totalSupply() + _amount;
1467         if (total <= 3500) return 0;
1468         return min(total - 3500, _amount) * premium;
1469     }
1470 
1471     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1472         return a <= b ? a : b;
1473     }
1474 
1475     function withdraw() external {
1476         uint256 balance = address(this).balance;
1477         require(balance > 0);
1478         (bool toOwner, ) = owner().call{value: (balance * 925) / 1000}("");
1479         require(toOwner, "Transfer failed.");
1480         (bool toDev, ) = dev.call{value: (balance * 75) / 1000}("");
1481         require(toDev, "Transfer failed.");
1482     }
1483 
1484     /**
1485      * @dev set the _baseTokenURI
1486      * @param baseURI of the _baseTokenURI
1487      */
1488     function setBaseURI(string memory baseURI) public onlyOwner {
1489         baseTokenURI = baseURI;
1490     }
1491 
1492     function _baseURI() internal view virtual override returns (string memory) {
1493         return baseTokenURI;
1494     }
1495 }