1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Context.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Address.sol
96 
97 
98 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
99 
100 pragma solidity ^0.8.1;
101 
102 /**
103  * @dev Collection of functions related to the address type
104  */
105 library Address {
106     /**
107      * @dev Returns true if `account` is a contract.
108      *
109      * [IMPORTANT]
110      * ====
111      * It is unsafe to assume that an address for which this function returns
112      * false is an externally-owned account (EOA) and not a contract.
113      *
114      * Among others, `isContract` will return false for the following
115      * types of addresses:
116      *
117      *  - an externally-owned account
118      *  - a contract in construction
119      *  - an address where a contract will be created
120      *  - an address where a contract lived, but was destroyed
121      * ====
122      *
123      * [IMPORTANT]
124      * ====
125      * You shouldn't rely on `isContract` to protect against flash loan attacks!
126      *
127      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
128      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
129      * constructor.
130      * ====
131      */
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize/address.code.length, which returns 0
134         // for contracts in construction, since the code is only stored at the end
135         // of the constructor execution.
136 
137         return account.code.length > 0;
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      */
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162 
163     /**
164      * @dev Performs a Solidity function call using a low level `call`. A
165      * plain `call` is an unsafe replacement for a function call: use this
166      * function instead.
167      *
168      * If `target` reverts with a revert reason, it is bubbled up by this
169      * function (like regular Solidity function calls).
170      *
171      * Returns the raw returned data. To convert to the expected return value,
172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
173      *
174      * Requirements:
175      *
176      * - `target` must be a contract.
177      * - calling `target` with `data` must not revert.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, "Address: low-level call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
187      * `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, 0, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but also transferring `value` wei to `target`.
202      *
203      * Requirements:
204      *
205      * - the calling contract must have an ETH balance of at least `value`.
206      * - the called Solidity function must be `payable`.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
220      * with `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         require(address(this).balance >= value, "Address: insufficient balance for call");
231         require(isContract(target), "Address: call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.call{value: value}(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
244         return functionStaticCall(target, data, "Address: low-level static call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal view returns (bytes memory) {
258         require(isContract(target), "Address: static call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.staticcall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(isContract(target), "Address: delegate call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.delegatecall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
293      * revert reason using the provided one.
294      *
295      * _Available since v4.3._
296      */
297     function verifyCallResult(
298         bool success,
299         bytes memory returndata,
300         string memory errorMessage
301     ) internal pure returns (bytes memory) {
302         if (success) {
303             return returndata;
304         } else {
305             // Look for revert reason and bubble it up if present
306             if (returndata.length > 0) {
307                 // The easiest way to bubble the revert reason is using memory via assembly
308 
309                 assembly {
310                     let returndata_size := mload(returndata)
311                     revert(add(32, returndata), returndata_size)
312                 }
313             } else {
314                 revert(errorMessage);
315             }
316         }
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
321 
322 
323 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @title ERC721 token receiver interface
329  * @dev Interface for any contract that wants to support safeTransfers
330  * from ERC721 asset contracts.
331  */
332 interface IERC721Receiver {
333     /**
334      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
335      * by `operator` from `from`, this function is called.
336      *
337      * It must return its Solidity selector to confirm the token transfer.
338      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
339      *
340      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
341      */
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Interface of the ERC165 standard, as defined in the
359  * https://eips.ethereum.org/EIPS/eip-165[EIP].
360  *
361  * Implementers can declare support of contract interfaces, which can then be
362  * queried by others ({ERC165Checker}).
363  *
364  * For an implementation, see {ERC165}.
365  */
366 interface IERC165 {
367     /**
368      * @dev Returns true if this contract implements the interface defined by
369      * `interfaceId`. See the corresponding
370      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
371      * to learn more about how these ids are created.
372      *
373      * This function call must use less than 30 000 gas.
374      */
375     function supportsInterface(bytes4 interfaceId) external view returns (bool);
376 }
377 
378 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Implementation of the {IERC165} interface.
388  *
389  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
390  * for the additional interface id that will be supported. For example:
391  *
392  * ```solidity
393  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
395  * }
396  * ```
397  *
398  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
399  */
400 abstract contract ERC165 is IERC165 {
401     /**
402      * @dev See {IERC165-supportsInterface}.
403      */
404     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405         return interfaceId == type(IERC165).interfaceId;
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Required interface of an ERC721 compliant contract.
419  */
420 interface IERC721 is IERC165 {
421     /**
422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
433      */
434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
435 
436     /**
437      * @dev Returns the number of tokens in ``owner``'s account.
438      */
439     function balanceOf(address owner) external view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function ownerOf(uint256 tokenId) external view returns (address owner);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes calldata data
468     ) external;
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId) external view returns (address operator);
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
555 
556 
557 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Enumerable is IERC721 {
567     /**
568      * @dev Returns the total amount of tokens stored by the contract.
569      */
570     function totalSupply() external view returns (uint256);
571 
572     /**
573      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
574      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
575      */
576     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
577 
578     /**
579      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
580      * Use along with {totalSupply} to enumerate all tokens.
581      */
582     function tokenByIndex(uint256 index) external view returns (uint256);
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
595  * @dev See https://eips.ethereum.org/EIPS/eip-721
596  */
597 interface IERC721Metadata is IERC721 {
598     /**
599      * @dev Returns the token collection name.
600      */
601     function name() external view returns (string memory);
602 
603     /**
604      * @dev Returns the token collection symbol.
605      */
606     function symbol() external view returns (string memory);
607 
608     /**
609      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
610      */
611     function tokenURI(uint256 tokenId) external view returns (string memory);
612 }
613 
614 // File: ERC721A.sol
615 
616 
617 // Creator: Chiru Labs
618 
619 pragma solidity ^0.8.0;
620 
621 
622 
623 
624 
625 
626 
627 
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
631  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
632  *
633  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
634  *
635  * Does not support burning tokens to address(0).
636  *
637  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
638  */
639 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
640     using Address for address;
641     using Strings for uint256;
642 
643     struct TokenOwnership {
644         address addr;
645         uint64 startTimestamp;
646     }
647 
648     struct AddressData {
649         uint128 balance;
650         uint128 numberMinted;
651     }
652 
653     uint256 internal currentIndex;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to ownership details
662     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
663     mapping(uint256 => TokenOwnership) internal _ownerships;
664 
665     // Mapping owner address to address data
666     mapping(address => AddressData) private _addressData;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     constructor(string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677     }
678 
679     /**
680      * @dev See {IERC721Enumerable-totalSupply}.
681      */
682     function totalSupply() public view override returns (uint256) {
683         return currentIndex;
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-tokenByIndex}.
688      */
689     function tokenByIndex(uint256 index) public view override returns (uint256) {
690         require(index < totalSupply(), 'ERC721A: global index out of bounds');
691         return index;
692     }
693 
694     /**
695      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
696      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
697      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
698      */
699     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
700         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
701         uint256 numMintedSoFar = totalSupply();
702         uint256 tokenIdsIdx;
703         address currOwnershipAddr;
704 
705         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
706         unchecked {
707             for (uint256 i; i < numMintedSoFar; i++) {
708                 TokenOwnership memory ownership = _ownerships[i];
709                 if (ownership.addr != address(0)) {
710                     currOwnershipAddr = ownership.addr;
711                 }
712                 if (currOwnershipAddr == owner) {
713                     if (tokenIdsIdx == index) {
714                         return i;
715                     }
716                     tokenIdsIdx++;
717                 }
718             }
719         }
720 
721         revert('ERC721A: unable to get token of owner by index');
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             interfaceId == type(IERC721Enumerable).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view override returns (uint256) {
739         require(owner != address(0), 'ERC721A: balance query for the zero address');
740         return uint256(_addressData[owner].balance);
741     }
742 
743     function _numberMinted(address owner) internal view returns (uint256) {
744         require(owner != address(0), 'ERC721A: number minted query for the zero address');
745         return uint256(_addressData[owner].numberMinted);
746     }
747 
748     /**
749      * Gas spent here starts off proportional to the maximum mint batch size.
750      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
751      */
752     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
753         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
754 
755         unchecked {
756             for (uint256 curr = tokenId; curr >= 0; curr--) {
757                 TokenOwnership memory ownership = _ownerships[curr];
758                 if (ownership.addr != address(0)) {
759                     return ownership;
760                 }
761             }
762         }
763 
764         revert('ERC721A: unable to determine the owner of token');
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view override returns (address) {
771         return ownershipOf(tokenId).addr;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
796     }
797 
798     /**
799      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
800      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
801      * by default, can be overriden in child contracts.
802      */
803     function _baseURI() internal view virtual returns (string memory) {
804         return '';
805     }
806 
807     /**
808      * @dev See {IERC721-approve}.
809      */
810     function approve(address to, uint256 tokenId) public override {
811         address owner = ERC721A.ownerOf(tokenId);
812         require(to != owner, 'ERC721A: approval to current owner');
813 
814         require(
815             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
816             'ERC721A: approve caller is not owner nor approved for all'
817         );
818 
819         _approve(to, tokenId, owner);
820     }
821 
822     /**
823      * @dev See {IERC721-getApproved}.
824      */
825     function getApproved(uint256 tokenId) public view override returns (address) {
826         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
827 
828         return _tokenApprovals[tokenId];
829     }
830 
831     /**
832      * @dev See {IERC721-setApprovalForAll}.
833      */
834     function setApprovalForAll(address operator, bool approved) public override {
835         require(operator != _msgSender(), 'ERC721A: approve to caller');
836 
837         _operatorApprovals[_msgSender()][operator] = approved;
838         emit ApprovalForAll(_msgSender(), operator, approved);
839     }
840 
841     /**
842      * @dev See {IERC721-isApprovedForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
845         return _operatorApprovals[owner][operator];
846     }
847 
848     /**
849      * @dev See {IERC721-transferFrom}.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public override {
856         _transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public override {
867         safeTransferFrom(from, to, tokenId, '');
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId,
877         bytes memory _data
878     ) public override {
879         _transfer(from, to, tokenId);
880         require(
881             _checkOnERC721Received(from, to, tokenId, _data),
882             'ERC721A: transfer to non ERC721Receiver implementer'
883         );
884     }
885 
886     /**
887      * @dev Returns whether `tokenId` exists.
888      *
889      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
890      *
891      * Tokens start existing when they are minted (`_mint`),
892      */
893     function _exists(uint256 tokenId) internal view returns (bool) {
894         return tokenId < currentIndex;
895     }
896 
897     function _safeMint(address to, uint256 quantity) internal {
898         _safeMint(to, quantity, '');
899     }
900 
901     /**
902      * @dev Safely mints `quantity` tokens and transfers them to `to`.
903      *
904      * Requirements:
905      *
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
907      * - `quantity` must be greater than 0.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeMint(
912         address to,
913         uint256 quantity,
914         bytes memory _data
915     ) internal {
916         _mint(to, quantity, _data, true);
917     }
918 
919     /**
920      * @dev Mints `quantity` tokens and transfers them to `to`.
921      *
922      * Requirements:
923      *
924      * - `to` cannot be the zero address.
925      * - `quantity` must be greater than 0.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _mint(
930         address to,
931         uint256 quantity,
932         bytes memory _data,
933         bool safe
934     ) internal {
935         uint256 startTokenId = currentIndex;
936         require(to != address(0), 'ERC721A: mint to the zero address');
937         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
938 
939         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
940 
941         // Overflows are incredibly unrealistic.
942         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
943         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
944         unchecked {
945             _addressData[to].balance += uint128(quantity);
946             _addressData[to].numberMinted += uint128(quantity);
947 
948             _ownerships[startTokenId].addr = to;
949             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
950 
951             uint256 updatedIndex = startTokenId;
952 
953             for (uint256 i; i < quantity; i++) {
954                 emit Transfer(address(0), to, updatedIndex);
955                 if (safe) {
956                     require(
957                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
958                         'ERC721A: transfer to non ERC721Receiver implementer'
959                     );
960                 }
961 
962                 updatedIndex++;
963             }
964 
965             currentIndex = updatedIndex;
966         }
967 
968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
969     }
970 
971     /**
972      * @dev Transfers `tokenId` from `from` to `to`.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) private {
986         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
987 
988         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
989             getApproved(tokenId) == _msgSender() ||
990             isApprovedForAll(prevOwnership.addr, _msgSender()));
991 
992         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
993 
994         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
995         require(to != address(0), 'ERC721A: transfer to the zero address');
996 
997         _beforeTokenTransfers(from, to, tokenId, 1);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId, prevOwnership.addr);
1001 
1002         // Underflow of the sender's balance is impossible because we check for
1003         // ownership above and the recipient's balance can't realistically overflow.
1004         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1005         unchecked {
1006             _addressData[from].balance -= 1;
1007             _addressData[to].balance += 1;
1008 
1009             _ownerships[tokenId].addr = to;
1010             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1011 
1012             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1013             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1014             uint256 nextTokenId = tokenId + 1;
1015             if (_ownerships[nextTokenId].addr == address(0)) {
1016                 if (_exists(nextTokenId)) {
1017                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1018                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1019                 }
1020             }
1021         }
1022 
1023         emit Transfer(from, to, tokenId);
1024         _afterTokenTransfers(from, to, tokenId, 1);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(
1033         address to,
1034         uint256 tokenId,
1035         address owner
1036     ) private {
1037         _tokenApprovals[tokenId] = to;
1038         emit Approval(owner, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1043      * The call is not executed if the target address is not a contract.
1044      *
1045      * @param from address representing the previous owner of the given token ID
1046      * @param to target address that will receive the tokens
1047      * @param tokenId uint256 ID of the token to be transferred
1048      * @param _data bytes optional data to send along with the call
1049      * @return bool whether the call correctly returned the expected magic value
1050      */
1051     function _checkOnERC721Received(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) private returns (bool) {
1057         if (to.isContract()) {
1058             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1059                 return retval == IERC721Receiver(to).onERC721Received.selector;
1060             } catch (bytes memory reason) {
1061                 if (reason.length == 0) {
1062                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1063                 } else {
1064                     assembly {
1065                         revert(add(32, reason), mload(reason))
1066                     }
1067                 }
1068             }
1069         } else {
1070             return true;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      */
1086     function _beforeTokenTransfers(
1087         address from,
1088         address to,
1089         uint256 startTokenId,
1090         uint256 quantity
1091     ) internal virtual {}
1092 
1093     /**
1094      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1095      * minting.
1096      *
1097      * startTokenId - the first token id to be transferred
1098      * quantity - the amount to be transferred
1099      *
1100      * Calling conditions:
1101      *
1102      * - when `from` and `to` are both non-zero.
1103      * - `from` and `to` are never both zero.
1104      */
1105     function _afterTokenTransfers(
1106         address from,
1107         address to,
1108         uint256 startTokenId,
1109         uint256 quantity
1110     ) internal virtual {}
1111 }
1112 // File: MutantAIYachtClub.sol
1113 
1114 
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 /**
1119  * @dev Contract module which allows children to implement an emergency stop
1120  * mechanism that can be triggered by an authorized account.
1121  *
1122  * This module is used through inheritance. It will make available the
1123  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1124  * the functions of your contract. Note that they will not be pausable by
1125  * simply including this module, only once the modifiers are put in place.
1126  */
1127 abstract contract Pausable is Context {
1128     /**
1129      * @dev Emitted when the pause is triggered by `account`.
1130      */
1131     event Paused(address account);
1132 
1133     /**
1134      * @dev Emitted when the pause is lifted by `account`.
1135      */
1136     event Unpaused(address account);
1137 
1138     bool private _paused;
1139 
1140     /**
1141      * @dev Initializes the contract in unpaused state.
1142      */
1143     constructor() {
1144         _paused = false;
1145     }
1146 
1147     /**
1148      * @dev Returns true if the contract is paused, and false otherwise.
1149      */
1150     function paused() public view virtual returns (bool) {
1151         return _paused;
1152     }
1153 
1154     /**
1155      * @dev Modifier to make a function callable only when the contract is not paused.
1156      *
1157      * Requirements:
1158      *
1159      * - The contract must not be paused.
1160      */
1161     modifier whenNotPaused() {
1162         require(!paused(), "Pausable: paused");
1163         _;
1164     }
1165 
1166     /**
1167      * @dev Modifier to make a function callable only when the contract is paused.
1168      *
1169      * Requirements:
1170      *
1171      * - The contract must be paused.
1172      */
1173     modifier whenPaused() {
1174         require(paused(), "Pausable: not paused");
1175         _;
1176     }
1177 
1178     /**
1179      * @dev Triggers stopped state.
1180      *
1181      * Requirements:
1182      *
1183      * - The contract must not be paused.
1184      */
1185     function _pause() internal virtual whenNotPaused {
1186         _paused = true;
1187         emit Paused(_msgSender());
1188     }
1189 
1190     /**
1191      * @dev Returns to normal state.
1192      *
1193      * Requirements:
1194      *
1195      * - The contract must be paused.
1196      */
1197     function _unpause() internal virtual whenPaused {
1198         _paused = false;
1199         emit Unpaused(_msgSender());
1200     }
1201 }
1202 
1203 // Ownable.sol
1204 
1205 pragma solidity ^0.8.0;
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(
1223         address indexed previousOwner,
1224         address indexed newOwner
1225     );
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _setOwner(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _setOwner(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(
1266             newOwner != address(0),
1267             "Ownable: new owner is the zero address"
1268         );
1269         _setOwner(newOwner);
1270     }
1271 
1272     function _setOwner(address newOwner) private {
1273         address oldOwner = _owner;
1274         _owner = newOwner;
1275         emit OwnershipTransferred(oldOwner, newOwner);
1276     }
1277 }
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 /**
1282  * @dev Contract module that helps prevent reentrant calls to a function.
1283  *
1284  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1285  * available, which can be applied to functions to make sure there are no nested
1286  * (reentrant) calls to them.
1287  *
1288  * Note that because there is a single `nonReentrant` guard, functions marked as
1289  * `nonReentrant` may not call one another. This can be worked around by making
1290  * those functions `private`, and then adding `external` `nonReentrant` entry
1291  * points to them.
1292  *
1293  * TIP: If you would like to learn more about reentrancy and alternative ways
1294  * to protect against it, check out our blog post
1295  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1296  */
1297 abstract contract ReentrancyGuard {
1298     // Booleans are more expensive than uint256 or any type that takes up a full
1299     // word because each write operation emits an extra SLOAD to first read the
1300     // slot's contents, replace the bits taken up by the boolean, and then write
1301     // back. This is the compiler's defense against contract upgrades and
1302     // pointer aliasing, and it cannot be disabled.
1303 
1304     // The values being non-zero value makes deployment a bit more expensive,
1305     // but in exchange the refund on every call to nonReentrant will be lower in
1306     // amount. Since refunds are capped to a percentage of the total
1307     // transaction's gas, it is best to keep them low in cases like this one, to
1308     // increase the likelihood of the full refund coming into effect.
1309     uint256 private constant _NOT_ENTERED = 1;
1310     uint256 private constant _ENTERED = 2;
1311 
1312     uint256 private _status;
1313 
1314     constructor() {
1315         _status = _NOT_ENTERED;
1316     }
1317 
1318     /**
1319      * @dev Prevents a contract from calling itself, directly or indirectly.
1320      * Calling a `nonReentrant` function from another `nonReentrant`
1321      * function is not supported. It is possible to prevent this from happening
1322      * by making the `nonReentrant` function external, and make it call a
1323      * `private` function that does the actual work.
1324      */
1325     modifier nonReentrant() {
1326         // On the first call to nonReentrant, _notEntered will be true
1327         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1328 
1329         // Any calls to nonReentrant after this point will fail
1330         _status = _ENTERED;
1331 
1332         _;
1333 
1334         // By storing the original value once again, a refund is triggered (see
1335         // https://eips.ethereum.org/EIPS/eip-2200)
1336         _status = _NOT_ENTERED;
1337     }
1338 }
1339 
1340 //newerc.sol
1341 pragma solidity ^0.8.0;
1342 
1343 
1344 contract MiniMenClub is ERC721A, Ownable, Pausable, ReentrancyGuard {
1345     using Strings for uint256;
1346     string public baseURI;
1347     uint256 public cost = 0.01 ether;
1348     uint256 public maxSupply = 3333;
1349     uint256 public maxFree = 3333;
1350     uint256 public maxperAddressFreeLimit = 1;
1351     uint256 public maxperAddressPublicMint = 10;
1352     bool public IS_SALE_ACTIVE = false;
1353 
1354     mapping(address => uint256) public addressFreeMintedBalance;
1355 
1356     constructor() ERC721A("Mini Men Club", "MMC") {
1357         setBaseURI("");
1358 
1359     }
1360 
1361     function _baseURI() internal view virtual override returns (string memory) {
1362         return baseURI;
1363     }
1364 
1365     function MintAllowlist(uint256 _mintAmount) public payable nonReentrant{
1366 		uint256 s = totalSupply();
1367         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1368         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "max NFT per address exceeded");
1369 		require(_mintAmount > 0, "Cant mint 0" );
1370 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1371         require(IS_SALE_ACTIVE, "Mint not active");
1372 		for (uint256 i = 0; i < _mintAmount; ++i) {
1373             addressFreeMintedBalance[msg.sender]++;
1374 
1375 		}
1376         _safeMint(msg.sender, _mintAmount);
1377 		delete s;
1378         delete addressFreeMintedCount;
1379 	}
1380 
1381     function setIsSaleActive(bool isActive) external virtual onlyOwner {
1382         IS_SALE_ACTIVE = isActive;
1383     }
1384 
1385 
1386     function mintPublic(uint256 _mintAmount) public payable nonReentrant {
1387         uint256 s = totalSupply();
1388         require(_mintAmount > 0, "Cant mint 0");
1389         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more then maxmint" );
1390         require(s + _mintAmount <= maxSupply, "Cant go over supply");
1391         require(msg.value >= cost * _mintAmount);
1392         require(IS_SALE_ACTIVE, "Mint not active");
1393         _safeMint(msg.sender, _mintAmount);
1394         delete s;
1395     }
1396 
1397     function gift(uint256[] calldata quantity, address[] calldata recipient)
1398         external
1399         onlyOwner
1400     {
1401         require(
1402             quantity.length == recipient.length,
1403             "Provide quantities and recipients"
1404         );
1405         uint256 totalQuantity = 0;
1406         uint256 s = totalSupply();
1407         for (uint256 i = 0; i < quantity.length; ++i) {
1408             totalQuantity += quantity[i];
1409         }
1410         require(s + totalQuantity <= maxSupply, "Too many");
1411         delete totalQuantity;
1412         for (uint256 i = 0; i < recipient.length; ++i) {
1413             _safeMint(recipient[i], quantity[i]);
1414         }
1415         delete s;
1416     }
1417 
1418     function tokenURI(uint256 tokenId)
1419         public
1420         view
1421         virtual
1422         override
1423         returns (string memory)
1424     {
1425         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1426         string memory currentBaseURI = _baseURI();
1427         return
1428             bytes(currentBaseURI).length > 0
1429                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1430                 : "";
1431     }
1432 
1433 
1434 
1435     function setCost(uint256 _newCost) public onlyOwner {
1436         cost = _newCost;
1437     }
1438 
1439     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1440         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1441         maxSupply = _newMaxSupply;
1442     }
1443      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1444                maxFree = _newMaxFreeSupply;
1445     }
1446 
1447     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1448         baseURI = _newBaseURI;
1449     }
1450 
1451     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1452         maxperAddressPublicMint = _amount;
1453     }
1454 
1455     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1456         maxperAddressFreeLimit = _amount;
1457     }
1458     function withdraw() public payable onlyOwner {
1459         (bool success, ) = payable(msg.sender).call{
1460             value: address(this).balance
1461         }("");
1462         require(success);
1463     }
1464 
1465     function withdrawAny(uint256 _amount) public payable onlyOwner {
1466         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1467         require(success);
1468     }
1469 }