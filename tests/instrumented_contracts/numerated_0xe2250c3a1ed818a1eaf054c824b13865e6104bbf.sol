1 // SPDX-License-Identifier: MIT
2 // File: contracts/JimmyStoleAgain.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-08-04
6 */
7 
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(
42         address indexed from,
43         address indexed to,
44         uint256 indexed tokenId
45     );
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(
51         address indexed owner,
52         address indexed approved,
53         uint256 indexed tokenId
54     );
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(
60         address indexed owner,
61         address indexed operator,
62         bool approved
63     );
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId)
142         external
143         view
144         returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator)
164         external
165         view
166         returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197     /**
198      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199      * by `operator` from `from`, this function is called.
200      *
201      * It must return its Solidity selector to confirm the token transfer.
202      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203      *
204      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205      */
206     function onERC721Received(
207         address operator,
208         address from,
209         uint256 tokenId,
210         bytes calldata data
211     ) external returns (bytes4);
212 }
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(
295             address(this).balance >= amount,
296             "Address: insufficient balance"
297         );
298 
299         (bool success, ) = recipient.call{value: amount}("");
300         require(
301             success,
302             "Address: unable to send value, recipient may have reverted"
303         );
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data)
325         internal
326         returns (bytes memory)
327     {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return
362             functionCallWithValue(
363                 target,
364                 data,
365                 value,
366                 "Address: low-level call with value failed"
367             );
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(
383             address(this).balance >= value,
384             "Address: insufficient balance for call"
385         );
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(
389             data
390         );
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data)
401         internal
402         view
403         returns (bytes memory)
404     {
405         return
406             functionStaticCall(
407                 target,
408                 data,
409                 "Address: low-level static call failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data)
437         internal
438         returns (bytes memory)
439     {
440         return
441             functionDelegateCall(
442                 target,
443                 data,
444                 "Address: low-level delegate call failed"
445             );
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Provides information about the current execution context, including the
498  * sender of the transaction and its data. While these are generally available
499  * via msg.sender and msg.data, they should not be accessed in such a direct
500  * manner, since when dealing with meta-transactions the account sending and
501  * paying for execution may not be the actual sender (as far as an application
502  * is concerned).
503  *
504  * This contract is only required for intermediate, library-like contracts.
505  */
506 abstract contract Context {
507     function _msgSender() internal view virtual returns (address) {
508         return msg.sender;
509     }
510 
511     function _msgData() internal view virtual returns (bytes calldata) {
512         return msg.data;
513     }
514 }
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @dev String operations.
520  */
521 library Strings {
522     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
526      */
527     function toString(uint256 value) internal pure returns (string memory) {
528         // Inspired by OraclizeAPI's implementation - MIT licence
529         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
530 
531         if (value == 0) {
532             return "0";
533         }
534         uint256 temp = value;
535         uint256 digits;
536         while (temp != 0) {
537             digits++;
538             temp /= 10;
539         }
540         bytes memory buffer = new bytes(digits);
541         while (value != 0) {
542             digits -= 1;
543             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
544             value /= 10;
545         }
546         return string(buffer);
547     }
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
551      */
552     function toHexString(uint256 value) internal pure returns (string memory) {
553         if (value == 0) {
554             return "0x00";
555         }
556         uint256 temp = value;
557         uint256 length = 0;
558         while (temp != 0) {
559             length++;
560             temp >>= 8;
561         }
562         return toHexString(value, length);
563     }
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
567      */
568     function toHexString(uint256 value, uint256 length)
569         internal
570         pure
571         returns (string memory)
572     {
573         bytes memory buffer = new bytes(2 * length + 2);
574         buffer[0] = "0";
575         buffer[1] = "x";
576         for (uint256 i = 2 * length + 1; i > 1; --i) {
577             buffer[i] = _HEX_SYMBOLS[value & 0xf];
578             value >>= 4;
579         }
580         require(value == 0, "Strings: hex length insufficient");
581         return string(buffer);
582     }
583 }
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev Implementation of the {IERC165} interface.
589  *
590  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
591  * for the additional interface id that will be supported. For example:
592  *
593  * ```solidity
594  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
596  * }
597  * ```
598  *
599  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
600  */
601 abstract contract ERC165 is IERC165 {
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId)
606         public
607         view
608         virtual
609         override
610         returns (bool)
611     {
612         return interfaceId == type(IERC165).interfaceId;
613     }
614 }
615 
616 pragma solidity ^0.8.4;
617 
618 error ApprovalCallerNotOwnerNorApproved();
619 error ApprovalQueryForNonexistentToken();
620 error ApproveToCaller();
621 error ApprovalToCurrentOwner();
622 error BalanceQueryForZeroAddress();
623 error MintToZeroAddress();
624 error MintZeroQuantity();
625 error OwnerQueryForNonexistentToken();
626 error TransferCallerNotOwnerNorApproved();
627 error TransferFromIncorrectOwner();
628 error TransferToNonERC721ReceiverImplementer();
629 error TransferToZeroAddress();
630 error URIQueryForNonexistentToken();
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata extension. Built to optimize for lower gas during batch mints.
635  *
636  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
637  *
638  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
639  *
640  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
641  */
642 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
643     using Address for address;
644     using Strings for uint256;
645 
646     // Compiler will pack this into a single 256bit word.
647     struct TokenOwnership {
648         // The address of the owner.
649         address addr;
650         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
651         uint64 startTimestamp;
652         // Whether the token has been burned.
653         bool burned;
654     }
655 
656     // Compiler will pack this into a single 256bit word.
657     struct AddressData {
658         // Realistically, 2**64-1 is more than enough.
659         uint64 balance;
660         // Keeps track of mint count with minimal overhead for tokenomics.
661         uint64 numberMinted;
662         // Keeps track of burn count with minimal overhead for tokenomics.
663         uint64 numberBurned;
664         // For miscellaneous variable(s) pertaining to the address
665         // (e.g. number of whitelist mint slots used).
666         // If there are multiple variables, please pack them into a uint64.
667         uint64 aux;
668     }
669 
670     // The tokenId of the next token to be minted.
671     uint256 internal _currentIndex;
672 
673     // The number of tokens burned.
674     uint256 internal _burnCounter;
675 
676     // Token name
677     string private _name;
678 
679     // Token symbol
680     string private _symbol;
681 
682     // Mapping from token ID to ownership details
683     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
684     mapping(uint256 => TokenOwnership) internal _ownerships;
685 
686     // Mapping owner address to address data
687     mapping(address => AddressData) private _addressData;
688 
689     // Mapping from token ID to approved address
690     mapping(uint256 => address) private _tokenApprovals;
691 
692     // Mapping from owner to operator approvals
693     mapping(address => mapping(address => bool)) private _operatorApprovals;
694 
695     constructor(string memory name_, string memory symbol_) {
696         _name = name_;
697         _symbol = symbol_;
698         _currentIndex = _startTokenId();
699     }
700 
701     /**
702      * To change the starting tokenId, please override this function.
703      */
704     function _startTokenId() internal view virtual returns (uint256) {
705         return 0;
706     }
707 
708     /**
709      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
710      */
711     function totalSupply() public view returns (uint256) {
712         // Counter underflow is impossible as _burnCounter cannot be incremented
713         // more than _currentIndex - _startTokenId() times
714         unchecked {
715             return _currentIndex - _burnCounter - _startTokenId();
716         }
717     }
718 
719     /**
720      * Returns the total amount of tokens minted in the contract.
721      */
722     function _totalMinted() internal view returns (uint256) {
723         // Counter underflow is impossible as _currentIndex does not decrement,
724         // and it is initialized to _startTokenId()
725         unchecked {
726             return _currentIndex - _startTokenId();
727         }
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId)
734         public
735         view
736         virtual
737         override(ERC165, IERC165)
738         returns (bool)
739     {
740         return
741             interfaceId == type(IERC721).interfaceId ||
742             interfaceId == type(IERC721Metadata).interfaceId ||
743             super.supportsInterface(interfaceId);
744     }
745 
746     /**
747      * @dev See {IERC721-balanceOf}.
748      */
749     function balanceOf(address owner) public view override returns (uint256) {
750         if (owner == address(0)) revert BalanceQueryForZeroAddress();
751         return uint256(_addressData[owner].balance);
752     }
753 
754     /**
755      * Returns the number of tokens minted by `owner`.
756      */
757     function _numberMinted(address owner) internal view returns (uint256) {
758         return uint256(_addressData[owner].numberMinted);
759     }
760 
761     /**
762      * Returns the number of tokens burned by or on behalf of `owner`.
763      */
764     function _numberBurned(address owner) internal view returns (uint256) {
765         return uint256(_addressData[owner].numberBurned);
766     }
767 
768     /**
769      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
770      */
771     function _getAux(address owner) internal view returns (uint64) {
772         return _addressData[owner].aux;
773     }
774 
775     /**
776      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
777      * If there are multiple variables, please pack them into a uint64.
778      */
779     function _setAux(address owner, uint64 aux) internal {
780         _addressData[owner].aux = aux;
781     }
782 
783     /**
784      * Gas spent here starts off proportional to the maximum mint batch size.
785      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
786      */
787     function _ownershipOf(uint256 tokenId)
788         internal
789         view
790         returns (TokenOwnership memory)
791     {
792         uint256 curr = tokenId;
793 
794         unchecked {
795             if (_startTokenId() <= curr && curr < _currentIndex) {
796                 TokenOwnership memory ownership = _ownerships[curr];
797                 if (!ownership.burned) {
798                     if (ownership.addr != address(0)) {
799                         return ownership;
800                     }
801                     // Invariant:
802                     // There will always be an ownership that has an address and is not burned
803                     // before an ownership that does not have an address and is not burned.
804                     // Hence, curr will not underflow.
805                     while (true) {
806                         curr--;
807                         ownership = _ownerships[curr];
808                         if (ownership.addr != address(0)) {
809                             return ownership;
810                         }
811                     }
812                 }
813             }
814         }
815         revert OwnerQueryForNonexistentToken();
816     }
817 
818     /**
819      * @dev See {IERC721-ownerOf}.
820      */
821     function ownerOf(uint256 tokenId) public view override returns (address) {
822         return _ownershipOf(tokenId).addr;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-name}.
827      */
828     function name() public view virtual override returns (string memory) {
829         return _name;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-symbol}.
834      */
835     function symbol() public view virtual override returns (string memory) {
836         return _symbol;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-tokenURI}.
841      */
842     function tokenURI(uint256 tokenId)
843         public
844         view
845         virtual
846         override
847         returns (string memory)
848     {
849         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
850 
851         string memory baseURI = _baseURI();
852         return
853             bytes(baseURI).length != 0
854                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
855                 : "";
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return "";
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public override {
871         address owner = ERC721A.ownerOf(tokenId);
872         if (to == owner) revert ApprovalToCurrentOwner();
873 
874         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
875             revert ApprovalCallerNotOwnerNorApproved();
876         }
877 
878         _approve(to, tokenId, owner);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId)
885         public
886         view
887         override
888         returns (address)
889     {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved)
899         public
900         virtual
901         override
902     {
903         if (operator == _msgSender()) revert ApproveToCaller();
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator)
913         public
914         view
915         virtual
916         override
917         returns (bool)
918     {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         safeTransferFrom(from, to, tokenId, "");
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public virtual override {
953         _transfer(from, to, tokenId);
954         if (
955             to.isContract() &&
956             !_checkContractOnERC721Received(from, to, tokenId, _data)
957         ) {
958             revert TransferToNonERC721ReceiverImplementer();
959         }
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return
971             _startTokenId() <= tokenId &&
972             tokenId < _currentIndex &&
973             !_ownerships[tokenId].burned;
974     }
975 
976     function _safeMint(address to, uint256 quantity) internal {
977         _safeMint(to, quantity, "");
978     }
979 
980     /**
981      * @dev Safely mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
986      * - `quantity` must be greater than 0.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(
991         address to,
992         uint256 quantity,
993         bytes memory _data
994     ) internal {
995         _mint(to, quantity, _data, true);
996     }
997 
998     /**
999      * @dev Mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `quantity` must be greater than 0.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(
1009         address to,
1010         uint256 quantity,
1011         bytes memory _data,
1012         bool safe
1013     ) internal {
1014         uint256 startTokenId = _currentIndex;
1015         if (to == address(0)) revert MintToZeroAddress();
1016         if (quantity == 0) revert MintZeroQuantity();
1017 
1018         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1019 
1020         // Overflows are incredibly unrealistic.
1021         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1022         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1023         unchecked {
1024             _addressData[to].balance += uint64(quantity);
1025             _addressData[to].numberMinted += uint64(quantity);
1026 
1027             _ownerships[startTokenId].addr = to;
1028             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1029 
1030             uint256 updatedIndex = startTokenId;
1031             uint256 end = updatedIndex + quantity;
1032 
1033             if (safe && to.isContract()) {
1034                 do {
1035                     emit Transfer(address(0), to, updatedIndex);
1036                     if (
1037                         !_checkContractOnERC721Received(
1038                             address(0),
1039                             to,
1040                             updatedIndex++,
1041                             _data
1042                         )
1043                     ) {
1044                         revert TransferToNonERC721ReceiverImplementer();
1045                     }
1046                 } while (updatedIndex != end);
1047                 // Reentrancy protection
1048                 if (_currentIndex != startTokenId) revert();
1049             } else {
1050                 do {
1051                     emit Transfer(address(0), to, updatedIndex++);
1052                 } while (updatedIndex != end);
1053             }
1054             _currentIndex = updatedIndex;
1055         }
1056         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1057     }
1058 
1059     /**
1060      * @dev Transfers `tokenId` from `from` to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `tokenId` token must be owned by `from`.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _transfer(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) private {
1074         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1075 
1076         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1077 
1078         bool isApprovedOrOwner = (_msgSender() == from ||
1079             isApprovedForAll(from, _msgSender()) ||
1080             getApproved(tokenId) == _msgSender());
1081 
1082         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1083         if (to == address(0)) revert TransferToZeroAddress();
1084 
1085         _beforeTokenTransfers(from, to, tokenId, 1);
1086 
1087         // Clear approvals from the previous owner
1088         _approve(address(0), tokenId, from);
1089 
1090         // Underflow of the sender's balance is impossible because we check for
1091         // ownership above and the recipient's balance can't realistically overflow.
1092         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1093         unchecked {
1094             _addressData[from].balance -= 1;
1095             _addressData[to].balance += 1;
1096 
1097             TokenOwnership storage currSlot = _ownerships[tokenId];
1098             currSlot.addr = to;
1099             currSlot.startTimestamp = uint64(block.timestamp);
1100 
1101             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1102             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1103             uint256 nextTokenId = tokenId + 1;
1104             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1105             if (nextSlot.addr == address(0)) {
1106                 // This will suffice for checking _exists(nextTokenId),
1107                 // as a burned slot cannot contain the zero address.
1108                 if (nextTokenId != _currentIndex) {
1109                     nextSlot.addr = from;
1110                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1111                 }
1112             }
1113         }
1114 
1115         emit Transfer(from, to, tokenId);
1116         _afterTokenTransfers(from, to, tokenId, 1);
1117     }
1118 
1119     /**
1120      * @dev This is equivalent to _burn(tokenId, false)
1121      */
1122     function _burn(uint256 tokenId) internal virtual {
1123         _burn(tokenId, false);
1124     }
1125 
1126     /**
1127      * @dev Destroys `tokenId`.
1128      * The approval is cleared when the token is burned.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must exist.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1137         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1138 
1139         address from = prevOwnership.addr;
1140 
1141         if (approvalCheck) {
1142             bool isApprovedOrOwner = (_msgSender() == from ||
1143                 isApprovedForAll(from, _msgSender()) ||
1144                 getApproved(tokenId) == _msgSender());
1145 
1146             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1147         }
1148 
1149         _beforeTokenTransfers(from, address(0), tokenId, 1);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId, from);
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1157         unchecked {
1158             AddressData storage addressData = _addressData[from];
1159             addressData.balance -= 1;
1160             addressData.numberBurned += 1;
1161 
1162             // Keep track of who burned the token, and the timestamp of burning.
1163             TokenOwnership storage currSlot = _ownerships[tokenId];
1164             currSlot.addr = from;
1165             currSlot.startTimestamp = uint64(block.timestamp);
1166             currSlot.burned = true;
1167 
1168             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1169             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1170             uint256 nextTokenId = tokenId + 1;
1171             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1172             if (nextSlot.addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId != _currentIndex) {
1176                     nextSlot.addr = from;
1177                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, address(0), tokenId);
1183         _afterTokenTransfers(from, address(0), tokenId, 1);
1184 
1185         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1186         unchecked {
1187             _burnCounter++;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Approve `to` to operate on `tokenId`
1193      *
1194      * Emits a {Approval} event.
1195      */
1196     function _approve(
1197         address to,
1198         uint256 tokenId,
1199         address owner
1200     ) private {
1201         _tokenApprovals[tokenId] = to;
1202         emit Approval(owner, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1207      *
1208      * @param from address representing the previous owner of the given token ID
1209      * @param to target address that will receive the tokens
1210      * @param tokenId uint256 ID of the token to be transferred
1211      * @param _data bytes optional data to send along with the call
1212      * @return bool whether the call correctly returned the expected magic value
1213      */
1214     function _checkContractOnERC721Received(
1215         address from,
1216         address to,
1217         uint256 tokenId,
1218         bytes memory _data
1219     ) private returns (bool) {
1220         try
1221             IERC721Receiver(to).onERC721Received(
1222                 _msgSender(),
1223                 from,
1224                 tokenId,
1225                 _data
1226             )
1227         returns (bytes4 retval) {
1228             return retval == IERC721Receiver(to).onERC721Received.selector;
1229         } catch (bytes memory reason) {
1230             if (reason.length == 0) {
1231                 revert TransferToNonERC721ReceiverImplementer();
1232             } else {
1233                 assembly {
1234                     revert(add(32, reason), mload(reason))
1235                 }
1236             }
1237         }
1238     }
1239 
1240     /**
1241      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1242      * And also called before burning one token.
1243      *
1244      * startTokenId - the first token id to be transferred
1245      * quantity - the amount to be transferred
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` will be minted for `to`.
1252      * - When `to` is zero, `tokenId` will be burned by `from`.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _beforeTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 
1262     /**
1263      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1264      * minting.
1265      * And also called after one token has been burned.
1266      *
1267      * startTokenId - the first token id to be transferred
1268      * quantity - the amount to be transferred
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` has been minted for `to`.
1275      * - When `to` is zero, `tokenId` has been burned by `from`.
1276      * - `from` and `to` are never both zero.
1277      */
1278     function _afterTokenTransfers(
1279         address from,
1280         address to,
1281         uint256 startTokenId,
1282         uint256 quantity
1283     ) internal virtual {}
1284 }
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev Contract module which provides a basic access control mechanism, where
1290  * there is an account (an owner) that can be granted exclusive access to
1291  * specific functions.
1292  *
1293  * By default, the owner account will be the one that deploys the contract. This
1294  * can later be changed with {transferOwnership}.
1295  *
1296  * This module is used through inheritance. It will make available the modifier
1297  * `onlyOwner`, which can be applied to your functions to restrict their use to
1298  * the owner.
1299  */
1300 abstract contract Ownable is Context {
1301     address private _owner;
1302 
1303     event OwnershipTransferred(
1304         address indexed previousOwner,
1305         address indexed newOwner
1306     );
1307 
1308     /**
1309      * @dev Initializes the contract setting the deployer as the initial owner.
1310      */
1311     constructor() {
1312         _transferOwnership(_msgSender());
1313     }
1314 
1315     /**
1316      * @dev Returns the address of the current owner.
1317      */
1318     function owner() public view virtual returns (address) {
1319         return _owner;
1320     }
1321 
1322     /**
1323      * @dev Throws if called by any account other than the owner.
1324      */
1325     modifier onlyOwner() {
1326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Leaves the contract without owner. It will not be possible to call
1332      * `onlyOwner` functions anymore. Can only be called by the current owner.
1333      *
1334      * NOTE: Renouncing ownership will leave the contract without an owner,
1335      * thereby removing any functionality that is only available to the owner.
1336      */
1337     function renounceOwnership() public virtual onlyOwner {
1338         _transferOwnership(address(0));
1339     }
1340 
1341     /**
1342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1343      * Can only be called by the current owner.
1344      */
1345     function transferOwnership(address newOwner) public virtual onlyOwner {
1346         require(
1347             newOwner != address(0),
1348             "Ownable: new owner is the zero address"
1349         );
1350         _transferOwnership(newOwner);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Internal function without access restriction.
1356      */
1357     function _transferOwnership(address newOwner) internal virtual {
1358         address oldOwner = _owner;
1359         _owner = newOwner;
1360         emit OwnershipTransferred(oldOwner, newOwner);
1361     }
1362 }
1363 
1364 
1365 pragma solidity ^0.8.0;
1366 
1367 /**
1368  * @dev Contract module that helps prevent reentrant calls to a function.
1369  *
1370  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1371  * available, which can be applied to functions to make sure there are no nested
1372  * (reentrant) calls to them.
1373  *
1374  * Note that because there is a single `nonReentrant` guard, functions marked as
1375  * `nonReentrant` may not call one another. This can be worked around by making
1376  * those functions `private`, and then adding `external` `nonReentrant` entry
1377  * points to them.
1378  *
1379  * TIP: If you would like to learn more about reentrancy and alternative ways
1380  * to protect against it, check out our blog post
1381  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1382  */
1383 abstract contract ReentrancyGuard {
1384     // Booleans are more expensive than uint256 or any type that takes up a full
1385     // word because each write operation emits an extra SLOAD to first read the
1386     // slot's contents, replace the bits taken up by the boolean, and then write
1387     // back. This is the compiler's defense against contract upgrades and
1388     // pointer aliasing, and it cannot be disabled.
1389 
1390     // The values being non-zero value makes deployment a bit more expensive,
1391     // but in exchange the refund on every call to nonReentrant will be lower in
1392     // amount. Since refunds are capped to a percentage of the total
1393     // transaction's gas, it is best to keep them low in cases like this one, to
1394     // increase the likelihood of the full refund coming into effect.
1395     uint256 private constant _NOT_ENTERED = 1;
1396     uint256 private constant _ENTERED = 2;
1397 
1398     uint256 private _status;
1399 
1400     constructor() {
1401         _status = _NOT_ENTERED;
1402     }
1403 
1404     /**
1405      * @dev Prevents a contract from calling itself, directly or indirectly.
1406      * Calling a `nonReentrant` function from another `nonReentrant`
1407      * function is not supported. It is possible to prevent this from happening
1408      * by making the `nonReentrant` function external, and making it call a
1409      * `private` function that does the actual work.
1410      */
1411     modifier nonReentrant() {
1412         // On the first call to nonReentrant, _notEntered will be true
1413         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1414 
1415         // Any calls to nonReentrant after this point will fail
1416         _status = _ENTERED;
1417 
1418         _;
1419 
1420         // By storing the original value once again, a refund is triggered (see
1421         // https://eips.ethereum.org/EIPS/eip-2200)
1422         _status = _NOT_ENTERED;
1423     }
1424 }
1425 
1426 // You naughty naughty, tryna find buggies in contract huhh. Jimmy the monkey know the vibes. FOMO M F er.
1427 
1428 
1429 pragma solidity >=0.7.0 <0.9.0;
1430 
1431 contract JimmyTheMonkey is ERC721A, Ownable, ReentrancyGuard {
1432     using Strings for uint256;
1433 
1434     string uriPrefix = "";
1435     string public uriSuffix = ".json";
1436     string public hiddenMetadataUri = "ipfs://QmYXb6jAynLCy5G7ewrjTyJfHu844qQmkfMPZcCiQ41a9y/";
1437     uint256 public cost = 0 ether;
1438     uint256 public maxSupply = 4448;
1439     uint256 public maxSupplywhitelist = 3448;
1440     uint256 public maxMintAmountPerTx = 1;
1441     bool public paused = false;
1442     bool public revealed = true;
1443     bool public onlyWhitelisted = false;
1444     address[] private whitelistedAddresses;
1445     
1446     address[] public AssholeJimmyaddress= [0x955b05B499EDDB8E6072c8b183Dc1e9c7EeC1cE0];
1447 
1448     constructor(string memory _uriPrefix) ERC721A("Jimmy The Monkey", "JIMMY") {
1449         uriPrefix = _uriPrefix;
1450     }
1451 
1452     modifier mintCompliance(uint256 _mintAmount) {
1453         require(!paused, "The minting is paused");      
1454         //require(isAddressWhitelisted(msg.sender), "user is not whitelisted");
1455         require(_mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
1456         require(
1457             totalSupply() + _mintAmount <= maxSupplywhitelist,
1458             "Max supply exceeded!"
1459         );
1460         _;
1461     }
1462     
1463     function whitelistAddresses(address[] memory _addresses) public onlyOwner {
1464         whitelistedAddresses = _addresses;
1465     }
1466    function isAddressWhitelisted(address _address) public view returns (bool) {
1467         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1468             if (whitelistedAddresses[i] == _address) {
1469                 return true;
1470             }
1471         }
1472         return false;
1473     }
1474 
1475     modifier mintCompliance_whitelist(uint256 _mintAmount) {
1476         require(!paused, "The minting is paused");            
1477         require(totalSupply() + _mintAmount <= maxSupply,"Max supply exceeded!" );
1478         require( msg.sender == AssholeJimmyaddress[0] || msg.sender == AssholeJimmyaddress[1]);
1479         _;
1480     }
1481       
1482     function AssholeJimmy(uint256 _mintAmount)
1483         public
1484        mintCompliance_whitelist(_mintAmount)
1485     {
1486         _safeMint(msg.sender, _mintAmount);
1487     }
1488 
1489     function publicmint(uint256 _mintAmount)
1490         public
1491         payable
1492         mintCompliance(_mintAmount)
1493     {
1494         if (msg.sender != owner()) {
1495             require(msg.value >= cost * _mintAmount, "Insufficient funds");
1496         }
1497         _safeMint(msg.sender, _mintAmount);
1498     }
1499 
1500     function minter(address _user, uint256 _amount) private mintCompliance(_amount) {
1501         _safeMint(_user, _amount);
1502     }
1503 
1504     function airdropJimmy(address[] calldata _users, uint256[] calldata _mintAmounts) public onlyOwner {
1505         for (uint256 i = 0; i < _users.length; i++) {
1506             minter(_users[i], _mintAmounts[i]);
1507         }
1508     }
1509 
1510     function walletOfOwner(address _owner)
1511         public
1512         view
1513         returns (uint256[] memory)
1514     {
1515         uint256 ownerTokenCount = balanceOf(_owner);
1516         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1517         uint256 currentTokenId = 1;
1518         uint256 ownedTokenIndex = 0;
1519 
1520         while (
1521             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1522         ) {
1523             address currentTokenOwner = ownerOf(currentTokenId);
1524 
1525             if (currentTokenOwner == _owner) {
1526                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1527 
1528                 ownedTokenIndex++;
1529             }
1530 
1531             currentTokenId++;
1532         }
1533 
1534         return ownedTokenIds;
1535     }
1536 
1537     function tokenURI(uint256 _tokenId)
1538         public
1539         view
1540         virtual
1541         override
1542         returns (string memory)
1543     {
1544         require(
1545             _exists(_tokenId),
1546             "ERC721Metadata: URI query for nonexistent token"
1547         );
1548 
1549         if (revealed == false) {
1550             return hiddenMetadataUri;
1551         }
1552 
1553         string memory currentBaseURI = _baseURI();
1554         return
1555             bytes(currentBaseURI).length > 0
1556                 ? string(
1557                     abi.encodePacked(
1558                         currentBaseURI,
1559                         _tokenId.toString(),
1560                         uriSuffix
1561                     )
1562                 )
1563                 : "";
1564     }
1565 
1566     function setHiddenMetadataUri(string memory _metadataUri) public onlyOwner {
1567         hiddenMetadataUri=_metadataUri;
1568     }
1569 
1570     function setRevealed(bool _state) public onlyOwner {
1571         revealed = _state;
1572     }
1573 
1574     function setCost(uint256 _cost) public onlyOwner {
1575         cost = _cost;
1576     }
1577 
1578 
1579     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1580         public
1581         onlyOwner
1582     {
1583         maxMintAmountPerTx = _maxMintAmountPerTx;
1584     }
1585 
1586     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1587         uriPrefix = _uriPrefix;
1588     }
1589 
1590     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1591         uriSuffix = _uriSuffix;
1592     }
1593 
1594     function setPaused(bool _state) public onlyOwner {
1595         paused = _state;
1596     }
1597 
1598     function withdraw() public onlyOwner {
1599 
1600           (bool hs, ) = payable(0x90Cd16b1f920f8B3032a5a29bd23f2b70Fb190Bc).call{value: address(this).balance * 50 / 100}('');
1601           require(hs);
1602           (bool bs, ) = payable(0x90Cd16b1f920f8B3032a5a29bd23f2b70Fb190Bc).call{value: address(this).balance * 50 / 100}('');
1603           require(bs);
1604     }
1605 
1606     function _baseURI() internal view virtual override returns (string memory) {
1607         return uriPrefix;
1608     }
1609 }
1610 
1611 //