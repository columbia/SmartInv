1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length)
58         internal
59         pure
60         returns (string memory)
61     {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(
136             address(this).balance >= amount,
137             "Address: insufficient balance"
138         );
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(
142             success,
143             "Address: unable to send value, recipient may have reverted"
144         );
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data)
166         internal
167         returns (bytes memory)
168     {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return
203             functionCallWithValue(
204                 target,
205                 data,
206                 value,
207                 "Address: low-level call with value failed"
208             );
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(
224             address(this).balance >= value,
225             "Address: insufficient balance for call"
226         );
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(
230             data
231         );
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data)
242         internal
243         view
244         returns (bytes memory)
245     {
246         return
247             functionStaticCall(
248                 target,
249                 data,
250                 "Address: low-level static call failed"
251             );
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal view returns (bytes memory) {
265         require(isContract(target), "Address: static call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.staticcall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(address target, bytes memory data)
278         internal
279         returns (bytes memory)
280     {
281         return
282             functionDelegateCall(
283                 target,
284                 data,
285                 "Address: low-level delegate call failed"
286             );
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(isContract(target), "Address: delegate call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.delegatecall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
308      * revert reason using the provided one.
309      *
310      * _Available since v4.3._
311      */
312     function verifyCallResult(
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal pure returns (bytes memory) {
317         if (success) {
318             return returndata;
319         } else {
320             // Look for revert reason and bubble it up if present
321             if (returndata.length > 0) {
322                 // The easiest way to bubble the revert reason is using memory via assembly
323 
324                 assembly {
325                     let returndata_size := mload(returndata)
326                     revert(add(32, returndata), returndata_size)
327                 }
328             } else {
329                 revert(errorMessage);
330             }
331         }
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
355      */
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Interface of the ERC165 standard, as defined in the
372  * https://eips.ethereum.org/EIPS/eip-165[EIP].
373  *
374  * Implementers can declare support of contract interfaces, which can then be
375  * queried by others ({ERC165Checker}).
376  *
377  * For an implementation, see {ERC165}.
378  */
379 interface IERC165 {
380     /**
381      * @dev Returns true if this contract implements the interface defined by
382      * `interfaceId`. See the corresponding
383      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
384      * to learn more about how these ids are created.
385      *
386      * This function call must use less than 30 000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool);
389 }
390 
391 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Implementation of the {IERC165} interface.
399  *
400  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
401  * for the additional interface id that will be supported. For example:
402  *
403  * ```solidity
404  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
406  * }
407  * ```
408  *
409  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
410  */
411 abstract contract ERC165 is IERC165 {
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId)
416         public
417         view
418         virtual
419         override
420         returns (bool)
421     {
422         return interfaceId == type(IERC165).interfaceId;
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
427 
428 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Required interface of an ERC721 compliant contract.
434  */
435 interface IERC721 is IERC165 {
436     /**
437      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
438      */
439     event Transfer(
440         address indexed from,
441         address indexed to,
442         uint256 indexed tokenId
443     );
444 
445     /**
446      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
447      */
448     event Approval(
449         address indexed owner,
450         address indexed approved,
451         uint256 indexed tokenId
452     );
453 
454     /**
455      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
456      */
457     event ApprovalForAll(
458         address indexed owner,
459         address indexed operator,
460         bool approved
461     );
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId)
540         external
541         view
542         returns (address operator);
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558      *
559      * See {setApprovalForAll}
560      */
561     function isApprovedForAll(address owner, address operator)
562         external
563         view
564         returns (bool);
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId,
583         bytes calldata data
584     ) external;
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
588 
589 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
595  * @dev See https://eips.ethereum.org/EIPS/eip-721
596  */
597 interface IERC721Enumerable is IERC721 {
598     /**
599      * @dev Returns the total amount of tokens stored by the contract.
600      */
601     function totalSupply() external view returns (uint256);
602 
603     /**
604      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
605      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
606      */
607     function tokenOfOwnerByIndex(address owner, uint256 index)
608         external
609         view
610         returns (uint256);
611 
612     /**
613      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
614      * Use along with {totalSupply} to enumerate all tokens.
615      */
616     function tokenByIndex(uint256 index) external view returns (uint256);
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 // File: @openzeppelin/contracts/utils/Context.sol
647 
648 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Provides information about the current execution context, including the
654  * sender of the transaction and its data. While these are generally available
655  * via msg.sender and msg.data, they should not be accessed in such a direct
656  * manner, since when dealing with meta-transactions the account sending and
657  * paying for execution may not be the actual sender (as far as an application
658  * is concerned).
659  *
660  * This contract is only required for intermediate, library-like contracts.
661  */
662 abstract contract Context {
663     function _msgSender() internal view virtual returns (address) {
664         return msg.sender;
665     }
666 
667     function _msgData() internal view virtual returns (bytes calldata) {
668         return msg.data;
669     }
670 }
671 
672 // File: erc721a/contracts/ERC721A.sol
673 
674 // Creator: Chiru Labs
675 
676 pragma solidity ^0.8.4;
677 
678 error ApprovalCallerNotOwnerNorApproved();
679 error ApprovalQueryForNonexistentToken();
680 error ApproveToCaller();
681 error ApprovalToCurrentOwner();
682 error BalanceQueryForZeroAddress();
683 error MintedQueryForZeroAddress();
684 error BurnedQueryForZeroAddress();
685 error AuxQueryForZeroAddress();
686 error MintToZeroAddress();
687 error MintZeroQuantity();
688 error OwnerIndexOutOfBounds();
689 error OwnerQueryForNonexistentToken();
690 error TokenIndexOutOfBounds();
691 error TransferCallerNotOwnerNorApproved();
692 error TransferFromIncorrectOwner();
693 error TransferToNonERC721ReceiverImplementer();
694 error TransferToZeroAddress();
695 error URIQueryForNonexistentToken();
696 
697 /**
698  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
699  * the Metadata extension. Built to optimize for lower gas during batch mints.
700  *
701  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
702  *
703  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
704  *
705  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
706  */
707 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
708     using Address for address;
709     using Strings for uint256;
710 
711     // Compiler will pack this into a single 256bit word.
712     struct TokenOwnership {
713         // The address of the owner.
714         address addr;
715         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
716         uint64 startTimestamp;
717         // Whether the token has been burned.
718         bool burned;
719     }
720 
721     // Compiler will pack this into a single 256bit word.
722     struct AddressData {
723         // Realistically, 2**64-1 is more than enough.
724         uint64 balance;
725         // Keeps track of mint count with minimal overhead for tokenomics.
726         uint64 numberMinted;
727         // Keeps track of burn count with minimal overhead for tokenomics.
728         uint64 numberBurned;
729         // For miscellaneous variable(s) pertaining to the address
730         // (e.g. number of whitelist mint slots used).
731         // If there are multiple variables, please pack them into a uint64.
732         uint64 aux;
733     }
734 
735     // The tokenId of the next token to be minted.
736     uint256 internal _currentIndex;
737 
738     // The number of tokens burned.
739     uint256 internal _burnCounter;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to ownership details
748     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
749     mapping(uint256 => TokenOwnership) internal _ownerships;
750 
751     // Mapping owner address to address data
752     mapping(address => AddressData) private _addressData;
753 
754     // Mapping from token ID to approved address
755     mapping(uint256 => address) private _tokenApprovals;
756 
757     // Mapping from owner to operator approvals
758     mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763         _currentIndex = _startTokenId();
764     }
765 
766     /**
767      * To change the starting tokenId, please override this function.
768      */
769     function _startTokenId() internal view virtual returns (uint256) {
770         return 0;
771     }
772 
773     /**
774      * @dev See {IERC721Enumerable-totalSupply}.
775      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
776      */
777     function totalSupply() public view returns (uint256) {
778         // Counter underflow is impossible as _burnCounter cannot be incremented
779         // more than _currentIndex - _startTokenId() times
780         unchecked {
781             return _currentIndex - _burnCounter - _startTokenId();
782         }
783     }
784 
785     /**
786      * Returns the total amount of tokens minted in the contract.
787      */
788     function _totalMinted() internal view returns (uint256) {
789         // Counter underflow is impossible as _currentIndex does not decrement,
790         // and it is initialized to _startTokenId()
791         unchecked {
792             return _currentIndex - _startTokenId();
793         }
794     }
795 
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId)
800         public
801         view
802         virtual
803         override(ERC165, IERC165)
804         returns (bool)
805     {
806         return
807             interfaceId == type(IERC721).interfaceId ||
808             interfaceId == type(IERC721Metadata).interfaceId ||
809             super.supportsInterface(interfaceId);
810     }
811 
812     /**
813      * @dev See {IERC721-balanceOf}.
814      */
815     function balanceOf(address owner) public view override returns (uint256) {
816         if (owner == address(0)) revert BalanceQueryForZeroAddress();
817         return uint256(_addressData[owner].balance);
818     }
819 
820     /**
821      * Returns the number of tokens minted by `owner`.
822      */
823     function _numberMinted(address owner) internal view returns (uint256) {
824         if (owner == address(0)) revert MintedQueryForZeroAddress();
825         return uint256(_addressData[owner].numberMinted);
826     }
827 
828     /**
829      * Returns the number of tokens burned by or on behalf of `owner`.
830      */
831     function _numberBurned(address owner) internal view returns (uint256) {
832         if (owner == address(0)) revert BurnedQueryForZeroAddress();
833         return uint256(_addressData[owner].numberBurned);
834     }
835 
836     /**
837      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
838      */
839     function _getAux(address owner) internal view returns (uint64) {
840         if (owner == address(0)) revert AuxQueryForZeroAddress();
841         return _addressData[owner].aux;
842     }
843 
844     /**
845      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
846      * If there are multiple variables, please pack them into a uint64.
847      */
848     function _setAux(address owner, uint64 aux) internal {
849         if (owner == address(0)) revert AuxQueryForZeroAddress();
850         _addressData[owner].aux = aux;
851     }
852 
853     /**
854      * Gas spent here starts off proportional to the maximum mint batch size.
855      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
856      */
857     function ownershipOf(uint256 tokenId)
858         internal
859         view
860         returns (TokenOwnership memory)
861     {
862         uint256 curr = tokenId;
863 
864         unchecked {
865             if (_startTokenId() <= curr && curr < _currentIndex) {
866                 TokenOwnership memory ownership = _ownerships[curr];
867                 if (!ownership.burned) {
868                     if (ownership.addr != address(0)) {
869                         return ownership;
870                     }
871                     // Invariant:
872                     // There will always be an ownership that has an address and is not burned
873                     // before an ownership that does not have an address and is not burned.
874                     // Hence, curr will not underflow.
875                     while (true) {
876                         curr--;
877                         ownership = _ownerships[curr];
878                         if (ownership.addr != address(0)) {
879                             return ownership;
880                         }
881                     }
882                 }
883             }
884         }
885         revert OwnerQueryForNonexistentToken();
886     }
887 
888     /**
889      * @dev See {IERC721-ownerOf}.
890      */
891     function ownerOf(uint256 tokenId) public view override returns (address) {
892         return ownershipOf(tokenId).addr;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId)
913         public
914         view
915         virtual
916         override
917         returns (string memory)
918     {
919         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
920 
921         string memory baseURI = _baseURI();
922         return
923             bytes(baseURI).length != 0
924                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
925                 : "";
926     }
927 
928     /**
929      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
930      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
931      * by default, can be overriden in child contracts.
932      */
933     function _baseURI() internal view virtual returns (string memory) {
934         return "";
935     }
936 
937     /**
938      * @dev See {IERC721-approve}.
939      */
940     function approve(address to, uint256 tokenId) public override {
941         address owner = ERC721A.ownerOf(tokenId);
942         if (to == owner) revert ApprovalToCurrentOwner();
943 
944         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
945             revert ApprovalCallerNotOwnerNorApproved();
946         }
947 
948         _approve(to, tokenId, owner);
949     }
950 
951     /**
952      * @dev See {IERC721-getApproved}.
953      */
954     function getApproved(uint256 tokenId)
955         public
956         view
957         override
958         returns (address)
959     {
960         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved)
969         public
970         override
971     {
972         if (operator == _msgSender()) revert ApproveToCaller();
973 
974         _operatorApprovals[_msgSender()][operator] = approved;
975         emit ApprovalForAll(_msgSender(), operator, approved);
976     }
977 
978     /**
979      * @dev See {IERC721-isApprovedForAll}.
980      */
981     function isApprovedForAll(address owner, address operator)
982         public
983         view
984         virtual
985         override
986         returns (bool)
987     {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         safeTransferFrom(from, to, tokenId, "");
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023         if (
1024             to.isContract() &&
1025             !_checkContractOnERC721Received(from, to, tokenId, _data)
1026         ) {
1027             revert TransferToNonERC721ReceiverImplementer();
1028         }
1029     }
1030 
1031     /**
1032      * @dev Returns whether `tokenId` exists.
1033      *
1034      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1035      *
1036      * Tokens start existing when they are minted (`_mint`),
1037      */
1038     function _exists(uint256 tokenId) internal view returns (bool) {
1039         return
1040             _startTokenId() <= tokenId &&
1041             tokenId < _currentIndex &&
1042             !_ownerships[tokenId].burned;
1043     }
1044 
1045     function _safeMint(address to, uint256 quantity) internal {
1046         _safeMint(to, quantity, "");
1047     }
1048 
1049     /**
1050      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 quantity,
1062         bytes memory _data
1063     ) internal {
1064         _mint(to, quantity, _data, true);
1065     }
1066 
1067     /**
1068      * @dev Mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _mint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data,
1081         bool safe
1082     ) internal {
1083         uint256 startTokenId = _currentIndex;
1084         if (to == address(0)) revert MintToZeroAddress();
1085         if (quantity == 0) revert MintZeroQuantity();
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are incredibly unrealistic.
1090         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1091         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1092         unchecked {
1093             _addressData[to].balance += uint64(quantity);
1094             _addressData[to].numberMinted += uint64(quantity);
1095 
1096             _ownerships[startTokenId].addr = to;
1097             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1098 
1099             uint256 updatedIndex = startTokenId;
1100             uint256 end = updatedIndex + quantity;
1101 
1102             if (safe && to.isContract()) {
1103                 do {
1104                     emit Transfer(address(0), to, updatedIndex);
1105                     if (
1106                         !_checkContractOnERC721Received(
1107                             address(0),
1108                             to,
1109                             updatedIndex++,
1110                             _data
1111                         )
1112                     ) {
1113                         revert TransferToNonERC721ReceiverImplementer();
1114                     }
1115                 } while (updatedIndex != end);
1116                 // Reentrancy protection
1117                 if (_currentIndex != startTokenId) revert();
1118             } else {
1119                 do {
1120                     emit Transfer(address(0), to, updatedIndex++);
1121                 } while (updatedIndex != end);
1122             }
1123             _currentIndex = updatedIndex;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Transfers `tokenId` from `from` to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must be owned by `from`.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _transfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) private {
1143         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1144 
1145         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1146             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1147             getApproved(tokenId) == _msgSender());
1148 
1149         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1150         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1151         if (to == address(0)) revert TransferToZeroAddress();
1152 
1153         _beforeTokenTransfers(from, to, tokenId, 1);
1154 
1155         // Clear approvals from the previous owner
1156         _approve(address(0), tokenId, prevOwnership.addr);
1157 
1158         // Underflow of the sender's balance is impossible because we check for
1159         // ownership above and the recipient's balance can't realistically overflow.
1160         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1161         unchecked {
1162             _addressData[from].balance -= 1;
1163             _addressData[to].balance += 1;
1164 
1165             _ownerships[tokenId].addr = to;
1166             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1167 
1168             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1169             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1170             uint256 nextTokenId = tokenId + 1;
1171             if (_ownerships[nextTokenId].addr == address(0)) {
1172                 // This will suffice for checking _exists(nextTokenId),
1173                 // as a burned slot cannot contain the zero address.
1174                 if (nextTokenId < _currentIndex) {
1175                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1176                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1177                         .startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1225                         .startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(prevOwnership.addr, address(0), tokenId);
1231         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1234         unchecked {
1235             _burnCounter++;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Approve `to` to operate on `tokenId`
1241      *
1242      * Emits a {Approval} event.
1243      */
1244     function _approve(
1245         address to,
1246         uint256 tokenId,
1247         address owner
1248     ) private {
1249         _tokenApprovals[tokenId] = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try
1269             IERC721Receiver(to).onERC721Received(
1270                 _msgSender(),
1271                 from,
1272                 tokenId,
1273                 _data
1274             )
1275         returns (bytes4 retval) {
1276             return retval == IERC721Receiver(to).onERC721Received.selector;
1277         } catch (bytes memory reason) {
1278             if (reason.length == 0) {
1279                 revert TransferToNonERC721ReceiverImplementer();
1280             } else {
1281                 assembly {
1282                     revert(add(32, reason), mload(reason))
1283                 }
1284             }
1285         }
1286     }
1287 
1288     /**
1289      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1290      * And also called before burning one token.
1291      *
1292      * startTokenId - the first token id to be transferred
1293      * quantity - the amount to be transferred
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _beforeTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 
1310     /**
1311      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1312      * minting.
1313      * And also called after one token has been burned.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` has been minted for `to`.
1323      * - When `to` is zero, `tokenId` has been burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _afterTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 }
1333 
1334 // File: @openzeppelin/contracts/access/Ownable.sol
1335 
1336 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 /**
1341  * @dev Contract module which provides a basic access control mechanism, where
1342  * there is an account (an owner) that can be granted exclusive access to
1343  * specific functions.
1344  *
1345  * By default, the owner account will be the one that deploys the contract. This
1346  * can later be changed with {transferOwnership}.
1347  *
1348  * This module is used through inheritance. It will make available the modifier
1349  * `onlyOwner`, which can be applied to your functions to restrict their use to
1350  * the owner.
1351  */
1352 abstract contract Ownable is Context {
1353     address private _owner;
1354 
1355     event OwnershipTransferred(
1356         address indexed previousOwner,
1357         address indexed newOwner
1358     );
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Returns the address of the current owner.
1369      */
1370     function owner() public view virtual returns (address) {
1371         return _owner;
1372     }
1373 
1374     /**
1375      * @dev Throws if called by any account other than the owner.
1376      */
1377     modifier onlyOwner() {
1378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1379         _;
1380     }
1381 
1382     /**
1383      * @dev Leaves the contract without owner. It will not be possible to call
1384      * `onlyOwner` functions anymore. Can only be called by the current owner.
1385      *
1386      * NOTE: Renouncing ownership will leave the contract without an owner,
1387      * thereby removing any functionality that is only available to the owner.
1388      */
1389     function renounceOwnership() public virtual onlyOwner {
1390         _transferOwnership(address(0));
1391     }
1392 
1393     /**
1394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1395      * Can only be called by the current owner.
1396      */
1397     function transferOwnership(address newOwner) public virtual onlyOwner {
1398         require(
1399             newOwner != address(0),
1400             "Ownable: new owner is the zero address"
1401         );
1402         _transferOwnership(newOwner);
1403     }
1404 
1405     /**
1406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1407      * Internal function without access restriction.
1408      */
1409     function _transferOwnership(address newOwner) internal virtual {
1410         address oldOwner = _owner;
1411         _owner = newOwner;
1412         emit OwnershipTransferred(oldOwner, newOwner);
1413     }
1414 }
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 contract FreeTheNipple is ERC721A, Ownable {
1419     using Strings for uint256;
1420     uint256 public cost = 0 ether;
1421     uint256 public maxSupply = 2222;
1422     uint256 public maxMintAmount = 3;
1423     bool public paused = false;
1424     string public baseURI;
1425 
1426     mapping(address => uint256) public addressMintedBalance;
1427 
1428     constructor(string memory _initBaseURI) ERC721A("FreeTheNipple", "FTN") {
1429         baseURI = _initBaseURI;
1430     }
1431 
1432     function tokenURI(uint256 tokenId)
1433         public
1434         view
1435         override
1436         returns (string memory)
1437     {
1438         require(_exists(tokenId), "ERC721Metadata: Token ID does not exist");
1439         return
1440             bytes(baseURI).length > 0
1441                 ? string(
1442                     abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")
1443                 )
1444                 : "";
1445     }
1446 
1447     function mint(uint256 _amount) external payable {
1448         require(!paused, "FreeTheNipple - The Contract is Paused");
1449         require(
1450             totalSupply() + _amount <= maxSupply,
1451             "FreeTheNipple - max NFT limit exceeded"
1452         );
1453         if (msg.sender != owner()) {
1454             require(
1455                 _amount <= maxMintAmount,
1456                 "FreeTheNipple - max mint amount limit exceeded"
1457             );
1458             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1459             require(
1460                 ownerMintedCount + _amount <= maxMintAmount,
1461                 "FreeTheNipple - max NFT per address exceeded"
1462             );
1463             require(
1464                 msg.value >= cost * _amount,
1465                 "FreeTheNipple - insufficient ethers"
1466             );
1467         }
1468 
1469         _safeMint(msg.sender, _amount);
1470         addressMintedBalance[msg.sender] += _amount;
1471     }
1472 
1473     //only owner
1474     function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1475         maxMintAmount = _maxMintAmount;
1476     }
1477 
1478     function setCost(uint256 _newCost) public onlyOwner {
1479         cost = _newCost;
1480     }
1481 
1482     function setBaseURI(string memory _baseURI) public onlyOwner {
1483         baseURI = _baseURI;
1484     }
1485 
1486     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1487         maxSupply = _maxSupply;
1488     }
1489 
1490     function pause() public onlyOwner {
1491         paused = !paused;
1492     }
1493 
1494     function withdraw() public onlyOwner {
1495         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1496         require(os);
1497     }
1498 }